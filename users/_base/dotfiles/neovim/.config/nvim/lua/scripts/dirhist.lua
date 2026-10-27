-- Tracks directories you've been in, most recent first, unique entries.

local path = vim.fn.stdpath("data") .. "/.dirhist"
local max_entries = 100

local function read()
  local ok, lines = pcall(vim.fn.readfile, path)
  return ok and lines or {}
end

local function record(dir)
  if not dir or dir == "" then
    return
  end
  -- Put the new dir first, then append the old entries minus any duplicate.
  -- Re-reading on every write keeps multiple Neovim instances in sync.
  local list = { dir }
  for _, d in ipairs(read()) do
    if d ~= dir and #list < max_entries then
      table.insert(list, d)
    end
  end
  vim.fn.writefile(list, path)
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  group = vim.api.nvim_create_augroup("DirHist", { clear = true }),
  callback = function()
    record(vim.fn.getcwd())
  end,
})

local function select()
  local dirs = vim.tbl_filter(function(d)
    return vim.fn.isdirectory(d) == 1 and d ~= vim.fn.getcwd()
  end, read())

  require("fzf-lua").fzf_exec(dirs, {
    prompt = "cd ",
    preview = "ls -la {}",
    actions = {
      ["default"] = function(selected)
        if selected[1] then
          vim.cmd.cd(vim.fn.fnameescape(selected[1]))
        end
      end,
    },
  })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "FzfLuaLoadPost",
  callback = function()
    require("config.plugins.configurations.fzf-lua")["dirhist"] = select
  end,
})

vim.keymap.set({ "n", "x", "i" }, "<leader><C-S-f>", function()
  select()
end, {})
