#import "./palette.typ": palette

//==============================================================================
// STYLE TEMPLATE
//==============================================================================
#let style(doc) = [
  //----------------------------------------------------------------------------
  // DOCUMENT
  //----------------------------------------------------------------------------
  #set page(
    width: 450pt,
    height: auto,
    fill: palette.bg,
  )
  #set text(
    font: ("Roboto Mono", "Courier"),
    fill: palette.fg,
    size: 7pt,
    weight: "regular",
  )

  //----------------------------------------------------------------------------
  // PARAGRAPHS
  //----------------------------------------------------------------------------
  #set par(leading: 1em, spacing: 2em)

  //----------------------------------------------------------------------------
  // IMAGES
  //----------------------------------------------------------------------------
  #set image(width: 90%)
  #show image: it => {
    align(center, block(
      clip: true,
      radius: 2pt,
      stroke: palette.mg,
      spacing: 30pt,
      it,
    ))
  }

  //----------------------------------------------------------------------------
  // TABLES
  //----------------------------------------------------------------------------
  #show table: it => {
    align(center, it)
  }

  //----------------------------------------------------------------------------
  // LINKS
  //----------------------------------------------------------------------------
  #show link: it => {
    set text(fill: palette.blue)
    it
  }

  //----------------------------------------------------------------------------
  // CODE
  //----------------------------------------------------------------------------
  // TODO: if there is a language, add it to the top right of the block?
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

  //----------------------------------------------------------------------------
  // MATH
  //----------------------------------------------------------------------------
  #set math.cancel(stroke: palette.mg)

  //----------------------------------------------------------------------------
  // HEADINGS
  //----------------------------------------------------------------------------
  #show heading: it => {
    set line(start: (0pt, -1pt), length: 100% - 10pt, stroke: 0.25pt)
    show line: l => box(l)

    let col = palette.fg
    if it.level == 1 {
      col = color.mix((palette.fg, 35%), (palette.blue, 65%))
    } else if it.level == 2 {
      col = color.mix((palette.fg, 35%), (palette.yellow, 65%))
    } else if it.level == 3 {
      col = color.mix((palette.fg, 35%), (palette.green, 65%))
    } else if it.level == 4 {
      col = color.mix((palette.fg, 35%), (palette.cyan, 65%))
    } else if it.level == 5 {
      col = color.mix((palette.fg, 35%), (palette.purple, 65%))
    } else if it.level == 6 {
      col = color.mix((palette.fg, 35%), (palette.orange, 65%))
    }

    set text(fill: col)

    block(below: 12pt, above: 25pt)[
      #block(it, spacing: 0pt)
      #block(spacing: 0pt)[
        #line(stroke: col)
        #text(size: 4pt, weight: "medium", fill: col)[#it.level]
      ]
    ]
  }

  #doc
]

//==============================================================================
// CUSTOM BINDINGS
//==============================================================================
#let toc = {
  show outline: it => {
    block(stroke: 0.5pt + palette.mg, inset: 10pt, width: 100%)[
      *Table of Contents:*
      #line(length: 100%, stroke: 0.75pt + palette.fg)
      #it
    ]
  }
  show outline.entry: it => {
    link(
      it.element.location(),
      it.indented(it.prefix(), it.body()),
    )
  }

  outline(title: none)
}

#let hl(color, content) = {
  highlight(fill: color.transparentize(75%), content)
}

// TEMP: Filler for video until it is implemented: https://github.com/typst/typst/issues/955
#let video(source, fallback_image, ..args) = {
  set image(..args)
  link(source, fallback_image)
}

// Create a boxed frame around the content and center it
//
#let cframe(content) = {
  align(center, block(content, stroke: 0.5pt + palette.mg, inset: 5pt))
}

// Create a boxed frame around the content
//
#let frame(alignment: center, content) = {
  align(alignment, block(content, stroke: 0.5pt + palette.mg, inset: 5pt))
}

// Style a term that is being defined
//
#let def(term) = {
  [*_#term;_*]
}

// Color content from math mode
#let col(content, color) = text(fill: color)[$#content$]

// TODO: Create a gallery of images
#let gallery() = {}

//==============================================================================
// ADMONITIONS
//==============================================================================

#let admonition_lite(heading, body, color: palette.fg) = {
  let rad = 2pt
  let bg_color = color.transparentize(80%)
  let border_color = color.transparentize(50%)

  block(
    width: 100%,
    fill: bg_color,
    radius: rad,
    inset: 7pt,
    stroke: 0.5pt + border_color,
    text(fill: color)[
      *#heading* \
      #body
    ],
  )
}

#let admonition(heading, body, color: palette.fg, width: 100%) = {
  let rad = 5pt
  let heading_bg_color = color.transparentize(50%)
  let body_bg_color = color.transparentize(80%)
  let separator_color = color.transparentize(20%)

  move(dx: 50% - width / 2)[
    #stack(
      dir: ttb,
      spacing: 0pt,
      block(
        width: width,
        sticky: true,
        fill: heading_bg_color,
        radius: (
          top: rad,
        ),
        inset: 8pt,
        text(fill: color)[*#heading*],
      ),
      line(stroke: 0.5pt + separator_color, length: width),
      block(
        width: width,
        fill: rgb(body_bg_color),
        inset: (
          x: 8pt,
          top: 12pt,
          bottom: 6pt,
        ),
        text(fill: color)[#body],
      ),
      block(
        width: width,
        fill: rgb(body_bg_color),
        radius: (
          bottom: rad,
        ),
        " ",
      ),
    )
  ]
}

// TODO: blend colors with main text color to ensure legibility

#let example(body) = admonition(
  " Example",
  body,
  color: palette.green,
)

#let intuition(body) = admonition(
  "󰧑 Intuition",
  body,
  color: palette.cyan,
)

#let derivation(body) = admonition(
  "⊶ Derivation",
  body,
  color: palette.base04,
)

#let definition(body) = admonition(
  " Definition",
  body,
  color: palette.base04,
  width: 70%,
)

#let etymology(body) = admonition_lite(
  " Etymology",
  body,
  color: palette.purple,
)

#let note(body) = admonition_lite(
  "🗅 Note",
  body,
  color: palette.blue,
)

#let tip(body) = admonition_lite(
  " Tip",
  body,
  color: palette.yellow,
)

#let warning(body) = admonition_lite(
  " Warning",
  body,
  color: palette.orange,
)

#let important(body) = admonition_lite(
  " Important",
  body,
  color: palette.red,
)
