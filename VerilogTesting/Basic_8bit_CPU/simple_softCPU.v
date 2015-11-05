module control_matrix(
clock,
instruction,
instructionPointer,
addressIn,
valueIn,
addressOut,
valueOut
);

input clock;
input [25:0] instruction;

//Memory interfaces, attaches to chips, NOT THE USERS
output [15:0] instructionPointer;
input [7:0] valueIn; 
input [15:0] addressIn;
output [7:0] valueOut;
output [15:0] addressOut;

wire clock;
wire [7:0] valueIn;
//Don't give them names, make a nested data bus? Impossiburu in verilog
reg [7:0] valueOut, value1Internal, value2Internal, value3Internal, registerA, registerB, registerC, registerD, registerE, registerF, registerG, registerH, registerI, registerJ, registerK, registerL, registerM, registerN, registerO, registerP;
reg [15:0] value1Addy, value2Addy, instructionPointer;

reg [3:0] commandCode;	

//Register Selector Block
reg addyFlag, reg1Flag, reg2Flag; //needed?
reg [4:0] registerSelector;
reg [3:0] valueInternalSelector;
reg [7:0] tempValueInternal;
reg writeToReg;
/*
	Command format
	
	Message is 26 bits long
	First 6 bits are command code, next 18 are 9 each for value 1 and value 2
		left stuffed with 1 bit address flag. Flag is on if the value is an 
		address and not an value.
	
*/

initial begin
	instructionPointer <= 0;
end

//Register Selector Block
//Assign tempValueInternal to desired value, register selector to desired register, and valueInternalSelector to which internal register to set it to

//Example of usage
	//register -> valueInternal
		//writeToReg = 0;
		//registerSelector = #; //Pick which register to use
		//valueInternalSelector = #; //Select where to store value internally
	//valueInternal ->	register
		//writeToReg = 1;
		//valueInternalSelector = #; //Pick which valueInternal to use
		//registerSelector = #; //Select which register to store valueInternal
		
always@(*) begin
	//Write data from Registers to valueInternals
	if (writeToReg == 0) begin
		if (registerSelector == 4'b0000) begin
			tempValueInternal = registerA;
		end else if (registerSelector == 4'b0001) begin
			tempValueInternal = registerB;
		end else if (registerSelector == 4'b0010) begin
			tempValueInternal = registerC;
		end else if (registerSelector == 4'b0011) begin
			tempValueInternal = registerD;
		end else if (registerSelector == 4'b0100) begin
			tempValueInternal = registerE;
		end else if (registerSelector == 4'b0101) begin
			tempValueInternal = registerF;
		end else if (registerSelector == 4'b0110) begin
			tempValueInternal = registerG;
		end else if (registerSelector == 4'b0111) begin
			tempValueInternal = registerH;
		end else if (registerSelector == 4'b1000) begin
			tempValueInternal = registerI;
		end else if (registerSelector == 4'b1001) begin
			tempValueInternal = registerJ;
		end else if (registerSelector == 4'b1010) begin
			tempValueInternal = registerK;
		end else if (registerSelector == 4'b1011) begin
			tempValueInternal = registerL;
		end else if (registerSelector == 4'b1100) begin
			tempValueInternal = registerM;
		end else if (registerSelector == 4'b1101) begin
			tempValueInternal = registerN;
		end else if (registerSelector == 4'b1110) begin
			tempValueInternal = registerO;
		end else if (registerSelector == 4'b1111) begin
			tempValueInternal = registerP;
		end
		if (valueInternalSelector == 1) begin
			value1Internal = tempValueInternal;
		end else if (valueInternalSelector == 2) begin
			value2Internal = tempValueInternal;
		end else if (valueInternalSelector == 3) begin
			value3Internal = tempValueInternal;
		end

	//Write data from valueInternals to Registers
	end else if (writeToReg) begin
		//Select value to use first!
		if (valueInternalSelector == 1) begin
			tempValueInternal = value1Internal;
		end else if (valueInternalSelector == 2) begin
			tempValueInternal = value2Internal;
		end else if (valueInternalSelector == 3) begin
			tempValueInternal = value3Internal;
		end

		if (registerSelector == 4'b0000) begin
			tempValueInternal = registerA;
		end else if (registerSelector == 4'b0001) begin
			registerB = tempValueInternal;
		end else if (registerSelector == 4'b0010) begin
			registerC = tempValueInternal;
		end else if (registerSelector == 4'b0011) begin
			registerD = tempValueInternal;
		end else if (registerSelector == 4'b0100) begin
			registerE = tempValueInternal;
		end else if (registerSelector == 4'b0101) begin
			registerF = tempValueInternal;
		end else if (registerSelector == 4'b0110) begin
			registerG = tempValueInternal;
		end else if (registerSelector == 4'b0111) begin
			registerH = tempValueInternal;
		end else if (registerSelector == 4'b1000) begin
			registerI = tempValueInternal;
		end else if (registerSelector == 4'b1001) begin
			registerJ = tempValueInternal;
		end else if (registerSelector == 4'b1010) begin
			registerK = tempValueInternal;
		end else if (registerSelector == 4'b1011) begin
			registerL = tempValueInternal;
		end else if (registerSelector == 4'b1100) begin
			registerM = tempValueInternal;
		end else if (registerSelector == 4'b1101) begin
			registerN = tempValueInternal;
		end else if (registerSelector == 4'b1110) begin
			registerO = tempValueInternal;
		end else if (registerSelector == 4'b1111) begin
			registerP = tempValueInternal;
		end
	end
end

always @(posedge clock) begin

	commandCode = instruction[25:22];

//Parse Values
//-----------------------------------------------------------------------------

//this should probably be done later
/*
	if (commandCode == 4'b0101) begin
			registerSelector = instruction[23:20];
			regFlag = 1;
	end else if (commandCode == 4'b0100 && instruction[22] && instruction[21]) begin
			registerSelector = instruction[20:17];
			regFlag = 1;
	end else if (!commandCode[3] && instruction[22]) begin
			registerSelector = instruction[17:13];
			regFlag = 1;
	end
*/
	//what about the multiple registers for add and sub? And output registers?


//--------------------------------------------------------------------------------

	instructionPointer = instructionPointer + 1;
	writeToReg = 0;

//Parse Command Code and do Calculation
//--------------------------------------------------------------------------------

	//Add command
	if (commandCode == 4'b0001) begin
		if (instruction[21]) begin
			//parse register info
			valueInternalSelector = 1;
			registerSelector = instruction[16:13]; //set value1Internal to register
			//value1Internal set by the always(*) block
			end
		else
			value1Internal = instruction[20:13];
		if (instruction[12]) begin
			//parse register info
			valueInternalSelector = 2;
			registerSelector = instruction[7:4];
			//value2Internal set by the always(*) block
			end
		else
			value2Internal <= instruction[11:4];
		value3Internal = value1Internal + value2Internal;
		//Now store value3Internal in the register
		writeToReg = 1;
		registerSelector = instruction[3:0];
		valueInternalSelector = 3;
	end


//--------------------------------------------------------------------------------

//Output value
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
end

endmodule
