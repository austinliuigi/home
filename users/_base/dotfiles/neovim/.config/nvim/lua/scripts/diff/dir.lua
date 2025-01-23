--- Calls a given function on each child of a directory
---
---@param dir string
---@param fn fun(child_path: string, child_type: "file"|"directory"|"link")
---@return boolean|nil # true if dir exists, else nil
local function ls(dir, fn)
  local handle = vim.uv.fs_scandir(dir)
  if handle == nil then
    return nil
  end

  while true do
    local child_basename, child_type = vim.uv.fs_scandir_next(handle)
    if child_basename == nil then
      break
    end

    local child_path = dir .. "/" .. child_basename

    fn(child_path, child_type)
  end

  return true
end

--- Calls a given function on each descendant of a directory
---
---@param dir string
---@param fn fun(child_path: string, child_type: "file"|"directory"|"link", depth: integer)
local function walk(dir, fn, _depth)
  _depth = _depth or 0
  ls(dir, function(child_path, child_type)
    fn(child_path, child_type, _depth)
    if child_type == "directory" then
      walk(child_path, fn, _depth + 1)
    end
  end)
end

--- A structured tree of a directory
local Node = {}
local Tree = {}

function Node:create(path, type)
  local node = { path = path, type = type }
  if type == "directory" then
    node.children = {}
  end

  setmetatable(node, self)
  self.__index = self
  return node
end

---@param dir string
---@return table|nil # Tree if dir exists, else nil
function Tree:create(dir)
  local tree = Node:create(dir, "directory")
  local dir_exists = ls(dir, function(child_path, child_type)
    if child_type == "directory" then
      table.insert(tree.children, Tree:create(child_path))
    else
      table.insert(tree.children, Node:create(child_path, child_type))
    end
  end)

  if not dir_exists then
    return nil
  end

  -- sort directories before files/links, alphabetical order
  table.sort(tree.children, function(c1, c2)
    if c1.type == "directory" and c2.type ~= "directory" then
      return true
    elseif c1.type ~= "directory" and c2.type == "directory" then
      return false
    elseif c1.path < c2.path then
      return true
    else
      return false
    end
  end)

  -- https://www.lua.org/pil/16.1.html
  setmetatable(tree, self)
  self.__index = self
  return tree
end

---@param relative_path string Relative path to the node from the root of the tree
---@return table|nil # Node if it exists, else nil
function Tree:get_node(relative_path)
  local path_components = vim.split(relative_path, "/")

  local current_node = self
  for i, component in ipairs(path_components) do
    -- only the last component can be a file, which wouldn't run this
    if current_node.type ~= "directory" then
      return nil
    end

    -- if there are more components and the current one doesn't have children
    if #current_node.children == 0 then
      return nil
    end

    for j, child in ipairs(current_node.children) do
      -- assuming children are sorted, if component must be a directory and the child is not, it means we passed all children that are directories without finding the matching node
      --   - can skip all files as an optimization
      if i ~= #path_components and child.type ~= "directory" then
        return nil
      end
      -- if node matches component
      if vim.fs.basename(child.path) == component then
        current_node = child
        break
      end
      -- if made it here on last child without breaking, we couldn't find the node
      if j == #current_node.children then
        return nil
      end
    end
  end

  return current_node
end

---@return string[], table[]
function Tree:repr_lines()
  local lines = {}
  local linenr_to_node_map = {}
  local function handle_node(node, prefix_stack, is_last, is_root)
    local line = ""
    if not is_root then
      for _, prefix in ipairs(prefix_stack) do
        line = line .. prefix
      end
      if not is_last then
        line = line .. "├── "
      else
        line = line .. "└── "
      end
    end

    line = string.format("%s%s%s", line, node.type == "directory" and " " or " ", vim.fs.basename(node.path))

    table.insert(lines, line)
    table.insert(linenr_to_node_map, node)

    if node.type == "directory" then
      if not is_root then
        table.insert(prefix_stack, is_last and "    " or "│   ")
      end

      for n, child in ipairs(node.children) do
        local is_last_child = (n == #node.children)
        handle_node(child, prefix_stack, is_last_child)
      end

      if not is_root then
        table.remove(prefix_stack)
      end
    end
  end

  handle_node(self, {}, false, true)
  return lines, linenr_to_node_map
end

function Tree:output_to_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_create_buf(false, true)
  local lines, node_map = self:repr_lines()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  return bufnr, node_map
end

-- ====================== COMMANDS ======================

--- Create directory tree window
--  TODO: update on filesystem change
vim.api.nvim_create_user_command("Tree", function(attrs)
  local dir = attrs.fargs[1] or "."
  dir = vim.fn.expand(dir)

  local tree = Tree:create(dir)
  if tree == nil then
    print(string.format("Tree: Directory `%s` does not exist", dir))
    return
  end

  local bufnr, node_map = tree:output_to_buffer()
  vim.cmd("topleft vnew")
  vim.api.nvim_set_current_buf(bufnr)

  vim.keymap.set("n", "<CR>", function()
    local linenr = vim.api.nvim_win_get_cursor(0)[1]
    local node = node_map[linenr]
    if node.type == "directory" then
      _, node_map = node:output_to_buffer(bufnr)
    else
      vim.cmd("edit " .. node.path)
    end
  end, { buffer = bufnr })
end, { nargs = "?" })

---@param dir string
local function strip_trailing_sep(dir)
  if string.sub(dir, -1, -1) == "/" then
    dir = string.sub(dir, 1, -2)
  end
  return dir
end

---@param node table Node to get relative path to
---@param root string Path to start relative path from
local function get_relpath(node, root)
  if string.sub(node.path, 1, #root) == root then
    return string.sub(node.path, #root + 2)
  end
  return nil
end

---@param tree table Tree to insert child into
---@param node table Child node to insert
local function insert_child(tree, node)
  for n, child in ipairs(tree.children) do
    if child.type == "directory" and node.type ~= "directory" then
      goto continue
    elseif node.type == "directory" and child.type ~= "directory" then
      table.insert(tree.children, n, node)
      return
    elseif vim.fs.basename(child.path) > vim.fs.basename(node.path) then
      table.insert(tree.children, n, node)
      return
    end
    ::continue::
  end
  table.insert(tree.children, node)
end

--- Perform a diff on files in two directories
--- note: spaces in arguments need to be escaped
vim.api.nvim_create_user_command("DiffDir", function(attrs)
  local usage = "Usage: DiffDir <dir1> <dir2>"
  if #attrs.fargs ~= 2 then
    print(usage)
    return
  end

  local dir1 = strip_trailing_sep(vim.fn.fnamemodify(vim.fn.expand(attrs.fargs[1]), ":p"))
  local dir2 = strip_trailing_sep(vim.fn.fnamemodify(vim.fn.expand(attrs.fargs[2]), ":p"))
  local tree1 = Tree:create(dir1)
  local tree2 = Tree:create(dir2)

  if tree1 == nil then
    print(string.format("DiffDir: Directory `%s` does not exist", dir1))
    return
  end

  if tree2 == nil then
    print(string.format("DiffDir: Directory `%s` does not exist", dir2))
    return
  end

  -- merge trees
  local function merge_trees(t1, t2)
    for _, child in ipairs(t2.children) do
      local relative_path = string.sub(child.path, #t2.path + 2)
      local matched_node = t1:get_node(relative_path)
      if not matched_node then
        insert_child(t1, child)
      elseif child.type == "directory" then
        merge_trees(matched_node, child)
      end
    end
    return t1
  end

  local merged_tree = merge_trees(vim.deepcopy(tree1), vim.deepcopy(tree2))

  -- open windows
  local selection_bufnr, node_map = merged_tree:output_to_buffer()
  if vim.api.nvim_buf_get_name(0) ~= "" then
    vim.cmd("tabe")
  end
  vim.api.nvim_buf_set_name(selection_bufnr, "DiffDir Selection [" .. selection_bufnr .. "]")
  vim.api.nvim_set_current_buf(selection_bufnr)
  local ns = vim.api.nvim_create_namespace("DiffDir" .. selection_bufnr)
  for linenr, line in ipairs(vim.api.nvim_buf_get_lines(selection_bufnr, 0, -1, true)) do
    local node = node_map[linenr]
    if node.type ~= "directory" then
      local relative_path = get_relpath(node, dir1) or get_relpath(node, dir2)
      local in_dir1 = tree1:get_node(relative_path)
      local in_dir2 = tree2:get_node(relative_path)

      local hl
      if in_dir1 and in_dir2 then
        hl = "DiffDirBoth"
      elseif in_dir1 then
        hl = "DiffDir1"
      elseif in_dir2 then
        hl = "DiffDir2"
      end

      -- note: since both string.find and nvim_buf_set_extmark work byte-wise, there doesn't need to be any conversion for wide characters
      local start_col, end_col = string.find(line, vim.fs.basename(node_map[linenr].path))
      vim.api.nvim_buf_set_extmark(selection_bufnr, ns, linenr - 1, start_col - 1, {
        end_row = linenr - 1,
        end_col = end_col,
        hl_group = hl,
      })
    end
  end
  local selection_winnr = vim.api.nvim_get_current_win()
  -- TODO: make readonly buffer

  vim.cmd("topleft new")
  local diff1_winnr = vim.api.nvim_get_current_win()

  vim.api.nvim_open_win(0, true, { split = "right" }) -- use vim api call to force split to be on the right; :bottomright will cause window to take full height
  local diff2_winnr = vim.api.nvim_get_current_win()

  vim.api.nvim_set_current_win(selection_winnr)

  -- set selection buffer keymaps
  vim.keymap.set("n", "<CR>", function()
    local linenr = vim.api.nvim_win_get_cursor(0)[1]
    local node = node_map[linenr]
    local relative_path = get_relpath(node, dir1) or get_relpath(node, dir2)

    if node.type ~= "directory" then
      vim.cmd("diffoff!")
      vim.api.nvim_win_call(diff1_winnr, function()
        vim.cmd("e " .. dir1 .. "/" .. relative_path)
        vim.cmd("diffthis")
      end)
      vim.api.nvim_win_call(diff2_winnr, function()
        vim.cmd("e " .. dir2 .. "/" .. relative_path)
        vim.cmd("diffthis")
      end)
    end
  end, { buffer = selection_bufnr })
end, { nargs = "+" })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- local dye = require("dye")
    vim.api.nvim_set_hl(0, "DiffDirBoth", { link = "DiffChange" })
    vim.api.nvim_set_hl(0, "DiffDir1", { link = "DiffAdd" })
    vim.api.nvim_set_hl(0, "DiffDir2", { link = "DiffDelete" })
  end,
})
