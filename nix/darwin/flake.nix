{
  description = "Zennn.mind system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
          pkgs.tmux
          pkgs.corepack_latest
          pkgs.alacritty
          pkgs.appflowy
          pkgs.hugo
          pkgs.zoxide
        ];

      homebrew = {
        enable = true;

        brews = [
          "mas"
          "nginx"
          "fzf"
          "rbenv"
          "node"
        ];

        casks = [
          "hammerspoon"
          "notion"
          "loop"
          "the-unarchiver"
          "obsidian"
          "android-platform-tools"
          "swimat"
        ];

        masApps = {
          Xcode = 497799835;
        };

        onActivation.cleanup = "zap";
      };

      fonts.packages = 
        [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."m1max16" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # apple silicon
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "buiduong";

            autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."m1max16".pkgs;
  };
}
