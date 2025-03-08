.prony: 

sync:
	cp user.zshrc ~/user.zshrc
	cp .zshrc ~/.zshrc
	cp .yabairc ~/.yabairc
	cp .skhdrc ~/.skhdrc
	cp nix/darwin/* ~/.config/nix/

build_darwin:
	darwin-rebuild switch --flake ~/.dotfiles/nix/darwin#m1max16

start_llama:
	llama-server \
    --hf-repo ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF \
    --hf-file qwen2.5-coder-7b-q8_0.gguf \
    --port 8012 -ngl 99 -fa -ub 1024 -b 1024 -dt 0.1 \
    --ctx-size 0 --cache-reuse 256
