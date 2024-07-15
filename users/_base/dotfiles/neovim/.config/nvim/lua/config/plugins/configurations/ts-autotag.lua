require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false, -- Auto close on trailing </ (only makes sense if enable_close is false)
  },
  per_filetype = {
    ["html"] = {
      enable_close_on_slash = true,
    },
  },
})
