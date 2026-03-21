{
  config,
  modules,
  outputs,
  ...
}: let
  inherit (outputs) overlays;
in {
  imports = [
    modules.hardware.wsl.nvidia
    modules.security.sops
    (outputs.lib.users.getNixUserModule "ryans")
  ];

  nixpkgs.overlays = [
    overlays.lix
  ];

  home-manager.users.${config.custom.systemUser} = outputs.lib.home-manager.mkHomeEntry {
    user = config.custom.systemUser;
    options = {system.graphics = false;};
  };
}
