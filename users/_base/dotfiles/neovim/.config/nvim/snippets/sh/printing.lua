---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {}

----------------------------------------------------------------------------------------------------

table.insert(snippets, s({trig = "printpdf", desc = "Print to pdf (located in \"Out\" directory configured in /etc/cups/cups-pdf-pdf.conf)"},
  fmt(
    [[
      pdfjam --outfile /dev/stdout --scale 1 {} | lp -d {}
    ]],
    {
      i(1, "path/to/file.(pdf,ps,eps,jpg,png)"),
      i(0, "pdf")
    }
  )
))

----------------------------------------------------------------------------------------------------

table.insert(snippets, s({trig = "printtest", desc = "Print a single page to test the print settings"},
  fmt(
    [[
      pdfjam --outfile /dev/stdout --scale 1 {} '1' | lp -d {}
    ]],
    {
      i(1, "file"),
      -- TODO: get a list of destinations and make a choice node (or use shell completion)
      i(0)
    }
  )
))

----------------------------------------------------------------------------------------------------

return snippets
