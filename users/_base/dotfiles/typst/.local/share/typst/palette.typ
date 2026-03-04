#let palette = (
  base00: rgb("#@base00@"),
  base01: rgb("#@base01@"),
  base02: rgb("#@base02@"),
  base03: rgb("#@base03@"),
  base04: rgb("#@base04@"),
  base05: rgb("#@base05@"),
  base06: rgb("#@base06@"),
  base07: rgb("#@base07@"),
  base08: rgb("#@base08@"),
  base09: rgb("#@base09@"),
  base0A: rgb("#@base0A@"),
  base0B: rgb("#@base0B@"),
  base0C: rgb("#@base0C@"),
  base0D: rgb("#@base0D@"),
  base0E: rgb("#@base0E@"),
  base0F: rgb("#@base0F@"),
)

#{
  palette.insert("bg", palette.at("base00"))
  palette.insert("mg", palette.at("base03"))
  palette.insert("fg", palette.at("base05"))
  palette.insert("red", palette.at("base08"))
  palette.insert("orange", palette.at("base09"))
  palette.insert("yellow", palette.at("base0A"))
  palette.insert("green", palette.at("base0B"))
  palette.insert("cyan", palette.at("base0C"))
  palette.insert("blue", palette.at("base0D"))
  palette.insert("purple", palette.at("base0E"))
  palette.insert("brown", palette.at("base0F"))
}
