{ config, lib, pkgs, ... }:

{
  # termux integration
  android-integration = {
    am.enable = true; # termux-am
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
    # unsuported.enable = true;
    xdg-open.enable = true;
  };

  # custom variable
  environment.sessionVariables = {
    TEST = "kuy";
    EDITOR = "vim";
  };

  # default shell
  user.shell = lib.getExe pkgs.fish; # change pkgs.fish with your favorite shell

  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    # vim # or some other editor, e.g. nano or neovim
    neovim
    nano
    # Some common stuff that people expect to have
    procps
    killall
    diffutils
    findutils
    fd # findutils alternative
    utillinux
    #tzdata
    hostname
    man
    gnugrep
    #gnupg
    gnused
    gnutar
    #bzip2
    #gzip
    #xz
    zip
    unzip
  ];

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Asia/Jakarta";

  # TODO set terminal font
  terminal.font = "${pkgs.terminus_font_ttf}/share/fonts/truetype/TerminusTTF.ttf";
}
