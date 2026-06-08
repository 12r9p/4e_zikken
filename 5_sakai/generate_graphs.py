import os
import pandas as pd
import matplotlib.pyplot as plt

# macOSでの日本語文字化け防止のためのフォント設定
plt.rcParams['font.family'] = 'Hiragino Sans'
plt.rcParams['axes.unicode_minus'] = False # マイナス符号の文字化け防止

# 学術論文・実験レポート用の「ちゃんとした」スタイル設定
plt.rcParams['xtick.direction'] = 'in'       # 目盛りを内向きにする
plt.rcParams['ytick.direction'] = 'in'       # 目盛りを内向きにする
plt.rcParams['xtick.top'] = True             # 上部にも目盛りを表示
plt.rcParams['ytick.right'] = True           # 右側にも目盛りを表示
plt.rcParams['xtick.major.width'] = 1.0      # 主目盛りの線の太さ
plt.rcParams['ytick.major.width'] = 1.0
plt.rcParams['xtick.minor.visible'] = True   # 補助目盛りを表示
plt.rcParams['ytick.minor.visible'] = True
plt.rcParams['xtick.minor.width'] = 0.6      # 補助目盛りの線の太さ
plt.rcParams['ytick.minor.width'] = 0.6

# グラフ出力用ディレクトリ
AM_DIR = '5_sakai/am'
FM_DIR = '5_sakai/fm'

# 共通デザイン設定
LINE_COLOR = '#1f77b4'  # スチールブルー
MARKER_COLOR = '#ff7f0e' # オレンジ
GRID_STYLE = '--'
GRID_ALPHA = 0.5

# ----------------- AM (振幅変調) -----------------

# 1. 変調率mの入力電圧Vs依存性
def plot_am_m_vs_Vs():
    csv_path = os.path.join(AM_DIR, '変調率ｍの入力電圧Vs依存性.csv')
    df = pd.read_csv(csv_path, sep='\t')
    
    fig, ax = plt.subplots(figsize=(6, 4.5))
    ax.plot(df['信号波の振幅 [mV]'], df['変調率 m'], marker='o', color=LINE_COLOR, markerfacecolor=MARKER_COLOR, markersize=6, linewidth=1.5)
    ax.set_title('変調率 $m$ の入力電圧 $V_s$ 依存性', fontsize=12, pad=10, weight='bold')
    ax.set_xlabel('信号波の振幅 $V_s$ [mV]', fontsize=11)
    ax.set_ylabel('変調率 $m$', fontsize=11)
    ax.set_xlim(left=0)
    ax.set_ylim(bottom=0, top=1.1)
    ax.grid(True, which='both', linestyle=GRID_STYLE, alpha=GRID_ALPHA)
    fig.tight_layout()
    fig.savefig(os.path.join(AM_DIR, 'am_m_vs_Vs.png'), dpi=300)
    plt.close(fig)

# 2. 変調率mの入力周波数fs依存性
def plot_am_m_vs_fs():
    csv_path = os.path.join(AM_DIR, '変調率ｍの入力周波数fs依存性.csv')
    df = pd.read_csv(csv_path, sep='\t')
    
    fig, ax = plt.subplots(figsize=(6, 4.5))
    ax.plot(df['周波数 [Hz]'], df['変調率 m'], marker='o', color=LINE_COLOR, markerfacecolor=MARKER_COLOR, markersize=6, linewidth=1.5)
    ax.set_title('変調率 $m$ の入力周波数 $f_s$ 依存性', fontsize=12, pad=10, weight='bold')
    ax.set_xlabel('入力周波数 $f_s$ [Hz] (対数軸)', fontsize=11)
    ax.set_ylabel('変調率 $m$', fontsize=11)
    ax.set_xscale('log') # 周波数の変化範囲が広いので対数スケールに設定
    ax.set_ylim(0, 1.2)
    ax.grid(True, which="both", linestyle=GRID_STYLE, alpha=GRID_ALPHA)
    fig.tight_layout()
    fig.savefig(os.path.join(AM_DIR, 'am_m_vs_fs.png'), dpi=300)
    plt.close(fig)

# 3. 復調出力電圧Voutの入力電圧Vs依存性
def plot_am_Vout_vs_Vs():
    csv_path = os.path.join(AM_DIR, '復調出力電圧Voutの入力電圧Vs依存性.csv')
    df = pd.read_csv(csv_path, sep='\t')
    
    fig, ax = plt.subplots(figsize=(6, 4.5))
    ax.plot(df['入力電圧 [mV]'], df['出力電圧 [V]'], marker='o', color=LINE_COLOR, markerfacecolor=MARKER_COLOR, markersize=6, linewidth=1.5)
    ax.set_title('復調出力電圧 $V_{out}$ の入力電圧 $V_s$ 依存性', fontsize=12, pad=10, weight='bold')
    ax.set_xlabel('入力電圧 $V_s$ [mV]', fontsize=11)
    ax.set_ylabel('出力電圧 $V_{out}$ [V]', fontsize=11)
    ax.set_xlim(left=0)
    ax.set_ylim(bottom=0)
    ax.grid(True, which='both', linestyle=GRID_STYLE, alpha=GRID_ALPHA)
    fig.tight_layout()
    fig.savefig(os.path.join(AM_DIR, 'am_Vout_vs_Vs.png'), dpi=300)
    plt.close(fig)

# 4. 復調出力電圧Voutの入力周波数fs依存性
def plot_am_Vout_vs_fs():
    csv_path = os.path.join(AM_DIR, '復調出力電圧Voutの入力周波数fs依存性.csv')
    df = pd.read_csv(csv_path, sep='\t')
    
    fig, ax = plt.subplots(figsize=(6, 4.5))
    ax.plot(df['周波数 [Hz]'], df['出力電圧 [V]'], marker='o', color=LINE_COLOR, markerfacecolor=MARKER_COLOR, markersize=6, linewidth=1.5)
    ax.set_title('復調出力電圧 $V_{out}$ の入力周波数 $f_s$ 依存性 (片対数)', fontsize=12, pad=10, weight='bold')
    ax.set_xlabel('周波数 $f_s$ [Hz] (対数軸)', fontsize=11)
    ax.set_ylabel('出力電圧 $V_{out}$ [V]', fontsize=11)
    ax.set_xscale('log') # 周波数を対数にしたグラフ
    ax.grid(True, which="both", linestyle=GRID_STYLE, alpha=GRID_ALPHA)
    fig.tight_layout()
    fig.savefig(os.path.join(AM_DIR, 'am_Vout_vs_fs.png'), dpi=300)
    plt.close(fig)


# ----------------- FM (周波数変調) -----------------

# 1. 変調器出力周波数fFMのバリキャップバイアス電圧VC依存性
def plot_fm_fFM_vs_VC():
    csv_path = os.path.join(FM_DIR, '変調器の特性（変調器出力周波数fFMのバリキャップのバイアス電圧VC依存性）.csv')
    df = pd.read_csv(csv_path, sep='\t')
    
    fig, ax = plt.subplots(figsize=(6, 4.5))
    ax.plot(df['バイアス電圧V_c [V]'], df['周波数f_FM [kHz]'], marker='o', color=LINE_COLOR, markerfacecolor=MARKER_COLOR, markersize=6, linewidth=1.5)
    ax.set_title('変調器出力周波数 $f_{FM}$ のバイアス電圧 $V_C$ 依存性', fontsize=12, pad=10, weight='bold')
    ax.set_xlabel('バイアス電圧 $V_C$ [V]', fontsize=11)
    ax.set_ylabel('変調器出力周波数 $f_{FM}$ [kHz]', fontsize=11)
    ax.grid(True, which='both', linestyle=GRID_STYLE, alpha=GRID_ALPHA)
    fig.tight_layout()
    fig.savefig(os.path.join(FM_DIR, 'fm_fFM_vs_VC.png'), dpi=300)
    plt.close(fig)

# 2. 復調器出力電圧Voutの復調器入力周波数fFM依存性
def plot_fm_Vout_vs_fFM():
    csv_path = os.path.join(FM_DIR, '復調特性（復調器出力電圧Voutの復調器入力周波数fFM依存性）.csv')
    df = pd.read_csv(csv_path, sep='\t')
    
    fig, ax = plt.subplots(figsize=(6, 4.5))
    ax.plot(df['信号波の周波数 f_FM [kHz]'], df['出力電圧 V_out [V]'], marker='o', color=LINE_COLOR, markerfacecolor=MARKER_COLOR, markersize=4, linewidth=1.2)
    
    # 15kHzから17kHzの直線部分を強調するための枠線
    ax.axvspan(15.0, 17.0, color='gray', alpha=0.15, label='検波器のS字特性の直線部 (15–17 kHz)')
    
    ax.set_title('復調器出力電圧 $V_{out}$ の入力周波数 $f_{FM}$ 依存性 (S字特性)', fontsize=12, pad=10, weight='bold')
    ax.set_xlabel('入力周波数 $f_{FM}$ [kHz]', fontsize=11)
    ax.set_ylabel('出力電圧 $V_{out}$ [V]', fontsize=11)
    ax.legend(loc='upper left', fontsize=9.5)
    ax.grid(True, which='both', linestyle=GRID_STYLE, alpha=GRID_ALPHA)
    fig.tight_layout()
    fig.savefig(os.path.join(FM_DIR, 'fm_Vout_vs_fFM.png'), dpi=300)
    plt.close(fig)

# 3. 復調器出力電圧Voutの変調器入力電圧Vs依存性
def plot_fm_Vout_vs_Vs():
    csv_path = os.path.join(FM_DIR, '変復調特性（復調器出力電圧Voutの変調器入力電圧Vs依存性）.csv')
    df = pd.read_csv(csv_path, sep='\t')
    
    fig, ax = plt.subplots(figsize=(6, 4.5))
    ax.plot(df['信号波の電圧 [mV]'], df['出力電圧 [mV]'], marker='o', color=LINE_COLOR, markerfacecolor=MARKER_COLOR, markersize=6, linewidth=1.5)
    ax.axvline(300.0, color='red', linestyle=':', alpha=0.8, label='線形動作限界 (300 mV)')
    ax.set_title('復調出力電圧 $V_{out}$ の変調器入力電圧 $V_s$ 依存性', fontsize=12, pad=10, weight='bold')
    ax.set_xlabel('信号波の電圧 $V_s$ [mV]', fontsize=11)
    ax.set_ylabel('復調器出力電圧 $V_{out}$ [mV]', fontsize=11)
    ax.set_xlim(left=0)
    ax.set_ylim(bottom=0)
    ax.legend(fontsize=9.5)
    ax.grid(True, which='both', linestyle=GRID_STYLE, alpha=GRID_ALPHA)
    fig.tight_layout()
    fig.savefig(os.path.join(FM_DIR, 'fm_Vout_vs_Vs.png'), dpi=300)
    plt.close(fig)

# 4. 復調器出力電圧Voutの変調器入力周波数fs依存性
def plot_fm_Vout_vs_fs():
    csv_path = os.path.join(FM_DIR, '変復調特性（復調器出力電圧Voutの変調器入力周波数fs依存性）.csv')
    df = pd.read_csv(csv_path, sep='\t')
    
    fig, ax = plt.subplots(figsize=(6, 4.5))
    ax.plot(df['信号波の周波数 [Hz]'], df['出力電圧 [mV]'], marker='o', color=LINE_COLOR, markerfacecolor=MARKER_COLOR, markersize=5, linewidth=1.5)
    ax.set_title('復調出力電圧 $V_{out}$ の入力周波数 $f_s$ 依存性 (両対数)', fontsize=12, pad=10, weight='bold')
    ax.set_xlabel('周波数 $f_s$ [Hz] (対数軸)', fontsize=11)
    ax.set_ylabel('出力電圧 $V_{out}$ [mV] (対数軸)', fontsize=11)
    ax.set_xscale('log')
    ax.set_yscale('log')
    ax.grid(True, which="both", linestyle=GRID_STYLE, alpha=GRID_ALPHA)
    fig.tight_layout()
    fig.savefig(os.path.join(FM_DIR, 'fm_Vout_vs_fs.png'), dpi=300)
    plt.close(fig)

if __name__ == '__main__':
    print("Generating AM graphs...")
    plot_am_m_vs_Vs()
    plot_am_m_vs_fs()
    plot_am_Vout_vs_Vs()
    plot_am_Vout_vs_fs()
    
    print("Generating FM graphs...")
    plot_fm_fFM_vs_VC()
    plot_fm_Vout_vs_fFM()
    plot_fm_Vout_vs_Vs()
    plot_fm_Vout_vs_fs()
    
    print("All graphs successfully generated!")
