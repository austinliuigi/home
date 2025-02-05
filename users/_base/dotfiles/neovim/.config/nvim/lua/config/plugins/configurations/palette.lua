local config = {
  bold = true,
  italic = true,
  transparent = false,
  transparent_float = false,
  dim_nc_background = false,
  line = "underline",
}

vim.api.nvim_create_user_command("PaletteLoad", function()
  local palette_ok, palette = pcall(dofile, string.format("%s/palette.lua", vim.fn.stdpath("data")))
  if palette_ok then
    require("palette").setup(vim.tbl_extend("force", config, palette))
    vim.cmd("colorscheme palette")
  else
    vim.notify("config: palette config not found", vim.log.levels.ERROR)
  end
end, {})

vim.cmd("PaletteLoad")

vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  command = "PaletteLoad",
  nested = true,
})
