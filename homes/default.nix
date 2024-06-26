{
  inputs,
  self,
  config,
  lib,
  ...
}: {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs self;
    };
    users = {
      alyx = ./alyx;
      # more users can go here, the format is only for convenience
    };
  };
}
