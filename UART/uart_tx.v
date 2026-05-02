
module uart_tx (clk, rst,data_input, flag_in, tx_out);


input clk, rst;

input  flag_in;
input [7:0] data_input;  

output reg tx_out;


parameter idle = 2'b 00;
parameter start = 2'b 01;
parameter bit_send = 2'b 10;
parameter stop  = 2'b 11;
parameter baudcycle = 434; // Here we need to sample the data of full period
//parameter half_baudcycle = 217; 

reg [1:0] state; 
reg [8:0] counter;   // As there is no clk in UART but there is baud rate. So for 50 MHZ clk and 115200 Baud Rate we need a counter of 
                    // 50000000/115200 = 434 counter. To sample the the incoming signal and to count upto 7 bit of data as UART has 7-8 bit of data
                   // normally
reg [2:0] activebit;
reg [7:0] datain_reg;  

always @(posedge clk) begin

    if (rst == 1) begin

        state <= idle;
        counter <= 0; 
        activebit <= 0;
        tx_out <= 0;  

    end

    else begin
        
        case (state)
        ///////////////////////////////////////////////////////////////////////////////////////////////
        idle : begin

            counter <= 0; 
            activebit <= 0;
            tx_out <= 1;   // As we want to mirror rx and tx data so in rx end, data has to be high in idle state and low in start state so tx data 
                          //  has to be high in idle state and low in the start state
                            

            state <= flag_in ?  start : idle;

        end

        //////////////////////////////////////////////////////////////////////////////////////////////
        start: begin

            tx_out <= 0; 
            datain_reg <= data_input; 

            if (counter > baudcycle) begin

                counter <= 0; 
                state <= bit_send; 
                
            end
            else begin

                counter <= counter + 1; 
                state <= start; 
            end

        end
        /////////////////////////////////////////////////////////////////////////////////////////////
        bit_send: begin

            if (counter > baudcycle) begin

                counter <= 0;
                activebit <= activebit + 1;
                tx_out <= datain_reg[activebit];

                if (activebit == 7) begin

                    state <= stop; 
                    
                end
                
                else begin
                    state <= bit_send;
                end
                
            end

            else begin
                counter <= counter + 1;
                state <= bit_send;
            end
  
        end

        ////////////////////////////////////////////////////////////////////////////////////////////
        stop: begin
            tx_out <= 1; 

            if (counter>baudcycle) begin
                state <= idle;
                counter <= 0;
                activebit <= 0;
            end

            else begin
                counter <= counter + 1;
                state <= stop; 
            end
      
        end 
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        default : begin
            state <= idle;
            counter <= 0; 
            activebit <= 0;
            tx_out <= 1; 
            end   


        endcase
    end


end

endmodule 















