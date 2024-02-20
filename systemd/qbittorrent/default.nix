{ pkgs, ... }: {
  description = "QBittorrent client";
  wantedBy = [ "multi-user.target" ];
  wants = [ "network-online.target" ];

  serviceConfig = {
    ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";
    Restart = "always";
    User = "qbtuser";
    WorkingDirectory = "/home/qbtuser";
  };
}
