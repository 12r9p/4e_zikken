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


= 実験結果と検討

アナログ信号を一定時間間隔で標本化し、得られた離散データに高速フーリエ変換（FFT）を適用すると、時間領域の信号を周波数領域の成分に分解できる。サンプリング周波数を $f_s$、FFT のサンプル数を $N$ とすると、周波数ビンの間隔は $Delta f = f_s / N$ である。本実験では $f_s = 48\,"kHz"$ とした。

== 4.2 フーリエ変換の基礎実験

`fft_datacollection` を用いて音声信号の FFT データを取得し、CSV ファイルに保存された 128 個の数値を周波数スペクトルとして整理した。CSV の $k$ 番目の値には $f_k = k f_s/N$ を対応させた。

/* TODO: Arduino IDE、Spresense ボード、マイク、microSD の準備と、シリアルモニタから CSV が生成されたことを実際の作業内容に合わせて追記する。 */

== 4.3 フーリエ変換・逆フーリエ変換

VoiceChanger の `SubFFT` と `MainAudio` を用い、入力音声を FFT して振幅スペクトルをシフトした後、逆 FFT で時間波形に戻した。pitch_shift は周波数そのものではなく、振幅スペクトルを移動させるサンプル数である。

サンプル数を半分にした場合、周波数分解能は低下し、レジュメの記録では出力音声が「ボコボコ」した音になった。これは時間方向の処理単位が短くなったこと、周波数ビンの間隔が広がったこと、および FFT・逆 FFT の近似誤差が音声に現れたためと考えられる。

/* 検討3: 入力音声と出力音声を実際に聴き比べ、音量、音質、音高、歪み、雑音について具体的に追記する。 */

== 4.4 フーリエ変換による周波数解析1

500 Hz 以上の正弦波音声を入力し、pitch_shift を -10 および -20 として入出力音声の振幅スペクトルを比較した。pitch_shift の変更によりスペクトルのピーク位置と分布が変化し、出力音声の音高が変化することを確認した。

#figure(image("figures/pitch_shift_comparison.png", width: 100%), caption: [pitch_shift の違いによる振幅スペクトルの比較]) <pitch-shift>

/* 検討4: 入力音声、実験用アンプからの出力音声、pitch_shift の設定値をもとに、音高・音質・音量の変化を具体的に追記する。 */

== 4.5 フーリエ変換による周波数解析2

メモに記録された時刻に対応する data014（あ）、data020（い）、data024（う）、data028（え）、data033（お）を取り出した。母音ごとにスペクトルのピーク位置と分布が異なり、声帯振動の基本周波数だけでなく、声道の共鳴によるフォルマントが母音の音色を特徴付けている。

#figure(image("figures/vowel_あ.png", width: 100%), caption: [母音「あ」の振幅スペクトル]) <vowel-a>
#figure(image("figures/vowel_い.png", width: 100%), caption: [母音「い」の振幅スペクトル]) <vowel-i>
#figure(image("figures/vowel_う.png", width: 100%), caption: [母音「う」の振幅スペクトル]) <vowel-u>
#figure(image("figures/vowel_え.png", width: 100%), caption: [母音「え」の振幅スペクトル]) <vowel-e>
#figure(image("figures/vowel_お.png", width: 100%), caption: [母音「お」の振幅スペクトル]) <vowel-o>

/* 検討5: 各母音の主なピーク周波数を表にし、メンバーのデータと比較して共通点・差異を追記する。 */

== 4.4・4.5で使用した単色信号の比較

500 Hz と 1 kHz の正弦波では、設定周波数付近に主ピークが現れた。正弦波は単一周波数成分が支配的である。一方、矩形波では基本波に加えて高調波成分が現れ、正弦波より広い周波数帯域に成分が分布した。理想的な対称矩形波では奇数次高調波が主に現れるが、実測ではマイク、アンプ、A/D 変換、窓関数、有限長データの影響でピークの強度や位置にずれが生じる。

#figure(image("figures/sine_500Hz.png", width: 100%), caption: [500 Hz 正弦波の振幅スペクトル]) <sine500>
#figure(image("figures/sine_1000Hz.png", width: 100%), caption: [1 kHz 正弦波の振幅スペクトル]) <sine1000>
#figure(image("figures/square_500Hz.png", width: 100%), caption: [500 Hz 矩形波の振幅スペクトル]) <square500>
#figure(image("figures/square_1000Hz.png", width: 100%), caption: [1 kHz 矩形波の振幅スペクトル]) <square1000>

/* 検討1: 正弦波は設定周波数に集中し、矩形波は高調波を含むという理論と実験結果を比較し、ピーク周波数の誤差を追記する。 */

== サンプル数と振幅スペクトル

500 Hz 系の信号について 1024点、256点、64点を比較した。$Delta f$ はそれぞれ 46.875 Hz、187.5 Hz、750 Hz であり、サンプル数を減らすほどピーク位置が粗くなり、近接した周波数成分を分離しにくくなる。

#figure(image("figures/sample_count_comparison.png", width: 100%), caption: [サンプル数による周波数分解能の比較]) <sample-count>

/* 検討2: サンプル数の変化によるピーク位置・ピーク幅・高調波の見え方を、3つのグラフから具体的に追記する。 */

= 残る検討事項

/* TODO: 使用したマイク、アンプ、スピーカ、音源周波数、音量設定、共同実験者、天候、実験場所を確認して表紙と実験条件表に反映する。 */

= 結論

FFT により音声信号を周波数成分として可視化し、正弦波・矩形波の違い、サンプル数と周波数分解能の関係、pitch_shift によるスペクトル変化、母音ごとの周波数特性を確認した。特に、周波数分解能は $Delta f = f_s/N$ で決まり、サンプル数を増やすほど周波数成分を細かく観測できることを確認した。

/* TODO: レポート提出時に、天候、実験場所、実験日、共同実験者、使用機器の型番を確認して表紙と実験条件に反映する。 */
