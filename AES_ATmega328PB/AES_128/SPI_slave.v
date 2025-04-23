`timescale 1ns / 10ps

module spi_slave (
    input  wire       clk,        // System clock
    input  wire       rst,      // Active-low reset
    input  wire       sck,       // SPI clock
    input  wire       mosi,       // SPI Master Out Slave In
    input  wire       ss,       // SPI Chip Select (active low)
    output wire       miso,       // SPI Master In Slave Out

    // AES Core Interface
    output reg        start_encryption,
    output reg        new_message,
    input  wire       encryption_done,
    output reg [127:0] plaintext,
    output reg [127:0] key,
    output reg [127:0] iv,
    input  wire [127:0] ciphertext
);

// -----------------------------------
// Parameters
// -----------------------------------
localparam CMD_WRITE_PLAIN      = 8'h01;
localparam CMD_WRITE_KEY        = 8'h02;
localparam CMD_WRITE_IV         = 8'h03;
localparam CMD_START_AES        = 8'h04;
localparam CMD_READ_CIPHER      = 8'h05;
localparam CMD_START_AES_FIRST  = 8'h06;
localparam CMD_READ_STATUS      = 8'hFF;

// -----------------------------------
// Registers
// -----------------------------------
reg [7:0] cmd;
reg [7:0] spi_rx_byte;
// reg [7:0] spi_tx_byte;
reg [3:0] bit_cnt;
reg [4:0] byte_cnt;
reg [7:0] miso_cnt;

reg [127:0] tx_buffer;
reg [127:0] rx_buffer;

reg spi_rx_ready;
reg spi_rx_ready_samp;
wire spi_rx_done;

assign spi_rx_done = spi_rx_ready && !spi_rx_ready_samp;

reg miso_reg;

// State machine
// typedef enum logic [2:0] {
//     IDLE,
//     LOAD_CMD,
//     LOAD_DATA,
//     SEND_DATA
// } state_t;

localparam IDLE  = 2'b00;
localparam LOAD_CMD    = 2'b01;
localparam LOAD_DATA     = 2'b10;
localparam SEND_DATA    = 2'b11;

reg [1:0] state;

// -----------------------------------
// SPI Shift Register (RX)
// -----------------------------------
always @(posedge sck or negedge rst) begin
    if (!rst) begin
        spi_rx_byte <= 8'b0;
        bit_cnt <= 0;
        spi_rx_ready <= 0;
    end else if (!ss) begin
        spi_rx_byte <= {spi_rx_byte[6:0], mosi};

        case (state)
            IDLE:       bit_cnt <= bit_cnt + 1;
            LOAD_CMD:   bit_cnt <= bit_cnt + 1;
            LOAD_DATA:  bit_cnt <= bit_cnt + 1;
            SEND_DATA:  bit_cnt <= bit_cnt;
        endcase
        

        if (bit_cnt == 7) begin
            spi_rx_ready <= 1;
            bit_cnt <= 0;
        end else begin
            spi_rx_ready <= 0;
        end
    end else begin
        if (bit_cnt == 7) begin
            spi_rx_ready <= 1;
            bit_cnt <= 0;
        end else begin
            spi_rx_ready <= 0;
        end
    end
end

// -----------------------------------
// SPI Shift Register (TX)
// -----------------------------------
always @(posedge sck or negedge rst) begin
    if (!rst) begin
        miso_reg <= 0;
        miso_cnt <= 0;
    end else begin
        case (state)
            SEND_DATA: begin
                miso_reg <= tx_buffer[127];
                if (!ss) begin
                    tx_buffer <= {tx_buffer[126:0], 1'b0};
                    miso_cnt <= miso_cnt + 1;
                    if (miso_cnt == 127) begin
                        miso_cnt <= 0;
                        state <= IDLE;
                    end
                end else begin
                    if (miso_cnt == 127) begin
                        miso_cnt <= 0;
                        state <= IDLE;
                    end
                end
            end
        endcase
    end
end

assign miso = miso_reg;

// -----------------------------------
// spi_rx_ready sampling
// -----------------------------------
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        spi_rx_ready_samp <= 0;
    end else begin
        spi_rx_ready_samp <= spi_rx_ready;
    end
end

// -----------------------------------
// Main State Machine
// -----------------------------------
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        state <= IDLE;
        cmd <= 8'h00;
        byte_cnt <= 0;
        start_encryption <= 0;
    end else begin
        start_encryption <= 0; // Default
        new_message <= 0;

        case (state)
            IDLE: begin
                if (spi_rx_done) begin
                    cmd <= spi_rx_byte;
                    byte_cnt <= 0;
                    state <= LOAD_CMD;
                end
            end

            LOAD_CMD: begin
                case (cmd)
                    CMD_WRITE_PLAIN,    // 00
                    CMD_WRITE_KEY,      // 01
                    CMD_WRITE_IV: state <= LOAD_DATA;   // 02

                    CMD_START_AES: begin    // 03
                        start_encryption <= 1;
                        state <= IDLE;
                    end

                    CMD_READ_CIPHER: begin  // 04
                        tx_buffer <= ciphertext;
                        state <= SEND_DATA;
                    end

                    CMD_READ_STATUS: begin  // 05
                        tx_buffer <= {120'd0, 7'd0, encryption_done};
                        state <= SEND_DATA;
                    end

                    CMD_START_AES_FIRST: begin  // 06
                        start_encryption <= 1;
                        new_message <= 1;
                        state <= IDLE;
                    end

                    default: state <= IDLE;
                endcase
            end

            LOAD_DATA: begin
                if (spi_rx_done) begin
                    rx_buffer <= {rx_buffer[119:0], spi_rx_byte};
                    byte_cnt <= byte_cnt + 1;
                    if (byte_cnt == 15) begin
                        case (cmd)
                            CMD_WRITE_PLAIN: plaintext <= {rx_buffer[119:0], spi_rx_byte};
                            CMD_WRITE_KEY:   key       <= {rx_buffer[119:0], spi_rx_byte};
                            CMD_WRITE_IV:    iv        <= {rx_buffer[119:0], spi_rx_byte};
                        endcase
                        state <= IDLE;
                    end
                end
            end

        endcase
    end
end

endmodule