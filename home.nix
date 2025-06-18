{ inputs, ... }: 

let
  username = builtins.getEnv "USER";
  homedir = builtins.getEnv "HOME";

  # gitUsername = builtins.getEnv "GIT_USERNAME"; 
  # gitEmail = builtins.getEnv "GIT_EMAIL";
in
{
  home = {
    # homeDirectory = ""
    username = username; 
  };
}

