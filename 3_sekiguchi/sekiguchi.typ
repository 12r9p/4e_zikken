#import "@preview/js:0.1.3": *
#import "@preview/codelst:2.0.2": *
#show: js.with(
  lang: "ja",
  seriffont-cjk: "Harano Aji Mincho",
  sansfont-cjk: "Harano Aji Gothic"
)
#set page(paper: "a4", margin: 25mm, numbering: "1")
#set text(lang: "ja", region: "JP")
#set heading(numbering: none)


// ========== ここを編集 ==========
#let title = "タイトル"
// ================================


#align(center, text(size: 14pt, weight: "bold", [#title]))
#v(2em)
#align(right, [
  作成者： 佐藤 匠
  提出日： #datetime.today().display("[year]年[month]月[day]日")
])

#pagebreak()