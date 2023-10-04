local toggle_key = require("austin.keymaps").toggle_key

require('incline').setup {
  debounce_threshold = 10,
  window = {
    placement = {
      vertical = 'top',
      horizontal = 'right'
    },
    margin = {
      vertical = 0
    }
  },
  ignore = {
    unlisted_buffers = false,
    buftypes = {'acwrite', 'nofile', 'nowrite', 'terminal', 'prompt'}
  },
  render = function(props)
    local filepath = string.gsub(vim.api.nvim_buf_get_name(props.buf), vim.env.HOME, '~')
    local filename = vim.fn.fnamemodify(filepath, ':t')
    local fileext = vim.fn.fnamemodify(filepath, ':e')

    -- Icon to show in incline bar
    local icon = function ()
      local nwd = require('nvim-web-devicons')
      local i = filepath == '' and nwd.get_icon('', 'txt') or nwd.get_icon(filename, fileext)
      return { i, group = "Type" }
    end
    -- Name to show in incline bar
    local name = function ()
      local n
      if vim.api.nvim_buf_get_option(props.buf, 'filetype') == 'help' then
        n = 'help'
      elseif filepath == '' then
        n = '(no-name)'
      else
        n = vim.g.incline_full_path and filepath or filename
      end
      local g = props.focused and 'bold' or 'italic'
      return { ' '..n, gui = g }
    end

    local readonly = function ()
      local r = vim.api.nvim_buf_get_option(props.buf, 'readonly') and ' [RO]' or ''
      return { r }
    end

    local modified = function ()
      local m = vim.api.nvim_buf_get_option(props.buf, 'modified') and { ' *' } or ''
      return { m, guifg = '#db4b4b' }
    end

    return {
      -- File icon
      icon(),
      -- File name/path
      name(),
      -- Read only
      readonly(),
      -- Modified
      modified()
    }
  end
}

-- Toggle whether incline shows full path or just tail of buffer file
vim.g.incline_full_path = false
vim.keymap.set('n', toggle_key..'in', function() vim.g.incline_full_path = not vim.g.incline_full_path; require('incline').enable() end)
