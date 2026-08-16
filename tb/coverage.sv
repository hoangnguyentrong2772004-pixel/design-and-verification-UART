class coverage_uart;
  bit [7:0] tx_data;
  covergroup uart_cg;
    cp_tx_da : coverpoint tx_data{
      bins zero			= {8'h0};
      bins all_one 		= {8'hFF};
      bins patern_55	= {8'h55};
      bins patern_AA 	= {8'HAA};
    }
  endgroup
  
  covergroup uart_all;
    cp_all_tx : coverpoint tx_data{
      bins all_value[] = {[8'h00 : 8'hFF]};
    }
  endgroup
  
  function new();
    uart_cg = new();
    uart_all = new();
  endfunction
  
  function void sample(bit[7:0] data);
    tx_data = data;
    uart_cg.sample();
    uart_all.sample();
  endfunction
endclass