{
  pkgs,
  outputs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../common/arrpc.nix
    ../../common/packages.nix
    ../../common/programs.nix
    ../../common/gitm.nix
    ../../common/nvim-flake.nix
    ../../common/ags
  ];

  home = {
    username = "maya";
    homeDirectory = "/home/maya";
    file.".config/foot/foot.ini".source = ../../common/foot.ini;
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
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = import ./hyprland.nix;
    plugins = [
      inputs.hyprgrass.packages.${pkgs.system}.default
    ];
  };

  programs.waybar = {
    enable = true;
    settings = import ../../common/waybar.nix;
    style = import ../../common/waybar-style.nix;
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  services.udiskie.enable = true;

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  # Nicely reload system(d) units when changing configs
  systemd.user.startServices = lib.mkDefault "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
