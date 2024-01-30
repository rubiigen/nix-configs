{pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
    pamixer
    vesktop
    vlc
    wget
    beeper
    brightnessctl
    firefox-devedition
    hyfetch
    fastfetch
    mumble
    networkmanagerapplet
    prismlauncher
    rnote
    wofi
    scrcpy
    signal-desktop
    tetrio-desktop
    timidity
    transmission-qt
    stellarium
    vscodium
  ];
}
