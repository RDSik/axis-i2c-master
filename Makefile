TOP      := axis_i2c_top
TCL      := project.tcl
PROJ_DIR := proj

CLEAN_TARGETS := $(PROJ_DIR)\*.zip $(PROJ_DIR)\.Xil $(PROJ_DIR)\*.jou $(PROJ_DIR)\*.log $(PROJ_DIR)\*.pb $(PROJ_DIR)\*.dmp $(PROJ_DIR)\$(TOP).cache $(PROJ_DIR)\$(TOP).data work $(PROJ_DIR)\$(TOP).runs $(PROJ_DIR)\$(TOP).hw $(PROJ_DIR)\$(TOP).ip_user_files $(PROJ_DIR)\$(TOP).sim $(PROJ_DIR)\$(TOP).xpr

project:
	vivado -mode tcl -source $(PROJ_DIR)/$(TCL)

clean:
	del /s /q /f $(CLEAN_TARGETS)
	@-rmdir /s /q $(CLEAN_TARGETS) >nul 2>&1

.PHONY: project clean
