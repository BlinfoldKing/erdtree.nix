update-channel:
	@sudo nix-channel --add https://nixos.org/channels/nixos-unstable
	@sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable
	@sudo nix-channel --update

rebuild:
	@make reconfig
	@sudo nixos-rebuild switch --upgrade

test:
	@make reconfig
	@sudo nixos-rebuild test

reconfig:	
	@sudo rm -rf /etc/nixos
	@sudo cp -r ./ /etc/nixos

update-qtile:
	@make reconfig
	@qtile cmd-obj -o cmd -f restart
	@eww -c /etc/nixos/qtile/eww kill
	@eww -c /etc/nixos/qtile/eww daemon
	@eww -c /etc/nixos/qtile/eww open bar

iso:
	@make reconfig
	@nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
