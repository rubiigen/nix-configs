{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      #"aarch64-linux"
      #"i686-linux"
      "x86_64-linux"
      #"aarch64-darwin"
      #"x86_64-darwin"
      # uncomment system types as they are added to the list of hosts
    ];
  in rec {
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );
    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/shared/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/shared/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = let
      home-manager = inputs.home-manager.nixosModules.home-manager; # get home-manager module from the flake

      homes = ./home-manager; # shared homes module
      nixos = ./modules/nixos; # shared nixos module
      sharedModules = [homes nixos home-manager]; # a list that contains modules to be shared
    in {
      # FIXME replace with your hostname
      Messier = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules =
          [
            # > Our main nixos configuration file <
            ./nixos/hosts/messier # this imports the entirety of messier's configs
            ./modules/nixos # this imports the shared nixos module that lets you re-use settings between hosts
          ]
          ++ sharedModules;
      };

      # this is another sample host
      Andromeda = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules =
          [
            # > Our main nixos configuration file <
            ./nixos/hosts/Andromeda # this imports the entirety of host2's configs
            ./modules/nixos
          ]
          ++ sharedModules;
      };

      Dysnomia = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules =
          [
            # > Our main nixos configuration file <
            ./nixos/hosts/Dysnomia # this imports the entirety of host2's configs
            ./modules/nixos
          ]
          ++ sharedModules;
      };

    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "rion@Messier" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main home-manager configuration file <
          ./home-manager/homes/rion
        ];
      };
    };
  };
}
