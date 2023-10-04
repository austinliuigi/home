local animate = require("mini.animate")

local timing = animate.gen_timing.cubic({duration = 375, unit = "total", easing = "out"})

animate.setup({
  cursor = {
    enable = true,
    timing = timing,
  },
  scroll = {
    enable = true,
    timing = timing,
  }
})
