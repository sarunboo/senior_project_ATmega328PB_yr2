`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module usart_test_tb3;

	localparam				Usart_0=0,
							Usart_1=1;
		
	
	reg					core_ireset;
	reg					cp2;
	reg [12-1:0] 		core_ramadr; 
	reg 				core_ramre; 
	reg 				core_ramwe; 
	wire [7:0] 				data_bus[0:1] ;
	wire 					d_en_bus[0:1] ;	
	reg [7:0] 			core_dbusout; 
	wire [45-1:0] 			core_irqlines;
	reg      			core_irqack;
	reg [5:0] 			core_irqackad;
	
	wire					TXD0;
	wire					TXD1;
	wire					TXEN0;
	wire					TXEN1;
	wire					RXEN0;
	wire					RXEN1;
	wire					XCK0_OUT;
	wire					XCK1_OUT;
	reg					DDR_XCK0;
	reg					DDR_XCK1;
	wire					UMSEL0;
	wire					UMSEL1;
	
	reg [7:0]			DID_int;	// .XCKn_i 	(DID_int[4]), .RxDn_i 	(DID_int[0])
	reg [7:0]			DIB_int;	// .XCKn_i 	(DIB_int[5]), .RxDn_i 	(DIB_int[4])
	
	wire			XCKn_transfer;
	wire			TxDn_RxDn;
	
	
	USARTn #(
		.UDRn_Address 		(12'h0C6) ,
	    .UCSRnA_Address 	(12'h0C0) ,
	    .UCSRnB_Address 	(12'h0C1) ,
	    .UCSRnC_Address 	(12'h0C2) ,
	    .UBRRnH_Address 	(12'h0C5) ,
	    .UBRRnL_Address 	(12'h0C4) ,
	    .RxcIRQ_Address 	(6'h12) ,
	    .UdreIRQ_Address 	(6'h13) ,
	    .TxcIRQ_Address 	(6'h14) ,
	    .UStBIRQ_Address 	(6'h1A)
	)USARTn_0_inst(
		.ireset		(core_ireset),
		.cp2		(cp2),
		.ram_Addr 	(core_ramadr),
		.ramre 		(core_ramre),
		.ramwe 		(core_ramwe),
		.out_en 	(d_en_bus[Usart_0]),
		.dbus_in 	(core_dbusout),
		.dbus_out 	(data_bus[Usart_0]),
		.DDR_XCKn 	(DDR_XCK0),
		.UMSEL		(UMSEL0),
		.XCKn_i 	(XCK1_OUT), //
		.XCKn_o 	(XCK0_OUT), //
		.RxDn_i 	(TXD1), //
		.TxDn_o 	(TXD0), //
		.RXENn 		(RXEN0),
		.TXENn 		(TXEN0),
		.RxcIRQ 	(core_irqlines[18]),
		.UdreIRQ	(core_irqlines[19]), 
		.TxcIRQ 	(core_irqlines[20]),
		.UStBIRQ	(core_irqlines[26]),
		.irqack_addr(core_irqackad),
		.irqack		(core_irqack)
	);
	
	USARTn #(
		.UDRn_Address 		(12'h0C7) ,
	    .UCSRnA_Address 	(12'h0C8) ,
	    .UCSRnB_Address 	(12'h0C9) ,
	    .UCSRnC_Address 	(12'h0CA) ,
	    .UBRRnH_Address 	(12'h0CD) ,
	    .UBRRnL_Address 	(12'h0CC) ,
	    .RxcIRQ_Address 	(6'h1C) ,
	    .UdreIRQ_Address 	(6'h1D) ,
	    .TxcIRQ_Address 	(6'h1E) ,
	    .UStBIRQ_Address 	(6'h1F)
	)USARTn_1_inst(
		.ireset		(core_ireset),
		.cp2		(cp2),
		.ram_Addr 	(core_ramadr),
		.ramre 		(core_ramre),
		.ramwe 		(core_ramwe),
		.out_en 	(d_en_bus[Usart_1]),
		.dbus_in 	(core_dbusout),
		.dbus_out 	(data_bus[Usart_1]),
		.DDR_XCKn 	(DDR_XCK1),
		.UMSEL		(UMSEL1),
		.XCKn_i 	(DIB_int[5]), //
		.XCKn_o 	(XCK1_OUT), //
		.RxDn_i 	(TXD0), //
		.TxDn_o 	(TXD1), //
		.RXENn 		(RXEN1),
		.TXENn 		(TXEN1),
		.RxcIRQ 	(core_irqlines[28]),
		.UdreIRQ	(core_irqlines[29]), 
		.TxcIRQ 	(core_irqlines[30]),
		.UStBIRQ	(core_irqlines[31]),
		.irqack_addr(core_irqackad),
		.irqack		(core_irqack)
	);
	
	parameter period = 50 ;

	always begin
		#(period/2) cp2 =1'b1 ;
		#(period/2) cp2 =1'b0 ;
	end 
	
	initial //reset module, lenght: 2 periods
	begin 
	core_ireset = 1'b1;
	#(1*period);
	core_ireset = 1'b0;
	#(1*period);
	core_ireset = 1'b1;
	end
	
	initial 
	begin
		#(10*1000*1000); //test time = 10 ms
		$finish;
	end
	
	initial
	begin 

	#(2*period); // wait until reset done
	
	// ---------------------------------------------- USART_0 Control Register Configure
	//set baud rate
	core_ramadr = 12'h0C5; //UBRRnH addr
	core_dbusout = 8'b00000000;
	core_ramwe = 1'b1;
	#(1*period);
	core_ramadr = 12'h0C4; // UBRRnL addr
	core_dbusout = 8'b00000000; // set UBRRn
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);

	//set data direction (for synchronous mode)
	DDR_XCK0 = 1'b0; // 0 for slave and 1 for master?
	#(1*period);
	

	//Write to UCSRnA
	core_ramadr = 12'h0C0; //UCSRnA addr
	core_dbusout = 8'b00000000; // Default (enable 2xSpeed or MPCM)
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);

	//Write to UCSRnB
	core_ramadr = 12'h0C1; //UCSRnB addr
	core_dbusout = 8'b00001101; // enables TXEN (and enable/write ninth-bit to TXB8n)
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);

	//Write to UCSRnC
	core_ramadr = 12'h0C2; //UCSRnC addr
	core_dbusout = 8'b01101110; // Select Mode and Set Frame Format
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);
	
	// ---------------------------------------------- USART_1 Control Register Configure
	//set baud rate
	core_ramadr = 12'h0CD; //UBRRnH addr
	core_dbusout = 8'b00000100;
	core_ramwe = 1'b1;
	#(1*period);
	core_ramadr = 12'h0CC; // UBRRnL addr
	core_dbusout = 8'b00010001; // set UBRRn
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);

	//set data direction (for synchronous mode)
	DDR_XCK1 = 1'b1; // 0 for slave and 1 for master?
	#(1*period);
	

	//Write to UCSRnA
	core_ramadr = 12'h0C8; //UCSRnA addr
	core_dbusout = 8'b00000000; // Default (enable 2xSpeed or MPCM)
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);

	//Write to UCSRnB
	core_ramadr = 12'h0C9; //UCSRnB addr
	core_dbusout = 8'b00001101; // enables TXEN (and enable/write ninth-bit to TXB8n)
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);

	//Write to UCSRnC
	core_ramadr = 12'h0CA; //UCSRnC addr
	core_dbusout = 8'b01101110; // Select Mode and Set Frame Format
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);

	// ---------------------------------------------- enable RXEN of both USART

	//Write to UCSRnB
	core_ramadr = 12'h0C1; //UCSRnB addr
	core_dbusout = 8'b00011101; // enables RXEN
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);

	//Write to UCSRnB
	core_ramadr = 12'h0C9; //UCSRnB addr
	core_dbusout = 8'b00011101; // enables RXEN 
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);
	
	// ---------------------------------------------- load byte to send
	#(500*20*period);

	core_ramadr = 12'h0C6;
	core_dbusout = 8'b01100101;	// first data
	core_ramwe = 1'b1;
	#(1*period);

	core_ramadr = 12'h0C7;
	core_ramwe = 1'b0;
	#(1*period);

	#(100*20*period);

	core_dbusout = 8'b01110101;	// second data
	core_ramwe = 1'b1;
	#(1*period);
	
	core_ramwe = 1'b0;
	#(10*period);
	
	end

	initial
	begin

	#(1041*20*period)
	#(1041*20*period)
/*
	core_ramadr = 12'h0C1;
	core_ramre = 1'b1;
	#(1*period);
	core_ramre = 1'b0;
	#(1*period);
*/
	core_ramadr = 12'h0C6;
	core_ramre = 1'b1;
	#(1*period);
	core_ramre = 1'b0;
	#(1*period);

	#(1041*20*period)
/*
	core_ramadr = 12'h0C9;
	core_ramre = 1'b1;
	#(1*period);
	core_ramre = 1'b0;
	#(1*period);
*/
	core_ramadr = 12'h0C7;
	core_ramre = 1'b1;
	#(1*period);
	core_ramre = 1'b0;
	#(1*period);

/*
	core_ramadr = 12'h0C8; //clear TXCn flag
	core_dbusout = 8'b01000000;
	core_ramwe = 1'b1;
	#(1*period);
	core_ramwe = 1'b0;
	#(1*period);
*/
	end

endmodule
