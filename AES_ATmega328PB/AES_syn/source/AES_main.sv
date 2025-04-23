`timescale 1ns / 10ps

module aes_main(clk,rst,data_in,key,data_out,encrypt_start,encrypt_done);
input clk;
input rst;
input [127:0] data_in,key;
output  [127:0] data_out;

input wire encrypt_start;
output reg encrypt_done;

wire [127:0] key_s,key_s0,key_s1,key_s2,key_s3,key_s4,key_s5,key_s6,key_s7,key_s8,key_s9;
wire [127:0]r_data_out,r0_data_out,r1_data_out,r2_data_out,r3_data_out,r4_data_out,r5_data_out,r6_data_out,r7_data_out,r8_data_out,r9_data_out;

assign r_data_out=data_in^key_s;

// State
localparam IDLE  = 0;
localparam ENCRYPT = 1;

reg state;
reg [5:0] process_cnt;

wire st;
assign st = state;

aes_key_expand_128 a0( clk,key, key_s,key_s0,key_s1,key_s2,key_s3,key_s4,key_s5,key_s6,key_s7,key_s8,key_s9);
round r0(clk,st,r_data_out,key_s0,r0_data_out);
round r1(clk,st,r0_data_out,key_s1,r1_data_out);
round r2(clk,st,r1_data_out,key_s2,r2_data_out);
round r3(clk,st,r2_data_out,key_s3,r3_data_out);
round r4(clk,st,r3_data_out,key_s4,r4_data_out);
round r5(clk,st,r4_data_out,key_s5,r5_data_out);
round r6(clk,st,r5_data_out,key_s6,r6_data_out);
round r7(clk,st,r6_data_out,key_s7,r7_data_out);
round r8(clk,st,r7_data_out,key_s8,r8_data_out);
last_round r9(clk,st,r8_data_out,key_s9,r9_data_out);


// main state machine
always@(posedge clk or negedge rst) begin
    if (!rst) begin
        state <= IDLE;
        process_cnt <= 0;
        encrypt_done <= 0;
    end else begin
        case (state)
            IDLE: begin
                encrypt_done <= 0;
                if (encrypt_start) begin
                    state <= ENCRYPT;
                end
            end

            ENCRYPT: begin
                process_cnt <= process_cnt + 1;
                if (process_cnt == 29) begin
                    encrypt_done <= 1;
                    process_cnt <= 0;
                    state <= IDLE;
                end else begin
                    encrypt_done <= 0;
                end
            end
        endcase
    end
end

// process counter
// always@(posedge clk) begin
//     if (!rst) begin
//         process_cnt <= 0;
//     end else begin
//         case (state)
//             IDLE: begin
//                 if (encrypt_start) begin
//                     state <= ENCRYPT;
//                 end
//             end

//             ENCRYPT: begin
//                 if (encrypt_done) begin
//                     state <= IDLE;
//                 end;
//             end
//         endcase
//     end
// end

assign data_out=r9_data_out;
endmodule
