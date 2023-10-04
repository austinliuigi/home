return {
  {
    "NeogitOrg/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("neogit").setup {
        disable_signs = false,
        disable_hint = false,
        disable_context_highlighting = true,
        disable_commit_confirmation = false,
        -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size. 
        -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
        auto_refresh = true,
        sort_branches = "-committerdate",
        disable_builtin_notifications = false,
        -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example
        -- below will use the native fzf sorter instead.
        telescope_sorter = function()
          return require("telescope").extensions.fzf.native_fzf_sorter()
        end,
        use_magit_keybindings = false,
        -- Change the default way of opening neogit
        kind = "tab",
        -- Change the default way of opening the commit popup
        commit_popup = {
          kind = "split",
        },
        -- Change the default way of opening popups
        popup = {
          kind = "split",
        },
        -- customize displayed signs
        signs = {
          -- { CLOSED, OPENED }
          section = { "", "" },
          item = { "", "" },
          hunk = { "", "" },
        },
        integrations = {
          telescope = true,
          diffview = true,
        },
        -- Setting any section to `false` will make the section not render at all
        sections = {
          untracked = {
            folded = false,
            hidden = false
          },
          unstaged = {
            folded = false,
            hidden = false
          },
          staged = {
            folded = false,
            hidden = false
          },
          stashes = {
            folded = true,
            hidden = false
          },
          unpulled = {
            folded = true,
            hidden = false
          },
          unmerged = {
            folded = false,
            hidden = false
          },
          recent = {
            folded = true,
            hidden = false
          },
        },
        -- override/add mappings
        mappings = {
          -- modify status buffer mappings
          status = {
            -- ["a"] = "Stage",
            -- ["A"] = "StageAll",
            -- ["zo"] = "Toggle",
            -- ["zc"] = "Toggle",
          }
        }
      }
    end
  }
}
