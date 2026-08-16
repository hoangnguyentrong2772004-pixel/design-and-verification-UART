module tb;
  reg clk = 0;
  always #5 clk = ~clk;
  uart_if vif(clk);
  top_uart dut(.clk(clk),
               .rst_n(vif.rst_n),
               .tx_start(vif.tx_start),
               .tx_data(vif.tx_data),
               .tx_done(vif.tx_done),
               .tx_out(vif.tx_out),
               .rx_data(vif.rx_data),
               .rx_done(vif.rx_done));
  
  initial begin
    vif.rst_n = 0;
    repeat(5) @(posedge clk);
    vif.rst_n = 1;
  end
  
  initial begin
    automatic test t = new(vif);
    #200;
    t.run();
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
     