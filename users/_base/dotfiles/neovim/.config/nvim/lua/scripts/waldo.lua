local waldo = {
  ns = vim.api.nvim_create_namespace("Waldo"),
  is_enabled = false,
}

function waldo.enable()
  if waldo.is_enabled == true then
    return
  end
  waldo.is_enabled = true

  -- TODO: use statuscol instead?
  vim.api.nvim_set_decoration_provider(waldo.ns, {
    on_line = function(_, winid, buf, row)
      -- if window is not floating
      if not vim.api.nvim_win_get_config(winid).zindex then
        -- don't mark current line so cursorline highlight is visible
        if (winid == vim.api.nvim_get_current_win()) and (row == vim.api.nvim_win_get_cursor(winid)[1] - 1) then
          return
        end
        if row % 2 == 1 then
          vim.api.nvim_buf_set_extmark(buf, waldo.ns, row, 0, {
            end_row = row + 1,
            hl_group = "Waldo",
            hl_eol = true,
            hl_mode = "combine",
            ephemeral = true,
          })
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
