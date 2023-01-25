# PS2-keyboard-protocol-implementation-in-SystemVerilog

<h1> Abstract </h1>
<hr/>

I implemented the <b>ps2 protocol for the keyboard</b>, where the device is a keyboard with a ps2 serial port, and the host is an <b><i>Altera Cyclone® V FPGA board</i></b>.

Implementation involves going through all stages of software development for hardware:
<ol>
  <li><b><i>Simulation using Verilog and Altera ModelSim</i></b></li>
  <li><b><i>Synthesis using Verilog and Quartus II</i></b></li>
  <li><b><i>Verification using SystemVerilog and QuestaSim</i></b></li>
</ol>


<h1>Navigation</h1>
<hr/>

In the folder src/simulation there are source files used for the simulation.
In the subfolder <b>modules</b> there are implementations of the used module written in Verilog.
In addition, on the path src/simulation there is a file testbench_uvm, which represents the source code for verification, written in Systemerilog using the standard library UVM (Universal Verification Methodology library).



The src/synthesis path contains files relevant to synthesis on the Altera Cyclone® V FPGA board.
the path src/synthesis/modules contains the implemented modules:
<ol>
<li><b><i>deb.v which is a debouncer for the keyboard clock signal</i></b></li>
<li><b><i>hex.v which is a module for reading hex values on the seven-segment display of the FPGA board</i></b></li>
<li><b><i>ps2.v which represents the main module in which the logic of the protocol is implemented</i></b></li>
</ol>

On the path src/syntesis/ there is also the file DEO_TOP0.v which represents the file in which things are instantiated and from which the program for the FPGA board will be synthesized.


<h1>Starting up</h1>
<hr/>

<h3>Before starting, make sure you have pre-installed Altera ModelSim, Quartus II and QuestaSim as well as connected Altera Cyclone® V FPGA board. </h3>

In order to start one of the development phases, it is necessary to use the makefile located in the path src/tooling/xpack/makefile
If it is started from the Windows operating system, it is necessary to install and run <b>Cygwin<b> in order to simulate linux functions on windows from the terminal.

Inside the makefile, with the <b></i>help</i></b> command, we get a list of possible commands for starting phases.

The command <b></i>simul_run</i></b> starts the verification while the command <b></i>synth_pgm</i></b> starts the tools of the synthesis program and puts program to the connected FPGA board.
