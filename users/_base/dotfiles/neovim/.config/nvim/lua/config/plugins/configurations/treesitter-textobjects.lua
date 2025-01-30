require("nvim-treesitter-textobjects").init()
require("nvim-treesitter.configs").setup({
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["ia"] = "@parameter.inner",
        ["aa"] = "@parameter.outer",
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",
        ["ic"] = "@class.inner",
        ["ac"] = "@class.outer",
      },
      selection_modes = {
        ["@parameter.inner"] = "v", -- charwise
        ["@parameter.outer"] = "v", -- charwise
        ["@function.inner"] = "V", -- linewise
        ["@function.outer"] = "V", -- linewise
        ["@class.inner"] = "V", -- linewise
        ["@class.outer"] = "V", -- linewise
      },
      include_surrounding_whitespace = false, -- include whitespace in "around" textobjects
    },
  },
})

-- require("nvim-treesitter-textobjects").setup({
--   select = {
--     -- Automatically jump forward to textobj, similar to targets.vim
--     lookahead = true,
--     selection_modes = {
--       ["@parameter.inner"] = "v", -- charwise
--       ["@parameter.outer"] = "v", -- charwise
--       ["@function.inner"] = "V", -- linewise
--       ["@function.outer"] = "V", -- linewise
--       ["@class.inner"] = "V", -- linewise
--       ["@class.outer"] = "V", -- linewise
--     },
--     -- If you set this to `true` (default is `false`) then any textobject is
--     -- extended to include preceding or succeeding whitespace. Succeeding
--     -- whitespace has priority in order to act similarly to eg the built-in
--     -- `ap`.
--     include_surrounding_whitespace = false,
--   },
-- })
--
-- print("meow")
--
-- vim.keymap.set({ "x", "o" }, "ia", function()
--   require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
-- end)
-- vim.keymap.set({ "x", "o" }, "aa", function()
--   require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
-- end)
-- vim.keymap.set({ "x", "o" }, "if", function()
--   require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
-- end)
-- vim.keymap.set({ "x", "o" }, "af", function()
--   require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
-- end)
-- vim.keymap.set({ "x", "o" }, "ic", function()
--   require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
-- end)
-- vim.keymap.set({ "x", "o" }, "ac", function()
--   require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
-- end)
