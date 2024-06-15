{
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:

let
  hyprConfig = lib.mkMerge [
    (lib.mkIf (osConfig.networking.hostName == "Millwright") (import ./Millwright.nix))
    (lib.mkIf (osConfig.networking.hostName == "Nomad") (import ./Nomad.nix))
    (lib.mkIf (osConfig.networking.hostName == "Jupiter") (import ./Jupiter.nix))
  ];
in

 {
  imports = [
    ../../common/arrpc.nix
    ../../common/packages.nix # home.packages and similar stuff
    ../../common/programs.nix # programs.<programName>.enable
    ../../common/gita.nix
    ../../common/nvim-flake.nix
    ../../common/ags
    ../../common/files.nix
  ];

  home = {
    username = "alyx";
    homeDirectory = "/home/alyx";
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 40;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        variant = "mocha";
      };
    };

    cursorTheme = {
      name = "Catppuccin-Mocha-Mauve-Cursors";
      package = pkgs.catppuccin-cursors.mochaMauve;
      size = 40;
    };
  };
  
  qt.enable = true;
  qt.platformTheme.name = "gtk";

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    settings = hyprConfig;
  };

  services.udiskie.enable = true;

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  # Nicely reload system(d) units when changing configs
  systemd.user.startServices = lib.mkDefault "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
