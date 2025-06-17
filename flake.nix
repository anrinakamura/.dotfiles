{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = 
    { self, nixpkgs, ... }: 
    let 
      systems = [
        "x86_64-linux"
	# "aarch64-darwin"
      ]; 
      forAllSystems = nixpkgs.lib.genAttrs systems; 
    in
    {
      apps = forAllSystems(
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

      packages = forAllSystems (
        system: 
	let
	  pkgs = nixpkgs.legacyPackages.${system}; 
	in
	{
	  neofetch = pkgs.neofetch; 

	  # `nix fmt`
	  formatter = pkgs.nixfmt-rfc-style; 

	}
      ); 

    }; 
}

