--- @module 'blink.cmp'
--- @class blink.cmp.Source
local source = {}

-- Called by blink when it starts; used to set config for this source
--- @param opts table set from user's blink config for `sources.providers.your_provider.opts`
--- @param config table the full `sources.providers.your_provider` table
function source.new(opts, config)
  -- vim.validate("your-source.opts.some_option", opts.some_option, { "string" })
  -- vim.validate("your-source.opts.optional_option", opts.optional_option, { "string" }, true)

  -- must return a metatable in this format
  local self = setmetatable({}, { __index = source })
  self.opts = opts
  return self
end

-- Called by blink when it queries for completion items
-- (Optional) Enable the source in specific contexts only
function source:enabled()
  return true
  -- return vim.bo.filetype == "lua"
end

-- (Optional) Non-alphanumeric characters that trigger the source
--   - https://cmp.saghen.dev/configuration/completion.html#trigger
-- function source:get_trigger_characters()
--   return { "." }
-- end

-- Called by blink when it queries for completion items to get a table of completion items
--- @param ctx table Context containing the current keyword, cursor pos, bufnr, etc.
--- @param callback function Shows the completion menu on first invocation. Appends items to the menu if it is already open. Must be called at least once in this function.
function source:get_completions(ctx, callback)
  -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItem
  --- @type lsp.CompletionItem[]
  local items = {}
  for i = 1, 10 do
    --- @type lsp.CompletionItem
    local item = {
      -- Label of the item in the UI. Typically the text that is completed to.
      label = "foo",

      -- (Optional) Item kind, where `Function` and `Method` will receive
      -- auto brackets automatically
      kind = require("blink.cmp.types").CompletionItemKind.Text,

      -- (Optional) Text to fuzzy match against. Default is the item's label.
      filterText = "bar",

      -- (Optional) Text to use for sorting. Default is the item's label. You
      -- may use a layout like 'aaaa', 'aaab', 'aaac', ... to control the order of the items
      sortText = "baz",

      -- Text to be inserted when accepting the item using ONE of:
      --
      -- (Recommended) Control the exact range of text that will be replaced
      textEdit = {
        newText = "item " .. i,
        range = {
          -- 0-indexed line and character, end-exclusive
          start = { line = ctx.cursor[1] - 1, character = ctx.bounds.start_col - 1 },
          ["end"] = { line = ctx.cursor[1] - 1, character = ctx.cursor[2] },
        },
      },

      -- Or get blink.cmp to guess the range to replace for you. Use this only
      -- when inserting *exclusively* alphanumeric characters. Any symbols will
      -- trigger complicated guessing logic in blink.cmp that may not give the
      -- result you're expecting
      -- Note that blink.cmp will use `label` when omitting both `insertText` and `textEdit`
      -- insertText = "foo",

      -- May be Snippet or PlainText. Works with both `textEdit` and `insertText`
      -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#snippet_syntax
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,

      -- There are some other fields you may want to explore which are blink.cmp
      -- specific, such as `score_offset` (blink.cmp.CompletionItem)
    }
    table.insert(items, item)
  end

  -- The callback _MUST_ be called at least once. The first time it's called,
  -- blink.cmp will show the results in the completion menu. Subsequent calls
  -- will append the results to the menu to support streaming results.
  --
  -- NOTE: blink.cmp will mutate the items you return, so you must vim.deepcopy them
  -- before returning if you want to re-use them in the future (such as for caching)
  callback({
    items = items,
    -- Whether blink.cmp should request items when deleting characters
    -- from the keyword (i.e. "foo|" -> "fo|")
    -- Note that any non-alphanumeric characters will always request
    -- new items (excluding `-` and `_`)
    is_incomplete_backward = false,
    -- Whether blink.cmp should request items when adding characters
    -- to the keyword (i.e. "fo|" -> "foo|")
    -- Note that any non-alphanumeric characters will always request
    -- new items (excluding `-` and `_`)
    is_incomplete_forward = false,
  })

  -- (Optional) Return a function which cancels the request
  -- If you have long running requests, it's essential you support cancellation
  return function() end
end

-- (Optional) Function used to lazily resolve some fields of the completion items, so you may avoid calculating expensive fields (i.e. documentation) for only when they're actually needed.
-- Happens before accepting the item or showing documentation, blink.cmp will call this function
-- Note only some fields may be resolved lazily. You may check the LSP capabilities for a complete list:
-- `textDocument.completion.completionItem.resolveSupport`
-- At the time of writing: 'documentation', 'detail', 'additionalTextEdits', 'command', 'data'
function source:resolve(item, callback)
  item = vim.deepcopy(item)

  -- Shown in the documentation window (<C-space> when menu open by default)
  item.documentation = {
    kind = "markdown",
    value = "# Foo\n\nBar",
  }

  -- Additional edits to make to the document, such as for auto-imports
  item.additionalTextEdits = {
    {
      newText = "foo",
      range = {
        start = { line = 0, character = 0 },
        ["end"] = { line = 0, character = 0 },
      },
    },
  }

  callback(item)
end

-- (Optional) Called immediately after applying the item's textEdit/insertText
-- Only useful when you want to customize how items are accepted,
-- beyond what's possible with `textEdit` and `additionalTextEdits`
function source:execute(ctx, item, callback, default_implementation)
  -- When you provide an `execute` function, your source must handle the execution
  -- of the item itself, but you may use the default implementation at any time
  default_implementation()

  -- The callback _MUST_ be called once
  callback()
end

return source
