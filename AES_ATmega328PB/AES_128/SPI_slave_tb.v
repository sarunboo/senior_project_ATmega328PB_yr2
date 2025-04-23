`timescale 1ns / 10ps

module spi_slave_tb;

    reg clk = 0;
    reg rst = 0;

    // SPI interface
    reg sck = 0;
    reg mosi = 0;
    reg ss = 1;
    wire miso;

    // AES signals
    wire start_encryption;
    reg encryption_done = 0;
    wire [127:0] plaintext, key, iv;
    reg  [127:0] ciphertext = 128'hCAFEBABE_DEADBEEF_FEEDFACE_01234567;

    reg [127:0] received_ct;
    reg [7:0] tmp;

    parameter clk_period = 50 ;
    parameter sck_period = 500 ;

    // Clock generation (system clk = 20 MHz)
    always #(clk_period/2) clk = ~clk;

    // SPI clock generation (sck = 2 MHz)
    always #(sck_period/2) sck = ~sck;

    // Instantiate Unit Under Test
    spi_slave uut (
        .clk(clk),
        .rst(rst),
        .sck(sck),
        .mosi(mosi),
        .ss(ss),
        .miso(miso),
        .start_encryption(start_encryption),
        .new_message(new_message),
        .encryption_done(encryption_done),
        .plaintext(plaintext),
        .key(key),
        .iv(iv),
        .ciphertext(ciphertext)
    );

    // SPI master task
    task spi_write(input [7:0] byte);
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge sck);
                mosi <= byte[i];
            end
        end
    endtask

    task spi_read(output [7:0] byte);
        integer i;
        begin
            byte = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge sck);
                byte[i] = miso;
            end
        end
    endtask

    task send_command(input [7:0] cmd);
        begin
            ss <= 0;
            spi_write(cmd);
            #(sck_period)
            ss <= 1;
            #(40*clk_period);
        end
    endtask

    task send_block(input [127:0] data);
        integer i;
        begin
            ss <= 0;
            for (i = 15; i >= 0; i = i - 1)
                spi_write(data[i*8 +: 8]);
            #(sck_period)
            ss <= 1;
            #(40*clk_period);
        end
    endtask

    task read_block(output [127:0] data_out);
        integer i;
        begin
            ss <= 0;
            #(sck_period)
            for (i = 15; i >= 0; i = i - 1) begin
                spi_read(tmp);
                data_out[i*8 +: 8] <= tmp;
            end
            ss <= 1;
            #(40*clk_period);
        end
    endtask

    // Main test procedure
    initial begin
        $display("Starting AES SPI Slave Testbench...");
        #(2*clk_period);
        rst <= 1;
        #(4*clk_period);

        // Send key
        send_command(8'h02);
        send_block(128'h00112233445566778899AABBCCDDEEFF);

        // Send IV
        send_command(8'h03);
        send_block(128'hAABBCCDDEEFF00112233445566778899);

        // Send plaintext
        send_command(8'h01);
        send_block(128'h112233445566778899AABBCCDDEEFF00);

        // Trigger AES encryption (first message)
        send_command(8'h06);
        #(4*clk_period);
        encryption_done <= 1;
        #(4*clk_period);
        encryption_done <= 0;

        // Trigger AES encryption (remaining message)
        send_command(8'h04);
        #(4*clk_period);
        encryption_done <= 1;
        #(4*clk_period);
        encryption_done <= 0;

        // Read ciphertext
        send_command(8'h05);
        // reg [127:0] received_ct;
        read_block(received_ct);
        #(4*clk_period);

        $display("Received Ciphertext: %h", received_ct);
        if (received_ct == ciphertext)
            $display("Test Passed: Ciphertext matches expected output");
        else
            $display("Test Failed: Ciphertext mismatch");

        $stop;
    end
endmodule
