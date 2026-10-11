require("mini.animate").setup({
  cursor = {
    enable = false,
  },
  scroll = {
    enable = false,
    timing = require("mini.animate").gen_timing.cubic({ easing = "out", duration = 12, unit = "step" }),
  },
  resize = {
    enable = false,
    timing = require("mini.animate").gen_timing.cubic({ easing = "out", duration = 80, unit = "total" }),
  },
  open = {
    enable = false,
  },
  close = {
    enable = false,
  },
})
