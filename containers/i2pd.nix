{ pkgs, ... }: {
  autoStart = true;
  config = { ... }: {
    system.stateVersion = "23.05";
    networking.firewall.allowedTCPPorts = [ 7656 7070 4447 4444 1776 ];
    environment.systemPackages = with pkgs; [ neovim xd ];

    users.groups.xdgroup = {};
    users.users.xduser = {
      isSystemUser = true;
      group = "xdgroup";
    };

    services.i2pd = {
      enable = true;
      address = "0.0.0.0";
      proto = {
        http = {
          enable = true;
          address = "192.168.1.91";
        };
        socksProxy = {
          enable = true;
          address = "192.168.1.91";
        };
        httpProxy = {
          enable = true;
          address = "192.168.1.91";
        };
        sam.enable = true;
      };
    };

    systemd.services.xd = {
      description = "XD BitTorrent client";
      wantedBy = [ "multi-user.target" ];
      wants = [ "i2pd.service" ];

      serviceConfig = {
        ExecStart = "${pkgs.xd}/bin/XD";
        Restart = "always";
        User = "xduser";
        Group = "xdgroup";
        WorkingDirectory = "/home/xduser";
      };
    };
  };
}
