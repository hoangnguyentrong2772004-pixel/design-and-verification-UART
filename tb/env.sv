class environment;
  event drvnext;
  
  generator g;
  drive d;
  monitor m;
  scoreboard s;
  coverage_uart c;
  
  mailbox #(transaction) drv_mbx = new ();
  mailbox #(transaction) sco_mbx = new ();
  mailbox #(bit [7:0]) mbx_expect = new();
  
  virtual uart_if vif;
  
  function new(virtual uart_if vif,
               mailbox #(transaction) drv_mbx,
               mailbox #(transaction) sco_mbx,
               mailbox #(bit [7:0]) mbx_expect);
    this.drv_mbx = drv_mbx;
    this.sco_mbx = sco_mbx;
    this.mbx_expect = mbx_expect;
    this.vif = vif;
    g = new(drv_mbx, drvnext);
    c = new();
    d = new(vif, drv_mbx, mbx_expect, drvnext,c);
    m = new(vif,  sco_mbx);
    s = new(sco_mbx, mbx_expect);
   
  endfunction
  
  task run();
    fork
      g.run();
      d.run();
      m.run();
      s.run();
    join_none
    
    wait(g.done.triggered);
   
    $display("SPECIAL COVERAGE = %0.2f%%",c.uart_cg.get_coverage());
    $display("ALL COVERAGE = %0.2f%%",c.uart_all.get_coverage() );
     #100;
    $finish;
  endtask
endclass