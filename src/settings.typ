// Global template settings.

#import "./palette.typ": *


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


// Environment counters reset at each top-level section.
#let section-counter-names = (
  "definition", "axiom", "theorem", "proposition", "lemma",
  "corollary", "example", "exercise", "problem",
)


