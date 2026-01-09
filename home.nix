{ config, pkgs, ... }:

{
  home.username = "truong";
  home.homeDirectory = "/home/truong";
  home.stateVersion = "25.11";

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      monitor = [
        ",preferred,auto,1"
      ];

      exec-once = [
        "mako"
        "hyprpaper"
        "fcitx5 -d"
      ];

      bind = [
        "$mod, RETURN, exec, foot"
        "$mod, Q, killactive"
        "$mod, D, exec, wofi --show drun"
      ];
    };
  };
}
