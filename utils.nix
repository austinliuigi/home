{ pkgs, lib }:

rec {
  # Generate a list of files in a directory, recursing into subdirectories
  #   - param dir: string|path - directory that should be scanned; if string, must be path in the nix store
  #   - param recurse: boolean - whether or not to recurse down subdirectories
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


  # Generate a map from filepaths to substitute derivations for each file within a directory
  #   - param dir: path - top level directory that holds all files that should get substituted
  #   - param replacements: attr - map from strings that should get replaced to their respective replacements
  #     - key = <match>: str - files that contain the text @<match>@ get replaced
  #     - val = <replacement>: str - the text that should replace @<match>@ in the file
  #   - return substitutions: attr - map from filepaths to substitute derivations
  #     - key = <filepath>: str - filepath relative to dir
  #     - val = <substituted_file>: derivation - derivation that builds the file with substituted replacements
  substituteDirFiles = { dir, replacements }:
    (builtins.listToAttrs
      (builtins.map
        (file:
          {
            name = file;
            value = pkgs.substituteAll ({
              src = "${dir}/${file}";
            } // replacements);
          }
        )
        (scanDirFiles { dir = dir; })
      )
    );


  # Substitute colors based on current theme
  #   - param dir: str|path directory which contains configurations files that should be placed in home
  #   - return substitutions: attr
  #     - key = <filepath>: str - filepath relative to dir
  #     - val = { source = <substituted_file> }: attr - <substituted_file> is a derivation that builds the file with substituted replacements
  interpolateConfig = dir:
    builtins.mapAttrs
      (file: substituted: { source = substituted; })
      (substituteDirFiles { 
        dir = dir;
        replacements = {
          base01 = "color1";
          base02 = "color2";
          base03 = "color3";
          base04 = "color4";
          base05 = "color5";
          base06 = "color6";
          base07 = "color7";
          base08 = "color8";
          base09 = "color9";
          base10 = "color10";
          base11 = "color11";
          base12 = "color12";
          base13 = "color13";
          base14 = "color14";
          base15 = "color15";
          base16 = "color16";
        };
      });


  # Remove elements in a list
  # e.g. removeElems ["x" "z"] ["x" "y" "z"]
  removeElems = blacklist:
    builtins.filter (e: !(builtins.elem e blacklist));
}
