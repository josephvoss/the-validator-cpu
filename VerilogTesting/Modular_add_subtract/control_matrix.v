module control_matrix(
clock,
commandIn,
value1In,
//value2In,
opcodeOut,
value1Out,
value1Addy,
//value2Out,
//value2Addy,
instructionPointer
);

input clock;
input [23:0] commandIn;
input [7:0] value1In, value2In; //only used if addy specified
output [5:0] opcodeOut;
output [7:0] value1Out, value2Out, value1Addy, value2Addy, insturctionPointer;

wire clock;
wire [23:0] commandIn;
wire [7:0] value1In, value2In; //only used if addy specified
reg [5:0] opcodeOut;
reg [7:0] value1Out, value2Out, value1Addy, value2Addy, insturctionPointer;

reg [5:0] commandCode;	

/*
	Command format
	
	Message is 24 bits long
	First 6 bits are command code, next 18 are 9 each for value 1 and value 2
		left stuffed with 1 bit address flag. Flag is on if the value is an 
		address and not an value.
	
*/

always @(posedge clock) begin
	commandCode = commandIn[23:17];
	if (commandCode == 6'b000001) begin //add
	end
	if (commandCode == 6'b000010) begin //sub
	end
	if (commandCode == 6'b000011) begin //invert
	end
	if (commandCode == 6'b000100) begin //mov
	end
	if (commandCode == 6'b000101) begin //jfe
	end
	if (commandCode == 6'b000110) begin //jfl
	end
	if (commandCode == 6'b000111) begin //jfg
	end
end
