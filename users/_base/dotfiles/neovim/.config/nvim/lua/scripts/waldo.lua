local waldo = {
  ns = vim.api.nvim_create_namespace("Waldo"),
  is_enabled = false,
}

local function get_gitsigns_type(lnum, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  -- Retrieve the raw list of git hunks for the buffer
  local hunks = require("gitsigns").get_hunks(bufnr) or {}

  for _, hunk in ipairs(hunks) do
    -- For 'add' and 'change', the line falls within the newly added range
    if lnum >= hunk.added.start and lnum <= (hunk.added.start + hunk.added.count - 1) then
      -- If hunk.removed.count > 0, it means it's a modified/changed line, not just a pure add
      return hunk.removed.count > 0 and "change" or "add"
    end

    -- For deletions, git placement flags the line immediately following or preceding the cut
    if lnum == hunk.added.start and hunk.added.count == 0 then
      return "delete"
    end
  end
  return nil -- No gitsign on this line
end

function waldo.enable()
  if waldo.is_enabled == true then
    return
  end
  waldo.is_enabled = true

  -- TODO: use statuscol instead?
  vim.api.nvim_set_decoration_provider(waldo.ns, {
    on_line = function(_, winid, buf, row)
      -- if window is not floating or terminal a terminal buffer
      if not vim.api.nvim_win_get_config(winid).zindex and vim.bo[buf].buftype ~= "terminal" then
        -- don't mark current line so cursorline highlight is visible
        if (winid == vim.api.nvim_get_current_win()) and (row == vim.api.nvim_win_get_cursor(winid)[1] - 1) then
          return
        end
        if row % 2 == 1 then
          -- TODO: refactor
          local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
          if not gitsigns_ok or not require("gitsigns.config").config.linehl or not get_gitsigns_type(row + 1, buf) then
            vim.api.nvim_buf_set_extmark(buf, waldo.ns, row, 0, {
              end_row = row + 1,
              hl_group = "Waldo",
              hl_eol = true,
              hl_mode = "combine",
              priority = 1,
              ephemeral = true,
            })
          end
        end
      end
    end,
  })
end

function waldo.disable()
  if waldo.is_enabled == false then
    return
  end
  waldo.is_enabled = false

  vim.api.nvim_set_decoration_provider(waldo.ns, {
    on_line = function() end,
  })
end

function waldo.toggle()
  if waldo.is_enabled == true then
    waldo.disable()
    return
  end
  waldo.enable()
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local dye = require("dye")
    vim.api.nvim_set_hl(0, "Waldo", { bg = dye.CursorLine.bg.blend(dye.Normal.bg.hex, 0.7).hex })
  end,
})

-- enable initially
waldo.enable()

return waldo
