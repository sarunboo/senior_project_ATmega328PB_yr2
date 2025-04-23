`timescale 1ns / 10ps

module last_round(clk,st,data_in,key_in,data_out_last);
input clk;
input st;
input [127:0]data_in;
input [127:0]key_in;
output [127:0] data_out_last;

wire [127:0] sub_data_out,shift_data_out;

subbytes s1(clk,st,data_in,sub_data_out);
shiftrows s2(clk,st,sub_data_out,shift_data_out);
assign data_out_last=shift_data_out^key_in;


endmodule


