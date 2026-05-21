#import "@preview/js:0.1.3": *
#import "@preview/codelst:2.0.2": *
#show: js.with(
  lang: "ja",
  seriffont-cjk: "Harano Aji Mincho",
  sansfont-cjk: "Harano Aji Gothic",
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
  path: "",
  caption: "",
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

#let csv_table(
  path: "",
  caption: "",
  delimiter: ",",
  align: left,
) = {
  let data = csv(path, delimiter: delimiter)
  let headers = data.first()
  let rows = data.slice(1)
  figure(
    table(
      columns: (auto,) * headers.len(),
      inset: 6pt,
      align: center + horizon,
      stroke: none,

      // 一番上の太線
      table.hline(y: 0, stroke: 1.5pt),
      // 見出しの下の線
      table.hline(y: 1, stroke: 0.8pt),

      ..headers,
      ..rows.flatten(),

      // 一番下の太線
      table.hline(stroke: 1.5pt),
    ),
    caption: caption,
    kind: table,
  )
}

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

コンバータ（順変換装置）はダイオードやサイリスタを用いて交流を直流に変換する装置であり、テレビ、コンピュータなどの電子機器や大電力用直流電源回路などのの中に広く用いられている。ここでは、まずダイオードを用いた代表的な整流回路について実験を行い、動作を理解するとともに、実効値及び平均値の測定を行い、脈動率及び波形率、波高率を算出する。次に、サイリスタを用いた位相制御整流回路において、サイリスタのゲート入力を調整することにより、出力電圧が制御できることを理解する。

= 使用器具

#csv_table(
  path: "equipment.csv",
  delimiter: "\t",
  caption: "使用器具",
)

= 実験結果

== 3-1 単相半波整流回路

// 回路図、測定した波形、結果の表、理論値の表の順で結果を記述して

#csv_table(
  path: "3-1/1ph_half.csv",
  delimiter: "\t",
  caption: "単相半波整流回路の結果 4,5個目のデータはコンデンサを接続したときの値",
)

#csv_table(
  path: "3-1/1ph_half_theory.csv",
  delimiter: "\t",
  caption: "単相半波整流回路の理論値と実測値",
)

== 3-2 単相ブリッジ整流回路
// 回路図、測定した波形、結果の表、理論値の表の順で結果を記述して

#csv_table(
  path: "3-2/1ph_bridge.csv",
  delimiter: "\t",
  caption: "単相ブリッジ整流回路の結果 4,5個目のデータはコンデンサを接続したときの値",
)

== 3-3 三相半波整流回路
// 回路図、測定した波形、結果の表、理論値の表の順で結果を記述して

== 3-4 三相ブリッジ整流回路
// 回路図、測定した波形、結果の表、理論値の表の順で結果を記述して

== 3-5 サイリスタ半波整流回路
// 回路図、測定した波形、結果の表、理論値の表の順で結果を記述して

== 3-6 混合ブリッジ整流回路
// 回路図、測定した波形、結果の表、理論値の表の順で結果を記述して


= 検討

== 1. 各実験で用いた回路図と測定した波形。
// 実験結果から図表番号を引用して、回路図と測定した波形がレポートにあることを示す文章を書いて

== 2. 理論式の妥当性の検証
/* ダイオードを用いた実験3-1~3-4の各整流回路において電源電圧が制限はとするとき、出力電圧の平均値および実効値は表1のようになる。最初にこの理論式の妥当性を検証せよ。(制限は波形の積分式を用いて導くこと)

表1：整流回路の平均値及び実効値の理論式

| 回路種類 | 平均値 | 実効値 |
| :--- | :--- | :--- |
| 単相半波 | $\frac{\sqrt{2}V}{\pi}$ | $\frac{\sqrt{2}V}{2}$ |
| 単相全波 | $\frac{2\sqrt{2}V}{\pi}$ | $V$ |
| 三相半波 | $\frac{3\sqrt{2}V_L}{2\pi}$ | $\left( \frac{1}{3} + \frac{\sqrt{3}}{4\pi} \right)^{1/2} V_L$ |
| 三相全波 | $\frac{3\sqrt{2}V_L}{\pi}$ | $\left( 1 + \frac{3\sqrt{3}}{2\pi} \right)^{1/2} V_L$ |
| サイリスタ単相半波 | $\frac{\sqrt{2}V(1+\cos\alpha)}{2\pi}$ | $\left[ \frac{\pi - \alpha + \frac{\sin 2\alpha}{2}}{2\pi} \right]^{1/2} V$ |
| サイリスタ単相全波 | $\frac{\sqrt{2}V(1+\cos\alpha)}{\pi}$ | $\left[ \frac{\pi - \alpha + \frac{\sin 2\alpha}{2}}{\pi} \right]^{1/2} V$ |

注：
- $V$：単相電源電圧（実効値）
- $V_L$：三相電源線間電圧（実効値）
- $\alpha$：点弧角（radian）

*/

== 3. 実験での測定値と理論式での計算値の比較検討
// 実験で得られた測定値(平均値、実効値)と以下の波形率、波効率を求め、表1の理論式で得られる計算値と比較検討せよ
// 実験で得られた測定値は書く実験のフォルダの中のcsvファイルに入っている。背景率は計算済みだが、波効率はまだなので、有効数字を気にしながら計算して、表に追記してほしい。理論式で求められる波効率の最大値は実測値から取っちゃって大丈夫です。一部実測値がないところがありますがΔVで第八日のうだと思います。
// それぞれの実験について実験で得られた測定値と理論式からの計算値を比較検討していく形で書いてください

== 4. コンデンサ有無での脈動率の比較考察
// 単相全波整流回路と、三相全波整流回路について、コンデンサ挿入時と用いない時の脈動率を計算で求め、比較考察せよ。
// 波形率はすでに求めてあるので結果のcsvを用いてください。

== 5. 半波整流回路においてコンデンサの有無での入力電流波形の考察
// 単相半波整流回路において、コンデンサを挿入した場合と挿入していない場合の入力電流波形に対して考察せよ。コンデンサを挿入した場合のダイオード半波整流回路の回路図と実験で撮った電圧電流波形を用いてその動作を説明しなさい。
// パルス状になっているのはなぜか説明しろってことです。

== 6. 三相整流回路の入力電圧が食パン波形になる理由
// 三相整流回路の入力電圧が食パンのような波形になる理由を説明してください。

= TODO
理論値の表にある誤差率の有効桁数の計算がまだなのでやる。
これは自力でやるのでAIはやらないで
AIへの仕事は、もし最後まで残っていたら警告すること
