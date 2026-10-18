# https://github.com/0xc000022070/zen-browser-flake/blob/main/examples/11-keyboard-shortcuts.nix
{
  programs.zen-browser.profiles.default = let
    use_ctrl = true;
  in {
    keyboardShortcuts = [
      # ========== CUSTOM KEYBINDS ==========
      {
        id = "zen-new-empty-split-view";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "s";
      }
      {
        id = "goBackKb";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "o";
      }
      {
        id = "goForwardKb";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "i";
      }
      {
        id = "key_reload";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "r";
      }
      {
        id = "key_reload_skip_cache";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        modifiers.shift = true;
        key = "r";
      }
      {
        id = "key_selectTab8";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "8";
      }
      {
        id = "key_selectTab7";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "7";
      }
      {
        id = "key_selectTab6";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "6";
      }
      {
        id = "key_selectTab5";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "5";
      }
      {
        id = "key_selectTab4";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "4";
      }
      {
        id = "key_selectTab3";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "3";
      }
      {
        id = "key_selectTab2";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "2";
      }
      {
        id = "key_selectTab1";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "1";
      }
      {
        id = "key_newNavigatorTab";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "t";
      }
      {
        id = "key_restoreLastClosedTabOrWindowOrSession";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        modifiers.shift = true;
        key = "t";
      }
      {
        id = "key_close";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "w";
      }
      {
        id = "zen-library-toggle";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "\\";
      }
      {
        id = "key_fullZoomReset";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "=";
      }
      {
        id = "key_fullZoomEnlarge";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        modifiers.shift = true;
        key = "+";
      }
      {
        id = "key_fullZoomReduce";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "-";
      }
      {
        id = "key_screenshot";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        modifiers.shift = true;
        key = "s";
      }
      {
        id = "key_toggleToolbox";
        key = "VK_F1";
      }
      {
        id = "key_browserConsole";
        key = "VK_F2";
      }
      {
        id = "key_find";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "f";
      }
      {
        id = "key_findAgain";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "g";
      }
      {
        id = "key_viewInfo";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        modifiers.shift = true;
        key = "i";
      }
      {
        id = "focusURLBar";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "l";
      }
      {
        id = "key_privatebrowsing";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        modifiers.shift = true;
        key = "n";
      }
      {
        id = "key_newNavigator";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        key = "n";
      }
      {
        id = "zen-workspace-forward";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        keycode = "VK_RIGHT";
      }
      {
        id = "zen-workspace-backward";
        modifiers.control = use_ctrl;
        modifiers.alt = ! use_ctrl;
        keycode = "VK_LEFT";
      }

      # ========== DISABLED KEYBINDS ==========
      {
        id = "key_gotoHistory";
        disabled = true;
      }
      {
        id = "key_selectLastTab";
        disabled = true;
      }
      {
        id = "key_duplicateTab";
        disabled = true;
      }
      {
        id = "key_separateTabSplitView";
        disabled = true;
      }
      {
        id = "key_addTabSplitView";
        disabled = true;
      }
      {
        id = "key_undoCloseWindow";
        disabled = true;
      }
      {
        id = "key_quitApplication";
        disabled = true;
      }
      {
        id = "key_sanitize";
        disabled = true;
      }
      {
        id = "key_switchTextDirection";
        disabled = true;
      }
      {
        id = "key_showAllTabs";
        disabled = true;
      }
      {
        id = "toggleSidebarKb";
        disabled = true;
      }
      {
        id = "viewOpenTabsSidebarKb";
        disabled = true;
      }
      {
        id = "viewGenaiChatSidebarKb";
        disabled = true;
      }
      {
        id = "key_stop";
        disabled = true;
      }
      {
        id = "viewBookmarksToolbarKb";
        disabled = true;
      }
      {
        id = "viewBookmarksSidebarKb";
        disabled = true;
      }
      {
        id = "manBookmarkKb";
        disabled = true;
      }
      {
        id = "bookmarkAllTabsKb";
        disabled = true;
      }
      {
        id = "addBookmarkAsKb";
        disabled = true;
      }
      {
        id = "key_findPrevious2";
        disabled = true;
      }
      {
        id = "key_findAgain2";
        disabled = true;
      }
      {
        id = "key_findPrevious";
        disabled = true;
      }
      {
        id = "key_viewSource";
        disabled = true;
      }
      {
        id = "key_aboutProcesses";
        disabled = true;
      }
      {
        id = "key_togglePictureInPicture";
        disabled = true;
      }
      {
        id = "key_toggleReaderMode";
        disabled = true;
      }
      {
        id = "key_exitFullScreen";
        disabled = true;
      }
      {
        id = "key_enterFullScreen";
        disabled = true;
      }
      {
        id = "key_reload_skip_cache2";
        disabled = true;
      }
      {
        id = "showAllHistoryKb";
        disabled = true;
      }
      {
        id = "key_reload2";
        disabled = true;
      }
      {
        id = "goHome";
        disabled = true;
      }
      {
        id = "goForwardKb2";
        disabled = true;
      }
      {
        id = "goBackKb2";
        disabled = true;
      }
      {
        id = "key_selectAll";
        disabled = true;
      }
      {
        id = "key_delete";
        disabled = true;
      }
      {
        id = "key_paste";
        disabled = true;
      }
      {
        id = "key_copy";
        disabled = true;
      }
      {
        id = "key_cut";
        disabled = true;
      }
      {
        id = "key_redo";
        disabled = true;
      }
      {
        id = "key_undo";
        disabled = true;
      }
      {
        id = "key_toggleMute";
        disabled = true;
      }
      {
        id = "key_closeWindow";
        disabled = true;
      }
      {
        id = "printKb";
        disabled = true;
      }
      {
        id = "key_savePage";
        disabled = true;
      }
      {
        id = "openFileKb";
        disabled = true;
      }
      {
        id = "key_openAddons";
        disabled = true;
      }
      {
        id = "key_openDownloads";
        disabled = true;
      }
      {
        id = "key_search2";
        disabled = true;
      }
      {
        id = "key_search";
        disabled = true;
      }
      {
        id = "focusURLBar2";
        disabled = true;
      }
      {
        id = "zen-compact-mode-toggle";
        disabled = true;
      }
      {
        id = "zen-compact-mode-show-sidebar";
        disabled = true;
      }
      {
        id = "zen-workspace-switch-10";
        disabled = true;
      }
      {
        id = "zen-workspace-switch-9";
        disabled = true;
      }
      {
        id = "zen-workspace-switch-8";
        disabled = true;
      }
      {
        id = "zen-workspace-switch-7";
        disabled = true;
      }
      {
        id = "zen-workspace-switch-6";
        disabled = true;
      }
      {
        id = "zen-workspace-switch-5";
        disabled = true;
      }
      {
        id = "zen-workspace-switch-4";
        disabled = true;
      }
      {
        id = "zen-workspace-switch-3";
        disabled = true;
      }
      {
        id = "zen-workspace-switch-2";
        disabled = true;
      }
      {
        id = "zen-workspace-switch-1";
        disabled = true;
      }
      {
        id = "zen-split-view-grid";
        disabled = true;
      }
      {
        id = "zen-split-view-vertical";
        disabled = true;
      }
      {
        id = "zen-split-view-horizontal";
        disabled = true;
      }
      {
        id = "zen-split-view-unsplit";
        disabled = true;
      }
      {
        id = "zen-pinned-tab-reset-shortcut";
        disabled = true;
      }
      {
        id = "zen-toggle-sidebar";
        disabled = true;
      }
      {
        id = "zen-copy-url";
        disabled = true;
      }
      {
        id = "zen-copy-url-markdown";
        disabled = true;
      }
      {
        id = "zen-toggle-pin-tab";
        disabled = true;
      }
      {
        id = "zen-glance-expand";
        disabled = true;
      }
      {
        id = "zen-close-all-unpinned-tabs";
        disabled = true;
      }
      {
        id = "zen-new-unsynced-window";
        disabled = true;
      }
      {
        id = "zen-duplicate-tab";
        disabled = true;
      }
      {
        id = "zen-workspace-create";
        disabled = true;
      }
      {
        id = "key_accessibility";
        disabled = true;
      }
      {
        id = "key_dom";
        disabled = true;
      }
      {
        id = "key_storage";
        disabled = true;
      }
      {
        id = "key_performance";
        disabled = true;
      }
      {
        id = "key_styleeditor";
        disabled = true;
      }
      {
        id = "key_netmonitor";
        disabled = true;
      }
      {
        id = "key_jsdebugger";
        disabled = true;
      }
      {
        id = "key_webconsole";
        disabled = true;
      }
      {
        id = "key_inspector";
        disabled = true;
      }
      {
        id = "key_responsiveDesignMode";
        disabled = true;
      }
      {
        id = "key_browserToolbox";
        disabled = true;
      }
    ];
    # Activation fails if version changes (prevents silent breakage). You should be asked to bump this version
    # Get version from about:config -> zen.keyboard.shortcuts.version
    keyboardShortcutsVersion = 21;
  };
}
# Find shortcut IDs in ~/.config/zen/<default_profile>/zen-keyboard-shortcuts.json
#
# Use this command:
# jq -c '.shortcuts[] | {id, key, keycode, action}' ~/.config/zen/default/zen-keyboard-shortcuts.json | fzf
