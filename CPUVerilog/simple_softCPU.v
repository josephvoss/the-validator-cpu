module control_matrix(
clock,
instruction,
instructionPointer,
addressIn,
valueIn,
readValueIn,
addressOut,
valueOut,
writeValueOut
);

input clock;
input [25:0] instruction;

//Memory interfaces, attaches to chips, NOT THE USERS
output [15:0] instructionPointer;
input [7:0] valueIn; 
output [15:0] addressIn;
output [7:0] valueOut;
output [15:0] addressOut;
output readValueIn, writeValueOut;

wire clock;
wire [7:0] valueIn;
//Don't give them names, make a nested data bus? Impossiburu in verilog
reg [7:0] valueOut, value1Internal, value2Internal, value3Internal, registerA, registerB, registerC, registerD, registerE, registerF, registerG, registerH, registerI, registerJ, registerK, registerL, registerM, registerN, registerO, registerP;
reg [15:0] value1Addy, value2Addy, instructionPointer;

reg readValueIn, writeValueOut;
reg [15:0] addressIn, addressOut;

reg [3:0] commandCode;

//Register Selector Block
reg addyFlag, reg1Flag, reg2Flag; //needed?
/*
	Command format
	
	Message is 26 bits long. Specific syntax varies per command
	See Command\ Guide.txt for details
	
*/

initial begin
	instructionPointer <= 0;
	readValueIn <= 0;
	writeValueOut <= 0;
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
		

//Write data from Registers to valueInternals
task regToValue;
input [3:0] registerSelector;
input [3:0] valueInternalSelector;
reg [7:0] tempValueInternal;
begin
	if (registerSelector == 4'b0000) 
		tempValueInternal = registerA;
	else if (registerSelector == 4'b0001)
		tempValueInternal = registerB;
	else if (registerSelector == 4'b0010)
		tempValueInternal = registerC;
	else if (registerSelector == 4'b0011)
		tempValueInternal = registerD;
	else if (registerSelector == 4'b0100)
		tempValueInternal = registerE;
	else if (registerSelector == 4'b0101)
		tempValueInternal = registerF;
	else if (registerSelector == 4'b0110)
		tempValueInternal = registerG;
	else if (registerSelector == 4'b0111)
		tempValueInternal = registerH;
	else if (registerSelector == 4'b1000)
		tempValueInternal = registerI;
	else if (registerSelector == 4'b1001)
		tempValueInternal = registerJ;
	else if (registerSelector == 4'b1010)
		tempValueInternal = registerK;
	else if (registerSelector == 4'b1011)
		tempValueInternal = registerL;
	else if (registerSelector == 4'b1100)
		tempValueInternal = registerM;
	else if (registerSelector == 4'b1101)
		tempValueInternal = registerN;
	else if (registerSelector == 4'b1110)
		tempValueInternal = registerO;
	else if (registerSelector == 4'b1111)
		tempValueInternal = registerP;
		
	if (valueInternalSelector == 1)
		value1Internal = tempValueInternal;
	else if (valueInternalSelector == 2)
		value2Internal = tempValueInternal;
	else if (valueInternalSelector == 3)
		value3Internal = tempValueInternal;
end
endtask

//Write data from valueInternals to Registers
task valueToReg;
input [3:0] valueInternalSelector;
input [3:0] registerSelector;
reg [7:0] tempValueInternal;
begin
	if (valueInternalSelector == 1)
		tempValueInternal = value1Internal;
	else if (valueInternalSelector == 2)
		tempValueInternal = value2Internal;
	else if (valueInternalSelector == 3)
		tempValueInternal = value3Internal;

	if (registerSelector == 4'b0000)
		registerA = tempValueInternal;
	else if (registerSelector == 4'b0001)
		registerB = tempValueInternal;
	else if (registerSelector == 4'b0010)
		registerC = tempValueInternal;
	else if (registerSelector == 4'b0011)
		registerD = tempValueInternal;
	else if (registerSelector == 4'b0100)
		registerE = tempValueInternal;
	else if (registerSelector == 4'b0101)
		registerF = tempValueInternal;
	else if (registerSelector == 4'b0110)
		registerG = tempValueInternal;
	else if (registerSelector == 4'b0111)
		registerH = tempValueInternal;
	else if (registerSelector == 4'b1000)
		registerI = tempValueInternal;
	else if (registerSelector == 4'b1001)
		registerJ = tempValueInternal;
	else if (registerSelector == 4'b1010)
		registerK = tempValueInternal;
	else if (registerSelector == 4'b1011)
		registerL = tempValueInternal;
	else if (registerSelector == 4'b1100)
		registerM = tempValueInternal;
	else if (registerSelector == 4'b1101)
		registerN = tempValueInternal;
	else if (registerSelector == 4'b1110)
		registerO = tempValueInternal;
	else if (registerSelector == 4'b1111)
		registerP = tempValueInternal;
end
endtask

always @(posedge clock) begin

	#4//delay for memory instruction reading in

	commandCode = instruction[25:22];

	instructionPointer = instructionPointer + 3; //instruction is 3 bytes long

	//Add command
	if (commandCode == 4'b0001) begin
		if (instruction[21]) begin
			regToValue(instruction[16:13], 1);
			//value1Internal set by the always(*) block
		end
		else
			value1Internal = instruction[20:13];
		if (instruction[12]) begin 
			regToValue(instruction[7:4], 2);
			//value2Internal set by the always(*) block
		end
		else
			value2Internal = instruction[11:4];
		value3Internal = value1Internal + value2Internal;
		//Now store value3Internal in the register
		valueToReg(3, instruction[3:0]);
	end

	//Sub command
	//COMBINE WITH ABOVE? Identical except for - instead of +
	else if (commandCode == 4'b0011) begin	
		if (instruction[21]) begin
			regToValue(instruction[16:13], 1);
			//value1Internal set by the always(*) block
		end
		else
			value1Internal = instruction[20:13];
		if (instruction[12]) begin 
			regToValue(instruction[7:4], 2);
			//value2Internal set by the always(*) block
		end
		else
			value2Internal = instruction[11:4];
		value3Internal = value1Internal - value2Internal;
		//Now store value3Internal in the register
		valueToReg(3, instruction[3:0]);
	end

	//Inv command
	else if (commandCode == 4'b0010) begin
		if (instruction[21]) 
			regToValue(instruction[16:13], 1);
		else
			value1Internal = instruction[20:13];
		value3Internal = ~value1Internal;
		valueToReg(3, instruction[3:0]);
	end	

	//Mov commad
	else if (commandCode == 4'b0100) begin
		if (instruction[21]) begin //read value from mem
			if (instruction[20]) begin
				readValueIn = 1;
				addressIn = instruction[19:3]; //addy in or addy out?
				#1 value1Internal = valueIn; //wait for value to be fetched
				readValueIn = 0;
			end
			else
				value1Internal = instruction[11:3];
			valueToReg(value1Internal, instruction[3:0]);
		end
		else if (instruction[20]) begin
			//write value to memory
			if (instruction[20]) begin //write value from reg
				writeValueOut = 1;
				regToValue(instruction[19:15], 1);
				valueOut = value1Internal;
				addressOut = instruction[15:0]; //addy in or addy out?
			end
		end
	end

	//Jfl command
	else if (commandCode == 4'b0101) begin
		regToValue(instruction[21:18], 1);
		if (value1Internal[7])
			instructionPointer = instruction[17:2];
	end

	//Jfe command
	else if (commandCode == 4'b0110) begin
		regToValue(instruction[21:18], 1);
		if (value1Internal == 0)
			instructionPointer = instruction[17:2];
	end

	//Jfg command
	else if (commandCode == 4'b0111) begin
		regToValue(instruction[21:18], 1);
		if (value1Internal > 0 && !value1Internal[7])
			instructionPointer = instruction[17:2];
	end

end

endmodule
