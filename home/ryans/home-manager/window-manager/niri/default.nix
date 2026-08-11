{
  inputs,
  pkgs,
  lib,
  config,
  nixosConfig,
  ...
}:
lib.mkIf (
  builtins.all (s: s) [
    pkgs.stdenv.hostPlatform.isLinux
    config.custom.system.graphics
    (config.custom.linux.windowManager == "niri")
  ]
) {
  home.packages = with pkgs; let
    nur = inputs.nur.legacyPackages.${stdenv.hostPlatform.system};
  in [
    nemo
    mpvpaper
    xwayland-satellite
    socat
    nur.repos.sagikazarmark.sf-pro
  ];

  xdg.configFile."wallpaper.mp4".source = ../../background/orange/sunset-beach.mp4;
  home.file.".local/share/fonts/hyprlock/Steelfish Outline Regular.otf".source = ./hyprlock/steelfish.outline-regular.otf;

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        path = "${../../background/orange/sunset-beach-still.png}";
        blur_passes = 3;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      general = {
        no_fade_in = false;
        disable_loading_bar = false;
      };

      animations = {
        enabled = true;
        bezier = "linear, 1, 1, 0, 0";
      };
    };
    extraConfig = builtins.readFile ./hyprlock/hyprlock.conf;
  };

  # Link in config.kdl (until an upstream module is made for home-manager)
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  gtk = {
    enable = true;
    iconTheme = {
      name = "la-capitaine-icon-theme";
      package = pkgs.la-capitaine-icon-theme;
    };
    gtk4.theme = {
      name = "squared-gtk";
      package = pkgs.callPackage ../../../../../pkgs/themes/squared-gtk.nix {};
    };
  };
}
