# Unlike other modules, this module requires some stuff to be passed in to check for some features on Macbooks.
# For example, 13" Macbooks still have a touch bar that requires configuration and newer devices have a notch.
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.apple-silicon.nixosModules.apple-silicon-support # make sure that the Apple Silicon support module is loaded.
  ];

  options.custom.asahi = {
    firmwareHash = lib.mkOption {
      type = lib.types.str;
    };
    hasTouchBar = lib.mkEnableOption "touch bar support (using tiny-dfr)";
    showNotch = lib.mkEnableOption "notch space on supporting devices.";
  };

  config = let
    inherit (config.custom.asahi) hasTouchBar showNotch firmwareHash;
  in {
    environment.systemPackages = with pkgs; let
      reboot-macos = pkgs.writeShellScriptBin "reboot-macos" ''
        sudo ${lib.getExe pkgs.asahi-bless} --set-boot-macos --yes \
          && echo "Rebooting to MacOS in five seconds..." && sleep 5 && systemctl reboot
      '';
    in [
      asahi-bless # allows switching boot device, similar to Startup Disk on MacOS (or the bless utility).

      # Custom packages
      reboot-macos
    ];

    hardware.asahi.enable = true;

    hardware.asahi.peripheralFirmwareDirectory = let
      # Flakes run in "pure" evaluation mode on nix, making them unable to simply require the <ESP>/asahi partition.
      # Therefore, to make the system reproducible, it has to have the hash of the peripheral firmware directory.
      #
      # This simplifies the creation of one and simply requires the hash, while also providing instructions when
      # errors happen.
      mkPeripheralFirmwareDirectory = hash:
        pkgs.requireFile {
          inherit hash;
          name = "vendorfw";
          hashMode = "recursive";
          message = ''
                        Linux on Apple Silicon requires proprietary firmware blobs taken from MacOS to function correctly, run the below command on your system, and if it doesn't work, try the following troubleshooting steps.
            Litefin
                        nix-store --add-fixed sha256 --recursive <path-to-asahi-esp>/asahi

                        #1) Is the hash of your firmware directory different from the one listed here? Check with `nix hash --algo sha256 <path-to-asahi-esp>/asahi`
                        #2) Is this your first install? Running this command on the installation environment won't work, and you'll have to first run without it and run it on the system itself before doing a switch.
          '';
        };
    in
      mkPeripheralFirmwareDirectory firmwareHash;

    nixpkgs.config.allowUnfreePackages = ["vendorfw"]; # Allows unfree firmware to be part of the install.

    # You can't touch EFI variables on an Asahi Linux system, and doing so will cause the switch to fail.
    boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

    # Configurable parts for Apple Macbook quirks, such as the Touch Bar and the Notch on older and newer devices
    # respectively.
    hardware.apple.touchBar.enable = hasTouchBar;
    boot.kernelParams = lib.optionals showNotch ["appledrm.show_notch=1"];

    # Nix settings (enable custom substituter for apple-silicon)
    # see https://github.com/nix-community/nixos-apple-silicon/blob/main/docs/binary-cache.md for more info
    nix.settings = {
      extra-substituters = ["https://nixos-apple-silicon.cachix.org"];
      extra-trusted-public-keys = ["nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="];
    };
  };
}
