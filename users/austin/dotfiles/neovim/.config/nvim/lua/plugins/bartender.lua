return {
  {
    "austinliuigi/bartender.nvim",
    dev = true,
    config = function()
      local bartender = require("bartender")
      local utils = require("bartender.utils")
      local sections = require("bartender.builtin.sections")
      -- local mode_component = require("bartender.builtin.components.mode")

      -- this is a function so that it can change value after startup
      local winbar_active_accent = function()
        return utils.get_hl_attr("@field", "foreground")
      end

      -- this is a function so that it can change value after startup
      local winbar_inactive_accent = function()
        return utils.get_hl_attr("@comment", "foreground")
      end


      bartender.setup({
        winbar = {
          active = {
            { sections.head, args = function() return {winbar_active_accent()} end },
            { sections.file },
            { sections.partition },
            { sections.navic },
            { sections.sharp_tail, args = function() return {winbar_active_accent()} end },
          },
          inactive = {
            { sections.head, args = function() return {winbar_inactive_accent()} end },
            { sections.file },
            { sections.partition },
            { sections.sharp_tail, args = function() return {winbar_inactive_accent()} end },
          }
        },
        statusline = {
          global = {
            { sections.mode },
            { sections.partition },
            { sections.cwd },
            { sections.partition },
            { sections.pos, args = function() return {utils.get_hl_attr("Comment", "fg")} end },
            { sections.round_tail, args = function() return {utils.get_hl_attr("Normal", "fg"), utils.get_hl_attr("Comment", "fg")} end },
            -- { sections.round_tail, args = function()
            --     local mode_hl = mode_component.get_current_mode_highlight()
            --     local mode_accent
            --     if mode_hl.reverse then
            --       mode_accent = mode_hl.fg
            --     else
            --       mode_accent = mode_hl.bg
            --     end
            --   return {mode_accent, utils.get_hl_attr("Cursor", "bg")}
            --   end
            -- },
          },
        },
        tabline = {
          global = {
            { sections.tabs },
          }
        },
      })
    end
  },
}
