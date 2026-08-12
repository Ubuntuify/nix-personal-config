{
  outputs,
  modules,
  ...
}: let
  inherit (outputs) overlays;
in {
  imports = [
    ./generated/hardware-configuration.nix
    ./system-specific/bootloader.nix
    ./system-specific/swap.nix
    modules.hardware.asahi
    modules.security.sops
    modules.system.audio
    modules.system.fonts
    modules.system.networking
    modules.system.printing
    modules.system.bluetooth
    modules.window-manager
    modules.display-manager.sysc-greet
    modules.security.sops
    modules.drawing
    (outputs.lib.users.getNixUserModule "ryans")
  ];

  # Options required for Asahi (apple-silicon)'s hardware module, such as providing the firmware hash
  # for pure flakes, and other options like touch bar support.
  custom.asahi = {
    firmwareHash = "sha256-5p9g6q8YdbTtc5YrjB4MInxxIiQNMbUoihLzyhSa7AQ=";
    hasTouchBar = true;
  };

  nixpkgs.overlays = [
    overlays.lix
  ];

  services.xserver.enable = true;
  security.polkit.enable = true;
  programs.niri.enable = true;

  programs.nix-ld.enable = true;

  system.stateVersion = "25.11";
}
