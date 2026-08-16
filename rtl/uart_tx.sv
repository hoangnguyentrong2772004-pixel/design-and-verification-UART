module uart_tx( input clk, rst_n, tx_start ,input[7:0] tx_data, output reg tx_done, output reg tx_out);
  
  parameter CLK_FREQ = 50_000_000;
  parameter BAUDRATE = 9600;
  localparam CLK_PER_BIT = CLK_FREQ / BAUDRATE ;
  localparam CNT_WIDTH = $clog2(CLK_PER_BIT);
  
  localparam [1:0]  	IDLE = 2'b00,
  						START = 2'b01,
  						DATA = 2'b10,
  						STOP = 2'b11;
  
  reg [1:0] state ;
  reg [CNT_WIDTH - 1:0] counter ;
  reg [3:0] index;
  reg [9:0] shift_tx_data ;
  
  always@(posedge clk or negedge rst_n) 
    begin
      if(!rst_n)
        begin
          state <= IDLE;
          counter <= 0 ;
          index <= 4'hF;
          shift_tx_data <= 10'b0;
          tx_done <= 1'b0;
          tx_out <= 1'b1;
        end
      else begin
        tx_done <= 1'b0;
       
        case(state)
          
          IDLE: begin
            tx_out <= 1'b1;
            index <= 4'hF;
            if(tx_start)
              begin
                state <= START;
                shift_tx_data <= {1'b1,tx_data,1'b0};
                counter <= 0;
              end
          end
          
          
          START: begin
            tx_out <= shift_tx_data[0];
            if(counter == CLK_PER_BIT - 1)
              begin
                counter <= 0 ;
                state <= DATA;
                index <= 0;
              end
            else
              counter <= counter + 1;
          end
          
          DATA: begin
            tx_out <= shift_tx_data[index + 1];
            if(counter == CLK_PER_BIT - 1)  
              begin        
              	counter <= 0;
              	if(index == 7)
                	state <= STOP;
                else
                  	index <= index + 1;
              end
            else
              counter <= counter + 1;       
          end
           
          STOP: begin
            tx_out <= 1'b1;
            if(counter == CLK_PER_BIT - 1)
              begin
                counter <=0;
                tx_done <= 1'b1;
                state <= IDLE;
                index <= 0;
              end
            else
              counter <= counter + 1;
          end
               
          default : state <= IDLE;
        endcase
    end
  end
endmodule