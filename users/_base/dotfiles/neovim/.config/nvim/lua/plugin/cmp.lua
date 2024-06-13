local cmp = require("cmp")
local compare = require("cmp.config.compare")

cmp.setup({
  enabled = function()
    local dap_loaded, dap
    pcall(require, "cmp_dap")
    return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt" or (dap_loaded and dap.is_dap_buffer())
  end,
  completion = {
    completeopt = "menu,menuone,noinsert,popup",
  },
  mapping = cmp.mapping.preset.insert({
    ["<Left>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
    ["<Right>"] = cmp.mapping(
      cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
      { "i", "c" }
    ),
    ["<C-Up>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Down>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
  }),
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = { hl_group = "CmpGhostText" },
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.score, -- prefer higher source priority, as calculated in :h cmp-config.sorting.priority_weight
      compare.offset, -- prefer matches that are closer to the beginning of the entry
      compare.exact, -- prefer entries with exact matches
      -- compare.scopes,
      compare.recently_used, -- prefer recently used entries
      compare.locality,
      compare.kind,
      -- compare.sort_text,
      compare.length, -- prefer shorter entries
      compare.order,
    },
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, vim_item)
      local kind_icons = {
        Class = "󰠱",
        Color = "󰏘",
        Constant = "",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "󰈙",
        Folder = "󰉋",
        Function = "󰊕",
        Interface = "󱐥",
        Keyword = "",
        Method = "󰊕",
        Module = "",
        Operator = "󰆕",
        Property = "",
        Reference = "󰶭",
        Snippet = "",
        Struct = "",
        Text = "󰉿",
        TypeParameter = "󰓼",
        Unit = "󰳂",
        Value = "󰎠",
        Variable = "󰀫",
      }
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

      local menu_text = {
        buffer = "[BUF]",
        calc = "[CALC]",
        cmdline = "[CMD]",
        cmdline_history = "[HIST]",
        dap = "[DAP]",
        luasnip = "[SNIP]",
        nvim_lsp = "[LSP]",
        nvim_lsp_signature_help = "[SIG]",
        nvim_lua = "[API]",
        path = "[PATH]",
      }
      vim_item.menu = menu_text[entry.source.name]

      return vim_item
    end,
  },
  sources = {
    { name = "neorg" },
    { name = "luasnip" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "calc" },
    { name = "buffer", keyword_length = 2, max_item_count = 4 },
  },
})

-- [DAP]
cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
  sources = {
    { name = "dap", trigger_characters = { "." } },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
  },
})

-- [CMDLINE]
cmp.setup.cmdline(":", {
  sources = {
    { name = "path" },
    { name = "nvim_lua" },
    { name = "cmdline", max_item_count = 20 },
    { name = "cmdline_history", max_item_count = 10, keyword_length = 3, priority = -100 },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
  },
  window = {
    completion = cmp.config.window.bordered(),
  },
})

-- [SEARCH]
for _, cmd_type in ipairs({ "/", "?" }) do
  cmp.setup.cmdline(cmd_type, {
    sources = {
      { name = "buffer", max_item_count = 5 },
      { name = "cmdline_history", max_item_count = 2, keyword_length = 3 },
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
    },
    window = {
      completion = cmp.config.window.bordered(),
    },
  })
end

-- vim.o.pumheight = 10 -- overall max_item_count

vim.api.nvim_exec_autocmds("User", { pattern = "CmpConfigLoaded" })
