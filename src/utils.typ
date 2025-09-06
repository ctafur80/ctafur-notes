

#import "./palette.typ": *



// Puts in uppercase just the first letter in a word.
#let capitalize(text) = {
  if text == "" { "" } else {
    upper(text.slice(0, 1)) + text.slice(1,)
  }
}



// Thematic pause.
#let hrule = block[
  #v(15pt)
  #line(length: 100%, stroke: (paint: palette.fg, thickness: 0.5pt, dash: "dashed"))
  #v(15pt)
]












