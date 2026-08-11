{outputs, ...}: let
  user = "ryan";
in {
  # Windows (which I derive my NixOS username from) has different naming
  # user conventions compared to Unix-based systems.
  #
  # Such as the fact that the last name is not included as part of the
  # "username" part of it.

  users.users.${user} = {
    # nix-darwin's "The Plan" should allow me to set more configuration, such as Docks,
    # Preferences, and other settings in here later on. You can probably do with
    # home-manager, but I prefer my setups more specialized on MacOS, and make sure
    # MacOS specific changes in a different file.
    #
    # - tracking issue: nix-darwin/nix-darwin#1452 -

    name = "${user}";
    description = "Ryan Salazar";
    home = "/Users/${user}";
  };

  # These apps are things that I, (this user), uses, so they shouldn't be a common
  # module.
  homebrew = {
    casks = [
      "rectangle"
      "calibre"
      "discord"
      "grishka/grishka/neardrop"
    ];
    masApps = {
      # These are Mac Store applications, defined with an ID.
      "DaVinci Resolve" = 571213070;
    };
  };

  home-manager.users.${user} = outputs.lib.home-manager.mkHomeEntry {
    user = "ryans"; # use *this* specific configuration
  };
}
