{ config, lib, pkgs, ... }:

{
  imports = [
    ./phosh.nix
    ../common-configuration.nix
  ];

  config = {
    users.users.alyx = {
      isNormalUser = true;
      extraGroups = [
        "dialout"
        "feedbackd"
        "networkmanager"
        "video"
        "wheel"
      ];
    };

    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
    
    services.xserver.desktopManager.phosh = {
      user = alyx;
    };
  };
}
