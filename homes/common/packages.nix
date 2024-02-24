{
 pkgs, inputs, ...}: {

  imports = [ inputs.hyprland.homeManagerModules.default ];

  home.packages = with pkgs; [
    brightnessctl
    easyeffects
    fastfetch
    firefox-devedition
    gparted
    hyfetch
    krita
    libsForQt5.ark
    mumble
    networkmanagerapplet
    obs-studio
    pamixer
    (pkgs.makeDesktopItem {
       name = "beeper";
       exec = "beeper";
       desktopName = "Beeper";
    })
    (pkgs.writeShellApplication {
       name = "beeper";
       text = "${pkgs.beeper}/bin/beeper --ozone-platform=wayland";
    })
    prismlauncher
    prusa-slicer
    rnote
    scrcpy
    signal-desktop
    steam
    stellarium
    tetrio-desktop
    timidity
    transmission-qt
    vesktop
    vlc
    vscodium
    wdisplays
    wl-clipboard
    wofi
    libreoffice
    nwg-launchers
    blender
    amberol
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
