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
      libvdpau-va-gl
      mesa
      nvidia-vaapi-driver
      vaapiVdpau
      vulkan-validation-layers
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
      driversi686Linux.mesa
      pkgsi686Linux.nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
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

  #programs.hyprlock = {
  #  enable = true;
  #  package = inputs.hyprlock.packages.${pkgs.system}.default.overrideAttrs {
  #     patchPhase = ''
  #        substituteInPlace src/core/hyprlock.cpp \
  #        --replace "5000" "16"
  #     '';
  #  };
  #};

  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock.overrideAttrs (old: {
      version = "git";
      src = pkgs.fetchFromGitHub {
        owner = "hyprwm";
        repo = "hyprlock";
        rev = "2bce52f";
        sha256 = "36qa6MOhCBd39YPC0FgapwGRHZXjstw8BQuKdFzwQ4k=";
      };
      patchPhase = ''
        substituteInPlace src/core/hyprlock.cpp \
        --replace "5000" "16"
      '';
      });
  };

 environment.systemPackages = with pkgs; [
    alvr
    clinfo
    ddcutil
    gwe
    i2c-tools
    lact
    nvtopPackages.nvidia
    (pkgs.python3.withPackages (ps: with ps; [tkinter]))
    sidequest
    tpm2-tss
    vulkan-loader
    vulkan-tools
  ];

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    __GL_THREADED_OPTIMIZATION = "1";
    __GL_SHADER_CACHE = "1";
    NVD_BACKEND = "direct";
  };

  

  hardware.i2c.enable = true;
  hardware.keyboard.qmk.enable = true;

  services.ddccontrol.enable = true;
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
  };

  console.useXkbConfig = true;

  networking.hostName = "Millwright";
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 5900 ];


  virtualisation.libvirtd = {
    enable = true;
    extraConfig = ''
      user="alyx"
    '';
    qemu.ovmf.enable = true;
    qemu.package = pkgs.qemu;
    qemu.ovmf.packages = [
      pkgs.OVMF.fd
      pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
    ];
    qemu.runAsRoot = true;
    qemu.swtpm.enable = true;
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  systemd.services.lactd = {
   after = [ "multi-user.target" ];
   description = "AMDGPU Control Daemon";
   wantedBy = [ "multi-user.target" ];
   serviceConfig = {
     ExecStart = ''${pkgs.lact}/bin/lact daemon'';
     Nice = "-10";
   };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.initrd.systemd.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-partuuid/f1afe0b2-9f0b-4f4d-8eab-9c1bea57c705";
      header = "/dev/disk/by-partuuid/08f5286a-64f5-49b3-bde7-ec6180ee9f84";
      allowDiscards = true;
      preLVM = true;
    };
  };

  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.supportedFilesystems = ["exfat" "xfs" "ntfs"];
  boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11_beta];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.blacklistedKernelModules = ["nouveau"];  
  boot.kernelParams = [ "preempt=voluntary" "intel_iommu=on" "iommu=pt" "pcie_acs_override=downstream,multifunction"];
  boot.initrd.kernelModules = ["vfio_pci" "vfio_iommu_type1" "vfio" "kvm-intel"];
  boot.kernelModules = ["vfio_virqfd" "vhost-net"];  

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
