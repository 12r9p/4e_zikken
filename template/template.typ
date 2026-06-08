#import "../lib/report-utils.typ": *
#show: setup_report

// ========== ここを編集 ==========
#let title = ""
#let place = ""
#let date = "2026年5月日"
#let whether = ""
#let teacher = " 教員"
// ================================

#v(10em)
#align(center, text(size: 16pt, weight: "bold", [#title]))
#v(6em)
#align(right, [
  2026年 4E 電気電子システム工学実験
])
#v(40em)
#align(left, [
  作成者： 佐藤 匠
])
#align(left, [
  作成日： #datetime.today().display("[year]年[month]月[day]日")
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

#pagebreak()

// ================================

= 目的

= 回路図

= 使用器具

= 結果

= 検討