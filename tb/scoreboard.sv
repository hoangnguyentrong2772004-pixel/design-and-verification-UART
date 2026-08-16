class scoreboard;
  
  mailbox #(transaction) sco_mbx;
  mailbox #(bit[7:0]) mbx_expect;  
  
  function new(mailbox #(transaction) sco_mbx, mailbox #(bit[7:0]) mbx_expect);
    this.sco_mbx = sco_mbx;
    this.mbx_expect = mbx_expect;
  endfunction
  
  task run();
    transaction tr;
    bit [7:0] exp;
    
    forever begin
      	sco_mbx.get(tr);
      	mbx_expect.get(exp);
      	
      if(tr.rx_data == exp)
        $display("PASS,Time = %0t TX_DATA = 0x%0h, RX_DATA = 0x%0h",$time, exp, tr.rx_data );
      else 
        $display("ERROR,Time = %0t TX_DATA = 0x%0h, RX_DATA = 0x%0h",$time,  exp, tr.rx_data);
    end

  endtask
endclass
