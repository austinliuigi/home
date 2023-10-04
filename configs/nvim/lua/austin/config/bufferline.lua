vim.opt.termguicolors = true
require('bufferline').setup {
  options = {
    mode = "buffers", -- set to "tabs" to only show tabpages instead
    numbers = "none", -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string
    close_command = "bdelete! %d",     -- can be a string | function, see "Mouse actions"
    right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d",  -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil,      -- can be a string | function, see "Mouse actions"
    indicator = {
      icon = '▎', -- this should be omitted if indicator style is not 'icon'
      style = 'icon' -- 'icon' | 'underline' | 'none',
    },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    --- name_formatter can be used to change the buffer's label in the bufferline.
    --- Please note some names can/will break the
    --- bufferline so use this at your discretion knowing that it has
    --- some limitations that will *NOT* be fixed.
    --[[ name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
      -- remove extension from markdown files for example
      if buf.name:match('%.md') then
        return vim.fn.fnamemodify(buf.name, ':t:r')
      end
      return vim.fn.fnamemodify(buf.name, ':t')
    end, ]]
    max_name_length = 30,
    max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
    tab_size = 18,
    diagnostics =  false, -- false | "nvim_lsp" | "coc"
    diagnostics_update_in_insert = false,
    -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      return "("..count..")"
    end,
    -- NOTE: this will be called a lot so don't do any heavy processing here
    --[[ custom_filter = function(buf_number, buf_numbers)
      -- filter out filetypes you don't want to see
      if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
        return true
      end
      -- filter out by buffer name
      if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
        return true
      end
      -- filter out based on arbitrary rules
      -- e.g. filter out vim wiki buffer from tabline in your work repo
      if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
        return true
      end
      -- filter out by it's index number in list (don't show first buffer)
      if buf_numbers[1] ~= buf_number then
        return true
      end
    end, ]]
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer", -- "File Explorer" | function ,
        text_align = "center", -- "left" | "center" | "right"
        separator = true,
      }
    },
    color_icons = true, -- true | false -- whether or not to add the filetype icon highlights
    show_buffer_icons = true, -- true | false -- disable filetype icons for buffers
    show_buffer_close_icons = false, -- true | false
    show_buffer_default_icon = true, -- true | false -- whether or not an unrecognised filetype should show a default icon
    show_close_icon = true, -- true | false
    show_tab_indicators = true, -- true | false
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' }
    enforce_regular_tabs = false, -- false | true
    always_show_bufferline = true, -- true | false
    sort_by = 'insert_after_current', -- 'insert_after_current' | 'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b) return buffer_a.modified > buffer_b.modified end
  },
  highlights = {
    fill = {
        fg = { attribute = "fg", highlight = "TabLine" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Unfocused tabs
    tab = {
        fg = { attribute = "fg", highlight = "Comment" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Focused tab
    tab_selected = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Unfocused buffers
    background = {
        fg = { attribute = "fg", highlight = "TabLine" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Unfocused but visible buffers
    buffer_visible = {
        fg = { attribute = "fg", highlight = "TabLine" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Focused buffer
    buffer_selected = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "TabLine" },
        bold = true,
        italic = false,
    },
    -- Tab close button
    tab_close = {
        fg = { attribute = "fg", highlight = "Comment" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Unfocused buffers close button
    close_button = {
        fg = { attribute = "fg", highlight = "Comment" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Unfocused but visible buffers close button
    close_button_visible = {
        fg = { attribute = "fg", highlight = "Comment" },
        bg = { attribute = "bg", highlight = "Tabline" },
    },
    -- Focused buffer close button
    close_button_selected = {
        fg = { attribute = "fg", highlight = "Comment" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Unfocused buffers number
    -- numbers = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    -- },
    -- Unfocused but visible buffers number
    -- numbers_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    -- },
    -- Focused buffer number
    -- numbers_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    -- diagnostic = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    -- },
    -- diagnostic_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    -- },
    -- diagnostic_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    -- hint = {
    --     fg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- hint_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- hint_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    -- hint_diagnostic = {
    --     fg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- hint_diagnostic_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- hint_diagnostic_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    -- info = {
    --     fg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- info_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    -- },
    -- info_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    -- info_diagnostic = {
    --     fg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    -- },
    -- info_diagnostic_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    -- },
    -- info_diagnostic_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    -- warning = {
    --     fg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- warning_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- warning_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    -- warning_diagnostic = {
    --     fg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- warning_diagnostic_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- warning_diagnostic_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     sp = warning_diagnostic_fg,
    --     bold = true,
    --     italic = true,
    -- },
    -- error = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     sp = '<colour-value-here>'
    -- },
    -- error_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- error_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     italic = true,
    -- },
    -- error_diagnostic = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     sp = '<colour-value-here>'
    -- },
    -- error_diagnostic_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>'
    -- },
    -- error_diagnostic_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     sp = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    modified = {
        fg = { attribute = "fg", highlight = "Error" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    modified_visible = {
        fg = { attribute = "fg", highlight = "Error" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    modified_selected = {
        fg = { attribute = "fg", highlight = "Error" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- duplicate_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     italic = true,
    -- },
    -- duplicate_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     italic = true
    -- },
    -- duplicate = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     italic = true
    -- },
    -- Separator of unfocused buffers
    separator = {
        fg = { attribute = "fg", highlight = "Comment" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    separator_visible = {
        fg = { attribute = "fg", highlight = "Comment" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Separator of focused buffer
    separator_selected = {
        fg = { attribute = "fg", highlight = "Special" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    indicator_selected = {
        fg = { attribute = "fg", highlight = "Special" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Separator of unfocused tabs
    tab_separator = {
        fg = { attribute = "fg", highlight = "TabLine" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Separator of focused tab
    tab_separator_selected = {
        fg = { attribute = "fg", highlight = "TabLine" },
        bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- pick_selected = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    -- pick_visible = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    -- pick = {
    --     fg = '<colour-value-here>',
    --     bg = '<colour-value-here>',
    --     bold = true,
    --     italic = true,
    -- },
    -- offset_separator = {
    --     fg = { attribute = "fg", highlight = "Normal" },
    --     bg = { attribute = "bg", highlight = "Normal" },
    -- },
  }
}
