class monitor;
  virtual uart_if vif;
  mailbox #(transaction) sco_mbx;
  
  function new(virtual uart_if vif, mailbox #(transaction) sco_mbx);
    this.vif = vif;
    this.sco_mbx = sco_mbx;
  endfunction
  
  task run();
    transaction tr;
    
    forever begin
      @(posedge vif.rx_done) 
      tr = new();
      tr.rx_data = vif.rx_data;
      $display("MONITOR RECEIVE RX = 0x%0h",tr.rx_data);
      
      sco_mbx.put(tr);
      
    end
  endtask
endclass