{ pkgs, lib, ... }:
{
  imports = [
    ./fish.nix
    ./starship.nix
    ./git.nix
    ./lazygit.nix
    ./fzf.nix
    ./vim.nix
    ./tmux
  ];

  home.stateVersion = "24.05";

  programs = {
    home-manager.enable = true; 
    bat.enable = true; # cat alternative
    bat.config = {
      pager = "less -FR";
    };

    # ls alternative
    eza.enable = true;
    eza.icons = true; # display icons
    eza.git = true; # git integration

    jq.enable = true;

    zoxide.enable = true; # cd alternative

  };
}
