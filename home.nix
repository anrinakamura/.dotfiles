{ inputs, pkgs, ... }:

let
  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";

  # gitUsername = builtins.getEnv "GIT_USERNAME";
  # gitEmail = builtins.getEnv "GIT_EMAIL";
in
{
  home = {
    inherit username homeDirectory;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  home.packages = with pkgs; [
    neofetch
    git
    gh
  ];

  programs.home-manager.enable = true;
}
