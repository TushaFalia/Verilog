module uart_rx (clk, rst, rx_in, rx_out, rx_flag);

input clk, rst, rx_in;

output reg [7:0] rx_out;
output reg rx_flag;  // This will ensure the starting of transmit when it turns to 1 as we want to mirror receive data on the transmit side


parameter idle = 2'b00;
parameter start = 2'b01;
parameter bit_receive = 2'b10;
parameter stop  = 2'b11;
parameter baudcycle = 434;
parameter half_baudcycle = 217; 

reg [1:0] state;   //, next_state; 
reg [8:0] counter;   // As there is no clk in UART but there is baud rate. So for 50 MHZ clk and 115200 Baud Rate we need a counter of 
                    // 50000000/115200 = 434 counter. To sample the the incoming signal and to count upto 7 bit of data as UART has 7-8 bit of data
                    // normally

reg [2:0] activebit; 
reg reg_in1; 
//reg rx_out1; 

always @(posedge clk) begin

      reg_in1 <= rx_in;
   // reg_f <= reg_g;
   // reg_e <= reg_f;
   // reg_d <= reg_
     // reg_out1 <= reg_in1;
//
    
end


always @(posedge clk) begin

    if (rst==1) begin

        state = idle;
        counter = 0; 
        activebit = 0;
        rx_flag = 0; 

    end

    else begin
        
        case (state)
///////////////////////////////////////////////////////////////////////////////////////////////
        idle : begin

        counter = 0; 
        activebit = 0;
        if (reg_in1 == 0) begin
        state = start;
        end

        else begin
            state = idle;
            counter = 0;
            activebit = 0;
        end


        end
//////////////////////////////////////////////////////////////////////////////////////////////
        start: begin
            if (counter > half_baudcycle ) begin   // We need half baud cycle to sample the start signal/data, beacuse at the middle position it is a stable signal

                state = reg_in1 ?  idle : bit_receive; // change  
                counter = 0; 
            end

            else begin
                
                counter = counter + 1;
                
            end
          

        end
////////////////////////////////////////////////////////////////////////////////////////////
        bit_receive: begin

            if (counter > baudcycle) begin  // one half to another half distance is 434
                rx_out[activebit] = reg_in1; 
                counter = 0;
                activebit = activebit +1; 
                if (activebit == 3'b111) begin
                    state = stop;
                end
                else begin
                    state = bit_receive;
                end
            end

            else begin
                counter = counter +1;
                state = bit_receive; 
            end
          
        end
///////////////////////////////////////////////////////////////////////////////////////////
        stop: begin
            if (counter > baudcycle) begin

            state = idle;
            counter = 0;
            activebit = 0;
            rx_flag = 1;
                
            end

            else begin
                state = stop;
                counter = counter +1; 
            end
               
        end 

        default : begin
            state = idle;
            counter = 0;
            activebit = 0;
            rx_flag = 0;
            end   

        endcase

    end
    
//end

//initial begin
    
   // state = idle;
    //state = start;
    //state = bit_receive;
    //state =stop; 

end


endmodule
