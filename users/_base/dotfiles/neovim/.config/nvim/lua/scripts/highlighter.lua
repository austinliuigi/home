local highlighter = {
  ns = vim.api.nvim_create_namespace("Highlighter"),
}

local curswant = 0
function highlighter.highlight(motion)
  if motion == nil then
    vim.o.operatorfunc = "v:lua.require'scripts.highlighter'.highlight" -- https://github.com/neovim/neovim/issues/14157
    curswant = vim.fn.getcurpos()[5] -- for block mode; need to store here b/c cursor moves to beginning of range after g@ is executed
    return "g@"
  end

  -- line is one-based, row and col are zero-based
  local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, "["))
  local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, "]"))
  local start_row = start_line - 1
  local end_row = end_line - 1

  vim.api.nvim_buf_clear_namespace(0, highlighter.ns, 0, -1)

  if motion == "char" then
    vim.api.nvim_buf_set_extmark(0, highlighter.ns, start_row, start_col, {
      end_row = end_row,
      end_col = end_col + 1,
      hl_group = "Highlighter",
    })
  elseif motion == "line" then
    vim.api.nvim_buf_set_extmark(0, highlighter.ns, start_row, 0, {
      end_row = end_row + 1,
      end_col = 0,
      hl_group = "Highlighter",
      hl_eol = true,
    })
  elseif motion == "block" then
    for row = start_row, end_row do
      if curswant == vim.v.maxcol then
        end_col = vim.fn.strdisplaywidth(vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]) - 1
      end
      vim.api.nvim_buf_set_extmark(0, highlighter.ns, row, start_col, {
        end_col = end_col + 1,
        hl_group = "Highlighter",
        strict = false,
      })
    end
  end

  -- gotcha: end_col doesn't include eol character in char mode but does in block mode
  -- vim.print(motion)
  -- vim.print("start: ", unpack(vim.api.nvim_buf_get_mark(0, "[")))
  -- vim.print("end: ", unpack(vim.api.nvim_buf_get_mark(0, "]")))
end

function highlighter.clear()
  vim.api.nvim_buf_clear_namespace(0, highlighter.ns, 0, -1)
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local dye = require("dye")
    vim.api.nvim_set_hl(0, "Highlighter", { bg = dye.CursorLine.bg.blend(dye.Normal.bg.hsl, 0.5).hex })
  end,
})

vim.keymap.set({ "n", "x" }, "gh", highlighter.highlight, { expr = true })
vim.keymap.set({ "n" }, "ghc", highlighter.clear, {})

return highlighter
