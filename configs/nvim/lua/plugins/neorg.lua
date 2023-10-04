return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    ft = "norg",
    cmd = "Neorg",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    opts = {
      load = {
        ["core.defaults"] = {
          config = {}
        },

        ["core.keybinds"] = {
          config = {
            default_keybinds = false,
            neorg_leader = "-",
            hook = function(keybinds)
              local leader = keybinds.leader
              keybinds.map_event_to_mode("norg", {
                n = {
                  -- Marks the task under the cursor as "undone"
                  { leader .. "tu", "core.qol.todo_items.todo.task_undone", opts = { desc = "Mark as Undone" } },

                  -- Marks the task under the cursor as "pending"
                  { leader .. "tp", "core.qol.todo_items.todo.task_pending", opts = { desc = "Mark as Pending" } },

                  -- Marks the task under the cursor as "done"
                  { leader .. "td", "core.qol.todo_items.todo.task_done", opts = { desc = "Mark as Done" } },

                  -- Marks the task under the cursor as "on_hold"
                  { leader .. "th", "core.qol.todo_items.todo.task_on_hold", opts = { desc = "Mark as On Hold" } },

                  -- Marks the task under the cursor as "cancelled"
                  { leader .. "tc", "core.qol.todo_items.todo.task_cancelled", opts = { desc = "Mark as Cancelled" }, },

                  -- Marks the task under the cursor as "recurring"
                  { leader .. "tr", "core.qol.todo_items.todo.task_recurring", opts = { desc = "Mark as Recurring" }, },

                  -- Marks the task under the cursor as "important"
                  { leader .. "ti", "core.qol.todo_items.todo.task_important", opts = { desc = "Mark as Important" }, },

                  -- Marks the task under the cursor as "ambiguous"
                  { leader .. "ta", "core.qol.todo_items.todo.task_ambiguous", opts = { desc = "Mark as Ambigous" } },

                  -- Switches the task under the cursor between a select few states
                  { leader .. "tt", "core.qol.todo_items.todo.task_cycle", opts = { desc = "Cycle Task" } },

                  -- Creates a new .norg file to take notes in
                  { leader .. "n", "core.dirman.new.note", opts = { desc = "Create New Note" } },

                  -- Hop to the destination of the link under the cursor
                  { "gl", "core.esupports.hop.hop-link", opts = { desc = "Jump to Link" } },

                  -- Same as `<CR>`, except opens the destination in a vertical split
                  { "<leader>gl", "core.esupports.hop.hop-link", "vsplit", opts = { desc = "Jump to Link (Vertical Split)" }, },

                  { "<leader><C-.>", "core.promo.promote", opts = { desc = "Promote Object (Non-Recursively)" } },
                  { "<leader><C-,>", "core.promo.demote", opts = { desc = "Demote Object (Non-Recursively)" } },

                  { "<C-.>", "core.promo.promote", "nested", opts = { desc = "Promote Object (Recursively)" } },
                  { "<C-,>", "core.promo.demote", "nested", opts = { desc = "Demote Object (Recursively)" } },

                  { leader .. "lt", "core.pivot.toggle-list-type", opts = { desc = "Toggle (Un)ordered List" } },
                  { leader .. "li", "core.pivot.invert-list-type", opts = { desc = "Invert (Un)ordered List" } },

                  -- { leader .. "id", "core.tempus.insert-date", opts = { desc = "Insert Date" } },
                },
                i = {
                  { "<C-t>", "core.promo.promote", opts = { desc = "Promote Object (Non-Recursively)" } },
                  { "<C-d>", "core.promo.demote", opts = { desc = "Demote Object (Non-Recursively)" } },
                  { "<C-CR>", "core.itero.next-iteration", opts = { desc = "Continue Object" } },
                  -- { "<M-d>", "core.tempus.insert-date-insert-mode", opts = { desc = "Insert Date" } },
                },
                v = {
                  { "<leader>>", "core.promo.promote", opts = { desc = "Promote Object (Recursively)" } },
                  { "<leader><", "core.promo.demote", opts = { desc = "Demote Object (Recursively)" } },
                  { ">", "core.promo.promote", "nested", opts = { desc = "Promote Object (Recursively)" } },
                  { "<", "core.promo.demote", "nested", opts = { desc = "Demote Object (Recursively)" } },
                }
              }, {
                silent = true,
                noremap = true,
              })
              keybinds.remap("norg", "n", "<leader>o", "<cmd>Neorg keybind norg core.itero.next-iteration<CR>a")
            end
          }
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
          }
        },

        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          }
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
            export_dir = "<export-dir>/<language>-export"
          }
        },

        ["core.export.markdown"] = {
          config = {
            extensions = "all"
          }
        }

        -- ["core.gtd.base"] = {
        --   config = {
        --     workspace = "gtd",
        --   },
        -- },
      },
    },
  },
}
