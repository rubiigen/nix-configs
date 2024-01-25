{pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
    pamixer
    vesktop
    vlc
    wget
    alacritty
    beeper
    brightnessctl
    firefox-devedition
    hyfetch
    fastfetch
    mumble
    networkmanagerapplet
    prismlauncher
    waybar
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
