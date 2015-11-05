`include "./simple_softCPU.v"
module softCPU_testbench;

reg clock;
reg [25:0] instruction;
wire [15:0] instructionPointer;
reg [15:0] addressIn;
reg [7:0] valueIn;
wire [15:0] addressOut;
wire [7:0] valueOut;

always begin
	#1 clock = !clock;
end

initial begin
	addressIn <= 0;
	valueIn <= 0;
	clock = 0;

//Works for first command only, fails for all following commands. Does the 3rd command work at all? YES!
//Error seems to be in changing the values once they've been input. Is there an issue with the add command if blocks?
	instruction = 26'b00010001001110000110010001; //adds 2 given numbers, stores it in registerA
	#2
	$display("00100111 + 00011001 = regB");
	$display("Value1\tValue2\tValue3");
	$display("%b\t%b\t%b", softCPU.value1Internal, softCPU.value2Internal, softCPU.value3Internal);
	$display("RegisterB = %b\n", softCPU.registerB);

	instruction = 26'b00010001001010000110010010; //adds 2 given numbers, stores it in registerA
	#2
	$display("00100101 + 00011001 = regC");
	$display("Value1\tValue2\tValue3");
	$display("%b\t%b\t%b", softCPU.value1Internal, softCPU.value2Internal, softCPU.value3Internal);
	$display("RegisterC = %b\n", softCPU.registerC);
	
	instruction = 26'b00011000000100101010100010; //registerA + 0001 0000 = registerB;
	#2
	$display("regC + 00010000 = regE");
	$display("Value1\tValue2\tValue3");
	$display("%b\t%b\t%b", softCPU.value1Internal, softCPU.value2Internal, softCPU.value3Internal);

	instruction = 26'b00011000000011000000100100;
	#2
	$display("regB + regC = regE");
	$display("%b\t+\t%b\t=\t%b", softCPU.registerB, softCPU.registerC, softCPU.registerE);
	

	$finish();
end

control_matrix softCPU(clock, instruction, instructionPointer, addressIn, valueIn, addressOut, valueOut);

endmodule
	
