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
        -- icons = nil,
        -- dim_code_blocks = nil,
        content_only = true,
        adaptive = true,
        width = "fullwidth",
        -- padding = nil,
        conceal = true,
      },
    },

    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },

    ["core.dirman"] = {
      config = {
        workspaces = {
          gtd = "~/.local/gtd",
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

    -- ["core.gtd.base"] = {
    --   config = {
    --     workspace = "gtd",
    --   },
    -- },
  },
})

vim.api.nvim_create_autocmd("Filetype", {
  desc = "Create neorg keybinds",
  pattern = "norg",
  callback = function()
    local neorg_leader = "-"
    local leader = vim.g.mapleader

    --------------- DIRMAN ---------------
    vim.keymap.set("n", neorg_leader .. "n", "<Plug>(neorg.dirman.new.note)", { buffer = 0, desc = "Create New Note" })

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
    vim.keymap.set("n", ">>", "<Plug>(neorg.promo.promote)", { buffer = 0, desc = "Promote Object (Non-Recursively)" })
    vim.keymap.set("n", "<<", "<Plug>(neorg.promo.demote)", { buffer = 0, desc = "Demote Object (Non-Recursively)" })
    vim.keymap.set(
      "n",
      leader .. ">>",
      "<Plug>(neorg.promo.promote.nested)",
      { buffer = 0, desc = "Promote Object (Recursively)" }
    )
    vim.keymap.set(
      "n",
      leader .. "<<",
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
    vim.keymap.set(
      "n",
      neorg_leader .. "lt",
      "<Plug>(neorg.pivot.toggle-list-type)",
      { buffer = 0, desc = "Toggle List Type" }
    )
    vim.keymap.set(
      "n",
      neorg_leader .. "li",
      "<Plug>(neorg.pivot.invert-list-type)",
      { buffer = 0, desc = "Toggle List Type (Respecting Mixed List Types)" }
    )

    --------------- QOL TODO ---------------
    vim.keymap.set(
      "n",
      neorg_leader .. "tu",
      "<Plug>(neorg.qol.todo-items.todo.task-undone)",
      { buffer = 0, desc = "Mark as Undone" }
    )
    vim.keymap.set(
      "n",
      neorg_leader .. "tp",
      "<Plug>(neorg.qol.todo-items.todo.task-pending)",
      { buffer = 0, desc = "Mark as Pending" }
    )
    vim.keymap.set(
      "n",
      neorg_leader .. "td",
      "<Plug>(neorg.qol.todo-items.todo.task-done)",
      { buffer = 0, desc = "Mark as Done" }
    )
    vim.keymap.set(
      "n",
      neorg_leader .. "th",
      "<Plug>(neorg.qol.todo-items.todo.task-on-hold)",
      { buffer = 0, desc = "Mark as On Hold" }
    )
    vim.keymap.set(
      "n",
      neorg_leader .. "tc",
      "<Plug>(neorg.qol.todo-items.todo.task-cancelled)",
      { buffer = 0, desc = "Mark as Cancelled" }
    )
    vim.keymap.set(
      "n",
      neorg_leader .. "tr",
      "<Plug>(neorg.qol.todo-items.todo.task-recurring)",
      { buffer = 0, desc = "Mark as Recurring" }
    )
    vim.keymap.set(
      "n",
      neorg_leader .. "ti",
      "<Plug>(neorg.qol.todo-items.todo.task-important)",
      { buffer = 0, desc = "Mark as Important" }
    )
    vim.keymap.set(
      "n",
      neorg_leader .. "ta",
      "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)",
      { buffer = 0, desc = "Mark as Ambigous" }
    )
    vim.keymap.set(
      "n",
      neorg_leader .. "tt",
      "<Plug>(neorg.qol.todo-items.todo.task-cycle)",
      { buffer = 0, desc = "Cycle Task" }
    )
  end,
})

-- HACK: manually trigger filetype autocmd if a norg buffer was opened before this configuration file loaded
if vim.o.filetype == "norg" then
  vim.api.nvim_exec_autocmds("Filetype", {
    pattern = "norg",
  })
end
