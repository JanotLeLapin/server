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

    systemd.services.soulseek = {
      description = "Soulseek daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.slskd}/bin/slskd --config ${slConfig}/slskd.yml";
        Restart = "always";
        User = "sluser";
        Group = "slgroup";
        WorkingDirectory = "/home/sluser";
      };
    };
  };
}
