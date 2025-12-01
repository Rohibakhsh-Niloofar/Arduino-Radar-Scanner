# Arduino Radar Scanner

## Overview
This project implements a radar system using an Arduino-controlled servo and an ultrasonic sensor (HY-SRF05) to detect objects. The system scans a 180° range, measures distances, and visualizes them in real-time using a Processing application. It can highlight nearby objects and provide alerts for sudden changes in distance readings.

---

## Features
- 180° scanning radar with servo motor
- Distance measurement using ultrasonic sensor
- Real-time visualization in Processing
- Object proximity alerts
- Smooth and filtered radar sweep animation

---

## Hardware Requirements
- Arduino Uno or compatible board  
- Ultrasonic Sensor **HY-SRF05**  
- Servo Motor (SG90 or similar)  
- Jumper wires  
- USB cable for Arduino  

### HY-SRF05 Connection Table

| Sensor Pin | Arduino Pin | Description |
|-----------|-------------|-------------|
| VCC       | 5V          | Power supply |
| GND       | GND         | Ground |
| TRIG      | 10          | Trigger pin |
| ECHO      | 11          | Echo pin |
| OUT / MODE | (Not used) | Optional pin – left unconnected |

> **Note:**  
> HY-SRF05 supports both **one-pin** and **two-pin** modes.  
> In this project we use **two-pin mode (TRIG + ECHO)** which gives better stability.


## Servo Motor Connection

| Wire Color (Typical) | Servo Pin | Arduino Pin | Description |
|-----------|-----------------------|--------------|-------------|
| **Brown** | GND                  | GND          | Ground connection |
| **Red**   | VCC (5V)             | 5V           | Power supply |
| **Orange / Yellow** | Signal     | 12           | PWM signal to control servo angle |


---

## Software Requirements
- [Arduino IDE](https://www.arduino.cc/en/software)  
- [Processing IDE](https://processing.org/download)  
- Arduino libraries:
  - `Servo.h` (pre-installed in Arduino IDE)  

---

## Arduino Code Explanation
- `Servo myServo;` → initializes the servo object  
- `trigPin` and `echoPin` → pins connected to the ultrasonic sensor  
- `readDistance()` → sends a trigger pulse, measures echo duration, and calculates distance in cm  
- `loop()` → sweeps the servo from 0° to 180° and back, printing angle and distance to serial  

**Workflow:**
1. Sweep servo in 1° increments
2. Read distance from ultrasonic sensor
3. Print results to Serial Monitor
4. Repeat in reverse sweep

---

## Processing Code Explanation
- Imports `processing.serial.*` for serial communication
- Reads Arduino output from serial port
- Smooths angle and distance using a simple exponential smoothing filter (`ALPHA = 0.2`)
- Maintains previous and current scans to detect sudden changes in object distance
- Visualizes radar with:
  - Semi-circular radar arcs
  - Lines representing scan angles
  - Blips for objects (red for objects closer than 20 cm)
  - Pulsing animation for detected objects
    
- Shows warnings in a sidebar when a sudden change occurs  

**Key Functions:**

 `serialEvent()` → parses incoming serial data and updates scans  
 `draw()` → renders radar display and warnings  
 `drawPulsingBlip(x, y, color c)` → renders a pulsing effect for close objects

---

## Installation & Usage

1. **Arduino:**
   - Connect Arduino to your computer  
   - Open `Arduino.Radar.ino` in Arduino IDE  
   - Upload code to Arduino board  

2. **Processing:**
   - Open `Radar.pde` in Processing IDE  
   - Select the correct serial port for Arduino  
   - Run the sketch to visualize radar readings  

3. **Operation:**
   - Place the radar on a flat surface  
   - The servo will sweep the area  
   - Objects within 200 cm will be visualized  
   - Red blips indicate objects closer than 20 cm  

---

## Troubleshooting
- **No serial connection detected:** Make sure Arduino is connected and drivers are installed  
- **Blips not showing:** Check wiring and ensure Trig/Echo pins match Arduino code  
- **Servo not moving:** Confirm servo signal pin and power supply  
- **Distance readings fluctuating:** Ensure the sensor is not exposed to noisy signals; use smoothing in Processing  

---

## License
This project is released under the MIT License.  

---

