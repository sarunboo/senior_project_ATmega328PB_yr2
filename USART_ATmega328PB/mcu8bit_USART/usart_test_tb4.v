`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module usart_test_tb;
	
	reg 			ireset;
	reg				cp2;
	reg [11:0]      ram_Addr;
	reg            	ramre;
	reg            	ramwe;
	wire         	out_en;
	reg [7:0]      	dbus_in;
	wire [7:0] 		dbus_out;

	reg  			DDR_XCKn;
	wire			UMSEL;
	reg 			XCKn_i;
	wire			XCKn_o;

	reg				RxDn_i;
	wire           	TxDn_o;

	wire			RXENn;
	wire			TXENn;

	wire      		TxcIRQ;
	wire      		RxcIRQ;
	wire      		UdreIRQ;
	wire      		UStBIRQ;

	reg [5:0]		irqack_addr;
	reg			 	irqack;
	
		
	wire [7:0]		UDRn;
	wire [7:0]   	UCSRnA;
	wire [7:0] 		UCSRnB;
	wire [7:0]		UCSRnC;
	wire [11:0] 	UBRRn;

	wire			XCKn_transfer;	//unused
	reg				tb_serial;

	localparam  	bit_length = 104;
	

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
		.RxDn_i(tb_serial),	//connects RxDn_i with simulated serial data from tb
		.irqack_addr(irqack_addr),
		.irqack(irqack),
	//output signals
		.out_en(out_en),
		.dbus_out(dbus_out),
		.UMSEL(UMSEL),
		.XCKn_o(XCKn_o),	
		.TxDn_o(TxDn_o),	
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

	initial 
	begin
		#(10*1000*1000); //test time = 10 ms
		$finish;
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
		#(2*period); // wait until reset done

		tb_serial = 1;
		setBaudRate(8'b00000001, 8'b00000011);
		writeUCSRnA(8'b00000010);
		writeUCSRnB(8'b11111000);
		writeUCSRnC(8'b00110110);
		#(1041*20*period)

		write8bit_parity0(8'b01100101);
		#(10*period);
		write8bit_parity1(8'b01100111);
		#(10*period);
		/*
		transmitData(8'b01100101);
		#(10*period);
		transmitData(8'b00111100);
		#(10*period);
		*/
	end

	initial
	begin
		#(1041*20*period);
		#(1041*20*period);
		#(1041*20*period);
		#(2500*20*period);

		readUCSRnA();
		#(1*period);
		readData();
		#(1*period);

		readUCSRnA();
		#(1*period);
		readData();
		#(1*period);

		readUCSRnA();
		#(1*period);
		readData();
		#(1*period);

		readUCSRnA();
		#(1*period);
		readData();
		#(1*period);
	end

//------------------------------------------------------- TASK FUNCTIONS -------------------------------------------------------

	task reset_USART;
		begin
			ireset = 1'b1;
			#(1*period);
			ireset = 1'b0;
		end
	endtask

	task setBaudRate(input[7:0] high_value, input[7:0] low_value);
		begin
			ram_Addr = 12'h0C5; //UBRRnH addr
			dbus_in = high_value;
			ramwe = 1'b1;
			#(1*period);
			ram_Addr = 12'h0C4; // UBRRnL addr
			dbus_in = low_value; // set UBRRn
			ramwe = 1'b1;
			#(1*period);
			ramwe = 1'b0;
		end
	endtask

	task writeUCSRnA(input[7:0] value);
		begin
			ram_Addr = 12'h0C0; //UCSRnA addr
			dbus_in = value; // Default (enable 2xSpeed or MPCM)
			ramwe = 1'b1;
			#(1*period);
			ramwe = 1'b0;
		end
	endtask

	task writeUCSRnB(input[7:0] value);
		begin
			ram_Addr = 12'h0C1; //UCSRnA addr
			dbus_in = value; // Default (enable 2xSpeed or MPCM)
			ramwe = 1'b1;
			#(1*period);
			ramwe = 1'b0;
		end
	endtask

	task writeUCSRnC(input[7:0] value);
		begin
			ram_Addr = 12'h0C2; //UCSRnA addr
			dbus_in = value; // Default (enable 2xSpeed or MPCM)
			ramwe = 1'b1;
			#(1*period);
			ramwe = 1'b0;
		end
	endtask

	task transmitData(input[7:0] value);
		begin
			ram_Addr = 12'h0C6;
			dbus_in = value;
			ramwe = 1'b1;
			#(1*period);
			ramwe = 1'b0;
		end
	endtask

	task readData;
		begin
			ram_Addr = 12'h0C6;
			ramre = 1'b1;
			#(1*period);
			ramre = 1'b0;
		end
	endtask

	task readUCSRnA;
		begin
			ram_Addr = 12'h0C0;
			ramre = 1'b1;
			#(1*period);
			ramre = 1'b0;
		end
	endtask

	task readUCSRnB;
		begin
			ram_Addr = 12'h0C1;
			ramre = 1'b1;
			#(1*period);
			ramre = 1'b0;
		end
	endtask

	task readUCSRnC;
		begin
			ram_Addr = 12'h0C2;
			ramre = 1'b1;
			#(1*period);
			ramre = 1'b0;
		end
	endtask

	task write8bit_stop1(input[7:0] data);
		begin
			tb_serial = 0;			// start bit
			#(104*20*period);
			tb_serial = data[0];
			#(104*20*period);
			tb_serial = data[1];
			#(104*20*period);
			tb_serial = data[2];
			#(104*20*period);
			tb_serial = data[3];
			#(104*20*period)
			tb_serial = data[4];
			#(104*20*period);
			tb_serial = data[5];
			#(104*20*period);
			tb_serial = data[6];
			#(104*20*period);
			tb_serial = data[7];
			#(104*20*period);
			tb_serial = 1;			// stop bit
			#(104*20*period);
			tb_serial = 1;			// idle
			#(104*20*period);
		end
	endtask

	task write8bit_stop0(input[7:0] data);
		begin
			tb_serial = 0;			// start bit
			#(104*20*period);
			tb_serial = data[0];
			#(104*20*period);
			tb_serial = data[1];
			#(104*20*period);
			tb_serial = data[2];
			#(104*20*period);
			tb_serial = data[3];
			#(104*20*period)
			tb_serial = data[4];
			#(104*20*period);
			tb_serial = data[5];
			#(104*20*period);
			tb_serial = data[6];
			#(104*20*period);
			tb_serial = data[7];
			#(104*20*period);
			tb_serial = 0;			// stop bit
			#(104*20*period);
			tb_serial = 1;			// idle
			#(104*20*period);
		end
	endtask

	task write8bit_parity0(input[7:0] data);
		begin
			tb_serial = 0;			// start bit
			#(104*20*period);
			tb_serial = data[0];
			#(104*20*period);
			tb_serial = data[1];
			#(104*20*period);
			tb_serial = data[2];
			#(104*20*period);
			tb_serial = data[3];
			#(104*20*period)
			tb_serial = data[4];
			#(104*20*period);
			tb_serial = data[5];
			#(104*20*period);
			tb_serial = data[6];
			#(104*20*period);
			tb_serial = data[7];
			#(104*20*period);
			tb_serial = 0;			// parity bit = 0
			#(104*20*period);
			tb_serial = 1;			// stop bit = 1
			#(104*20*period);
			tb_serial = 1;			// idle
			#(104*20*period);
		end
	endtask

	task write8bit_parity1(input[7:0] data);
		begin
			tb_serial = 0;			// start bit
			#(104*20*period);
			tb_serial = data[0];
			#(104*20*period);
			tb_serial = data[1];
			#(104*20*period);
			tb_serial = data[2];
			#(104*20*period);
			tb_serial = data[3];
			#(104*20*period)
			tb_serial = data[4];
			#(104*20*period);
			tb_serial = data[5];
			#(104*20*period);
			tb_serial = data[6];
			#(104*20*period);
			tb_serial = data[7];
			#(104*20*period);
			tb_serial = 1;			// parity = 1
			#(104*20*period);
			tb_serial = 1;			// stop bit = 1
			#(104*20*period);
			tb_serial = 1;			// idle
			#(104*20*period);
		end
	endtask


endmodule
