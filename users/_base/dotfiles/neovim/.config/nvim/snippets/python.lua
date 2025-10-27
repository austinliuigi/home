---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {}

table.insert(snippets, s(
  {
    trig="main",
    desc="Entry point of the python script"
  },
  fmt(
    [[
      def main():
          {}

      if __name__ == "__main__":
          main()
    ]],
    {
      i(0)
    }
  )
))

return snippets
