# SCRIPT EXECUTION STARTS HERE
post_message "i2c_master design pre-flow script"

set project_name "i2c_master"

set make_assignments 0

# Make sure that the right project is open
if {[is_project_open]} {
    if {[string compare $quartus(project) $project_name]} {
	project_close
	project_open $project_name
    }
} else {
    project_open $project_name
}

# Global assignments
set_global_assignment -name OPTIMIZE_IOC_REGISTER_PLACEMENT_FOR_TIMING "PACK ALL IO REGISTERS"
set_global_assignment -name IO_PLACEMENT_OPTIMIZATION ON
set_global_assignment -name SYNCHRONIZER_IDENTIFICATION "FORCED IF ASYNCHRONOUS"

# I/O configuration


# Commit assignments
export_assignments

# SCRIPT EXECUTION ENDS HERE
post_message "i2c_master design pre-flow script execution complete"
