--==============================================================================
-- When pasting from a clipboard (+ or * register), if the contents
-- aren't text, save them to a file and paste the filename instead.
--==============================================================================
local M = {}

local default_mime_types = {
  ["text/plain"] = true,
  ["image/png"] = true,
  ["image/gif"] = true,
}

---@return string os_name
local get_os = function()
  if vim.fn.has("win32") == 1 then
    return "Windows"
  end

  local current_os = tostring(io.popen("uname"):read())
  if current_os == "Linux" and vim.fn.readfile("/proc/version")[1]:lower():match("microsoft") then
    current_os = "Wsl"
  end
  return current_os
end

M.os = get_os()

---Get the offered mime types for the clipboard content
---@return string[] mime_types List of offered mime types
M.get_offered_mime_types = function()
  local mime_types

  if M.os == "Linux" then
    local display_server = os.getenv("XDG_SESSION_TYPE")
    if display_server == "wayland" then
      mime_types = vim.split(vim.system({ "wl-paste", "--list-types" }, { text = true }):wait().stdout, "\n")
    end
  end
  return mime_types or {}
end

---@return string[] offered_default_mime_types
M.get_offered_default_mime_types = function()
  local offered_default_mime_types = {}
  for _, mime_type in ipairs(M.get_offered_mime_types()) do
    if default_mime_types[mime_type] then
      table.insert(offered_default_mime_types, mime_type)
    end
  end
  return offered_default_mime_types
end

---@param filepath string Path of file to paste to
---@param mime_type string
---@return vim.SystemCompleted? obj
-- TODO: add support for more clipboards
--       - see builtin detection: https://github.com/neovim/neovim/blob/release-0.11/runtime/autoload/provider/clipboard.vim#L236-L259
M.paste_contents_to_file = function(filepath, mime_type)
  local cmd

  if M.os == "Linux" then
    local display_server = os.getenv("XDG_SESSION_TYPE")
    if display_server == "wayland" then
      cmd = { "bash", "-c", "wl-paste -t" .. mime_type .. ">" .. filepath }
    end
  end
  if cmd then
    vim.notify("Executing command: " .. table.concat(cmd, " "), vim.log.levels.INFO, { title = "Media Paste" })
    return vim.system(cmd, { text = true }):wait()
  else
    vim.notify("System not supported", vim.log.levels.WARN, { title = "Media Paste" })
  end
end

---@param dir string
M.mkdir = function(dir)
  dir = vim.fn.expand(dir)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

---@param p "p"|"P"
local function do_native_paste(p)
  vim.cmd('normal! "' .. vim.v.register .. p)
end

---@param p "p"|"P"
M.paste = function(p)
  p = p or "p"

  -- perform native paste if pasting from register instead of clipboard
  if vim.v.register ~= "*" and vim.v.register ~= "+" then
    do_native_paste(p)
    return
  end

  -- early exit if using osc52 since clipboard contents aren't on current local machine
  if vim.g.clipboard == "osc52" then
    do_native_paste(p)
    return
  end

  -- get mime type
  local mime_type
  local offered_default_mime_types = M.get_offered_default_mime_types()
  if #offered_default_mime_types == 0 then
    -- local selection = vim.ui.select(M.get_offered_mime_types(), { prompt = "Select mime type: " })
    local offered_mime_types = M.get_offered_mime_types()
    local selection = vim.fn.inputlist(offered_mime_types)
    if selection == 0 then
      vim.notify("Paste cancelled", vim.log.levels.INFO, { title = "Media Paste" })
      return
    else
      mime_type = offered_mime_types[selection]
    end
  else
    mime_type = offered_default_mime_types[1]
  end

  -- paste plain text directly
  if mime_type == "text/plain" then
    do_native_paste(p)
    return
  end

  local buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")

  -- temporarily cd to buf_dir so completion is accurate
  vim.cmd("cd " .. buf_dir)

  -- get file to paste media into
  -- local user_input = vim.ui.input({ prompt = "Save to: ", completion = "file" })
  local user_input = vim.fn.input({ prompt = "Save to: ", completion = "file" })
  if user_input == nil or user_input == "" then
    vim.cmd("cd -")
    vim.notify("Paste cancelled", vim.log.levels.INFO, { title = "Media Paste" })
    return
  end
  vim.cmd("cd -")

  local filepath = vim.fn.expand(user_input)
  if string.sub(filepath, 1, 1) ~= "/" then
    filepath = buf_dir .. "/" .. filepath
  end

  -- paste to tempfile
  local tmpfile = vim.fn.tempname()
  local obj = M.paste_contents_to_file(tmpfile, mime_type)
  if obj == nil then
    return
  end
  if obj.code ~= 0 then
    vim.notify("Paste failed with error: " .. obj.stderr, vim.log.levels.ERROR, { title = "Media Paste" })
    return
  end

  -- move to desired file
  M.mkdir(vim.fs.dirname(filepath))
  if vim.uv.fs_stat(filepath) then
    vim.uv.fs_unlink(filepath)
  end
  vim.uv.fs_link(tmpfile, filepath)
  vim.notify(
    string.format("Successfully saved %s file to %s", mime_type, filepath),
    vim.log.levels.INFO,
    { title = "Media Paste" }
  )

  -- paste generated filename
  vim.fn.setreg(vim.v.register, user_input)
  vim.cmd("normal! " .. p)
end

vim.keymap.set({ "n", "x" }, "p", function()
  M.paste("p")
end, { remap = false })

vim.keymap.set({ "n", "x" }, "P", function()
  M.paste("P")
end, { remap = false })

return M
