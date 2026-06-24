
#import "./palette.typ": *
#import "./settings.typ": *
#import "./utils.typ": *
#import "./counters.typ": *
#import "./layout.typ": *
#import "./refs.typ": *
#import "./environments.typ": *
#import "./blocks.typ": *
#import "./math.typ": *
#import "./tables.typ": *


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
    1
  } else {
    env_counter_reset_depth
  }

  set figure(numbering: figure-numbering(chapter-depth))
  set page(..page-settings(sheet, tablet))

  // Figures are unbreakable blocks by default. The theorem-like environments
  // are wrapped in figures (so they can be labeled and referenced), but they
  // should still be allowed to break across pages.
  show figure: it => {
    if section-counter-names.contains(it.kind) {
      set block(breakable: true)
      it
    } else {
      it
    }
  }

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

  show ref: reference-rule

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

  title-page(title, authors, abstract)
  outline-page(outline_depth)

  show outline: set heading(supplement: [Outline])
  show heading: heading-layout(parts, chapter-depth, reset-depth)

  set footnote.entry(separator: line(
    length: 30% + 0pt,
    stroke: (thickness: 0.5pt, paint: palette.fg),
  ))

  set par(justify: true)
  doc
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


