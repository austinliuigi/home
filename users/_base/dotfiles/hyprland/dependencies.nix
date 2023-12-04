{ config, pkgs, lib, utils, inputs, ... }:

{
  modules = {
    scripts = {
      brightness.enable = true;
      volume.enable = true;
      wayland.screenshot.enable = true;
    };
  };
}
