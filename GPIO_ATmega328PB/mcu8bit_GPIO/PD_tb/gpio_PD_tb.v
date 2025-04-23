`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module gpio_PD_tb;
	
	reg					core_ireset;
	reg					cp2;
	reg [5:0] 			core_adr; 
	reg 				core_iore; 
	reg 				core_iowe; 
	wire [7:0] 			data_bus;
	wire 				d_en_bus;	
	reg [7:0] 			core_dbusout; 

	reg [7:0]			pinD_int;		// input: pinD and bypass to DID
	wire [7:0]			DID_int;		// output: Port D Digital input (DID)
	wire				DDR_XCK0;		// output: DDR_XCK0 signal

	wire [7:0]			pu_D_int;		// Pull-up Port D Output
	wire [7:0]			dd_D_int;		// Data Direction Port D Output
	wire [7:0]			pv_D_int;		// Port Value Port D Output
	wire [7:0]			die_D_int;		// Digital Input Enable Port D Output

	reg                 PUD;
	reg 				SLEEP;
	reg 				RXEN0;
	reg 				TXEN0;
	reg                 OC0A_EN;
	reg           		OC0B_EN;
	reg 				OC2B_EN;
	reg 				OC3B_EN;
	reg 				OC4B_EN;
	reg 				OC4A_EN;
	reg 				OC3A_EN;
	reg                 XCK0_OUT;
	reg                 OC0A;
	reg           		OC0B;
	reg 				OC2B;
	reg 				OC3B;
	reg 				OC4B;
	reg 				OC4A;
	reg 				OC3A;
	reg                 UMSEL0;
	reg					TXD0;
	reg [7:0]           pcint; //pcint[23:16]
	reg                 INT1_EN;
	reg                 INT0_EN;
	reg					PCIE2;
	reg [1:0]			AINxD; // AINxD[1:0] added later (GPIO)
	
	Port_D Port_D_inst(
		.ireset		(core_ireset),
		.cp2		(cp2),
		.IO_Addr 	(core_adr),
		.iore 		(core_iore),
		.iowe 		(core_iowe),	
		.out_en 	(d_en_bus),
		.dbus_in 	(core_dbusout),
		.dbus_out 	(data_bus),
		
		.pinD_i 	(pinD_int),
		.DID_o		(DID_int),
		.pu_D		(pu_D_int),
		.dd_D		(dd_D_int),
		.pv_D		(pv_D_int),
		.die_D		(die_D_int),
		.DDR_XCK0   (DDR_XCK0),
		
		.PUD 		(PUD),
		.SLEEP      (SLEEP),
		.RXEN0		(RXEN0),
		.TXEN0		(TXEN0),
		.OC0A_EN	(OC0A_EN),
		.OC0B_EN	(OC0B_EN),
		.OC2B_EN	(OC2B_EN),
		.OC3B_EN	(OC3B_EN),
		.OC4B_EN	(OC4B_EN),
		.OC4A_EN	(OC4A_EN),
		.OC3A_EN	(OC3A_EN),
		.XCK0_OUT	(XCK0_OUT),
		.OC0A		(OC0A),
		.OC0B		(OC0B),
		.OC2B		(OC2B),
		.OC3B		(OC3B),
		.OC4B		(OC4B),
		.OC4A		(OC4A),
		.OC3A		(OC3A),
		.UMSEL		(UMSEL0),
		.TXD0		(TXD0),
		.PCINT		(pcint[7:0]), //pcint[23:16]
		.INT1_EN	(INT1_EN),
		.INT0_EN	(INT0_EN),
		.PCIE2		(PCIE2),
		.AINxD		(AINxD[1:0])	// AINxD[1:0] added later (GPIO)
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
		// by varying [DDxn, PORTxn, PUD] and inspect pu_D, dd_D, and pv_D signals
		TESTCASE = 4'd0;

		// set initial condition so that there are fewest-to-no override occurs (PUOE, DDOE, PVOE, DIEOE = 0)
		SLEEP = 1'b0;
		TXEN0 = 1'b0;
		RXEN0 = 1'b0;
		OC0A_EN = 1'b0;
		OC0B_EN = 1'b0;
		UMSEL0 = 1'b0;
		OC2B_EN = 1'b0;
		OC3B_EN = 1'b0;
		OC4B_EN = 1'b0;
		OC4A_EN = 1'b0;
		OC3A_EN = 1'b0;
		AINxD[1:0] = 2'b00;
		PCIE2 = 1'b0;
		INT1_EN = 1'b0;
		INT0_EN = 1'b0;		
		pcint[7:0] = 8'b00000000;
		#(1*period); // DIEOE[7:0] is always set for bit 5-0 and alternating with PUOE in bit 7,6

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
			core_adr[5:0] = 6'h09; //PINDn addr
			core_dbusout[7:0] = {value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task writeDDxn(input[7:0] value);
		begin
			core_adr[5:0] = 6'h0A; //DDDn addr
			core_dbusout[7:0] = {value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task writePORTxn(input[7:0] value);
		begin
			core_adr[5:0] = 6'h0B; //PORTDn addr
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
			TXEN0 = 1'b0;
			RXEN0 = 1'b0;
			#(2*period);
			
			testPortPinConfig();
			#(16*period);

			// testcase: override, pull-up enable (PUOE = 1, PUOV = 1)
			TXEN0 = 1'b1;
			RXEN0 = 1'b1;
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
			TXEN0 = 1'b0;
			RXEN0 = 1'b0;
		end
	endtask

	task testDataDirectionOverride();
		begin
			// testcase: non override (DDOE = 0)
			TXEN0 = 1'b0;
			RXEN0 = 1'b0;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// testcase: override (DDOE = 1)
			TXEN0 = 1'b1;
			RXEN0 = 1'b1;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// reset all signal to 0
			TXEN0 = 1'b0;
			RXEN0 = 1'b0;
		end
	endtask

	task testPortValueOverride();
		begin
			// testcase: non override (PVOE = 0)
			OC0A_EN = 1'b0;
			OC0B_EN = 1'b0;
			UMSEL0 = 1'b0;
			OC2B_EN = 1'b0;
			OC3B_EN = 1'b0;
			OC4B_EN = 1'b0;
			OC4A_EN = 1'b0;
			TXEN0 = 1'b0;
			OC3A_EN = 1'b0;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// testcase: override, value = 0 (PVOE = 1, PVOV = 0)
			OC0A_EN = 1'b1;
			OC0B_EN = 1'b1;
			UMSEL0 = 1'b1;
			OC2B_EN = 1'b1;
			OC3B_EN = 1'b1;
			OC4B_EN = 1'b1;
			OC4A_EN = 1'b1;
			TXEN0 = 1'b1;
			OC3A_EN = 1'b1;
			#(2*period);

			OC0A = 1'b0;
			OC0B = 1'b0;
			XCK0_OUT = 1'b0;
			OC2B = 1'b0;
			OC3B = 1'b0;
			OC4B = 1'b0;
			OC4A = 1'b0;
			TXD0 = 1'b0;
			OC3A = 1'b0;
			#(4*period);

			// test general function being overridden (set pin as output, value = 1)
			// [DDxn,PORTxn,PUD] = [1,1,x]
			writeDDxn(8'b11111111);
			writePORTxn(8'b11111111);
			PUD = 1'b0;
			#(4*period);

			// testcase: override, value = 1 (PVOE = 1, PVOV = 1)
			OC0A = 1'b1;
			OC0B = 1'b1;
			XCK0_OUT = 1'b1;
			OC2B = 1'b1;
			OC3B = 1'b1;
			OC4B = 1'b0; // test condition 'PVOVD[2] = (OC3B||OC4B) = 1'
			OC4A = 1'b1;
			TXD0 = 1'b1;
			OC3A = 1'b1;
			#(4*period); 

			// test general function being overridden (set pin as output, value = 0)
			// [DDxn,PORTxn,PUD] = [1,0,x]
			writeDDxn(8'b11111111);
			writePORTxn(8'b00000000);	// test condition 'PVOVD[2] = (OC3B&&OC4B) = 0'
			PUD = 1'b0;
			#(4*period);

			// reset all signal to 0
			writeDDxn(8'b00000000);
			writePORTxn(8'b00000000);
			OC0A_EN = 1'b0;
			OC0B_EN = 1'b0;
			UMSEL0 = 1'b0;
			OC2B_EN = 1'b0;
			OC3B_EN = 1'b0;
			OC4B_EN = 1'b0;
			OC4A_EN = 1'b0;
			TXEN0 = 1'b0;
			OC3A_EN = 1'b0;
		end
	endtask

	task testDigitalInputEnableOverride();
		begin
			// testcase: non override (DIEOE = 0)
			pcint[7:0] = 8'b00000000;
			PCIE2 = 1'b0;
			AINxD[1:0] = 2'b00;
			INT1_EN = 1'b0;
			INT0_EN = 1'b0;

			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// testcase: override, value = 0(for PD[7:6]) (DIEOE = 1, DIEOV = 0)
			pcint[7:0] = 8'b00111111;
			PCIE2 = 1'b1;
			AINxD[1:0] = 2'b11;
			INT1_EN = 1'b1;
			INT0_EN = 1'b1;
			#(4*period);

			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// testcase: override, value = 1 (DIEOE = 1, DIEOV = 1)
			pcint[7:0] = 8'b11110011;	// test condition 'INT1_EN||(PCINT[3]&&PCIE2)' and 'INT0_EN||(PCINT[2]&&PCIE2)' for bit 3,2
			PCIE2 = 1'b1;
			AINxD[1:0] = 2'b11;
			INT1_EN = 1'b1;
			INT0_EN = 1'b1;
			#(4*period);

			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// reset all signal to 0
			pcint[7:0] = 8'b00000000;
			PCIE2 = 1'b0;
			AINxD[1:0] = 2'b00;
			INT1_EN = 1'b0;
			INT0_EN = 1'b0;
			SLEEP = 0;
		end
	endtask
endmodule
