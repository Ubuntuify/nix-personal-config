{
  imports = [
    ./applications/alacritty.nix
    ./applications/firefox.nix
    ./applications/social.nix
    ./shell/fish.nix
    ./shell/git.nix
    ./shell/lf.nix
    ./shell/neovim.nix
    ./shell/utilities.nix
    ./desktop-environment/niri
    ./desktop-environment/dms.nix
  ];

  xdg.enable = true;

  home.stateVersion = "26.05";
}
