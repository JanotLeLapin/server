{ pkgs, ... }: {
  description = "Soulseek daemon";
  wantedBy = [ "multi-user.target" ];
  wants = [ "network-online.target" ];

  serviceConfig = {
    ExecStart = "${pkgs.slskd}/bin/slskd";
    Restart = "always";
    User = "sluser";
    WorkingDirectory = "/home/sluser";
  };
}
