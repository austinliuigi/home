//==============================================================================
// STYLE TEMPLATE
//==============================================================================
#let style(doc) = [
  // Document
  #set page(
    width: 450pt,
    height: auto,
    fill: rgb("#FEFCF6"),
  )
  #set text(
    font: ("Roboto Mono", "Courier"),
    fill: rgb("#555555"),
    size: 7pt,
    weight: "regular",
  )

  // Paragraphs
  #set par(leading: 1em, spacing: 2em)

  // Images
  #set image(width: 90%)
  #show image: it => {
    align(center, block(
      clip: true,
      radius: 2pt,
      spacing: 30pt,
      it,
    ))
  }

  // Links
  #show link: it => {
    set text(fill: blue)
    it
  }

  // Code
  #show raw.where(block: true): block.with(
    fill: luma(240),
    inset: 1.5em,
    radius: 3pt,
    width: 100%,
    stroke: 0.25pt + luma(100),
  )
  #show raw.where(block: false): box.with(
    fill: luma(240),
    inset: (x: 2pt),
    outset: (y: 2pt),
    radius: 2pt,
  )

  // TOC
  #show outline: it => {
    block(stroke: 0.5pt + luma(200), inset: 10pt, width: 100%)[
      *Table of Contents:*
      #line(length: 100%, stroke: 0.75pt + luma(100))
      #it
    ]
  }
  #show outline.entry: it => {
    link(
      it.element.location(),
      it.indented(it.prefix(), it.body()),
    )
  }

  // Headings
  #show heading: it => {
    set text(fill: luma(0))
    set line(start: (0pt, -1pt), length: 100% - 10pt, stroke: 0.25pt)
    show line: l => box(l)

    block(below: 12pt, above: 25pt)[
      #block(it, spacing: 0pt)
      #block(spacing: 0pt)[
        #if it.level == 1 {
          line(stroke: luma(0))
        } else if it.level == 2 {
          box(line(stroke: luma(100)))
        } else if it.level == 3 {
          line(stroke: luma(150))
        } else if it.level == 4 {
          line(stroke: luma(200))
        } else if it.level == 5 {
          line(stroke: luma(250))
        } else if it.level == 6 {
          line(stroke: luma(300))
        }
        #text(size: 4pt, weight: "medium", fill: rgb("#777777"))[#it.level]
      ]
    ]
  }

  #doc
]

//==============================================================================
// CUSTOM FUNCTIONS
//==============================================================================
// TEMPORARY FILLER FOR VIDEO
#let video(source, fallback_image, ..args) = {
  set image(..args)
  link(source, fallback_image)
}

#let cbox(content) = {
  align(center, block(content, stroke: 0.5pt + rgb("#BBBBBB"), inset: 5pt))
}

#let def(term) = {
  [#underline([*#term;*])]
}

#let admonition(heading, body, color: rgb("#444444"), body_color: none) = {
  let rad = 5pt
  if body_color == none {
    body_color = color.transparentize(40%)
  }

  stack(
    dir: ttb,
    spacing: -0.5pt,
    block(
      width: 100%,
      sticky: true,
      fill: rgb(color),
      radius: (
        top: rad,
      ),
      inset: 6pt,
      [*#heading*],
    ),
    block(
      width: 100%,
      fill: rgb(body_color),
      inset: 12pt,
      body,
    ),
    block(
      width: 100%,
      fill: rgb(body_color),
      radius: (
        bottom: rad,
      ),
      " ",
    ),
  )
}

#let example(body) = admonition("Example", body, color: rgb("#4c6e1a"))
