{ pkgs, ... }: {
  enable = true;
  settings = {
    SocksPolicy = [ "accept *:*" ];
    BandWidthRate = "100 MBytes";
  };
  client = {
    enable = true;
    socksListenAddress = {
      addr = "192.168.1.91";
      port = 9050;
    };
  };
}
