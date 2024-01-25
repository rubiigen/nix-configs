{
  nixpkgs,
  self,
  outputs,
  nixos-hardware,
  lanzaboote,
  ...
}: let
  inputs = self.inputs;

  home-manager = inputs.home-manager.nixosModules.home-manager;
  homeHyperion = ../homes/Hyperion;
  homeMillwright = ../homes/Millwright;
  homeVenus = ../homes/Venus;
  homeAlyssum = ../homes/Alyssum;

in {
  Millwright = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Millwright/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeMillwright
      lanzaboote.nixosModules.lanzaboote
    ];
  };

  Hyperion = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Hyperion/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeHyperion
      lanzaboote.nixosModules.lanzaboote
    ];
  };

  Venus = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      nixos-hardware.nixosModules.microsoft.surface-common
      lanzaboote.nixosModules.lanzaboote
      ./Venus/configuration.nix
      home-manager
      homeVenus
    ];
  };

  Alyssum = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      ./Alyssum/configuration.nix
      home-manager
      homeAlyssum
    ];
  };
}
