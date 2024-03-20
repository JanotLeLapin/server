{ pkgs, ... }: {
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
}
