{ pkgs, ... }: {
  description = "Minecraft server";
  wantedBy = [ "multi-user.target" ];
  wants = [ "network-online.target" ];

  serviceConfig = {
    ExecStart = "${pkgs.jre8}/bin/java -server -Xmx12000M -Xms12000M -jar Server.jar -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:-UseAdaptiveSizePolicy";
    Restart = "always";
    User = "mcuser";
    WorkingDirectory = "/home/mcuser";
  };
}
