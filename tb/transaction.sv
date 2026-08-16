class transaction;

  rand bit [7:0] tx_data;
  bit [7:0] rx_data;
  
  function transaction copy();
    copy = new();
    copy.tx_data = this.tx_data;
    copy.rx_data = this.rx_data;
  endfunction
  
  function void print(string tag = "", bit show_rx = 1);       // trong gen thi chi in ra tx
    if(show_rx)
    	$display("Time=%0t [%s]  tx_data: 0x%0h rx_data: 0x%0h",$time,tag,tx_data,rx_data);
    else 
      	$display("Time=%0t [%s]  tx_data: 0x%0h ",$time,tag,tx_data);
  endfunction
  
endclass