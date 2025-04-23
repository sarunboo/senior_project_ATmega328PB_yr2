`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module usart_test_tb;
	
	reg 			ireset;
	reg			cp2;
	reg [11:0]      	ram_Addr;
	reg            		ramre;
	reg            		ramwe;
	wire         		out_en;
	reg [7:0]      		dbus_in;
	wire [7:0] 		dbus_out;

	reg  			DDR_XCKn;
	wire			UMSEL;
	reg 			XCKn_i;
	wire			XCKn_o;

	reg			RxDn_i;
	wire           		TxDn_o;

	wire			RXENn;
	wire			TXENn;

	wire      		TxcIRQ;
	wire      		RxcIRQ;
	wire      		UdreIRQ;
	wire      		UStBIRQ;

	reg [5:0]		irqack_addr;
	reg			 irqack;
	
		
	wire [7:0]		UDRn;
	wire [7:0]   		UCSRnA;
	wire [7:0] 		UCSRnB;
	wire [7:0]		UCSRnC;
	wire [11:0] 		UBRRn;

	wire			XCKn_transfer;	//unused
	wire			TxDn_RxDn;
	

	USARTn uut (
	//input signals
		.ireset(ireset),
		.cp2(cp2),
		.ram_Addr(ram_Addr),
		.ramre(ramre),
		.ramwe(ramwe),
		.dbus_in(dbus_in),
		.DDR_XCKn(DDR_XCKn),
		.XCKn_i(XCKn_i),	
		.RxDn_i(TxDn_RxDn),	//connects RxDn_i with TxDn_o
		.irqack_addr(irqack_addr),
		.irqack(irqack),
	//output signals
		.out_en(out_en),
		.dbus_out(dbus_out),
		.UMSEL(UMSEL),
		.XCKn_o(XCKn_o),	
		.TxDn_o(TxDn_RxDn),	//connects RxDn_i with TxDn_o
		.RXENn(RXENn),
		.TXENn(TXENn),
		.TxcIRQ(TxcIRQ),
		.RxcIRQ(RxcIRQ),
		.UdreIRQ(UdreIRQ),
		.UStBIRQ(UStBIRQ)
	);

	parameter period = 50 ;

	always begin
		#(period/2) cp2 =1'b1 ;
		#(period/2) cp2 =1'b0 ;
	end 

	

	initial //reset module, lenght: 2
	begin 
	ireset = 1'b1;
	#(1*period);
	ireset = 1'b0;
	#(1*period);
	ireset = 1'b1;
	end

	initial 
	begin
		#(10*1000*1000); //test time = 10 ms
		$finish;
	end

	initial
	begin 

	#(2*period); // wait until reset done

	//set baud rate (for asynchronous mode)
	ram_Addr = 12'h0C5; //UBRRnH addr
	dbus_in = 8'b00000000;
	ramwe = 1'b1;
	#(1*period);
	ram_Addr = 12'h0C4; // UBRRnH addr
	dbus_in = 8'b10000001; // set UBRRn
	ramwe = 1'b1;
	#(1*period);
	ramwe = 1'b0;
	#(1*period);

	//Write to UCSRnA
	ram_Addr = 12'h0C0; //UCSRnA addr
	dbus_in = 8'b00000000; // Default (enable 2xSpeed or MPCM)
	ramwe = 1'b1;
	#(1*period);
	ramwe = 1'b0;
	#(1*period);

	//Write to UCSRnB
	ram_Addr = 12'h0C1; //UCSRnB addr
	dbus_in = 8'b00011000; // enables TXEN-RXEN (and enable/write ninth-bit to TXB8n)
	ramwe = 1'b1;
	#(1*period);
	ramwe = 1'b0;
	#(1*period);

	//Write to UCSRnC
	ram_Addr = 12'h0C2; //UCSRnC addr
	dbus_in = 8'b00001000; // Select Mode and Set Frame Format
	ramwe = 1'b1;
	#(1*period);
	ramwe = 1'b0;
	#(1*period);

	//load byte to send
	#(1041*20*period)

	ram_Addr = 12'h0C6;
	dbus_in = 8'b01100101;	// first data
	ramwe = 1'b1;
	#(1*period);

	ramwe = 1'b0;
	#(10*period);

	dbus_in = 8'b01010101;	// second data
	ramwe = 1'b1;
	#(1*period);

	ramwe = 1'b0;
	#(10*period);
/*
// test TX overflow
	dbus_in = 8'b00111001;
	ramwe = 1'b1;
	#(1*period);

	ramwe = 1'b0;
	#(10*period);
/*
	dbus_in = 8'b01111111;
	ramwe = 1'b1;
	#(1*period);

	ramwe = 1'b0;
	#(1*period);
*/
	end

	initial
	begin
	
	#(1041*20*period)
	#(1041*20*period)
	#(1041*20*period)
	#(1041*20*period)
/*
	ram_Addr = 12'h0C0; //read RXC TXC UDRE from USCRnA
	ramre = 1'b1;
	#(1*period);
	ramre = 1'b0;
	#(1*period);
*/
	ram_Addr = 12'h0C1; //change ram_Addr back to UDRn in order to read the 8 low bits
	ramre = 1'b1;
	#(1*period);
	ramre = 1'b0;
	#(1*period);

	ram_Addr = 12'h0C6;
	ramre = 1'b1;
	#(1*period);
	ramre = 1'b0;
	#(1*period);

	ram_Addr = 12'h0C6;
	ramre = 1'b1;
	#(1*period);
	ramre = 1'b0;
	#(1*period);

	ram_Addr = 12'h0C6;
	ramre = 1'b1;
	#(1*period);
	ramre = 1'b0;
	#(1*period);

/*
	ram_Addr = 12'h0C0; //clear TXCn flag
	dbus_in = 8'b01000000;
	ramwe = 1'b1;
	#(1*period);
	ramwe = 1'b0;
	#(1*period);
*/

	//test interrupt acknowledge of TXCIRQ
	#(1041*20*period)
	irqack_addr = 6'h14;
	irqack = 1'b1;
	#(1*period);
	irqack = 1'b0;

	end

endmodule
