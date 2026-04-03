

#import "./palette.typ": *
#import "./utils.typ": *





// Data for the different kinds of maths highlighted environments.
#let maths_hl_envs_data = (
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



// TODO Unify highlighted environments and exercise-like environments, including remarks,
// etc.




// Generic maths highlighted environments function.
#let maths_hl_envs(kind, body, number: none, title: none, numbering: none, bg: none) = {

  let cfg = maths_hl_envs_data.at(kind)

  let numbering_style = if numbering != none { numbering } else { cfg.numbering }
  let fill_style = if bg != none { bg } else { cfg.bg }

  let displayed_number = if number != none { " " + number } else { "" }
  let displayed_title = if title != none { " (" + title + ")" } else { "" }

  set enum(numbering: numbering_style)

  block(
    width: 100%,
    fill: fill_style,
    inset: 8pt,
    radius: 4pt,
  )[
    #text[*_#capitalize(cfg.title)#displayed_number#displayed_title.---_* ]
    #body
  ]
}


// Highlighted maths environments.

// Wrapper function
#let make_math_env = kind => {
  (body, number: none, title: none, numbering: none, bg: none) => {
    maths_hl_envs(kind, body, number: number, title: title, numbering: numbering, bg: bg)
  }
}

#let definition = make_math_env("definition")
#let axiom = make_math_env("axiom")
#let theorem = make_math_env("theorem")
#let proposition = make_math_env("proposition")
#let lemma = make_math_env("lemma")
#let corollary = make_math_env("corollary")







// Data of exercise-like environments.
#let exr_like_envs_data = (
  example: (
    title: "ejemplo",
    final_marker: $triangle.filled.br$,
  ),
  exercise: (
    title: "ejercicio",
    final_marker: $triangle.filled.br$,
  ),
  problem: (
    title: "problema",
    final_marker: $triangle.filled.br$,
  ),
)



// Generic exercise-like environments function.
#let exr_like_envs(kind, body, number: none, title: none, final_marker: none) = {
  let cfg = exr_like_envs_data.at(kind)

  // elegir marcador
  let marker = if final_marker != none { final_marker } else { cfg.final_marker }

  let displayed_number = if number != none { " " + number } else { "" }
  let displayed_title = if title != none { " (" + title + ")" } else { "" }

  block[
    #text[*_#capitalize(cfg.title)#displayed_number#displayed_title.---_* ]
    #body
    // marcador al final
    #h(1fr) #marker
  ]
}


// Exercise-like environments (wrappers).
#let make_exr_env = kind => {
  (body, number: none, title: none, final_marker: none) => {
    exr_like_envs(kind, body, number: number, title: title, final_marker: final_marker)
  }
}

#let example = make_exr_env("example")
#let exercise = make_exr_env("exercise")
#let problem = make_exr_env("problem")





#let proof(it, ref: none) = {
  let displayed_ref = if ref != none { " (" + ref + ")" } else { "" }

  block[
    #text[*_Demostración#displayed_ref.~--- _*]
    #it
    #h(1fr)
    #text[$qed$]
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







// Page number marker
#let new_page(page) = {
  assert(type(page) == int, message: "El argumento de 'pagina' debe ser un entero.")
  v(3.5em, weak: true)
  line(length: 100%, stroke: 1pt + luma(105))
  align(right)[#text(weight: "bold", style: "italic")[---~pág. #page]]
  v(1.5em, weak: true)
}



// TODO Make a note environment.
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

// I think that it is not necessary.
// #let st = math.class("relation", "|")






