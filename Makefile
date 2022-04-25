update-channel:
	@sudo nix-channel --add https://nixos.org/channels/nixos-unstable
	@sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable
	@sudo nix-channel update

# install from another os
install:
	@curl -L https://nixos.org/nix/install | bash
	@. ~/.nix-profile/etc/profile.d/nix.sh
	@nix-channel --add https://nixos.org/channels/nixos-unstable
	@nix-channel --add https://nixos.org/channels/nixpkgs-unstable
	@nix-channel --update
	@nix-channel --list
	@nix-env -f '<nixpkgs>' -iA nixos-install-tools
	@sudo groupadd -g 30000 nixbld
	@sudo useradd -u 30000 -g nixbld -G nixbld nixbld
	@sudo mount /dev/disk/by-label/ERDTREE /mnt
	@sudo nix-install --root /mnt
	@sudo userdel nixbld
	@sudo groupdel nixbld
	@sudo rm -rv ~/.nix-* /nix

rebuild:
	@sudo rm -rf /etc/nixos

	@sudo cp -r ./ /etc/nixos

	@sudo nixos-rebuild switch --upgrade

test:
	@sudo nixos-rebuild test

