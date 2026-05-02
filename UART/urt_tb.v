module UART_tb;

  // Inputs
  reg clk;
  reg reset;
  reg start;
  reg [7:0] data_in;

  // Outputs
  wire tx;

  // Instantiate the UART module
  UART uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(data_in),
    .tx(tx)
  );

  // Clock generation
  always begin
    #10 clk = ~clk; // Toggle the clock every 10 time units
  end

  // Initialize inputs
  initial begin
    clk = 0;
    reset = 1;
    start = 0;
    data_in = 8'b11011011;
    #10 reset = 0; // Deactivate reset
    #10 start = 1; // Activate start signal
    #100 $finish;
  end

  // Monitor the TX output
  always @(tx) begin
    $display("TX: %b", tx);
  end

endmodule


module UART_tb;

  // Inputs
  reg clk;
  reg reset;
  reg start;
  reg [7:0] data_in;

  // Outputs
  wire tx;

  // Instantiate the UART module
  UART uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(data_in),
    .tx(tx)
  );

  // Clock generation
  always begin
    #10 clk = ~clk; // Toggle the clock every 10 time units
  end

  // Initialize inputs
  initial begin
    clk = 0;
    reset = 1;
    start = 0;
    data_in = 8'b11011011;
    #10 reset = 0; // Deactivate reset
    #10 start = 1; // Activate start signal
    #100 $finish;
  end

  // Monitor the TX output
  always @(tx) begin
    $display("TX: %b", tx);
  end

endmodule

