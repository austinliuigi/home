#let basic_palette = (
  base00: rgb("#FFFFFF"),
  base01: rgb("#FFFFFF"),
  base02: rgb("#FFFFFF"),
  base03: rgb("#BBBBBB"),
  base04: rgb("#888888"),
  base05: rgb("#666666"),
  base06: rgb("#444444"),
  base07: rgb("#000000"),
  base08: rgb("#FF0000"),
  base09: rgb("#FFA500"),
  base0A: rgb("#FFFF00"),
  base0B: rgb("#00FF00"),
  base0C: rgb("#00FFFF"),
  base0D: rgb("#0000FF"),
  base0E: rgb("#FF00FF"),
  base0F: rgb("#A52A2A"),
)

#{
  basic_palette.insert("bg", basic_palette.at("base00"))
  basic_palette.insert("mg", basic_palette.at("base03"))
  basic_palette.insert("fg", basic_palette.at("base05"))
  basic_palette.insert("red", basic_palette.at("base08"))
  basic_palette.insert("orange", basic_palette.at("base09"))
  basic_palette.insert("yellow", basic_palette.at("base0A"))
  basic_palette.insert("green", basic_palette.at("base0B"))
  basic_palette.insert("cyan", basic_palette.at("base0C"))
  basic_palette.insert("blue", basic_palette.at("base0D"))
  basic_palette.insert("purple", basic_palette.at("base0E"))
  basic_palette.insert("brown", basic_palette.at("base0F"))
}
