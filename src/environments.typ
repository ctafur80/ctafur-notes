
#import "./palette.typ": *
#import "./utils.typ": *


// Data for the different kinds of maths highlighted environments.
#let maths_hl_envs_data = (
  definition: (
    title: "definición",
    bg: palette.math_hl_env_bg,
    numbering: "1",
  ),
  axiom: (
    title: "axioma",
    bg: palette.ax_env_bg,
    numbering: "1",
  ),
  theorem: (
    title: "teorema",
    bg: palette.math_hl_env_bg,
    numbering: "1",
  ),
  proposition: (
    title: "proposición",
    bg: palette.math_hl_env_bg,
    numbering: "1",
  ),
  lemma: (
    title: "lema",
    bg: palette.math_hl_env_bg,
    numbering: "1",
  ),
  corollary: (
    title: "corolario",
    bg: palette.math_hl_env_bg,
    numbering: "1",
  ),
)


// TODO Unify highlighted environments and exercise-like environments, including remarks,
// etc.


// Generic maths highlighted environments function.
#let env_figure_numbering(number, numbering-pattern) = {
  if number == auto {
    numbering-pattern
  } else if number == none {
    none
  } else {
    n => number
  }
}


#let env_auto_number(kind, numbering-pattern) = context {
  let heading-numbers = counter(heading).get()
  let top-level-number = if heading-numbers.len() > 0 {
    heading-numbers.first()
  } else {
    1
  }

  let env-number = counter(figure.where(kind: kind)).display(numbering-pattern)
  [#top-level-number.#env-number]
}


#let env_number(kind, number, numbering-pattern) = {
  if number == auto {
    env_auto_number(kind, numbering-pattern)
  } else {
    number
  }
}


#let maths_hl_envs(kind, body, number: auto, title: none, numbering: none, bg: none) = {
  let cfg = maths_hl_envs_data.at(kind)
  let env-numbering = if numbering != none { numbering } else { cfg.numbering }
  let suffix = env_title_suffix(
    number: env_number(kind, number, env-numbering),
    title: title,
  )

  figure(
    kind: kind,
    supplement: [#capitalize(cfg.title)],
    numbering: env_figure_numbering(number, env-numbering),
    outlined: false,
    block(
      width: 100%,
      fill: if bg != none { bg } else { cfg.bg },
      inset: 8pt,
      radius: 4pt,
    )[
      #set align(left)
      #set par(justify: true)
      #set enum(numbering: env-numbering)
      #text[*_#capitalize(cfg.title)#suffix.---_* ]
      #body
    ],
  )
}


#let make_math_env(kind) = {
  (body, number: auto, title: none, numbering: none, bg: none) => {
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
    numbering: "1",
    final_marker: $triangle.filled.br$,
  ),
  exercise: (
    title: "ejercicio",
    numbering: "1",
    final_marker: $triangle.filled.br$,
  ),
  problem: (
    title: "problema",
    numbering: "1",
    final_marker: $triangle.filled.br$,
  ),
)


// Generic exercise-like environments function.
#let exr_like_envs(kind, body, number: auto, title: none, numbering: none, final_marker: none) = {
  let cfg = exr_like_envs_data.at(kind)
  let env-numbering = if numbering != none { numbering } else { cfg.numbering }
  let suffix = env_title_suffix(
    number: env_number(kind, number, env-numbering),
    title: title,
  )
  let marker = if final_marker != none { final_marker } else { cfg.final_marker }

  figure(
    kind: kind,
    supplement: [#capitalize(cfg.title)],
    numbering: env_figure_numbering(number, env-numbering),
    outlined: false,
    block(width: 100%)[
      #set align(left)
      #set par(justify: true)
      #set enum(numbering: env-numbering)
      #text[*_#capitalize(cfg.title)#suffix.---_* ]
      #body
      #h(1fr) #marker
    ],
  )
}


#let make_exr_env(kind) = {
  (body, number: auto, title: none, numbering: none, final_marker: none) => {
    exr_like_envs(
      kind,
      body,
      number: number,
      title: title,
      numbering: numbering,
      final_marker: final_marker,
    )
  }
}

#let example = make_exr_env("example")
#let exercise = make_exr_env("exercise")
#let problem = make_exr_env("problem")


#let proof(it, ref: none) = {
  block[
    #text[*_Demostración#env_parenthetical(ref).~--- _*]
    #it
    #h(1fr)
    #text[$qed$]
  ]
}


#let remark(it) = {
  block[#text[*_Observación_*. #it #h(1fr) $triangle.filled.br$]]
}

#let remark_notat(it) = {
  block[#text[*_Notación_*. #it#h(1fr)$triangle.filled.br$]]
}

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
#let note() = {}


#let diversion(it) = {
  block(
    fill: luma(55),
    inset: 8pt,
    radius: 4pt,
  )[#text[#it]]
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
