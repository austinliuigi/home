local utils = {}

--- Get absolute path to the calling module
--
---@return string
utils.get_current_module_directory = function()
  -- get the abs path to current module
  local path = debug.getinfo(2, "S").source

  -- remove the "@" character at the beginning if it's there
  if path:sub(1, 1) == "@" then
    path = path:sub(2)
  end

  -- get the directory part of the path
  return vim.fn.fnamemodify(path, ":h")
end

--- Get list of files in a directory
--
---@param dir string
---@return table? list of files if dir exists else nil
utils.get_files_in_directory = function(dir)
  local files = {}
  local p = io.popen('ls "' .. dir .. '"')
  if p then
    for file in p:lines() do
      table.insert(files, file)
    end
    p:close()
  else
    vim.notify("unable to open directory " .. dir, vim.log.levels.ERROR)
    return nil
  end
  return files
end

--- Get directory associated with current buffer
--
---@return string dir
utils.get_buf_dir = function()
  local dir
  if vim.o.buftype == "terminal" then
    local pid = vim.b.terminal_job_pid
    if vim.fn.has("linux") == 1 then
      dir = vim.uv.fs_readlink("/proc/" .. pid .. "/cwd")
    elseif vim.fn.has("mac") == 1 then
      local out = vim.fn.system({ "lsof", "-a", "-d", "cwd", "-p", tostring(pid), "-Fn" })
      dir = out:match("\nn(.-)\n")
    end
  elseif vim.fn.expand("%") == "" then
    dir = vim.fn.getcwd()
  else
    dir = vim.fn.expand("%:p:h"):gsub("^oil://", "")
  end
  return dir
end

return utils
