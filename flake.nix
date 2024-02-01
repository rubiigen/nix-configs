{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs (unstable)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # arrpc
    arrpc = {
      url = "github:notashelf/arrpc-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    lanzaboote.url = "github:nix-community/lanzaboote";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
      #"i686-linux"
      #"aarch64-darwin"
      #"x86_64-darwin"
    ];
  in {
    # Entrypoint for NixOS configurations
    nixosConfigurations = import ./hosts {inherit self;};

    # NixOS modules that are meant to be exported by this flake
    nixosModules = import ./modules/shared/nixos;

    # Home-Manager modules that are meant to be exported by this flake
    homeManagerModules = import ./modules/shared/home-manager;

    # packages that are provided by this flake
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );

    # devshells that are provided by this flake
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );
  };
}
