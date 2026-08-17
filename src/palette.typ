
// Document themes


#let light_palette = (
  bg: rgb("fff"),
  fg: rgb("000"),
  math_hl_env_bg: gradient.linear(rgb("ededf7"), rgb("f5f5e9")),
  ax_env_bg: gradient.linear(rgb("faedf3"), rgb("f5f5e9")),
)


#let dark_palette = (
  bg: rgb("1e1e1e"),
  fg: rgb("a89e9e"),
  math_hl_env_bg: gradient.linear(rgb("22222b"), rgb("262621")),
  ax_env_bg: gradient.linear(rgb("261d20"), rgb("262621")),
)


// CHOOSE the color palette/theme for the document.
#let palette = dark_palette // Alt.: light_palette


// Typography weights (body and headings).
#let body_weight = 350
#let heading_weight = 500


