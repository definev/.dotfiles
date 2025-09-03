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
          pkgs.zig
          pkgs.tmux
          # pkgs.nerdfonts
          pkgs.corepack_latest
          pkgs.hugo
          pkgs.zoxide
          pkgs.iterm2
          pkgs.docker
          pkgs.ripgrep
          # pkgs.obsidian
          # pkgs.scrcpy
          pkgs.git-lfs
          # pkgs.skhd
          # pkgs.yabai
        ];

      homebrew = 
        { enable = true;

          taps = [
            "leoafarias/fvm"
            "codecrafters-io/tap"
            "koekeishiya/formulae"
          ];

          brews = [
            "swiftformat"
            "xcode-build-server"
            "xcbeautify"
            "psql"
            "scrcpy"
            "xcodegen"
            "create-dmg"
            "deno"
            "go"
            "fvm"
            "mas"
            "nginx"
            "fzf"
            "rbenv"
            "node"
            "docker-completion"
            "flyctl"
            "llama.cpp"
            "ffmpeg"
            "zls"
            "codecrafters-io/tap/codecrafters"
            "cmake"
            "redis"
            "ccls"
            "opus"
            "libogg"
            "supabase/tap/supabase"
            "yabai"
            "skhd"
            "pandoc"
          ];

          casks = [
            "notion"
            "ghostty"
            "the-unarchiver"
            "obsidian"
            "android-platform-tools"
            "swimat"
          ];

          masApps = {
            Xcode = 497799835;
          };
        };

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ]; 

      system.primaryUser = "daiduong";

      system.defaults = {
        dock.autohide = true;
        dock.orientation = "bottom";
        dock.persistent-others = [
          "/Users/daiduong/Downloads"
          "/Users/daiduong/Desktop"
        ];
        dock.show-recents = false;
        dock.wvous-bl-corner = 1;
        dock.wvous-br-corner = 1;
        dock.wvous-tl-corner = 1;
        dock.wvous-tr-corner = 1;

        dock.persistent-apps = [
          "/System/Applications/Mail.app"
          "/Applications/Google Chrome.app"
          "/Applications/Visual Studio Code.app"
          "${pkgs.iterm2}/Applications/iTerm2.app"
          "/Applications/Obsidian.app"
          "/Applications/Zalo.app"
          "/Applications/Ghostty.app"
        ];

        finder.FXPreferredViewStyle = "clmv";
        finder.QuitMenuItem = true;
        finder.AppleShowAllFiles = true;
      };

      # Auto upgrade nix package and the daemon service.
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
    # $ darwin-rebuild build --flake .#Buis-MacBook-Pro
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
