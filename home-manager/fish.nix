{ programs.fish = {
  enable = true;
  shellAbbrs = {
    nos = "nix-on-droid switch --verbose --flake ~/.config/nix-on-droid";
    nob = "nix-on-droid build --verbose --flake ~/.config/nix-on-droid";
    nor = "nix-on-droid rollback --verbose --flake ~/.config/nix-on-droid";
  };
  interactiveShellInit = ''
    set fish_greeting # Disable greeting
    printf '\e[5 q'
  '';
}; }
