{
  nixpkgs,
  self,
  outputs,
  ...
}: let
  inputs = self.inputs;

  home-manager = inputs.home-manager.nixosModules.home-manager;
  homes = ../homes;
in {
  Dysnomia = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Dysnomia/configuration.nix

      # use the nixos-module for home-manager
      home-manager
      homes
    ];
  };

  Nebula = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Nebula/configuration.nix

      # use the nixos-module for home-manager
      home-manager
      homes
    ];
  };

  Messier = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Messier/configuration.nix

      # use the nixos-module for home-manager
      home-manager
      homes
    ];
  };

  Pluto = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Pluto/configuration.nix

      # use the nixos-module for home-manager
      home-manager
      homes
    ];
  };
}
