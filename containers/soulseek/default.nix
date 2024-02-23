{ ... }: {
  autoStart = true;
  config = { pkgs, ... }: let
    slConfig = pkgs.stdenv.mkDerivation {
      name = "slskd-config";
      src = ./slskd.yml;
      buildCommand = ''
        mkdir -p $out
        cp $src $out/slskd.yml
      '';
    };
    
    zelda = pkgs.fetchFromGitHub {
      owner = "JanotLeLapin";
      repo = "zelda";
      rev = "1ce954667979dbccbaceb35111586f02ce028ac8";
      hash = "sha256-ppGmvOJnSAVqpo361sx8NQVxTHs9rq43F2x9K8mSQV0=";
    };

    zeldaWeb = pkgs.buildNpmPackage {
      pname = "zelda-web";
      version = "0.1";
      src = "${zelda}/web";
      npmDepsHash = "sha256-PqcUdLRGt/9ACqiK/VDnAgpFFh5S5qw844apMaW6d+g=";
    };

    zeldaConfig = pkgs.writeText "zelda-config" ''
      music_path = "/home/sluser/.local/share/slskd/downloads"

      [web]
      port = 4000
      host = "192.168.1.91"
      ui_path = "${zeldaWeb}/lib/node_modules/web/build"

      [database]
      port = 5432
      host = "localhost"
      user = "postgres"
      password = "postgres"
    '';

    zeldaServer = pkgs.rustPlatform.buildRustPackage {
      pname = "zelda-server";
      version = "0.1";
      src = zelda;

      cargoLock = { lockFile = "${zelda}/Cargo.lock"; };
    };
  in {
    system.stateVersion = "23.05";
    networking.firewall.allowedTCPPorts = [ 5030 3000 4000 ];
    
    users.groups.slgroup = {};
    users.users.sluser = {
      isSystemUser = true;
      group = "slgroup";
      home = "/home/sluser";
      createHome = true;
    };

    services.postgresql = {
      enable = true;
      initialScript = pkgs.writeText "postgres-initial-script" ''
        alter user postgres with password 'postgres';
        create table albums (
          path varchar(128),
          name varchar(64),
          cover_mime varchar(8),
          cover bytea
          primary key (path)
        );
        create table tracks (
          path varchar(128),
          album varchar(128),
          name varchar(64),
          pos smallint,
          primary key (path)
        );
      '';
    };

    systemd.services.soulseek = {
      description = "Soulseek daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.slskd}/bin/slskd --config ${slConfig}/slskd.yml";
        Restart = "always";
        User = "sluser";
        Group = "slgroup";
      };
    };

    systemd.services.zelda = {
      description = "Zelda streaming service";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" "postgresql.service" ];

      serviceConfig = {
        ExecStart = "${zeldaServer}/bin/zelda --config ${zeldaConfig}";
        Restart = "always";
        User = "sluser";
        Group = "slgroup";
      };
    };
  };
}
