### Keypad Matrix Assembly Project
This repository contains an assembly language implementation for interfacing with a 4x4 keypad matrix using MIPS assembly. It demonstrates how to read input from the keypad and display corresponding output on a simulated LED display.

##Features
Keypad Input: Reads keypresses from a 4x4 matrix keypad.
Output Display: Simulates displaying characters corresponding to keypad inputs.
Example Code: Includes example code for initializing the keypad, reading input, and displaying output.
Files Included
main.asm: Main assembly code implementing keypad interaction and output display.
keypad.asm: Assembly code handling keypad scanning and input processing.
README.md: This file, providing an overview of the project and instructions.
LICENSE: MIT License for the project.
## Usage
To assemble and run the project using DOSBox with MASM (Microsoft Macro Assembler):

## Clone the Repository:

bash
Copy code
git clone https://github.com/Skols93/Keypad-matrix_assembly.git
cd Keypad-matrix_assembly
## Set Up DOSBox and MASM:

Download and install DOSBox from https://www.dosbox.com/download.php.
Download and install MASM (Microsoft Macro Assembler) compatible with DOSBox.
Run DOSBox:

Launch DOSBox and mount the directory where your project files are located.
Assemble and Run:

Navigate to your project directory inside DOSBox.
Use MASM to assemble main.asm:
arduino
Copy code
masm main.asm;
Link the assembled object file (if necessary):
bash
Copy code
link main.obj;
Run the executable:
css
Copy code
main.exe
Follow on-screen instructions to interact with the simulated keypad and observe the output.
Example Code
assembly
Copy code
; Example code snippet demonstrating keypad input and output display
; Initialize keypad, read input, and display output

; Your assembly code here
Development Environment
Assembler: MASM (Microsoft Macro Assembler) compatible with DOSBox
Platform: DOSBox (DOS Emulator)
Operating System: Any OS with DOSBox installed (Windows, macOS, Linux)
Contributions
Contributions are welcome! If you have ideas for improvements, please open an issue or submit a pull request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Author
Author: [Stefan Vasilevski]
GitHub: [[Your GitHub profile URL](https://github.com/Skols93)]
