{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver = {
    enable = true;
    layout = "us";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  programs.dconf.enable = true;

  programs.fish.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bluez-alsa
    bluez
    cinnamon.nemo
    dbus
    gnome3.adwaita-icon-theme
    grim
    gtklock
    libsForQt5.kwallet
    libsForQt5.kwalletmanager
    libsForQt5.qt5ct
    lxqt.lxqt-policykit
    mesa
    pavucontrol
    pulseaudio
    slurp
    swaybg
    swayidle
    swaynotificationcenter
    swayosd
    temurin-bin-18
    temurin-jre-bin-8
    udiskie
    wget
    wl-clipboard
    xdg-utils
  ];

  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
  ];

  fonts.fontconfig.defaultFonts = {
    serif = ["Noto Serif" "Source Han Serif"];
    sansSerif = ["Noto Sans" "Source Han Sans"];
  };

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;
  services.dbus.enable = true;
  services.lvm.enable = true;
  services.printing.enable = true;
  services.udisks2.enable = true;

  console.useXkbConfig = true;

  services.greetd = {
    enable = true;
    restart = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = "true";
    TTYHangup = "true";
    TTYVTDisallocate = true;
  };

  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";
  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };

  networking.networkmanager.enable = true;

  boot.supportedFilesystems = ["exfat" "ntfs" "xfs"];
  boot.blacklistedKernelModules = ["nouveau"];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;

  systemd = {
    user.services.polkit-lxqt = {
      description = "polkit-lxqt";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  users.defaultUserShell = pkgs.fish;

  system.stateVersion = "24.05";
}
