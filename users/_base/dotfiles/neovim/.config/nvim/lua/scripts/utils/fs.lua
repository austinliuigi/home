local fs = {}

--- Calls a given function on each child of a directory
---
---@param dir string
---@param fn fun(child_path: string, child_type: "file"|"directory"|"link")
---@return boolean|nil # true if dir exists, else nil
function fs.ls(dir, fn)
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
function fs.walk(dir, fn, _depth)
  _depth = _depth or 0
  ls(dir, function(child_path, child_type)
    fn(child_path, child_type, _depth)
    if child_type == "directory" then
      walk(child_path, fn, _depth + 1)
    end
  end)
end

--- A structured tree of a directory
fs.Node = {}
fs.Tree = {}

function fs.Node:create(path, type)
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
function fs.Tree:create(dir)
  local tree = fs.Node:create(dir, "directory")
  local dir_exists = fs.ls(dir, function(child_path, child_type)
    if child_type == "directory" then
      table.insert(tree.children, fs.Tree:create(child_path))
    else
      table.insert(tree.children, fs.Node:create(child_path, child_type))
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
function fs.Tree:get_node(relative_path)
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

---@return string[], table[], string[]
function fs.Tree:repr_lines()
  local lines = {}
  local node_map = {}
  local foldlevel_map = {}
  local function handle_node(node, depth, prefix_stack, is_last, is_root)
    local line = ""
    if not is_root then
      line = table.concat(prefix_stack)
      if not is_last then
        line = line .. "├── "
      else
        line = line .. "└── "
      end
    end

    line = string.format("%s%s%s", line, node.type == "directory" and " " or " ", vim.fs.basename(node.path))

    table.insert(lines, line)
    table.insert(node_map, node)
    table.insert(foldlevel_map, node.type == "directory" and ">" .. depth or depth - 1)

    if node.type == "directory" then
      if not is_root then
        table.insert(prefix_stack, is_last and "    " or "│   ")
      end

      for n, child in ipairs(node.children) do
        local is_last_child = (n == #node.children)
        handle_node(child, depth + 1, prefix_stack, is_last_child)
      end

      if not is_root then
        table.remove(prefix_stack)
      end
    end
  end

  handle_node(self, 1, {}, false, true)
  return lines, node_map, foldlevel_map
end

function fs.Tree:output_to_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_create_buf(false, true)

  local lines, node_map, foldlevel_map = self:repr_lines()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  fs.Tree.bufnr_to_foldlevel_map[bufnr] = foldlevel_map

  -- highlight directories
  local ns = vim.api.nvim_create_namespace("")
  for linenr, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)) do
    local node = node_map[linenr]
    if node.type == "directory" then
      -- note: since both string.find and nvim_buf_set_extmark work byte-wise, there doesn't need to be any conversion for wide characters
      local start_col, end_col = string.find(line, vim.fs.basename(node_map[linenr].path), 1, true)
      vim.api.nvim_buf_set_extmark(
        bufnr,
        ns,
        linenr - 1,
        start_col - 5, -- note: start_col subtracts by five because " " is 3 + 1 bytes
        {
          end_row = linenr - 1,
          end_col = end_col,
          hl_group = "Directory",
        }
      )
    end
  end

  return bufnr, node_map
end

fs.Tree.bufnr_to_foldlevel_map = {}
function fs.Tree.foldexpr()
  local bufnr = vim.api.nvim_get_current_buf()
  if fs.Tree.bufnr_to_foldlevel_map[bufnr] then
    return fs.Tree.bufnr_to_foldlevel_map[bufnr][vim.v.lnum]
  end
end

return fs
