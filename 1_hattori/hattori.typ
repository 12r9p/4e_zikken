#import "../lib/report-utils.typ": *
#show: setup_report

// ========== ここを編集 ==========
#let title = "デジタル信号処理"
#let place = "電子計測実験室"
#let date = "2026年6月26日"
#let whether = ""
#let teacher = "服部 教員"
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
マイクロコンピュータを用いた音声信号処理の実験を通して、デジタル信号処理の基礎知識を修得する。

= 原理


= 結果

