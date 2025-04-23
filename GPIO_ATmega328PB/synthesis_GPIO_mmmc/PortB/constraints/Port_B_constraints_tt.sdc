# #########################################################################
# Cadence genus synthesis design constraints
# AUTHOR : Rapin.P
# DATE : 15/11/20204
# #########################################################################

set TOP_DESIGN_NAME     "Port_B"
set TARGET_LIBRARY      "scc013ull_hd_rvt_tt_v1p5_25c_basic"
set_dont_use            [get_lib_cells ${TARGET_LIBRARY}/SD*]
set_dont_use            [get_lib_cells ${TARGET_LIBRARY}/SE*]
set_dont_use            [get_lib_cells ${TARGET_LIBRARY}/SN*]
# ----------------------------------------------------------------------------
# 1. Create Clock
# ----------------------------------------------------------------------------

# Assume 20MHz for cp2
create_clock -name CLK -period 50 [ get_ports "cp2" ]

# Apply uncertainty factor on all clocks
set_clock_uncertainty -setup 1.00                           [get_clocks]
set_clock_uncertainty -hold  0.25                           [get_clocks]
# Clock properties in Max Condition
set_clock_latency    1 -max -source -early  [get_clocks]
set_clock_latency    1.25 -max -source -late   [get_clocks]
set_clock_latency    1.00 -max                              [get_clocks]
set_clock_transition 0.50 -max                              [get_clocks]
# Clock properties in Min Condition
set_clock_latency    0.50 -min -source -early [get_clocks]
set_clock_latency    0.75 -min -source -late  [get_clocks]
set_clock_latency    1.00 -min                              [get_clocks]
set_clock_transition 0.30 -min                              [get_clocks]

# set_clock_groups -asynchronous -group CLK -group CLK2 -allow_path
# create_clock -name wdt_clk -period 50 [ get_ports wdt_clk ]

# ----------------------------------------------------------------------------
# 1.2 Create Clock for Latches
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# 1.1 Identyfy Clock gating
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# 1.1 Check Clock gating
# ----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# 2. Global Delay
# -----------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# 3. Ideal Network for clock
# ------------------------------------------------------------------------------
set_ideal_network -no_propagate [get_nets cp2]
#set_ideal_network -no_propagate [get_nets PLS_m/SPI_m/O_CLK]
#set_ideal_network -no_propagate [get_pins "AES_Controlpath/BUF_*_CG/GC AES_Controlpath/DATA_*_CG/GC AES_Controlpath/KEY_*_CG/GC AES_Controlpath/CLK_Control_CG/GC"]
# ------------------------------------------------------------------------------
# 4. False Path and Multicycle if you have ?
# ------------------------------------------------------------------------------
set_false_path -through [get_cells IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[0]]
set_false_path -through [get_cells IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[1]]
set_false_path -through [get_cells IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[2]]
set_false_path -through [get_cells IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[3]]
set_false_path -through [get_cells IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[4]]
set_false_path -through [get_cells IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[5]]
set_false_path -through [get_cells IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[6]]
set_false_path -through [get_cells IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[7]]

set_false_path -from [get_ports pinB_i[0]] -to [get_pins IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[0]/D]
set_false_path -from [get_ports pinB_i[1]] -to [get_pins IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[1]/D]
set_false_path -from [get_ports pinB_i[2]] -to [get_pins IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[2]/D]
set_false_path -from [get_ports pinB_i[3]] -to [get_pins IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[3]/D]
set_false_path -from [get_ports pinB_i[4]] -to [get_pins IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[4]/D]
set_false_path -from [get_ports pinB_i[5]] -to [get_pins IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[5]/D]
set_false_path -from [get_ports pinB_i[6]] -to [get_pins IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[6]/D]
set_false_path -from [get_ports pinB_i[7]] -to [get_pins IO_Port_B_inst/synchronizer_pinx_inst/d_latch_reg[7]/D]
# ------------------------------------------------------------------------------
# 4. Input/Output Contraints
# ------------------------------------------------------------------------------

set_input_delay 10 -clock CLK             [all_inputs ]
set_output_delay 10 -clock CLK             [all_outputs]


# Clock signals
remove_input_delay                        [get_ports "cp2" ]
# Reset signals
remove_input_delay                        [get_ports "ireset"   ]
# ------------------------------------------------------------------------------
# 5. Driving Cell/Output Load Contraints
# ------------------------------------------------------------------------------

set_driving_cell -lib_cell BUFHDV8RD  [all_inputs]
remove_driving_cell [get_ports "cp2"]
set_driving_cell -lib_cell CLKBUFHDV32  [get_ports "cp2"]
#set_driving_cell -lib_cell BUFX12 [get_ports "ABE_CPR_RFCLK APM_CPR_PORSYS"]

#set_load -max [DQHDV0] [all_outputs]
#set_load -min [DQHDV0] [all_outputs]

#set_load -max [ load_of scc013ull_hd_rvt_tt_v1p5_25c_basic/DQHDV0/D] [all_outputs]
#set_load -min [ load_of scc013ull_hd_rvt_tt_v1p5_25c_basic/DQHDV0/D] [all_outputs]
set_load -max 0.0022433 [all_outputs]
set_load -min 0.0022335 [all_outputs]

#set_load -max -lib_cell DFFX4 [all_outputs]
#set_load -min -lib_cell DFFX4 [all_outputs]


# ------------------------------------------------------------------------------
# 6. Exclusion list for clock gating
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# 7. Interclock Relation
# ------------------------------------------------------------------------------
# report_interclock_relation > outputs/${TOP_DESIGN_NAME}.report_interclock_relation.before.rpt
# set_clock_groups -asynchronous -group PCLK -group QSCLK -allow_path

#set_clock_groups -asynchronous         -group CLK_PA0

# report_interclock_relation > outputs/${TOP_DESIGN_NAME}.report_interclock_relation.after.rpt

report_clocks > /nfs/mcu8b/sarun/synthesis_GPIO_mmmc/PortB/outputs/${TOP_DESIGN_NAME}.report_clock.rpt
#report_clock_tree > outputs/${TOP_DESIGN_NAME}.report_clock_tree.rpt
#report_clock_tree -summary > outputs/${TOP_DESIGN_NAME}.report_clock_tree.summary.rpt
# report_interclock_relation > outputs/${TOP_DESIGN_NAME}.report_interclock_relation.rpt
report_disable_timing > /nfs/mcu8b/sarun/synthesis_GPIO_mmmc/PortB/outputs/${TOP_DESIGN_NAME}.report_disable_timing.rpt