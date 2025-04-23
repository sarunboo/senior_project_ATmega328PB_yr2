`timescale 1ns / 10ps

module round(clk,st,data_in,key_in,data_out);
input clk;
input st;
input [127:0]data_in,key_in;
output [127:0] data_out;

wire [127:0]sub_data_out,shift_data_out,mix_data_out; 

subbytes a1(clk,st,data_in,sub_data_out);
shiftrows a2(clk,st,sub_data_out,shift_data_out);
mixcolumn a3(clk,st,shift_data_out,mix_data_out);
assign data_out=mix_data_out^key_in;
endmodule



