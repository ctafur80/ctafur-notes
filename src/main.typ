

// Color themes.
#let light-palette = (
  bg: rgb("fff"),
  fg: rgb("000"),
  math_hl_env_bg: gradient.linear(rgb("ededf7"), rgb("f5f5e9")),
  // math_env_bg_from: rgb("ededf7"),
  // math_env_bg_to: rgb("f5f5e9"),
  ax_env_bg: gradient.linear(rgb("faedf3"), rgb("f5f5e9")),
  // ax_env_bg_from: rgb("faedf3"),
  // ax_env_bg_to: rgb("f5f5e9"),
)

#let dark-palette = (
  bg: rgb("1e1e1e"),
  fg: rgb("a89e9e"),
  math_hl_env_bg: gradient.linear(rgb("2c2c3d"), rgb("3b3b30")),
  // math_env_bg_from: rgb("2c2c3d"),
  // math_env_bg_to: rgb("3b3b30"),
  ax_env_bg: gradient.linear(rgb("3d2c33"), rgb("3b3b30")),
  // ax_env_bg_from: rgb("3d2c33"),
  // ax_env_bg_to: rgb("3b3b30"),
)


// COLOR THEME SELECTION. <---------- !!!!!!!!!!!
// #let palette = light_palette
#let palette = dark-palette




#let templ(
  // dark_theme: false,
  sheet: "a4",
  lang: "en",
  title: none,
  authors: (), 
  abstract: [],
  // parts: false,
  outline-depth: 4,
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
          let this-page = counter(page).display()

          block[
            #text(style: "italic")[
              // TODO Solucionar el problema con esto.
              // #level.display(heading.numbering)
              ---
              #heading.body
              #h(1fr)
              #this-page
            ]
          ]
        }
      }
  ) // set page


  set text(
    // font: "Times New Roman",
    // size: 8pt,
    // weight: 100,
    // tracking: 0.6pt,
    //
    font: "Noto Sans",
    size: 8pt,
    weight: 300,
    tracking: 0.3pt,
    //
    // font: "New Computer Modern",
    // tracking: 0.2pt,
    // size: 10pt,
    fill: palette.fg,
  )

  show strong: set text(weight: 200)


  show raw: set text(
    font: "JetBrains Mono", // font: "JetBrainsMonoNL NF",
    size: 7pt,
  )


  // Default math font: Computer Modern (CM), the same as in TeX.
  show math.equation: set text(size: 9pt, weight: 100)
  /*
  show math.equation: it => {
    if it.body.func() == math.sans[].func(){
      it
    } else {
      math.equation(block: it.block, math.sans(it))
    }
  }
  */

  // Aún no se puede usar la siguiente. Creo que por un bug de la función
  // `show()`.
  // show math.text: set text(font: "Noto Sans", weight: 300, size: 7pt)
  // show math.text: text.with(font: "Noto Sans")







  // Headings
  show heading: set text(weight: 400)

  show heading.where(level: 1): set text(size: 14pt)
  show heading.where(level: 2): set text(size: 14pt)
  show heading.where(level: 3): set text(size: 10pt)
  show heading.where(level: 4): set text(size: 8pt)




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


  // Title page
  set align(center+horizon)
  text(weight: 400, size: 18pt, title)

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



  // Table of contents
  pagebreak()
  set align(left+top)
  // show outline.entry.where(level: 1): it => {
  //   set text(it, size: 36pt)
  // }
  v(3cm)
  outline(depth: outline-depth)




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
    if it.supplement != [Outline] {
      pagebreak(weak: true)
    }
    v(1.5em)
    it
    v(0.7em)
  }






  set footnote.entry(separator: line(length: 30% + 0pt, stroke: (thickness:
    0.5pt, paint: palette.fg)))










  set par(justify: true)
  doc
}


// Thematic pause.
#let hrule = block[
  #v(15pt)
  #line(length: 100%, stroke: (paint: palette.fg, thickness: 0.5pt, dash: "dashed"))
  #v(15pt)
]



// Maths Environments. TODO Try to put this in a separate file.
// ----------------------------------------------------------------------------------------


// Data for the different kinds of maths highlighted environments.
#let maths-hl-envs-data = (
  definition: (
    title: "definición",
    bg: palette.math_hl_env_bg,
    numbering: "i.",
  ),
  axiom: (
    title: "axioma",
    bg: palette.ax_env_bg,
    numbering: "i.",
  ),
  theorem: (
    title: "teorema",
    bg: palette.math_hl_env_bg,
    numbering: "i.",
  ),
  proposition: (
    title: "proposición",
    bg: palette.math_hl_env_bg,
    numbering: "i.",
  ),
  lemma: (
    title: "lema",
    bg: palette.math_hl_env_bg,
    numbering: "i.",
  ),
  corollary: (
    title: "corolario",
    bg: palette.math_hl_env_bg,
    numbering: "i.",
  )
)



// Generic maths highlighted environments function.
#let maths-hl-envs(kind, body, number: none, title: none, numbering: none, bg: none) = {

  let capitalize(text) = {
    if text == "" { "" } else {
      upper(text.slice(0, 1)) + text.slice(1,)
    }
  }

  let cfg = maths-hl-envs-data.at(kind)

  let numbering-style = if numbering != none { numbering } else { cfg.numbering }
  let fill-style = if bg != none { bg } else { cfg.bg }

  let displayed-number = if number != none { " " + number } else { "" }
  let displayed-title = if title != none { " (" + title + ")" } else { "" }

  // aplicar estilo de enumeración (si eso es lo que quieres)
  set enum(numbering: numbering-style)

  block(
    width: 100%,
    fill: fill-style,
    inset: 8pt,
    radius: 4pt,
  )[
    #text[*_#capitalize(cfg.title)#displayed-number#displayed-title._*]
    #body
  ]
}


// Highlighted maths environments.

// Helper/wrapper function.
#let make-math-env = kind => (body, number: none, title: none, numbering: none, bg: none) => maths-hl-envs(kind, body, number: number, title: title, numbering: numbering, bg: bg)

#let theorem = make-math-env("theorem")
#let definition = make-math-env("definition")
#let axiom = make-math-env("axiom")
#let proposition = make-math-env("proposition")
#let lemma = make-math-env("lemma")
#let corollary = make-math-env("corollary")



// Example
#let exmpl(body, number: none, title: none) = {
  let displayed-number = if number != none { " " + number } else { "" }
  let displayed-title = if title != none { " (" + title + ")" } else { "" }

  block[
    #text[*_Ejemplo#displayed-number#displayed-title._*]
    #body
    #h(1fr)
    $triangle.filled.br$
  ]
}

// Exercise
#let exr(body, number: none, title: none) = {
  let displayed-number = if number != none { " " + number } else { "" }
  let displayed-title = if title != none { " (" + title + ")" } else { "" }

  block[
    #text[*_Ejercicio#displayed-number#displayed-title._*]
    #body
    #h(1fr)
    $triangle.filled.br$
  ]
}

// Remark
#let remark(it) = {
  block[#text[*_Observación_*. #it #h(1fr) $triangle.filled.br$]]
}


// Remark about notation.
#let remark_notat(it) = {
  block[#text[*_Notación_*. #it#h(1fr)$triangle.filled.br$]]
}

// Remark about terminology.
#let remark_term(it) = {
  block[#text[*_Terminología_*. #it#h(1fr)$triangle.filled.br$]]
}



// TODO Put a reference to a math environment such as a theorem,
// proposition, etc.
#let proof(it) = {
  block[#text[*_Demostración_*~--- #it#h(1fr)$qed$]]
}





// Page number marker
#let new_page(page) = {
  assert(type(page) == int, message: "El argumento de 'pagina' debe ser un entero.")
  v(3.5em, weak: true)
  line(length: 100%, stroke: 1pt + luma(105))
  align(right)[#text(weight: "bold", style: "italic")[---~pág. #page]]
  v(1.5em, weak: true)
}



#let note() = {

}


#let diversion(it) = {
  block(
    fill: luma(55),
    inset: 8pt,
    radius: 4pt)[#text[#it]]
    // radius: 4pt)[#text[*_Desvío_*~--- #it]]
}



// TODO Entorno de tipo enum para los pasos en una demostración. Vea
// <https://forum.typst.app/t/can-you-make-a-horizontal-enum-list/877/3>.
/*
#let proof_steps(it) = enum(
  body-indent: 0em, #it
)
*/


