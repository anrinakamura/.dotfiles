{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager"; 
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
  };

  outputs = { 
    self, 
    nixpkgs, 
    home-manager, 
    ... 
  } @ inputs: let 
      # inherit (self) outputs; 

      systems = [
        "x86_64-linux"
	"aarch64-darwin"
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
	    program =  toString (
	      pkgs.writeShellScript "default" ''
	        set -e 
		uname -a
	      '');
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
	      ''); 
	  }; 
	} 
      );

      # `nix fmt`
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style); 

      packages = forAllSystems (
        system: 
	let
	  pkgs = nixpkgs.legacyPackages.${system}; 
	in
	{
	  neofetch = pkgs.neofetch; 
	}
      ); 

      # `home-manager --flake .#username@hostname`
      homeConfigurations = {
        personal = home-manager.lib.homeManagerConfiguration {
	  pkgs = nixpkgs.legacyPackages.x86_64-linux; 
	  extraSpecialArgs = {inherit inputs outputs;}; 
	  modules = [
	    ./home.nix
	  ];
	};
      };

    }; 
}

