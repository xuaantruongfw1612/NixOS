{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.truong = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  nixpkgs.config.allowUnfree = true;

  # NVIDIA Configuration for Acer Nitro 5 AN515-55
  # GPU Info: Intel CometLake-H UHD Graphics + NVIDIA GTX 1650 Ti Mobile
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;  # Use proprietary driver for GTX 1650 Ti
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      sync.enable = true;  # Use sync mode for stability with Hyprland
      # Alternative: offload mode for battery saving
      # offload.enable = true;
      # offload.enableOffloadCmd = true;

      # Bus IDs from lspci output:
      # 00:02.0 = Intel CometLake-H UHD Graphics
      # 01:00.0 = NVIDIA GTX 1650 Ti Mobile
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Hyprland Configuration
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Audio Configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Environment Variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    foot
    wofi
    mako
    hyprpaper
    grim
    slurp
    wl-clipboard
  ];

  system.stateVersion = "25.11";
}
