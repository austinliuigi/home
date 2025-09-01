local actions = require("fzf-lua").actions

require("fzf-lua").setup({
  -- =============== GENERAL OPTIONS ===============
  fzf_bin = "fzf",

  -- --------------- UI Options ---------------
  winopts = {
    treesitter = {
      enabled = true,
    },
    preview = {
      default = "builtin", -- picker-specific options can override this
    },
  },

  -- --------------- Neovim & FZF keybinds ---------------
  keymap = {
    -- to inherit default mappings, set [1] to `true`
    builtin = {
      -- neovim `:tmap` mappings for the fzf win
      false,
    },
    fzf = {
      -- fzf '--bind=' options
      false,
    },
  },

  -- --------------- FZF "accept" binds ---------------
  actions = {
    -- to inherit default actions, set [1] to `true`
    files = {
      false,
      -- Pickers inheriting these actions:
      --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
      --   tags, btags, args, buffers, tabs, lines, blines
      -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
      -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
      -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
      ["enter"] = actions.file_edit_or_qf,
      -- ["ctrl-shift-s"] = actions.file_split, -- https://github.com/junegunn/fzf/issues/2867
      ["ctrl-s"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      -- ["ctrl-q"] = actions.file_sel_to_qf,
      ["ctrl-q"] = { fn = actions.file_sel_to_qf, prefix = "select-all+" },
      -- ["ctrl-shift-s"] = actions.file_sel_to_ll,
      -- ["ctrl-i"] = actions.toggle_ignore, -- note: ctrl-i is the same as tab in terminals
      ["ctrl-h"] = actions.toggle_hidden,
      ["ctrl-f"] = actions.toggle_follow,
    },
  },

  -- --------------- FZF cli flags ---------------
  -- fzf_opts = { ...  },    -- Fzf CLI flags
  -- fzf_colors = { ...  },  -- Fzf `--color` specification

  -- --------------- Flags ---------------
  -- previewers = { ...  },  -- Previewers options

  -- =============== PICKER OPTIONS ===============
  files = {
    -- (name from 'previewers' table)
    -- set to 'false' to disable
    -- previewer = "cat",

    multiprocess = true, -- run command in a separate process
    git_icons = false, -- show git icons?
    file_icons = true, -- show file icons (true|"devicons"|"mini")?
    color_icons = true, -- colorize file|git icons

    -- executed command priority is 'cmd' (if exists)
    -- otherwise auto-detect prioritizes `fd`:`rg`:`find`
    -- default options are controlled by '{fd,rg,find}_opts'
    -- cmd = "rg --files",
    fd_opts = [[--color=never --hidden --type f --type l --exclude .git]],
    rg_opts = [[--color=never --hidden --files -g "!.git"]],
    find_opts = [[-type f -not -path '*/\.git/*']],

    -- by default, cwd appears in the header only if {opts} contain a cwd
    -- parameter to a different folder than the current working directory
    -- uncomment if you wish to force display of the cwd as part of the
    -- query prompt string (fzf.vim style), header line or both
    -- cwd_header = true,
    cwd_prompt = true,
    cwd_prompt_shorten_len = 32, -- shorten prompt beyond this length
    cwd_prompt_shorten_val = 1, -- shortened path parts length
    toggle_ignore_flag = "--no-ignore", -- flag toggled in `actions.toggle_ignore`
    toggle_hidden_flag = "--hidden", -- flag toggled in `actions.toggle_hidden`
    toggle_follow_flag = "-L", -- flag toggled in `actions.toggle_follow`
    hidden = true, -- enable hidden files
    follow = false, -- follow symlinks
    no_ignore = false, -- do not respect ".gitignore"
    actions = {
      -- inherits from 'actions.files', here we can override
      -- or set bind to 'false' to disable a default action
      -- uncomment to override `actions.file_edit_or_qf`
      --   ["enter"]     = actions.file_edit,
      -- custom actions are available too
      --   ["ctrl-y"]    = function(selected) print(selected[1]) end,
    },
  },
  bcommits = {
    -- default preview shows a git diff vs the previous commit
    -- if you prefer to see the entire commit you can use:
    --   git show --color {1} --rotate-to={file}
    --   {1}    : commit SHA (fzf field index expression)
    --   {file} : filepath placement within the commands
    cmd = [[git log --color --pretty=format:"%C(yellow)%h%Creset ]]
      .. [[%Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset" {file}]],
    preview = "git show --color {1} -- {file}",
    -- git-delta is automatically detected as pager, uncomment to disable
    -- preview_pager = false,
    actions = {
      ["enter"] = actions.git_buf_edit,
      -- ["ctrl-shift-s"]  = actions.git_buf_split,
      ["ctrl-s"] = actions.git_buf_vsplit,
      ["ctrl-t"] = actions.git_buf_tabedit,
      ["ctrl-y"] = { fn = actions.git_yank_commit, exec_silent = true },
    },
  },
  blame = {
    cmd = [[git blame --color-lines {file}]],
    preview = "git show --color {1} -- {file}",
    preview_pager = false, -- git-delta is automatically detected as pager, set to false to disable
    actions = {
      ["enter"] = actions.git_goto_line,
      -- ["ctrl-shift-s"] = actions.git_buf_split,
      ["ctrl-s"] = actions.git_buf_vsplit,
      ["ctrl-t"] = actions.git_buf_tabedit,
      ["ctrl-y"] = { fn = actions.git_yank_commit, exec_silent = true },
    },
  },
  keymaps = {
    winopts = { preview = { layout = "vertical" } },
    fzf_opts = { ["--tiebreak"] = "index" },
    ignore_patterns = { "^<SNR>", "^<Plug>" }, -- set to false to disable filtering
    show_desc = true,
    show_details = true,
    actions = {
      ["enter"] = actions.keymap_apply,
      -- ["ctrl-shift-s"] = actions.keymap_split,
      ["ctrl-s"] = actions.keymap_vsplit,
      ["ctrl-t"] = actions.keymap_tabedit,
    },
  },
})

-- require("fzf-lua").register_ui_select()

--==================================================================================================
-- Collect all commands
--==================================================================================================

local M

local builtins = {}
for command, func in pairs(require("fzf-lua")) do
  if require("fzf-lua")._excluded_metamap[command] == nil then
    builtins[command] = func
  end
end
M = builtins

vim.keymap.set({ "n", "x", "i" }, "<C-/>", function()
  require("fzf-lua").fzf_exec(vim.tbl_keys(M), {
    actions = {
      ["default"] = function(selected)
        if #selected > 0 then
          M[selected[1]]()
        end
      end,
    },
  })
end, { remap = false })

return M
