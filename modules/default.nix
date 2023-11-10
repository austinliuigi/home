{ config, pkgs, lib, utils, ... }:

{
  # import all modules; remove current file from list of files to avoid circular import
  imports = (lib.remove
    "${./.}/default.nix"
    (utils.scanDirFiles { dir = ./.; absolute_paths = true; })
  );
}
