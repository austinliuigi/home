local fs = require("scripts.utils.fs")

---@param dir string
local function strip_trailing_sep(dir)
  if string.sub(dir, -1, -1) == "/" then
    dir = string.sub(dir, 1, -2)
  end
  return dir
end

--- Create directory tree window
--  TODO: update on filesystem change
vim.api.nvim_create_user_command("Tree", function(attrs)
  local dir = attrs.fargs[1] or "."
  dir = strip_trailing_sep(vim.fn.fnamemodify(vim.fn.expand(dir), ":p"))

  local tree = fs.Tree:create(dir)
  if tree == nil then
    print(string.format("Tree: Directory `%s` does not exist", dir))
    return
  end

  local bufnr, node_map = tree:output_to_buffer()
  vim.api.nvim_set_current_buf(bufnr)
  vim.bo[bufnr].modifiable = false

  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = 'v:lua.require("scripts.utils.fs").Tree.foldexpr()'

  vim.keymap.set("n", "<CR>", function()
    local linenr = vim.api.nvim_win_get_cursor(0)[1]
    local node = node_map[linenr]
    if node.type == "directory" then
      vim.bo.modifiable = true
      _, node_map = node:output_to_buffer(bufnr)
      vim.bo.modifiable = false
    else
      vim.cmd("edit " .. node.path)
    end
  end, { buffer = bufnr })
end, { nargs = "?" })

-- inotify on linux doesn't natively support recursive directory watching
--   - libuv doesn't support recursive watching: https://github.com/libuv/libuv/issues/1778
--   - filewatching megathread: https://github.com/neovim/neovim/issues/1380#issuecomment-64184368
--   - related thread: https://github.com/neovim/neovim/issues/23291#issuecomment-1536968751
-- vim._watch source:
--   - https://github.com/neovim/neovim/blob/b922b7d6d7889cce863540df7b0da7d512f8a2a1/runtime/lua/vim/_watch.lua#L127
--   - https://github.com/neovim/neovim/blob/9d9ee34/runtime/lua/vim/lsp/_watchfiles.lua#L10-L16
vim._watch.watchdirs(
  "/home/austin/.config/home-manager/users/_base/dotfiles/neovim/.config/nvim/lua/scripts/diff/test",
  {},
  function(path, change_type)
    -- file 4913: https://github.com/neovim/neovim/issues/3460
    if (change_type == 1 or change_type == 3) and vim.fs.basename(path) ~= "4913" then
      vim.print(path)
      vim.print(change_type)
    end
  end
)
