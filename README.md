This design is a reaction timer game that tests the user’s ability to react to a visual stimulus, with this being LEDs turning on, and pressing a button to get the fastest reaction time. The game goes through multiple states when loaded and includes user inputs, random delay generations, capturing the reaction time, and displaying the reaction time. The design pieces this together using a finite state machine with three separate states.
The game works as follows:
1.	State 1: “PressStart”: When the program is loaded, HEX displays 4-0 will switch between the words “Press” and “Start” each displaying for one second until a specific button is pressed.
![image](https://github.com/user-attachments/assets/4a66c71c-c09b-4409-be1d-dbbb6f70dcb6)
2.	State 2: “Game”: When the start button is pressed (Key0) the HEX displays will blank out at a random time between 0-8 seconds starts. When a random time between 0-8 seconds happens, then all the LEDs (9-0) will light up, the HEX displays will turn back on showing the time up to a thousandth of a millisecond since the LEDs came on, and the user will have to press the reaction button (Key1) The HEX display will display in the format of X.XXX, with the X before the decimal being total seconds, and the XXX after the decimal being milliseconds in tenths, hundredths, and thousandths.
![image](https://github.com/user-attachments/assets/f55fa3f9-e54a-4567-8edd-795456c93865)
![image](https://github.com/user-attachments/assets/996813a2-c0b1-4e3f-8cf3-908ab7d16a95)
3.	State 3: “Result”: When the button is pressed, the LEDs blank out and the HEX display will display the time it took between the LEDs turning on and Key1 being pressed. After the reaction time is displayed for seven seconds, the game will reset back to the “PressStart” state. This will allow the user to play the game repeatedly without having to reload the program.
![image](https://github.com/user-attachments/assets/bcca77a6-9244-44ab-9753-a72a542b00c3)

The only hardware that is used is the DE10-Lite FPGA board since all the needed inputs and outputs are already included. Quartus II software was used to develop and load the program on the board.

![image](https://github.com/user-attachments/assets/56356800-c525-452a-968e-8d4a4ccb11e6)
