`include "add_subtract.v"
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

output [7:0] alu1In;
output [7:0] alu2In;

reg [7:0] alu1In;
reg [7:0] alu2In;
wire [7:0] aluOut;

input [7:0] aluOut;

output [7:0] valueGetter;
reg [7:0] valueGetter;
input [7:0] valueGot;
wire [7:0] valueGot;

reg value1AddyFlag, value2AddyFlag;
/*
	Command format
	
	Message is 24 bits long
	First 6 bits are command code, next 18 are 9 each for value 1 and value 2
		left stuffed with 1 bit address flag. Flag is on if the value is an 
		address and not an value.
	
*/

always @(posedge clock) begin
	commandCode = commandIn[23:18];
	value1AddyFlag = commandIn[17];
	if value1AddyFlag begin
		value1Addy = commandIn[16:9];
		// Get value1 from memory using this addy
		valueGetter = value1Addy;
		#10 value1Out = valueGot;
	end else begin
		value1Out = commandIn[16:9];
	end		
	value2AddyFlag = commandIn[8];
	if value2AddyFlag begin
		value2Addy = commandIn[7:0];
		// Get value2 from memory using this addy
		valueGetter = value1Addy;
		#10 value2Out = value2Addy;
	end else begin
		value2Out = commandIn[7:0];
	end

	if (commandCode == 6'b000001) begin //add
		alu1In = value1Out;
		alu2In = value2Out;
		opcodeOut = 4'b0001;
		#10 //wait for ALU execution
		ACC = aluOut;
	end
	if (commandCode == 6'b000010) begin //sub
		alu1In = value1Out;
		alu2In = value2Out;
		opcodeOut = 4'b0010;
		#10 //wait for ALU execution
		ACC = aluOut;
	end
	if (commandCode == 6'b000011) begin //invert
		alu1In = value1Out;
		opcodeOut = 4'b0011;
		#10
		value2Out = aluOut;
	end
	if (commandCode == 6'b000100) begin //mov
		value2Out = value1Out; //Addresses were input, overwwrite output
	end
	if (commandCode == 6'b000101) begin //jfe
	
	end
	if (commandCode == 6'b000110) begin //jfl
	
	end
	if (commandCode == 6'b000111) begin //jfg
	
	end
end

add_subtract(clock?, opcodeOut, alu1In, alu2In, out);
