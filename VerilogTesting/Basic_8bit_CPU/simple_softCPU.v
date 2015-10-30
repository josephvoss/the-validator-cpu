module control_matrix(
clock,
commandIn,
value1In,
value2In,
value1Out, //needed?
value1Addy, //needed?
value2Out,
value2Addy,
instructionPointer
);

input clock;
input [23:0] commandIn;
input [7:0] value1In, value2In; //only used if addy specified
output [7:0] value1Out, value2Out, value1Addy, value2Addy, insturctionPointer;

wire clock;
wire [23:0] commandIn;
wire [7:0] value1In, value2In; //only used if addy specified
reg [7:0] value1Out, value2Out, value1Addy, value2Addy, insturctionPointer;

reg [5:0] commandCode;	
reg [7:0] value1Internal, value2Internal;


output [7:0] valueGetter;
reg [7:0] valueGetter;
input [7:0] valueGot;
wire [7:0] valueGot;

reg value1AddyFlag, value2AddyFlag, overwriteOutput;
/*
	Command format
	
	Message is 24 bits long
	First 6 bits are command code, next 18 are 9 each for value 1 and value 2
		left stuffed with 1 bit address flag. Flag is on if the value is an 
		address and not an value.
	
*/

always @(posedge clock) begin
	//Use valueGetter/valueGot to get command code? Leaving this way for command by command debugging on hardware, but for actual implementation need to be automatic with insturction pointer 

	commandCode = commandIn[23:18];

//Parse Values
//-----------------------------------------------------------------------------
	value1AddyFlag = commandIn[17];
	if value1AddyFlag begin
		value1Addy = commandIn[16:9];
		// Get value1 from memory using this addy
		if (value1Addy == 8'b11111111) begin //ACC flag
			value1Internal = ACC;
		end else begin
			valueGetter = value1Addy;
			#10 value1Internal = valueGot; //wait to get value
		end
	end else begin
		value1Internal = commandIn[16:9];
	end		
	value2AddyFlag = commandIn[8];
	if value2AddyFlag begin
		value2Addy = commandIn[7:0];
		// Get value2 from memory using this addy
		if (value2Addy == 8'b11111111) begin //ACC flag
			value2Internal = ACC;
		end else begin
			valueGetter = value2Addy;
			#10 value2Internal = valueGot; //wait to get value
		end
	end else begin
		value2Internal = commandIn[7:0];
	end
//--------------------------------------------------------------------------------

	instructionPointer = instructionPointer + 1;

//Parse Command Code and do Calculation
//--------------------------------------------------------------------------------
	if (commandCode == 6'b000001) begin //add
		ACC = value1Internal + value2Internal;
	end
	if (commandCode == 6'b000010) begin //sub
		ACC = value1Internal - value2Internal;
	end
	if (commandCode == 6'b000011) begin //invert
		value2Internal = ~value1In + 1;
		overwriteOutput = 1;
	end
	if (commandCode == 6'b000100) begin //mov
		value2Internal = value1Internal; //Addresses were input, overwrite output
		overwriteOutput = 1;
	end
	if (commandCode == 6'b000101) begin //jfe
		if (value1 == 0) begin
			instructionPointer = value2;
		end	
	end
	if (commandCode == 6'b000110) begin //jfl
		if (value1 < 0) begin
			instructionPointer = value2;
		end
	end
	if (commandCode == 6'b000111) begin //jfg
		if (value1 > 0) begin
			instructionPointer = value2;
		end
	end
//--------------------------------------------------------------------------------

//Output value
//--------------------------------------------------------------------------------
	if (overwriteOutput && value2AddyFlag) begin //only command with output have value2In as an address
		//overwrite contents of value2 with this value
		//will have to change to correctly identify with memory storage
		value2Out = value2Internal;
		//value2Addy should still be valid
	end
//--------------------------------------------------------------------------------

end
