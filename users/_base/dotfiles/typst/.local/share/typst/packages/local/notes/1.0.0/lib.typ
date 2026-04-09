#import "./palette.typ": palette
#import "./basic_palette.typ": basic_palette

// comment this out to use custom palette
#let palette = palette

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
    // TABLES/GRIDS
    //----------------------------------------------------------------------------
    #set table(stroke: 0.5pt + palette.mg)
    #show table: it => {
        align(center, it)
    }

    #show grid: it => {
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
    // LINKS
    //----------------------------------------------------------------------------
    #set underline(offset: 1.25pt)
    #set overline(offset: -1em)

    //----------------------------------------------------------------------------
    // CODE
    //----------------------------------------------------------------------------
    // TODO: if there is a language, add it to the top right of the block?
    #show raw.where(block: true): block.with(
        fill: color.mix((palette.bg, 75%), (palette.base01, 25%)),
        inset: 1.5em,
        radius: 3pt,
        width: 100%,
        stroke: 0.25pt + palette.base02,
    )
    #show raw.where(block: false): box.with(
        fill: color.mix((palette.bg, 20%), (palette.base01, 75%)),
        inset: (x: 2pt),
        outset: (y: 2pt),
        radius: 1.5pt,
    )
    #show raw.where(block: false): set text(1.2em)

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
        let size = 1em
        if it.level == 1 {
            col = color.mix((palette.fg, 35%), (palette.blue, 65%))
            size = 1.2em
        } else if it.level == 2 {
            col = color.mix((palette.fg, 35%), (palette.yellow, 65%))
            size = 1.1em
        } else if it.level == 3 {
            col = color.mix((palette.fg, 35%), (palette.green, 65%))
            size = 1.2em
        } else if it.level == 4 {
            col = color.mix((palette.fg, 35%), (palette.cyan, 65%))
            size = 1.2em
        } else if it.level == 5 {
            col = color.mix((palette.fg, 35%), (palette.purple, 65%))
            size = 1.2em
        } else if it.level == 6 {
            col = color.mix((palette.fg, 35%), (palette.orange, 65%))
            size = 1.2em
        }

        set text(fill: col)

        block(below: 12pt, above: 25pt)[
            #block(text(size: size, it), spacing: 0pt)
            #block(spacing: 0pt)[
                #line(stroke: 0.15pt + col)
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


// Color content
#let colorize(color, content) = text(fill: color, content)
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
    colorize(palette.orange.mix((palette.fg, 70%)), text(weight: 900, term))
}

// List of options
//
#let opt_list(..opts) = {
    let indent = false
    for item in opts.pos() {
        if indent {
            [
                #block(inset: (top: -4pt, left: 2em), item)
                \
            ]
        } else {
            strong(item)
        }
        indent = not indent
    }
}

// Pros and cons list
//
#let procon(pros: [], cons: []) = {
    if (pros != []) {
        [*Pros:*]
        {
            set text(palette.green)
            set list(marker: "+")
            pros
        }
    }

    if (cons != []) {
        [*Cons:*]
        {
            set text(palette.red)
            set list(marker: "-")
            cons
        }
    }
}

// Size brackets
//
#let lrXL(content) = math.lr(content, size: 200%)
#let lrL(content) = math.lr(content, size: 150%)
#let lrS(content) = math.lr(content, size: 50%)

//==============================================================================
// MATH
//==============================================================================

#let Cov = math.op("Cov")
#let Pr = math.op("Pr")
#let Var = math.op("Var")
#let Cov = math.op("Cov")

// convert a number to a string, split it into characters, and convert it back into digits
#let digits(x) = str(x).clusters().map(int)

#let long_division(dividend, divisor, quotient) = {
    let dividend_digits = digits(dividend)
    let divisor_digits = digits(divisor)
    let quotient_digits = digits(quotient)

    let digit_width = 0.6em

    let dividend_width = dividend_digits.len() * digit_width
    let divisor_width = divisor_digits.len() * digit_width
    let quotient_width = quotient_digits.len() * digit_width

    let digit_map(digit) = {
        box(width: digit_width, align(center, [#digit]))
    }

    stack(
        dir: ttb,
        spacing: 0.5em,

        // ROW 1
        stack(
            dir: ltr,
            spacing: 0em,

            h(dividend_width),

            // Quotient
            ..quotient_digits.map(digit_map),
        ),

        // ROW 2
        stack(
            dir: ltr,
            spacing: 0.05em,

            // Divisor
            ..divisor_digits.map(digit_map),

            // Separator (Divisor-Dividend)
            box(
                width: 0.5em,
                align(center, ")"),
            ),

            move(dy: -0.2em, stack(
                dir: ttb,
                spacing: 0.2em,

                // Separator (Dividend-Quotient)
                move(dx: -0.7 * digit_width, line(
                    length: dividend_width + 0.5 * digit_width,
                    stroke: 0.5pt + palette.fg,
                )),

                // Dividend
                stack(
                    dir: ltr,
                    spacing: 0em,
                    ..dividend_digits.map(digit_map),
                ),
            )),
        ),
    )
}


//==============================================================================
// ADMONITIONS
//==============================================================================

#let admonition_lite(heading, body, accent: palette.fg) = {
    let rad = 2pt
    // let bg_color = accent.transparentize(80%)
    // let border_color = accent.transparentize(50%)
    // let shadow_color = accent.transparentize(70%)
    let bg_color = color.mix((palette.bg, 80%), (accent, 20%))
    let border_color = color.mix((palette.bg, 30%), (accent, 70%))
    let shadow_color = color.mix((palette.bg, 50%), (accent, 50%))
    let shadow_offset = (4pt, 6pt)

    pad(
        bottom: shadow_offset.at(0),
        block(
            radius: rad,
            fill: shadow_color,
            move(
                dx: shadow_offset.at(0),
                dy: shadow_offset.at(1),
                block(
                    width: 100% - shadow_offset.at(0),
                    fill: bg_color,
                    radius: rad,
                    inset: 7pt,
                    stroke: 0.5pt + border_color,
                    text(fill: accent)[
                        *#heading* \
                        #body
                    ],
                ),
            ),
        ),
    )
}

#let admonition(
    heading,
    subheading,
    body,
    accent: palette.fg,
    width: 100%,
) = {
    let rad = 3pt
    // let heading_bg_color = accent.transparentize(50%)
    // let body_bg_color = accent.transparentize(80%)
    // let separator_color = accent.transparentize(20%)

    let heading_bg_color = color.mix((palette.bg, 50%), (accent, 50%))
    let body_bg_color = color.mix((palette.bg, 80%), (accent, 20%))
    let border_color = color.mix((palette.bg, 30%), (accent, 70%))
    let separator_color = accent

    if subheading != "" {
        subheading = [: #subheading]
    }

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
                inset: (x: 8pt, y: 6pt),
                stroke: (
                    x: 0.5pt + border_color,
                    top: 0.5pt + border_color,
                ),
                text(fill: accent)[*#heading*#subheading],
            ),
            line(stroke: 0.5pt + separator_color, length: width),
            block(
                width: width,
                fill: rgb(body_bg_color),
                inset: (
                    x: 8pt,
                    y: 12pt,
                ),
                radius: (
                    bottom: rad,
                ),
                stroke: (
                    x: 0.5pt + border_color,
                    bottom: 0.5pt + border_color,
                ),
                text(fill: accent)[#body],
            ),
            // block(
            //   width: width,
            //   fill: rgb(body_bg_color),
            //   radius: (
            //     bottom: rad,
            //   ),
            //   stroke: (
            //     left: 0.5pt + border_color,
            //     bottom: 0.5pt + border_color,
            //   ),
            //   " ",
            // ),
        )
    ]
}

// TODO: blend colors with main text color to ensure legibility

#let example(body, title: "") = admonition(
    " Example",
    title,
    body,
    accent: palette.green,
)

#let intuition(body, title: "") = admonition(
    "󰧑 Intuition",
    title,
    body,
    accent: palette.cyan,
)

#let derivation(body, title: "") = admonition(
    "⊶ Derivation",
    title,
    body,
    accent: palette.base04,
)

#let definition(body, title: "") = admonition(
    " Definition",
    title,
    body,
    accent: palette.base04,
)

#let etymology(body) = admonition_lite(
    " Etymology",
    body,
    accent: palette.purple,
)

#let analogy(body) = admonition_lite(
    "󰨎 Analogy",
    body,
    accent: palette.purple,
)

#let note(body) = admonition_lite(
    "🗅 Note",
    body,
    accent: palette.blue,
)

#let tip(body) = admonition_lite(
    " Tip",
    body,
    accent: palette.yellow,
)

#let warning(body) = admonition_lite(
    " Warning",
    body,
    accent: palette.orange,
)

#let important(body) = admonition_lite(
    " Important",
    body,
    accent: palette.red,
)
