{
  description = "Basic example of Nix-on-Droid system config.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-on-droid, ... } @ inputs: {
    templates.default = {
      path = ./.;
      description = "My configuration nix on android";
    };
    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux"; # change to your system
        allowUnfree = true;
      };
      extraSpecialArgs = {
        inherit inputs;
        inherit (self) outputs;
      };
      modules = [
        ./nix-on-droid.nix
        ./etc
        ({ ... }: {
          environment.etcBackupExtension = ".backup~.${toString self.lastModified}";
          home-manager = {
            backupFileExtension = "backup~.${toString self.lastModified}";
            config = { ... }: {
              imports = [ ./home-manager ];
              nix.registry = {
                nixpkgs.flake = nixpkgs;
                nix-on-droid.flake = nix-on-droid;
                self.flake = self;
              };
            };
            sharedModules = [];
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        })
      ];
    };

  };
}
