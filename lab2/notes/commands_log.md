# Lab 2 Commands Log

## 1. Clone NES Emulator Project

```powershell
cd D:\Gowin\computer_arch
git clone --depth 1 https://github.com/sipeed/TangNano-20K-example.git
cd D:\Gowin\computer_arch\TangNano-20K-example\nestang
dir
```

## 2. Generate games.img

```powershell
cd D:\Gowin\computer_arch\nes_roms
python nes2img.py -o games.img Spacegulls-1.1.nes
```

Output:

```text
Number of menu pages: 1
Done.
```

## 3. Write games.img to TF Card

Tool used:

```text
Balena Etcher
```

Input file:

```text
D:\Gowin\computer_arch\nes_roms\games.img
```

Result:

```text
Flash successfully completed.
```

## 4. FPGA Programming Settings

Tool used:

```text
Gowin Programmer
```

Device:

```text
GW2AR-18C
```

Programming mode:

```text
External Flash Mode
```

Operation:

```text
exFlash Erase, Program, Verify
```

Programming file:

```text
D:\Gowin\computer_arch\TangNano-20K-example\nestang\nes.fs
```

Successful output:

```text
SPI program and verify success!
Finished.
```
