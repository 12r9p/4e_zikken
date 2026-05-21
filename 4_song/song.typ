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
  width: 100%,
) = {
  let label_name = "fig:" + path.split("/").last().split(".").first()
  [
    #figure(
      image(path, width: width),
      caption: caption,
    )
    #label(label_name)
    #v(1em)
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
  [
    #figure(
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
    #v(1em)
  ]
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

実験に用いた回路図を @fig:3-1_circuit および @fig:3-1_circuit_c に示す。また、測定した出力電圧・電流波形を @fig:3-1_1ph_half、@fig:3-1_1ph_half_cap_dc および @fig:3-1_1ph_half_cap_ac に示す。

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-1/3-1_circuit.jpeg", caption: "単相半波整流回路の実験回路図"),
  figure_report(path: "3-1/3-1_circuit_c.jpeg", caption: "単相半波整流回路（コンデンサあり）の実験回路図"),
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-1/3-1_1ph_half.jpg", caption: "単相半波整流波形（Cなし, V_in = 40 V）"),
  figure_report(path: "3-1/3-1_1ph_half_cap_dc.jpg", caption: "単相半波整流波形（Cあり DC結合, V_in = 40 V）"),
)
#align(center)[
  #figure_report(path: "3-1/3-1_1ph_half_cap_ac.jpg", caption: "単相半波整流波形（Cあり AC結合, V_in = 40 V）", width: 48%)
]

#csv_table(
  path: "3-1/1ph_half.csv",
  delimiter: "\t",
  caption: "単相半波整流回路の結果（4, 5データ目は平滑コンデンサ接続時）",
)

#csv_table(
  path: "3-1/1ph_half_theory.csv",
  delimiter: "\t",
  caption: "単相半波整流回路の理論値と実測値の比較",
)

== 3-2 単相ブリッジ整流回路

実験に用いた回路図を @fig:3-2_circuit および @fig:3-2_circuit_c に示す。また、測定した出力電圧・電流波形を @fig:3-2_1ph_bridge、@fig:3-2_1ph_bridge_cap_dc および @fig:3-2_1ph_bridge_cap_ac に示す。

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-2/3-2_circuit.jpeg", caption: "単相ブリッジ整流回路の実験回路図"),
  figure_report(path: "3-2/3-2_circuit_c.jpeg", caption: "単相ブリッジ整流回路（コンデンサあり）の実験回路図"),
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-2/3-2_1ph_bridge.jpg", caption: "単相ブリッジ整流波形（Cなし, V_in = 40 V）"),
  figure_report(path: "3-2/3-2_1ph_bridge_cap_dc.jpg", caption: "単相ブリッジ整流波形（Cあり DC結合, V_in = 40 V）"),
)
#align(center)[
  #figure_report(path: "3-2/3-2_1ph_bridge_cap_ac.jpg", caption: "単相ブリッジ整流波形（Cあり AC結合, V_in = 40 V）", width: 48%)
]

#csv_table(
  path: "3-2/1ph_bridge.csv",
  delimiter: "\t",
  caption: "単相ブリッジ整流回路の結果（4, 5データ目は平滑コンデンサ接続時）",
)

#csv_table(
  path: "3-2/1ph_bridge_theory.csv",
  delimiter: "\t",
  caption: "単相ブリッジ整流回路の理論値と実測値の比較",
)

== 3-3 三相半波整流回路

実験に用いた回路図を @fig:3-3_circuit および @fig:3-3_circuit_c に示す。また、測定した出力電圧・電流波形を @fig:3-3_3ph_half_dc、@fig:3-3_3ph_half_cap_dc および @fig:3-3_3ph_half_cap_ac に示す。

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-3/3-3_circuit.jpeg", caption: "三相半波整流回路の実験回路図"),
  figure_report(path: "3-3/3-3_circuit_c.jpeg", caption: "三相半波整流回路（コンデンサあり）の実験回路図"),
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-3/3-3_3ph_half_dc.jpg", caption: "三相半波整流波形（Cなし, V_in = 40 V）"),
  figure_report(path: "3-3/3-3_3ph_half_cap_dc.jpg", caption: "三相半波整流波形（Cあり DC結合, V_in = 40 V）"),
)
#align(center)[
  #figure_report(path: "3-3/3-3_3ph_half_cap_ac.jpg", caption: "三相半波整流波形（Cあり AC結合, V_in = 40 V）", width: 48%)
]

#csv_table(
  path: "3-3/3ph_half.csv",
  delimiter: "\t",
  caption: "三相半波整流回路の結果（4, 5データ目は平滑コンデンサ接続時）",
)

#csv_table(
  path: "3-3/3ph_half_theory.csv",
  delimiter: "\t",
  caption: "三相半波整流回路の理論値と実測値の比較",
)

== 3-4 三相ブリッジ整流回路

実験に用いた回路図を @fig:3-4_circuit および @fig:3-4_circuit_c に示す。また、測定した出力電圧・電流波形を @fig:3-4_3ph_bridge_dc、@fig:3-4_3ph_bridge_ac、@fig:3-4_3ph_bridge_cap_dc および @fig:3-4_3ph_bridge_cap_ac に示す。

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-4/3-4_circuit.jpeg", caption: "三相ブリッジ整流回路の実験回路図"),
  figure_report(path: "3-4/3-4_circuit_c.jpeg", caption: "三相ブリッジ整流回路（コンデンサあり）の実験回路図"),
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-4/3-4_3ph_bridge_dc.jpg", caption: "三相ブリッジ整流波形（Cなし DC結合, V_in = 40 V）"),
  figure_report(path: "3-4/3-4_3ph_bridge_ac.jpg", caption: "三相ブリッジ整流波形（Cなし AC結合, V_in = 40 V）"),
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-4/3-4_3ph_bridge_cap_dc.jpg", caption: "三相ブリッジ整流波形（Cあり DC結合, V_in = 40 V）"),
  figure_report(path: "3-4/3-4_3ph_bridge_cap_ac.jpg", caption: "三相ブリッジ整流波形（Cあり AC結合, V_in = 40 V）"),
)

#csv_table(
  path: "3-4/3ph_bridge.csv",
  delimiter: "\t",
  caption: "三相ブリッジ整流回路の結果（4, 5データ目は平滑コンデンサ接続時）",
)

#csv_table(
  path: "3-4/3ph_bridge_theory.csv",
  delimiter: "\t",
  caption: "三相ブリッジ整流回路の理論値と実測値の比較",
)

== 3-5 サイリスタ半波整流回路

実験に用いた回路図を @fig:3-5_circuit に示す。また、制御角 $alpha = 45"°", 90"°", 120"°"$ における測定波形を @fig:3-5_1ph_half_thy_45deg、@fig:3-5_1ph_half_thy_90deg および @fig:3-5_1ph_half_thy_120deg に示す。

#align(center)[
  #figure_report(path: "3-5/3-5_circuit.jpeg", caption: "サイリスタ半波整流回路の実験回路図", width: 48%)
]
#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-5/3-5_1ph_half_thy_45deg.jpg", caption: "サイリスタ半波整流波形（α = 45°, V_in = 40 V）"),
  figure_report(path: "3-5/3-5_1ph_half_thy_90deg.jpg", caption: "サイリスタ半波整流波形（α = 90°, V_in = 40 V）"),
)
#align(center)[
  #figure_report(path: "3-5/3-5_1ph_half_thy_120deg.jpg", caption: "サイリスタ半波整流波形（α = 120°, V_in = 40 V）", width: 48%)
]

#csv_table(
  path: "3-5/1ph_half_thy.csv",
  delimiter: "\t",
  caption: "サイリスタ半波整流回路の結果（V_in = 40 V）",
)

#csv_table(
  path: "3-5/1ph_half_thy_theory.csv",
  delimiter: "\t",
  caption: "サイリスタ半波整流回路の理論値と実測値の比較",
)

== 3-6 混合ブリッジ整流回路

実験に用いた回路図を @fig:3-6_circuit に示す。また、制御角 $alpha = 45"°", 90"°", 120"°"$ における測定波形を @fig:3-6_1ph_bridge_thy_45deg、@fig:3-6_1ph_bridge_thy_90deg および @fig:3-6_1ph_bridge_thy_120deg に示す。

#align(center)[
  #figure_report(path: "3-6/3-6_circuit.jpeg", caption: "混合ブリッジ整流回路の実験回路図", width: 48%)
]

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure_report(path: "3-6/3-6_1ph_bridge_thy_45deg.jpg", caption: "混合ブリッジ整流波形（α = 45°, V_in = 40 V）"),
  figure_report(path: "3-6/3-6_1ph_bridge_thy_90deg.jpg", caption: "混合ブリッジ整流波形（α = 90°, V_in = 40 V）"),
)
#align(center)[
  #figure_report(path: "3-6/3-6_1ph_bridge_thy_120deg.jpg", caption: "混合ブリッジ整流波形（α = 120°, V_in = 40 V）", width: 48%)
]

#csv_table(
  path: "3-6/1ph_bridge_thy.csv",
  delimiter: "\t",
  caption: "混合ブリッジ整流回路の結果（V_in = 40 V）",
)

#csv_table(
  path: "3-6/1ph_bridge_thy_theory.csv",
  delimiter: "\t",
  caption: "混合ブリッジ整流回路の理論値と実測値の比較",
)


= 検討

== 1. 各実験で用いた回路図と測定した波形。
// 実験結果から図表番号を引用して、回路図と測定した波形がレポートにあることを示す文章を書いて
本実験で用いた各回路図および測定波形は、すべて実験結果のセクションに整理して掲載してある。
単相半波整流回路の実験回路図は @fig:3-1_circuit, @fig:3-1_circuit_c に、測定波形は @fig:3-1_1ph_half, @fig:3-1_1ph_half_cap_dc, @fig:3-1_1ph_half_cap_ac に示した。
同様に、単相ブリッジ整流回路は @fig:3-2_circuit, @fig:3-2_circuit_c および波形 @fig:3-2_1ph_bridge, @fig:3-2_1ph_bridge_cap_dc, @fig:3-2_1ph_bridge_cap_ac に、三相半波整流回路は @fig:3-3_circuit, @fig:3-3_circuit_c および波形 @fig:3-3_3ph_half_dc, @fig:3-3_3ph_half_cap_dc, @fig:3-3_3ph_half_cap_ac に、三相ブリッジ整流回路は @fig:3-4_circuit, @fig:3-4_circuit_c および波形 @fig:3-4_3ph_bridge_dc, @fig:3-4_3ph_bridge_ac, @fig:3-4_3ph_bridge_cap_dc, @fig:3-4_3ph_bridge_cap_ac にそれぞれ掲載した。
さらに、位相制御を行うサイリスタ半波整流回路は回路図 @fig:3-5_circuit および制御角ごとの波形 @fig:3-5_1ph_half_thy_45deg, @fig:3-5_1ph_half_thy_90deg, @fig:3-5_1ph_half_thy_120deg に、混合ブリッジ整流回路は回路図 @fig:3-6_circuit および波形 @fig:3-6_1ph_bridge_thy_45deg, @fig:3-6_1ph_bridge_thy_90deg, @fig:3-6_1ph_bridge_thy_120deg に整理した。
これらにより、各整流回路の動作特性を視覚的かつ定量的に確認できる構成となっている。

== 2. 理論式の妥当性の検証
/*
ダイオードを用いた実験3-1~3-4の各整流回路において電源電圧が正弦波のとき、出力電圧の平均値および実効値は表1のようになる。最初にこの理論式の妥当性を検証せよ。(正弦波形の積分式を用いて導くこと)

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
ダイオードを用いた各整流回路およびサイリスタ整流回路について、電源電圧の瞬時値を $v(theta)$ とし、出力電圧の平均値 $V_d$ および実効値 $V_r$ の理論式の積分による導出過程を示す。なお、電源の実効電圧を $V$、三相の場合は線間実効電圧を $V_L$ とする。

=== (1) 単相半波整流回路
電源電圧を $v(theta) = sqrt(2) V sin theta$ とする。出力電圧は $0 <= theta <= pi$ で $v(theta)$、 $pi <= theta <= 2pi$ で $0$ となる。周期は $2pi$ である。
- *平均値 $V_d$*：
  $
    V_d = 1 / (2 pi) integral_0^pi sqrt(2) V sin theta d theta = (sqrt(2) V) / (2 pi) [-cos theta]_0^pi = (sqrt(2) V) / (2 pi) (1 - (-1)) = (sqrt(2) V) / pi
  $
- *実効値 $V_r$*：
  $
    V_r = sqrt(1 / (2 pi) integral_0^pi (sqrt(2) V sin theta)^2 d theta) = sqrt(V^2 / pi integral_0^pi (1 - cos 2theta) / 2 d theta) \\
    = sqrt(V^2 / pi [theta / 2 - (sin 2theta) / 4]_0^pi) = sqrt(V^2 / pi (pi / 2)) = V / sqrt(2) = (sqrt(2) V) / 2
  $

=== (2) 単相全波整流回路
出力波形は $pi$ を周期とするため、積分範囲は $0 <= theta <= pi$、瞬時値は $sqrt(2) V sin theta$ である。
- *平均値 $V_d$*：
  $ V_d = 1 / pi integral_0^pi sqrt(2) V sin theta d theta = (sqrt(2) V) / pi [-cos theta]_0^pi = (2 sqrt(2) V) / pi $
- *実効値 $V_r$*：
  $
    V_r = sqrt(1 / pi integral_0^pi (sqrt(2) V sin theta)^2 d theta) = sqrt((2 V^2) / pi integral_0^pi (1 - cos 2theta) / 2 d theta) = sqrt((2 V^2) / pi (pi / 2)) = V
  $

=== (3) 三相半波整流回路
相電圧 $v_p (theta) = sqrt(2) V_p cos theta$ （ただし線間電圧 $V_L$ に対して相実効電圧 $V_p = V_L / sqrt(3)$）とする。出力電圧は各相の最大値が順次現れ、周期は $2pi / 3$、対称な積分範囲は $-pi / 3 <= theta <= pi / 3$ となる。
- *平均値 $V_d$*：
  $
    V_d = 3 / (2 pi) integral_(-pi/3)^(pi/3) sqrt(2) V_p cos theta d theta = (3 sqrt(2) V_p) / (2 pi) [sin theta]_(-pi/3)^(pi/3) = (3 sqrt(2) V_p) / (2 pi) (sqrt(3)/2 - (-sqrt(3)/2)) \\
    = (3 sqrt(6) V_p) / (2 pi) = (3 sqrt(6) (V_L / sqrt(3))) / (2 pi) = (3 sqrt(2) V_L) / (2 pi)
  $
- *実効値 $V_r$*：
  $
    V_r = sqrt(3 / (2 pi) integral_(-pi/3)^(pi/3) (sqrt(2) V_p cos theta)^2 d theta) \\
    = sqrt((3 V_p^2) / pi integral_(-pi/3)^(pi/3) (1 + cos 2theta) / 2 d theta) \\
    = sqrt((3 V_p^2) / pi [theta / 2 + (sin 2theta) / 4]_(-pi/3)^(pi/3)) \\
    = sqrt(
      (3 V_p^2) / pi ( (pi / 6 + sqrt(3) / 8) \
        - (-pi / 6 - sqrt(3) / 8) )
    ) \\
    = sqrt((3 V_p^2) / pi ( pi / 3 + sqrt(3) / 4 )) \\
    = V_p sqrt(1 + (3 sqrt(3)) / (4 pi)) \\
    = (V_L / sqrt(3)) sqrt(1 + (3 sqrt(3)) / (4 pi)) \\
    = sqrt(1 / 3 + sqrt(3) / (4 pi)) V_L
  $

=== (4) 三相全波整流回路
出力電圧は線間電圧 $v(theta) = sqrt(2) V_L cos theta$ となり、周期は $pi / 3$、対称な積分範囲は $-pi / 6 <= theta <= pi / 6$ である。
- *平均値 $V_d$*：
  $
    V_d = 3 / pi integral_(-pi/6)^(pi/6) sqrt(2) V_L cos theta d theta = (3 sqrt(2) V_L) / pi [sin theta]_(-pi/6)^(pi/6) = (3 sqrt(2) V_L) / pi (1/2 - (-1/2)) = (3 sqrt(2) V_L) / pi
  $
- *実効値 $V_r$*：
  $
    V_r = sqrt(3 / pi integral_(-pi/6)^(pi/6) (sqrt(2) V_L cos theta)^2 d theta) \\
    = sqrt((6 V_L^2) / pi integral_(-pi/6)^(pi/6) (1 + cos 2theta) / 2 d theta) \\
    = sqrt((6 V_L^2) / pi [theta / 2 + (sin 2theta) / 4]_(-pi/6)^(pi/6)) \\
    = sqrt(
      (6 V_L^2) / pi ( (pi / 12 + sqrt(3) / 8) \
        - (-pi / 12 - sqrt(3) / 8) )
    ) \\
    = sqrt((6 V_L^2) / pi ( pi / 6 + sqrt(3) / 4 )) \\
    = V_L sqrt(1 + (3 sqrt(3)) / (2 pi))
  $

=== (5) サイリスタ単相半波整流回路
制御角（点弧角） $alpha$ で導通を開始し、電源電圧が負になる $pi$ で電流が遮断される。周期 is $2 pi$ である。
- *平均値 $V_d$*：
  $
    V_d = 1 / (2 pi) integral_alpha^pi sqrt(2) V sin theta d theta = (sqrt(2) V) / (2 pi) [-cos theta]_alpha^pi = (sqrt(2) V (1 + cos alpha)) / (2 pi)
  $
- *実効値 $V_r$*：
  $
    V_r = sqrt(1 / (2 pi) integral_alpha^pi (sqrt(2) V sin theta)^2 d theta) \\
    = sqrt(V^2 / pi integral_alpha^pi (1 - cos 2theta) / 2 d theta) \\
    = sqrt(V^2 / (2 pi) [theta - (sin 2theta) / 2]_alpha^pi) \\
    = sqrt(V^2 / (2 pi) (pi - alpha + (sin 2alpha) / 2)) \\
    = sqrt((pi - alpha + (sin 2alpha) / 2) / (2 pi)) V
  $

=== (6) サイリスタ混合全波ブリッジ整流回路（単相全波）
周期 is $pi$ となり、制御角 $alpha$ から $pi$ までの区間で導通する。
- *平均値 $V_d$*：
  $
    V_d = 1 / pi integral_alpha^pi sqrt(2) V sin theta d theta = (sqrt(2) V) / pi [-cos theta]_alpha^pi = (sqrt(2) V (1 + cos alpha)) / pi
  $
- *実効値 $V_r$*：
  $
    V_r = sqrt(1 / pi integral_alpha^pi (sqrt(2) V sin theta)^2 d theta) \
    = sqrt((2 V^2) / pi integral_alpha^pi (1 - cos 2theta) / 2 d theta) \
    = sqrt(V^2 / pi [theta - (sin 2theta) / 2]_alpha^pi) \
    = sqrt((pi - alpha + (sin 2alpha) / 2) / pi) V
  $

以上により、表1に示されたすべての平均値および実効値の理論式が、積分式により厳密に導出され、その妥当性が検証された。

== 3. 実験での測定値と理論式での計算値の比較検討
// 実験で得られた測定値（平均値、実効値）から波形率、波高率を求め、表1の理論式で得られる計算値と比較検討せよ。また、誤差の原因についても言及すること。
実験で得られた測定値（平均値、実効値）から求めた波形率 $F_f = V_r / V_d$ （実測実効値 / 実測平均値）および波高率 $F_c = V_"peak" / V_r$（実測最大値 / 実測実効値）を、理論式に基づく計算値と比較検討する。

=== (1) 3-1 単相半波整流回路
- *特性変化*：
  平滑コンデンサを接続しない場合（$V_"in" = 40, 50, 60 "V"$），波形率は $1.57 \sim 1.59$，波高率は $1.98 \sim 2.02$ となっている。これは理論値である波形率 $F_f = pi / 2 approx 1.57$，波高率 $F_c = 2 approx 2.00$ と非常によく一致している。
  一方、平滑コンデンサ $C$ を接続した場合（$V_"in" = 40, 50 "V"$），波形率は $1.01$，波高率は $1.11$ 付近まで低下しており、出力電圧が非常に平滑な直流（C=∞の極限では $F_f = 1.0, F_c = 1.0$）に近付いていることが確認できる。
- *誤差の分析*：
  コンデンサなし時において、実測の平均値および実効値は理論値に対して $-3\%$ から $-6\%$ 程度の負の誤差を示している。これは、ダイオードの順方向電圧降下（約 $0.7" V"$）や、回路全体の配線抵抗による電圧降下、および測定用トランスの電圧低下が原因である。

=== (2) 3-2 単相ブリッジ整流回路
- *特性変化*：
  コンデンサなし時、実測の波形率は $1.12$、波高率は $1.41 \sim 1.45$ であり、理論値 $F_f = pi / (2 sqrt(2)) approx 1.11$、$F_c = sqrt(2) approx 1.41$ に極めて近い。コンデンサ接続時には波形率 $1.00$、波高率 $1.08$ となり、単相半波のときよりも脈動がさらに小さい高品質な直流となっている。
- *誤差の分析*：
  実測値は理論値に比べ $-3\%$ から $-7\%$ 程度の負の誤差を有する。ブリッジ整流回路では常に2個のダイオードが直列に導通するため、ダイオードの順方向電圧降下が2倍（約 $1.4" V"$）になり、単相半波よりも電圧降下誤差の影響がわずかに大きくなっている。

=== (3) 3-3 三相半波整流回路
- *特性変化*：
  コンデンサなし時の実測波形率は $1.16 \sim 1.17$、波高率は $1.48 \sim 1.54$ である。
  コンデンサあり時の実測波形率は $1.01$、波高率は $1.05 \sim 1.08$ となり、平滑作用が顕著に機能している。
- *誤差の分析*：
  平均値は理論値より約 $-4.5\%$ から $-5.2\%$ 低い。一方、実効値には $+8.5\%$ から $+10.0\%$ という大きな正の誤差が観測されている。これは、三相交流電源の各相間のアンバランス（振幅および位相差の非対称性）、中性線配線のインピーダンス、およびデジタルオシロスコープの実効値演算（交流ノイズによる実効値の増大）が主要因と考えられる。

=== (4) 3-4 三相ブリッジ整流回路
- *特性変化*：
  コンデンサなし時の実測波形率は $1.00 \sim 1.01$、波高率は $1.08 \sim 1.09$ と、コンデンサ未挿入の状態であっても極めて直流に近い優れた波形特性を示す。
  コンデンサあり時には波形率 $1.02$、波高率 $1.03 \sim 1.04$ となり、ほぼ完全な平坦直流が得られている。
- *誤差の分析*：
  平均値・実効値ともに理論値に対して $-2.7\%$ から $-5.5\%$ の負の誤差である。三相ブリッジ回路では、変圧器の漏れリアクタンスによる転流重なり期間（転流たるみ）が生じるため、平均出力電圧が理論値よりも押し下げられる効果が働き、負の誤差として表れている。

=== (5) 3-5 サイリスタ半波整流回路
- *特性変化*：
  $alpha = 45"°" arrow 90"°" arrow 120"°"$ に増加させるに伴い、実測の波形率は $1.75 \to 2.22 \to 2.81$、波高率は $2.23 \to 2.83 \to 3.36$ と急激に増大している。これは、点弧角を広げることで導通角が狭まり、出力電圧が不連続なパルス状波形となるためである。
- *誤差の分析*：
  $alpha = 45"°", 90"°"$ においては、実測値と理論値の差は $+- 6\%$ 以内と良好である。しかし $alpha = 120"°"$ では、平均値誤差率が $+15.5\%$、実効値誤差率が $+16.7\%$ と極端に大きな正の誤差が生じている。これは、導通期間が非常に狭く電流値が極めて小さくなった結果、サイリスタの動作維持に必要な「保持電流」を下回り早期に消弧したこと、点弧ゲートパルスの波形歪み、および測定ノイズの相対的増加が主な誤差原因である。

=== (6) 3-6 混合ブリッジ整流回路
- *特性変化*：
  $alpha = 45"°" arrow 90"°" arrow 120"°"$ に広げると、実測波形率は $1.22 \to 1.58 \to 1.97$ と上昇し、出力の平滑性が損なわれていく挙動が確認できる。
- *誤差の分析*：
  $alpha = 45"°"$ では誤差 $-1\%$ から $-2.7\%$ と極めて正確であるが、$alpha = 120"°"$ では平均値で $+23\%$、実効値で $+24\%$ という著しい正の誤差が生じた。これは 3-5 と同様に、制御角が大きくなって微小電流領域になると、サイリスタの非理想的なスイッチング特性（ターンオフ時の遅れ特性や漏れ電流、保持電流の影響）およびオシロスコープのトリガ精度の限界が複合して測定誤差を増大させたためである。

== 4. コンデンサ有無での脈動率の比較考察
// 単相全波整流回路と、三相全波整流回路について、コンデンサ挿入時と用いない時の脈動率を比較考察せよ。
単相全波整流回路（3-2）および三相全波整流回路（3-4）について、平滑コンデンサを挿入した場合と用いない場合の脈動率 $gamma$ を実測値から比較・考察する。

- *単相全波整流回路の脈動率*：
  - コンデンサなし：$gamma approx 1.58 - 1.62$
  - コンデンサあり：$gamma approx 0.10$
- *三相全波整流回路の脈動率*：
  - コンデンサなし：$gamma approx 0.15 - 0.16$
  - コンデンサあり：$gamma approx 0.03$

=== 考察
平滑コンデンサがない場合、単相全波整流回路の脈動率は $1.6$ 前後と非常に大きい。出力電圧波形が半周期ごとに必ず $0" V"$ まで完全に低下するためである。ここにコンデンサを挿入すると、電源電圧が降下する期間においてコンデンサに蓄えられた電荷が負荷へと放電され、電圧の落ち込みを強力に防ぐ。これにより、脈動率は $0.10$ と約 1/16 に激減し、滑らかな直流が得られる。

一方、三相全波整流回路（ブリッジ）では、コンデンサがない状態でも脈動率が $0.15$ 程度と、単相全波の約 1/10 という極めて低い値を示す。これは、三相交流の各相が $120"°"$（$2 pi / 3$）ずつ位相がズレて重なり合っているため、常にいずれかの相が高い電圧を維持し、出力の「谷」が非常に浅くなるためである。この回路に平滑コンデンサを挿入すると、谷が元々非常に浅いことから放電による低下がほとんど発生せず、コンデンサ容量が小さくとも $gamma approx 0.03$ という極めて平滑な（脈動がほぼゼロの）完全な直流出力を容易に実現できる。

== 5. 半波整流回路においてコンデンサの有無での入力電流波形の考察
// 単相半波整流回路において、コンデンサを挿入した場合と挿入していない場合の入力電流波形に対して考察せよ。
単相半波整流回路（3-1）において、平滑コンデンサの有無によって入力電流波形がどのように変化するかを、実験回路図（@fig:3-1_circuit, @fig:3-1_circuit_c）および測定波形を交えて考察する。

- *コンデンサなしの場合*：
  ダイオードがオンになる（導通する）のは、入力電源電圧 $v(t)$ が正である半周期（$0$ から $pi$）の全域である（導通角 $180"°"$）。このとき負荷は単純な純抵抗であるため、オームの法則に従い、入力電流波形は電圧波形と全く同様に、なだらかな半波正弦波状になる。
- *コンデンサありの場合*：
  コンデンサが接続されると、出力端子の電圧（コンデンサ両端電圧 $v_c$）は常に高電圧（ピーク値 $sqrt(2) V$ 付近）に維持される。ダイオードに電流が流れるのは、「電源電圧 $v(t)$ がコンデンサの残留電圧 $v_c(t)$ を超えた瞬間」だけである。
  これは電源電圧のピーク付近（導通角が非常に狭い期間）に限られる。この短い期間に、ダイオードを介してコンデンサへ一気に電荷を送り込むため、極めて高くて急峻な「パルス状（スパイク状）の電流波形」が入力側に流れる。電圧のピークを過ぎると $v(t) < v_c(t)$ となり、ダイオードは即座に逆バイアスされてオフになるため、電流は完全に 0 となる。
  この現象は、測定波形 @fig:3-1_1ph_half_cap_dc において、出力電圧のピーク手前で急峻なパルス状電流（アノード電流）が観測されている動作と完全に一致する。

== 6. 三相整流回路の入力電圧が食パン波形になる理由
// 三相整流回路の入力電圧が食パンのような波形になる理由を説明してください。
三相ブリッジ整流回路（3-4）の動作時において、電源の入力線間電圧波形が純粋な正弦波から逸脱し、頂部が平坦で角ばった「食パンのような波形」（あるいは転流ノッチが入った波形）になる理由は、以下の二つの相互作用によるものである。

1. *変圧器の漏れリアクタンスとダイオードの転流動作（重なり現象）*：
  三相ブリッジ回路では、導通するダイオードが次の相へと順次切り替わる「転流」が発生する。電源の変圧器には必ず「漏れリアクタンス（インダクタンス）」が存在するため、電流は一瞬では変化できず、転流する前後の二つの相のダイオードが同時に導通する「重なり期間（オーバーラップ期間）」が生じる。この重なり期間中、二つの相が短絡されたような状態になり、変圧器の漏れインピーダンスによる極めて深い電圧降下（転流ノッチ、転流たるみ）が生じて、電圧波形が押し潰される。
2. *クランプ効果と負荷電流によるピーク電圧の平坦化*：
  負荷に電流を供給している期間中、オンになっているダイオードを介して出力側の大容量コンデンサや負荷が電源線間に直接接続される。このとき、負荷電流が変圧器の内部インピーダンスを通ることで大きな電圧降下が発生する。特に電圧のピーク付近（ダイオードが最も強くオンになり、大電流が流れる領域）で電圧降下が最大となるため、正弦波の頂上が下方にクランプされて平らになり、角ばった「食パン波形」が電源二次側（入力側）に観測される。

= TODO
理論値の表にある誤差率の有効桁数の計算がまだなのでやる。
これは自力でやるのでAIはやらないで
AIへの仕事は、もし最後まで残っていたら警告すること

#block(
  fill: rgb("fff3cd"),
  inset: 10pt,
  radius: 4pt,
  stroke: 1pt + rgb("ffeeba"),
  [
    #text(weight: "bold", fill: rgb("856404"))[⚠️ AIからの最終警告]

    ユーザー指定のTODO「理論値の表にある誤差率の有効桁数の計算」は、指示に従いAIによる編集を行わず残してあります。レポートをPDF出力する前に、ご自身での計算と確認を忘れずに行ってください。
  ],
)
