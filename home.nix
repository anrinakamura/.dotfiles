# Home-manager configuration

{
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs = {
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
  home.homeDirectory = builtins.getEnv "HOME";
  home.username = builtins.getEnv "USER";

  home.packages = with pkgs; [
    neofetch
    git
    gh
    neovim
    tmux
    starship
  ];

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "anrinakamura";
      user.email = "89412831+anrinakamura@users.noreply.github.com";
      init.defaultbranch = "main";
      core.editor = "vim";
    };
  };

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
    mouse = true;
    extraConfig = ''
      set -g status-right '#(whoami)@#h '

      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"
    '';
  };

  programs.starship = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
