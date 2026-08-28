"""服部実験の FFT CSV からレポート用の Excel 風グラフを作る。"""

from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw, ImageFont

ROOT = next(Path(__file__).parent.parent.glob("*1_hattori"))
DATA = ROOT / "deta"
OUT = ROOT / "figures"
FS = 48_000
OUT.mkdir(exist_ok=True)
FONT_PATH = "/System/Library/Fonts/ヒラギノ角ゴシック W4.ttc"


def font(size):
    return ImageFont.truetype(FONT_PATH, size)


def read_spectrum(path: Path) -> np.ndarray:
    values = []
    raw = path.read_bytes()
    for encoding in ("utf-8", "cp932", "latin-1"):
        try:
            text = raw.decode(encoding)
            break
        except UnicodeDecodeError:
            continue
    for line in text.splitlines():
        nums = []
        for field in line.strip().split(","):
            try:
                nums.append(float(field))
            except ValueError:
                pass
        if nums:
            values.append(nums[-1])
    return np.asarray(values, dtype=float)


def spectrum(folder: str, index: int, n_fft: int):
    values = read_spectrum(DATA / folder / f"data{index:03d}.csv")
    return np.arange(values.size) * FS / n_fft, values


def draw_chart(filename, series, x_max=6000, width=1200, height=700):
    image = Image.new("RGB", (width, height), "white")
    draw = ImageDraw.Draw(image)
    left, top, right, bottom = 155, 80, width - 45, height - 95
    draw.rectangle((left, top, right, bottom), outline="#666666", width=2)
    max_y = max(float(np.max(values)) for _, values, _, _ in series) or 1.0
    max_y *= 1.08
    for ytick in np.linspace(0, max_y, 6):
        y = bottom - (ytick / max_y) * (bottom - top)
        draw.line((left, y, right, y), fill="#d9d9d9", width=1)
        draw.text((55, y - 10), f"{ytick:.2g}", fill="#555555", font=font(17))
    ylabel = Image.new("RGBA", (220, 34), (255, 255, 255, 0))
    ylabel_draw = ImageDraw.Draw(ylabel)
    ylabel_draw.text((0, 0), "振幅スペクトル", fill="#222222", font=font(20))
    ylabel = ylabel.rotate(90, expand=True)
    image.paste(ylabel, (8, (height - ylabel.height) // 2), ylabel)
    for xtick in np.linspace(0, x_max, 7):
        x = left + (xtick / x_max) * (right - left)
        draw.line((x, top, x, bottom), fill="#eeeeee", width=1)
        draw.text((x - 20, bottom + 12), f"{xtick:.0f}", fill="#555555", font=font(17))
    for freq, values, label, color in series:
        points = []
        for xval, yval in zip(freq, values):
            if xval > x_max:
                continue
            x = left + (xval / x_max) * (right - left)
            y = bottom - (float(yval) / max_y) * (bottom - top)
            points.append((x, y))
        if len(points) > 1:
            draw.line(points, fill=color, width=3)
        for x, y in points:
            draw.ellipse((x - 4, y - 4, x + 4, y + 4), fill=color, outline="white", width=1)
    legend_x = right - 330
    for idx, (_, _, label, color) in enumerate(series):
        y = top + 18 + idx * 32
        draw.line((legend_x, y + 10, legend_x + 35, y + 10), fill=color, width=3)
        draw.text((legend_x + 45, y), label, fill="#333333", font=font(17))
    draw.text(((left + right) // 2 - 60, height - 48), "周波数 [Hz]", fill="#222222", font=font(20))
    image.save(OUT / filename)


draw_chart("sine_500Hz.png", [
    (*spectrum("単色音声信号のフーリエ変換_正弦波", 16, 1024), "data016", "#4472c4")])
draw_chart("sine_1000Hz.png", [
    (*spectrum("単色音声信号のフーリエ変換_正弦波", 33, 1024), "data033", "#4472c4")])
draw_chart("square_500Hz.png", [
    (*spectrum("単色音声信号のフーリエ変換_矩形波", 28, 1024), "data028", "#4472c4")])
draw_chart("square_1000Hz.png", [
    (*spectrum("単色音声信号のフーリエ変換_矩形波", 33, 1024), "data033", "#4472c4")])
draw_chart("sample_count_1024.png", [
    (*spectrum("単色音声信号のフーリエ変換_矩形波", 28, 1024), "1024点", "#4472c4")])
draw_chart("sample_count_256.png", [
    (*spectrum("500hz波形,48000Hz,256point", 7, 256), "256点", "#4472c4")])
draw_chart("sample_count_64.png", [
    (*spectrum("500hz波形,48000Hz,64point", 14, 64), "64点", "#4472c4")])
draw_chart("pitch_shift_minus10.png", [
    (*spectrum("フーリエ変換による周波数解析1 -10", 9, 1024), "pitch_shift=-10", "#4472c4")])
draw_chart("pitch_shift_minus20.png", [
    (*spectrum("フーリエ変換による周波数解析1 -20", 3, 1024), "pitch_shift=-20", "#4472c4")])
for vowel, index in [("あ", 14), ("い", 20), ("う", 24), ("え", 28), ("お", 33)]:
    draw_chart(f"vowel_{vowel}.png", [
        (*spectrum("フーリエ変換による周波数解析2", index, 1024), vowel, "#4472c4")])

print(f"generated {len(list(OUT.glob('*.png')))} figures in {OUT}")
