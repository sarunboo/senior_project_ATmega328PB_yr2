`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module aes_main_tb;

    reg             clk;
	reg				rst;
    reg [127:0]     data_in;
    reg [127:0]     key;
	reg				encrypt_start;

	wire [127:0]	data_out;
	wire			encrypt_done;

	aes_main uut (
	//input signals
		.clk			(clk),
		.rst			(rst),
		.data_in		(data_in),
		.key			(key),
		.encrypt_start	(encrypt_start),
	//output signals
		.data_out		(data_out),
		.encrypt_done	(encrypt_done)
	);

	reg [3:0] 		TESTCASE;
	reg [127:0]		expected_out;

	parameter period = 50 ;

	always begin
		#(period/2) clk =1'b1;
		#(period/2) clk =1'b0;
	end 
	
	initial
	begin
		// input data
		// Example Input 

		// data_in = 128'h00112233445566778899aabbccddeeff;
		// key = 128'h000102030405060708090a0b0c0d0e0f;
		// expected_out = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;

		data_in = 128'h3243f6a8885a308d313198a2e0370734;
		key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
		expected_out = 128'h3925841D02DC09FBDC118597196A0B32;

		// initialize module
		clk = 0;
		rst = 0;
		encrypt_start = 1'b0;
		#(1*period);
		rst = 1;
		TESTCASE = 4'd0;

		#(9*period);

		encrypt_start = 1'b1;
		#(1*period);
		encrypt_start = 1'b0;

		#(29*period);

		TESTCASE = 4'd1;
		if (data_out == expected_out) begin
            $display("PASS: Encryption is correct with the encrypted data: %0b", data_out);
        end else begin
            $display("FAIL: Expected %0b, but got %0b", expected_out, data_out);
        end
		#(4*period);

		$stop;
	end

endmodule