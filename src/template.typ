

#import "./palette.typ": *
#import "./utils.typ": *
#import "./environments.typ": *



// Variables
// ----------------------------------------------------------------------------
#let body_weight = 300
#let bold_weight = 400


#let main_body_text_settings = (
  font: "Times",
  // font: "Noto Sans",
  size: 8pt,
  weight: body_weight,
  tracking: 0.3pt,

  /* Alts.
  font: "Times New Roman",
  size: 8pt,
  weight: 100,
  tracking: 0.6pt,

  font: "New Computer Modern",
  tracking: 0.2pt,
  size: 10pt,
  */
)


#let raw_font_text_settings = (
  font: "JetBrains Mono NL", // "JetBrainsMonoNL NL",
  size: 7pt,
  ligatures: false,
  weight: 200,
  features: (frac: 0, numr: 0, sups: 0, ordn: 0),
)





// Template
// ----------------------------------------------------------------------------
#let templ(
  // dark_theme: false,
  sheet: "a4",
  lang: "en",
  title: none,
  authors: (),
  abstract: [],
  // parts: false,
  outline_depth: 4,
  doc,
) = {

  set text(lang: lang)

  set page(
    fill: palette.bg,

    paper:
      if sheet == "tablet" {
        "a5"
      },

    margin:
    if sheet == "tablet" {
      (x: 8pt, y: 8pt)
    },

    // numbering: "1",

    footer: none,

    header:
      if sheet == "tablet" {
        none
      } else {
        context {
          let selector = selector(heading).before(here())
          let level = counter(selector)
          let headings = query(selector)

          if headings.len() == 0 {
            return
          }

          let heading = headings.last()
          let this_page = counter(page).display()

          block[
            #text(style: "italic")[
              // TODO Solucionar el problema con esto.
              // #level.display(heading.numbering)
              ---
              #heading.body
              #h(1fr)
              #this_page
            ]
          ]
        }
      }
  ) // set page


  set text(..main_body_text_settings)
  set text(fill: palette.fg)

  show strong: set text(weight: bold_weight)

  show raw: set text(..raw_font_text_settings)


  // Default math font: Computer Modern (CM), the same as in TeX.
  show math.equation: set text(size: 9pt, weight: 100, font: "STIX Two Math")
  // show math.equation: set text(size: 9pt, weight: 100)

  /*
  show math.equation: it => {
    if it.body.func() == math.sans[].func(){
      it
    } else {
      math.equation(block: it.block, math.sans(it))
    }
  }
  */

  // El problema con lo siguiente es que los números quiero dejarlos en CM.
  // show math.text: set text(font: "Noto Sans", weight: 300, size: 7pt)
  // Lo siguiente hace otra cosa parecida.
  // show math.text: text.with(font: "Noto Sans")



  // Headings
  show heading: set text(weight: bold_weight)

  show heading.where(level: 1): set text(size: 14pt)
  show heading.where(level: 2): set text(size: 12pt)
  show heading.where(level: 3): set text(size: 10pt)
  show heading.where(level: 4): set text(size: 8pt)
  show heading.where(level: 5): set text(size: 7pt)



  // Code block background.
  show raw.where(block: true): block.with(
    fill: luma(40),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
  )


  show figure.caption: set text(style: "italic")



  set par(
    justify: true,
    // first-line-indent: 1em,
    // leading: 0.6em,
  )

  // set heading(numbering: "1.")




  set table(stroke: 0.4pt + palette.fg)



  // Cambió en la versión 0.14 de Typst y ahora no funciona bien. El antiguo
  // está comentado justo después.
  // Enumerates automatically the labeled non-referenced equations.
  // set math.equation(numbering: "(1)")
  /*
  show math.equation: it => {
      if it.block and not it.has("label") [
        #counter(math.equation).update(v => v - 1)
        #math.equation(it.body, block: true, numbering: none)
      ] else {
        it
      }
  }
  */

  /*
  // Enumerates automatically the labeled non-referenced equations.
  set math.equation(numbering: "(1)")
  show math.equation: it => {
      if it.block and not it.has("label") [
        #counter(math.equation).update(v => v - 1)
        #math.equation(it.body, block: true, numbering: none)#label("")
      ] else {
        it
      }
  }
  */



  /*
  // TODO Try to merge it in the main Typst project for the Spanish language
  // behavior.
  show heading.where(level: 1): set heading(supplement: [Capítulo])
  show heading.where(level: 2): set heading(supplement: [Sección])
  show heading.where(level: 3): set heading(supplement: [Sección])
  show heading.where(level: 4): set heading(supplement: [Sección])
  show heading.where(level: 5): set heading(supplement: [Sección])
  show heading.where(level: 6): set heading(supplement: [Sección])
  */

  // Transforms every instance. I just want in math mode.
  // show "sin": name => { "sen" }
  // show "sin": set text(font: "Open Sans", size: 9pt)
  // show "lim": name => { "lím" }


  // TODO Sigue mal. La centra.
  // show bibliography: set heading(level: 2)


  // -- Title page --
  set align(center+horizon)
  text(weight: bold_weight, size: 18pt, title)

  v(2em)

  // Authors parameter.
  let count = authors.len()
  let ncols = calc.min(count, 3)
  grid(
    columns: (1fr,) * ncols,
    row-gutter: 24pt,
    ..authors.map(author => [#author.name \ #author.affiliation \ #link("mailto:" + author.email)])
  )

  v(3em)

  par(justify: false)[
    *Abstract* \
    #abstract
  ]
  // -- Title page --



  // Table of contents
  pagebreak()
  set align(left+top)
  // show outline.entry.where(level: 1): it => {
  //   set text(it, size: 36pt)
  // }
  v(3cm)
  outline(depth: outline_depth)
  pagebreak()




  // Makes a page break before every depth-1 heading.
  show outline: set heading(supplement: [Outline])
  show heading.where(depth: 1): it => {
    if it.supplement != [Outline] {
      pagebreak(weak: true)
    }
    v(4cm)
    it
    v(1.3em)
  }

  show heading.where(depth: 2): it => {
    v(2cm)
    it
    v(1em)
  }

  show heading.where(depth: 3): it => {
    v(1.5em)
    it
    v(0.7em)
  }



  // Footnotes marker.
  set footnote.entry(separator: line(length: 30% + 0pt, stroke: (thickness:
    0.5pt, paint: palette.fg)))





  set par(justify: true)
  doc
}





// TODO When I put it in templ-book file it doesn't make any effect.
// Updating the counters by sections
#show heading.where(level: 1): it => {
  // pagebreak()
  counter("proposition").update(0)
  counter("theorem").update(0)
  counter("example").update(0)
  counter("lemma").update(0)
  counter("corollary").update(0)
  counter("exercise").update(0)
  counter("axiom").update(0)
  counter("deffinition").update(0)
  it
}









