class test;
  environment env;
  mailbox #(transaction) drv_mbx;
  mailbox #(transaction) sco_mbx;
  mailbox #(bit [7:0]) mbx_expect;
  
  virtual uart_if vif;
  
  function new(virtual uart_if vif);
	this.vif = vif;
    	drv_mbx = new();
    	sco_mbx = new();
    	mbx_expect = new();
    
    	env = new(vif,drv_mbx,sco_mbx,mbx_expect);
  endfunction
  
  task run();
    env.g.loop = 100;
    env.run();
  endtask
endclass