class generator ;
  
  int loop = 0;
  mailbox #(transaction) drv_mbx;
  event done;
  event drvnext;
  
  function new (mailbox #(transaction) drv_mbx, event drvnext);
    this.drv_mbx = drv_mbx;
    this.drvnext = drvnext;
  endfunction
      
  task run();
    for(int i = 0; i < loop; i++) begin
      transaction tr,tr_copy ;
      tr = new();
      tr_copy = new();
      assert(tr.randomize()) else $error("[GEN]: Randomize fail");
      tr.print("GENERATOR ORIGINAL",0);

      tr_copy = tr.copy();
      drv_mbx.put(tr_copy);
      tr_copy.print("GENERATOR COPY",0);
      @(drvnext);
    end
	-> done;
  endtask
endclass