{
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:

let
  hyprConfig = lib.mkMerge [
    (lib.mkIf (osConfig.networking.hostName == "Alyssum") (import ./Alyssum.nix))
    (lib.mkIf (osConfig.networking.hostName == "Venus") (import ./Venus.nix))
    (lib.mkIf (osConfig.networking.hostName == "Helium") (import ./Helium.nix))
  ];

  touchPlugin = lib.mkMerge [
    (lib.mkIf (osConfig.networking.hostName == "Venus") (inputs.hyprgrass.packages.${pkgs.system}.default))
  ];
in

 {
  imports = [
    ../../common/arrpc.nix
    ../../common/packages.nix # home.packages and similar stuff
    ../../common/programs.nix # programs.<programName>.enable
    ../../common/gitm.nix
    ../../common/nvim-flake.nix
    ../../common/ags
    ../../common/files.nix
  ];

  home = {
    username = "maya";
    homeDirectory = "/home/maya";
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      x11 = {
        enable = true;
        defaultCursor = "Adwaita";
      };
      size = 24;
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
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
      name = "Adwaita";
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
    settings = hyprConfig;
    plugins = [
      touchPlugin
    ];
  };

  services.udiskie.enable = true;

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  # Nicely reload system(d) units when changing configs
  systemd.user.startServices = lib.mkDefault "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
