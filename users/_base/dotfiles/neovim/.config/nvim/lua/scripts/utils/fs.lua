local M = {}
local ns = vim.api.nvim_create_namespace("fs")

---@alias NodeType "file"|"directory"|"link"|"fifo"|"socket"|"char"|"block"|"unknown"

---@class Node
---@field path string
---@field type NodeType
---@field children? Node[] string

-- TODO: Use web-devicons for file icons
local type_to_icon = {
  file = "",
  directory = "",
  link = "",
  fifo = "󰟥",
  socket = "󰟩",
  char = "󱌮",
  block = "󰋊",
  unknown = "",
}
local path_to_node = {}

--- Calls a given function on each child of a directory
---
---@param dir string
---@param fn fun(child_path: string, child_type: NodeType)
---@return boolean|nil # true if dir exists, else nil
function M.ls(dir, fn)
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
---@param fn fun(child_path: string, child_type: NodeType, depth: integer)
function M.walk(dir, fn, _depth)
  _depth = _depth or 0
  M.ls(dir, function(child_path, child_type)
    fn(child_path, child_type, _depth)
    if child_type == "directory" then
      M.walk(child_path, fn, _depth + 1)
    end
  end)
end

M.Node = {}

--- Create a node and all its descendants
--
---@param path string Absolute path for the node
--
function M.Node:create(path)
  local stat = vim.uv.fs_stat(path)
  if not stat then
    return nil
  end
  local type = stat.type

  if path_to_node[path] then
    return path_to_node[path]
  end

  local node = { path = path, type = type }
  path_to_node[path] = node

  if type == "directory" then
    node.children = {}

    M.ls(path, function(child_path, _)
      table.insert(node.children, M.Node:create(child_path))
    end)

    -- sort directories before files/links, alphabetical order
    table.sort(node.children, function(c1, c2)
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
  end

  -- https://www.lua.org/pil/16.1.html
  setmetatable(node, self)
  self.__index = self
  return node
end

--- Get a descendant node based on its relative path to the current node
--
---@param relative_path string Relative path to the node from the root of the tree
---@return table? descendant Descendant node if it exists, else nil
--
function M.Node:get_descendant(relative_path)
  return path_to_node[self.path .. "/" .. relative_path]
end

--- Retrieve the parent of a node
--
---@return Node? parent
--
function M.Node:get_parent()
  local parent_path = vim.fs.dirname(self.path)
  return path_to_node[parent_path]
end

--- Check if the current node is the last child of its parent
--
---@return boolean
--
function M.Node:is_last()
  local parent = self:get_parent()

  -- if parent hasn't been created before, just return true
  if not parent then
    return true
  end

  for _, child in ipairs(parent.children) do
    if self == child then
      return false
    end
  end
  return true
end

--- Get the lines representing the child nodes of the current node
--
---@param prefix? string String to prepend to each line
---@return string[] lines, Node[] linenr_to_node
--
function M.Node:repr_children(prefix)
  if self.type ~= "directory" then
    return {}, {}
  end

  prefix = prefix or ""

  local lines = {}
  local linenr_to_node = {}

  local num_children = #self.children
  for i, child in ipairs(self.children) do
    local line = prefix
    if i ~= num_children then
      line = line .. "├── "
    else
      line = line .. "└── "
    end
    line = string.format("%s%s %s", line, type_to_icon[child.type], vim.fs.basename(child.path))
    table.insert(lines, line)
    table.insert(linenr_to_node, child)
  end

  return lines, linenr_to_node
end

function M.Node:output_lazy(bufnr)
  -- create buffer
  bufnr = bufnr or vim.api.nvim_create_buf(false, true)

  -- add root
  local lines = { string.format("%s %s", type_to_icon[self.type], vim.fs.basename(self.path)) }
  local linenr_to_node = { self }

  -- add root children
  local children_lines, children_linenr_to_node = self:repr_children()
  for i = 1, #children_lines do
    table.insert(lines, children_lines[i])
    table.insert(linenr_to_node, children_linenr_to_node[i])
  end

  vim.api.nvim_buf_set_lines(bufnr, 1, -1, true, children_lines)

  -- create keymaps
  vim.keymap.set("n", "<tab>", function()
    local cur_linenr = vim.api.nvim_win_get_cursor(0)[1]
    local cur_node = linenr_to_node[cur_linenr]
    if cur_node.type == "directory" then
      if cur_linenr == #linenr_to_node or linenr_to_node[cur_linenr + 1]:get_parent() ~= cur_node then
        local cur_children_lines, cur_children_linenr_to_node = cur_node:repr_children()
        vim.api.nvim_buf_set_lines(bufnr, cur_linenr, cur_linenr, true, cur_children_lines)
        -- TODO: edit linenr_to_node
      else
        -- TODO: toggle fold
      end
    end
  end, {})
end

--- Get the output representation of the node as a list of lines
--
---@return string[] lines, Node[] linenr_to_node
--
function M.Node:repr()
  local lines = {}
  local linenr_to_node = {}
  local function append_node_line(node, prefix_stack, is_last, is_root)
    -- append prefix stack
    local line = table.concat(prefix_stack)

    -- append connector
    if not is_root then
      if not is_last then
        line = line .. "├── "
      else
        line = line .. "└── "
      end
    end

    -- append file icon and name
    line = string.format("%s%s %s", line, type_to_icon[node.type], vim.fs.basename(node.path))

    table.insert(lines, line)
    table.insert(linenr_to_node, node)

    if node.type == "directory" then
      if not is_root then
        table.insert(prefix_stack, is_last and "    " or "│   ")
      end

      for i, child in ipairs(node.children) do
        local is_last_child = (i == #node.children)
        append_node_line(child, prefix_stack, is_last_child)
      end

      if not is_root then
        table.remove(prefix_stack)
      end
    end
  end

  append_node_line(self, {}, true, true)
  return lines, linenr_to_node
end

--- Add highlight extmarks for lines in a node's buffer
--
---@param bufnr integer
---@param linenr_to_node Node[]
---@param first_linenr integer First line to start adding highlights (default: 1)
---@param last_linenr integer Last line to add highlights to (default: last line in buffer)
--
local function generate_highlights(bufnr, linenr_to_node, first_linenr, last_linenr)
  first_linenr = first_linenr or 1
  last_linenr = last_linenr or #linenr_to_node

  local lines = vim.api.nvim_buf_get_lines(bufnr, first_linenr - 1, last_linenr, true)

  -- add highlights
  for curr_linenr = first_linenr, last_linenr do
    local line = lines[curr_linenr - first_linenr + 1]
    local node = linenr_to_node[curr_linenr]

    -- NOTE: since both string.find and nvim_buf_set_extmark work byte-wise, there doesn't need to be any conversion for wide characters

    -- highlight lines
    local basename_start_col, basename_end_col = string.find(line, vim.fs.basename(node.path), 1, true)
    vim.api.nvim_buf_set_extmark(
      bufnr,
      ns,
      curr_linenr - 1,
      0, -- note: start_col subtracts by five because " " is 3 + 1 bytes
      {
        end_row = curr_linenr - 1,
        end_col = basename_start_col - 5,
        hl_group = "Base03",
      }
    )

    -- highlight directories
    if node.type == "directory" then
      vim.api.nvim_buf_set_extmark(
        bufnr,
        ns,
        curr_linenr - 1,
        basename_start_col - 5, -- note: start_col subtracts by five because " " is 3 + 1 bytes
        {
          end_row = curr_linenr - 1,
          end_col = basename_end_col,
          hl_group = "Directory",
        }
      )
    end
  end
end

--- Create a buffer containing the node and its descendants as a tree
--
---@param bufnr integer
--
function M.Node:output(bufnr)
  bufnr = bufnr or vim.api.nvim_create_buf(false, true)

  local lines, linenr_to_node = self:repr()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  generate_highlights(bufnr, linenr_to_node)

  return bufnr, linenr_to_node
end

--- Fold expression for node buffers
--
function M.foldexpr()
  local line = vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1]
  line = line:gsub("├", " "):gsub("│", " "):gsub("└", " "):gsub("─", " ")

  local icon_idx = line:find("%S")
  local dir_icon = type_to_icon.directory

  ---@diagnostic disable-next-line: param-type-mismatch
  if line:sub(icon_idx, icon_idx + #dir_icon - 1) == dir_icon then
    return ">" .. ((icon_idx - 1) / 4) + 1
  end
  return (icon_idx - 1) / 4
end

return M
