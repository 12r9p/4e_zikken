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
#let title = "単相変圧器の特性試験と各種三相結線"
#let place = "電気機械実験室"
#let date = "2026年4月17,24日"
#let whether = "晴れ 18.9℃ 50%"
#let teacher = "関口 直俊 教員"
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
#v(2em)

#pagebreak()


// ================================

= 目的
(A)各種試験法を通して、電力用変圧器の損失、電圧変動率、効率などの諸特性を学ぶ。

(B)単相変圧器の各種三相結線法の特徴を理解するとともに、誤結線の場合の動作についても理解する。このため、種々の三相結線における相電圧と線間電圧の絶対値の関係、およびそれらの波形を観察する。

= 回路図

回路図を図 @2-1kairo ～ @2-6kairo に示す。

#figure(
  image("assets/2-1kairo.png", width: 60%),
  caption: [無負荷試験回路]
)<2-1kairo>
#figure(
  image("assets/2-2kairo.png", width: 60%),
  caption: [実負荷試験回路]
)<2-2kairo>
#figure(
  image("assets/2-3kairo.png", width: 60%),
  caption: [star-star結線回路]
)<2-3kairo>
#figure(
  image("assets/2-4kairo.png", width: 60%),
  caption: [delta-star結線回路]
)<2-4kairo>
#figure(
  image("assets/2-5kairo.png", width: 60%),
  caption: [delta-delta結線回路]
)<2-5kairo>
#figure(
  image("assets/2-5-2kairo.png", width: 60%),
  caption: [deltaループ解放回路]
)<2-5-2kairo>
#figure(
  image("assets/2-6kairo.png", width: 60%),
  caption: [open delta-open delta 結線回路]
)<2-6kairo>

= 使用器具
図 @siyoukigu に示す。

#figure(
  image("assets/siyoukigu.png", width: 60%),
  caption:[使用器具]
)<siyoukigu>


= 結果

== 2.1

結果を図 @2-1kekka に示す。

#figure(
image("assets/2-1kekka.png", width: 70%),
caption: [無負荷試験時の特性]
)<2-1kekka>



== 2.2

結果を図 @2-2kekka に示す。

#figure(
image("assets/2-2kekka.png", width: 70%),
caption: [実負荷試験時の特性]
)<2-2kekka>

電圧変動率εは0.025604297であった。

== 2.3 star-star結線
=== 2.3.1 正規結線

==== (1)

結果を図 @2-3-1kekka に示す。

#figure(
  image("assets/2-3-1kekka.png", width: 50%),
  caption: [star-star結線（正規結線）の測定結果]
)<2-3-1kekka>

==== (2)

一次側および二次側の電圧波形を図 @yy_phase1_0 ～ @yy_line1_3 に示す。

#grid(
  columns: 2,
  [#figure(
    image("hakei/yy_phase1_0.png", width: 90%),
    caption: [star-star結線の一次側相電圧波形]
  )<yy_phase1_0>
  #v(2em)],[
  #figure(
    image("hakei/yy_phase2_1.png", width: 90%),
    caption: [star-star結線の一次側線間電圧波形]
  )<yy_phase2_1>
  #v(2em)],[
  #figure(
    image("hakei/yy_phase3_2.png", width: 90%),
    caption: [star-star結線の二次側相電圧波形]
  )<yy_phase3_2>
  #v(2em)],[
  #figure(
    image("hakei/yy_line1_3.png", width: 90%),
    caption: [star-star結線の二次側線間電圧波形]
  )<yy_line1_3>
  #v(2em)
  ]
)

==== (3)

励磁電流の波形を図 @yy_line3_5 に示す。

#figure(
  image("hakei/yy_line3_5.png", width: 50%),
  caption: [star-star結線の励磁電流波形]
)<yy_line3_5>


=== 2.3.2 誤結線
結果を図 @2-3-2kekka に示す。

#figure(
  image("assets/2-3-2kekka.png", width: 50%),
  caption: [star-star結線（誤結線）の測定結果]
)<2-3-2kekka>

== 2.4 delta-star結線
=== 2.4.1 正規結線
==== (1)

結果を図 @2-4-1kekka に示す。
#figure(
  image("assets/2-4-1kekka.png", width: 50%),
  caption: [delta-star結線（正規結線）の測定結果]
)<2-4-1kekka>


==== (2)

一次側および二次側の電圧波形を図 @dy_line1_6 ～ @dy_phase3_8 に示す。

#grid(
  columns: 2,[
  #figure(
    image("hakei/dy_line1_6.png", width: 90%),
    caption: [delta-star結線の一次側線間電圧波形]
  )<dy_line1_6>
  #v(2em)],[
  #figure(
    image("hakei/dy_line2_7.png", width: 90%),
    caption: [delta-star結線の二次側相電圧波形]
  )<dy_line2_7>
  #v(2em)],[
  #figure(
    image("hakei/dy_phase3_8.png", width: 90%),
    caption: [delta-star結線の二次側線間電圧波形]
  )<dy_phase3_8>
  #v(2em)]
)

==== (3)

励磁電流の波形を図 @dy_current_9 に示す。

#figure(
  image("hakei/dy_current_9.png", width: 50%),
  caption: [delta-star結線の励磁電流波形]
)<dy_current_9>

=== 2.4.2 誤結線
結果を図 @2-4-2kekka に示す。

#figure(
  image("assets/2-4-2kekka.png", width: 50%),
  caption: [delta-star結線（誤結線）の測定結果]
)<2-4-2kekka>

== 2.5 delta-delta結線
=== 2.5.1 正規結線
==== (1)
結果を図 @2-5-1kekka に示す。

#figure(
  image("assets/2-5-1kekka.png", width: 50%),
  caption: [delta-delta結線（正規結線）の測定結果]
)<2-5-1kekka>


==== (2)

一次側および二次側の線間電圧波形を図 @dd_line1_10 ～ @dd_line2_11 に示す。

#grid(
  columns: 2,
  [#figure(
    image("hakei/dd_line1_10.png", width: 90%),
    caption: [delta-delta結線の一次側線間電圧波形]
  )<dd_line1_10>
  #v(2em)],
  [#figure(
    image("hakei/dd_line2_11.png", width: 90%),
    caption: [delta-delta結線の二次側線間電圧波形]
  )<dd_line2_11>
  #v(2em)]
)

==== (3)

励磁電流の波形を図 @dd_line3_12 に示す。

#figure(
  image("hakei/dd_line3_12.png", width: 50%),
  caption: [delta-delta結線の励磁電流波形]
)<dd_line3_12>

=== 2.5.2 deltaループを開く
=== 2.5.3 誤結線
結果を図 @2-5-3kekka に示す。

#figure(
  image("assets/2-5-3kekka.png", width: 50%),
  caption: [delta-delta結線（誤結線）の測定結果]
)<2-5-3kekka>

== 2.6 open delta-open delta結線
=== 2.6.1 正規結線
==== (1)
結果を図 @2-6-1kekka に示す。

#figure(
  image("assets/2-6-1kekka.png", width: 50%),
  caption: [open delta-open delta結線（正規結線）の測定結果]
)<2-6-1kekka>


==== (2)

一次側および二次側の線間電圧波形を図 @od_line1_13 ～ @od_line2_14 に示す。

#grid(
  columns: 2,
  [#figure(
    image("hakei/od_line1_13.png", width: 90%),
    caption: [open delta結線の一次側線間電圧波形]
  )<od_line1_13>
  #v(2em)],
  [#figure(
    image("hakei/od_line2_14.png", width: 90%),
    caption: [open delta結線の二次側線間電圧波形]
  )<od_line2_14>
  #v(2em)]
)

==== (3)

励磁電流の波形を図 @od_current_15 に示す。

#figure(
  image("hakei/od_current_15.png", width: 50%),
  caption: [open delta結線の励磁電流波形]
)<od_current_15>

=== 2.6.2 誤結線
結果を図 @2-6-2kekka に示す。

#figure(
  image("assets/2-6-2kekka.png", width: 50%),
  caption: [open delta-open delta結線（誤結線）の測定結果]
)<2-6-2kekka>

#pagebreak()

= 検討
== (1) 無負荷試験の結果について、グラフから読み取れることを述べよ。

無負荷試験では、印加電圧の上昇に対して無負荷電流は小さい値のまま推移し、一次入力電力は主として鉄損（ヒステリシス損・渦電流損）に対応して増加した。
二次側は開放のため出力電力はほぼ 0 であり、入力電力の大部分が損失として消費されることを確認できた。
また、低電圧域では電流変化が比較的緩やかである一方、定格付近では磁気飽和現象の影響により電流増加がやや大きくなる傾向がみられた。


== (2) 実負荷試験の結果について、グラフから読み取れることを述べよ。

実負荷試験では、負荷電流の増加に伴って二次端子電圧が低下し、変圧器内部インピーダンス（巻線抵抗・漏れリアクタンス）による電圧降下を確認できた。
同時に銅損は電流のおおよそ二乗に比例して増加するため、負荷が重くなるほど効率低下要因が大きくなる。
鉄損と銅損が等しくなる点で効率が最も最大になるため、中負荷付近で効率がピークに達することもグラフから読み取れた。
本実験で求めた電圧変動率は $epsilon = 0.0256$（約 2.56%）であり、定格近傍での電圧低下は実用上許容範囲にあると考えられる。
効率は一般に、軽負荷側では固定的な鉄損の影響で低く、中負荷付近で高くなり、さらに重負荷側で銅損増大により低下する傾向を示す。


== (3) 無負荷励磁電流波形を比較せよ。

無負荷励磁電流波形を比較すると、いずれの結線でも完全な正弦波ではなく、磁化特性の非線形性に起因するひずみを含むことが分かる。
star-star 結線では波形の対称性が比較的良い一方、delta を含む結線では循環電流の影響で高調波成分の現れ方が変化し、波形のピーク形状に差が見られた。
open delta-open delta 結線では三相平衡条件が弱くなるため、他方式に比べて振幅の不揃いやひずみが目立ち、励磁電流の不平衡が生じやすいことを確認した。


== (4) 各種三相結線の特徴それぞれ述べよ。

star-star（Y-Y）結線は、相電圧と線間電圧の関係が明確で取り扱いやすく、相電圧が線間電圧の$1/ √3$倍になるため、絶縁設計上も有利である。
ただし中性点の扱いによっては三次高調波の影響を受けやすく、負荷条件により電圧波形が乱れる場合がある。

\

delta-star（Δ-Y）結線は、一次側 delta による高調波抑制効果を得やすく、配電系統で広く用いられる。
一方で一次・二次間に位相差（30 度）が生じるため、系統連系時は極性・相順の確認が必須である。

\

delta-delta（Δ-Δ）結線は、三次高調波に対して比較的安定で、三相負荷への対応力が高い。
また一相故障時に open delta 運転へ移行できる利点があるが、同容量での効率や電圧維持は低下する。
open delta-open delta（V-V）結線は、機器故障時の暫定運転や小容量用途で有効である。

\

ただし供給可能容量が小さく、電圧変動・不平衡・効率低下が生じやすいため、常用よりも非常運転向きである。
\
具体的にはデルタ結線の$√3/3$に低下する。

\

誤結線時は、相電圧と線間電圧の関係や位相関係が崩れ、波形異常・過電流・トルク脈動などの原因となる。
したがって投入前に、相順・極性・結線図の三点確認を行うことが重要である。


