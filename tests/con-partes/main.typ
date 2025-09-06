

#import "../../src/template.typ": *




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






