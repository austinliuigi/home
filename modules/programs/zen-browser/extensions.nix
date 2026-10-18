# Firefox extensions via rycee's NUR repository
# Reference: https://nur.nix-community.org/repos/rycee/
#
# `settings` writes browser-extension-data/<id>/storage.js. Keys are the
# extension's own storage.local schema, so read its source; declare every key
# you care about, omitted ones revert to the extension's defaults on each
# switch. Requires `force`, and sets ExtensionStorageIDB.enabled=false for the
# whole profile, which drops every extension to the legacy JSON backend and
# hides what they had in IndexedDB (nix-community/home-manager#9211).
{
  inputs,
  pkgs,
  ...
}: let
  # firefox-addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
in {
  nixpkgs.overlays = [
    inputs.nur.overlays.default
  ];

  programs.zen-browser.profiles.default.settings = {
    "extensions.autoDisableScopes" = 0; # automatically install extensions without needing user approval
  };

  programs.zen-browser.profiles.default.extensions = {
    packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      clearurls
      bitwarden
      sponsorblock
      enhancer-for-youtube
      auto-tab-discard
    ];

    settings = {
    };
  };
}
