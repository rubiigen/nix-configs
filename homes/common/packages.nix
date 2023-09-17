{pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
    scrcpy
    kitty
    wofi
    tetrio-desktop
    hyprpaper
    networkmanagerapplet
    swaylock
    grim
    slurp
    vmware-workstation
    prismlauncher
    brightnessctl
    jetbrains.pycharm-professional
    hyfetch
    timidity
    wl-clipboard
    wev
    tidal-hifi
    transmission
    spotify
    vscodium
    chromium
    fluffychat
    firefox-devedition
    stellarium
  ];
}
