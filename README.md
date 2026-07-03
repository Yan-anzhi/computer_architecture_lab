# computer_architecture_lab

## Course Overview

This repository contains laboratory assignments for the Computer Architecture course.
The experiments are implemented on the Sipeed Tang Nano 20K FPGA development board using the Gowin FPGA toolchain.

---

## Authors

* Liang Xuan
* Xiao Jiateng
* Yan Qinyuan

---

## Hardware Platform

* Sipeed Tang Nano 20K FPGA Development Board
* Gowin FPGA Designer and Gowin Programmer
* MounRiver Studio Community
* HDMI monitor
* TF card
* Joystick controller and Joystick to DIP convert board
* USB serial assistant

---

## Repository Structure

```text
computer_architecture_lab/
├── lab0_led/       Lab 0 environment setup and official LED demo
├── lab1/           Lab 1 Verilog LED blinking experiment
├── lab2/           Lab 2 NES emulator on FPGA
│   ├── README.md
│   ├── source_analysis.md
│   ├── notes/
│   ├── screenshots/
│   └── videos/
├── lab3/           Lab 3 SparrowRV RISC-V processor experiment
│   ├── SparrowRV/
│   └── result_pics/
├── .gitignore
└── README.md
```

---

# Lab 0 - Environment Setup & Basic FPGA Project

## Objectives

Lab 0 focuses on environment setup and basic FPGA workflow understanding, including:

* Installing and configuring Gowin FPGA tools
* Creating and managing a GitHub repository
* Running the official LED demo project
* Understanding FPGA project structure, including Verilog, CST, and SDC files
* Performing bitstream generation and FPGA programming

## Results

The official LED example was successfully downloaded, programmed, and executed on the Tang Nano 20K FPGA board. The LED running pattern confirmed that the hardware, USB driver, Gowin Programmer, and basic FPGA toolchain were working correctly.

---

# Lab 1 - LED Blinking Circuit

## Objectives

Lab 1 implements a simple LED blinking circuit based on clock frequency division.

## Principle

A counter driven by the system clock is used to divide the frequency. When the counter reaches a predefined threshold, the LED output toggles.

## Functionality

* Input: system clock (`clk`)
* Output: onboard LED (`led`)
* Behavior: LED toggles periodically

## Implementation

* A synchronous counter is used for clock division
* Sequential logic is implemented using `always @(posedge clk)`
* CST and SDC files are used for pin and timing constraints
* The design is synthesized, placed, routed, and programmed to the FPGA using Gowin tools

---

# Lab 2 - NES Emulator on FPGA

## Objectives

Lab 2 deploys and tests an existing NES emulator project on the Tang Nano 20K FPGA board. The experiment focuses on understanding the complete FPGA-based emulator system, including ROM loading, HDMI video output, joystick input, TF card storage, and source code structure.

## External Project

The experiment uses the NESTang project from the Sipeed TangNano-20K-example repository.

Main files used:

```text
nes.fs      Prebuilt FPGA bitstream
nes.gprj    Gowin project file
src/        NES emulator source code
tools/      Utility scripts such as nes2img.py
```

## Implementation Summary

The NESTang project was cloned using Git. The prebuilt bitstream `nes.fs` was programmed into the external Flash of the Tang Nano 20K using Gowin Programmer. A legal homebrew NES ROM, `Spacegulls-1.1.nes`, was used locally for hardware verification. The ROM was packed into `games.img` using `nes2img.py`, and the generated image was written to the TF card using Balena Etcher.

The FPGA board was then connected to an HDMI monitor and a joystick through a Joystick to DIP convert board. After power-on, the HDMI monitor displayed the NESTang game menu. The joystick input successfully started the game, and the Spacegulls gameplay screen was displayed.

## Result Files

```text
lab2/README.md
lab2/source_analysis.md
lab2/notes/commands_log.md
lab2/screenshots/
lab2/videos/lab2_nestang_demo.mp4
```

## Important Note

For copyright considerations, `.nes` ROM files and the generated `games.img` file are not uploaded to this repository. They were used only for local hardware verification.

---

# Lab 3 - SparrowRV RISC-V Processor Experiment

## Objectives

Lab 3 deploys and verifies the SparrowRV RISC-V processor on the Tang Nano 20K FPGA board. The experiment includes software compilation, instruction memory initialization, FPGA synthesis and implementation, UART output verification, and source-level analysis of the SparrowRV processor structure.

## External Project

The experiment uses the SparrowRV project from Gitee. The selected version provides BSP software, RTL source files, Gowin FPGA project files, testbench tools, and reference documents.

Main files used:

```text
rtl/                                  SparrowRV processor and SoC RTL source files
bsp/bsp_app/app/main.c                 Hello World APP source code
bsp/bsp_app/SparrowRV_APP.wvproj       MounRiver Studio APP project
fpga/gowin_tang_nano_20k/              Gowin FPGA project for Tang Nano 20K
tb/inst.txt                            Instruction memory initialization file
```

## Implementation Summary

The SparrowRV APP project was compiled in MounRiver Studio to generate `SparrowRV_APP.bin`. The binary file was then converted into `inst.txt`, which is loaded into instruction memory through Verilog `$readmemh` during Gowin synthesis.

The Gowin project for Tang Nano 20K was synthesized, placed, routed, and programmed to the FPGA. During implementation, an FPIOA port constraint issue was fixed by matching the RTL port configuration with the CST pin constraints. After downloading the generated `.fs` file, the serial assistant successfully received repeated Hello World output and system information from the SparrowRV processor.

## Result Files

```text
lab3/SparrowRV/rtl/
lab3/SparrowRV/bsp/bsp_app/app/main.c
lab3/SparrowRV/bsp/bsp_app/SparrowRV_APP.wvproj
lab3/SparrowRV/fpga/gowin_tang_nano_20k/
lab3/SparrowRV/tb/inst.txt
lab3/result_pics/
```

## Verification Result

The UART output confirmed that the APP program was successfully initialized into IRAM and executed by the SparrowRV processor on FPGA. The output included Hello World messages, system frequency, IRAM size, SRAM size, and Vendor ID information.

---

## Notes

This repository is used for course laboratory documentation and source management. Large generated files, temporary build outputs, ROM images, FPGA intermediate files, and local cache files are excluded by `.gitignore`.
