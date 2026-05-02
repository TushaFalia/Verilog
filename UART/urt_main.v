module UART (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output wire tx
);

parameter BAUD_RATE = 9600; // Baud rate in bits per second

reg [3:0] state;
reg [7:0] shift_reg;
reg [3:0] bit_counter;
reg tx_reg;

assign tx = tx_reg;

parameter [15:0] BIT_PERIOD = 50000000 / BAUD_RATE; // Number of clock cycles per bit

localparam [3:0]
    IDLE = 4'b0000,
    START_BIT = 4'b0001,
    DATA_BITS = 4'b0010,
    STOP_BIT = 4'b0011;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        state <= IDLE; // Initialize the state to IDLE
        shift_reg <= 8'b0; // Clear the shift register
        bit_counter <= 4'b0; // Reset the bit counter
        tx_reg <= 1; // Set the TX line to idle (high)
    end
    else
    begin
        case (state)
            IDLE:
                if (start)
                begin
                    shift_reg <= data_in; // Load the data into the shift register
                    state <= START_BIT;
                    bit_counter <= 4'b0;
                    tx_reg <= 0; // Start bit (low)
                end
            START_BIT:
                begin
                    if (bit_counter == BIT_PERIOD - 1)
                    begin
                        state <= DATA_BITS;
                        bit_counter <= 4'b0;
                        tx_reg <= shift_reg[0]; // Send LSB of the data
                        shift_reg <= {shift_reg[6:0], 1'b0}; // Shift the data
                    end
                    else
                        bit_counter <= bit_counter + 1;
                end
            DATA_BITS:
                begin
                    if (bit_counter == BIT_PERIOD - 1)
                    begin
                        if (bit_counter == 7)
                        begin
                            state <= STOP_BIT;
                            bit_counter <= 4'b0;
                            tx_reg <= 1; // Stop bit (high)
                        end
                        else
                        begin
                            bit_counter <= bit_counter + 1;
                            tx_reg <= shift_reg[0]; // Send the next bit of data
                            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift the data
                        end
                    end
                    else
                        bit_counter <= bit_counter + 1;
                end
            STOP_BIT:
                begin
                    if (bit_counter == BIT_PERIOD - 1)
                    begin
                        state <= IDLE;
                        bit_counter <= 4'b0;
                        tx_reg <= 1; // TX line idle (high)
                    end
                    else
                        bit_counter <= bit_counter + 1;
                end
        endcase
    end
end

endmodule

