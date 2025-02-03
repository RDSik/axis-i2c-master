TOP         := axis_i2c_top
TCL         := project.tcl
PROJECT_DIR := project

.PHONY: project clean

project:
	vivado -mode tcl -source $(PROJECT_DIR)/$(TCL)

clean:
ifeq ($(OS), Windows_NT)
	del *.jou
	del *.log
	rmdir /s /q $(PROJECT_DIR)\.zip
	rmdir /s /q $(PROJECT_DIR)\.Xil
	rmdir /s /q $(PROJECT_DIR)\*.pb
	rmdir /s /q $(PROJECT_DIR)\*.dmp
	rmdir /s /q $(PROJECT_DIR)\$(TOP).cache
	rmdir /s /q $(PROJECT_DIR)\$(TOP).data
	rmdir /s /q $(PROJECT_DIR)\$(TOP).runs
	rmdir /s /q $(PROJECT_DIR)\$(TOP).hw
	rmdir /s /q $(PROJECT_DIR)\$(TOP).ip_user_files
	rmdir /s /q $(PROJECT_DIR)\$(TOP).sim
	rmdir /s /q $(PROJECT_DIR)\work
	rmdir /s /q $(PROJECT_DIR)\$(TOP).xpr
else
	rm *.jou
	rm *.log
	rm *.pb
	rm *.dmp
	rm $(PROJECT_DIR)/$(TOP).xpr
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