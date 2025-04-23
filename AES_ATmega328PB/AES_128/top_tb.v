`timescale 1ns / 10ps

module top_tb;

    reg clk = 0;
    reg rst = 0;

    // SPI interface
    reg sck = 0;
    reg mosi = 0;
    reg ss = 1;
    wire miso;

    // Expected Output 
    // reg [127:0] ciphertext = 128'h925943E85856C44979B72A069817C3AA; // expected output (1st block)
    // reg [127:0] ciphertext2 = 128'h99DEC033E2982816778D334AAE9FD0C7; // expected output (2nd block)
    // reg [127:0] ciphertext3 = 128'hD514784287F8B45B24D6916F57B21F51; // expected output (3rd block)

    reg [127:0] ciphertext = 128'h9782B8E6186C948BCAA6FB177449444E; // expected output (1st block)
    reg [127:0] ciphertext2 = 128'hBECCCAF9D1BB403F5F76EF6E24CF92AB; // expected output (2nd block)
    reg [127:0] ciphertext3 = 128'hA99D81A84B166E88BA60CA9D469AD783; // expected output (3rd block)
    reg [127:0] ciphertext4 = 128'hB2773969D4CD7FDB3702768D0377E0D8; // expected output (4th block)
    reg [127:0] ciphertext5 = 128'hF4B28ACE0D3065A5CC11565D925F988B; // expected output (5th block)

    reg [127:0] received_ct;
    reg [7:0] tmp;

    parameter clk_period = 50 ;
    parameter sck_period = 100 ;

    // Clock generation (system clk = 20 MHz)
    always #(clk_period/2) clk = ~clk;

    // SPI clock generation (sck = 10 MHz)
    always #(sck_period/2) sck = ~sck;

    // Instantiate Unit Under Test
    aes_top uut (
        .clk(clk),
        .rst(rst),
        .sck(sck),
        .mosi(mosi),
        .ss(ss),
        .miso(miso)
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
        $display("Starting AES_TOP Testbench...");
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
        // send_block(128'h112233445566778899AABBCCDDEEFF00);
        send_block(128'hd1cddc70c7720d9aafac5065a84ea579);

        // Trigger AES encryption (first message)
        send_command(8'h06);
        // #(4*clk_period);
        // encryption_done <= 1;
        // #(4*clk_period);
        // encryption_done <= 0;     
        
        // Read ciphertext
        send_command(8'h05);
        read_block(received_ct);

        $display("Received Ciphertext: %h", received_ct);
        if (received_ct == ciphertext)
            $display("Test Passed: Ciphertext matches expected output");
        else
            $display("Test Failed: Ciphertext mismatch");

        // Send plaintext (next message)
        send_command(8'h01);
        // send_block(128'h112233445566778899AABBCCDDEEFF00);
        send_block(128'haa884e36768f1d178ae26cbdfbe938cd);

        // Trigger AES encryption (next message)
        send_command(8'h04);
        // #(4*clk_period);
        // encryption_done <= 1;
        // #(4*clk_period);
        // encryption_done <= 0;

        // Read ciphertext (next message)
        send_command(8'h05);
        read_block(received_ct);

        #(40*clk_period);

        $display("Received Ciphertext: %h", received_ct);
        if (received_ct == ciphertext2)
            $display("Test Passed: Ciphertext matches expected output");
        else
            $display("Test Failed: Ciphertext mismatch");

        // Send plaintext (next message)
        send_command(8'h01);
        // send_block(128'h112233445566778899AABBCCDDEEFF00);
        send_block(128'hc265c4b8fb4d7befe5b9435606bb007d);

        // Trigger AES encryption (next message)
        send_command(8'h04);
        // #(4*clk_period);
        // encryption_done <= 1;
        // #(4*clk_period);
        // encryption_done <= 0;

        // Read ciphertext (next message)
        send_command(8'h05);
        read_block(received_ct);

        #(40*clk_period);

        $display("Received Ciphertext: %h", received_ct);
        if (received_ct == ciphertext3)
            $display("Test Passed: Ciphertext matches expected output");
        else
            $display("Test Failed: Ciphertext mismatch");

        // Send plaintext (next message)
        send_command(8'h01);
        // send_block(128'h112233445566778899AABBCCDDEEFF00);
        send_block(128'h721dd6557e81948871dbd5dffd807c75);

        // Trigger AES encryption (next message)
        send_command(8'h04);
        // #(4*clk_period);
        // encryption_done <= 1;
        // #(4*clk_period);
        // encryption_done <= 0;

        // Read ciphertext (next message)
        send_command(8'h05);
        read_block(received_ct);

        #(40*clk_period);

        $display("Received Ciphertext: %h", received_ct);
        if (received_ct == ciphertext4)
            $display("Test Passed: Ciphertext matches expected output");
        else
            $display("Test Failed: Ciphertext mismatch");

        // Send plaintext (next message)
        send_command(8'h01);
        // send_block(128'h112233445566778899AABBCCDDEEFF00);
        send_block(128'h88a50a1a563b7fea20fe8bee6425382a);

        // Trigger AES encryption (next message)
        send_command(8'h04);
        // #(4*clk_period);
        // encryption_done <= 1;
        // #(4*clk_period);
        // encryption_done <= 0;

        // Read ciphertext (next message)
        send_command(8'h05);
        read_block(received_ct);

        #(40*clk_period);

        $display("Received Ciphertext: %h", received_ct);
        if (received_ct == ciphertext5)
            $display("Test Passed: Ciphertext matches expected output");
        else
            $display("Test Failed: Ciphertext mismatch");
        $stop;
    end
endmodule
