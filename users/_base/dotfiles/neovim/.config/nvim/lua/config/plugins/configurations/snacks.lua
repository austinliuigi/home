require("snacks").setup({
  bigfile = { enabled = true },
  styles = {
    snacks_image = {
      relative = "win",
      col = -1,
    },
  },
  image = {
    enabled = true,
    doc = {
      -- enable image viewer for documents
      -- a treesitter parser must be available for the enabled languages
      enabled = true,

      -- render the image inline in the buffer
      -- if your env doesn't support unicode placeholders, this will be disabled
      -- takes precedence over `opts.float` on supported terminals
      inline = false,

      -- render the image in a floating window
      -- only used if `opts.inline` is disabled
      float = true,

      max_width = 50,
      max_height = 40,

      -- Set to `true`, to conceal the image text when rendering inline.
      -- (experimental)
      ---@param lang string tree-sitter language
      ---@param type snacks.image.Type image type
      conceal = function(lang, type)
        return type == "math"
      end,
    },
    convert = {
      notify = true, -- show a notification on error
      magick = {
        default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
        vector = { "-density", 192, "{src}[0]" }, -- used by vector images like svg
        math = { "-density", 192, "{src}[0]", "-trim" },
        pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
      },
    },
  },
  quickfile = { enabled = true },
  scroll = {
    enabled = false,
    animate = {
      duration = { step = 25, total = 300 },
      easing = "outQuad",
    },

    -- faster animation when repeating scroll after delay
    animate_repeat = {
      delay = 100, -- delay in ms before using the repeat animation
      duration = { step = 5, total = 50 },
      easing = "outQuad",
    },

    -- what buffers to animate
    filter = function(buf)
      return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false
    end,
  },
})
