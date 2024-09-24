local dashboard = {}

local function random(list)
  math.randomseed(os.time())
  return list[math.random(#list)]
end

function dashboard.center(banner)
  local banner_rows = #banner
  local banner_cols = vim.fn.strdisplaywidth(banner[1]) -- assumes all lines are same length
  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)

  local top
  if banner_rows > win_height then
    top = 0
  else
    top = math.floor((win_height - banner_rows) / 2)
  end

  local left
  if banner_cols > win_width then
    left = 0
  else
    left = math.floor((win_width - banner_cols) / 2)
  end

  local centered = {}
  -- add padding to top
  for _ = 1, top - 1 do
    table.insert(centered, "")
  end
  -- add padding to left
  local left_padding = string.rep(" ", left)
  for _, line in ipairs(banner) do
    table.insert(centered, left_padding .. line)
  end

  return centered, top, left, banner_rows, banner_cols
end

function dashboard.draw(banner, hl_group)
  vim.opt_local.modifiable = true
  local centered_banner, top, _, banner_rows, _ = dashboard.center(banner)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, centered_banner)
  for i = 0, banner_rows - 1 do
    vim.api.nvim_buf_add_highlight(0, -1, hl_group, top + i - 1, 0, -1)
  end
  vim.opt_local.modifiable = false
end

function dashboard.create_buffer()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)

  vim.opt_local.buftype = "nofile"
  vim.opt_local.buflisted = false
  vim.opt_local.bufhidden = "wipe"
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "dashboard"
  vim.opt_local.wrap = false
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.cursorline = false
  vim.opt_local.cursorcolumn = false
  vim.opt_local.colorcolumn = ""
  vim.opt_local.synmaxcol = 0
  vim.opt_local.foldlevel = 999
  vim.opt_local.foldcolumn = "0"
  vim.opt_local.matchpairs = ""
  vim.opt_local.fillchars = { eob = " " }
  vim.opt_local.list = false
  vim.opt_local.spell = false

  vim.cmd("hi Cursor blend=100")

  local banner = random(require("scripts.dashboard.banners"))
  local hl_group = random({
    -- "Base02",
    "Base05",
    "Base08",
    "Base09",
    "Base0A",
    "Base0B",
    "Base0C",
    "Base0D",
    "Base0E",
    "Base0F",
  })

  dashboard.draw(banner, hl_group)
  vim.api.nvim_create_autocmd("VimResized", {
    buffer = 0,
    callback = function()
      dashboard.draw(banner, hl_group)
    end,
  })

  local keys = { "i", "a", "o", "p", "q", ":", "I", "A", "O", "P" }
  for _, key in ipairs(keys) do
    vim.keymap.set("n", key, function()
      vim.cmd("enew")
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "ni")
    end, { buffer = 0 })
  end

  return buf
end

function dashboard.should_open()
  -- if nvim opened with filename
  if vim.fn.argc() ~= 0 then
    return false
  end

  -- if buffer has lines, e.g. piped from stdin
  local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
  if #lines > 1 or (#lines == 1 and #lines[1] > 0) then
    return false
  end

  -- blacklisted non-filename arguments
  for _, arg in pairs(vim.v.argv) do
    if arg == "-b" or arg == "-c" or arg == "-S" or arg:sub(1, 1) == "+" then
      return false
    end
  end

  return true
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if dashboard.should_open() then
      local buf = dashboard.create_buffer()
      vim.api.nvim_create_autocmd("BufUnload", {
        buffer = buf,
        callback = function()
          vim.cmd("hi Cursor blend=0")
        end,
      })
    end
  end,
})

return dashboard
