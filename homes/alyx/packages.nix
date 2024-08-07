{
 pkgs, inputs, ...}: {

  imports = [ inputs.hyprland.homeManagerModules.default ];

  home.packages = with pkgs; [
    amberol
    blender-hip
    brightnessctl
    cinny-desktop
    clonehero
    distrobox
    easyeffects
    element-desktop
    fastfetch
    firefox-devedition
    gomuks
    gparted
    gzdoom
    hyfetch
    jetbrains.idea-ultimate
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
    transmission_4-qt
    vesktop
    vlc
    vscodium
    wdisplays
    webcord-vencord
    wireguard-tools
    wl-clipboard
    wofi
    xfce.thunar
  ];
}
