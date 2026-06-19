# computer_architecture_lab

## Course Overview
This repository contains laboratory assignments for the Computer Architecture course.  
All experiments are implemented using Verilog HDL and developed on the Gowin FPGA platform.

---

## Authors
- Liang Xuan  
- Xiao Jiateng  
- Yan Qinyuan  

---

## Hardware Platform
- Sipeed Tang Nano 20K FPGA Development Board  
- Gowin FPGA Designer Toolchain  

---

# Lab 0 - Environment Setup & Basic FPGA Project

## Objectives
Lab 0 focuses on environment setup and basic FPGA workflow understanding, including:

- Installing and configuring Gowin FPGA tools
- Creating and managing a GitHub repository
- Running the official LED demo project
- Understanding FPGA project structure (Verilog / CST / SDC)
- Performing bitstream generation and FPGA programming

## Results
Successfully downloaded and executed the official LED example on the FPGA board, confirming correct hardware and toolchain setup.

---

# Lab 1 - LED Blinking Circuit

## Objectives
Lab 1 implements a simple LED blinking circuit based on clock frequency division.

## Principle
A counter driven by a 27 MHz system clock is used to divide the frequency.  
When the counter reaches a predefined threshold, the LED output toggles.

## Functionality
- Input: system clock (`clk`)
- Output: onboard LED (`led`)
- Behavior: LED toggles every 0.5 seconds

## Implementation
- A 26-bit synchronous counter is used for clock division
- Sequential logic implemented using `always @(posedge clk)`
- Timing constraints ensure correct clock interpretation by the FPGA toolchain

## Files
- Verilog source code (Lab0 / Lab1)
- `.cst` pin constraint files
- `.sdc` timing constraint files

---

# Lab 2

---

# Lab 3
