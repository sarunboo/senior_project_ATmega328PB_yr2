
//input ports
add mapped point cp2 cp2 -type PI PI
add mapped point ireset ireset -type PI PI
add mapped point IO_Addr[5] IO_Addr[5] -type PI PI
add mapped point IO_Addr[4] IO_Addr[4] -type PI PI
add mapped point IO_Addr[3] IO_Addr[3] -type PI PI
add mapped point IO_Addr[2] IO_Addr[2] -type PI PI
add mapped point IO_Addr[1] IO_Addr[1] -type PI PI
add mapped point IO_Addr[0] IO_Addr[0] -type PI PI
add mapped point iore iore -type PI PI
add mapped point iowe iowe -type PI PI
add mapped point dbus_in[7] dbus_in[7] -type PI PI
add mapped point dbus_in[6] dbus_in[6] -type PI PI
add mapped point dbus_in[5] dbus_in[5] -type PI PI
add mapped point dbus_in[4] dbus_in[4] -type PI PI
add mapped point dbus_in[3] dbus_in[3] -type PI PI
add mapped point dbus_in[2] dbus_in[2] -type PI PI
add mapped point dbus_in[1] dbus_in[1] -type PI PI
add mapped point dbus_in[0] dbus_in[0] -type PI PI
add mapped point pinE_i[3] pinE_i[3] -type PI PI
add mapped point pinE_i[2] pinE_i[2] -type PI PI
add mapped point pinE_i[1] pinE_i[1] -type PI PI
add mapped point pinE_i[0] pinE_i[0] -type PI PI
add mapped point PUD PUD -type PI PI
add mapped point SLEEP SLEEP -type PI PI
add mapped point RSTDISBL RSTDISBL -type PI PI
add mapped point TWEN1 TWEN1 -type PI PI
add mapped point SPE1 SPE1 -type PI PI
add mapped point MSTR MSTR -type PI PI
add mapped point SCK1_OUT SCK1_OUT -type PI PI
add mapped point SPI1_MT_OUT SPI1_MT_OUT -type PI PI
add mapped point SCL1_OUT SCL1_OUT -type PI PI
add mapped point SDA1_OUT SDA1_OUT -type PI PI
add mapped point ADCxD[1] ADCxD[1] -type PI PI
add mapped point ADCxD[0] ADCxD[0] -type PI PI
add mapped point PCINT[3] PCINT[3] -type PI PI
add mapped point PCINT[2] PCINT[2] -type PI PI
add mapped point PCINT[1] PCINT[1] -type PI PI
add mapped point PCINT[0] PCINT[0] -type PI PI
add mapped point PCIE3 PCIE3 -type PI PI
add mapped point aco_oe aco_oe -type PI PI
add mapped point acompout acompout -type PI PI

//output ports
add mapped point out_en out_en -type PO PO
add mapped point dbus_out[7] dbus_out[7] -type PO PO
add mapped point dbus_out[6] dbus_out[6] -type PO PO
add mapped point dbus_out[5] dbus_out[5] -type PO PO
add mapped point dbus_out[4] dbus_out[4] -type PO PO
add mapped point dbus_out[3] dbus_out[3] -type PO PO
add mapped point dbus_out[2] dbus_out[2] -type PO PO
add mapped point dbus_out[1] dbus_out[1] -type PO PO
add mapped point dbus_out[0] dbus_out[0] -type PO PO
add mapped point DIE_o[3] DIE_o[3] -type PO PO
add mapped point DIE_o[2] DIE_o[2] -type PO PO
add mapped point DIE_o[1] DIE_o[1] -type PO PO
add mapped point DIE_o[0] DIE_o[0] -type PO PO
add mapped point pu_E[3] pu_E[3] -type PO PO
add mapped point pu_E[2] pu_E[2] -type PO PO
add mapped point pu_E[1] pu_E[1] -type PO PO
add mapped point pu_E[0] pu_E[0] -type PO PO
add mapped point dd_E[3] dd_E[3] -type PO PO
add mapped point dd_E[2] dd_E[2] -type PO PO
add mapped point dd_E[1] dd_E[1] -type PO PO
add mapped point dd_E[0] dd_E[0] -type PO PO
add mapped point pv_E[3] pv_E[3] -type PO PO
add mapped point pv_E[2] pv_E[2] -type PO PO
add mapped point pv_E[1] pv_E[1] -type PO PO
add mapped point pv_E[0] pv_E[0] -type PO PO
add mapped point die_E[3] die_E[3] -type PO PO
add mapped point die_E[2] die_E[2] -type PO PO
add mapped point die_E[1] die_E[1] -type PO PO
add mapped point die_E[0] die_E[0] -type PO PO

//inout ports




//Sequential Pins
add mapped point IO_Port_E_inst/rg_md_ddrx_inst/rg_current[0]/q IO_Port_E_inst/rg_md_ddrx_inst/rg_current_reg[0]/Q -type DFF DFF
add mapped point IO_Port_E_inst/rg_md_ddrx_inst/rg_current[1]/q IO_Port_E_inst/rg_md_ddrx_inst/rg_current_reg[1]/Q -type DFF DFF
add mapped point IO_Port_E_inst/rg_md_ddrx_inst/rg_current[2]/q IO_Port_E_inst/rg_md_ddrx_inst/rg_current_reg[2]/Q -type DFF DFF
add mapped point IO_Port_E_inst/rg_md_ddrx_inst/rg_current[3]/q IO_Port_E_inst/rg_md_ddrx_inst/rg_current_reg[3]/Q -type DFF DFF
add mapped point IO_Port_E_inst/rg_md_portx_inst/rg_current[0]/q IO_Port_E_inst/rg_md_portx_inst/rg_current_reg[0]/Q -type DFF DFF
add mapped point IO_Port_E_inst/rg_md_portx_inst/rg_current[2]/q IO_Port_E_inst/rg_md_portx_inst/rg_current_reg[2]/Q -type DFF DFF
add mapped point IO_Port_E_inst/rg_md_portx_inst/rg_current[3]/q IO_Port_E_inst/rg_md_portx_inst/rg_current_reg[3]/Q -type DFF DFF
add mapped point IO_Port_E_inst/rg_md_portx_inst/rg_current[1]/q IO_Port_E_inst/rg_md_portx_inst/rg_current_reg[1]/Q -type DFF DFF
add mapped point IO_Port_E_inst/synchronizer_pinx_inst/d_sync_int[3]/q IO_Port_E_inst/synchronizer_pinx_inst/d_sync_int_reg[3]/Q -type DFF DFF
add mapped point IO_Port_E_inst/synchronizer_pinx_inst/d_sync_int[2]/q IO_Port_E_inst/synchronizer_pinx_inst/d_sync_int_reg[2]/Q -type DFF DFF
add mapped point IO_Port_E_inst/synchronizer_pinx_inst/d_sync_int[0]/q IO_Port_E_inst/synchronizer_pinx_inst/d_sync_int_reg[0]/Q -type DFF DFF
add mapped point IO_Port_E_inst/synchronizer_pinx_inst/d_sync_int[1]/q IO_Port_E_inst/synchronizer_pinx_inst/d_sync_int_reg[1]/Q -type DFF DFF
add mapped point IO_Port_E_inst/synchronizer_pinx_inst/d_latch[2]/q IO_Port_E_inst/synchronizer_pinx_inst/d_latch_reg[2]/Q -type DLAT DLAT
add mapped point IO_Port_E_inst/synchronizer_pinx_inst/d_latch[0]/q IO_Port_E_inst/synchronizer_pinx_inst/d_latch_reg[0]/Q -type DLAT DLAT
add mapped point IO_Port_E_inst/synchronizer_pinx_inst/d_latch[1]/q IO_Port_E_inst/synchronizer_pinx_inst/d_latch_reg[1]/Q -type DLAT DLAT
add mapped point IO_Port_E_inst/synchronizer_pinx_inst/d_latch[3]/q IO_Port_E_inst/synchronizer_pinx_inst/d_latch_reg[3]/Q -type DLAT DLAT



//Black Boxes



//Empty Modules as Blackboxes
