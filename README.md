# PS2-keyboard-protocol-implementation-in-SystemVerilog

<h1> Abstract </h1>
<hr/>
Implementation of the <b>ps2 protocol for the keyboard</b>, where the device is a keyboard with a ps2 serial port, and the host is an <b><i>Altera Cyclone® V FPGA board</i></b>.

Implementation involves going through all stages of software development for hardware:
<ol>
  <li><b><i>Simulation using Verilog and Altera ModelSim</i></b></li>
  <li><b><i>Synthesis using Verilog and Quartus II</i></b></li>
  <li><b><i>Verification using SystemVerilog and QuestaSim</i></b></li>
</ol>


<h1>Navigation</h1>
<hr/>

In the folder <b><i>src/simulation</i></b> there are source files used for the simulation.
In the subfolder <b>modules</b> there are implementations of the used module written in Verilog.
In addition, on the path <b><i>src/simulation</i></b> there is a file testbench_uvm, which represents the source code for verification, written in Systemerilog using the standard library UVM (Universal Verification Methodology library).



The <b><i>src/synthesis</i></b> path contains files relevant to synthesis on the Altera Cyclone® V FPGA board.
the path <b><i>src/synthesis/modules</i></b> contains the implemented modules:
<ol>
<li><b><i>deb.v which is a debouncer for the keyboard clock signal</i></b></li>
<li><b><i>hex.v which is a module for reading hex values on the seven-segment display of the FPGA board</i></b></li>
<li><b><i>ps2.v which represents the main module in which the logic of the protocol is implemented</i></b></li>
</ol>

On the path <b><i>src/syntesis/</i></b> there is also the file DEO_TOP0.v which represents the file in which things are instantiated and from which the program for the FPGA board will be synthesized.


<h1>Starting up</h1>
<hr/>

<h3>Before starting, make sure you have pre-installed Altera ModelSim, Quartus II and QuestaSim as well as connected Altera Cyclone® V FPGA board. </h3>

In order to start one of the development phases, it is necessary to use the makefile located in the path <b><i>src/tooling/xpack/makefile</i></b>
If it is started from the Windows operating system, it is necessary to install and run <b>Cygwin</b> in order to simulate linux functions on windows from the terminal.

Inside the makefile, with the <b><i>help</i></b> command, we get a list of possible commands for starting phases.

The command <b><i>simul_run</i></b> starts the verification while the command <b><i>synth_pgm</i></b> starts the tools of the synthesis program and puts program to the connected FPGA board.

<h3>Implementation</h3>
<hr/>
The goal of the project was to implement this protocol so that the last two bytes of pressed and released keyboard codes (make and break codes) are displayed on the seven-segment display of an Altera Cyclone® V FPGA board. 
I wrote the software for this board so that the board and the keyboard can communicate via ps2 protocol and send values that will be shown on the display.


<h2>Specification:</h2>
  <ul>
    <li>PS/2 protocol is a serial protocol for communication between devices and keyboards.</li>
    <li>Communication is performed using two signals:</li>
    <ol> 
      <li><b><i>PS2_KBCLK</i></b> which represents the keyboard clock signal (10-16.7kH) to which data is sent.</li>
      <li><b><i>PS2_KBDAT</i></b> through which data from the keyboard is sent serially.</li>
    </ol>
    <li>Data is sent on the falling edge of the keyboard clock signal.</li>
    <li>When no data is sent, the <b><i>PS2_KBDAT</i></b> signal has a value of one.</li>
    <li>Sending data starts with the <b><i>START</i></b> bit (value 0), followed by 8 DATA bits (sent first
the lowest bit), followed by the <b><i>ODD_PARITY</i></b> bit (odd parity), and finally the <b><i>STOP</i></b> bit is sent
(value 1).</li>
    <li>If a key whose make code has more than one byte is pressed, older bytes are sent first, using the same principle as sending from the lowest bits</li>
    <li>When a button on the keyboard is pressed or released, the keyboard sends a code over the protocol
pressed (<b><i>make code</i></b>) or released (<b><i>break code</i></b>) button.</li>
    <li>The code can be of different lengths (1B, 2B, 4B, ...).</li>
    <li>The code of the released button is formed by adding F0 to the code of the pressed button
the two highest bytes.</li>
    <li>If a button whose make code is larger than one byte is released, then a break code is created by adding <b><i>F0</i></b> between the first and second byte.</li>
  </ul> 
 



