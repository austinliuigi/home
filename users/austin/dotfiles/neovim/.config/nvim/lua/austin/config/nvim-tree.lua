require("nvim-tree").setup {
  auto_reload_on_write = true,
  create_in_closed_folder = false,
  disable_netrw = false,
  hijack_cursor = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  ignore_buffer_on_setup = false,
  open_on_setup = false,
  open_on_setup_file = false,
  open_on_tab = false,
  ignore_buf_on_tab_change = {},
  sort_by = "case_sensitive",
  root_dirs = {},
  prefer_startup_root = false,
  sync_root_with_cwd = true,
  reload_on_bufenter = false,
  respect_buf_cwd = false,
  on_attach = "disable", -- function(bufnr). If nil, will use the deprecated mapping strategy
  remove_keymaps = false, -- boolean (disable totally or not) or list of key (lhs)
  view = {
    adaptive_size = false,
    centralize_selection = false,
    width = 30,
    hide_root_folder = false,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = true,
    signcolumn = "yes",
    -- @deprecated
    mappings = {
      custom_only = true,
      list = {
        -- user mappings go here
        { key = '<CR>',   action = 'edit' },
        { key = 'cd',     action = 'cd' },
        { key = 'a',      action = 'create' },
        { key = 'd',      action = 'remove' },
        { key = 'f',      action = 'search_node' },
        { key = 'h',      action = 'close_node' },
        { key = 'l',      action = 'edit' },
        { key = 'q',      action = 'close' },
        { key = 'r',      action = 'rename' },
        { key = '<Tab>',  action = 'toggle_mark' },
        { key = 'm', action = 'move', action_cb = function()
          local marks = require("nvim-tree.marks").get_marks()
          if #marks == 0 then
            require("nvim-tree.actions.fs.rename-file").fn(":p")()
          else
            require("nvim-tree.marks.bulk-move").bulk_move()
          end
        end },
        { key = '<C-t>',  action = 'tabnew' },
        { key = '<C-v>',  action = 'vsplit' },
        { key = 'y',      action = 'copy_path' },
        { key = 'Y',      action = 'copy_absolute_path' },
        { key = '<C-y>',  action = 'copy' },
        { key = '<C-x>',  action = 'split' },
        { key = 'g?',     action = 'toggle_help' }
      },
    },
    float = {
      enable = false,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 30,
        height = 30,
        row = 1,
        col = 1,
      },
    },
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    highlight_git = false,
    full_name = false,
    highlight_opened_files = "none",
    root_folder_modifier = ":~",
    indent_width = 2,
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "signcolumn",
      padding = " ",
      symlink_arrow = "  ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "~",
          -- unstaged = "",
          staged = "+",
          -- staged = "",
          unmerged = "",
          renamed = "﬍",
          untracked = "?",
          -- untracked = "",
          deleted = "﫧",
          ignored = "◌",
        },
      },
    },
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
    symlink_destination = true,
  },
  -- Open nvim-tree when opening dir in neovim
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  -- Show file in nvim-tree after BufEnter-ing (:e <file>)
  update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = {},
  },
  ignore_ft_on_setup = {},
  system_open = {
    cmd = "",
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    debounce_delay = 50,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
  },
  git = {
    enable = true,
    ignore = true,
    show_on_dirs = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    expand_all = {
      max_folder_discovery = 300,
      exclude = {},
    },
    file_popup = {
      open_win_config = {
        col = 1,
        row = 1,
        relative = "cursor",
        border = "shadow",
        style = "minimal",
      },
    },
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
    remove_file = {
      close_window = true,
    },
  },
  trash = {
    cmd = "gio trash",
    require_confirm = true,
  },
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = true,
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      dev = false,
      diagnostics = false,
      git = false,
      profile = false,
      watcher = false,
    },
  },
}
