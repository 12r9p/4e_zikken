# Spectrogram App

This application processes Fourier-transform data from CSV files and displays/saves a rendered spectrogram.

## Commands

- **Run GUI**:
  ```bash
  cd /Users/takumi/Documents/4e_zikken/spectrogram_app && ./scripts/run_app.sh
  ```

- **Build App Bundle**:
  ```bash
  cd /Users/takumi/Documents/4e_zikken/spectrogram_app && ./scripts/build_app.sh
  ```

- **Smoke Test**:
  ```bash
  cd /Users/takumi/Documents/4e_zikken/spectrogram_app && ./scripts/verify_app.sh
  ```

- **CLI Headless Execution**:
  ```bash
  $(swift build --show-bin-path)/SpectrogramApp <csv_dir> <output_png> [sampling_rate] [sample_count] [min_freq] [max_freq]
  ```

## Technical Details

- **Frequency Formula**:
  `frequency_hz = bin_index * sampling_rate_hz / sample_count`
  - Sliders and text fields in the GUI sidebar allow setting custom Min/Max Frequency ranges.
  - The rendered output dynamically maps rows between the chosen bounds, using:
    `bin = round(frequency * sample_count / sampling_rate)` clamped to valid bins.

- **Embedded Metadata**:
  - Generated images (both GUI preview and saved/headless PNGs) embed metadata text at the top:
    `Sampling Rate: <SR> Hz   Sample Count: <SC>   Frequency Range: <Min>-<Max> Hz`

- **Data Folder Requirements**:
  The selected folder must contain `data*.csv` files, with each file having one numeric magnitude column.
