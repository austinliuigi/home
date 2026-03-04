--TODO
--  - [ ] only allow one minibuffer type per parent (need to keep track of open instances in subclasses)
--  - [ ] autocompletion for command and search bufs
--  - [ ] inccommand/incsearch support
--  - [x] add command and search selections to respective native histories
--    - :h histadd()
--  - [ ] use `winfixbuf` on parent?

---@class minibuf.MiniBuffer Abstract Base Class
---@field bufnr integer
---@field winid integer
---@field parent_bufnr integer
---@field parent_winid integer
---@field history string|string[] File containing history entries or list of history entries
---@field handle_selection fun(string): nil
---@field augroup_id integer

local M = {}
M.__index = M

--- Initialize a minibuf buffer
--
---@param history string
---@return integer bufnr
local function init_buf(history)
  local bufnr = vim.api.nvim_create_buf(false, false)

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, type(history) == "string" and vim.fn.readfile(history) or history)

  vim.bo[bufnr].buftype = "nowrite"

  return bufnr
end

--- Initialize a minibuf window
--
---@return integer winid
local function init_win(bufnr)
  local winid = vim.api.nvim_open_win(bufnr, true, {
    split = "below",
  })
  vim.api.nvim_win_set_height(winid, math.floor(vim.o.lines / 4))
  vim.wo[winid].winfixheight = true
  return winid
end

--- Function to call when item is selected
--
function M:on_select()
  -- enter normal mode if not already
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, true, true), "ni", false)

  -- schedule so the fed <ESC> is done first, otherwise it may be used to exit a prompt instead of entering normal mode
  vim.schedule(function()
    -- assert parent is unchanged
    if not vim.api.nvim_win_is_valid(self.parent_winid) then
      vim.notify("Parent window no longer exists", vim.log.levels.WARN, {})
      self:destroy()
      return
    end
    if vim.api.nvim_win_get_buf(self.parent_winid) ~= self.parent_bufnr then
      vim.notify("Changed buffer in parent window", vim.log.levels.WARN, {})
      self:destroy()
      return
    end

    local selection = vim.api.nvim_get_current_line()
    if not selection:match("^%s$") then
      -- restore original view so that cursor location is restored in the case that vim.o.splitkeep ~= "cursor"
      --   - this is particularly important for searching
      -- we need to destroy before handling selection, otherwise the winview becomes weird
      self:destroy()
      vim.api.nvim_win_call(self.parent_winid, function()
        vim.fn.winrestview(self.winview)
      end)

      self:handle_selection(selection)
      self:update_history(selection)
    end
  end)
end

--- Create a minibuffer instance
--
---@return minibuf.MiniBuffer
function M:create(history)
  if type(history) == "string" and not vim.uv.fs_stat(history) then
    vim.system({ "touch", history }, {}):wait()
  end

  local winview = vim.fn.winsaveview()
  local parent_bufnr = vim.api.nvim_get_current_buf()
  local parent_winid = vim.api.nvim_get_current_win()
  local bufnr = init_buf(history)
  local winid = init_win(bufnr)
  vim.cmd("normal! Go")

  local instance = {
    bufnr = bufnr,
    winid = winid,
    winview = winview,
    parent_bufnr = parent_bufnr,
    parent_winid = parent_winid,
  }

  vim.keymap.set({ "n", "i" }, "<CR>", function()
    instance:on_select()
  end, { buffer = bufnr })

  instance.augroup_id = vim.api.nvim_create_augroup("minibuf-" .. bufnr, {})
  vim.api.nvim_create_autocmd("WinClosed", {
    group = instance.augroup_id,
    pattern = tostring(instance.winid),
    once = true,
    callback = function()
      instance:destroy()
    end,
  })

  return instance
end

--- Destroy a minibuffer instance
--
function M:destroy()
  vim.api.nvim_del_augroup_by_id(self.augroup_id)
  if vim.api.nvim_win_is_valid(self.winid) then
    vim.api.nvim_win_close(self.winid, true)
  end
  if vim.api.nvim_buf_is_valid(self.bufnr) then
    vim.api.nvim_buf_delete(self.bufnr, {})
  end
end

return M
