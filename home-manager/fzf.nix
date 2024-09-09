{ programs.fzf = {

  enable = true;
  tmux.enableShellIntegration = true;
  fileWidgetCommand = "fd --type f"; # CTRL+T
  changeDirWidgetCommand = "fd --type d"; # ALT+C

  historyWidgetOptions = [
    "--sort"
    "--exact"
  ]; # CTRL+R

}; }
