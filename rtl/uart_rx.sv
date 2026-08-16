module uart_rx(input clk, rx_in, rst_n, output reg[7:0] rx_out,output reg rx_done);
  
  
  parameter CLK_FREQ = 50_000_000;
  parameter OVERSAMPLE = 16 ;
  parameter BAUDRATE = 9600;
  
  localparam SAMPLE_TICK = CLK_FREQ / (BAUDRATE * OVERSAMPLE);     //325
  localparam CNT_WIDTH = $clog2(SAMPLE_TICK);
  localparam [1:0]  	IDLE = 2'b00,
  						START = 2'b01,
  						DATA = 2'b10,
  						STOP = 2'b11;
   
  reg [3:0] counter_tick;             // SAMPLE TAI 7 or ́8
  reg [CNT_WIDTH-1:0] counter;				 // 325
  reg [3:0] index ;
  reg [1:0] state ;
  reg rx_sync1,rx_sync2;
  
  always@(posedge clk) begin
    rx_sync1 <= rx_in;
    rx_sync2 <= rx_sync1;
  end
  	
  always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
      begin
        counter_tick <= 0;
        counter <= 0;
        index <= 0;
        state <= IDLE;
        rx_out <= 8'b0;
        rx_done <= 1'b0;
      end else begin
        rx_done <= 1'b0;
        
   
        case(state)
          
          IDLE: begin
            counter <= 0;
            index <= 4'hF;
            counter_tick <= 0;
            if (rx_sync2 == 1'b0) 
              state <= START ;
          end
          
          
          START: begin
            if(counter == SAMPLE_TICK - 1)                        //325
              begin
                counter <= 0;			
                if(counter_tick == 7) 
                  begin
                    if(rx_sync2 == 1'b0)
                      begin
                        state <= DATA;
                        counter_tick <= 0;
                        index <= 0;
                      end
                    else begin
                      state <= IDLE;
                    end
                  end
                else
                  counter_tick <= counter_tick + 1;						// 15
              end
            else
              counter <= counter + 1 ;
          end
          
          
          DATA: begin
            if(counter == SAMPLE_TICK - 1) begin		//325
              counter <= 0;
              if(counter_tick == 15) begin
                counter_tick <= 0;
                rx_out[index] <= rx_sync2;
                if(index == 7)
                  state <= STOP;
                else
                  index <= index + 1;
              end
              else
                counter_tick <= counter_tick + 1;
            end
            else
              counter <= counter + 1;
          end
            		
          
          STOP: begin
            if(counter == SAMPLE_TICK - 1)
              begin          
                counter <= 0;
                if(counter_tick == 15)
                  begin
                    counter_tick <= 0;
                    if(rx_sync2 == 1'b1)
                      begin
                        state <= IDLE;
                        rx_done <= 1'b1;
                        index <= 0;
                      end
                    else begin
                      state <= IDLE;
                      index <= 0;
                      counter_tick <= 0;
                    end
                  end
                else
                  counter_tick <= counter_tick + 1;
              end
            else
              counter <= counter + 1;
          end
          
          default: state <= IDLE;
          endcase
        end    
  end
endmodule