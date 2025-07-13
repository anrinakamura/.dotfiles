{
  description = "dotfiles";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Formatter
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      treefmt-nix,
      neovim-nightly-overlay,
      ...
    }@inputs:
    # Supported systems
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Formatter setting
      treefmtEval = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        treefmt-nix.lib.evalModule pkgs ./treefmt.nix
      );
    in
    {
      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          # `nix run .`
          default = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "default" ''
                	        set -e 
                		uname -a
                	      ''
            );
          };

          # `nix run .#update`
          update = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "update" ''
                                	        set -e 
                                		echo "updating flake..."
                                                nix flake update
                				echo "updating home-manager..."
                				nix run nixpkgs#home-manager -- switch --flake .#default --show-trace --impure
                                		echo "updates successfully completed!"
                                	      ''
            );
          };
        }
      );

      # `nix fmt`
      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      # `nix flake check`
      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });

      # `home-manager switch --flake .#<system> --impure`
      # or `nix run nixpkgs#home-manager -- switch --flake .#<system> --impure`
      homeConfigurations = {
        "linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home.nix ];
        };

        "darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;

          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home.nix ];
        };

      };
    };
}
