require("blame").setup({
  date_format = "%d.%m.%Y",
  virtual_style = "right_align", -- "right" (end of window) | "float" (end of line)
  views = { -- views that can be used when toggling blame
    default = require("blame.views.window_view"),
    window = require("blame.views.window_view"),
    virtual = require("blame.views.virtual_view"),
  },
  merge_consecutive = false, -- merge consecutive blames that are from the same commit
  max_summary_width = 30, -- if date_message is used, cut the summary if it excedes this number of characters
  colors = nil, -- list of RGB strings to use instead of randomly generated RGBs for highlights
  commit_detail_view = "vsplit", -- "tab" | "split" | "vsplit" | "current"
  format_fn = require("blame.formats.default_formats").date_message,
  mappings = {
    commit_info = "i",
    stack_push = "<Tab>",
    stack_pop = "<S-Tab>",
    show_commit = "<CR>",
    close = "q",
  },
})
