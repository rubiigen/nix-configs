{self, ...}: let
  # get inputs from self
  inherit (self) inputs;
  # get necessary inputs from self.inputs
  inherit (inputs) nixpkgs lanzaboote nixos-hardware;
  inherit (inputs.home-manager.nixosModules) home-manager;  
  # get lib from nixpkgs and create and alias  for lib.nixosSystem
  # for potential future overrides & abstractions
  inherit (nixpkgs) lib;
  mkSystem = lib.nixosSystem;

  homeJupiter = ../homes/Jupiter;
  homeMillwright = ../homes/Millwright;
  homeVenus = ../homes/Venus;
  homeAlyssum = ../homes/Alyssum;
  homeNomad = ../homes/Nomad;

  # define a sharedArgs variable that we can simply inherit
  # across all hosts to avoid traversing the file whenever
  # we need to add a common specialArg
  # if a host needs a specific arg that others do not need
  # then we can merge into the old attribute set as such:
  # specialArgs = commonArgs // { newArg = "value"; };

  commonArgs = {inherit self inputs;};
in {
  "Millwright" = mkSystem {
    specialArgs = commonArgs;
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Millwright/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeMillwright
      lanzaboote.nixosModules.lanzaboote
    ];
  };

  "Jupiter" = mkSystem {
     specialArgs = commonArgs;
     modules = [
       ./Jupiter/configuration.nix
       home-manager
       homeJupiter
     ];
  };

  "Nomad" = mkSystem {
    specialArgs = commonArgs;
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Nomad/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeNomad
      lanzaboote.nixosModules.lanzaboote
    ];
  };

  "Venus" = mkSystem {
    specialArgs = commonArgs;
    modules = [
      nixos-hardware.nixosModules.microsoft-surface-common
      lanzaboote.nixosModules.lanzaboote
      ./Venus/configuration.nix
      home-manager
      homeVenus
    ];
  };

  "Alyssum" = mkSystem {
    specialArgs = commonArgs;
    modules = [
      ./Alyssum/configuration.nix
      home-manager
      homeAlyssum
    ];
  };
}
