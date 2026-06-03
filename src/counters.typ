// Counter helpers for numbered objects.

#import "./settings.typ": section-counter-names


#let reset-section-counters() = {
  for name in section-counter-names {
    counter(name).update(0)
    counter(figure.where(kind: name)).update(0)
  }
}

#let reset-figure-counters() = {
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
}

#let current-heading-number(depth, fallback: 1) = {
  let heading-numbers = counter(heading).get()
  if heading-numbers.len() >= depth {
    heading-numbers.at(depth - 1)
  } else {
    fallback
  }
}
