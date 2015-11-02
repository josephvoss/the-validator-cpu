`timescale 1ns / 1ps
`include "simple_softCPU.v"

module implementation_wrapper(
	input[7:0] valueIn,
	input clock,
	output[7:0] LED,
	output[7:0] SevenSegment, //just turns 7 segment display off
	output[2:0] Enable //just turns 7 segment display off
   );

wire [23:0] commandIn;
reg [15:0] staticCommandIn;
reg [7:0] value1In, value2In; //only used if addy specified
wire [7:0] value1Out, value2Out, value1Addy, value2Addy, instructionPointer, ACC;

initial begin
	// 000001 - adder code, 0 addy flag, 000000001 1st value
	// 0 addy flag, 00000000 2nd value initially
	staticCommandIn = 16'b0000100000101010;
end

assign commandIn = {staticCommandIn, ~valueIn};
assign LED = ACC;
assign SevenSegment = 8'b00000000;
assign Enable = 3'b111;

control_matrix basicAdder(
clock,
commandIn,
value1In,
value2In,
value1Out, //needed?
value1Addy, //needed?
value2Out,
value2Addy,
instructionPointer,
ACC
);

endmodule
