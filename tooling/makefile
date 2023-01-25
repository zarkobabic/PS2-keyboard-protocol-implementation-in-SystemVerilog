SIMUL_TOP_LEVEL_MODULE = testbench_uvm
SIMUL_LIB = work
# 1(yes) -> override timescale
# 0(no)  -> do NOT override timescale
SIMUL_IS_TIMESCALE_OVERRIDEN = 1
SIMUL_TIMESCALE = "1 ps / 1 ps"
SIMUL_RUN_TCL_SCRIPT = ./config/run.tcl
SIMUL_WAVEFORM_MACRO = ./config/waveform-define.do
SIMUL_WAVEFORM_FILE = ./waveform.wlf
SIMUL_VLOG_LOG_FILE = ./vlog_compile.log
# 1(yes) -> Questa
# 0(no)  -> ModelSim
SIMUL_IS_QUESTA_USED = 1
# either empty variable or path ending with \\ i.e. double backslash
# C:\\"Program Files"\\altera\\13.1\\modelsim_ase\\win32aloem\\ 

SIMUL_TOOL_EXE_DIR_PATH = C:\\"Program1"\\questasim64_10.7c\\win64\\
#SIMUL_TOOL_EXE_DIR_PATH = C:\\questasim64_10.4c\\win64\\

SYNTH_TOP_LEVEL_MODULE = DE0_TOP
# CycloneIII
# CycloneV
SYNTH_DEVICE_FAMILY = CycloneIII
# EP3C16F484C6 (CycloneIII)
# 5CEBA4F23C7 (CycloneV)
SYNTH_DEVICE_PART = EP3C16F484C6
SYNTH_CYCLONE3_DEFAULT_ASSIGNMENT_FILE = ./config/boards/cyclone3/assignment_defaults.qdf
SYNTH_CYCLONE5_DEFAULT_ASSIGNMENT_FILE = ./config/boards/cyclone5/assignment_defaults.qdf
SYNTH_CYCLONE5_CONSTRAINTS_FILE = ./config/boards/cyclone5/DE0_CV_TOP.sdc
# either empty variable or path ending with \\ i.e. double backslash
# C:\\"Program Files"\\altera\\13.1\\quartus\\bin\\ 
SYNTH_TOOL_EXE_DIR_PATH = C:\\"Program Files"\\altera\\13.1\\quartus\\bin64\\

LIST_FILE_ICARUS = ./config/list-icarus-verilog.lst
LIST_FILE_SIMUL = ./config/list-src-files-simul.lst
LIST_FILE_SYNTH = ./config/list-src-files-synth.lst

all: help

help:
	@echo
	@echo "USAGE: make [options] <target(s)>"
	@echo
	@echo "TARGETS:"
	@echo "       help            - Show the help (this text)."
	@echo
	@echo "       simul_all       - Compile and simulate the design (Shell-based)."
	@echo "       simul_lib       - Create the work library."
	@echo "       simul_cmp       - Compile the design."
	@echo "       simul_run       - Start default simulation (shell-based)."
	@echo "       simul_run_gui   - Start GUI-based simulation."
	@echo "       simul_run_sh    - Start shell-based simulation."
	@echo "       simul_wave_old  - Show already existing wave (do not run simulation)."
	@echo "       simul_wave_new  - Show newly created wave (run simulation)."
	@echo "       simul_clean     - Clean simulation directory."
	@echo
	@echo "       synth_all       - Analyze & Synthesize, Place & Route, Assembly and Static Time Analyze."
	@echo "       synth_map       - Map (Analyze & Synthesize)."
	@echo "       synth_fit       - Fit (Place & Route)."
	@echo "       synth_asm       - Assemble."
	@echo "       synth_sta       - Static Time Analyze."
	@echo "       synth_net       - Create post-fit netlist."
	@echo "       synth_pgm       - Program the device."
	@echo "       synth_clean     - Clean synthesis directory." 
	@echo
	@echo "       list_all        - Create list for Icarus Verilog, simulation and synthesis"
	@echo "       list_icarus     - Create list of Icarus Verilog library directories"
	@echo "       list_simul      - Create list of simulation source files (src/*)"
	@echo "       list_synth      - Create list of synthesis source files (src/synthesis/*)"
	@echo

clean: simul_clean synth_clean

# user function for creating source file list
# $(1) param is file path
create_src_file_list = $(addprefix ../,$(strip $(file < $(1))))

# #######################################################################################
# S I M U L A T I O N 
# #######################################################################################

# #######################################################################################
# Usage: vlib -help
#        vlib [-short | -dos | -long | -unix ] [-archive [-compact <compact>]]
#             [-depend [<depend>]] [-mapping [<mapping>]] [-target [<target>]]
#             [-vendor [<vendor>]] [-version [<version>]]
#             [-unnamed_designs <count>] [(-lock|-unlock) <design>]
#             [-locklib|-unlocklib] <library_name>

# #######################################################################################
# Usage: vlog [options] files
# Options:
#    -override_timescale <timescale>
#                       Override the timescale specified in the source code. 
#    -work <path>       Specify library WORK 
#    -l <filename>      Write compilation log to <filename>

# #######################################################################################
# Usage: vsim [options] [[<library>.]<primary>[(<secondary>)]]...
#     -lib <libname>          Load top-level design units from <libname>
#                             (Default: work) 
#     -wlf <filename>         Specify the name of the WLF file (Default: vsim.wlf)
#     -do "<command>"         Execute <command> on startup; <command> can be
#                             a macro filename
#     -G <Name>=<Value>       Alternate way to override generic/parameter with specified Value

SIMUL_TAG = ***[SIMULATION]***

SIMUL_TOOL_VLIB = $(SIMUL_TOOL_EXE_DIR_PATH)vlib.exe
SIMUL_TOOL_VLOG = $(SIMUL_TOOL_EXE_DIR_PATH)vlog.exe
SIMUL_TOOL_VOPT = $(SIMUL_TOOL_EXE_DIR_PATH)vopt.exe
SIMUL_TOOL_VSIM = $(SIMUL_TOOL_EXE_DIR_PATH)vsim.exe

SIMUL_SRC_FILE_LIST = $(call create_src_file_list,$(LIST_FILE_SIMUL))
# $(info $(SIMUL_SRC_FILE_LIST))

# ONLY ONE MODULE CAN BE DEFINED PER FILE FOR QUESTA
SIMUL_COMPILED_DESIGN_LIST=$(basename $(notdir $(SIMUL_SRC_FILE_LIST)))
SIMUL_OPTIMIZED_DESIGN = optimized_design

# vlog (compiler) command line option arguments
SIMUL_VLOG_ARGS =
SIMUL_VLOG_ARGS += -work $(SIMUL_LIB)
SIMUL_VLOG_ARGS += -l $(SIMUL_VLOG_LOG_FILE)
ifeq ($(SIMUL_IS_TIMESCALE_OVERRIDEN), 1)
SIMUL_VLOG_ARGS += -override_timescale $(SIMUL_TIMESCALE)
endif

# vopt (optimizer) command line option arguments
SIMUL_VOPT_ARGS =
ifeq ($(SIMUL_IS_QUESTA_USED), 1)
SIMUL_VOPT_ARGS += $(SIMUL_VLOG_ARGS)
SIMUL_VOPT_ARGS += +acc
SIMUL_VOPT_ARGS += -o $(SIMUL_OPTIMIZED_DESIGN)
endif

# vsim (simulator) command line option arguments
SIMUL_VSIM_ARGS =
SIMUL_VSIM_ARGS += -lib $(SIMUL_LIB)
SIMUL_VSIM_ARGS += -wlf $(SIMUL_WAVEFORM_FILE)
SIMUL_VSIM_ARGS_GUI = $(SIMUL_VSIM_ARGS)
SIMUL_VSIM_ARGS_GUI += -do "source $(SIMUL_WAVEFORM_MACRO); source $(SIMUL_RUN_TCL_SCRIPT)"
SIMUL_VSIM_ARGS_SHELL = $(SIMUL_VSIM_ARGS)
SIMUL_VSIM_ARGS_SHELL += -do "$(SIMUL_RUN_TCL_SCRIPT)"

simul_all: simul_lib simul_cmp simul_run

simul_lib:
	@echo "$(SIMUL_TAG) Creating new library $(SIMUL_LIB)."
	rm -rf $(SIMUL_LIB)
	$(SIMUL_TOOL_VLIB) $(SIMUL_LIB)

simul_cmp: simul_lib
	@echo "$(SIMUL_TAG) Compiling Verilog HDL source files."
	$(SIMUL_TOOL_VLOG) $(SIMUL_VLOG_ARGS) $(SIMUL_SRC_FILE_LIST)

simul_run: simul_run_sh

ifeq ($(SIMUL_IS_QUESTA_USED), 1)
# RECIPES FOR QUEST USAGE
simul_run_gui: simul_cmp
	@echo "$(SIMUL_TAG) Starting simulation in GUI mode."
	$(SIMUL_TOOL_VOPT) $(SIMUL_VOPT_ARGS) $(SIMUL_COMPILED_DESIGN_LIST)
	$(SIMUL_TOOL_VSIM) -gui $(SIMUL_VSIM_ARGS_GUI) $(SIMUL_OPTIMIZED_DESIGN) &

simul_run_sh: simul_cmp
	@echo "$(SIMUL_TAG) Starting simulation in shell mode."
	$(SIMUL_TOOL_VOPT) $(SIMUL_VOPT_ARGS) $(SIMUL_COMPILED_DESIGN_LIST)
	$(SIMUL_TOOL_VSIM) -c $(SIMUL_VSIM_ARGS_SHELL) $(SIMUL_OPTIMIZED_DESIGN)
else
# RECIPES FOR MODEL SIM USAGE
simul_run_gui: simul_cmp
	@echo "$(SIMUL_TAG) Starting simulation in GUI mode."
	$(SIMUL_TOOL_VSIM) -gui $(SIMUL_VSIM_ARGS_GUI) $(SIMUL_LIB).$(SIMUL_TOP_LEVEL_MODULE) &

simul_run_sh: simul_cmp
	@echo "$(SIMUL_TAG) Starting simulation in shell mode."
	$(SIMUL_TOOL_VSIM) -c $(SIMUL_VSIM_ARGS_SHELL) $(SIMUL_LIB).$(SIMUL_TOP_LEVEL_MODULE)
endif

simul_wave_old: 
	@echo "$(SIMUL_TAG) Showing existing waveform (simulation has not been run again)."
	$(SIMUL_TOOL_VSIM) -do "$(SIMUL_WAVEFORM_MACRO)" -view $(SIMUL_WAVEFORM_FILE)

simul_wave_new: simul_run_sh
	@echo "$(SIMUL_TAG) Showing newly created waveform (simulation has been run)."
	$(SIMUL_TOOL_VSIM) -do "$(SIMUL_WAVEFORM_MACRO)" -view $(SIMUL_WAVEFORM_FILE)

simul_clean:
	@echo "$(SIMUL_TAG) Cleaning directory."
	rm -fr $(SIMUL_LIB) $(SIMUL_VLOG_LOG_FILE) $(SIMUL_WAVEFORM_FILE) transcript *~

# #######################################################################################
# S Y N T H E S I S
# #######################################################################################

# #######################################################################################
# The smart action is defined as the earliest module in the Compiler flow that
# needs to be run based on current assignment files.
# This option writes out a .chg file depending on what has changed in the source files.
# For a given quartus_<exe_name>, the associated .chg file name
# has the format trigger.<exe_name>.chg. For example, if quartus_map needs to be rerun,
# a file named trigger.map.chg is created.

SYNTH_TAG = ***[SYNTHESIS]***

SYNTH_TOOL_SH = $(SYNTH_TOOL_EXE_DIR_PATH)quartus_sh
SYNTH_TOOL_MAP = $(SYNTH_TOOL_EXE_DIR_PATH)quartus_map
SYNTH_TOOL_FIT = $(SYNTH_TOOL_EXE_DIR_PATH)quartus_fit
SYNTH_TOOL_ASM = $(SYNTH_TOOL_EXE_DIR_PATH)quartus_asm
SYNTH_TOOL_STA = $(SYNTH_TOOL_EXE_DIR_PATH)quartus_sta
SYNTH_TOOL_CDB = $(SYNTH_TOOL_EXE_DIR_PATH)quartus_cdb
SYNTH_TOOL_PGM = $(SYNTH_TOOL_EXE_DIR_PATH)quartus_pgm

SYNTH_SRC_FILE_LIST = $(call create_src_file_list,$(LIST_FILE_SYNTH))
# $(info $(SYNTH_SRC_FILE_LIST))

# trigger change given file forcing make to
# execute recipes of rules with adequate prerequisites
SYNTH_TRIGGER = echo done >
SYNTH_PROJECT = $(SYNTH_TOP_LEVEL_MODULE)
SYNTH_ASSIGNMENT_FILES = $(SYNTH_PROJECT).qpf $(SYNTH_PROJECT).qsf

# quartus_map (mapping i.e. analysis & synthesis) command line arguments
SYNTH_MAP_ARGS =
SYNTH_MAP_ARGS += --family=$(SYNTH_DEVICE_FAMILY)
SYNTH_MAP_ARGS += $(addprefix --source=,$(SYNTH_SRC_FILE_LIST))

# quartus_fit (fitting i.e. place & route) command line arguments
SYNTH_FIT_ARGS =
SYNTH_FIT_ARGS += --part=$(SYNTH_DEVICE_PART)

# quartus_asm (assembly) command line arguments
SYNTH_ASM_ARGS =

# quartus_sta (static timing analysis) command line arguments
SYNTH_STA_ARGS = 

# quartus_cdb
SYNTH_CDB_ARGS =
SYNTH_CDB_ARGS += --write_eqn_file=$(SYNTH_PROJECT).eqn
SYNTH_CDB_ARGS += --netlist_type=cmp

# quartus_pgm (quartus programmer) command line arguments
SYNTH_PGM_ARGS =
SYNTH_PGM_ARGS += --mode="JTAG" 
SYNTH_PGM_ARGS += --operation="P;$(SYNTH_PROJECT).sof"

synth_all: smart.log $(SYNTH_PROJECT).asm.rpt $(SYNTH_PROJECT).sta.rpt $(SYNTH_PROJECT).eqn

$(SYNTH_ASSIGNMENT_FILES):
	@echo "$(SYNTH_TAG) Preparing."
	$(SYNTH_TOOL_SH) --prepare $(SYNTH_PROJECT)
#	@case $(SYNTH_DEVICE_FAMILY) in \
		CycloneIII) \
			cat $(SYNTH_CYCLONE3_DEFAULT_ASSIGNMENT_FILE) >> $(SYNTH_PROJECT).qsf \
			;; \
		CycloneV) \
			cat $(SYNTH_CYCLONE5_DEFAULT_ASSIGNMENT_FILE) >> $(SYNTH_PROJECT).qsf && \
			cat $(SYNTH_CYCLONE5_CONSTRAINTS_FILE) >> $(SYNTH_PROJECT).sdc \
			;; \
	esac

trigger.map.chg:
	$(SYNTH_TRIGGER) trigger.map.chg
trigger.fit.chg:
	$(SYNTH_TRIGGER) trigger.fit.chg
trigger.asm.chg:
	$(SYNTH_TRIGGER) trigger.asm.chg
trigger.sta.chg:
	$(SYNTH_TRIGGER) trigger.sta.chg
trigger.net.chg:
	$(SYNTH_TRIGGER) trigger.net.chg

synth_map: smart.log $(SYNTH_PROJECT).map.rpt
synth_fit: smart.log $(SYNTH_PROJECT).fit.rpt
synth_asm: smart.log $(SYNTH_PROJECT).asm.rpt
synth_sta: smart.log $(SYNTH_PROJECT).sta.rpt
synth_net: smart.log $(SYNTH_PROJECT).eqn
smart: smart.log

$(SYNTH_PROJECT).map.rpt: trigger.map.chg $(SYNTH_SRC_FILE_LIST)
	@echo "$(SYNTH_TAG) Analysis & Synthesis (mapping HDL to logic netlist)."
	$(SYNTH_TOOL_MAP) $(SYNTH_MAP_ARGS) $(SYNTH_PROJECT)
	$(SYNTH_TRIGGER) trigger.fit.chg

$(SYNTH_PROJECT).fit.rpt: trigger.fit.chg $(SYNTH_PROJECT).map.rpt
	@echo "$(SYNTH_TAG) Fitting (placing and routing logic netlist onto a device)."
	$(SYNTH_TOOL_FIT) $(SYNTH_FIT_ARGS) $(SYNTH_PROJECT)
	$(SYNTH_TRIGGER) trigger.asm.chg
	$(SYNTH_TRIGGER) trigger.sta.chg
	$(SYNTH_TRIGGER) trigger.net.chg

$(SYNTH_PROJECT).asm.rpt: trigger.asm.chg $(SYNTH_PROJECT).fit.rpt
	@echo "$(SYNTH_TAG) Assembling (generating a physical device programming image)."
	$(SYNTH_TOOL_ASM) $(SYNTH_ASM_ARGS) $(SYNTH_PROJECT)

$(SYNTH_PROJECT).sta.rpt: trigger.sta.chg $(SYNTH_PROJECT).fit.rpt
	@echo "$(SYNTH_TAG) Static Timing Analysis."
	$(SYNTH_TOOL_STA) $(SYNTH_STA_ARGS) $(SYNTH_PROJECT)

$(SYNTH_PROJECT).eqn: trigger.net.chg $(SYNTH_PROJECT).fit.rpt
	@echo "$(SYNTH_TAG) Creating post-fit netlist."
	$(SYNTH_TOOL_CDB) $(SYNTH_PROJECT) $(SYNTH_CDB_ARGS)

synth_pgm: synth_all
	@echo "$(SYNTH_TAG) Programming the device."
	$(SYNTH_TOOL_PGM) $(SYNTH_PGM_ARGS)

smart.log: $(SYNTH_ASSIGNMENT_FILES)
	@echo "$(SYNTH_TAG) Determining smart action."
	$(SYNTH_TOOL_SH) --determine_smart_action $(SYNTH_PROJECT) > smart.log

synth_clean:
	@echo "$(SYNTH_TAG) Cleaning directory."
	rm -rf db incremental_db hc_output
	rm -rf *.qpf *.qdf *.sdc *.jdi
#	rm -rf  *.qsf
	rm -rf *.eqn *.pin *.sof *.pof
	rm -rf smart.log *.rpt *.htm *.summary *.smsg *.echo *.txt
	rm -rf *.chg

# #######################################################################################
# LIST
# #######################################################################################

LIST_TAG = ***[LIST]***

NULL =
SPACE = ${NULL} ${NULL}
# https://www.gnu.org/software/make/manual/make.html#Multi_002dLine
define NEWLINE


endef

# user function for breaking on spaces (substituting spaces with newlines)
# $(1) param is text for breaking on spaces
break = $(subst $(SPACE),$(NEWLINE),$(strip $(1)))

# user function for recursive wildcard
# $(1) param is directory path
# $(2) param is filter pattern
wildcardrecursive = \
	$(foreach \
		DIR,\
		$(wildcard $(1:=/*)),\
		$(call wildcardrecursive,$(DIR),$(2)) $(filter $(subst *,%,$(2)),$(DIR)))
LIST_SIMUL = $(strip $(subst ../,,$(call wildcardrecursive,../src/simulation,*.v *.vp *.sv)))
LIST_SYNTH = $(strip $(subst ../,,$(call wildcardrecursive,../src/synthesis,*.v *.vp *.sv)))
LIST_COMBINED = $(LIST_SIMUL) $(LIST_SYNTH)

list_all: list_icarus list_simul list_synth

list_icarus:
	@echo $(LIST_TAG) Created list of Icarus Verilog library directories \(+libdir+\)
	$(file > $(LIST_FILE_ICARUS),$(call break,$(addprefix +libdir+,$(sort $(dir $(subst /,\,$(LIST_COMBINED)))))))

list_simul:
	@echo $(LIST_TAG) Created list of simulation source files \(src/*\)
	$(file > $(LIST_FILE_SIMUL),$(call break,$(LIST_COMBINED)))

list_synth:
	@echo $(LIST_TAG) Created list of synthesis source files \(src/synthesis/*\)
	$(file > $(LIST_FILE_SYNTH),$(call break,$(LIST_SYNTH)))
