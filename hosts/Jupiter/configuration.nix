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
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      vulkan-validation-layers
      libvdpau-va-gl
      vaapiVdpau
      mesa
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
      driversi686Linux.mesa
    ];
  };

  services.xserver = {
    enable = true;
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
    virt-manager.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      pkgs.libusb1
      pkgs.cargo
      pkgs.rustc
      pkgs.pkg-config
      pkgs.cacert
    ];
  };

  environment.systemPackages = with pkgs; [
    alvr
    ddcutil
    i2c-tools
    (pkgs.python3.withPackages (ps: with ps; [tkinter]))
    sidequest
    tpm2-tss
  ];

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  hardware.i2c.enable = true;
  hardware.keyboard.qmk.enable = true;

  services.ddccontrol.enable = true;
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
  };

  console.useXkbConfig = true;

  networking.hostName = "Jupiter";

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

  boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-partuuid/fcf37e6e-4b0d-407d-856a-d68d225f8c76";
      header = "/dev/disk/by-partuuid/88a42cb8-c6c5-411b-9738-34481dd44d3b";
      allowDiscards = true;
      preLVM = true;
    };
  };

  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.supportedFilesystems = ["exfat" "xfs" "ntfs"];
  boot.kernelParams = ["preempt=voluntary" "intel_iommu=on" "iommu=pt"];
  boot.initrd.kernelModules = ["vfio" "kvm-intel"];
  boot.kernelModules = ["vfio_virqfd" "vhost-net"];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # enable networking
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

  users.users.alyx = {
    isNormalUser = true;
    description = "alyx";
    extraGroups = ["networkmanager" "wheel" "adbusers" "libvirtd" "kvm"];
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
      PasswordAuthentication = true;
    };
  };
}
