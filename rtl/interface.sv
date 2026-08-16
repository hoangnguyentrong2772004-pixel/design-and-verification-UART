interface uart_if(input logic clk);
  logic rst_n;
  
  logic tx_start;
  logic [7:0] tx_data;
  logic tx_done;
  logic tx_out;
  
  logic [7:0] rx_data;
  logic rx_done;
endinterface