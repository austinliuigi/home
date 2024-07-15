-- note: oil will still open if nvim was started with a directory as an arg
--   - https://github.com/stevearc/oil.nvim/blob/10fbfdd37b6904c0776c5db1a27ab47eecba335e/lua/oil/init.lua#L1293C1-L1298C6

return {
  "oil.nvim",
  event = "DeferredUIEnter",
}
