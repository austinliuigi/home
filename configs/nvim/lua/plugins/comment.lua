function _comment_toggle(type)
  -- Run this only when called with mapping (not dot-repeat)
  if type == nil then
    vim.o.operatorfunc = "v:lua._comment_toggle"
    return "g@"
  end

  vim.cmd([[keeppatterns '[,']g/./lua require('Comment.api').toggle.linewise.current()]])
end

return {
  {
    'numToStr/Comment.nvim',
    keys = {
      { "gc", mode = {"n", "x"}},
      { "gb", mode = {"n", "x"}},
      { "gC", mode = {"n", "x"}},
    },
    config = function()
      require("Comment").setup({
        padding = true, ---Add a space b/w comment and the line
        sticky = true, ---Whether the cursor should stay at its position
        ignore = nil, ---Lines to be ignored while (un)comment
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
            line = 'gcc',
            block = 'gbc',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            line = 'gc',
            block = 'gb',
        },
        ---LHS of extra mappings
        extra = {
            above = 'gcO',
            below = 'gco',
            eol = 'gcA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = true,
        },
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(), ---Function to call before (un)comment
        post_hook = nil, ---Function to call after (un)comment
      })

      vim.keymap.set({"n", "x"}, "gC", function()
        return _comment_toggle()
      end, { expr = true })
    end
  },
}
