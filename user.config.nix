args@{ pkgs, ... }:
let 
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    username = "blinfoldking";
    initialPassword = "root";
    hostname = "erdtree";
    wallpaper = "/etc/nixos/wallpaper.jpg";
    applications = with pkgs; [
        # install your application here
        brave
        discord
        vlc
        slack
        nuclear
    ];
in
{
    imports = [
        (import "${home-manager}/nixos")
        (import ./term/erdtree.nix (
            args 
                // { username = username; }
            )
        )
        (import ./qtile/erdtree.nix (
            args 
                // { username = username; }
            )
        )
    ];

    networking.hostName = hostname; # Define your hostname.
    
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${username} = {
        isNormalUser = true;
        initialPassword = initialPassword;
        extraGroups = [ 
            "wheel" # Enable ‘sudo’ for the user.
            "docker"
            "audio"
            "networkmanager"
        ]; 
        shell = pkgs.xonsh;
    };

    # Set your time zone.
    time.timeZone = "Asia/Jakarta";

    # pick your display manager 
    services.xserver.windowManager.placidusax.wallpaper = wallpaper;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.displayManager.lightdm.greeters.mini = {
        enable = true;
        user = username;
        extraConfig = ''
            [greeter]
            show-password-label = true
            show-sys-info = true
            [greeter-theme]
            font = "Caskaydia Cove Nerd Font"
            window-color = "#1a1b26"
            text-color = "#a9b1d6"
            background-image = "${wallpaper}" 
        '';
    };

    nixpkgs.config.allowUnfree = true;
    # pick your applications
    environment.systemPackages = applications;
}
