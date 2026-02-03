require("neorg").setup({
  load = {
    ["core.defaults"] = {
      config = {},
    },

    ["core.keybinds"] = {
      config = {
        default_keybinds = false,
      },
    },

    ["core.concealer"] = {
      config = { -- Note that this table is optional and doesn't need to be provided
        icon_preset = "diamond",
        icons = {
          list = {
            -- icons = { "-", "   -", "      -", "         -", "            -", "               -" },
            icons = { "•", "   •", "      •", "         •", "            •", "               •" },
          },
          ordered = {
            icons = { "1.", " A.", "  a.", "   (1)", "    I.", "     i." },
          },
          heading = {
            icons = { "◆", "◈", "❖", "⬗", "◇", "" },
            -- icons = { "󰼏", "󰼐", "󰼑", "󰼒", "󰼓", "󰼔" },
          },
          todo = {
            undone = {
              icon = " ",
            },
          },
        },
        -- dim_code_blocks = nil,
        content_only = true,
        adaptive = true,
        width = "fullwidth",
        -- padding = nil,
        conceal = true,
      },
    },

    ["core.esupports.indent"] = {
      config = {
        dedent_excess = true,
        format_on_enter = false,
        format_on_escape = false,
        -- indents = {
        --   ["ranged_verbatim_tag_content"] = {
        --     modifiers = { "ranged-tag-end" },
        --     indent = 0,
        --   },
        -- },
      },
    },

    -- ["core.completion"] = {
    --   config = {
    --     engine = {
    --       module_name = "external.lsp-completion",
    --     },
    --   },
    -- },

    ["core.dirman"] = {
      config = {
        workspaces = {
          notes = "~/notes",
        },
      },
    },

    ["core.export"] = {
      config = {
        export_dir = "<export-dir>/<language>-export",
      },
    },

    ["core.export.markdown"] = {
      config = {
        extensions = "all",
      },
    },

    ["core.todo-introspector"] = {
      config = {
        highlight_group = "Comment",
      },
    },

    -- ["external.interim-ls"] = {
    --   config = {
    --     completion_provider = {
    --       enable = true,
    --       documentation = true, -- show file contents as documentation when you complete a file name
    --       categories = false, -- try to complete categories provided by Neorg Query. Requires `benlubas/neorg-query`
    --     },
    --   },
    -- },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Create neorg keybinds",
  pattern = "norg",
  callback = function()
    local neorg_leader = "-"
    local leader = vim.g.mapleader

    --------------- DIRMAN ---------------
    -- vim.keymap.set("n", neorg_leader .. "n", "<Plug>(neorg.dirman.new.note)", { buffer = 0, desc = "Create New Note" })

    --------------- HOP ---------------
    vim.keymap.set("n", "gl", "<Plug>(neorg.esupports.hop.hop-link)", { buffer = 0, desc = "Jump to Link" })
    vim.keymap.set(
      "n",
      "<leader>gl",
      "<Plug>(neorg.esupports.hop.hop-link)",
      { buffer = 0, desc = "Jump to Link (Vertical Split)" }
    )

    --------------- ITERO ---------------
    vim.keymap.set("i", "<C-CR>", "<Plug>(neorg.itero.next-iteration)", { buffer = 0, desc = "Continue Object" })
    vim.keymap.set("n", "<leader>o", "i<Plug>(neorg.itero.next-iteration)", { buffer = 0, desc = "Continue Object" })

    --------------- PROMO ---------------
    vim.keymap.set(
      "i",
      "<C-t>",
      "<Plug>(neorg.promo.promote)",
      { buffer = 0, desc = "Promote Object (Non-Recursively)" }
    )
    vim.keymap.set("i", "<C-d>", "<Plug>(neorg.promo.demote)", { buffer = 0, desc = "Demote Object (Non-Recursively)" })
    vim.keymap.set(
      "n",
      leader .. ">>",
      "<Plug>(neorg.promo.promote)",
      { buffer = 0, desc = "Promote Object (Non-Recursively)" }
    )
    vim.keymap.set(
      "n",
      leader .. "<<",
      "<Plug>(neorg.promo.demote)",
      { buffer = 0, desc = "Demote Object (Non-Recursively)" }
    )
    vim.keymap.set(
      "n",
      leader .. ">*",
      "<Plug>(neorg.promo.promote.nested)",
      { buffer = 0, desc = "Promote Object (Recursively)" }
    )
    vim.keymap.set(
      "n",
      leader .. "<*",
      "<Plug>(neorg.promo.demote.nested)",
      { buffer = 0, desc = "Demote Object (Recursively)" }
    )
    vim.keymap.set(
      "x",
      ">",
      "<Plug>(neorg.promo.promote.range)",
      { buffer = 0, desc = "Promote Object (Non-Recursively)" }
    )
    vim.keymap.set(
      "x",
      "<",
      "<Plug>(neorg.promo.demote.range)",
      { buffer = 0, desc = "Demote Object (Non-Recursively)" }
    )

    --------------- PIVOT ---------------
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "lt",
    --   "<Plug>(neorg.pivot.toggle-list-type)",
    --   { buffer = 0, desc = "Toggle List Type" }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "li",
    --   "<Plug>(neorg.pivot.invert-list-type)",
    --   { buffer = 0, desc = "Toggle List Type (Respecting Mixed List Types)" }
    -- )

    --------------- QOL TODO ---------------
    vim.keymap.set(
      "n",
      "<C-CR>",
      "<Plug>(neorg.qol.todo-items.todo.task-undone)",
      { buffer = 0, desc = "Mark as Undone" }
    )
    vim.keymap.set("n", "<CR>", "<Plug>(neorg.qol.todo-items.todo.task-done)", { buffer = 0, desc = "Mark as Done" })
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "1",
    --   "<Plug>(neorg.qol.todo-items.todo.task-undone)",
    --   { buffer = 0, desc = "Mark as Undone" }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "2",
    --   "<Plug>(neorg.qol.todo-items.todo.task-pending)",
    --   { buffer = 0, desc = "Mark as Pending" }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "3",
    --   "<Plug>(neorg.qol.todo-items.todo.task-done)",
    --   { buffer = 0, desc = "Mark as Done" }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "4",
    --   "<Plug>(neorg.qol.todo-items.todo.task-important)",
    --   { buffer = 0, desc = "Mark as Important" }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "5",
    --   "<Plug>(neorg.qol.todo-items.todo.task-on-hold)",
    --   { buffer = 0, desc = "Mark as On Hold" }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "6",
    --   "<Plug>(neorg.qol.todo-items.todo.task-cancelled)",
    --   { buffer = 0, desc = "Mark as Cancelled" }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "7",
    --   "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)",
    --   { buffer = 0, desc = "Mark as Ambigous" }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "0",
    --   "<Plug>(neorg.qol.todo-items.todo.task-recurring)",
    --   { buffer = 0, desc = "Mark as Recurring" }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. "-",
    --   "<Plug>(neorg.qol.todo-items.todo.task-done)",
    --   { buffer = 0, desc = "Mark as Done" }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   neorg_leader .. neorg_leader,
    --   "<Plug>(neorg.qol.todo-items.todo.task-cycle)",
    --   { buffer = 0, desc = "Cycle Task" }
    -- )
  end,
})

-- HACK: manually re-edit file if a norg buffer was opened before this configuration file loaded
--   - some modules, as well as our keybinds, set options on FileType
--   - some modules, e.g. indent, set options on BufEnter
if vim.o.filetype == "norg" then
  vim.cmd("e")
end
