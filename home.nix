{ pkgs, ... } @ inputs: let
  listImport = path: modules: (map (module: import (./. + "/${path}/${module}") inputs) modules);
  attrImport = path: modules: pkgs.lib.genAttrs modules (module: import (./. + "/${path}/${module}") inputs);
in {
  home = {
    username = "josephd";
    homeDirectory = "/home/josephd";
    stateVersion = "23.05";
    packages = with pkgs; [
      nitch lsd # CLI tools
      buildkit docker-compose # Docker
    ];
    file = attrImport "config" [ "zellij" ];
  };

  programs = attrImport "programs" [ "git" "neovim" "starship" "zellij" "zsh" ];

  systemd.user.services.spotifyd.Unit.After = [ "sops-nix.service" ];

  sops = import ./keys;
}
