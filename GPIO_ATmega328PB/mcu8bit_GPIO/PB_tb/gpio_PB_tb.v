`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module gpio_PB_tb;
	
	reg					core_ireset;
	reg					cp2;
	reg [5:0] 			core_adr; 
	reg 				core_iore; 
	reg 				core_iowe; 
	wire [7:0] 			data_bus;
	wire 				d_en_bus;	
	reg [7:0] 			core_dbusout; 

	reg [7:0]			pinB_int;		// input: pinB and bypass to DIB
	wire [7:0]			DIB_int;		// output: Port B Digital input (DIB)
	wire				DDR_XCK1;		// output: DDR_XCK1 signal

	wire [7:0]			pu_B_int;		// Pull-up Port B Output
	wire [7:0]			dd_B_int;		// Data Direction Port B Output
	wire [7:0]			pv_B_int;		// Port Value Port B Output
	wire [7:0]			die_B_int;		// Digital Input Enable Port B Output

	reg                	PUD;
	reg 				SLEEP;
	reg					INTRC;
	reg					EXCLK;
	reg					AS2;
	reg					SPE0;
	reg					MSTR0;
	reg 				RXEN1;
	reg 				TXEN1;
	reg                 OC2A_EN;
	reg           		OC1B_EN;
	reg 				OC1A_EN;
	reg                 SCK0_OUT;
	reg                 XCK1_OUT;
	reg                 SPI0_SL_OUT;
	reg                 OC2A;
	reg               	OC1B;
	reg					OC1A;
	reg                	SPI0_MT_OUT;
	reg                	UMSEL1;
	reg					TXD1;
	reg [7:0]           pcint; //pcint[7:0]
	reg					PCIE0;
	
	Port_B Port_B_inst(
		.ireset		(core_ireset),
		.cp2		(cp2),
		.IO_Addr 	(core_adr),
		.iore 		(core_iore),
		.iowe 		(core_iowe),	
		.out_en 	(d_en_bus),
		.dbus_in 	(core_dbusout),
		.dbus_out 	(data_bus),
		
		.pinB_i 	(pinB_int),
		.DIB_o		(DIB_int),
		.pu_B		(pu_B_int),
		.dd_B		(dd_B_int),
		.pv_B		(pv_B_int),
		.die_B		(die_B_int),
		.DDR_XCK1   (DDR_XCK1),
		
		.PUD 		(PUD),
		.SLEEP      (SLEEP),
		.INTRC		(INTRC),
		.EXTCK		(EXCLK), // ******
		.AS2		(AS2),
		.SPE0		(SPE0),
		.MSTR		(MSTR0),
		.RXEN1		(RXEN1),
		.TXEN1		(TXEN1),
		.OC2A_EN	(OC2A_EN),
		.OC1B_EN	(OC1B_EN),
		.OC1A_EN	(OC1A_EN),
		.SCK0_OUT	(SCK0_OUT),
		.XCK1_OUT	(XCK1_OUT),
		.SPI0_SL_OUT(SPI0_SL_OUT),
		.OC2A		(OC2A),
		.OC1B		(OC1B),
		.OC1A		(OC1A),
		.SPI0_MT_OUT(SPI0_MT_OUT),
		.UMSEL		(UMSEL1),
		.TXD1		(TXD1),
		.PCINT		(pcint[7:0]), //pcint[7:0]
		.PCIE0		(PCIE0)
	);
	
	reg [3:0] 			TESTCASE;

	parameter period = 50 ;
									
	always begin
		#(period/2) cp2 =1'b1;
		#(period/2) cp2 =1'b0;
	end 
	
	initial //reset module, lenght: 2 periods
	begin 
	core_ireset = 1'b1;
	#(1*period);
	core_ireset = 1'b0;
	#(1*period);
	core_ireset = 1'b1;
	core_iore = 1'b0;
	core_iowe = 1'b0;
	end
	
	initial //test time = 10 ms
	begin
		#(0.1*1000*1000); 
		$finish;
	end
	
	initial
	begin
		#(2*period); // wait until reset done
		
		// Testcase 0: Test Port Pin Configurations 
		// by varying [DDxn, PORTxn, PUD] and inspect pu_B, dd_B, and pv_B signals
		TESTCASE = 4'd0;

		// set initial condition so that there are fewest-to-no override occurs (PUOE, DDOE, PVOE, DIEOE = 0)
		SLEEP = 1'b0;
		INTRC = 1'b0;
		EXCLK = 1'b1;
		AS2 = 1'b0;
		SPE0 = 1'b0;
		MSTR0 = 1'b1;
		RXEN1 = 1'b0;
		TXEN1 = 1'b0;
		OC2A_EN = 1'b0;
		OC1B_EN = 1'b0;
		OC1A_EN = 1'b0;
		UMSEL1 = 1'b0;
		PCIE0 = 1'b0;
		pcint[7:0] = 8'b00000000;
		#(1*period); // DIEOE[7:0] is always set for bit 5-0 and alternating with PUOE in bit 7,6

		// Testcase 0: Test General Port Function
		testPortPinConfig();
		#(100*period);

		// Testcase 1: Alternate Port Function: Pull-up Override
		TESTCASE = 4'd1;
		testPullupOverride();
		#(100*period);

		// Testcase 2: Alternate Port Function: Data Direction Override
		TESTCASE = 4'd2;
		testDataDirectionOverride();
		#(100*period);

		// Testcase 3: Alternate Port Function: Port Value Override
		TESTCASE = 4'd3;
		testPortValueOverride();
		#(100*period);

		// Testcase 4: Alternate Port Function: Digital Input Enable Override
		TESTCASE = 4'd4;
		testDigitalInputEnableOverride();
		#(100*period);

	end

	task writePINxn(input[7:0] value);
		begin
			core_adr[5:0] = 6'h03; //PINBn addr
			core_dbusout[7:0] = {value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task writeDDxn(input[7:0] value);
		begin
			core_adr[5:0] = 6'h04; //DDBn addr
			core_dbusout[7:0] = {value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task writePORTxn(input[7:0] value);
		begin
			core_adr[5:0] = 6'h05; //PORTBn addr
			core_dbusout[7:0] = {value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task testPortPinConfig();
		begin
			// [DDxn,PORTxn,PUD] = [0,0,x]
			writeDDxn(8'b00000000);
			writePORTxn(8'b00000000);
			PUD = 1'b0;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [0,1,0]
			writeDDxn(8'b00000000);
			writePORTxn(8'b11111111);
			PUD = 1'b0;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [0,1,1]
			writeDDxn(8'b00000000);
			writePORTxn(8'b11111111);
			PUD = 1'b1;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [1,0,x]
			writeDDxn(8'b11111111);
			writePORTxn(8'b00000000);
			PUD = 1'b0;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [1,1,x]
			writeDDxn(8'b11111111);
			writePORTxn(8'b11111111);
			PUD = 1'b0;
			#(4*period);

			// test toggle: 0->1 for bit [1:0]
			writeDDxn(8'b11111111);
			writePORTxn(8'b00000000);
			PUD = 1'b0;
			#(2*period);
			writePINxn(8'b00001111);
			#(2*period);

			// test toggle: 1->0 for bit [3:2]
			writeDDxn(8'b11111111);
			writePORTxn(8'b11111111);
			PUD = 1'b0;
			#(2*period);
			writePINxn(8'b11110000);
			#(2*period);

			// reset all signal to 0
			writeDDxn(8'b00000000);
			writePORTxn(8'b00000000);
			writePINxn(8'b00000000);
		end
	endtask

	task testPullupOverride();
		begin
			// testcase: non override (PUOE = 0)
			INTRC = 1'b0;
			AS2 = 1'b0;
			EXCLK = 1'b1;
			SPE0 = 1'b0;
			MSTR0 = 1'b1;
			RXEN1 = 1'b0;
			TXEN1 = 1'b0;
			#(2*period);
			
			testPortPinConfig();
			#(16*period);

			// testcase: override, pull-up enable (PUOE = 1, PUOV = 1)
			INTRC = 1'b0;
			EXCLK = 1'b0;
			AS2 = 1'b1;
			SPE0 = 1'b1;
			MSTR0 = 1'b0;
			RXEN1 = 1'b1;
			TXEN1 = 1'b1;
			#(2*period);

			PUD = 1'b0;
			writePORTxn(8'b11111111);
			#(4*period);

			// testcase: override, pull-up disable (PUOE = 1, PUOV = 0)
			PUD = 1'b0;
			writePORTxn(8'b00000000);
			#(4*period);
			
			// reset all signal to 0
			writeDDxn(8'b00000000);
			writePORTxn(8'b00000000);
			INTRC = 1'b0;
			AS2 = 1'b0;
			EXCLK = 1'b1;
			SPE0 = 1'b0;
			MSTR0 = 1'b1;
			RXEN1 = 1'b0;
			TXEN1 = 1'b0;
		end
	endtask

	task testDataDirectionOverride();
		begin
			// testcase: non override (DDOE = 0)
			INTRC = 1'b0;
			AS2 = 1'b0;
			EXCLK = 1'b1;
			SPE0 = 1'b0;
			MSTR0 = 1'b1;
			RXEN1 = 1'b0;
			TXEN1 = 1'b0;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// testcase: override (DDOE = 1)
			INTRC = 1'b0;
			EXCLK = 1'b0;
			AS2 = 1'b1;
			SPE0 = 1'b1;
			MSTR0 = 1'b0;
			RXEN1 = 1'b1;
			TXEN1 = 1'b1;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// reset all signal to 0
			INTRC = 1'b0;
			AS2 = 1'b0;
			EXCLK = 1'b1;
			SPE0 = 1'b0;
			MSTR0 = 1'b1;
			RXEN1 = 1'b0;
			TXEN1 = 1'b0;
			PUD = 1'b0;
		end
	endtask

	task testPortValueOverride();
		begin
			// testcase: non override (PVOE = 0)
			SPE0 = 1'b0;
			MSTR0 = 1'b0;
			UMSEL1 = 1'b0;
			OC2A_EN = 1'b0;
			OC1B_EN = 1'b0;
			OC1A_EN = 1'b0;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// testcase: override, value = 0 (PVOE = 1, PVOV = 0)
			SPE0 = 1'b1;
			MSTR0 = 1'b0;
			UMSEL1 = 1'b1;
			OC2A_EN = 1'b1;
			OC1B_EN = 1'b1;
			OC1A_EN = 1'b1;

			SCK0_OUT = 1'b0;
			XCK1_OUT = 1'b0;
			SPI0_SL_OUT = 1'b0;
			SPI0_MT_OUT = 1'b0;
			OC2A = 1'b0;
			TXD1 = 1'b0;
			OC1B = 1'b0;
			OC1A = 1'b0;

			#(4*period);

			// test general function being overridden (set pin as output, value = 1)
			// [DDxn,PORTxn,PUD] = [1,1,x]
			writeDDxn(8'b11111111);
			writePORTxn(8'b11111111);
			PUD = 1'b0;
			#(4*period);

			// testcase: override, value = 1 (PVOE = 1, PVOV = 1)
			SCK0_OUT = 1'b1;
			XCK1_OUT = 1'b0;	// test condition 'SCK0_OUT || XCK1_OUT'
			SPI0_SL_OUT = 1'b1;
			SPI0_MT_OUT = 1'b1;
			OC2A = 1'b0;
			TXD1 = 1'b0;	// test condition 'SPI0_MT_OUT || OC2A || TXD1'
			OC1B = 1'b1;
			OC1A = 1'b1;
			#(4*period); 

			// test general function being overridden (set pin as output, value = 0)
			// [DDxn,PORTxn,PUD] = [1,0,x]
			writeDDxn(8'b11111111);
			writePORTxn(8'b00000000);
			PUD = 1'b0;
			#(4*period);

			// reset all signal to 0
			writeDDxn(8'b00000000);
			writePORTxn(8'b00000000);
			SPE0 = 1'b0;
			MSTR0 = 1'b0;
			UMSEL1 = 1'b0;
			OC2A_EN = 1'b0;
			OC1B_EN = 1'b0;
			OC1A_EN = 1'b0;
			SCK0_OUT = 1'b0;
			XCK1_OUT = 1'b0;
			SPI0_SL_OUT = 1'b0;
			SPI0_MT_OUT = 1'b0;
			OC2A = 1'b0;
			TXD1 = 1'b0;
			OC1B = 1'b0;
			OC1A = 1'b0;
		end
	endtask

	task testDigitalInputEnableOverride();
		begin
			// testcase: non override (DIEOE = 0)
			pcint[7:0] = 8'b00000000;
			PCIE0 = 1'b0;
			INTRC = 1'b1;
			EXCLK = 1'b1;
			AS2 = 1'b0;
			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// testcase: override, value = 0(for PB[7:6]) (DIEOE = 1, DIEOV = 0)
			pcint[7:0] = 8'b11111111;
			PCIE0 = 1'b1;
			INTRC = 1'b0;
			EXCLK = 1'b0;
			AS2 = 1'b1;
			#(4*period);

			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// testcase: override, value = 1 (DIEOE = 1, DIEOV = 1)
			pcint[7:0] = 8'b11111111;
			PCIE0 = 1'b1;
			INTRC = 1'b1;
			EXCLK = 1'b0; // test condition '(INTRC || EXCLK) && !AS2'
			AS2 = 1'b0;
			#(4*period);

			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// reset all signal to 0
			pcint[7:0] = 8'b00000000;
			PCIE0 = 1'b0;
			INTRC = 1'b1;
			EXCLK = 1'b1;
			AS2 = 1'b0;
			SLEEP = 0;
		end
	endtask
endmodule
