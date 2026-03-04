---@diagnostic disable: undefined-global

local snippets = {}

local function get_guard_name()
  return vim.fn.fnamemodify(vim.fs.basename(vim.api.nvim_buf_get_name(0)), ":r"):upper() .. "_H"
end

table.insert(
  snippets,
  s(
    {
      trig = "ifndef",
      desc = "Include guard",
    },
    fmt(
      [[
        #ifndef {}
        #define {}

        {}

        #endif // {}
      ]],
      {
        f(get_guard_name),
        f(get_guard_name),
        i(0),
        f(get_guard_name),
      }
    )
  )
)

return snippets
