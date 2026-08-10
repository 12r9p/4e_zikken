#import "../lib/report-utils.typ": *
#show: setup_report

// 図番号と assets 内の実ファイル名の対応
#let image-paths = (
  "assets/figures/01_帰還発振回路の発振原理.svg": "assets/帰還発振回路の発振原理.jpeg",
  "assets/figures/02_エミッター接地増幅回路.svg": "assets/エミッター接地増幅回路.jpeg",
  "assets/figures/03_エミッター接地バイアス回路.svg": "assets/エミッター接地増幅回路.jpeg",
  "assets/figures/04_エミッター接地交流回路.svg": "assets/エミッター接地増幅回路の交流回路.jpeg",
  "assets/figures/05_エミッター接地hパラメータ等価回路.svg": "assets/エミッター接地増幅回路のhパラメータを用いた簡易等価回路.jpeg",
  "assets/figures/06_ベース接地増幅回路.svg": "assets/ベース接地増幅回路.jpeg",
  "assets/figures/07_ベース接地バイアス回路.svg": "assets/ベース接地増幅回路.jpeg",
  "assets/figures/08_ベース接地交流回路.svg": "assets/ベース接地増幅回路の交流回路.jpeg",
  "assets/figures/09_ベース接地hパラメータ等価回路.svg": "assets/ベース接地増幅回路のhパラメータを用いた簡易等価回路.jpeg",
  "assets/figures/10_ハートレー型発振回路.svg": "assets/ハートレー型発振回路.jpeg",
  "assets/figures/11_ハートレー型交流等価回路1.svg": "assets/ハートレー型発振回路の交流等価回路1.jpeg",
  "assets/figures/12_ハートレー型交流等価回路2.svg": "assets/ハートレー型発振回路の交流等価回路2.jpeg",
  "assets/figures/13_ハートレー型交流等価回路3.svg": "assets/ハートレー型発振回路の交流等価回路3.jpeg",
  "assets/figures/14_コルピッツ型発振回路.svg": "assets/コルピッツ型発振回路.jpeg",
  "assets/figures/15_コルピッツ型交流等価回路1.svg": "assets/コルピッツ型発振回路の交流等価回路1.jpeg",
  "assets/figures/16_コルピッツ型交流等価回路2.svg": "assets/コルピッツ型発振回路の交流等価回路2.jpeg",
  "assets/figures/17_コルピッツ型交流等価回路3.svg": "assets/コルピッツ型発振回路の交流等価回路3.jpeg",
  "assets/figures/18_ターマン型発振回路の帰還回路.svg": "assets/ターマン型発振回路の帰還回路.jpeg",
  "assets/figures/19_ウィーンブリッジ回路.svg": "assets/ウィーンブリッジ回路.jpeg",
  "assets/figures/20_ウィーンブリッジ増幅回路.svg": "assets/ウィーンブリッジ発振回路の増幅回路部.jpeg",
  "assets/figures/21_ハートレー型発振回路の実験回路.svg": "assets/ハートレー型発振回路の実験回路.jpeg",
  "assets/figures/22_コルピッツ型発振回路の実験回路.svg": "assets/コルピッツ型発振回路の実験回路.jpeg",
  "assets/figures/23_ウィーンブリッジ発振回路の実験回路.svg": "assets/ウィーンブリッジ発振回路の実験回路.jpeg",
)

// 図の幅はここで 1 枚ずつ調整する。
#let figure-widths = (
  feedback: 36%,
  ce-circuit: 40%, ce-ac: 65%, ce-hparam: 105%,
  cb-circuit: 42%, cb-ac: 50%, cb-hparam: 75%,
  hartley: 52%, hartley-ac1: 56%, hartley-ac2: 65%, hartley-ac3: 25%,
  colpitts: 52%, colpitts-ac1: 45%, colpitts-ac2: 65%, colpitts-ac3: 25%,
  wien-feedback: 45%, wien-bridge: 55%, wien-amplifier: 35%,
  hartley-experiment: 54%, colpitts-experiment: 54%, wien-experiment: 64%,
  wien-feedback-measurement: 42%,
  bode: 70%,
)

// 検証時のみ --input render-circuit-images=false を指定する。
#let render-circuit-images = sys.inputs.at("render-circuit-images", default: "true") == "true"
#let figure_report(path: "", caption: "", label-name: "", width: 72%) = [
  #figure(
    if render-circuit-images {
      image(image-paths.at(path, default: path), width: width)
    } else {
      rect(width: width, height: 42mm, stroke: 0.5pt + gray, inset: 8pt)[
        #align(center + horizon)[回路図画像：#path]
      ]
    },
    caption: caption,
  )
  #label(label-name)
  #v(1em)
]

#let title = "発振回路"
#let date = "7月10,17,22日"
#let weather = "晴れ　室温23.7℃ 湿度68%"
#let place = "電気機械実験室"
#let teacher = "皆藤 新一 教員"

#v(10em)
#align(center, text(size: 16pt, weight: "bold", [#title]))
#v(6em)
#align(right, [2026年 4E 電気電子システム工学実験])
#v(40em)
作成者：佐藤 匠\

作成日：#datetime.today().display("[year]年[month]月[day]日") \

実験日：#date \

天気：#weather \

実験場所：#place \

担当教員：#teacher

#pagebreak()

// ================================

= 目的
代表的な正弦波発振回路である LC 発振回路、ならびに CR 発振回路について、実験を通して動作原理を理解するとともに、帰還回路について理解を深める。

= 使用器具
本実験で使用した器具を表 1 に示す。

#set text(size: 7.5pt)
#csv_table(
  path: "../2_kaito/assets/使用器具.csv",
  delimiter: "\t",
  caption: [使用器具],
)
#set text(size: 10pt)

= 原理

== (1) 発振条件
帰還発振回路の原理を図 @fig-feedback に示す。増幅器の電圧増幅率を $A$、帰還回路の伝達率を $beta$、入力電圧を $V_i$、出力電圧を $V_o$ とする。

#figure_report(
  path: "assets/figures/01_帰還発振回路の発振原理.svg",
  caption: [帰還発振回路の発振原理],
  label-name: "fig-feedback",
  width: figure-widths.at("feedback"),
)

正帰還であるから、増幅器への入力は $V_i + beta V_o$ となる。したがって、

$ V_o = A (V_i + beta V_o) $

であり、伝達関数 $G$ は次式で表される。

$ G = V_o / V_i = A / (1 - A beta) $

ここで $A beta$ が 1 に近づくと $G$ は非常に大きくなる。外部入力がない場合にも出力を維持するための条件、すなわちバークハウゼンの発振条件は次の 2 条件である。

- 振幅条件：$abs(A beta) = 1$
- 位相条件：$arg(A beta) = 2 pi n$

== (2) トランジスタ増幅器の電圧増幅率

=== ① エミッター接地増幅回路
エミッター接地増幅回路を図 @fig-ce-circuit に、交流回路および h パラメータを用いた簡易等価回路を図 @fig-ce-ac および図 @fig-ce-hparam に示す。

#figure_report(
  path: "assets/figures/02_エミッター接地増幅回路.svg",
  caption: [エミッター接地増幅回路],
  label-name: "fig-ce-circuit",
  width: figure-widths.at("ce-circuit"),
)

#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  figure_report(path: "assets/figures/04_エミッター接地交流回路.svg", caption: [エミッター接地の交流回路], label-name: "fig-ce-ac", width: figure-widths.at("ce-ac")),
  figure_report(path: "assets/figures/05_エミッター接地hパラメータ等価回路.svg", caption: [エミッター接地の h パラメータ等価回路], label-name: "fig-ce-hparam", width: figure-widths.at("ce-hparam")),
)


図 @fig-ce-hparam より、$i_c=h_("fe") i_b$、$v_i=h_("ie") i_b$、$v_o=-R_C i_c=-R_C h_("fe") i_b$ と表せる。出力電圧の負号は、コレクタ抵抗における電圧降下の向きが出力電圧の定義と逆であることによる。よって電圧増幅率 $A_v$ は、

$ A_v = v_o / v_i = - (h_("fe") / h_("ie")) R_C $

となる。すなわち、エミッター接地増幅回路では入力と出力の位相は 180° 反転する。

=== ② ベース接地増幅回路
ベース接地増幅回路を図 @fig-cb-circuit に、交流回路および h パラメータを用いた簡易等価回路を図 @fig-cb-ac および図 @fig-cb-hparam に示す。

#figure_report(
  path: "assets/figures/06_ベース接地増幅回路.svg",
  caption: [ベース接地増幅回路],
  label-name: "fig-cb-circuit",
  width: figure-widths.at("cb-circuit"),
)


#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  figure_report(path: "assets/figures/08_ベース接地交流回路.svg", caption: [ベース接地の交流回路], label-name: "fig-cb-ac", width: figure-widths.at("cb-ac")),
  figure_report(path: "assets/figures/09_ベース接地hパラメータ等価回路.svg", caption: [ベース接地の h パラメータ等価回路], label-name: "fig-cb-hparam", width: figure-widths.at("cb-hparam")),
)

図 @fig-cb-hparam より、$i_c=h_("fe") i_b$、$v_i=-h_("ie") i_b$、$v_o=-R_C h_("fe") i_b$ である。したがって、

$ A_v = v_o / v_i = (h_("fe") / h_("ie")) R_C $

となる。ベース接地増幅回路では、入力と出力の位相反転は生じない。

== (3) LC 発振回路の交流等価回路

=== ① ハートレー型
ハートレー型発振回路を図 @fig-hartley に示す。直流電圧源および結合・バイパスコンデンサを交流的に短絡した回路を図 @fig-hartley-ac1 に示す。さらに、交流的に等電位となる抵抗を短絡し、交流電流が流れない抵抗を開放して整理した回路を図 @fig-hartley-ac2 に示す。

#figure_report(path: "assets/figures/10_ハートレー型発振回路.svg", caption: [ハートレー型発振回路], label-name: "fig-hartley", width: figure-widths.at("hartley"))
#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  figure_report(path: "assets/figures/11_ハートレー型交流等価回路1.svg", caption: [ハートレー型の交流等価回路 1], label-name: "fig-hartley-ac1", width: figure-widths.at("hartley-ac1")),
  figure_report(path: "assets/figures/12_ハートレー型交流等価回路2.svg", caption: [ハートレー型の交流等価回路 2], label-name: "fig-hartley-ac2", width: figure-widths.at("hartley-ac2")),
)
#figure_report(path: "assets/figures/13_ハートレー型交流等価回路3.svg", caption: [ハートレー型の交流等価回路 3], label-name: "fig-hartley-ac3", width: figure-widths.at("hartley-ac3"))

$ f_0 = 1 / (2 pi sqrt(L C)) $

で表される。コイルの分割部から得た電圧が帰還電圧となり、増幅器の位相反転と合わせて正帰還を構成する。

=== ② コルピッツ型
コルピッツ型発振回路を図 @fig-colpitts に示す。直流電圧源およびバイパスコンデンサを交流的に短絡して整理した等価回路を図 @fig-colpitts-ac1 および図 @fig-colpitts-ac2 に示す。

#figure_report(path: "assets/figures/14_コルピッツ型発振回路.svg", caption: [コルピッツ型発振回路], label-name: "fig-colpitts", width: figure-widths.at("colpitts"))
#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  figure_report(path: "assets/figures/15_コルピッツ型交流等価回路1.svg", caption: [コルピッツ型の交流等価回路 1], label-name: "fig-colpitts-ac1", width: figure-widths.at("colpitts-ac1")),
  figure_report(path: "assets/figures/16_コルピッツ型交流等価回路2.svg", caption: [コルピッツ型の交流等価回路 2], label-name: "fig-colpitts-ac2", width: figure-widths.at("colpitts-ac2")),
)
#figure_report(path: "assets/figures/17_コルピッツ型交流等価回路3.svg", caption: [コルピッツ型の交流等価回路 3], label-name: "fig-colpitts-ac3", width: figure-widths.at("colpitts-ac3"))

二つのコンデンサを $C_2$、$C_3$ とすると、共振に寄与する合成容量は $C_("eq")=C_2 C_3/(C_2+C_3)$ である。したがって、共振周波数は

$ f_0 = 1 / (2 pi sqrt(L C_("eq"))) $

となる。

コルピッツ型ではコンデンサ分圧で帰還電圧を得る点が、コイル分割を用いるハートレー型と異なる。

== (4) ウィーンブリッジ発振回路の帰還率と平衡条件
ターマン型発振回路の帰還回路を図 @fig-wien-feedback に示す。

#figure_report(path: "assets/figures/18_ターマン型発振回路の帰還回路.svg", caption: [ターマン型発振回路の帰還回路], label-name: "fig-wien-feedback", width: figure-widths.at("wien-feedback"))

$Z_1=1/(1/R_1+j omega C_1)$、$Z_2=R_2+1/(j omega C_2)$とおくと、分圧則より帰還率は



$ beta = Z_1 / (Z_1 + Z_2) $

となる。これを整理すると、

$ beta = 1 / (1 + Z_2 / Z_1) $

$ = 1 / (1 + (R_2 + 1 / (j omega C_2)) (1 / R_1 + j omega C_1)) $

である。分母の積を展開すると、

$ beta = 1 / (1 + R_2/R_1 + C_1/C_2 + j (omega C_1 R_2 - 1/(omega C_2 R_1))) $

である。

ウィーンブリッジ回路を図 @fig-wien-bridge に示す。

#figure_report(path: "assets/figures/19_ウィーンブリッジ回路.svg", caption: [ウィーンブリッジ回路], label-name: "fig-wien-bridge", width: figure-widths.at("wien-bridge"))

平衡条件より、

$ Z_1 R_4 = Z_2 R_3 $

である。$Z_1$ および $Z_2$ を代入すると、

$ R_4 / R_3 = Z_2 / Z_1 $

$ = (R_2 + 1 / (j omega C_2)) (1 / R_1 + j omega C_1) $

となる。これを展開して整理すると、

$ R_4 / R_3 = R_2 / R_1 + C_1 / C_2 + j (omega C_1 R_2 - 1 / (omega C_2 R_1)) $

を得る。発振時には虚部が 0 となるため、

$ omega_0 C_1 R_2 - 1 / (omega_0 C_2 R_1) = 0 $

$ omega_0^2 C_1 C_2 R_1 R_2 = 1 $

$ omega_0^2 = 1 / (R_1 R_2 C_1 C_2) $

$ f_0 = 1 / (2 pi sqrt(R_1 R_2 C_1 C_2)) $

を得る。また、虚部が 0 のときの実部から $R_4/R_3=R_2/R_1+C_1/C_2$ となる。特に $R_1=R_2=R$、$C_1=C_2=C$ のとき、$f_0=1/(2 pi R C)$、$R_4/R_3=2$ であり、帰還率は $beta=1/3$ となる。

図 @fig-wien-amplifier に示す非反転増幅回路では、

$ A = 1 + R_4/R_3 $

である。したがって $beta=1/3$ のとき、定常発振には $A=3$ が必要となる。

#figure_report(path: "assets/figures/20_ウィーンブリッジ増幅回路.svg", caption: [ウィーンブリッジ発振回路の増幅回路部], label-name: "fig-wien-amplifier", width: figure-widths.at("wien-amplifier"))

= 実験結果と検討

== (1) ハートレー型発振回路
ハートレー型発振回路の実験回路を図 @fig-hartley-experiment に示す。発振周波数の理論式は $f_0=1/(2 pi sqrt(L C_2))$ である。測定結果および誤差率を表 2 に示す。

#figure_report(path: "assets/figures/21_ハートレー型発振回路の実験回路.svg", caption: [ハートレー型発振回路の実験回路], label-name: "fig-hartley-experiment", width: figure-widths.at("hartley-experiment"))

#set text(size: 7.5pt)
#csv_table(
  path: "../2_kaito/assets/ハートレー型発振回路の測定結果と誤差率.csv",
  delimiter: "\t",
  caption: [ハートレー型発振回路の測定結果と誤差率],
)
#set text(size: 10pt)

表 2 より、$C_2$ が小さくなるほど理論値との誤差率が大きくなり、$C_2=48.2 "pF"$ では 27.7 % に達した。コンデンサを開放したときにも 1.116 MHz で発振したことから、コイルの自己共振容量およびトランジスタの内部容量などによる寄生容量 $C_("open")$ が存在すると考えられる。

開放時の発振周波数から、この寄生容量は

$ C_("open") = 1 / ((2 pi times 1.116 times 10^6)^2 times 533.1 times 10^(-6)) $

$ C_("open") = 38.2 "pF" $

と求められる。そこで、各設定容量に $C_("open")$ を加えて理論周波数を補正した。補正後の結果を表 3 に示す。

#set text(size: 7.5pt)
#csv_table(
  path: "../2_kaito/assets/ハートレー型発振回路の測定結果と補正後の誤差率.csv",
  delimiter: "\t",
  caption: [ハートレー型発振回路の測定結果と補正後の誤差率],
)
#set text(size: 10pt)

表 3 では誤差率がほとんど一桁になった。これらは誤差の範囲内であると言える。このことから、表 2 で誤差率が大きくなった理由はコイルとトランジスタによる静電容量による影響があったということが確認できた。

== (2) コルピッツ型発振回路
コルピッツ型発振回路の実験回路を図 @fig-colpitts-experiment に示す。発振周波数の理論式は

$ f_0 = 1 / (2 pi sqrt(L ((C_1C_3)/(C_1+C_3)))) $

である。測定結果および誤差率を表 4 に示す。

#figure_report(path: "assets/figures/22_コルピッツ型発振回路の実験回路.svg", caption: [コルピッツ型発振回路の実験回路], label-name: "fig-colpitts-experiment", width: figure-widths.at("colpitts-experiment"))

#set text(size: 7.5pt)
#csv_table(
  path: "../2_kaito/assets/ルピッツ型発振回路の測定結果と誤差率.csv",
  delimiter: "\t",
  caption: [コルピッツ型発振回路の測定結果と誤差率],
)
#set text(size: 10pt)

表 4 より、$C_3$ が小さいほど誤差率が大きく、48.2 pF では 24.7 %、963 pF では 0.5 % であった。これは、コイルの自己共振容量やトランジスタのコレクタ出力容量などの寄生容量の相対的影響が、小容量側で大きくなるためと考えられる。

そこで、二つのコンデンサによる合成容量に寄生容量 $C_("open")$ を加えたときの発振周波数を考える。補正後の理論式は、

$ f_0 = 1 / (2 pi sqrt(L_2 ((C_1C_3) / (C_1 + C_3) + C_("open")))) $

である。この式を $C_("open")$ について解くと、

$ C_("open") = 1 / ((2 pi f_0)^2 L_2) - (C_1C_3) / (C_1 + C_3) $

となる。各測定値から求めた $C_("open")$ は表 5 に示すように 5.0 pF から 35.1 pF の範囲であり、その平均値は 21.5 pF であった。測定ごとの誤差の影響を小さくするため、この平均値を用いて理論周波数を補正した結果を表 6 に示す。

#set text(size: 7.5pt)
#csv_table(
  path: "../2_kaito/assets/コルピッツ型発振回路の寄生容量.csv",
  delimiter: "\t",
  caption: [コルピッツ型発振回路で各測定値から求めた寄生容量],
)
#set text(size: 10pt)

#set text(size: 7.5pt)
#csv_table(
  path: "../2_kaito/assets/コルピッツ型発振回路の測定結果と補正後の誤差率.csv",
  delimiter: "\t",
  caption: [コルピッツ型発振回路の測定結果と補正後の誤差率],
)
#set text(size: 10pt)

表 6 より、補正後の誤差率をみると、ほとんどが 1 桁になっているため、誤差の範囲内であるといえる。
48.2 pF および 98.9 pF では補正後も誤差が比較的大きいが、これらは設定容量に対する $C_("open")$ の割合が大きく、個々の測定から求めた寄生容量の変化の影響を受けやすいためと考えられる。
このことより、表 4 の誤差の主因はコイルとトランジスタによる静電容量であったと判断できる。

== (3) ウィーンブリッジ発振回路
ウィーンブリッジ発振回路の実験回路を図 @fig-wien-feedback-measurement に示す。
帰還回路の周波数特性を測定して得たボード線図を図 @fig-bode に示す。



#figure(
  image("assets/ウィーンブリッジ発振器用帰還回路の実験回路.jpeg", width: figure-widths.at("wien-feedback-measurement")),
  caption: [ウィーンブリッジ発振器用帰還回路の実験回路],
) <fig-wien-feedback-measurement>

#figure(
  image("assets/wien-bridge-bode.svg", width: figure-widths.at("bode")),
  caption: [ウィーンブリッジ帰還回路のボード線図。点は測定値、破線は位相差 0° および最大帰還率を示す。],
) <fig-bode>

図 @fig-bode に示すように、帰還率 $beta$ は 3400 Hz のとき最大となり、$beta=0.324$ であった。

ここで、発振周波数の理論値は原理の (4) より、

$ f_0 = 1 / (2 pi sqrt(C_1 C_2 R_1 R_2)) = 1 / (2 pi sqrt(48.4 times 10^(-9) times 46.7 times 10^(-9) times 1.01 times 10^3 times 992)) $

$ approx 3.34 "kHz" $

と求められる。したがって、帰還率が最大となる周波数 3.400 kHz に対する誤差率は、

$ (3.40 - 3.34) / 3.34 times 100 = 1.80 ... % approx 2 % $

となる。誤差率は 1 桁であるため、誤差の範囲内であるといえる。

#pagebreak()

次に、ウィーンブリッジ発振回路の実験回路を、図 @fig-wien-experiment に示す。

#figure_report(path: "assets/figures/23_ウィーンブリッジ発振回路の実験回路.svg", caption: [ウィーンブリッジ発振回路の実験回路], label-name: "fig-wien-experiment", width: figure-widths.at("wien-experiment"))



可変抵抗 $R_4=20.36 "kΩ"$ に設定し、増幅率を上昇させて発振を開始したときの周波数を表 7 に示す。

#figure(
  table(
    columns: (45mm, 80mm),
    align: center + horizon,
    inset: 6pt,
    stroke: none,
    table.hline(y: 0, stroke: 1.5pt),
    table.hline(y: 1, stroke: 0.8pt),
    [回数], [上昇時の測定値 [kHz]],
    [1回目], [3.33],
    [2回目], [3.33],
    table.hline(stroke: 1.5pt),
  ),
  caption: [ウィーンブリッジ発振回路の発振開始周波数],
  kind: table,
) <tbl-wien-start-frequency>

表 7 の発振開始周波数 3.33 kHz に対する誤差率は、

$ (3.34 - 3.33) / 3.34 times 100 = 0.299 ... % approx 0.3 % $

となり、誤差率は 1 桁になっているため、誤差の範囲内であるといえる。

また、抵抗の実測値 $R_3=9.99 "kΩ"$、$R_4=20.41 "kΩ"$ を用いると、電圧増幅率 $A$ は

 $ A = 1 + R_4 / R_3 = 1 + 20.41 / 9.99 = 3.04 $

となる。

原理の (4) より、発振条件を満たすために必要な電圧増幅率は、

$ A = 1 + R_4 / R_3 = 1 + R_2 / R_1 + C_1 / C_2  = 1 + 0.992 / 1.01 + 48.7 / 46.7 = 3.03 $

と求められる

誤差率は

$ (3.04 - 3.03) / 3.03 times 100 = 0.330 ... % approx 0.3 % $

となり、誤差率は 1 桁になっているため、誤差の範囲内であるといえる。

また、測定した帰還率 $beta=0.324$ より、

$ A beta = 3.04 times 0.324 = 0.985 $

となる。$A beta$ の理想値 1 からの誤差率は 1.5 % であり2桁になっているが、測定値の丸め、読み取り時の誤差によるものだと考えられる。
