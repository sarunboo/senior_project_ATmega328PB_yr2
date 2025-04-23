`timescale 1ns / 10ps

module cbc_logic (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire [127:0] plaintext,
    input  wire [127:0] key,
    input  wire [127:0] iv,
    input  wire         new_message,  // set to 1 for first block (to reset prev_cipher)
    output reg          done,
    output reg  [127:0] ciphertext,

    // Connect to your AES core
    output wire         aes_start,
    input  wire         aes_done,
    output wire [127:0] aes_plaintext,
    output wire [127:0] aes_key,
    input  wire [127:0] aes_ciphertext
);

    reg [127:0] prev_cipher;
    reg [127:0] xored_input;
    reg         busy;

    assign aes_start     = start & ~busy;
    assign aes_plaintext = xored_input;
    assign aes_key       = key;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            prev_cipher <= 0;
            xored_input <= 0;
            done <= 0;
            busy <= 0;
        end else begin
            done <= 0;

            if (start && !busy) begin
                busy <= 1;
                if (new_message)
                    prev_cipher <= iv;

                xored_input <= plaintext ^ (new_message ? iv : prev_cipher);
            end

            if (busy && aes_done) begin
                ciphertext <= aes_ciphertext;
                prev_cipher <= aes_ciphertext; // update for next block
                done <= 1;
                busy <= 0;
            end
        end
    end
endmodule
