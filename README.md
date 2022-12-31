# SUSTech_CS207-DD_2022f_Project-a-real-car

### Project of Digital Logic Design: a "real car"

### Contributors：

[**@OctCarp**](https://github.com/OctCarp) : Top module, global control, manual mode, 7-seg LED display, VGA display 

[**@Guojianyang2002**](https://github.com/Guojianyang2002) : Manual mode, semi-auto mode, auto mode

### Construction:

[**sources**](sources/) : Source code in Verilog

[**#other_docs**](#other_docs/) : Other related documents, including original demo, and the car simulation program in .zip

[**report**](report/) : Our project report (In Chinese)

[**DL_2022F_project_introduction**](DL_2022F_project_introduction.pdf) : Requirements Document

### How to Use It:

 Personal computer, FPGA: **EGO1**, VGA displayer (optional)

1. Use EDA (Xilinx Vivado is recommended), open `sources/`, then add the `cons.xdc` as **constrains**, others as **design sources**.
2. In EDA, run synthesis, implementation, then generate bitstream, and **program EGO1**.
3. Unzip the [**car simulation program**](#_other_docs/CarSimulation.zip), open the `DriveCar.exe`, then you can drive the car! Make sure that you **turn off bluetooth** in your PC, or there might be some problems with the **UART**.

### Feature Illustration

![EGO1_Illustration](report/pics/EGO1_Illustration.png)
