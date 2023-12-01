{ lib, ... }:

rec {
  inStore = path:
    if lib.isStringLike path then
      let
        path_str = builtins.toString path;
      in
        lib.hasPrefix "/nix/store" path_str
    else
      false;

  toStorePath = path:
    if (inStore path) then
      path
    else
      "${/. + path}";

  # Generate a list of files in a directory, recursing into subdirectories
  #   - param dir: string|path - directory that should be scanned
  #   - param recurse: boolean - whether or not to recurse down subdirectories
  #   - param absolute_paths: boolean - if true, files will be given with their nix store paths, else relative to dir
  #   - return files: list - paths to files in directory relative to the root
  scanDirFiles = { dir, recurse ? true, absolute_paths ? false }:
    let
      # convert an absolute path to nix store version to respect pure eval
      puredir = toStorePath dir;
      files = (lib.flatten
        (lib.mapAttrsToList
          (file: type:
            if type == "directory" then
              if recurse then
                scanDirFiles { dir = "${puredir}/${file}"; absolute_paths = true; }
              else
                []  # empty list will get flattened into nothing
            else
              "${puredir}/${file}"
          )
          (builtins.readDir "${puredir}")
        )
      );
    in
      if absolute_paths then
        files
      else
        builtins.map
          (file:
            builtins.unsafeDiscardStringContext (lib.removePrefix "${puredir}/" file)
          )
          (files);


  # Remove elements in a list
  # e.g. removeElems ["x" "z"] ["x" "y" "z"]
  removeElems = blacklist:
    builtins.filter (e: !(builtins.elem e blacklist));
}
