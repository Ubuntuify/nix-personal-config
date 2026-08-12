{
  self,
  inputs,
  outputs,
  ...
}: let
  users = import ./users.nix {inherit self inputs outputs;};
in {
  # General functions are kept here, while other functions which are specific to components are
  # inherited (imported) into this module;

  # Inherited functions
  inherit (users) getUserCfgs;

  # Naive approach to getting "common modules," which should be imported non-discriminantly, therefore
  # this simple function.
  getCommonModulePaths = path: let
    files = builtins.readDir path;
  in
    map (file: builtins.toPath (path + "/${file}")) (builtins.filter (obj: files.${obj} != "directory")
      (builtins.attrNames files));
}
