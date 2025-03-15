TOP := axis_i2c_top

RTL_DIR     := rtl
TB_DIR      := tb
PROJECT_DIR := project

SYN ?= gowin

MACRO_FILE := wave.do
GOWIN_TCL  := gowin_project.tcl
VIVADO_TCL := vivado_project.tcl

.PHONY: project sim clean

project:
ifeq ($(SYN), gowin)
	gw_sh $(PROJECT_DIR)/$(GOWIN_TCL)
else ifeq ($(SYN), vivado)
	vivado -mode tcl -source $(PROJECT_DIR)/$(VIVADO_TCL)
endif

sim:
	vsim -do $(TB_DIR)/$(MACRO_FILE)

clean:
ifeq ($(OS), Windows_NT)
	rmdir /s /q $(PROJECT_DIR)\$(TOP)
	rmdir /s /q work
	del *.jou
	del *.log
	del $(PROJECT_DIR)\*.jou
	del $(PROJECT_DIR)\*.log
	del $(PROJECT_DIR)\$(TOP).xpr
	rmdir /s /q .Xil
	rmdir /s /q $(PROJECT_DIR)\$(TOP).cache
	rmdir /s /q $(PROJECT_DIR)\$(TOP).runs
	rmdir /s /q $(PROJECT_DIR)\$(TOP).hw
	rmdir /s /q $(PROJECT_DIR)\$(TOP).ip_user_files
	rmdir /s /q $(PROJECT_DIR)\$(TOP).sim
	rmdir /s /q $(PROJECT_DIR)\$(TOP).data
	rmdir /s /q $(PROJECT_DIR)\work
	rmdir /s /q $(PROJECT_DIR)\.zip
	rmdir /s /q $(PROJECT_DIR)\*.pb
	rmdir /s /q $(PROJECT_DIR)\*.dmp
else
	rm -rf work
	rm *.jou
	rm *.log
	rm $(PROJECT_DIR)/*.pb
	rm $(PROJECT_DIR)/*.dmp
	rm $(PROJECT_DIR)/$(TOP).xpr
	rm -rf $(PROJECT_DIR)/$(TOP)
	rm -rf $(PROJECT_DIR)/*.zip
	rm -rf $(PROJECT_DIR)/.Xil
	rm -rf $(PROJECT_DIR)/$(TOP).cache
	rm -rf $(PROJECT_DIR)/$(TOP).data
	rm -rf $(PROJECT_DIR)/$(TOP).runs
	rm -rf $(PROJECT_DIR)/$(TOP).hw
	rm -rf $(PROJECT_DIR)/$(TOP).ip_user_files
	rm -rf $(PROJECT_DIR)/$(TOP).sim
	rm -rf $(PROJECT_DIR)/work
endif