---@diagnostic disable: undefined-global
local snippets = {}

--==============================================================================
-- COMMENT COMMANDS
--==============================================================================
local comment_command_prefix = "cmd:"
local comment_commands = {
  {
    trig = comment_command_prefix .. "pause",
    desc = [[Pause slide here until manually advancing.]],
  },
  {
    trig = comment_command_prefix .. "end_slide",
    desc = [[Explicitly mark the end of a line].],
  },
  {
    trig = comment_command_prefix .. "new_line",
    desc = [[Explicitly create a new line. Used to add spacing since markdown ignores multiple linesbreaks in a row.]],
  },
  {
    trig = comment_command_prefix .. "new_lines:",
    desc = [[*(int)* Explicitly create a specified number of new lines. Used to add spacing since markdown ignores multiple linesbreaks in a row.]],
  },
  {
    trig = comment_command_prefix .. "jump_to_middle",
    desc = [[Jump to the middle of the page vertically.]],
  },
  {
    trig = comment_command_prefix .. "column_layout:",
    desc = [[*(int[])* Define a column layout. Format is a square-bracketed, comma-separated list of relative column sizes.]],
  },
  {
    trig = comment_command_prefix .. "column:",
    desc = [[*(int)* Enter a specified column of the current column layout. Zero-indexed.]],
  },
  {
    trig = comment_command_prefix .. "reset_layout",
    desc = [[Exit the current column layout.]],
  },
  {
    trig = comment_command_prefix .. "incremental_lists:",
    desc = [[(*true|false*) Make lists pause between each bullet point for the remainder of the slide.]],
  },
  {
    trig = comment_command_prefix .. "no_footer",
    desc = [[Don't show the footer in the current slide.]],
  },
  {
    trig = comment_command_prefix .. "font_size:",
    desc = [[*(1-7)* Change the font size for the remainder of the slide.]],
  },
  {
    trig = comment_command_prefix .. "alignment:",
    desc = [[*(left|right|center)* Change the alignment of text for the remainder of the slide.]],
  },
  {
    trig = comment_command_prefix .. "skip_slide",
    desc = [[Don't include the current slide in the presentation.]],
  },
  {
    trig = comment_command_prefix .. "list_item_newlines:",
    desc = [[*(int)* Configure the number of newlines between list item for the remainder of the slide.]],
  },
  {
    trig = comment_command_prefix .. "include:",
    desc = [[*(path)* Include the contents of an external markdown file as if it was part of the original presentation. Path is relative to current file.]],
  },
  {
    trig = comment_command_prefix .. "speaker_note:",
    desc = [[*(string)* Notes to display instead of the presentation for a speaker-listening instance.]],
  },
  {
    trig = comment_command_prefix .. "snippet_output:",
    desc = [[*(string)* Place the output of the code block with the corresponding identifier.]],
  },
}

-- stylua: ignore start
for _, comment_command in ipairs(comment_commands) do
  table.insert(snippets, s(
    {
      trig = comment_command.trig,
      desc = comment_command.desc
    },
    fmt(
      [[
        <!-- {}{} -->
      ]],
      {
        t(comment_command.trig),
        d(1, function()
          if string.match(comment_command.trig, ":$") then
            return sn(nil, {t(" "), i(1)})
          end
          return sn(nil, t(""))
        end)
      }
    ),
    {
      condition = require("luasnip.extras.conditions.expand").line_begin,
    }
  ))
end
-- stylua: ignore end

--==============================================================================
-- CODE BLOCK ATTRIBUTES
--==============================================================================
local code_block_attrs = {
  {
    trig = "+line_numbers",
    desc = [[Show line numbers in the presentation code block.]],
  },
  {
    trig = "+exec",
    desc = [[Mark the code block as able to be executed by a configured keybind.]],
  },
  {
    trig = "+exec:",
    desc = [[*(rust-script|pytest|uv)* Same as +exec but use an alternative executor.]],
  },
  {
    trig = "+acquire_terminal",
    desc = [[Must be used alongside +exec. Makes the execution of the code block seize control of the terminal.]],
  },
  {
    trig = "+no_background",
    desc = [[Don't show the code block background. Useful for +exec_replace.]],
  },
  {
    trig = "+exec_replace",
    desc = [[Execute the code block automatically upon presenting and show the output instead of the code block itself.]],
  },
  {
    trig = "+image",
    desc = [[Same as +exec_replace but assume the output of the execution is a raw image (e.g. `cat img.png`) and render it as such.]],
  },
  {
    trig = "+render",
    desc = [[Same as +exec_replace but render the output based on the language of the code block. Supported languages include `typst`, `latex`, `mermaid`, and `d2`.]],
  },
  {
    trig = "+validate",
    desc = [[Make a non-executable code block automatically execute when --validate-snippets. Not necessary if +exec or +exec_replace is already set.]],
  },
  {
    trig = "+expect:failure",
    desc = [[Expect the code block to return non-zero exit code. An exit code of 0 will be reported during validation with --validate-snippets.]],
  },
  {
    trig = "+id:",
    desc = [[*(string)* Sets an identifier for a code block to be used by the snippet_output comment command.]],
  },
}

-- stylua: ignore start
for _, code_block_attr in ipairs(code_block_attrs) do
  table.insert(
    snippets,
    s(
      {
        trig = code_block_attr.trig,
        desc = code_block_attr.desc,
      },
      fmt(
        [[
        {}{}
      ]],
        {
          t(code_block_attr.trig),
          d(1, function()
            if string.match(code_block_attr.trig, ":$") then
              return sn(nil, i(1))
            end
            return sn(nil, t(""))
          end),
        }
      ),
      {
        condition = function(line_to_cursor, matched_trigger, captures)
          if string.match(line_to_cursor, "^```%w") then
            return true
          end
          return false
        end,
        show_condition = function(line_to_cursor)
          if string.match(line_to_cursor, "^```%w") then
            return true
          end
          return false
        end,
      }
    )
  )
end
-- stylua: ignore end

return snippets
