"""Create the Wien-bridge Bode scatter plot from the recorded CSV data."""

from __future__ import annotations

import csv
import math
from pathlib import Path


ASSET_DIR = Path(__file__).parent
SOURCE = next(ASSET_DIR.glob("*ボード線図*csv"))
OUTPUT = ASSET_DIR / "wien-bridge-bode.svg"

with SOURCE.open(encoding="utf-8") as file:
    rows = list(csv.DictReader(file, delimiter="\t"))

frequency = [float(row["周波数 [Hz]"]) for row in rows]
feedback = [float(row["帰還率β"]) for row in rows]
phase = [float(row["位相差 argβ [°]"]) for row in rows]

width, height = 920, 560
left, right, top, bottom = 110, 820, 38, 438
x_min, x_max = 90, 90000
beta_min, beta_max = 0, 0.35
phase_min, phase_max = -100, 100


def x(value: float) -> float:
    return left + (math.log10(value) - math.log10(x_min)) / (
        math.log10(x_max) - math.log10(x_min)
    ) * (right - left)


def y_beta(value: float) -> float:
    return bottom - (value - beta_min) / (beta_max - beta_min) * (bottom - top)


def y_phase(value: float) -> float:
    return bottom - (value - phase_min) / (phase_max - phase_min) * (bottom - top)


def text(x_pos: float, y_pos: float, value: str, anchor: str = "middle", klass: str = "") -> str:
    return f'<text class="{klass}" x="{x_pos:.1f}" y="{y_pos:.1f}" text-anchor="{anchor}">{value}</text>'


parts = [
    f'''<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">
<rect width="100%" height="100%" fill="white"/>
<style>
  text {{ font-family: Arial, 'Hiragino Sans', sans-serif; fill: #3f3f3f; font-size: 14px; }}
  .small {{ font-size: 12px; }}
  .axis-title {{ font-size: 16px; }}
  .beta {{ fill: #176a8d; }}
  .phase {{ fill: #e56f2e; }}
</style>
<rect x="{left}" y="{top}" width="{right-left}" height="{bottom-top}" fill="none" stroke="#a8a8a8" stroke-width="1"/>
'''
]

for value in (0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35):
    y_pos = y_beta(value)
    parts.append(f'<line x1="{left}" y1="{y_pos:.1f}" x2="{right}" y2="{y_pos:.1f}" stroke="#d0d0d0" stroke-width="1"/>')
    parts.append(text(left - 14, y_pos + 5, f"{value:.3f}", "end"))

for value in (-100, -80, -60, -40, -20, 0, 20, 40, 60, 80, 100):
    parts.append(text(right + 14, y_phase(value) + 5, str(value), "start"))

for value, label in ((90, "90"), (900, "900"), (9000, "9000"), (90000, "90000")):
    x_pos = x(value)
    parts.append(f'<line x1="{x_pos:.1f}" y1="{top}" x2="{x_pos:.1f}" y2="{bottom}" stroke="#d0d0d0" stroke-width="1"/>')
    parts.append(text(x_pos, bottom + 27, label))

mark_x = x(3400)
parts.extend([
    f'<line x1="{mark_x:.1f}" y1="{top}" x2="{mark_x:.1f}" y2="{bottom}" stroke="#6a6a6a" stroke-width="1.5" stroke-dasharray="6 4"/>',
    f'<rect x="{mark_x - 29:.1f}" y="{top + 8}" width="58" height="20" fill="white" opacity="0.92"/>',
    text(mark_x, top + 23, "3.4 kHz", klass="small"),
])

for freq, value in zip(frequency, feedback):
    parts.append(f'<circle cx="{x(freq):.1f}" cy="{y_beta(value):.1f}" r="4.7" fill="#176a8d"/>')

for freq, value in zip(frequency, phase):
    parts.append(f'<circle cx="{x(freq):.1f}" cy="{y_phase(value):.1f}" r="4.7" fill="#e56f2e"/>')

parts.extend([
    f'<text class="axis-title beta" x="30" y="{(top+bottom)/2:.1f}" text-anchor="middle" transform="rotate(-90 30 {(top+bottom)/2:.1f})">帰還率 β</text>',
    f'<text class="axis-title phase" x="{width-24}" y="{(top+bottom)/2:.1f}" text-anchor="middle" transform="rotate(-90 {width-24} {(top+bottom)/2:.1f})">位相差 argβ [°]</text>',
    text((left + right) / 2, bottom + 62, "周波数 f [Hz]（対数目盛）", klass="axis-title"),
    f'<circle cx="{width/2-74:.1f}" cy="{height-35}" r="5" fill="#176a8d"/>',
    text(width/2-63, height-30, "帰還率 β", "start"),
    f'<circle cx="{width/2+42:.1f}" cy="{height-35}" r="5" fill="#e56f2e"/>',
    text(width/2+53, height-30, "位相差 argβ [°]", "start"),
    "</svg>",
])

OUTPUT.write_text("\n".join(parts), encoding="utf-8")
