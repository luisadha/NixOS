{ pkgs, ... }:
{ programs.git = {

  enable = true;
  userName = "fmway"; # change to your username
  userEmail = "fm18lv@gmail.com"; # change to your email

  # delta.enable = true; # enable git diff with delta
  # difftastic.enable = true; # git diff with difftastic
  # diff-so-fancy.enable = true; # git diff with diff-so-fancy
  aliases = {
    a = "add";
    cm = "commit";
    ch = "checkout";
    s = "status";
  };

}; }
