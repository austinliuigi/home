---@param dir string
---@return table|nil # Returns a table of the form { pathname = type, ... } for each child of dir if dir exists, else nil
local function ls(dir)
  local handle = vim.uv.fs_scandir(dir)
  if handle == nil then
    return nil
  end

  local output = {}
  while true do
    local basename, _type = vim.uv.fs_scandir_next(handle)
    if basename == nil then
      break
    end

    local path = dir .. "/" .. basename

    output[path] = _type
  end

  return output
end

---@param dir string
---@return table|nil # Returns a table of the form { pathname = type, ... } for each descendant of dir if dir exists, else nil
local function tree(dir)
  local dir_output = ls(dir)
  if dir_output == nil then
    return nil
  end

  local subdirs_output = {}
  for path, _type in pairs(dir_output) do
    if _type == "directory" then
      subdirs_output = vim.tbl_extend("error", subdirs_output, tree(path))
    end
  end

  return vim.tbl_extend("error", dir_output, subdirs_output)
end

--- Perform a diff on files in two directories
-- note: spaces in arguments need to be escaped
local id = 0
local ids_to_wins = {}
vim.api.nvim_create_user_command("DiffDir", function(attrs)
  local usage = "Usage: DiffDir <dir1> <dir2>"
  if #attrs.fargs ~= 2 then
    print(usage)
    return
  end

  local dir1 = vim.fn.expand(attrs.fargs[1])
  local dir2 = vim.fn.expand(attrs.fargs[2])
  local tree1 = tree(dir1)
  local tree2 = tree(dir2)

  if tree1 == nil then
    print(string.format("DiffDir: Directory `%s` does not exist", dir1))
    return
  end

  if tree2 == nil then
    print(string.format("DiffDir: Directory `%s` does not exist", dir2))
    return
  end

  if (#vim.tbl_keys(tree1) ~= #vim.tbl_keys(tree2)) and (attrs.bang == false) then
    print(
      string.format(
        "DiffDir: `%s` and `%s` do not have an identical tree structure. Use DiffDir! to diff only files that have the same relative paths.",
        dir1,
        dir2
      )
    )
    return
  end

  local relative_tree1 = {}
  local relative_tree2 = {}
  for path, _type in pairs(tree1) do
    local relative_path = string.sub(path, #dir1 + 2)
    relative_tree1[relative_path] = _type
  end
  for path, _type in pairs(tree2) do
    local relative_path = string.sub(path, #dir2 + 2)
    relative_tree2[relative_path] = _type
  end

  local files_to_diff = {}
  for relative_path1, type1 in pairs(relative_tree1) do
    if relative_tree2[relative_path1] ~= nil then
      if type1 ~= "directory" then
        table.insert(files_to_diff, relative_path1)
      end
    elseif attrs.bang == false then
      print(
        string.format(
          "DiffDir: `%s` does not contain the relative path `%s`. Use DiffDir! to diff only files that have the same relative paths.",
          dir2,
          relative_path1
        )
      )
      return
    end
  end

  if vim.tbl_isempty(files_to_diff) then
    print("DiffDir: No files to diff")
    return
  end

  -- vim.print(files_to_diff)

  local initial_win = vim.api.nvim_get_current_win()

  ids_to_wins[id] = {}
  for _, file in ipairs(files_to_diff) do
    vim.cmd("tabe " .. dir1 .. "/" .. file)
    table.insert(ids_to_wins[id], vim.api.nvim_get_current_win())
    vim.cmd("vnew " .. dir2 .. "/" .. file)
    table.insert(ids_to_wins[id], vim.api.nvim_get_current_win())
    vim.cmd("windo diffthis")
  end

  if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(initial_win)) == "" then
    vim.api.nvim_win_close(initial_win, false)
  end

  print(string.format("DiffDir: id = %s", id))

  id = id + 1
end, { nargs = "+", bang = true })

--- Close windows corresponding to a previous DirDiff
vim.api.nvim_create_user_command("DiffDirClose", function(attrs)
  id = tonumber(attrs.args) or -1
  if ids_to_wins[id] == nil then
    print("DiffDirClose: invalid id " .. id)
  else
    for _, win in ipairs(ids_to_wins[id]) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, false)
      end
    end
    ids_to_wins[id] = nil
  end
end, { nargs = 1 })
