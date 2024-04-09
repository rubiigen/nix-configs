{
 pkgs, inputs, ...}: {

  imports = [ inputs.hyprland.homeManagerModules.default ];

  home.packages = with pkgs; [
    amberol
    blender
    brightnessctl
    cinny-desktop
    distrobox
    easyeffects
    element-desktop
    fastfetch
    firefox-devedition
    gomuks
    gparted
    gzdoom
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
    podman
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
    wireguard-tools
    wl-clipboard
    wofi
  ];
}
