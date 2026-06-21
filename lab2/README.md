# Lab 2 - NES Emulator on FPGA

## 1. Objective

This lab deploys and tests an existing NES emulator project on the Sipeed Tang Nano 20K FPGA board. The main purpose is to understand how an FPGA-based emulator integrates CPU execution, video output, game ROM loading, TF card storage, HDMI display, and joystick input.

## 2. External Project Used

External project:

```text
Sipeed TangNano-20K-example / nestang
```

Local project path:

```text
D:\Gowin\computer_arch\TangNano-20K-example\nestang
```

The project contains:

```text
nes.fs      Prebuilt FPGA bitstream
nes.gprj    Gowin project file
src/        Verilog/SystemVerilog source code
tools/      Utility scripts such as nes2img.py
```

## 3. Hardware and Software

Hardware used:

```text
Sipeed Tang Nano 20K FPGA board
HDMI monitor
HDMI cable
TF card
TF card reader
Joystick controller
Joystick to DIP convert board
USB-C cable
```

Software used:

```text
Gowin FPGA Designer
Gowin Programmer
Python
Balena Etcher
Git
```

## 4. Procedure Summary

### 4.1 Clone the NES Emulator Project

The NES emulator project was cloned using Git. The `nestang` directory contains the prebuilt bitstream file `nes.fs`, Gowin project file `nes.gprj`, source code, and utility scripts.

Evidence:

```text
screenshots/01_clone_nestang_success.png
```

### 4.2 Program the FPGA Bitstream

The Tang Nano 20K board was detected by Gowin Programmer as:

```text
Series: GW2AR
Device: GW2AR-18C
```

The programming mode was set as:

```text
Access Mode: External Flash Mode
Operation: exFlash Erase, Program, Verify
Programming file: nes.fs
```

The output showed:

```text
SPI program and verify success!
Finished.
```

Evidence:

```text
screenshots/02_programmer_detect_gw2ar18c.png
screenshots/03_select_nes_fs.png
screenshots/04_flash_program_success.png
```

### 4.3 Generate the Game Image

A legal homebrew NES ROM, `Spacegulls-1.1.nes`, was used only for local hardware verification. The ROM file was packed into `games.img` using `nes2img.py`.

Command used:

```powershell
python nes2img.py -o games.img Spacegulls-1.1.nes
```

The output showed:

```text
Number of menu pages: 1
Done.
```

The ROM file and generated `games.img` are not uploaded to the GitHub repository.

Evidence:

```text
screenshots/05_generate_games_img.png
screenshots/06_games_img_file_created.png
```

### 4.4 Write games.img to TF Card

The generated `games.img` was written to the TF card using Balena Etcher.

Evidence:

```text
screenshots/07_etcher_select_tf_card.png
screenshots/08_etcher_flash_success.png
```

### 4.5 Hardware Connection and Testing

The TF card was inserted into the Tang Nano 20K board. The board was connected to an HDMI monitor, and the joystick was connected through a Joystick to DIP convert board.

After power-on, the HDMI monitor displayed the NESTang menu. The menu showed `Spacegulls-1.1`. After pressing the joystick button, the emulator entered the Spacegulls title screen and then the gameplay screen.

Evidence:

```text
screenshots/09_hdmi_menu_spacegulls.jpg
screenshots/10_game_title_after_button1.jpg
screenshots/11_hardware_connection_with_joystick.jpg
screenshots/12_joystick_controller.jpg
screenshots/13_gameplay_spacegulls.jpg
videos/lab2_nestang_demo.mp4
```

## 5. Source Code Analysis

The source code analysis is provided in:

```text
source_analysis.md
```

This file includes:

```text
Overall NES emulator architecture
CPU, PPU, and APU cooperation
HDMI, joystick, and TF card interface analysis
Game ROM loading and execution flow
Testing and evaluation
```

## 6. Test Result

The NES emulator was successfully deployed on the Tang Nano 20K FPGA board. The FPGA loaded the game image from the TF card, displayed the menu through HDMI, accepted joystick input, and successfully entered the Spacegulls game screen.

## 7. Notes

For copyright considerations, the `.nes` ROM file and the generated `games.img` file were used only for local verification and were not uploaded to the repository.
