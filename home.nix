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
  };

  home.packages = with pkgs; [
    neofetch
  ];

  programs.home-manager.enable = true;
}
