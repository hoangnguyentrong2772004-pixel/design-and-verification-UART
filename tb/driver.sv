class drive;
  virtual uart_if vif;

  event drvnext;  
  mailbox #(transaction) drv_mbx;
  mailbox # (bit [7:0]) mbx_expect;
  
  coverage_uart cov;
  
  function new(virtual uart_if vif, mailbox #(transaction) drv_mbx, mailbox #(bit[7:0]) mbx_expect, event drvnext,coverage_uart cov);
    this.vif = vif;
    this.drv_mbx = drv_mbx;
    this.mbx_expect = mbx_expect;
    this.drvnext = drvnext;
    this.cov = cov; 
  endfunction
  
  task run();
    transaction tr;
    wait(vif.rst_n == 1);
    forever begin
      drv_mbx.get(tr);
      $display("DRV: GOT DATA at %0t", $time);
      
      cov.sample(tr.tx_data);

      @(posedge vif.clk);
      vif.tx_data <= tr.tx_data;
      vif.tx_start <= 1;
    
      @(posedge vif.clk);
      vif.tx_start <= 0;
      $display("DRV: WAIT tx_done...");
      wait(vif.tx_done == 1);
      
      repeat(2) @(posedge vif.clk);
      $display("DRV: tx_done DONE at %0t", $time);
      mbx_expect.put(tr.tx_data);
      
      tr.print("DRIVE",0);
      -> drvnext;
    end
  endtask
endclass