{
  description = "Ryan's Nix configuration flake";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org" "https://nixos-apple-silicon.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="];
  };

  inputs = {
    self.submodules = true; # enable submodules support

    # Main system components (i.e. NixOS, nix-darwin, etc.)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs"; # These stop nix from downloading multiple instances of nixpkgs

    # Secrets manager
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # User components (such as for: setting up home directories, and homebrew)
    home-manager = {
      url = "github:nix-community/home-manager"; # sets up home applications and their settings
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf"; # setups nvim with appropriate settings for development
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew"; # homebrew for nix-darwin
    elephant = {
      url = "github:abenz1267/elephant"; # elephant is a dependency of walker
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker"; # walker is a launcher and dmenu subtitute, used for launching apps
      inputs.elephant.follows = "elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sysc-greet = {
      url = "github:Nomadcxx/sysc-greet";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms.url = "github:AvengeMedia/DankMaterialShell";

    # Support modules (modules that connect to main system components to add patches for NixOS to work)
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main"; # for windows subsystem for linux (weird name), can build tarballs
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon/main"; # asahi linux, this comes with a module defined for ease
      inputs.nixpkgs.follows = "nixpkgs"; # of use.
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2"; # secure boot
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Alternate repositories (such as repositories for Firefox addons, etc.)
    nur = {
      url = "github:nix-community/NUR"; # used this primarily for Firefox addons, but can be used for other things
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake components (components used by the flake for management, etc.)
    haumae = {
      url = "github:nix-community/haumea/v0.2.2"; # might want to move away from this, but auto-imports modules like
      inputs.nixpkgs.follows = "nixpkgs"; # how you would do it in other programming languages
    };
  };

  outputs = inputs @ {self, ...}: let
    inherit (self) outputs;
    systems = import ./systems.nix {inherit inputs outputs;};
  in {
    overlays = inputs.haumae.lib.load {
      src = ./overlays;
      inputs = {inherit inputs;};
    };
    lib = import ./lib {inherit self inputs outputs;};
    inherit (systems) nixosConfigurations darwinConfigurations;
    formatter = outputs.lib.forEachSupportedSystem ({pkgs}: pkgs.alejandra);
  };
}
