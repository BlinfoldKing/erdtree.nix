nix-channel --add https://nixos.org/channels/nix-unstable
nix-channel --add https://nixos.org/channels/nixpkgs-unstable

sudo rm -rf /etc/nixos

sudo cp -r ./ /etc/nixos

sudo nixos-rebuild switch
