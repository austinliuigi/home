local ls = require("luasnip")
local types = require("luasnip.util.types")

--==================================================================================================
-- Configuration
--==================================================================================================

-- configure filetypes that extend others
local ft_extensions = {
  bash = { "sh" },
  zsh = { "sh" },
  cpp = { "c" },
}
for derived_ft, base_fts in pairs(ft_extensions) do
  ls.filetype_extend(derived_ft, base_fts)
end

ls.setup({
  keep_roots = true,
  link_roots = true,
  exit_roots = false,
  link_children = true,
  store_selection_keys = "<Tab>",
  update_events = { "TextChanged", "TextChangedI" },
  region_check_events = { "CursorMoved", "InsertEnter" },
  delete_check_events = { "TextChanged", "InsertLeave" },
  enable_autosnippets = false,
  ext_opts = {
    [types.insertNode] = {
      snippet_passive = {
        virt_text = { { "", "Base03" } },
        virt_text_pos = "inline",
        hl_mode = "combine",
      },
      active = {
        virt_text = {},
      },
    },
    [types.choiceNode] = {
      snippet_passive = {
        virt_text = { { "➤", "Base03" } },
        virt_text_pos = "inline",
        hl_mode = "combine",
      },
      active = {
        virt_text = { { "➤", "Special" } },
      },
    },
    [types.exitNode] = {
      snippet_passive = {
        virt_text = { { "", "Base03" } },
        virt_text_pos = "inline",
        hl_mode = "combine",
      },
      active = {
        virt_text = {},
      },
    },
  },
})

require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })

--==================================================================================================
-- Misc
--==================================================================================================

----------------------------------------------------------------------------------------------------
-- Keybinds
----------------------------------------------------------------------------------------------------

local function feedkeys(key)
  -- the 'i' flag is necessary so that macros with <Tab> work correctly, o.w. the <Tab> would be appended to the end of the macro sequence in the typeahead buffer
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "ni")
end

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  else
    feedkeys("<Tab>")
  end
end, {})

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  else
    feedkeys("<S-Tab>")
  end
end, {})

vim.keymap.set({ "i", "s" }, "<S-Up>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  else
    feedkeys("<S-Up>")
  end
end, {})

vim.keymap.set({ "i", "s" }, "<S-Down>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  else
    feedkeys("<S-Down>")
  end
end, {})

vim.api.nvim_create_user_command("LuaSnipEdit", require("luasnip.loaders").edit_snippet_files, { nargs = 0 })

----------------------------------------------------------------------------------------------------
-- Activate node based on cursor position
----------------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    local luasnip = require("luasnip")
    if luasnip.in_snippet() then
      pcall(luasnip.activate_node, { select = false })
    end
  end,
})

----------------------------------------------------------------------------------------------------
-- Unlink snippet upon jumping to exit node
----------------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("User", {
  pattern = "LuasnipExitNodeEnter",
  callback = function()
    if ls.session.event_node.pos == 0 and ls.session.jump_active then
      ls.unlink_current()
    end
  end,
})

----------------------------------------------------------------------------------------------------
-- Fuzzy find snippets
----------------------------------------------------------------------------------------------------

local function fzf_snippets()
  -- Get available snippets
  local ft_to_snippet_infos = ls.available(function(snip)
    return {
      trigger = snip.trigger,
      docstring = snip:get_docstring()[1],
      description = snip.description[1] or "",
    }
  end)
  vim.print(ft_to_snippet_infos)

  -- Flatten the snippets table and prepare entries for fzf-lua
  local entries = {}
  local data = {}
  local max_trig_len = 0
  local max_docstring_len = 0
  local max_desc_len = 0

  for ft, snippet_infos in pairs(ft_to_snippet_infos) do
    if type(snippet_infos) == "table" then
      for _, snippet_info in ipairs(snippet_infos) do
        max_trig_len = math.max(max_trig_len, #snippet_info.trigger)
        max_docstring_len = math.max(max_docstring_len, #snippet_info.docstring)
        max_desc_len = math.max(max_desc_len, #snippet_info.description)
        table.insert(data, {
          trig = snippet_info.trigger,
          docstring = snippet_info.docstring,
          desc = snippet_info.description,
          ft = ft,
        })
      end
    end
  end
  for _, row in ipairs(data) do
    table.insert(
      entries,
      string.format(
        '%s%s  |  "%s"%s  |"%s"%s  |  [%s]',
        row.trig,
        string.rep(" ", max_trig_len - #row.trig),
        row.docstring,
        string.rep(" ", max_docstring_len - #row.docstring),
        row.desc,
        string.rep(" ", max_desc_len - #row.desc),
        row.ft
      )
    )
  end

  -- Use fzf-lua to search through snippets
  require("fzf-lua").fzf_exec(entries, {
    actions = {
      ["default"] = function(selected)
        if #selected > 0 then
          -- Extract the trigger from the selected entry
          local trigger = selected[1]:match("^(.-)%s+|")

          -- Insert the trigger into the current buffer and expand the snippet
          vim.api.nvim_put({ trigger }, "c", true, true)
          vim.cmd("startinsert!")
          ls.expand_or_jump()
        end
      end,
    },
  })
end

vim.api.nvim_create_user_command("LuaSnipFzfLua", fzf_snippets, { nargs = 0 })
require("config.plugins.configurations.fzf-lua")["LuaSnipFzfLua"] = fzf_snippets
