TOP := axis_i2c_top

RTL_DIR     := rtl
TB_DIR      := tb
PROJECT_DIR := project

SYN ?= gowin

MACRO_FILE := wave.do
TCL        := project.tcl

.PHONY: project sim clean

project:
ifeq ($(SYN), gowin)
	gw_sh $(PROJECT_DIR)/gowin/$(TCL)
else ifeq ($(SYN), vivado)
	vivado -mode tcl -source $(PROJECT_DIR)/vivado/$(TCL)
endif

sim:
	vsim -do $(TB_DIR)/$(MACRO_FILE)

clean:
	rm -rf $(PROJECT_DIR)/$(TOP)
	rm -rf $(PROJECT_DIR)/vivado/$(TOP).cache
	rm -rf $(PROJECT_DIR)/vivado/$(TOP).hw
	rm -rf $(PROJECT_DIR)/vivado/$(TOP).runs
	rm -rf $(PROJECT_DIR)/vivado/$(TOP).sim
	rm -rf $(PROJECT_DIR)/vivado/$(TOP).ip_user_files
	rm -rf $(PROJECT_DIR)/vivado/.Xil
	rm $(PROJECT_DIR)/vivado/$(TOP).xpr
	rm -rf obj_dir
	rm -rf work
	rm transcript
	rm *.vcd
	rm *.wlf
	rm *.log
	rm *.jou