local resession = require("resession")

resession.setup({
  -- name of directory to store session; located in vim.fn.stdpath("data")
  dir = "sessions",
  -- order of sessions in resession.list
  --   - "modification_time"|"creation_time"|"filename"
  load_order = "modification_time",
  -- autosave when attached to a session
  autosave = {
    enabled = false,
    interval = 60,
    notify = true,
  },
})

local function get_default_session_name()
  local name = vim.fn.getcwd():gsub("[\\/:]+", "%%")
  local branch = vim.trim(vim.fn.system("git branch --show-current"))
  if vim.v.shell_error == 0 then
    return name .. "(" .. branch .. ")"
  else
    return name
  end
end

local function save_wrapper()
  local session_name = get_default_session_name()
  resession.save(session_name)
end

vim.api.nvim_create_user_command("ResessionSave", function()
  save_wrapper()
end, { nargs = 0 })
