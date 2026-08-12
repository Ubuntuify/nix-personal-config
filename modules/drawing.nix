{
  pkgs,
  options,
  outputs,
  lib,
  ...
}: let
  isLinux = builtins.hasAttr "hardware" options; # hardware configs only exist on NixOS systems
  isDarwin = builtins.hasAttr "homebrew" options; # homebrew configs only exist on nix-darwin
in
  lib.mkMerge [
    (outputs.lib.unsafeIf isLinux {
      home-manager.sharedModules = [
        {home.packages = [pkgs.krita];}
        # Krita is broken on Darwin systems, so we should only add it as a package on Linux.
      ];

      hardware.opentabletdriver.enable = true;
    })
    (outputs.lib.unsafeIf isDarwin {
      homebrew.casks = [
        "wacom-tablet" # OpenTabletDriver is not available on MacOS (Apple Silicon)
        "krita" # Use homebrew to install krita.
      ];
    })
  ]
