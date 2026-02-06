---@diagnostic disable: undefined-global

local snippets = {}

local function generate_note_title()
  local function capitalize(str)
    return str:upper()
  end

  -- current filename without extension
  local target = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
  if target == "index" then
    -- current file's parent directory
    target = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h:t")
  end

  local result = target:gsub("_", " "):gsub("^(%a)", capitalize):gsub("( %a)", capitalize)
  return result
end

-- stylua: ignore start

local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    local heading_str = type(parent.snippet.env.LS_SELECT_RAW) == "table"
                        and table.concat(parent.snippet.env.LS_SELECT_RAW, "\n")
                        or parent.snippet.env.LS_SELECT_RAW
    local heading_stripped = heading_str:gsub("^=+%s+", "")
    return sn(nil, fmt([[
      {} {}

      #toc
    ]],
    {
      t(heading_str:match("^=+")),
      i(1, heading_stripped)
    }))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, fmt([[
      = {}

      #toc


    ]],
    {
      i(1, generate_note_title()),
    }))
  end
end

table.insert(snippets, s(
  {
    trig = "note",
    desc = "Boilerplate for notes"
  },
  fmt(
    [[
      #import "@local/notes:1.0.0"
      #import "@local/notes:1.0.0": toc, palette, def
      #show: notes.style

      {}
    ]],
    {
      d(1, get_visual),
    }
  )
))

return snippets
