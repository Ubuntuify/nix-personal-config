{
  self,
  inputs,
  outputs,
}: {
  # Creates a list that you can set to config.users.users by simply importing a list
  # of users you want to have in your system.
  #
  getUserCfgs = users: path: system:
    map (user: (builtins.toPath path) + "/${user}/${system}/default.nix") users;
}
