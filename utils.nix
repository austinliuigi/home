{ lib, ... }:

rec {
  # Generate a list of files in a directory, recursing into subdirectories
  #   - param dir: string|path - directory that should be scanned; if string, must be path in the nix store
  #   - param recurse: boolean - whether or not to recurse down subdirectories
  #   - param absolute_paths: boolean - if true, files will be given with their nix store paths, else relative to dir
  #   - return files: list - paths to files in directory relative to the root
  scanDirFiles = { dir, recurse ? true, absolute_paths ? false }:
    let
      files = (lib.flatten
        (lib.mapAttrsToList
          (file: type:
            if type == "directory" then
              if recurse then
                scanDirFiles { dir = "${dir}/${file}"; absolute_paths = true; }
              else
                []  # empty list will get flattened into nothing
            else
              "${dir}/${file}"
          )
          (builtins.readDir "${dir}")
        )
      );
    in
      if absolute_paths then
        files
      else
        builtins.map
          (file:
            builtins.unsafeDiscardStringContext (lib.removePrefix "${dir}/" file)
          )
          (files);


  # Remove elements in a list
  # e.g. removeElems ["x" "z"] ["x" "y" "z"]
  removeElems = blacklist:
    builtins.filter (e: !(builtins.elem e blacklist));
}
