# NixOS configuration
This is configuration nix in android (nix-on-droid)

## How To Use?
- Install [nix-on-droid](https://f-droid.org/packages/com.termux.nix)
- Open the app, (you also have to enable flake) 
- Remove default configuration
  ```sh
  rm -rf ~/.config/nix-on-droid/*
  ```
- Clone this template to `~/.config/nix-on-droid`
  ```sh
  cd ~/.config/nix-on-droid
  nix flake init --template github:fmway/nixos/nix-on-droid
  ```
- The first think, you should change some configuration:
  * `system` in `flake.nix`
    ```nix
    {
      ...
      pkgs = import nixpkgs {
        system = "x86_64-linux"; # change this (e.g. aarch64-linux)
        ...
      };
      ...
    }
    ```
  * `user.shell` in `nix-on-droid.nix`
    ```nix
    {
      ...
      user.shell = lib.getExe pkgs.fish; # change pkgs.fish to your favorite shell (like bash, zsh, nu, etc)
      ...
    }
    ```
  * `userName` & `userEmail` in `home-manager/git.nix`
    ```nix
    {
      ...
      userName = "fmway"; # change to your username
      userEmail = "fm18lv@gmail.com"; # change to your email
      ...
    }
    ```
  The default editor installed is Vim. If you don't like vim, you can temporarily install your editor with nix shell. For example:
  ```sh
  nix shell nixpkgs#nano
  # or
  nix shell nixpkgs#emacs
  # etc...
  ```
- Build & switch the configuration
  ```sh
  nix-on-droid switch --flake ~/.config/nix-on-droid
  ```
- Enjoy with your nix-on-droid
