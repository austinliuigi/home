---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {}

table.insert(snippets, s(
  {
    trig = "snippet",
  },
  fmt(
    [=[
      table.insert(snippets, s(
        {{
          trig = "{}",
          desc = "{}"
        }},
        fmt(
          [[
            {}
          ]],
          {{
            {}
          }}
        ){}
      ))
    ]=],
    {
      i(1, "trig"),
      i(2, "desc"),
      i(3, "body"),
      i(4, "nodes"),
      c(5, {
        t(""),
        fmt(
          [[
            , {{
                condition = function()
                  {}
                end
              }}
          ]],
          {
            i(1)
          }
        )
      }),
    }
  ), {
    condition = function()
      local dir = vim.fn.split(vim.fn.expand("%:p:h"), "/")
      return dir[#dir] == "snippets"
    end,
    show_condition = function()
      local dir = vim.fn.split(vim.fn.expand("%:p:h"), "/")
      return dir[#dir] == "snippets"
    end,
  }
))

table.insert(snippets, s(
  {
    trig = "autocmd",
  },
  fmt(
    [[
      vim.api.nvim_create_augroup("{}", {{clear = true}})
      vim.api.nvim_create_autocmd({{ "{}" }}, {{
        group   = "{}",
        pattern = {{'{}'}},
        callback = function()
          {}
        end,
      }})
    ]],
    {
      i(1),
      i(2, "BufEnter"),
      rep(1),
      i(3, "*"),
      i(0),
    }
  )
))

return snippets
