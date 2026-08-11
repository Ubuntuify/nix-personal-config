{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gtk-engine-murrine,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "squared-gtk";
  version = "a23182a";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Squared";
    rev = finalAttrs.version;
    sha256 = "sha256-dyhdRxFpq6QPXingp21dkITIuLveYEiBJFo8wuP+BqQ=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/themes/squared-gtk
    cp -r * $out/share/themes/squared-gtk/
  '';

  meta = {
    description = "An elegant dark theme for Gnome with squared corners and an easy on the eyes color pallete";
    homepage = "https://www.gnome-look.org/p/2206255/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
})
