{ inputs, pkgs, ... }:

let
  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";

  # gitUsername = builtins.getEnv "GIT_USERNAME";
  # gitEmail = builtins.getEnv "GIT_EMAIL";
in
{
  nixpkgs = {
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
  };

  home = {
    inherit username homeDirectory;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  home.packages = with pkgs; [
    neofetch
    git
    gh
    neovim
  ];

  programs.home-manager.enable = true;
}
