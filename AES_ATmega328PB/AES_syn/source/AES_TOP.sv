`timescale 1ns / 10ps

module aes_top (
    input  wire        clk,        // system clock
    input  wire        rst,      // active-low reset

    // SPI interface
    input  wire        sck,
    input  wire        mosi,
    input  wire        ss,
    output wire        miso
);

    // Internal connections
    wire        start_encrypt;
    wire        aes_done;
    wire        cbc_done;
    wire [127:0] pt, key, iv;
    wire [127:0] ct;
    wire        new_message;

    // AES core control
    wire        aes_start;
    wire [127:0] aes_in;
    wire [127:0] aes_key;
    wire [127:0] aes_out;

    // SPI <-> CBC + AES control
    spi_slave spi_core (
        .clk(clk),
        .rst(rst),
        .sck(sck),
        .mosi(mosi),
        .ss(ss),
        .miso(miso),
        .encryption_done(aes_done),

        .start_encryption(start_encrypt),
        .new_message(new_message),
        .plaintext(pt),
        .key(key),
        .iv(iv),
        .ciphertext(ct)
    );

    // CBC encryption wrapper
    cbc_logic cbc_core (
        .clk(clk),
        .rst(rst),
        .start(start_encrypt),
        .plaintext(pt),
        .key(key),
        .iv(iv),
        .new_message(new_message),     // You can wire this as an SPI command flag if needed
        .done(cbc_done),
        .ciphertext(ct),

        .aes_start(aes_start),
        .aes_done(aes_done),
        .aes_plaintext(aes_in),
        .aes_key(aes_key),
        .aes_ciphertext(aes_out)
    );

    // AES-128 block encryptor
    aes_main aes_core (
        .clk(clk),
        .rst(rst),
        .data_in(aes_in),
        .key(aes_key),
        .encrypt_start(aes_start),

        .data_out(aes_out),
        .encrypt_done(aes_done)
    );

endmodule
