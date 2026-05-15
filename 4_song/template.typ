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
#show heading: set block(above: 2em, below: 1em)
#show heading: it => {
  v(1.5em, weak: false)
  it
}

#let figure_report(
  path : "",
  caption : ""
  ) = {
  let label_name = path.split("/").last().split(".").first()
  [
    #figure(
      image(path, width: 60%),
      caption: caption,
    )
    #label(label_name)
  ]
}

/**  figure_report の使用例
#figure_report(
  path: "../3_sekiguchi/assets/2-1kairo.png",
  caption: "open delta-open delta 結線回路"
  )
**/

#let table_paper(
  caption: "",
  columns: (auto, auto, auto),
  ..args
) = figure(
  table(
    columns: columns,
    inset: 6pt,
    align: center + horizon,
    stroke: none,

    // 一番上の太線
    table.hline(y: 0, stroke: 1.5pt),
    // 見出しの下の線
    table.hline(y: 1, stroke: 0.8pt),

    ..args,

    // 一番下の太線
    table.hline(stroke: 1.5pt),
  ),
  caption: caption,
  kind: table
)

// ========== ここを編集 ==========
#let title = "コンバータ"
#let place = "電気工学実験室"
#let date = "2026年5月1,8日"
#let whether = "曇り"
#let teacher = "成 慶珉 教員"
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

コンバータ（順変換装置）はダイオードやサイリスタを用いて交流を直流に変換する装置であり、テレビ、コンピュータなどの電子機器や大電力用直流電源回路などのの中に広く用いられている。ここでは、まずダイオードを用いた代表的な整流回路について実験を行い、動作を理解するとともに、実効値及び平均値の測定を行い、脈動率及び波形率、波高率を算出する。次に、サイリスタを用いた位相制御整流回路において、サイリスタのゲート入力を調整することにより、出力電圧が制御できることを理解する。

= 回路図



= 使用器具

#table_paper(
  caption: "使用器具",
  columns: 4, align: left,
  [種別], [製造元], [型番], [シリアル番号], 
  [単相変圧器], [MATSUSHITA COMMUNICATION INDUSTRIAL CO.,LTD.], [VQ-7155], [508078], 
  [三相変圧器], [YAMABISHI ELECCTRIC CO.,LTD.], [SLIDER S3P-240-15], [S-24-5B], 
  [滑り抵抗器], [株式会社 横河電機製作所], [SS-3], [K2033M84], 
  [電流計 A.C.], [YOKOGAWA ELECTRIC WORKS, LTD.], [1965], [52A555], 
  [電流計 D.C.], [YOKOGAWA ELECTRIC WORKS, LTD.], [1965], [M515B113], 
  [電圧計 A.C.], [YOKOGAWA ELECTRIC WORKS, LTD.], [E21], [8C0148], 
  [電圧計 平均], [FUJIDENKI], [TM], [1113518T], 
  [電圧計 実効値], [FUJIDENKI], [TS], [9X01487], 
  [オシロスコープ], [Tektonix], [TDS1012B], [C030189], 
  [電流プローブ], [HIOKI], [9694], [070215861], 
  [電圧プローブ], [Tektonix], [P2220], [57843710], 
  [ダイオード], [東芝], [6FC13], [N/A], 
  [ダイオード], [日立], [S02E], [N/A], 
)

= 結果

== 3-1 単相半波整流回路

#table_paper(
  caption: "単相半波整流回路 4,5個目のデータはコンデンサを接続したときの値",
  columns: 7, align: left,
  [V_input
  [V]], [アノード電流 I [A]], [カソード電流I_a [A]], [平均出力電圧 V_a [V]], [実効出力電圧 V_b [V]], [ΔV_out [V]], [脈動率 γ], 
  [40], [0.378], [0.241], [16.9], [26.6], [53.6], [3.17], 
  [50], [0.478], [0.302], [21.3], [33.6], [66.4], [3.12], 
  [60], [0.581], [0.379], [26.0], [41.2], [82.0], [3.15], 
  [40], [1.580], [0.669], [46.5], [47.3], [11.8], [0.25], 
  [50], [1.970], [0.842], [58.3], [58.9], [14.6], [0.25], 
)

#table_paper(
  caption: "単相半波整流回路の理論値と実測値",
  columns: 5, align: left,
  [V_input
  [V]], [平均値], [平均値誤差率], [実効値], [実効値誤差率], 
  [40], [18.01], [-6.14%], [28.28], [-5.95%], 
  [50], [22.51], [-5.37%], [35.36], [-4.96%], 
  [60], [27.01], [-3.74%], [42.43], [-2.89%], 
)


= 検討





