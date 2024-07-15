return {
  "neorg",
  -- TODO: make this DeferredUIEnter after neorg removes nvim-treesitter dependency
  event = "User TreesitterLoadPost",
  before = function()
    vim.cmd("packadd! nvim-cmp") -- for completion engine in config
  end,
}
