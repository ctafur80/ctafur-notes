

#import "template.typ": *





// Template data.
#show: templ.with(
  sheet: "tablet",
  lang: "es",
  title: [Apuntes de Geometría Básica],
  authors: (
    (
      name: "Carlos E. Tafur Egido",
      affiliation: "Artos Institute",
      email: "tung@artos.edu",
    ),
  ),
  abstract: [
    Apuntes de la asignatura Geometría Básica del primer curso del grado
    universitario de matemáticas de la Universidad Nacional de Educación a
    Distancia (UNED).
  ],
)





// TODO When I put it in templ-book file it doesn't make any effect.
// Updating the counters by sections
#show heading.where(level: 1): it => {
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







// ----------------------------------------------------------------------------


= Introducción
#include("src/introduccion.typ")



= Parte 1. Geometría abstracta

  == Capítulo 1. Espacios métricos
  #include("src/espacios-metricos.typ")



= Parte 2. Geometría euclidea plana

  == Capítulo 2. Axiomas del plano euclideo
  #include("src/ax-plano-euclideo.typ")



= Parte 3. Geometría euclidea espacial





#bibliography("referencias.yaml", style: "ieee")






