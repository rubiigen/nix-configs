{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
};

 {
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vulkan-validation-layers
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      ];
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "i915" ];
    layout = "us";
    libinput = {
        enable = true;
	mouse.accelProfile = "flat";
    };
  };
  
  environment.pathsToLink = [ "/libexec" ];

  nixpkgs = {
    config = {
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
    overlays = [
      (self: super: {
        vlc = super.vlc.override {
	  libbluray = super.libbluray.override {
	    withAACS = true;
	    withBDplus = true;
	  };
	};
      })
    ];
  };
  

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    fish.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };	
  };

  environment.systemPackages = with pkgs; [
    bluez-alsa
    bluez
    cinnamon.nemo
    dbus
    ddcutil
    gnome3.adwaita-icon-theme
    grim
    gtklock
    i2c-tools
    libsForQt5.qt5ct
    mesa
    pavucontrol
    (pkgs.python3.withPackages(ps: with ps; [ tkinter]))
    polkit-gnome
    pulseaudio
    slurp
    swaybg
    swayidle
    swaynotificationcenter
    swayosd
    temurin-bin-18
    temurin-jre-bin-8
    udiskie
    virt-manager
    wget
    wl-clipboard
    xdg-utils
  ];
  
  environment.sessionVariables = {
    XCURSOR_SIZE = "24";
  };

  fonts.packages = with pkgs; [
	font-awesome
	jetbrains-mono
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        source-han-sans
        source-han-sans-japanese
        source-han-serif-japanese
  ];
  fonts.fontconfig.defaultFonts = {
    serif = [ "Noto Serif" "Source Han Serif" ];
    sansSerif = [ "Noto Sans" "Source Han Sans" ];
  };

  # bluetooth
  hardware.bluetooth.enable = true;

  # services
  services.blueman.enable = true;
  services.dbus.enable = true;
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
  };
  services.lvm.enable = true;
  services.printing.enable = true;
  services.udisks2.enable = true;

  # greetd
  services.greetd = {
    enable = true;
      settings = {
        default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
	sessions = "--sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions";
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
    TTYVTDisallocate = "true";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  }; 

  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

  console.useXkbConfig = true;

  networking.hostName = "Alyssum";

  virtualisation.libvirtd = {
	enable = true;
        extraConfig = ''
          user="maya"
        '';
	qemu.ovmf.enable = true;
        qemu.package = pkgs.qemu_kvm;
	qemu.runAsRoot = true;  
  };

  virtualisation.spiceUSBRedirection.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.supportedFilesystems = [ "exfat" "xfs" "ntfs" ];
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" "pcie_acs_override=downstream,multifunction" "preempt=voluntary" ];
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];
  boot.kernelModules = [ "vfio_virqfd" "vhost-net" ];
  boot.extraModprobeConfig = "options vfio-pci ids=10DE:1AED,10DE:1AEB,1B21:1242,10DE:1AEC,10DE:1AED";
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
  
  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
  };
  # Set a time zone
  time.timeZone = "Australia/Perth";

  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

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

  security.pam.services.swaylock = {};

 systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  };
};

  users.defaultUserShell = pkgs.fish;

  users.users.maya = {
    isNormalUser = true;
    description = "maya";
    extraGroups = ["networkmanager" "wheel" "adbusers" "libvirtd"];
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
  };
  
services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "24.05";
}
