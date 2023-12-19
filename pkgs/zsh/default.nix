{ config, ... }:

{
  enable = true;
  shellAliases = {
    # Git
    gst = "git status";
    gd = "git diff";
    glog = "git log";
    ga = "git add";
    gaa = "git add .";
    gcm = "git commit -m";
    gca = "git commit --amend --no-edit";
    gcam = "git commit --amend -m";
    gr = "git restore";
    gra = "git restore .";
    gp = "git push";

    # Nix
    nd = "nix develop -c $SHELL";
    ns = "nix shell";
    nsp = "nix shell";
    nr = "sudo nixos-rebuild switch --impure --flake";

    # SSH
    ssag = "ssh-add /run/secrets/ssh/github";
    ssac = "ssh-add /run/secrets/ssh/github";

    # Other
    l = "lsd -a";
    c = "clear";
    v = "nvim";
    h = "helix";
  };
  history = {
    size = 1000;
    path = "${config.xdg.dataHome}/zsh/history";
  };
  oh-my-zsh = {
    enable = true;
    theme = "bira";
  };
}
