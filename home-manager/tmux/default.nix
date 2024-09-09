# terminal multiplexer
{ pkgs, lib, ... }:
{ programs.tmux = {

  enable = true;
  baseIndex = 1;
  clock24 = true;
  extraConfig = lib.fileContents ./tmux.conf;
  customPaneNavigationAndResize = true; # Override the hjkl and HJKL bindings for pane navigation and resizing in VI mode.
  plugins = with pkgs.tmuxPlugins; [
    {
      plugin = catppuccin;
      extraConfig = lib.fileContents ./catppuccin.tmux;
    }
    battery
    logging
    jump
    yank
    copycat
    prefix-highlight
    pain-control
    fzf-tmux-url
  ];

}; }
