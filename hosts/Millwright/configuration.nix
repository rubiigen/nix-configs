{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

 {
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      vulkan-validation-layers
      libvdpau-va-gl
      vaapiVdpau
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
    videoDrivers = [ "amdgpu" ];
    layout = "us";
  };
  
  environment.pathsToLink = [ "/libexec" ];

  hardware.enableAllFirmware = true;

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
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
    lxqt.lxqt-policykit
    pavucontrol
    (pkgs.python3.withPackages(ps: with ps; [ tkinter]))
    pulseaudio
    slurp
    swaybg
    swayidle
    swaynotificationcenter
    swayosd
    temurin-bin-18
    temurin-jre-bin-8
    tpm2-tss
    udiskie
    virt-manager
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
    serif = [ "Noto Serif" "Source Han Serif" ];
    sansSerif = [ "Noto Sans" "Source Han Sans" ];
  };

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.i2c.enable = true;

  # services
  services.blueman.enable = true;
  services.dbus.enable = true;
  services.ddccontrol.enable = true;
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
  };
  services.lvm.enable = true;
  services.printing.enable = true;
  services.udisks2.enable = true;

  # greetd
  services.greetd = {
    enable = true;
    restart = true;
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
    TTYVTDisallocate = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  }; 

  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

  console.useXkbConfig = true;

  networking.hostName = "Millwright";

  virtualisation.libvirtd = {
	enable = true;
        extraConfig = ''
          user="alyx"
        '';
	qemu.ovmf.enable = true;
        qemu.package = pkgs.qemu_kvm;
	qemu.runAsRoot = true;
        qemu.swtpm.enable = true;  
  };

  virtualisation.spiceUSBRedirection.enable = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.bootspec.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-18d0700e-1d6a-4526-83f6-4b0053b1a935".device = "/dev/disk/by-uuid/18d0700e-1d6a-4526-83f6-4b0053b1a935";
  boot.initrd.systemd.enable = true;
  boot.supportedFilesystems = [ "exfat" "xfs" "ntfs" ];
  boot.kernelParams = [ "preempt=voluntary" "module_blacklist=nouveau" "intel_iommu=on" "iommu=pt" "pcie_acs_override=downstream,multifunction" ];
  boot.initrd.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" "kvm-intel" ];
  boot.kernelModules = [ "vfio_virqfd" "vhost-net" ];
  boot.extraModprobeConfig = "options vfio-pci ids=10de:1c03,10de:10f1,1b21:2142";
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.blacklistedKernelModules = [ "nouveau" ];

  # enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Set a time zone
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "it_IT.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
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

 systemd = {
  user.services.polkit-lxqt = {
    description = "polkit-lxqt";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
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

  users.users.alyx = {
    isNormalUser = true;
    description = "alyx";
    extraGroups = ["networkmanager" "wheel" "adbusers" "libvirtd" "kvm" ];
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
  };
  
services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  system.stateVersion = "24.05";
}
