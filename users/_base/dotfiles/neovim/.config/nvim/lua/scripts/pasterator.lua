--==========================================================================================
-- Paste operator for vim
--   - NOTE: we do the paste using vim.api.nvim_buf_set_text rather than vim.cmd("normal! ...")
--     because the latter would override the g@ operator to be used for the dot operator
--==========================================================================================
local pasterator = {}

local curswant = 0
local paste_key = "p"
function pasterator.paste(motion)
  if motion == nil then
    vim.o.operatorfunc = "v:lua.require'scripts.pasterator'.paste" -- https://github.com/neovim/neovim/issues/14157
    curswant = vim.fn.getcurpos()[5] -- for block mode; need to store curswant here b/c the cursor moves to beginning of range after g@ is executed
    return "g@"
  end

  -- get replacement text from supplied register if one was provided
  local replacement_lines = vim.fn.getreg(vim.v.register, nil, true)

  -- copy text to default register before replacing
  local motion_to_vchar = {
    char = "v",
    line = "V",
    block = "",
  }
  if paste_key == "p" then
    vim.cmd("normal! `[" .. motion_to_vchar[motion] .. "`]y")
  end

  -- replace text
  --------------------------------------------------------------------------------------------
  -- convert line to row so it zero-indexed like the vim api expects
  local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, "["))
  local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, "]"))
  local start_row = start_line - 1
  local end_row = end_line - 1
  -- perform replacements
  if motion == "char" then
    vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col + 1, replacement_lines)
  elseif motion == "line" then
    vim.api.nvim_buf_set_text(0, start_row, 0, end_row, -1, replacement_lines)
  elseif motion == "block" then
    for row = start_row, end_row do
      if curswant == vim.v.maxcol then
        end_col = #vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] - 1
      end
      vim.api.nvim_buf_set_text(0, row, start_col, row, end_col + 1, { replacement_lines[row - start_row + 1] })
    end
  end
end

vim.keymap.set({ "n", "x" }, "gp", function()
  paste_key = "p"
  return pasterator.paste()
end, { expr = true })

vim.keymap.set({ "n", "x" }, "gP", function()
  paste_key = "P"
  return pasterator.paste()
end, { expr = true })

vim.keymap.set({ "n" }, "gpp", "Vgp", { remap = true })

vim.keymap.set({ "n" }, "gPP", "VgP", { remap = true })

return pasterator
