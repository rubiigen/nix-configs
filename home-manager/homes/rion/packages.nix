{pkgs, ...}: {
  home.packages = with pkgs; [
    kitty
    wofi
    tetrio-desktop
    hyprpaper
    networkmanagerapplet
    swaylock
    grim
    slurp
    vmware-workstation
    libsForQt5.dolphin
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
  ];
}
