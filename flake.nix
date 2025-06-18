{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        # "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
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
                		echo "updates successfully completed!"
                	      ''
            );
          };
        }
      );

      # `nix fmt`
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # `USER="xxx" HOME="xxx" home-manager switch --flake .#default --impure`
      #  or `nix run nixpkgs#home-manager -- switch --flake .#default --impure`
      homeConfigurations =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        {
          default = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs;
              pkgs = pkgs;
            };
            modules = [ ./home.nix ];
          };
        };

    };
}
