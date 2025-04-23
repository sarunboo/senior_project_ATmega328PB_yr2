`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module gpio_PE_tb;
	
	reg					core_ireset;
	reg					cp2;
	reg [5:0] 			core_adr; 
	reg 				core_iore; 
	reg 				core_iowe; 
	wire [7:0] 			data_bus;
	wire 				d_en_bus;	
	reg [7:0] 			core_dbusout; 

	reg [3:0]			pinE_int;		// input: pinE and bypass to DIE
	wire [3:0]			DIE_int;		// output: Port E Digital input (DIE)

	wire [3:0]			pu_E_int;		// Pull-up Port E Output
	wire [3:0]			dd_E_int;		// Data Direction Port E Output
	wire [3:0]			pv_E_int;		// Port Value Port E Output
	wire [3:0]			die_E_int;		// Digital Input Enable Port E Output

	reg                 PUD;
	reg 				SLEEP;
	reg					RSTDISBL;
	reg					TWEN1;
	reg					SPE1;
	reg					MSTR1;
	reg                 SCK1_OUT;
	reg                 SPI1_MT_OUT;
	reg           		SCL1_OUT;
	reg					SDA1_OUT;
	reg [1:0]			ADCxD; //ADCxD[7:6]
	reg [3:0]           pcint; //pcint[27:24]
	reg					PCIE3;
	reg                 aco_oe;
	reg                 acompout;
	
	Port_E Port_E_inst (
		.ireset		(core_ireset),
		.cp2		(cp2),
		.IO_Addr 	(core_adr),
		.iore 		(core_iore),
		.iowe 		(core_iowe),	
		.out_en 	(d_en_bus),
		.dbus_in 	(core_dbusout),
		.dbus_out 	(data_bus),
		
		.pinE_i 	(pinE_int),
		.DIE_o		(DIE_int),
		.pu_E		(pu_E_int),
		.dd_E		(dd_E_int),
		.pv_E		(pv_E_int),
		.die_E		(die_E_int),
		
		.PUD 		(PUD),
		.SLEEP      (SLEEP),
		.RSTDISBL	(RSTDISBL),
		.TWEN1		(TWEN1),
		.SPE1		(SPE1),
		.MSTR		(MSTR1),
		.SCK1_OUT	(SCK1_OUT),
		.SPI1_MT_OUT(SPI1_MT_OUT),
		.SCL1_OUT	(SCL1_OUT),
		.SDA1_OUT	(SDA1_OUT),
		.ADCxD		(ADCxD[1:0]), //ADCxD[7:6]
		.PCINT		(pcint[3:0]), //pcint[27:24]
		.PCIE3		(PCIE3),
		.aco_oe		(aco_oe),
		.acompout	(acompout)
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
		// by varying [DDxn, PORTxn, PUD] and inspect pu_E, dd_E, and pv_E signals
		TESTCASE = 4'd0;

		// set initial condition so that there are no override occurs (PUOE, DDOE, PVOE, DIEOE = 0)
		SLEEP = 0;
		aco_oe = 1'b0;
		TWEN1 = 1'b0;
		SPE1 = 1'b0;
		MSTR1 = 1'b1;
		pcint = 4'b0000;
		PCIE3 = 1'b0;
		ADCxD = 2'b00;
		#(1*period);

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

	task writePINxn(input[3:0] value);
		begin
			core_adr[5:0] = 6'h0c; //PINEn addr
			core_dbusout[7:0] = {4'b0000, value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task writeDDxn(input[3:0] value);
		begin
			core_adr[5:0] = 6'h0d; //DDEn addr
			core_dbusout[7:0] = {4'b0000, value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task writePORTxn(input[3:0] value);
		begin
			core_adr[5:0] = 6'h0e; //PORTEn addr
			core_dbusout[7:0] = {4'b0000, value};
			core_iowe = 1'b1;
			#(1*period);
			core_iowe = 1'b0;
			#(1*period);
		end
	endtask

	task testPortPinConfig();
		begin
			// [DDxn,PORTxn,PUD] = [0,0,x]
			writeDDxn(4'b0000);
			writePORTxn(4'b0000);
			PUD = 1'b0;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [0,1,0]
			writeDDxn(4'b0000);
			writePORTxn(4'b1111);
			PUD = 1'b0;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [0,1,1]
			writeDDxn(4'b0000);
			writePORTxn(4'b1111);
			PUD = 1'b1;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [1,0,x]
			writeDDxn(4'b1111);
			writePORTxn(4'b0000);
			PUD = 1'b0;
			#(4*period);

			// [DDxn,PORTxn,PUD] = [1,1,x]
			writeDDxn(4'b1111);
			writePORTxn(4'b1111);
			PUD = 1'b0;
			#(4*period);

			// test toggle: 0->1 for bit [1:0]
			writeDDxn(4'b1111);
			writePORTxn(4'b0000);
			PUD = 1'b0;
			#(2*period);
			writePINxn(4'b0011);
			#(2*period);

			// test toggle: 1->0 for bit [3:2]
			writeDDxn(4'b1111);
			writePORTxn(4'b1111);
			PUD = 1'b0;
			#(2*period);
			writePINxn(4'b1100);
			#(2*period);

			// reset all signal to 0
			writeDDxn(4'b0000);
			writePORTxn(4'b0000);
			writePINxn(4'b0000);
		end
	endtask

	task testPullupOverride();
		begin
			// testcase: non override (PUOE = 0)
			SPE1 = 1'b0;
			MSTR1 = 1'b0; 
			TWEN1 = 1'b0;
			aco_oe = 1'b0;
			#(2*period);
			
			testPortPinConfig();
			#(16*period);

			// testcase: override, pull-up enable (PUOE = 1, PUOV = 1)
			SPE1 = 1'b1;
			MSTR1 = 1'b0; 
			TWEN1 = 1'b1;
			aco_oe = 1'b0; // test 'TWEN1 || aco_oe' condition
			#(2*period);

			PUD = 1'b0;
			writePORTxn(4'b1111);
			#(4*period);

			// testcase: override, pull-up disable (PUOE = 1, PUOV = 0)
			PUD = 1'b0;
			writePORTxn(4'b0000);
			#(4*period);
			
			// reset all signal to 0
			writeDDxn(4'b0000);
			writePORTxn(4'b0000);
			SPE1 = 1'b0;
			MSTR1 = 1'b0; 
			TWEN1 = 1'b0;
			aco_oe = 1'b0;
			PUD = 1'b0;
		end
	endtask

	task testDataDirectionOverride();
		begin
			// testcase: non override (DDOE = 0)
			SPE1 = 1'b0;
			MSTR1 = 1'b1; 
			TWEN1 = 1'b0;
			aco_oe = 1'b0;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// testcase: override (DDOE = 1)
			SPE1 = 1'b1;
			MSTR1 = 1'b0; 
			TWEN1 = 1'b1;
			aco_oe = 1'b0; // test 'TWEN1 || aco_oe' condition
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// reset all signal to 0
			SPE1 = 1'b0;
			MSTR1 = 1'b0; 
			TWEN1 = 1'b0;
			aco_oe = 1'b0;
			PUD = 1'b0;
		end
	endtask

	task testPortValueOverride();
		begin
			// testcase: non override (PVOE = 0)
			SPE1 = 1'b0;
			MSTR1 = 1'b0; 
			TWEN1 = 1'b0;
			aco_oe = 1'b0;
			#(2*period);

			testPortPinConfig();
			#(16*period);

			// testcase: override, value = 0 (PVOE = 1, PVOV = 0)
			SPE1 = 1'b1;
			MSTR1 = 1'b1; 
			TWEN1 = 1'b1;
			aco_oe = 1'b1;

			SPI1_MT_OUT = 1'b0;
			SCL1_OUT = 1'b0;
			acompout = 1'b0;
			SDA1_OUT = 1'b0;
			#(4*period);

			// test general function being overridden (set pin as output, value = 1)
			// [DDxn,PORTxn,PUD] = [1,1,x]
			writeDDxn(4'b1111);
			writePORTxn(4'b1111);
			PUD = 1'b0;
			#(4*period);

			// testcase: override, value = 1 (PVOE = 1, PVOV = 1)
			SPI1_MT_OUT = 1'b1;
			SCL1_OUT = 1'b1;
			acompout = 1'b0;
			SDA1_OUT = 1'b1; // test 'acompout || SDA1_OUT' condition
			#(4*period); 

			// test general function being overridden (set pin as output, value = 0)
			// [DDxn,PORTxn,PUD] = [1,0,x]
			writeDDxn(4'b1111);
			writePORTxn(4'b0000);
			PUD = 1'b0;
			#(4*period);

			// reset all signal to 0
			writeDDxn(4'b0000);
			writePORTxn(4'b0000);
			SPE1 = 1'b0;
			MSTR1 = 1'b0; 
			TWEN1 = 1'b0;
			aco_oe = 1'b0;
			SPI1_MT_OUT = 1'b0;
			SCL1_OUT = 1'b0;
			acompout = 1'b0;
			SDA1_OUT = 1'b0;
		end
	endtask

	task testDigitalInputEnableOverride();
		begin
			// testcase: non override (DIEOE = 0)
			pcint[3:0] = 4'b0000;
			PCIE3 = 1'b0;
			ADCxD[1:0] = 2'b00;
			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// testcase: override, value = 0(for PE[3:2]) (DIEOE = 1, DIEOV = 0)
			pcint[3:0] = 4'b0011;
			PCIE3 = 1'b1;
			ADCxD[1:0] = 2'b11; // test 'pcint&&PCIE3 || ADCxD' condition
			#(4*period);

			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// testcase: override, value = 1 (DIEOE = 1, DIEOV = 1)
			pcint[3:0] = 4'b1111;
			PCIE3 = 1'b1;
			ADCxD[1:0] = 2'b00; // test 'pcint&&PCIE3 || ADCxD' condition
			#(4*period);

			SLEEP = 0;
			#(4*period);
			SLEEP = 1;
			#(4*period);

			// reset all signal to 0
			pcint[3:0] = 4'b0000;
			PCIE3 = 1'b0;
			ADCxD[1:0] = 2'b00;
			SLEEP = 0;
		end
	endtask
endmodule
