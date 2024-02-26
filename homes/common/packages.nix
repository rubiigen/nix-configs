{
 pkgs, inputs, ...}: {

  imports = [ inputs.hyprland.homeManagerModules.default ];

  home.packages = with pkgs; [
    amberol
    blender
    brightnessctl
    easyeffects
    element-desktop
    fastfetch
    firefox-devedition
    gomuks
    gparted
    hyfetch
    krita
    libreoffice
    libsForQt5.ark
    mumble
    networkmanagerapplet
    nwg-launchers
    obs-studio
    openrct2
    pamixer
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
<<<<<<< HEAD
    libreoffice
    nwg-launchers
    blender
    amberol
    openrct2
    gomuks
    distrobox
    podman
=======
>>>>>>> fea4cdc (gomuks, bye beeper, hello official element client that isnt a shit fork)
  ];
}
