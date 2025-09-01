local ls = require("luasnip")
local types = require("luasnip.util.types")

--==================================================================================================
-- Configuration
--==================================================================================================

-- configure filetypes that extend others
local ft_extensions = {
  bash = { "sh" },
  zsh = { "sh" },
}
for derived_ft, base_fts in pairs(ft_extensions) do
  ls.filetype_extend(derived_ft, base_fts)
end

ls.setup({
  history = true,
  update_events = { "TextChanged", "TextChangedI" },
  region_check_events = { "CursorMoved", "InsertEnter" },
  delete_check_events = { "TextChanged" },
  enable_autosnippets = false,
  ext_opts = {
    [types.insertNode] = {
      snippet_passive = {
        virt_text = { { "", "Base03" } },
        virt_text_pos = "inline",
        hl_mode = "combine",
      },
      visited = {
        virt_text = { { "", "Base01" } },
        virt_text_pos = "inline",
        hl_mode = "combine",
      },
      active = {
        virt_text = {},
        hl_group = "Underline",
      },
    },
    [types.choiceNode] = {
      snippet_passive = {
        virt_text = { { "➤", "Base03" } },
        virt_text_pos = "inline",
        hl_mode = "combine",
      },
      visited = {
        virt_text = { { "➤", "Base01" } },
        virt_text_pos = "inline",
        hl_mode = "combine",
      },
      active = {
        virt_text = { { "➤", "Base03" } },
        virt_text_pos = "inline",
        hl_mode = "combine",
      },
    },
    [types.exitNode] = {
      unvisited = {
        virt_text = { { "", "Base03" } },
        virt_text_pos = "inline",
        hl_mode = "combine",
      },
    },
  },
})

require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })

--==================================================================================================
-- Misc
--==================================================================================================

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n")
  end
end, {})

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "n")
  end
end, {})

vim.keymap.set({ "i", "s" }, "<S-Up>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<S-Up>", true, true, true), "n")
  end
end, {})

vim.keymap.set({ "i", "s" }, "<S-Down>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<S-Down>", true, true, true), "n")
  end
end, {})

vim.api.nvim_create_user_command("LuaSnipEdit", require("luasnip.loaders").edit_snippet_files, { nargs = 0 })

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    local luasnip = require("luasnip")
    if luasnip.in_snippet() then
      pcall(luasnip.activate_node, { select = false })
    end
  end,
})

local function fzf_snippets()
  -- Get available snippets
  local snippets = ls.available()

  -- Flatten the snippets table and prepare entries for fzf-lua
  local entries = {}
  for ft, snippet_list in pairs(snippets) do
    if type(snippet_list) == "table" then
      for _, snippet in ipairs(snippet_list) do
        local description = snippet.description[1] or "" -- Extract the first description if available
        local entry = string.format("%s  (%s) [%s]", snippet.trigger, description, ft)
        table.insert(entries, entry)
      end
    end
  end

  -- Use fzf-lua to search through snippets
  require("fzf-lua").fzf_exec(entries, {
    actions = {
      ["default"] = function(selected)
        if #selected > 0 then
          -- Extract the trigger from the selected entry
          local trigger = selected[1]:match("^(.-)%s+%(")

          -- Insert the trigger into the current buffer and go into insert mode
          vim.api.nvim_put({ trigger }, "c", true, true)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>a", true, true, true), "n", true)
        end
      end,
    },
  })
end

vim.api.nvim_create_user_command("LuaSnipFzfLua", fzf_snippets, { nargs = 0 })
require("config.plugins.configurations.fzf-lua")["LuaSnipFzfLua"] = fzf_snippets
