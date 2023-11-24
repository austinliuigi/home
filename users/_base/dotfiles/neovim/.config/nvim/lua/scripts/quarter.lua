local function round(n)
  return math.floor(n + 0.5)
end

-- Scroll

vim.keymap.set({ "n", "x" }, "<leader><C-u>", function()
  local count = round(vim.fn.winheight(0) / 4)
  return count.."<C-u><cmd>set scroll=0<CR>"
end, { remap = true, expr = true })

vim.keymap.set({ "n", "x" }, "<leader><C-d>", function()
  local count = round(vim.fn.winheight(0) / 4)
  return count.."<C-d><cmd>set scroll=0<CR>"
end, { remap = true, expr = true })


-- Jump

local function NumVisibleLines(first, last)
  first = first or vim.fn.line("w0")
  last = last or vim.fn.line("w$")

  local num_lines = 0
  local current_line = first
  while (current_line <= last) do
    if vim.fn.foldclosed(current_line) > 0 then
      current_line = vim.fn.foldclosedend(current_line) + 1
    else
      current_line = current_line + 1
      num_lines = num_lines + 1
    end
  end

  return num_lines
end

vim.keymap.set({ "n", "x" }, "<leader>L", function()
  local count = round(NumVisibleLines() / 4)
  return "M"..count.."j"
end, { remap = true, expr = true })

vim.keymap.set({ "n", "x" }, "<leader>H", function()
  local count = round(NumVisibleLines() / 4)
  return "M"..count.."k"
end, { remap = true, expr = true })
