require("neogit").setup({

  -- ========== General Options ==========
  disable_hint = false, -- hides hints at the top of the status buffer
  disable_signs = false, -- disables signs for sections/items/hunks
  disable_context_highlighting = false, -- disables changing the buffer highlights based on where cursor is

  -- true   will start commit editor in normal mode
  -- false  will start commit editor in insert mode
  -- "auto" will start commit editor in insert mode if commit message is empty, else normal mode
  disable_commit_confirmation = "auto",

  -- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem
  -- events.
  filewatcher = { enabled = true },

  -- "ascii"   is the graph the git CLI generates
  -- "unicode" is the graph like https://github.com/rbong/vim-flog
  -- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
  graph_style = "ascii",

  -- Format to show the commit date
  --   - when set, --date=format:<value> is added to the respective git cli command
  --   - if nil, doesn't add the --date flag and uses git's default
  log_date_format = nil, -- used for log, reflog, stash buffers
  commit_date_format = nil, -- used for buffer that shows commit info when creating a new commit (git show)

  -- Value used for `--sort` option for `git branch` command
  -- By default, branches will be sorted by commit date descending
  -- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
  -- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
  sort_branches = "-committerdate",

  -- Default way of opening neogit
  -- https://github.com/NeogitOrg/neogit/blob/63124cf520ff24d09deb3b850e053908ab0fc66a/lua/neogit/lib/buffer.lua#L299
  -- "replace" | "tab" | "split" | "split_above" | "split_above_all" | "split_below" | "split_below_all" | "vsplit" | "vsplit_left" | "floating" | "floating_console" | "popup" | "auto"
  --   - for "auto": vsplit if window would have 80 cols, otherwise split
  kind = "floating",

  signs = {
    -- { CLOSED, OPENED }
    section = { "", "" },
    item = { "", "" },
    hunk = { "", "" },
  },

  integrations = {
    telescope = nil,
    mini_pick = nil,
    diffview = true,
    fzf_lua = true,
  },

  sections = {
    sequencer = { -- reverting/cherry-picking
      folded = false,
      hidden = false,
    },
    untracked = {
      folded = false,
      hidden = false,
    },
    unstaged = {
      folded = false,
      hidden = false,
    },
    staged = {
      folded = false,
      hidden = false,
    },
    stashes = {
      folded = true,
      hidden = false,
    },
    unpulled_upstream = {
      folded = true,
      hidden = false,
    },
    unmerged_upstream = {
      folded = false,
      hidden = false,
    },
    unpulled_pushRemote = {
      folded = true,
      hidden = false,
    },
    unmerged_pushRemote = {
      folded = false,
      hidden = false,
    },
    recent = {
      folded = true,
      hidden = false,
    },
    rebase = {
      folded = true,
      hidden = false,
    },
  },

  -- ========== Popup Options ==========
  remember_settings = false, -- persist the values of switches/options within and across sessions
  use_per_project_settings = true, -- scope persisted settings on a per-project basis
  ignored_settings = { -- table of settings to never persist. Uses format "Filetype--cli-value"
    "NeogitPushPopup--force-with-lease",
    "NeogitPushPopup--force",
    "NeogitPullPopup--rebase",
    "NeogitCommitPopup--allow-empty",
    "NeogitRevertPopup--no-edit",
  },

  popup = {
    kind = "floating",
  },

  -- ========== Buffer  Options ==========
  status = {
    -- "Head" section at top of status buffer
    show_head_commit_hash = true,
    recent_commit_count = 10,
    HEAD_padding = 10,
    HEAD_folded = false,

    mode_padding = 3,
    mode_text = {
      M = "modified",
      N = "new file",
      A = "added",
      D = "deleted",
      C = "copied",
      U = "updated",
      R = "renamed",
      DD = "unmerged",
      AU = "unmerged",
      UD = "unmerged",
      UA = "unmerged",
      DU = "unmerged",
      AA = "unmerged",
      UU = "unmerged",
      ["?"] = "",
    },
  },
  commit_editor = {
    kind = "tab",
    show_staged_diff = true,
    -- Accepted values:
    -- "split" to show the staged diff below the commit editor
    -- "vsplit" to show it to the right
    -- "split_above" Like :top split
    -- "vsplit_left" like :vsplit, but open to the left
    -- "auto" "vsplit" if window would have 80 cols, otherwise "split"
    staged_diff_split_kind = "split",
    spell_check = true,
  },
  commit_select_view = {
    kind = "floating",
  },
  commit_view = {
    kind = "floating",
    -- verify_commit = vim.fn.executable("gpg") == 1,
  },
  log_view = {
    kind = "tab",
  },
  rebase_editor = {
    kind = "auto",
  },
  reflog_view = {
    kind = "tab",
  },
  merge_editor = {
    kind = "auto",
  },
  description_editor = {
    kind = "auto",
  },
  tag_editor = {
    kind = "auto",
  },
  preview_buffer = {
    kind = "floating_console",
  },
  stash = {
    kind = "tab",
  },
  refs_view = {
    kind = "tab",
  },

  -- ========== Keybinds ==========
  use_default_keymaps = false,
  mappings = {
    commit_editor = {
      -- ["q"] = "Close",
      -- ["<m-p>"] = "PrevMessage",
      -- ["<m-n>"] = "NextMessage",
      -- ["<m-r>"] = "ResetMessage",
      -- ["<c-c><c-c>"] = "Submit",
      -- ["<c-c><c-k>"] = "Abort",
    },
    commit_editor_I = {
      -- ["<c-c><c-c>"] = "Submit",
      -- ["<c-c><c-k>"] = "Abort",
    },

    rebase_editor = {
      -- ["p"] = "Pick",
      -- ["r"] = "Reword",
      -- ["e"] = "Edit",
      -- ["s"] = "Squash",
      -- ["f"] = "Fixup",
      -- ["x"] = "Execute",
      -- ["d"] = "Drop",
      -- ["b"] = "Break",
      -- ["q"] = "Close",
      ["<cr>"] = "OpenCommit",
      -- ["gk"] = "MoveUp",
      -- ["gj"] = "MoveDown",
      -- ["<c-c><c-c>"] = "Submit",
      -- ["<c-c><c-k>"] = "Abort",
      -- ["[c"] = "OpenOrScrollUp",
      -- ["]c"] = "OpenOrScrollDown",
    },
    rebase_editor_I = {
      -- ["<c-c><c-c>"] = "Submit",
      -- ["<c-c><c-k>"] = "Abort",
    },

    finder = {
      ["<cr>"] = "Select",
      ["<c-c>"] = "Close",
      ["<esc>"] = "Close",
      ["<c-n>"] = "Next",
      ["<c-p>"] = "Previous",
      ["<down>"] = "Next",
      ["<up>"] = "Previous",
      ["<tab>"] = "InsertCompletion",
      ["<space>"] = "MultiselectToggleNext",
      ["<s-space>"] = "MultiselectTogglePrevious",
      ["<c-j>"] = "NOP",
      ["<ScrollWheelDown>"] = "ScrollWheelDown",
      ["<ScrollWheelUp>"] = "ScrollWheelUp",
      ["<ScrollWheelLeft>"] = "NOP",
      ["<ScrollWheelRight>"] = "NOP",
      ["<LeftMouse>"] = "MouseClick",
      ["<2-LeftMouse>"] = "NOP",
    },

    popup = {
      ["g?"] = "HelpPopup",
      -- to sort based on popup name: `:sort / = /`
      ["<LocalLeader>B"] = "BisectPopup",
      ["<LocalLeader>b"] = "BranchPopup",
      ["<LocalLeader>C"] = "CherryPickPopup",
      ["<LocalLeader>c"] = "CommitPopup",
      ["<LocalLeader>d"] = "DiffPopup",
      ["<LocalLeader>f"] = "FetchPopup",
      ["<LocalLeader>i"] = "IgnorePopup",
      ["<LocalLeader>l"] = "LogPopup",
      ["<LocalLeader>m"] = "MergePopup",
      ["<LocalLeader>p"] = "PullPopup",
      ["<LocalLeader>P"] = "PushPopup",
      ["<LocalLeader>r"] = "RebasePopup",
      ["<LocalLeader>M"] = "RemotePopup",
      ["<LocalLeader>x"] = "ResetPopup",
      ["<LocalLeader>R"] = "RevertPopup",
      ["<LocalLeader>$"] = "StashPopup",
      ["<LocalLeader>t"] = "TagPopup",
      ["<LocalLeader>w"] = "WorktreePopup",
    },

    status = {
      -- ["j"] = "MoveDown", -- skips empty lines between sections
      -- ["k"] = "MoveUp", -- skips empty lines between sections
      -- ["q"] = "Close",
      -- ["I"] = "InitRepo",

      -- ["o"] = "OpenTree",
      -- ["<LocalLeader>1"] = "Depth1",
      -- ["<LocalLeader>2"] = "Depth2",
      -- ["<LocalLeader>3"] = "Depth3",
      -- ["<LocalLeader>4"] = "Depth4",
      ["zx"] = "Depth4",
      -- ["<tab>"] = "Toggle",

      ["!"] = "Command",
      ["<LocalLeader>q:"] = "CommandHistory",

      ["x"] = "Discard",
      ["s"] = "Stage",
      -- ["S"] = "StageUnstaged",
      ["S"] = "StageAll",
      ["u"] = "Unstage",
      ["U"] = "UnstageStaged",
      ["K"] = "Untrack",

      ["r"] = "ShowRefs",
      ["Y"] = "YankSelected",
      ["<C-r>"] = "RefreshBuffer",

      ["<CR>"] = "GoToFile",
      ["<C-s>"] = "VSplitOpen",
      ["<C-S-s>"] = "SplitOpen",
      ["<C-t>"] = "TabOpen",

      ["[["] = "GoToPreviousHunkHeader",
      ["]]"] = "GoToNextHunkHeader",
    },
  },
})

-- https://github.com/NeogitOrg/neogit/blob/63124cf520ff24d09deb3b850e053908ab0fc66a/lua/neogit.lua#L117
