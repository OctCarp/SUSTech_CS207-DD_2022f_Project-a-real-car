# SUSTech_CS207-DD_2022f_Project-a-real-car

### Project of Digital Logic Design: a "real car"

### Contributors：

[**@OctCarp**](https://github.com/OctCarp) : Top module, global control, manual mode, 7-seg LED display, VGA display 

[**@Guojianyang2002**](https://github.com/Guojianyang2002) : Manual mode, semi-auto mode, auto mode

### Construction:

[**DL_2022F_project_introduction.pdf**](DL_2022F_project_introduction.pdf) : Main requirements document

[**Requirements_Doc/**](Requirements_Doc/) : Other requirements documents, including original demo, and the car simulation program in .zip

[**report/**](report/) : Our project report (If you can read Chinese, I recommend you read this first)

[**sources/**](sources/) : Source code in Verilog

[**unused/**](unused/) : Unused modules

### How to Use It:

 Personal computer, FPGA: **EGO1**, VGA displayer (optional)

1. Use EDA ([![](https://img.shields.io/badge/-VIVADO-white?style=flat&logo=xilinx&logoColor=red)](https://www.xilinx.com/products/design-tools/vivado.html) is recommended), open `sources/`, then add the `cons.xdc` as **constrains**, others as **design sources**.
2. In EDA, run synthesis, implementation, then generate bitstream, and **program EGO1**.
3. Unzip the [**car simulation program**](Requirements_Doc/CarSimulation_bugFix.zip), run the `DriveCar.exe`, then you can drive the car! Make sure that you **turn off bluetooth** in your PC, or there might be some problems with the **UART**.

### Feature Illustration (In English)

#### 1. System Feature

This project implements the logic of driving a car controlled by EGO1. By using the maze program provided by Student Assistant to simulate the running of the car and the Verilog signaling module left in advance, we implement the running simulation and wayfinding simulation of the car.

A control module is reserved to control the power on, off and mode selection of the car respectively. In manual mode, there are throttle, gear, shift, brake and steering functions and control; in semi-automatic mode, there are forward, U-turn and steering control while in fork road, and automatic U-turn while in dead end; in automatic mode, it can automatically find the exit.

The display module includes the mileage display by 7-seg digital display tubes, and the state and mileage display by VGA port.

#### 2. Feature description of each switch

![EGO1_Illustration](report/pics/EGO1_Illustration.png)

- `on` : Power on button, hold **1s** to turn on the engine

- `off` : Power off button

- `switch mode` : Switch mode button, hold down **0.5s** to switch mode

- `turn left` : Left turn control button

- `turn right` : Right turn control button

- `throttle` : Throttle switch

- `reverse` : Reverse switch

- `clutch` : Clutch switch

- `brake` : Brake switch, which covers the throttle switch

- `power` : Power indicator

- `mode` : Mode indicator

- `turn light` : Turn signal light

- `detector` : Detecting lights

- `mile display` : Mile display


#### 4.  Brief User Guide

- **Power switch:**
  - **On:** Hold the Power On button for **1s** to turn on the power.
  - **Off:** Press the Power Off button to turn off the power.

- **Mode selection:**
  - **Mode switching:** Hold the mode selector button while powered on, and switch modes every **0.5s**. The mode light `01` corresponds to manual mode, `10` to semi-automatic mode, and `11` to automatic mode.

- **Manual mode:**
  - **Ignition:** In manual mode, the default state is **unignited**. Open the clutch first, then open the throttle to ignite. After that, close the clutch to start, and move forward. (**Note:** Stepping on the throttle without opening the clutch in advance will cause **power off** when in unignited state)
  - **Forward:** After ignition, when reverse gear is not hanging, open the throttle and the car will move forward; Close the throttle and the car will stop.
  - **Steering:** After ignition, when the left or right steering button is held down, the car turns and the corresponding turn signal flashes. (When both pressed at the same time, the car will go straight)
  - **Brake:** When the brake is applied, the car stops and **returns to unignited state**. And the brake switch covers the throttle, that is, the throttle operation is invalid when the brake is open.
  - **Reverse:** After ignition, turn on the clutch and then turn on the reverse. After the switch, turn off the clutch to end the switch. If the reverse is on, open the throttle, the car will move backward. (**Note:** If the clutch is not turned on during the switch, will cause **power off**)

- **Semi-automatic mode:**
  - **Moving logic:** When the car is not at starting point, and without meeting a fork in the road, the car will automatically find its way. If the car detects a dead end, it will turn 180° and continue. When the car can only turn left or only turn right, it will automatically turn left or turn right and go forward.

  - **Forward command:** At the fork in the road, push the throttle switch once and the car will move forward.

  - **Reverse command:** At the fork in the road, push the reverse switch once and the car will turn 180° then moving forward.

  - **Left Turn command:** At the fork in the road, press the left turn button and the car will turn left at 90°.

  - **Right Turn command:** At the fork in the road, press the right turn button and the car will turn right at 90°.

- **Automatic Mode:**
  - **Moving Logic:** When switching to auto mode, the car can find the end point in right first principle (make sure the car starts from the starting point), if the car can't turn right, then go straight first, then turn left. It will turn back at dead end. After the detector in front of the car detects the wall or beacon, it will enter a static judgment state (it is also the state at the beginning). At this time, straight ahead is preferred (only valid at the beginning, because only when there is no road ahead, it will enter the static judgment state), and then turn right first, turn left first, and finally turn around. The car will place a beacon one grid forward after each right turn, and destroy one beacon each time the car make a U-turn.

- **Mileage count:**
  - **Counting logic:** Forward counts 2m every 1s, backward counts 1m.

- **VGA display:**
  - **Display:** Power on/off status, mode status, and detail states of manual mode, and mileage display.
