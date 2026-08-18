#import "../lib/report-utils.typ": *
#show: setup_report

// 検証時のみ --input render-circuit-images=false を指定する。
#let render-circuit-images = sys.inputs.at("render-circuit-images", default: "true") == "true"
#let figure_report(path: "", caption: "", label-name: "", width: 72%) = [
  #figure(
    if render-circuit-images {
      image(path, width: width)
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
  path: "assets/帰還発振回路の発振原理.jpeg",
  caption: [帰還発振回路の発振原理],
  label-name: "fig-feedback",
  width: 36%,
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
  path: "assets/エミッター接地増幅回路.jpeg",
  caption: [エミッター接地増幅回路],
  label-name: "fig-ce-circuit",
  width: 40%,
)

#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  figure_report(path: "assets/エミッター接地増幅回路の交流回路.jpeg", caption: [エミッター接地の交流回路], label-name: "fig-ce-ac", width: 65%),
  figure_report(path: "assets/エミッター接地増幅回路のhパラメータを用いた簡易等価回路.jpeg", caption: [エミッター接地の h パラメータ等価回路], label-name: "fig-ce-hparam", width: 105%),
)
図 @fig-ce-hparam の赤矢印をループの正方向とする。入力側のループを時計回りに一周すると、電源では $v_i$ だけ電位が上昇し、$h_("ie")$ では電流 $i_b$ の向きに $h_("ie")i_b$ だけ電位が低下する。したがって、キルヒホッフの第 2 法則より、

$ v_i - h_("ie") i_b = 0 quad quad v_i = h_("ie") i_b $

となる。出力側のループは、赤矢印に沿って反時計回りにとる。制御電流源の電流 $i_c=h_("fe")i_b$ は上側の節点から下向きに流れるため、$R_C$ を流れる電流は同じ大きさで下から上へ流れる。$R_C$ の下端と上端の電位をそれぞれ $V_("L")$、$V_("H")$ とすると、受動符号規約より $V_("L")-V_("H")=R_C i_c$ である。一方、図の上向きを正とする出力電圧は $v_o=V_("H")-V_("L")$ であるため、

$ v_o = -R_C i_c = -R_C h_("fe") i_b $

と表せる。よって電圧増幅率 $A_v$ は、

$ A_v = v_o / v_i = - (h_("fe") / h_("ie")) R_C $

となる。すなわち、エミッター接地増幅回路では入力と出力の位相は 180° 反転する。

=== ② ベース接地増幅回路
ベース接地増幅回路を図 @fig-cb-circuit に、交流回路および h パラメータを用いた簡易等価回路を図 @fig-cb-ac および図 @fig-cb-hparam に示す。

#figure_report(
  path: "assets/ベース接地増幅回路.jpeg",
  caption: [ベース接地増幅回路],
  label-name: "fig-cb-circuit",
  width: 42%,
)


#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  figure_report(path: "assets/ベース接地増幅回路の交流回路.jpeg", caption: [ベース接地の交流回路], label-name: "fig-cb-ac", width: 50%),
  figure_report(path: "assets/ベース接地増幅回路のhパラメータを用いた簡易等価回路.jpeg", caption: [ベース接地の h パラメータ等価回路], label-name: "fig-cb-hparam", width: 75%),
)

図 @fig-cb-hparam では、入力側の赤矢印を時計回り、出力側の赤矢印を反時計回りの正方向とする。入力側のループでは、$h_("ie")$ を電流 $i_b$ の向きに上から下へ通過するため、電位は $h_("ie")i_b$ だけ低下する。また、$v_i$ は上向きを正としているため、ループを上から下へ通過すると $v_i$ だけ電位が低下する。したがって、

$ -h_("ie") i_b - v_i = 0 quad therefore quad v_i = -h_("ie") i_b $

となる。出力側では、制御電流源の電流 $i_c=h_("fe")i_b$ により、$R_C$ の電流は赤矢印と同じく下から上へ流れる。$R_C$ の下端と上端の電位をそれぞれ $V_("L")$、$V_("H")$ とすると、$V_("L")-V_("H")=R_C i_c$ となる。図の上向きを正とする出力電圧は $v_o=V_("H")-V_("L")$ であるため、

$ v_o = -R_C i_c = -R_C h_("fe") i_b $

である。したがって、

$ A_v = v_o / v_i = (h_("fe") / h_("ie")) R_C $

となる。ベース接地増幅回路では、入力と出力の位相反転は生じない。

== (3) LC 発振回路の交流等価回路

=== ① ハートレー型
ハートレー型発振回路を図 @fig-hartley に示す。直流電圧源および結合・バイパスコンデンサを交流的に短絡した回路を図 @fig-hartley-ac1 に示す。さらに、交流的に等電位となる抵抗を短絡し、交流電流が流れない抵抗を開放して整理した回路を図 @fig-hartley-ac2 に示す。

#figure_report(path: "assets/ハートレー型発振回路.jpeg", caption: [ハートレー型発振回路], label-name: "fig-hartley", width: 52%)
#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  figure_report(path: "assets/ハートレー型発振回路の交流等価回路1.jpeg", caption: [ハートレー型の交流等価回路 1\ 直流電圧源とコンデンサ $C_B,C_f,C_o$ を短絡する], label-name: "fig-hartley-ac1", width: 96%),
  figure_report(path: "assets/ハートレー型発振回路の交流等価回路2.jpeg", caption: [ハートレー型の交流等価回路 2\ R1 の両端は等電位であるため、短絡とみなせる。\ また、Re には電流が流れないため開放する。\ Rf の抵抗値は 0 と近似し短絡する], label-name: "fig-hartley-ac2", width: 65%),
)
#figure_report(path: "assets/ハートレー型発振回路の交流等価回路3.jpeg", caption: [ハートレー型の交流等価回路 3\ 図@fig-hartley-ac2 を整理したものを示す。], label-name: "fig-hartley-ac3", width: 25%)

$ f_0 = 1 / (2 pi sqrt(L C)) $

で表される。コイルの分割部から得た電圧が帰還電圧となり、増幅器の位相反転と合わせて正帰還を構成する。

=== ② コルピッツ型
コルピッツ型発振回路を図 @fig-colpitts に示す。直流電圧源およびバイパスコンデンサを交流的に短絡して整理した等価回路を図 @fig-colpitts-ac1 および図 @fig-colpitts-ac2 に示す。

#figure_report(path: "assets/コルピッツ型発振回路.jpeg", caption: [コルピッツ型発振回路], label-name: "fig-colpitts", width: 52%)
#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  figure_report(path: "assets/コルピッツ型発振回路の交流等価回路1.jpeg", caption: [コルピッツ型の交流等価回路 1\ 流電圧源とコンデンサ $C_B,C_o$ を短絡する], label-name: "fig-colpitts-ac1", width: 95%),
  figure_report(path: "assets/コルピッツ型発振回路の交流等価回路2.jpeg", caption: [コルピッツ型の交流等価回路 2\ R1 の両端は等電位であるため、短絡とみなせる。\ また、Re には電流が流れないため開放する。\ Rf の抵抗値は 0 と近似し短絡する。], label-name: "fig-colpitts-ac2", width: 65%),
)
#figure_report(path: "assets/コルピッツ型発振回路の交流等価回路3.jpeg", caption: [コルピッツ型の交流等価回路 3\ 図@fig-colpitts-ac2 を整理したものを示す。], label-name: "fig-colpitts-ac3", width: 25%)

図 @fig-colpitts-ac3 の二つのコンデンサを $C_1$、$C_2$ とすると、共振に寄与する合成容量は $C_("eq")=C_1 C_2/(C_1+C_2)$ である。したがって、共振周波数は

$ f_0 = 1 / (2 pi sqrt(L C_("eq"))) $

となる。

コルピッツ型ではコンデンサ分圧で帰還電圧を得る点が、コイル分割を用いるハートレー型と異なる。

== (4) ウィーンブリッジ発振回路の帰還率と平衡条件
ターマン型発振回路の帰還回路を図 @fig-wien-feedback に示す。

#figure_report(path: "assets/ターマン型発振回路の帰還回路.jpeg", caption: [ターマン型発振回路の帰還回路], label-name: "fig-wien-feedback", width: 45%)

$R_1$ と $C_1$ の並列回路のインピーダンスを $Z_1=1/(1/R_1+j omega C_1)$、$R_2$ と $C_2$ の直列回路のインピーダンスを $Z_2=R_2+1/(j omega C_2)$ とおくと、分圧則より帰還率は



$ beta = Z_1 / (Z_1 + Z_2) $

となる。これを整理すると、

$ beta = 1 / (1 + Z_2 / Z_1) $

$ = 1 / (1 + (R_2 + 1 / (j omega C_2)) (1 / R_1 + j omega C_1)) $

である。分母の積を展開すると、

$ beta = 1 / (1 + R_2/R_1 + C_1/C_2 + j (omega C_1 R_2 - 1/(omega C_2 R_1))) $

である。

ウィーンブリッジ回路を図 @fig-wien-bridge に示す。

#figure_report(path: "assets/ウィーンブリッジ回路.jpeg", caption: [ウィーンブリッジ回路], label-name: "fig-wien-bridge", width: 55%)

平衡条件より、

$ Z_1 R_4 = Z_2 R_3 $

である。ここで、$1/Z_1=1/R_1+j omega C_1, Z_2 = R_2 + 1/(j omega C_2) $ であるため、$Z_1$ および $Z_2$ を代入すると、

$ R_4 / R_3 = Z_2 / Z_1  = (R_2 + 1 / (j omega C_2)) (1 / R_1 + j omega C_1) $


$ R_4 / R_3 = R_2/R_1 + j omega C_1 R_2 + 1/(j omega C_2 R_1) + C_1/C_2 $

となる。ここで $1/j=-j$ を用いて実部と虚部に分けると、

$ R_4 / R_3 = R_2 / R_1 + C_1 / C_2 + j (omega C_1 R_2 - 1 / (omega C_2 R_1)) $

を得る。発振時には虚部が 0 となるため、

$ omega_0 C_1 R_2 - 1 / (omega_0 C_2 R_1) = 0 $

$ omega_0^2 C_1 C_2 R_1 R_2 = 1 $

$ omega_0^2 = 1 / (R_1 R_2 C_1 C_2) $

$ f_0 = 1 / (2 pi sqrt(R_1 R_2 C_1 C_2)) $

を得る。また、虚部が 0 のときの実部から $R_4/R_3=R_2/R_1+C_1/C_2$ となる。

図 @fig-wien-amplifier の増幅回路は非反転増幅回路であるため、その電圧増幅率は

$ A = 1 + R_4/R_3 $

である。したがって、帰還回路の平衡条件から求めた $R_4/R_3$ を用いると、発振に必要な増幅率は $A=1+R_2/R_1+C_1/C_2$ と表される。

#figure_report(path: "assets/ウィーンブリッジ発振回路の増幅回路部.jpeg", caption: [ウィーンブリッジ発振回路の増幅回路部], label-name: "fig-wien-amplifier", width: 35%)

= 実験結果と検討

== (1) ハートレー型発振回路
ハートレー型発振回路の実験回路を図 @fig-hartley-experiment に示す。発振周波数の理論式は $f_0=1/(2 pi sqrt(L C_2))$ である。測定結果および誤差率を表 2 に示す。

#figure_report(path: "assets/ハートレー型発振回路の実験回路.jpeg", caption: [ハートレー型発振回路の実験回路], label-name: "fig-hartley-experiment", width: 54%)

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



補正後の誤差率をみると、ほとんどが 1 桁になっているため、誤差の範囲内であるといえる。静電容量が小さい値である 85.5pF の時、誤差率が 2 桁となっている。これは、C2 が大きい時は、Copen の影響が小さいが、C2 が小さい時は、Copen の影響が大きくなるため誤差率が２桁になったと考えた。

したがって、表 2 の大きな誤差の主因は寄生容量であること確認できる。

== (2) コルピッツ型発振回路
コルピッツ型発振回路の実験回路を図 @fig-colpitts-experiment に示す。発振周波数の理論式は

$ f_0 = 1 / (2 pi sqrt(L ((C_1C_3)/(C_1+C_3)))) $

である。

測定結果および誤差率を表 4 に示す。

#figure_report(path: "assets/コルピッツ型発振回路の実験回路.jpeg", caption: [コルピッツ型発振回路の実験回路], label-name: "fig-colpitts-experiment", width: 54%)

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

となる。各測定値から求めた $C_("open")$ は表 5 に示すように 5.0 pF から 35.1 pF の範囲であり、その平均値は 21.5 pF であった。この平均値を用いて理論周波数を補正した結果を表 6 に示す。

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

表5を見ると、測定値から求めた $C_("open")$は 5.0 pF～35.1 pF の範囲で変化しており、一定の値ではないことがわかる。そのため、表6のように平均値である 21.5 pF をすべての条件に用いると、実際の寄生容量との差が補正後にも誤差として残ると考えられる。

特に $C_3$ が小さい場合は合成容量も小さくなるため、寄生容量のわずかな違いでも全体に与える影響が大きくなる。このため、高周波側では周波数のずれも大きくなりやすい。

以上から、表4で見られた誤差には寄生容量が大きく関係していると考えられる。また、表6で補正後にも誤差が残った理由としては、寄生容量を一定値として扱っていることに加え、コイルのインダクタンスやトランジスタの容量が周波数によって変化することも影響していると考えられる。

== (3) ウィーンブリッジ発振回路
ウィーンブリッジ発振器用帰還回路の実験回路を図 @fig-wien-feedback-measurement に示す。
帰還回路の周波数特性を測定して得たボード線図を図 @fig-bode に示す。



#figure(
  image("assets/ウィーンブリッジ発振器用帰還回路の実験回路.jpeg", width: 40%),
  caption: [ウィーンブリッジ発振器用帰還回路の実験回路],
) <fig-wien-feedback-measurement>

#figure(
  image("assets/wien-bridge-bode.svg", width: 65%),
  caption: [ウィーンブリッジ帰還回路のボード線図。点は測定値、破線は位相差 0° および最大帰還率を示す。],
) <fig-bode>

図 @fig-bode に示すように、帰還率 $beta$ は 3400 Hz のとき最大となり、$beta=0.324$ であった。

ここで、発振周波数の理論値は原理の (4) より、

$ f_0 = 1 / (2 pi sqrt(C_1 C_2 R_1 R_2)) = 1 / (2 pi sqrt(48.4 times 10^(-9) times 46.7 times 10^(-9) times 1.01 times 10^3 times 992)) $

$ approx 3.34 "kHz" $

と求められる。したがって、帰還率が最大となる周波数 3.400 kHz に対する誤差率は、

$ (3.40 - 3.34) / 3.34 times 100 = 1.80 ... % approx 2 % $

この誤差率は 1 桁であるため、誤差の範囲内であるといえる。

#pagebreak()

次に、ウィーンブリッジ発振回路の実験回路を、図 @fig-wien-experiment に示す。

#figure_report(path: "assets/ウィーンブリッジ発振回路の実験回路.jpeg", caption: [ウィーンブリッジ発振回路の実験回路], label-name: "fig-wien-experiment", width: 52%)



可変抵抗 $R_4=20.41 "kΩ"$ に設定し、増幅率を上昇させて発振を開始したときの周波数を表 7 に示す。

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

 $ A = 1 + R_4 / R_3 = 1 + 20.41 / 9.99 = 3.0430 ... approx 3.04 $

となる。

原理の (4) より、発振条件を満たすために必要な電圧増幅率は、

$ A = 1 + R_4 / R_3 = 1 + R_2 / R_1 + C_1 / C_2  = 1 + 0.992 / 1.01 + 48.4 / 46.7 = 3.0186 ... approx 3.02 $

と求められる。

誤差率は

$ (3.0430 - 3.0186) / 3.0186 times 100 = 0.808 ... % approx 0.8 % $

となり、誤差率は 1 桁になっているため、誤差の範囲内であるといえる。

また、測定した帰還率 $beta=0.324$ より、

$ A beta = 3.0430 times 0.324 = 0.9859 ... approx 0.986 $

したがって、$A beta$ の理想値 1 に対する誤差率は、

$ (1 - 0.9859) / 1 times 100  approx 1.4 % $

となった。
以上より、実測した $A beta$ は0.986となり、理想値1との差は約1.4 %であった。この差には、オシロスコープによる実効値の測定誤差が主に影響したと考えられる。

今回使用したオシロスコープの垂直軸利得確度は $plus.minus 3.0 %$ である。入力電圧と出力電圧をそれぞれ測定し、その比から帰還率を求めているため、両チャンネルの測定誤差の差が帰還率の誤差として現れる可能性がある。
今回、$A beta = 1$ を満たすために必要な帰還率は、

$
beta
= frac(1, 3.0430)
approx 0.329
$

であり、実測値 $0.324$ との差は約1.3 %である。この差は、オシロスコープの測定確度によって生じる可能性がある。

したがって、理論的な発振条件と実測結果は一致しているといえる。
