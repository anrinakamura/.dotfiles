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

  # home.stableVersion = "24.05";
  # home.homeDirectory = buildtins.getEnv "HOME";
  # home.username = builtins.getEnv "USER";

  home.packages = with pkgs; [
    neofetch
    git
    gh
    neovim
    tmux
  ];

  programs.git = {
    enable = false;
    extraConfig = {
      user.name = "anrinakamura";
      user.email = "89412831+anrinakamura@users.noreply.github.com";
      init.defaultbranch = "main";
      core.editor = "vim";
    };
  };

  programs.gh.enable = false;

  programs.neovim = {
    enable = true;
  };

  # ignore lazy-lock.json
  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua".source = ./nvim/lua;

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "xterm-256color";
    extraConfig = ''
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"
    '';
  };

  programs.home-manager.enable = true;
}
