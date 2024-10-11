.prony: 

sync:
	cp user.zshrc ~/user.zshrc
	cp .zshrc ~/.zshrc
	cp nix/darwin/* ~/.config/nix/

build_darwin:
	darwin-rebuild switch --flake ~/.config/nix#m1max16
