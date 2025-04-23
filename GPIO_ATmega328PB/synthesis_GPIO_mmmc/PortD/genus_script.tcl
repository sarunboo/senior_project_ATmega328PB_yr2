# #########################################################################
# Cadence genus synthesis script
# AUTHOR : Norakamon P. & Sarun B.
# DATE : 07/02/2025
# #########################################################################

set LIB_DIR     "/nfs/mcu8b/jirath/01lib/"
# set TARGET_LIB  "scc013ull_hd_rvt_tt_v1p5_25c_basic.lib"
set mmmc_tcl  "mmmc.tcl"
set RTL_DIR     "/nfs/mcu8b/sarun/current_GPIO/portD/"
set TOP_DESIGN_NAME     "Port_D"

file mkdir   report
file mkdir   outputs

set_db  init_lib_search_path     ${LIB_DIR}
set_db  init_hdl_search_path     ${RTL_DIR}
# read_libs   ${TARGET_LIB}
read_mmmc ${mmmc_tcl}

# read rtl and constriants
read_hdl   -language sv ${TOP_DESIGN_NAME}.sv IO_Port.sv rg_md.sv synchronizer.sv
# ${TOP_DESIGN_NAME}.sv mux0.sv prescaler0.sv synchronizer.sv
elaborate
init_design 

# read_sdc -stop_on_errors   constraints/${TOP_DESIGN_NAME}_constraints.sdc

# set synthesis effort
set_db  syn_generic_effort      medium
set_db  syn_map_effort          medium
set_db  syn_opt_effort          medium

# synthesis 
syn_generic
syn_map
syn_opt

# outputs
write_netlist               > outputs/${TOP_DESIGN_NAME}_netlist.v
# write_hdl                   > outputs/${TOP_DESIGN_NAME}_netlist.v
write_sdc -view view_ff_v1p32 > outputs/${TOP_DESIGN_NAME}_ff_sdc.sdc
write_sdc -view view_ss_v1p08_125c > outputs/${TOP_DESIGN_NAME}_ss_sdc.sdc
write_sdc -view view_tt_v1p5_25c > outputs/${TOP_DESIGN_NAME}_tt_sdc.sdc
write_sdf   -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/${TOP_DESIGN_NAME}.sdf

# check timing
check_design -all           > report/${TOP_DESIGN_NAME}_check_design.txt
check_timing_intent -view view_ff_v1p32 > report/${TOP_DESIGN_NAME}_ff_check_timing.txt
check_timing_intent -view view_ss_v1p08_125c > report/${TOP_DESIGN_NAME}_ss_check_timing.txt
check_timing_intent -view view_tt_v1p5_25c > report/${TOP_DESIGN_NAME}_tt_check_timing.txt

# report
report_timing     -nets -path_type full_clock -nworst 20 -view view_ff_v1p32  > report/${TOP_DESIGN_NAME}_ff_report_timing.rpt
report_timing     -nets -path_type full_clock -nworst 20 -view view_ss_v1p08_125c  > report/${TOP_DESIGN_NAME}_ss_report_timing.rpt
report_timing     -nets -path_type full_clock -nworst 20 -view view_tt_v1p5_25c  > report/${TOP_DESIGN_NAME}_tt_report_timing.rpt
report_power                > report/${TOP_DESIGN_NAME}_report_power.rpt
report_area                 > report/${TOP_DESIGN_NAME}_report_area.rpt
report_qor                  > report/${TOP_DESIGN_NAME}_report_qor.rpt
report_design_rules         > report/${TOP_DESIGN_NAME}_design_rules.rpt
report_gates                > report/${TOP_DESIGN_NAME}_gates.rpt
report_messages             > report/${TOP_DESIGN_NAME}_messages.rpt
report_timing     -unconstrained -nworst 5 -view view_ff_v1p32  > report/${TOP_DESIGN_NAME}_ff_report_timing_unconstrained.rpt
report_timing     -unconstrained -nworst 5 -view view_ss_v1p08_125c  > report/${TOP_DESIGN_NAME}_ss_report_timing_unconstrained.rpt
report_timing     -unconstrained -nworst 5 -view view_tt_v1p5_25c  > report/${TOP_DESIGN_NAME}_tt_report_timing_unconstrained.rpt
#report_summary              -directory "report/${TOP_DESIGN_NAME}_summary.rpt"

#report_timing -from [all_inputs] -to [all_outputs] > report/${TOP_DESIGN_NAME}_report_timing.rpt
#report_timing -from [all_registers] -to [all_registers] > report/${TOP_DESIGN_NAME}_report_timing.rpt
#report_power                > report/${TOP_DESIGN_NAME}_report_power.rpt
#report_area                 > report/${TOP_DESIGN_NAME}_report_area.rpt
#report_qor                  > report/${TOP_DESIGN_NAME}_report_qor.rpt
#report_summary              -directory "report/${TOP_DESIGN_NAME}_summary.rpt"
#report_design_rules         > report/${TOP_DESIGN_NAME}_design_rules.rpt
#report_gates                > report/${TOP_DESIGN_NAME}_gates.rpt
#report_messages             > report/${TOP_DESIGN_NAME}_messages.rpt
#report_timing     -unconstrained          > report/${TOP_DESIGN_NAME}_report_timing_unconstrained.rpt