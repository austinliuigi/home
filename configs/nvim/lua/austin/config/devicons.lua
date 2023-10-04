require("nvim-web-devicons").setup {
 -- your personal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 --[[ override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 }; ]]
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}
require("nvim-web-devicons").set_default_icon('', '#ffffff')
