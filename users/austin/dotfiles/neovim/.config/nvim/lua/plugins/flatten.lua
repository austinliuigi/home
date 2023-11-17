return {
  {
    'willothy/flatten.nvim',
    priority = 1001, -- ensure that it runs first to minimize delay when opening file from terminal
    config = function()
      require("flatten").setup({
        window = {
          open = "tab",
          focus = "first",
        }
      })
    end
  },
}
