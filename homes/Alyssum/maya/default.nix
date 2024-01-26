{
  pkgs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ../../common/packages.nix # home.packages and similar stuff
    ../../common/programs.nix # programs.<programName>.enable
    ../../../.gitignore/gitm.nix
  ];

  home = {
    username = "maya";
    homeDirectory = "/home/maya";
    file.".config/sway/config".source = ./config;
    file.".config/waybar/config".source = ./waybar;
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  # Nicely reload system(d) units when changing configs
  systemd.user.startServices = lib.mkDefault "sd-switch";
  
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
	variant = "mocha";
      };
    };
  };
  
  services.udiskie.enable = true;
  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
