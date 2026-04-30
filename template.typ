#import "@preview/js:0.1.3": *
#import "@preview/codelst:2.0.2": *
#show: js.with(
  lang: "ja",
  seriffont-cjk: "Harano Aji Mincho",
  sansfont-cjk: "Harano Aji Gothic"
)
#set page(paper: "a4", margin: 14mm, numbering: "1")
#set text(lang: "ja", region: "JP")
#set heading(numbering: none)


// ========== ここを編集 ==========
#let title = "タイトル"
#let place = "場所"
#let date = "日付"
#let whether = "天候"
#let teacher = "担当教員"
// ================================

#v(10em)
#align(center, text(size: 16pt, weight: "bold", [#title]))
#v(6em)
#align(right,[
  2026年 4E 電気電子システム工学実験
])
#v(40em)
#align(left, [
  作成者： 佐藤 匠
])
#align(left, [
  提出日： #datetime.today().display("[year]年[month]月[day]日")
])
#align(left, [
  実験日： #date
])
#align(left, [
  天候： #whether
])
#align(left, [
  実験場所： #place
])
#align(left, [
  担当教員： #teacher
])
#v(2em)

#pagebreak()


// ================================

