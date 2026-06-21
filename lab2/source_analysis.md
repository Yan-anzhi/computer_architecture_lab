# Lab 2 Source Code Analysis and Evaluation

## 1. Overall Architecture of the NES Emulator

The NESTang project implements an NES emulator on the Tang Nano 20K FPGA. The whole system can be divided into three layers: the FPGA board-level interface layer, the NES core layer, and the external storage/input/output layer.

At the board level, `nes_tang20k.v` is the top-level module for the Tang Nano 20K platform. It connects the FPGA pins to external devices, including HDMI display output, TF card storage, joystick input, clock/reset signals, and memory-related signals. This module is responsible for adapting the NES emulator core to the actual FPGA development board.

At the NES core level, `nes.v` integrates the main functional blocks of the emulator, including CPU, PPU, APU, memory controller, and input-related logic. The CPU executes the game program, the PPU generates video frames, and the APU handles audio-related logic. These modules cooperate through memory-mapped interfaces, similar to the organization of the original NES console.

The external storage and I/O layer includes modules for loading game ROMs from the TF card, reading joystick input, and outputting video through HDMI. Therefore, the emulator is not only a CPU implementation, but a complete hardware system that integrates computation, memory, display, storage, and input.

## 2. CPU, PPU, and APU Cooperation

The CPU module, mainly implemented in `cpu.v`, is responsible for executing the 6502-compatible instructions used by NES games. It fetches instructions from the loaded ROM, updates registers and memory, handles game logic, and communicates with other hardware modules through address-mapped registers.

The PPU module, mainly implemented in `ppu.v`, is responsible for generating the video output of the NES. It reads graphical data, palette information, background data, and sprite data, then produces pixel-level display signals. The video data is then sent to the HDMI-related modules for display on an external monitor.

The APU module, mainly implemented in `apu.v`, handles the audio part of the NES. Although the main verification in this experiment focused on HDMI video and joystick input, the existence of the APU module shows that the project attempts to reproduce not only the CPU execution behavior but also the audio subsystem of the original NES.

The CPU, PPU, and APU cooperate through memory-mapped access. The CPU controls the game flow and writes control data to the PPU and APU. The PPU continuously generates frames according to graphics memory and register states, while the APU generates sound data according to audio control registers. This design follows the idea of the original NES architecture, where different hardware modules work in parallel rather than being implemented as a pure software emulator.

## 3. FPGA Interfaces with HDMI, Joystick, and TF Card

The HDMI output is handled by video conversion and HDMI-related modules such as `nes2hdmi.sv` and the `hdmi2` folder. The NES PPU generates video information in a format close to the original NES display timing. The HDMI-related logic converts the generated pixel data and synchronization signals into a format that can be displayed by a modern HDMI monitor. In the experiment, the HDMI monitor successfully displayed the NESTang menu, the Spacegulls title screen, and the actual game scene, proving that the video output path worked correctly.

The joystick input is handled by modules such as `dualshock_controller.v`. The joystick is connected to the Tang Nano 20K through a Joystick to DIP convert board. The FPGA communicates with the controller through signals such as clock, MOSI, MISO, chip select, power, and ground. The controller state is then converted into NES-compatible input signals. In the experiment, pressing button 1 on the controller started the Spacegulls game, showing that the joystick interface was working.

The TF card is used to store the generated `games.img` image. The related modules include `sd_loader.v`, `sd_reader.sv`, and other SD-card control logic. The image file was generated from `Spacegulls-1.1.nes` using `nes2img.py` and written to the TF card using Balena Etcher. After power-on, the FPGA read the menu and ROM data from the TF card and displayed the game list on the HDMI monitor.

## 4. Game ROM Loading and Execution Flow

The ROM loading process starts on the PC side. First, the `.nes` ROM file is packed into `games.img` using `nes2img.py`. This script generates a menu image and stores the ROM data in a format that can be read by the FPGA system. Then, the generated `games.img` is written to the TF card using Balena Etcher.

On the FPGA side, after the NESTang bitstream `nes.fs` is programmed into the external Flash, the board becomes an NES emulator after power-on. The SD card loader reads the menu and ROM information from the TF card. The HDMI display shows the game list, and the user selects a game using the joystick. After a game is selected, the ROM data is loaded into the emulator memory system. The CPU then starts executing the game program, while the PPU generates the corresponding video output and the controller module provides user input to the game.

In this experiment, `Spacegulls-1.1.nes` was packed into `games.img`, written to the TF card, and successfully loaded by the FPGA. The HDMI monitor first displayed the NESTang menu, then entered the Spacegulls title screen after pressing the controller button, and finally showed the actual gameplay scene. This verifies the complete flow from ROM preparation to FPGA execution.

## 5. Testing and Evaluation

The experiment was tested using a Tang Nano 20K FPGA board, HDMI monitor, TF card, Joystick to DIP convert board, and a game controller. The NESTang bitstream was successfully programmed into the external Flash using Gowin Programmer. The output log showed that SPI programming and verification were successful.

The generated `games.img` was written to the TF card using Balena Etcher. After inserting the TF card and connecting the HDMI monitor, the NESTang game menu was displayed correctly. The menu showed `Spacegulls-1.1`, which means the FPGA successfully read the game image from the TF card. After connecting the joystick and pressing button 1, the emulator entered the Spacegulls title screen and then the gameplay scene.

During testing, no serious startup failure or ROM loading error occurred. The HDMI image was stable enough for demonstration. No obvious screen tearing was observed in the captured screenshots, but the video output could still be further evaluated using more games and longer running time. Since the experiment mainly focused on video output and controller input, audio output was not deeply tested. Future improvements could include testing more NES ROMs, checking the audio module output, comparing performance with different game mappers, and documenting the exact joystick key mapping.
