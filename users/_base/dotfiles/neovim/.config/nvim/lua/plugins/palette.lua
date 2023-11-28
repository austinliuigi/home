return {
  {
    "austinliuigi/palette.nvim",
    dev = true,
    config = function()
      local config_ok, config = pcall(dofile, string.format("%s/palette.lua", vim.fn.stdpath("data")))
      if config_ok then
        require("palette").setup(config)
        vim.cmd("colorscheme palette")
      else
        vim.notify("config: palette config not found", vim.log.levels.ERROR)
      end
    end,
  },
}
