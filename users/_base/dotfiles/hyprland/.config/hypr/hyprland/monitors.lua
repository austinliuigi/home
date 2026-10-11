-- output: identifies monitor to configure
--   - get list of outputs using `hyprctl monitors all`
-- mode: specifies size and refresh rate (mode, "preferred", "highres", "highrr", "maxwidth")
--   - get available modes for output using `hyprctl monitors all`
-- position: specifies position of monitor in the virtual monitor layout ("-320x-1440", "auto", "auto-right", "auto-center-right")
--   - acts on effective resolution (takes into account scale)
--   - warnings will pop up position values cause monitors to overlap
-- scale: factor to scale screen by (integer)
--   - higher scale means more physical screen pixels are used to render a single logical pixel
--   - higher scale reduces the effective resolution, e.g. 1920x1080 at 1.5 scale has an effective resolution of 1280x720
--   - warnings will pop up if scale value causes effective resolution to not be whole numebrs

hl.monitor({
  output = "",
  mode = "highrr",
  position = "auto",
  scale = 1,
})

hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "0x0",
  scale = 1,
})
