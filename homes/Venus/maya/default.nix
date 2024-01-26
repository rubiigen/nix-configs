{
  pkgs,
  outputs,
  lib,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ../../common/packages.nix
    ../../common/programs.nix
    ../../../.gitignore/gitm.nix
  ];

  # TODO: Set your username
  home = {
    username = "maya";
    homeDirectory = "/home/maya";
    file.".config/sway/config".source = ./config;
    file.".config/waybar/config".source = ./waybar;
  };

  wayland.windowManager.sway = {
    extraOptions = [ "--unsupported-gpu" ];
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
		  Requires = [ "graphical-session-pre.target" ];
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
