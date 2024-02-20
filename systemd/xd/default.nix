{ pkgs, ... }: {
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
}
