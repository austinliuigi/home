return {
  {
    "austinliuigi/silicon.lua",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    keys = {
      { '<leader>y', function() require("silicon").visualise_api({to_clip = true}) end, mode = {'x'} },
    },
    opts = {
      theme = "auto",
      output = "SILICON_${year}-${month}-${date}_${time}.png",
      bgColor = "#fff0",
      bgImage = "", -- path to image, must be png
      roundCorner = true,
      windowControls = true,
      lineNumber = true,
      font = "monospace",
      lineOffset = 1, -- from where to start line number
      linePad = 2, -- padding between lines
      padHoriz = 80, -- Horizontal padding
      padVert = 100, -- vertical padding
      shadowBlurRadius = 15,
      shadowColor = "#444444",
      shadowOffsetX = 8,
      shadowOffsetY = 8,
      gobble = false, -- enable lsautogobble like feature
      debug = true, -- enable debug output
    }
  },
}
