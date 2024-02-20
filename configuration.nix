{ pkgs, ... } @ inputs:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # ← use the same mount point here.
    };
    grub = {
      enable = true;
      efiSupport = true;
      # efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
      devices = [ "nodev" ];
    };
  };

  # Enable networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # OpenSSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
  programs.ssh.startAgent = true;
  services.gnome.gnome-keyring.enable = true;

  hardware.bluetooth.enable = true;

  # Configure console keymap
  console.keyMap = "fr";

  virtualisation.docker.enable = true;

  # Define a user account
  programs.zsh.enable = true;
  users.users.josephd = {
    isNormalUser = true;
    description = "Joseph DALY";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    bash gcc wget unzip glib ripgrep sops
  ];

  networking.firewall.allowedTCPPorts = [
    7070 4447 4444 7656
    1776
    9050
    8080
    25565
    5030 5031 50300
    3000
  ];

  services = {
    i2pd = import ./systemd/i2pd inputs;
    tor = import ./systemd/tor inputs;
    postgresql.enable = true;
  };

  systemd.services = {
    xd = import ./systemd/xd inputs;
    qbittorrent = import ./systemd/qbittorrent inputs;
    soulseek = import ./systemd/soulseek inputs;
    mstream = import ./systemd/mstream inputs;
    minecraft = import ./systemd/minecraft inputs;
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}
