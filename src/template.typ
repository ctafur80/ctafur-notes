
#import "./palette.typ": *
#import "./utils.typ": *
#import "./environments.typ": *


// Typography
// ----------------------------------------------------------------------------

#let main_body_text_settings = (
  font: "Noto Sans",
  size: 8pt,
  weight: body_weight,
  tracking: 0.3pt,

  /* Alts.
  font: "Times New Roman",
  size: 8pt,
  weight: 100,
  tracking: 0.6pt,
  */

  // font: "New Computer Modern",
  // tracking: 0.2pt,
  // size: 10pt,
)

#let raw_font_text_settings = (
  font: "JetBrains Mono NL", // "JetBrainsMonoNL NL",
  size: 8pt,
  ligatures: false,
  weight: 200,
  features: (frac: 0, numr: 0, sups: 0, ordn: 0),
)


// Counters reset at each top-level section/chapter.
#let section-counter-names = (
  "definition", "axiom", "theorem", "proposition", "lemma",
  "corollary", "example", "exercise", "problem",
)

#let reset-section-counters() = {
  for name in section-counter-names {
    counter(name).update(0)
  }
}


// Template
// ----------------------------------------------------------------------------
#let templ(
  // dark_theme: false,
  sheet: "a4",
  lang: "en",
  title: none,
  authors: (),
  abstract: [],
  parts: false,
  outline_depth: 4,
  env_counter_reset_depth: auto,
  doc,
) = {
  set text(lang: lang)
  set heading(numbering: "1.")

  let tablet = sheet == "tablet"
  let chapter-depth = if parts { 2 } else { 1 }
  let reset-depth = if env_counter_reset_depth == auto {
    chapter-depth
  } else {
    env_counter_reset_depth
  }

  set page(
    fill: palette.bg,
    paper: if tablet { "a5" } else { sheet },
    margin: if tablet { (x: 8pt, y: 8pt) } else { auto },
    footer: none,
    header: if tablet {
      none
    } else {
      context {
        let headings = query(selector(heading).before(here()))
        if headings.len() == 0 {
          return
        }

        let heading = headings.last()
        let this_page = counter(page).display()

        block[
          #text(style: "italic")[
            // TODO Solucionar el problema con esto.
            // #counter(selector(heading).before(here())).display(heading.numbering)
            ---
            #heading.body
            #h(1fr)
            #this_page
          ]
        ]
      }
    },
  )

  set text(..main_body_text_settings)
  set text(fill: palette.fg)

  // show strong: set text(weight: bold_weight)

  show raw: set text(..raw_font_text_settings)

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

  show heading: set text(weight: heading_weight)
  show heading.where(level: 1): set text(size: 14pt)
  show heading.where(level: 2): set text(size: 12pt)
  show heading.where(level: 3): set text(size: 10pt)
  show heading.where(level: 4): set text(size: 8pt)
  show heading.where(level: 5): set text(size: 7pt)

  // show math.equation: set text(size: 1.2em, font: "New Computer Modern")
  show math.equation: set text(size: 1.2em)

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
  set align(center + horizon)
  text(weight: heading_weight, size: 18pt, title)

  v(2em)

  let ncols = calc.min(authors.len(), 3)
  grid(
    columns: (1fr,) * ncols,
    row-gutter: 24pt,
    ..authors.map(author => [#author.name \ #author.affiliation \ #link("mailto:" + author.email)]),
  )

  v(3em)

  par(justify: false)[
    *Abstract* \
    #abstract
  ]
  // -- Title page --

  pagebreak()
  set align(left + top)
  v(3cm)
  outline(depth: outline_depth)
  pagebreak()

  show outline: set heading(supplement: [Outline])
  show heading: it => {
    let section-depth = chapter-depth + 1
    let subsection-depth = chapter-depth + 2

    if it.level == reset-depth and it.supplement != [Outline] {
      reset-section-counters()
    }

    if it.level == 1 or (parts and it.level == chapter-depth) {
      if it.supplement != [Outline] {
        pagebreak(weak: true)
      }
      v(4cm)
      it
      v(1.3em)
    } else if it.level == section-depth {
      v(2cm)
      it
      v(1em)
    } else if it.level == subsection-depth {
      v(1.5em)
      it
      v(0.7em)
    } else {
      it
    }
  }

  set footnote.entry(separator: line(
    length: 30% + 0pt,
    stroke: (thickness: 0.5pt, paint: palette.fg),
  ))

  set par(justify: true)
  doc
}


#let norm(cuerpo) = {
  set text(..main_body_text_settings)
  show math.equation: set text(
    font: "New Computer Modern Math",
    size: 1.5em,
  )
  h(1.2em)
  cuerpo
}


#let emptyset = sym.diameter


#let func_sig(name, dom, codom, var, value) = [
  $ & name  & : && dom & -->         && codom \
    &       &   && var & mapsto.long && value $
]

// TODO Quizás sea mejor marcarlo como operador binario, en lugar de con
// espacios fijos.
#let iff = $#math.space #math.arrow.l.r.double.long #math.space$
#let implies = $#math.space #math.arrow.r.double.long #math.space$


// Highlight in a box.
#let hl(it) = align(center)[#rect(stroke: 0.3pt + palette.fg)[#it]]


#let table-header-cell(it) = {
  set text(weight: "bold", style: "italic")
  show math.equation: math.bold
  it
}

#let tbl-standard-head = table-header-cell

#let std_table(..items) = {
  show table.cell.where(y: 0): table-header-cell
  align(center)[#table(..items)]
}


// TODO Hacer una función para introducir cómodamente la hipótesis y la meta
// de inducción del paso inductivo.

  // #table(
  //   columns: 2,
  //   align: (left, left),
  //   stroke: none,
  //   [#sym.bullet hipótesis:],
  //     $m dot n = n dot m$,
  //   [#sym.bullet meta:],
  //     $m dot suc(n) = suc(n) dot m$,
  // )

// TODO Crear entorno de expresión simbólica alternativa de un resultado.
// TODO Crear entorno de expresión alternativa en Lean de un resultado.
// TODO Crear entorno de explicación de notación.
// TODO Crear entorno de explicación de terminología.
