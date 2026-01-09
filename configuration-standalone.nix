# Standalone NixOS Configuration for Acer Nitro 5 AN515-55
# Can be used WITHOUT flakes for initial installation
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable flakes for future use
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.truong = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    initialPassword = "nixos";  # Change after first login!
  };

  nixpkgs.config.allowUnfree = true;

  # NVIDIA Configuration for Acer Nitro 5 AN515-55
  # GPU: Intel CometLake-H UHD + NVIDIA GTX 1650 Ti Mobile
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      sync.enable = true;
      # Bus IDs from: lspci | grep -E "VGA|3D"
      # 00:02.0 = Intel CometLake-H UHD Graphics
      # 01:00.0 = NVIDIA GTX 1650 Ti Mobile
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Environment
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    wget
    curl

    # Hyprland essentials
    foot
    wofi
    mako
    hyprpaper
    grim
    slurp
    wl-clipboard

    # Laptop utilities
    brightnessctl
    pamixer
    playerctl
    networkmanagerapplet

    # Input method
    fcitx5
    fcitx5-unikey
  ];

  # Hyprland basic config (minimal, can customize later)
  environment.etc."hypr/hyprland.conf".text = ''
    monitor=,preferred,auto,1

    exec-once = mako
    exec-once = hyprpaper
    exec-once = fcitx5 -d

    $mod = SUPER

    bind = $mod, RETURN, exec, foot
    bind = $mod, Q, killactive
    bind = $mod, D, exec, wofi --show drun
    bind = $mod SHIFT, E, exit

    # Workspace bindings
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5

    input {
      kb_layout = us
      touchpad {
        natural_scroll = true
        disable_while_typing = true
      }
    }

    general {
      gaps_in = 5
      gaps_out = 10
      border_size = 2
    }
  '';

  system.stateVersion = "25.11";
}
