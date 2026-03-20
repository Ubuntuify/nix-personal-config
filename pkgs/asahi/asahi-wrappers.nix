{
  stdenvNoCC,
  writeShellScriptBin,
  pkgs,
}: let
  reboot-to-macos = writeShellScriptBin "reboot-to-macos" ''
    sudo asahi-bless --next --set-boot-macos -y && systemctl reboot
  '';
in
  stdenvNoCC.mkDerivation {
    name = "asahi-wrappers";
    version = 1.0;
    buildInputs = [
      reboot-to-macos
    ];

    src = ./.;

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${reboot-to-macos}/bin/reboot-to-macos $out/bin/reboot-to-macos
    '';
  }
