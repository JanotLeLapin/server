{ pkgs, ...}: {
  description = "Music streaming server";
  wantedBy = [ "multi-user.target" ];
  wants = [ "network-online.target" ];

  serviceConfig = {
    ExecStart = "${pkgs.nodejs}/bin/node cli-boot-wrapper.js";
    Restart = "always";
    User = "msuser";
    WorkingDirectory = "/home/msuser/mstream";
  };
}
