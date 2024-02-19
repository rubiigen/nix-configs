{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  hardware.opengl = {
    extraPackages = with pkgs; [
      vulkan-validation-layers
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  services.xserver = {
    videoDrivers = ["i915"];
  };

  nixpkgs = {
    config = {
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
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
  };

  environment.systemPackages = with pkgs; [
    i2c-tools
    (pkgs.python3.withPackages (ps: with ps; [tkinter]))
    virt-manager
  ];

  environment.sessionVariables = {
    XCURSOR_SIZE = "24";
  };

  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
  };

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
  boot.initrd.luks.devices."luks-62c4e746-ff0e-4fce-ae90-c144bd565e0b" = {
    device = "/dev/disk/by-uuid/62c4e746-ff0e-4fce-ae90-c144bd565e0b";
    keyFile = "/key/key/alyssum";
    preLVM = false;
  };
  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.kernelParams = ["intel_iommu=on" "iommu=pt" "pcie_acs_override=downstream,multifunction" "preempt=voluntary"];
  boot.blacklistedKernelModules = ["nouveau"];
  boot.kernelModules = ["vfio_virqfd" "vhost-net"];
  boot.extraModprobeConfig = "options vfio-pci ids=10DE:1AED,10DE:1AEB,1B21:1242,10DE:1AEC,10DE:1AED,10EC:818B";
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = ["vfio_pci" "vfio" "vfio_iommu_type1" "uas" "usbcore" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1" ];

  networking = {
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

  users.users.maya = {
    isNormalUser = true;
    description = "maya";
    extraGroups = ["networkmanager" "wheel" "adbusers" "libvirtd"];
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
  };
  
  services.pipewire = {
    extraConfig = {
      pipewire = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.rate" = 96000;
          };
        };
      };
      pipewire-pulse = {
        "11-pulse-clock-rate" = {
          "pulse.properties" = {
            "pulse.default.req" = "128/96000";
          };
        };
      };
    };
  };


  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };
}
