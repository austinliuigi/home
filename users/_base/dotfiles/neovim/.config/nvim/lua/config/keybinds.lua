local keymap = vim.keymap.set
toggle_key = "\\"

-- Mapping Functions {{{

vim.cmd([[
  function! ToggleSpaceChar()
      if stridx(&listchars, "space") <= 0
          set listchars+=space:⋅
      else
          set listchars-=space:⋅
      endif
  endfunction
  command! ToggleSpaceChar call ToggleSpaceChar()

  function! ToggleConcealLevel()
      let &l:concealevel = &l:concealevel ? 0 : 2
  endfunction
  command! ToggleConcealLevel call ToggleConcealLevel()
]])

---@param direction "h"|"j"|"k"|"l"
local function swap_window(direction)
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()

  -- open current buf in target window
  vim.cmd("wincmd " .. direction)
  local target_win = vim.api.nvim_get_current_win()
  local target_buf = vim.api.nvim_get_current_buf()

  if target_win == current_win then -- early exit
    return
  end

  vim.api.nvim_win_set_buf(0, current_buf)

  -- open target buf in current window
  vim.api.nvim_set_current_win(current_win)
  vim.api.nvim_win_set_buf(0, target_buf)

  -- switch to target window
  vim.api.nvim_set_current_win(target_win)
end

-- }}}

-- Leader key {{{

vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<leader>", "<nop>", { noremap = true })

-- }}}
-- Motion mappings {{{

keymap({ "n", "x" }, "k", "v:count ? 'k' : 'gk'", { noremap = true, expr = true })

keymap({ "n", "x" }, "j", "v:count ? 'j' : 'gj'", { noremap = true, expr = true })

keymap({ "n", "x" }, "0", function()
  return vim.o.wrap and "g0" or "0"
end, { expr = true })

keymap({ "n", "x" }, "$", function()
  -- determines if current line is wrapped
  local is_wrapped = vim.api.nvim_win_text_height(0, {
    start_row = (vim.fn.line(".") - 1),
    end_row = (vim.fn.line(".") - 1),
    start_vcol = 0,
  })["all"] > 1

  if is_wrapped then
    return "g$"
  end
  return "$"
end, { expr = true })

keymap({ "n", "x" }, "<leader><C-u>", function()
  local count = math.floor(vim.fn.winheight(0) / 4 + 0.5)
  return count .. "<C-u><cmd>set scroll=0<CR>"
end, { remap = true, expr = true, desc = "Scroll up a quarter of the screen height" })

keymap({ "n", "x" }, "<leader><C-d>", function()
  local count = math.floor(vim.fn.winheight(0) / 4 + 0.5)
  return count .. "<C-d><cmd>set scroll=0<CR>"
end, { remap = true, expr = true, desc = "Scroll down a quarter of the screen height" })

keymap({ "n", "x" }, "g/", function()
  local cursor_line = vim.fn.line(".")
  local win_bot_line = vim.fn.line("w$")

  return "/\\%>" .. (cursor_line - 1) .. "l\\%<" .. (win_bot_line + 1) .. "l"
end, { remap = false, expr = true, desc = "Search forwards from the cursor to the bottom of the visible screen" })

keymap({ "n", "x" }, "g?", function()
  local win_top_line = vim.fn.line("w0")
  local cursor_line = vim.fn.line(".")

  return "?\\%>" .. (win_top_line - 1) .. "l\\%<" .. (cursor_line + 1) .. "l"
end, { remap = false, expr = true, desc = "Search backwards from the cursor to the top of the visible screen" })

keymap({ "n", "x" }, "n", function()
  local char
  if vim.v.searchforward == 0 then
    char = "N"
  else
    char = "n"
  end
  return char
end, { expr = true, remap = false })

keymap({ "n", "x" }, "N", function()
  local char
  if vim.v.searchforward == 0 then
    char = "n"
  else
    char = "N"
  end
  return char
end, { expr = true, remap = false })

keymap({ "n", "x" }, "<leader>n", "nzz", { remap = true })

keymap({ "n", "x" }, "<leader>N", "Nzz", { remap = true })

keymap({ "n", "x" }, "*", "*N", { remap = false })

keymap({ "n", "x" }, "#", "#N", { remap = false })

-- }}}
-- Register mappings {{{

keymap({ "n", "x" }, "<leader>c", "c", { noremap = true })

keymap({ "n", "x" }, "<leader>C", "C", { noremap = true })

keymap({ "n", "x" }, "<leader>d", "d", { noremap = true })

keymap({ "n", "x" }, "<leader>D", "D", { noremap = true })

keymap({ "n", "x" }, "<leader>s", "s", { noremap = true })

keymap({ "n", "x" }, "<leader>S", "S", { noremap = true })

keymap({ "n", "x" }, "<leader>x", "x", { noremap = true })

keymap({ "n", "x" }, "<leader>X", "X", { noremap = true })

keymap({ "n", "x" }, "c", '"_c', { noremap = true })

keymap({ "n", "x" }, "C", '"_C', { noremap = true })

keymap({ "n", "x" }, "d", '"_d', { noremap = true })

keymap({ "n", "x" }, "D", '"_D', { noremap = true })

keymap({ "n", "x" }, "s", '"_s', { noremap = true })

keymap({ "n", "x" }, "S", '"_S', { noremap = true })

keymap({ "n", "x" }, "x", '"_x', { noremap = true })

keymap({ "n", "x" }, "X", '"_X', { noremap = true })

keymap({ "n" }, "<leader>V", "V<leader>", { remap = true })

-- }}}

-- Buffer list mappings {{{

keymap("n", "]b", "<cmd>bn<CR>", { noremap = true, silent = true })

keymap("n", "[b", "<cmd>bp<CR>", { noremap = true, silent = true })

keymap("n", toggle_key .. "b", "<cmd>b#<CR>", { noremap = true, silent = true, desc = "Switch to alternate buffer" })

keymap("n", "<leader><leader>b", ":ls<CR>:b<Space>", { noremap = true, silent = true })

-- }}}
-- Argument list mappings {{{

keymap("n", "]a", "<cmd>n!<CR>", { noremap = true, silent = true })

keymap("n", "[a", "<cmd>N!<CR>", { noremap = true, silent = true })

keymap("n", "<leader><leader>a", "<cmd>args<CR>", { noremap = true, silent = true })

-- }}}
-- Quickfix list mappings {{{

keymap("n", "]c", "<cmd>cn<CR>", { noremap = true, silent = true })

keymap("n", "[c", "<cmd>cp<CR>", { noremap = true, silent = true })

keymap("n", toggle_key .. "c", function()
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.fn.getwininfo(winid)[1].quickfix == 1 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("copen")
end, { noremap = true, silent = true, desc = "Toggle quickfix list" })

-- }}}
-- Local list mappings {{{

keymap("n", "]l", "<cmd>ln<CR>", { noremap = true, silent = true })

keymap("n", "[l", "<cmd>lp<CR>", { noremap = true, silent = true })

keymap("n", toggle_key .. "l", function()
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.fn.getwininfo(winid)[1].loclist == 1 then
      vim.cmd("lclose")
      return
    end
  end
  vim.cmd("lopen")
end, { noremap = true, silent = true, desc = "Toggle location list" })

-- }}}

-- Window mappings {{{

keymap({ "n" }, "<leader><C-h>", "<cmd>new<CR>", { noremap = true })

keymap({ "n" }, "<leader><C-v>", "<cmd>vnew<CR>", { noremap = true })

keymap({ "n", "i", "t" }, "<C-h>", "<cmd>wincmd h<CR>", { noremap = true })

keymap({ "n", "i", "t" }, "<C-j>", "<cmd>wincmd j<CR>", { noremap = true })

keymap({ "n", "i", "t" }, "<C-k>", "<cmd>wincmd k<CR>", { noremap = true })

keymap({ "n", "i", "t" }, "<C-l>", "<cmd>wincmd l<CR>", { noremap = true })

keymap({ "n", "i", "t" }, "<C-S-h>", function()
  swap_window("h")
end, { noremap = true })

keymap({ "n", "i", "t" }, "<C-S-j>", function()
  swap_window("j")
end, { noremap = true })

keymap({ "n", "i", "t" }, "<C-S-k>", function()
  swap_window("k")
end, { noremap = true })

keymap({ "n", "i", "t" }, "<C-S-l>", function()
  swap_window("l")
end, { noremap = true })

-- }}}
-- Tab mappings {{{

keymap({ "n" }, "<leader><C-t>", "<cmd>tabnew<CR>", { noremap = true })

keymap({ "n", "i", "t" }, "<C-,>", "<cmd>tabprev<CR>", { noremap = true, silent = true })

keymap({ "n", "i", "t" }, "<C-.>", "<cmd>tabnext<CR>", { noremap = true, silent = true })

keymap("n", "<C-S-,>", function()
  if vim.fn.tabpagenr() == 1 then
    vim.cmd("$tabmove")
  else
    vim.cmd("-tabmove")
  end
end, { noremap = true, silent = true })

keymap("n", "<C-S-.>", function()
  if vim.fn.tabpagenr() == vim.fn.tabpagenr("$") then
    vim.cmd("0tabmove")
  else
    vim.cmd("+tabmove")
  end
end, { noremap = true, silent = true })

keymap("n", "<leader><leader>t", ":tabs<CR>:tabn<Space>", { noremap = true, silent = true })

-- }}}

-- Toggle mappings {{{

keymap(
  "n",
  toggle_key .. "h",
  "v:hlsearch ? '<cmd>nohl<CR>' : '<cmd>set hlsearch<CR>'",
  { noremap = true, silent = true, expr = true, replace_keycodes = false, desc = "Toggle search highlighting" }
)

keymap(
  "n",
  toggle_key .. "L",
  "<cmd>ToggleSpaceChar<CR>",
  { noremap = true, silent = true, desc = "Toggle space characters" }
)

keymap("n", toggle_key .. "n", function()
  local prev_num = vim.o.number
  vim.o.number = not vim.o.relativenumber
  vim.o.relativenumber = prev_num and vim.o.number
end, { noremap = true, silent = true, desc = "Toggle line numbers (number -> relativenumber -> nonumber" })

keymap(
  "n",
  toggle_key .. "v",
  "empty(&virtualedit) ? '<cmd>set virtualedit+=all<CR>' : '<cmd>set virtualedit-=all<CR>'",
  { noremap = true, silent = true, expr = true, replace_keycodes = false, desc = "Toggle virtual edit" }
)

keymap("n", toggle_key .. "w", "<cmd>set wrap!<CR>", { noremap = true, silent = true, desc = "Toggle line wrap" })

keymap("n", toggle_key .. "B", function()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end, { noremap = true, silent = true, desc = "Toggle background theme" })

-- }}}

-- Normal mode mappings {{{

keymap(
  "n",
  "<leader>!",
  "<cmd>so %<CR><cmd>echohl GitSignsAdd | echo 'Sourced :)' | echohl None<CR>",
  { noremap = true, silent = false }
)

keymap("n", "<esc>", "<cmd>nohl<CR><cmd>echo ''<CR>", { noremap = true, silent = true })

keymap("n", "<C-\\>", function()
  if vim.fn.expand("%") == "" then
    return "<cmd>vnew .<CR>"
  end
  return "<cmd>vnew %:h<CR>"
end, { noremap = true, silent = true, expr = true })

keymap("n", "g<C-\\>", function()
  if vim.fn.expand("%") == "" then
    return "<cmd>e .<CR>"
  end
  return "<cmd>e %:h<CR>"
end, { noremap = true, silent = true, expr = true })

keymap("n", "<leader><C-\\>", function()
  if vim.fn.expand("%") == "" then
    return "<cmd>tabe .<CR>"
  end
  return "<cmd>tabe %:h<CR>"
end, { noremap = true, silent = true, expr = true })

keymap("n", "<leader>p", "<cmd>put<CR>", { noremap = true, silent = true })

keymap("n", "<leader>P", "<cmd>put!<CR>", { noremap = true, silent = true })

keymap("n", "zC", "zCvzC", { noremap = true })

keymap("n", "<C-]>", "<cmd>tcd %:p:h<CR>", {})

keymap("n", "<C-[>", "<cmd>tcd ..<CR>", {})

-- }}}
-- Insert mode mappings {{{

keymap(
  "i",
  "<S-Left>",
  "pumvisible() ? '<C-e>' : '<S-Left>'",
  { noremap = true, expr = true, replace_keycodes = false }
)

keymap(
  "i",
  "<S-Right>",
  "pumvisible() ? '<C-y>' : '<S-Right>'",
  { noremap = true, expr = true, replace_keycodes = false }
)

keymap("i", "<CR>", "pumvisible() ? '<C-e><CR>' : '<CR>'", { noremap = true, expr = true, replace_keycodes = false })

-- }}}
-- Visual mode mappings {{{

keymap("x", "<", "<gv", { noremap = true })

keymap("x", ">", ">gv", { noremap = true })

keymap("x", "<leader>/", "<esc>/\\%V", { noremap = true, desc = "Search forwards in visual selection" })

keymap("x", "<leader>?", "<esc>?\\%V", { noremap = true, desc = "Search backwards in visual selection" })

-- }}}
-- Terminal mode mappings {{{

keymap({ "n", "i", "t" }, "<C-CR>", "<cmd>vnew | term<CR>", { noremap = true })

keymap({ "n" }, "g<C-CR>", "<cmd>term<CR>", { noremap = true })

keymap({ "n" }, "<leader><C-CR>", "<cmd>tabnew | term<CR>", { noremap = true })

keymap("t", "<S-Esc>", "<C-\\><C-n>", { noremap = true })

-- }}}

-- Operator mappings {{{

-- toggle comments
function _comment_toggle(type)
  -- Run this only when called with mapping (not dot-repeat)
  if type == nil then
    vim.o.operatorfunc = "v:lua._comment_toggle"
    return "g@"
  end

  vim.cmd([[keeppatterns '[,']g/./normal gcc]])
end

vim.keymap.set({ "n", "x" }, "<leader>gc", function()
  return _comment_toggle()
end, { expr = true })

-- visual previously pasted text
vim.keymap.set("n", "gp", function()
  local visual = string.sub(vim.fn.getregtype(), 1, 1)
  if visual == "" then
    return "`[<C-v>`]"
  end
  return "`[" .. visual .. "`]"
end, { expr = true })

-- open uri
-- if vim.fn.has("mac") == 1 then
--   vim.keymap.set({ "n" }, "gx", function()
--     vim.fn.jobstart({ "open", vim.fn.expand("<cfile>") }, { detach = true })
--   end)
--   -- TODO: implement when get_visual_selection is implemented (https://github.com/neovim/neovim/pull/13896)
--   -- vim.keymap.set({"x"}, "gx", function()
--   -- vim.fn.jobstart({"open", get_visual_selection(),}, {detach = true})
--   -- end)
-- elseif vim.fn.has("unix") == 1 then
--   vim.keymap.set({ "n" }, "gx", function()
--     vim.fn.jobstart({ "xdg-open", vim.fn.expand("<cfile>") }, { detach = true })
--   end)
--   -- TODO: implement when get_visual_selection is implemented (https://github.com/neovim/neovim/pull/13896)
--   -- vim.keymap.set({"x"}, "gx", function()
--   -- vim.fn.jobstart({"xdg-open", get_visual_selection(),}, {detach = true})
--   -- end)
-- else
--   vim.keymap.set({ "n", "x" }, "gx", function()
--     print("Error: gx is not supported on this OS!")
--   end)
-- end

-- }}}

-- Misc {{{

-- Unbind <CR> in command line window
vim.api.nvim_create_autocmd("CmdwinEnter", {
  command = "nnoremap <buffer> <CR> <CR>",
  pattern = { "*" },
})

-- }}}

-- Conflict Mappings {{{
-- for _, mode in ipairs({"n", "v", "o", "i", "c", "s", "x", "l", "t"}) do
--   local mapping = vim.fn.maparg("<esc>", mode)
--   if mapping == vim.fn.maparg("<C-[>", mode) and mapping ~= "" then
--     vim.keymap.del(mode, "<esc>", {})
--   end
-- end
-- vim.keymap.del({"i", "t"}, "<esc>", {})
-- }}}

-- vim: foldmethod=marker
