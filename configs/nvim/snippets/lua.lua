local snippets = {
  s("snippet", fmt([[
    local snippets = {{
      {}
    }}

    return snippets
  ]], {
    i(0)
  }), {
    condition = function()
      local dir = vim.fn.split(vim.fn.expand("%:p:h"), "/")
      return dir[#dir] == "snippets"
    end,
    show_condition = function()
      local dir = vim.fn.split(vim.fn.expand("%:p:h"), "/")
      return dir[#dir] == "snippets"
    end,
  }),

  s("snip", fmt([=[
    s("{}", fmt([[
      {}
    ]], {{
      {}
    }})),
  ]=], {
    i(1),
    i(2),
    i(0),
  }), {
    condition = function()
      local dir = vim.fn.split(vim.fn.expand("%:p:h"), "/")
      return dir[#dir] == "snippets"
    end,
    show_condition = function()
      local dir = vim.fn.split(vim.fn.expand("%:p:h"), "/")
      return dir[#dir] == "snippets"
    end,
  }),

  s("autocmd", fmt([[
    vim.api.nvim_create_augroup("{}", {{clear = true}})
    vim.api.nvim_create_autocmd({{ "{}" }}, {{
      group   = "{}",
      pattern = {{'{}'}},
      callback = function()
        {}
      end,
    }})
  ]], {
    i(1),
    i(2, "BufEnter"),
    rep(1),
    i(3, "*"),
    i(0),
  })),
}

return snippets
