return {
  {
    'austinliuigi/lasso.nvim',
    -- dir = '~/tin/projects/neovim/personal/lasso.nvim/',
    keys = {
      {"y"}
    },
    config = function()
      require("lasso").setup()
    end
  },
}
