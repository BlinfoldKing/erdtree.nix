# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let 
unstable = import <nixos> {};
pythonPackages = python-packages: with python-packages; [
    pip
    pip-tools
    bootstrapped-pip
    pipBuildHook
    pipInstallHook
];
customPython3 = pkgs.python39.withPackages pythonPackages;
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./user.config.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "/dev/disk/by-label/BOOT";
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

 # install NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "Terminus"]; })
  ];

  environment.systemPackages = with pkgs; [
    # gui
    firefox
    nitrogen
    pavucontrol
    font-manager
    gparted

    # language
    gcc
    customPython3
    rustup
    go_1_18
    gopls
    
    # dev tools
    git
    cmake
    gnumake
    docker 
    docker-compose
    dolphin

    # terminal desktop environment
    pfetch
    wget
    curl
    kitty
    nnn
    starship 
    home-manager
    os-prober
    nerd-font-patcher
    ngrok
    dunst
    libnotify
    jq
    unar
    unzip
    ripgrep
    eww
    zsh
    rofi
    pulseaudio
    wirelesstools
  ];

  programs.neovim = {
    package = pkgs.neovim-unwrapped; 
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
 
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

