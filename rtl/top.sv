module top_uart (
    input  wire clk,
    input  wire rst_n,

    input  wire       tx_start,
    input  wire [7:0] tx_data,

    output wire tx_out,
    output wire tx_done,

    output wire [7:0] rx_data,
    output wire       rx_done
);

    wire tx_serial;

    uart_tx u_tx (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_done(tx_done),          
        .tx_out(tx_serial)  
    );

    uart_rx u_rx (
        .clk(clk),
        .rst_n(rst_n),
        .rx_in(tx_serial),   
        .rx_out(rx_data),
        .rx_done(rx_done)
    );
	assign tx_out = tx_serial;
endmodule