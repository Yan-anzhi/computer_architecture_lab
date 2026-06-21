# Lab 2 Source Code Analysis and Evaluation

## 1. Overall Architecture of the NES Emulator

The NESTang project implements an NES emulator on the Tang Nano 20K FPGA board. Different from a software emulator running on a CPU, this project describes the NES hardware behavior using Verilog/SystemVerilog modules and maps the design onto FPGA logic resources.

The whole system can be divided into three layers:

1. **Board-level integration layer**
   This layer connects the NES emulator core to the Tang Nano 20K board peripherals, such as HDMI output, TF card interface, joystick input, clock, reset, and external memory.

2. **NES core layer**
   This layer contains the main NES hardware modules, including CPU, PPU, APU, memory controller, ROM/RAM access logic, and controller input logic.

3. **External storage and I/O layer**
   This layer handles game ROM loading from the TF card, user input from the joystick, and video output to the HDMI monitor.

At the board level, `nes_tang20k.v` is the top-level module for the Tang Nano 20K platform. It connects the FPGA pins to external devices and adapts the NES emulator core to the actual hardware board.

At the NES core level, `nes.v` integrates CPU, PPU, APU, memory control, ROM access, and controller input. The CPU executes the game program, the PPU generates graphics, and the APU handles audio-related logic. These modules cooperate through memory-mapped interfaces, similar to the organization of the original NES console.

Therefore, the project is not only a CPU implementation. It is a complete FPGA-based system that integrates computation, video generation, storage access, input control, and display output.

---

## 2. Source File Mapping

The following table summarizes the main source files and their roles in the NESTang system.

| Function                | Related Source Files                      | Role in the System                                                                                                        |
| ----------------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Board-level integration | `nes_tang20k.v`                           | Top-level module for Tang Nano 20K. It connects HDMI, TF card, joystick, clock, reset, and memory-related pins.           |
| NES core integration    | `nes.v`                                   | Integrates the CPU, PPU, APU, memory controller, ROM access, and input logic.                                             |
| CPU execution           | `cpu.v`                                   | Implements the 6502-compatible CPU logic used by NES games. It fetches and executes instructions from the loaded ROM.     |
| Video generation        | `ppu.v`                                   | Implements the Picture Processing Unit. It generates background, sprite, palette, and pixel data for each video frame.    |
| Audio logic             | `apu.v`                                   | Implements the Audio Processing Unit logic and handles NES audio-related registers and sound behavior.                    |
| HDMI output             | `nes2hdmi.sv`, `hdmi2/`                   | Converts NES video signals into HDMI-compatible video output for modern displays.                                         |
| Joystick input          | `dualshock_controller.v`                  | Reads external controller signals through the Joystick to DIP convert board and maps them to NES-compatible input states. |
| TF card reading         | `sd_loader.v`, `sd_reader.sv`             | Reads menu data and game ROM data from the TF card.                                                                       |
| Game ROM loading        | `game_loader.v`                           | Loads the selected game ROM into the emulator memory system after the user chooses a game from the menu.                  |
| Memory management       | `memory_controller.v`, `mmu.v`, `sdram.v` | Handles memory mapping, ROM/RAM access, and external memory control.                                                      |

This file mapping shows that the emulator is organized as a modular hardware system. Each module is responsible for one part of the NES hardware or one FPGA peripheral interface.

---

## 3. CPU, PPU, and APU Cooperation

The original NES console contains several key hardware components, mainly the CPU, PPU, APU, memory, game cartridge, and controller interface. The NESTang project follows this hardware structure and implements the main components as FPGA logic modules.

The CPU module, mainly implemented in `cpu.v`, is responsible for executing the 6502-compatible instructions used by NES games. It fetches instructions from the loaded ROM, updates internal registers, performs arithmetic and logic operations, handles memory access, and controls the game logic. The CPU does not directly draw the screen. Instead, it writes control data to video-related registers and memory areas.

The PPU module, mainly implemented in `ppu.v`, is responsible for generating the video output of the NES. It reads graphical information such as background data, sprite data, name table data, and palette data, then produces pixel-level video output. The PPU works in parallel with the CPU. While the CPU executes game logic, the PPU continuously generates video frames according to the current graphics memory state.

The APU module, mainly implemented in `apu.v`, handles the audio part of the NES. It responds to CPU writes to audio registers and generates sound-related signals. In this experiment, the main verification focused on HDMI video output and joystick input, so the audio output was not deeply tested. However, the existence of the APU module shows that the project attempts to reproduce not only CPU instruction execution but also the audio subsystem of the original NES.

The CPU, PPU, and APU cooperate through memory-mapped access. The CPU controls the game flow and writes data to PPU and APU registers. The PPU reads graphics data and generates the display output. The APU handles audio behavior according to CPU-controlled registers. This design is close to the original hardware organization of the NES, where different hardware modules work in parallel instead of being simulated sequentially by software.

---

## 4. FPGA Interfaces with HDMI, Joystick, and TF Card

### 4.1 HDMI Interface

The HDMI display path is an important part of this experiment. The NES PPU generates video data in a format close to the original NES video timing, but a modern monitor needs HDMI-compatible signals. Therefore, the project uses HDMI-related logic such as `nes2hdmi.sv` and the `hdmi2` modules to convert the NES video output into signals that can be displayed on an HDMI monitor.

The basic video flow is:

```text
PPU video output
        ↓
NES video signal conversion
        ↓
nes2hdmi / HDMI-related logic
        ↓
HDMI monitor
```

In the experiment, the HDMI monitor successfully displayed the NESTang menu, the Spacegulls title screen, and the gameplay screen. This proves that the video output path from PPU to HDMI worked correctly.

### 4.2 Joystick Interface

The joystick input is handled by modules such as `dualshock_controller.v`. The controller is connected to the Tang Nano 20K board through a Joystick to DIP convert board. The FPGA communicates with the joystick using several digital signals, including clock, MOSI, MISO, chip select, power, and ground.

The joystick interface flow is:

```text
Joystick button press
        ↓
Joystick to DIP convert board
        ↓
FPGA input pins
        ↓
dualshock_controller.v
        ↓
NES-compatible controller state
        ↓
CPU reads controller input
```

In this experiment, pressing button 1 on the joystick successfully entered the Spacegulls title screen and then the gameplay screen. This shows that the input interface was correctly connected and recognized by the emulator.

### 4.3 TF Card Interface

The TF card is used to store the generated game image file `games.img`. On the PC side, the `.nes` ROM file is packed into `games.img` using `nes2img.py`. Then `games.img` is written to the TF card using Balena Etcher.

On the FPGA side, the SD-card-related modules, such as `sd_loader.v` and `sd_reader.sv`, read the menu information and ROM data from the TF card. The menu is shown on the HDMI display, and the selected game ROM is loaded into the emulator memory system.

The TF card data path is:

```text
games.img on TF card
        ↓
sd_reader / sd_loader
        ↓
menu and ROM information
        ↓
game_loader
        ↓
NES memory system
```

This process allows the FPGA to load different NES games without rebuilding the FPGA bitstream.

---

## 5. Game ROM Loading and Execution Flow

The ROM loading process contains both a PC-side preparation stage and an FPGA-side execution stage.

### 5.1 PC-side ROM Preparation

First, a legal homebrew NES ROM file, `Spacegulls-1.1.nes`, was prepared locally. Then the script `nes2img.py` was used to pack the ROM into a TF-card image.

The command used was:

```powershell
python nes2img.py -o games.img Spacegulls-1.1.nes
```

The output showed:

```text
Number of menu pages: 1
Done.
```

This means that the ROM was successfully packed into `games.img`. The generated image was then written to the TF card using Balena Etcher.

### 5.2 FPGA-side ROM Loading

After `nes.fs` was programmed into the external Flash of the Tang Nano 20K board, the FPGA became an NES emulator after power-on. The TF card was inserted into the board, and the FPGA read the game menu information from `games.img`.

The HDMI display first showed the NESTang menu. The menu contained the game name `Spacegulls-1.1`. After the user selected the game using the joystick, the game loader loaded the corresponding ROM data into the emulator memory system.

### 5.3 Game Execution

After the selected ROM was loaded, the CPU began executing the game program. During execution, the CPU fetched instructions, updated game states, read controller input, and controlled the PPU and APU through memory-mapped registers.

The PPU generated video frames based on the current graphics state. The HDMI logic converted the video output to a modern display format. The joystick module continuously provided user input to the game.

The complete flow is:

```text
Spacegulls-1.1.nes
        ↓ packed by nes2img.py
games.img
        ↓ written to TF card by Balena Etcher
TF card
        ↓ read by sd_loader / sd_reader
NESTang game menu on HDMI
        ↓ game selected by joystick
game_loader loads selected ROM
        ↓
CPU starts executing game program
        ↓
CPU communicates with PPU, APU, and controller interface
        ↓
PPU generates video frames
        ↓
nes2hdmi outputs video to HDMI monitor
```

In the experiment, this complete flow was verified successfully. The HDMI monitor showed the game menu, the Spacegulls title screen, and the gameplay screen.

---

## 6. Testing and Evaluation

### 6.1 Test Environment

The experiment was tested using the following hardware and software:

```text
Hardware:
- Sipeed Tang Nano 20K FPGA board
- HDMI monitor
- HDMI cable
- TF card
- TF card reader
- Joystick controller
- Joystick to DIP convert board
- USB-C cable

Software:
- Gowin Programmer
- Python
- nes2img.py
- Balena Etcher
- Git
```

### 6.2 Test Results

The NESTang bitstream `nes.fs` was successfully programmed into the external Flash of the Tang Nano 20K board. Gowin Programmer detected the FPGA as `GW2AR-18C`, and the output log showed:

```text
SPI program and verify success!
Finished.
```

The `Spacegulls-1.1.nes` ROM was packed into `games.img` using `nes2img.py`. The generated `games.img` was written to the TF card using Balena Etcher. After inserting the TF card and connecting the HDMI monitor, the NESTang menu was displayed correctly. The menu showed `Spacegulls-1.1`, proving that the FPGA successfully read the game image from the TF card.

After connecting the joystick through the Joystick to DIP convert board, pressing button 1 entered the Spacegulls title screen and then the gameplay screen. This verified the complete path of ROM loading, HDMI display output, and joystick input.

### 6.3 Observed Performance

During the test, the HDMI output was stable enough for demonstration. No serious startup failure, ROM loading failure, or obvious screen tearing was observed in the captured screenshots and demo video. The game menu, title screen, and gameplay screen were displayed clearly.

The joystick input was successfully recognized for starting the game. This indicates that the controller interface was working correctly for the basic test.

### 6.4 Problems Encountered

The main problems encountered during the experiment were related to environment setup and file preparation rather than FPGA runtime behavior:

1. At first, the difference between `nes.fs`, `.nes` ROM files, and `games.img` was unclear.

   * `nes.fs` is the FPGA bitstream.
   * `.nes` is the game ROM file.
   * `games.img` is the TF-card image generated from the ROM.

2. Balena Etcher warned that `games.img` did not contain a partition table.

   * This was normal because `games.img` is not a normal bootable operating system image. It is a raw image read by the NESTang FPGA logic.

3. Windows could not directly recognize the written TF card format.

   * This was also normal. The TF card was written for the FPGA loader, not for Windows file browsing.

4. The test used only one homebrew NES ROM.

   * Therefore, compatibility with other games and different mappers was not fully evaluated.

### 6.5 Future Improvements

Future improvements could include:

1. Testing more legal homebrew NES ROMs to evaluate compatibility.
2. Recording exact joystick key mapping and checking all controller buttons.
3. Testing audio output and verifying whether the APU path works correctly.
4. Running longer stability tests to check whether video output remains stable.
5. Comparing resource utilization and timing reports after full Gowin compilation.
6. Investigating support for different NES mappers and larger ROMs.
7. Adding a clearer user guide for preparing ROMs, generating `games.img`, and writing the TF card.

---

## 7. Conclusion

This Lab 2 experiment successfully deployed and tested an NES emulator on the Tang Nano 20K FPGA board. The prebuilt NESTang bitstream was programmed into the external Flash, and a legal homebrew ROM was packed into a TF-card image. After connecting the HDMI monitor, TF card, joystick, and Joystick to DIP convert board, the FPGA successfully displayed the NESTang menu, loaded the selected game, and entered the gameplay screen.

Through source code analysis, the project was understood as a complete FPGA-based emulator system rather than a simple demo. The CPU executes game instructions, the PPU generates video frames, the APU handles audio-related logic, the TF card modules load ROM data, the joystick module provides input, and the HDMI modules output the generated video to a modern display.

The experiment demonstrates how an FPGA can be used to reproduce a classic game console architecture at the hardware level and shows the interaction between processor logic, memory, storage, display, and input peripherals.
