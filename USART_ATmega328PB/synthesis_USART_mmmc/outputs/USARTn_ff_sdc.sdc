# ####################################################################

#  Created by Genus(TM) Synthesis Solution 22.10-p001_1 on Wed Mar 12 23:42:25 +07 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design USARTn

create_clock -name "CLK" -period 50.0 -waveform {0.0 25.0} [get_ports cp2]
set_clock_transition -min 0.3 [get_clocks CLK]
set_clock_transition -max 0.5 [get_clocks CLK]
set_load -pin_load 0.0022 [get_ports out_en]
set_load -pin_load 0.0022 [get_ports {dbus_out[7]}]
set_load -pin_load 0.0022 [get_ports {dbus_out[6]}]
set_load -pin_load 0.0022 [get_ports {dbus_out[5]}]
set_load -pin_load 0.0022 [get_ports {dbus_out[4]}]
set_load -pin_load 0.0022 [get_ports {dbus_out[3]}]
set_load -pin_load 0.0022 [get_ports {dbus_out[2]}]
set_load -pin_load 0.0022 [get_ports {dbus_out[1]}]
set_load -pin_load 0.0022 [get_ports {dbus_out[0]}]
set_load -pin_load 0.0022 [get_ports UMSEL]
set_load -pin_load 0.0022 [get_ports XCKn_o]
set_load -pin_load 0.0022 [get_ports TxDn_o]
set_load -pin_load 0.0022 [get_ports RXENn]
set_load -pin_load 0.0022 [get_ports TXENn]
set_load -pin_load 0.0022 [get_ports TxcIRQ]
set_load -pin_load 0.0022 [get_ports RxcIRQ]
set_load -pin_load 0.0022 [get_ports UdreIRQ]
set_load -pin_load 0.0022 [get_ports UStBIRQ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[11]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[10]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[9]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[8]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[7]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[6]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[5]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[4]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[3]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[2]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[1]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {ram_Addr[0]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports ramre]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports ramwe]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_in[7]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_in[6]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_in[5]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_in[4]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_in[3]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_in[2]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_in[1]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_in[0]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports DDR_XCKn]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports XCKn_i]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports RxDn_i]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {irqack_addr[5]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {irqack_addr[4]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {irqack_addr[3]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {irqack_addr[2]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {irqack_addr[1]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {irqack_addr[0]}]
set_input_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports irqack]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports out_en]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_out[7]}]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_out[6]}]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_out[5]}]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_out[4]}]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_out[3]}]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_out[2]}]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_out[1]}]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports {dbus_out[0]}]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports UMSEL]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports XCKn_o]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports TxDn_o]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports RXENn]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports TXENn]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports TxcIRQ]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports RxcIRQ]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports UdreIRQ]
set_output_delay -clock [get_clocks CLK] -add_delay 10.0 [get_ports UStBIRQ]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports ireset]
set_driving_cell -lib_cell CLKBUFHDV32 -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports cp2]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[11]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[10]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[9]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[8]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[7]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[6]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[5]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[4]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[3]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[2]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[1]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {ram_Addr[0]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports ramre]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports ramwe]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {dbus_in[7]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {dbus_in[6]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {dbus_in[5]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {dbus_in[4]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {dbus_in[3]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {dbus_in[2]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {dbus_in[1]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {dbus_in[0]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports DDR_XCKn]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports XCKn_i]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports RxDn_i]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {irqack_addr[5]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {irqack_addr[4]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {irqack_addr[3]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {irqack_addr[2]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {irqack_addr[1]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports {irqack_addr[0]}]
set_driving_cell -lib_cell BUFHDV8RD -library scc013ull_hd_rvt_ff_v1p32_-40c_basic -pin "Z" [get_ports irqack]
set_ideal_network -no_propagate [get_nets cp2]
set_wire_load_mode "enclosed"
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDGRNQHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDGRNQHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDGRNQHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDGRNQHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDGRNQNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDGRNQNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDGRNQNHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDGRNQNHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDQHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDQHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDQHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDQHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDQNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDQNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDQNHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDQNHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRNQHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRNQHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRNQHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRNQHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRNQNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRNQNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRNQNHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRNQNHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRQHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRQHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRQHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRQHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRQNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRQNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRQNHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRQNHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRSNQHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRSNQHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRSNQHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRSNQHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRSNQNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRSNQNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRSNQNHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDRSNQNHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDSNQHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDSNQHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDSNQHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDSNQHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDSNQNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDSNQNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDSNQNHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDSNQNHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDXHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDXHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SDXHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDQHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDQHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDQHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDQHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDQNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDQNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDQNHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDQNHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDRNQHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDRNQHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDRNQHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDRNQHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDRNQNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDRNQNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDRNQNHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SEDRNQNHDV8]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDRNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDRNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDRNHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDRSNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDRSNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDRSNHDV4]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDSNHDV0]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDSNHDV2]
set_dont_use true [get_lib_cells scc013ull_hd_rvt_ff_v1p32_-40c_basic/SNDSNHDV4]
set_clock_latency  1.0 [get_clocks CLK]
set_clock_latency -source -max -late 1.25 [get_clocks CLK]
set_clock_latency -source -max -early 1.0 [get_clocks CLK]
set_clock_latency -source -min -early 0.5 [get_clocks CLK]
set_clock_latency -source -min -late 0.75 [get_clocks CLK]
set_clock_uncertainty -setup 1.0 [get_clocks CLK]
set_clock_uncertainty -hold 0.25 [get_clocks CLK]
