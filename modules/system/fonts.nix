{
  inputs,
  lib,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; let
    nur = inputs.nur.legacyPackages.${stdenv.hostPlatform.system};
  in [
    # Install Windows fonts.
    corefonts
    vista-fonts

    # Install MacOS' San Francisco font
    nur.repos.sagikazarmark.sf-pro

    # Other open source fonts.
    noto-fonts
    font-awesome
    joypixels
    open-sans
    jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
  fonts.fontconfig.useEmbeddedBitmaps = true;

  # Joypixels is a "fremium" emoji font, therefore requires a license agreement.
  nixpkgs.config.joypixels.acceptLicense = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "sf-pro"
      "corefonts"
      "vista-fonts"
    ];
}
