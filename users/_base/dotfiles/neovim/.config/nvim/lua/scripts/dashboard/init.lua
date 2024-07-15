local function create_dashboard_buffer()
  local headers = require("scripts.dashboard.headers")
  math.randomseed(os.time())
  local header = headers[math.random(#headers)]
  -- buftype
  -- buflisted
  -- draw:
  --   - https://github.com/goolord/alpha-nvim/blob/41283fb402713fc8b327e60907f74e46166f4cfd/lua/alpha.lua#L614C1-L641C4
  -- redraw:
  --   - https://github.com/goolord/alpha-nvim/blob/41283fb402713fc8b327e60907f74e46166f4cfd/lua/alpha.lua#L530C1-L542C19
  --   - use VimResized
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() ~= 0 then
      create_dashboard_buffer()
    end
  end,
})
