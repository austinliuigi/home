local fs = require("scripts.utils.fs")

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

--- Merge two trees (nodes in t2 that are not found in t1 are inserted into t1)
-- note: mutates t1 out of necessity for to recursive calls to have an effect
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

--- Layout windows
--  - dir1 file in topleft
--  - dir2 file in topright
--  - selection buffer on bottom
local function layout()
  if vim.api.nvim_buf_get_name(0) ~= "" then
    vim.cmd("tabe")
  end
  local selection_winnr = vim.api.nvim_get_current_win()

  vim.cmd("topleft new")
  local diff1_winnr = vim.api.nvim_get_current_win()

  vim.api.nvim_open_win(0, true, { split = "right" }) -- use vim api call to force split to be on the right; :bottomright will cause window to take full height
  local diff2_winnr = vim.api.nvim_get_current_win()

  vim.api.nvim_set_current_win(selection_winnr)

  return {
    selection_winnr = selection_winnr,
    diff1_winnr = diff1_winnr,
    diff2_winnr = diff2_winnr,
  }
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
  local tree1 = fs.Tree:create(dir1)
  local tree2 = fs.Tree:create(dir2)

  if tree1 == nil then
    print(string.format("DiffDir: Directory `%s` does not exist", dir1))
    return
  end

  if tree2 == nil then
    print(string.format("DiffDir: Directory `%s` does not exist", dir2))
    return
  end

  local merged_tree = merge_trees(vim.deepcopy(tree1), vim.deepcopy(tree2))
  local wins = layout()

  local selection_bufnr, node_map = merged_tree:output_to_buffer()
  vim.api.nvim_win_set_buf(wins.selection_winnr, selection_bufnr)
  vim.api.nvim_buf_set_name(selection_bufnr, "DiffDir Selection [" .. selection_bufnr .. "]")
  vim.bo[selection_bufnr].modifiable = false
  vim.wo[wins.selection_winnr].foldmethod = "expr"
  vim.wo[wins.selection_winnr].foldexpr = 'v:lua.require("scripts.utils.fs").Tree.foldexpr()'

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

  -- set selection buffer keymaps
  vim.keymap.set("n", "<CR>", function()
    local linenr = vim.api.nvim_win_get_cursor(0)[1]
    local node = node_map[linenr]
    local relative_path = get_relpath(node, dir1) or get_relpath(node, dir2)

    if node.type ~= "directory" then
      vim.cmd("diffoff!")
      vim.api.nvim_win_call(wins.diff1_winnr, function()
        vim.cmd("e " .. dir1 .. "/" .. relative_path)
        vim.cmd("diffthis")
      end)
      vim.api.nvim_win_call(wins.diff2_winnr, function()
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
