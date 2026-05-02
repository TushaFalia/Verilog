`include "uart_rx.v"

`timescale 1ps/1ps

module uart_rx_tb ();

reg clk, rst, rx_in;
wire [7:0] rx_out;


uart_rx dut (.clk(clk), .rst(rst), .rx_in(rx_in), .rx_out(rx_out));

initial begin

$dumpfile ("uart_rx.vcd");
$dumpvars (0, uart_rx_tb);
end

initial begin
    clk = 1'b0;
    forever begin
        #10 clk = ~clk;
    end
end

initial begin
    
    rst = 1'b1;
    rx_in = 1'b1;

    #20

    rst = 1'b0;
    rx_in = 1'b0;


    #20

    rst = 1'b0;
    rx_in = 1'b1;

    #10

    rst = 1'b0;
    rx_in = 1'b1;

    #10


    rst = 1'b0;
    rx_in = 1'b1;

    #10


    rst = 1'b0;
    rx_in = 1'b1;

    #10


    rst = 1'b0;
    rx_in = 1'b0;

    #10

    rst = 1'b0;
    rx_in = 1'b1;

    #10

    rst = 1'b0;
    rx_in = 1'b0;

    #10

    rst = 1'b0;
    rx_in = 1'b1;

    #80

$finish; 
end

endmodule 