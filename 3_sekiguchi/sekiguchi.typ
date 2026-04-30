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

== 2.3
=== 2.3.1 正規結線
==== (1)


==== (2)

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

#figure(
  image("hakei/yy_line3_5.png", width: 50%),
  caption: [star-star結線の励磁電流波形]
)<yy_line3_5>


=== 2.3.2 誤結線

== 2.4
=== 2.4.1 正規結線
==== (1)

==== (2)

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

#figure(
  image("hakei/dy_current_9.png", width: 50%),
  caption: [delta-star結線の励磁電流波形]
)<dy_current_9>

=== 2.4.2 誤結線
== 2.5
=== 2.5.1 正規結線
==== (1)

==== (2)
#figure(
  image("hakei/dd_line1_10.png", width: 70%),
  caption: [delta-delta結線の一次側線間電圧波形]
)<dd_line1_10>
#figure(
  image("hakei/dd_line2_11.png", width: 70%),
  caption: [delta-delta結線の二次側線間電圧波形]
)<dd_line2_11>

==== (3)
#figure(
  image("hakei/dd_line3_12.png", width: 70%),
  caption: [delta-delta結線の励磁電流波形]
)<dd_line3_12>

=== 2.5.2 deltaループを開く
=== 2.5.3 誤結線
== 2.6
=== 2.6.1 正規結線
==== (1)

==== (2)
#figure(
  image("hakei/od_line1_13.png", width: 70%),
  caption: [open delta結線の一次側線間電圧波形]
)<od_line1_13>
#figure(
  image("hakei/od_line2_14.png", width: 70%),
  caption: [open delta結線の二次側線間電圧波形]
)<od_line2_14>

==== (3)

#figure(
  image("hakei/od_current_15.png", width: 70%),
  caption: [open delta結線の励磁電流波形]
)<od_current_15>

=== 2.6.2 誤結線


= 検討
== (1) 無負荷試験の結果について、グラフから読み取れることを述べよ。


== (2) 実負荷試験の結果について、グラフから読み取れることを述べよ。


== (3) 無負荷励磁電流波形を比較せよ。


== (4) 各種三相結線の特徴それぞれ述べよ。
star結線とdelta結線はそれぞれの結線方法に応じた特徴がある。star結線は一次側と二次側の相電圧が等しいため、電圧変動率が小さい。一方、delta結線は一次側と二次側の相電圧が√3倍になるため、電圧変動率が大きい。また、誤結線の場合は、相電圧と線間電圧の関係が崩れるため、波形も異常なものになる。
open delta結線は、二次側の一相が開放されているため、残りの二相で電力を供給することができるが、電圧変動率が非常に大きくなり、効率も低下する。
それぞれの結線の使い分けは、用途や要求される特性に応じて選択される。例えば、star結線は電圧変動率が小さいため、安定した電力供給が求められる場合に適している。一方、delta結線は高い電圧変動率が許容される場合や、三相負荷が不均衡な場合に適している。open delta結線は、二次側の一相が故障した場合のバックアップとして使用されることがあるが、通常は避けられるべきである。


