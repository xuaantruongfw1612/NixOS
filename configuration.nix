{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hyprland-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";

  services.getty.autologinUser = "truong";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  users.users.truong = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    foot
    kitty
    waybar
    git
    hyprpaper
    firefox
    neovim
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";

}

