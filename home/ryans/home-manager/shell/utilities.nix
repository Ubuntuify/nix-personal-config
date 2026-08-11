{
  pkgs,
  lib,
  config,
  nixosConfig,
  ...
} @ args: let
  isNixOS = builtins.hasAttr "nixosConfig" args;
in {
  programs.bat = {
    enable = true;
    config.theme = "Nord";
  };

  programs.cava = {
    enable = !pkgs.stdenv.hostPlatform.isDarwin;
    settings = {
      color = {
        background = "'#232136'";
        gradient = 1;
        gradient_count = 6;
        gradient_color_1 = "'#3e8fb0'";
        gradient_color_2 = "'#9ccfd8'";
        gradient_color_3 = "'#c4a7e7'";
        gradient_color_4 = "'#ea9a97'";
        gradient_color_5 = "'#f6c177'";
        gradient_color_6 = "'#eb6f92'";
      };
    };
  };

  programs.fastfetch.enable = true;

  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [".git/" "*.bak" ".DS_Store"];
  };

  home.packages = with pkgs;
    [
      # Packages that exist both on Linux and Darwin systems.
      zip
      xz
      unzip
      _7zz
      file
      lstr
      which
      gnused
      gnutar
      gawk
      zstd
      btop
    ]
    ++
    # Packages that only exist on Linux, and should not be added to
    # home.packages on darwin systems.
    (lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      lsof
      ethtool
      lm_sensors
      pciutils
      usbutils
    ]);

  # Nix can start taking a lot of space, as it doesn't remove old versions of
  # packages automatically. Since we're already using nh (yet another nix CLI
  # helper), use that to clean up.

  # This checks if there's already a corresponding configuration in nixosConfig
  # (there's none for nix-darwin), and removes it from home-manager if there is.
  programs.nh = with lib; let
    defaultFlakeLocation = "${config.xdg.dataHome}/nix-config";
  in
    lib.mkIf (!nixosConfig.programs.nh.enable or (!isNixOS)) {
      enable = true;
      darwinFlake = defaultFlakeLocation;
      homeFlake = mkIf (builtins.hasAttr "darwinConfig" args) defaultFlakeLocation;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--verbose --keep-since 7d --optimise";
      };
    };
}
