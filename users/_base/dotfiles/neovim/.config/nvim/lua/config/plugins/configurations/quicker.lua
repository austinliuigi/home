-- autosave logic: https://github.com/stevearc/quicker.nvim/blob/51d3926f183c2d98fbc237cc237ae0926839af3a/lua/quicker/editor.lua#L280-L286
-- error detection logic: https://github.com/stevearc/quicker.nvim/blob/51d3926f183c2d98fbc237cc237ae0926839af3a/lua/quicker/editor.lua#L237-L251
-- syncing logic: https://github.com/stevearc/quicker.nvim/blob/51d3926f183c2d98fbc237cc237ae0926839af3a/lua/quicker/context.lua#L267-L292
-- defers to vim's internal syncing since it essentially just calls vim.fn.getqflist?
require("quicker").setup({
  keys = {
    {
      "+",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "-",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  },
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    require("quicker").refresh()
  end,
})
