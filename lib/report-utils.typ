#import "@preview/js:0.1.3": *
#import "@preview/codelst:2.0.2": *

#let setup_report(
  body,
  lang: "ja",
  seriffont_cjk: "Harano Aji Mincho",
  sansfont_cjk: "Harano Aji Gothic",
  paper: "a4",
  margin: 14mm,
) = {
  show: js.with(
    lang: lang,
    seriffont-cjk: seriffont_cjk,
    sansfont-cjk: sansfont_cjk,
  )

  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )

  set text(
    lang: "ja",
    region: "JP",
  )

  set heading(numbering: none)

  show heading: set block(
    above: 2em,
    below: 1em,
  )

  show heading: it => {
    v(1.5em, weak: false)
    it
  }

  body
}

#let csv_table(
  path: "",
  caption: "",
  delimiter: ",",
  align: center + horizon,
  inset: 6pt,
) = {
  let data = csv(path, delimiter: delimiter)
  let headers = data.first()
  let rows = data.slice(1)

  [
    #figure(
      table(
        columns: (auto,) * headers.len(),
        inset: inset,
        align: align,
        stroke: none,

        table.hline(y: 0, stroke: 1.5pt),
        table.hline(y: 1, stroke: 0.8pt),

        ..headers,
        ..rows.flatten(),

        table.hline(stroke: 1.5pt),
      ),
      caption: caption,
      kind: table,
    )
    #v(1em)
  ]
}