`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module gpio_PC_tb;
	
	reg					core_ireset;
	reg					cp2;
	reg [5:0] 			core_adr; 
	reg 				core_iore; 
	reg 				core_iowe; 
	wire [7:0] 			data_bus;
	wire 				d_en_bus;	
	reg [7:0] 			core_dbusout; 

	reg [6:0]			pinC_int;		// input: pinD and bypass to DIC
	wire [6:0]			DIC_int;		// output: Port C Digital input (DIC)

	wire [6:0]			pu_C_int;		// Pull-up Port C Output
	wire [6:0]			dd_C_int;		// Data Direction Port C Output
	wire [6:0]			pv_C_int;		// Port Value Port C Output
	wire [6:0]			die_C_int;		// Digital Input Enable Port C Output

	reg					PUD;
	reg					SLEEP;
	reg					RSTDISBL;
	reg					TWEN0;
	reg					SPE1;
	reg					MSTR1;
	reg					SCK1_OUT;
	reg					SPI1_SL_OUT;
	reg					SCL0_OUT;
	reg					SDA0_OUT;
	reg [5:0]			ADCxD; //ADCxD[5:0]
	reg [6:0]			pcint; //pcint[14:8]
	reg					PCIE1;
	
	Port_C Port_C_inst(
		.ireset		(core_ireset),
		.cp2		(cp2),
		.IO_Addr 	(core_adr),
		.iore 		(core_iore),
		.iowe 		(core_iowe),	
		.out_en 	(d_en_bus),
		.dbus_in 	(core_dbusout),
		.dbus_out 	(data_bus),
		
		.pinC_i 	(pinC_int),
		.DIC_o		(DIC_int),
		.pu_C		(pu_C_int),
		.dd_C		(dd_C_int),
		.pv_C		(pv_C_int),
		.die_C		(die_C_int),
		
		.PUD 		(PUD),
		.SLEEP      (SLEEP),
		.RSTDISBL	(RSTDISBL),
		.TWEN0		(TWEN0),
		.SPE1		(SPE1),
		.MSTR		(MSTR1),
		.SCK1_OUT	(SCK1_OUT),
		.SPI1_SL_OUT(SPI1_SL_OUT),
		.SCL0_OUT	(SCL0_OUT),
		.SDA0_OUT	(SDA0_OUT),
		.ADCxD		(ADCxD[5:0]), //ADCxD[5:0]
		.PCINT		(pcint[6:0]), //pcint[14:8]
		.PCIE1		(PCIE1)	
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
		RSTDISBL = 1'b0;
		TWEN0 = 1'b0;
		SPE1 = 1'b0;
		MSTR1 = 1'b1;
		ADCxD[5:0] = 6'b000000;
		PCIE1 = 1'b0;
		pcint[6:0] = 7'b0000000;
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

	task writePINxn(input[6:0] value);
		begin
			core_adr[5:0] = 6'h06; //PINCn addr
			core_dbusout[7:0] = {1'b0, value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task writeDDxn(input[6:0] value);
		begin
			core_adr[5:0] = 6'h07; //DDCn addr
			core_dbusout[7:0] = {1'b0, value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task writePORTxn(input[6:0] value);
		begin
			core_adr[5:0] = 6'h08; //PORTCn addr
			core_dbusout[7:0] = {1'b0, value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task testPortPinConfig();
		begin
			// [DDxn,PORTxn,PUD] = [0,0,x]
			writeDDxn(7'b0000000);
			writePORTxn(7'b0000000);
			PUD = 1'b0;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [0,1,0]
			writeDDxn(7'b0000000);
			writePORTxn(7'b1111111);
			PUD = 1'b0;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [0,1,1]
			writeDDxn(7'b0000000);
			writePORTxn(7'b1111111);
			PUD = 1'b1;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [1,0,x]
			writeDDxn(7'b1111111);
			writePORTxn(7'b0000000);
			PUD = 1'b0;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [1,1,x]
			writeDDxn(7'b1111111);
			writePORTxn(7'b1111111);
			PUD = 1'b0;
			#(4*period);

			// test toggle: 0->1 for bit [1:0]
			writeDDxn(7'b1111111);
			writePORTxn(7'b0000000);
			PUD = 1'b0;
			#(2*period);
			writePINxn(7'b0001111);
			#(2*period);

			// test toggle: 1->0 for bit [3:2]
			writeDDxn(7'b1111111);
			writePORTxn(7'b1111111);
			PUD = 1'b0;
			#(2*period);
			writePINxn(7'b1110000);
			#(2*period);

			// reset all signal to 0
			writeDDxn(7'b0000000);
			writePORTxn(7'b0000000);
			writePINxn(7'b0000000);
		end
	endtask

	task testPullupOverride();
		begin
			// testcase: non override (PUOE = 0)
			RSTDISBL = 1'b0;
			TWEN0 = 1'b0;
			SPE1 = 1'b0;
			MSTR1 = 1'b0;
			#(2*period);
			
			testPortPinConfig();
			#(16*period);

			// testcase: override(PC[6:1]), pull-up enable (PUOE = 1, PUOV = 1)
			RSTDISBL = 1'b1;
			TWEN0 = 1'b1;
			SPE1 = 1'b1;
			MSTR1 = 1'b0;
			#(2*period);

			PUD = 1'b0;
			writePORTxn(7'b1111111);
			#(4*period);

			// testcase: override(PC[6:1]), pull-up disable (PUOE = 1, PUOV = 0)
			PUD = 1'b0;
			writePORTxn(7'b0000000);
			#(4*period);
			
			// reset all signal to 0
			writeDDxn(7'b0000000);
			writePORTxn(7'b0000000);
			RSTDISBL = 1'b0;
			TWEN0 = 1'b0;
			SPE1 = 1'b0;
			MSTR1 = 1'b0;
		end
	endtask

	task testDataDirectionOverride();
		begin
			// testcase: non override (DDOE = 0)
			RSTDISBL = 1'b0;
			TWEN0 = 1'b0;
			SPE1 = 1'b0;
			MSTR1 = 1'b0;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// testcase: override(PC[6:1]) (DDOE = 1)
			RSTDISBL = 1'b1;
			TWEN0 = 1'b1;
			SPE1 = 1'b1;
			MSTR1 = 1'b0;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// reset all signal to 0
			RSTDISBL = 1'b0;
			TWEN0 = 1'b0;
			SPE1 = 1'b0;
			MSTR1 = 1'b0;
		end
	endtask

	task testPortValueOverride();
		begin
			// testcase: non override (PVOE = 0)
			TWEN0 = 1'b0;
			SPE1 = 1'b0;
			MSTR1 = 1'b1;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// testcase: override, value = 0 (PVOE = 1, PVOV = 0)
			TWEN0 = 1'b1;
			SPE1 = 1'b1;
			MSTR1 = 1'b1;
			#(2*period);

			SCL0_OUT = 1'b0;
			SDA0_OUT = 1'b0;
			SCK1_OUT = 1'b0;
			SPI1_SL_OUT = 1'b0;
			#(4*period);

			// test general function being overridden (set pin as output, value = 1)
			// [DDxn,PORTxn,PUD] = [1,1,x]
			writeDDxn(7'b1111111);
			writePORTxn(7'b1111111);
			PUD = 1'b0;
			#(4*period);

			// testcase: override, value = 1 (PVOE = 1, PVOV = 1)
			SCL0_OUT = 1'b1;
			SDA0_OUT = 1'b1;
			SCK1_OUT = 1'b1;
			SPI1_SL_OUT = 1'b1;
			#(4*period); 

			// test general function being overridden (set pin as output, value = 0)
			// [DDxn,PORTxn,PUD] = [1,0,x]
			writeDDxn(7'b1111111);
			writePORTxn(7'b0000000);	// test condition 'PVOVD[2] = (OC3B&&OC4B) = 0'
			PUD = 1'b0;
			#(4*period);

			// reset all signal to 0
			writeDDxn(7'b0000000);
			writePORTxn(7'b0000000);
			TWEN0 = 1'b0;
			SPE1 = 1'b0;
			MSTR1 = 1'b1;
		end
	endtask

	task testDigitalInputEnableOverride();
		begin
			// testcase: non override (DIEOE = 0)
			RSTDISBL = 1'b0;
			pcint[6:0] = 7'b0000000;
			PCIE1 = 1'b0;
			ADCxD[5:0] = 6'b000000;

			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// testcase: override, value = 0 (DIEOE = 1, DIEOV = 0)
			pcint[6:0] = 7'b0000000;
			PCIE1 = 1'b0;
			ADCxD[5:0] = 6'b111111;
			RSTDISBL = 1'b1;
			#(4*period);

			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// testcase: override, value = 1 (DIEOE = 1, DIEOV = 1)
			pcint[6:0] = 7'b1111111;
			PCIE1 = 1'b1;
			ADCxD[5:0] = 6'b000000;
			RSTDISBL = 1'b1;
			#(4*period);

			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// reset all signal to 0
			RSTDISBL = 1'b0;
			pcint[6:0] = 7'b0000000;
			PCIE1 = 1'b0;
			ADCxD[5:0] = 6'b000000;
			SLEEP = 0;
		end
	endtask
endmodule
