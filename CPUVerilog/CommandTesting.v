`include "./simple_softCPU.v"
module softCPU_testbench;

reg clock;
reg [25:0] instruction;
wire [15:0] instructionPointer;
wire [15:0] addressIn;
reg [7:0] valueIn;
wire [15:0] addressOut;
wire [7:0] valueOut;
wire readValueIn, writeValueOut;

always begin
	#10 clock = !clock;
end

initial begin
	valueIn <= 0;
	clock = 0;


//Add command testing
//----------------------------------------------------------------------------------
	instruction = 26'b00010001001110000110010001; //adds 2 given numbers, stores it in registerA
	#20
	$display("00100111 + 00011001 = regB");
	$display("Value1\tValue2\tValue3");
	$display("%b\t%b\t%b", softCPU.value1Internal, softCPU.value2Internal, softCPU.value3Internal);
	$display("RegisterB = %b\n", softCPU.registerB);

	instruction = 26'b00010001001010000110010010; //adds 2 given numbers, stores it in registerA
	#20
	$display("00100101 + 00011001 = regC");
	$display("Value1\tValue2\tValue3");
	$display("%b\t%b\t%b", softCPU.value1Internal, softCPU.value2Internal, softCPU.value3Internal);
	$display("RegisterC = %b\n", softCPU.registerC);
	
	instruction = 26'b00011000000100101010100010; //registerA + 0001 0000 = registerB;
	#20
	$display("regC + 00010000 = regE");
	$display("Value1\tValue2\tValue3");
	$display("%b\t%b\t%b\n", softCPU.value1Internal, softCPU.value2Internal, softCPU.value3Internal);

	instruction = 26'b00011000000011000000100100;
	#20 $display("regB + regC = regE");
	$display("%b\t+\t%b\t=\t%b\n", softCPU.registerB, softCPU.registerC, softCPU.registerE);
//----------------------------------------------------------------------------------

//Sub command testing
//----------------------------------------------------------------------------------
	instruction = 26'b00110011111110010101010000;
	#20 $display("01111111 - 01010101 = regA");
	$display("%b\t%b\t%b\n", softCPU.value1Internal, softCPU.value2Internal, softCPU.registerA);

	instruction = 26'b00110000000010000011110001;
	#20 $display("00000001 - 00001111 = regB");
	$display("%b\t%b\t%b\n", softCPU.value1Internal, softCPU.value2Internal, softCPU.registerB);

	instruction = 26'b00111000000010000101010000;
	#20 $display("registerB - 00010101 = regA");
	$display("%b\t%b\t%b\n", softCPU.registerB, softCPU.value2Internal, softCPU.registerA);

	instruction = 26'b00111000000101000000000001;
	#20  $display("registerC - registerA = registerB");
	$display("%b\t%b\t%b\n", softCPU.registerC, softCPU.registerA, softCPU.registerB);
//----------------------------------------------------------------------------------

//Inv command testing
//----------------------------------------------------------------------------------
	instruction = 26'b00100010101010000000000000;
	#20 $display("Inv(01010101) = registerA");
	$display("%b\t%b\n", softCPU.value1Internal, softCPU.registerA);
	
	instruction = 26'b00101000000000000000000001;
	#20 $display("Inv(registerA) = registerB");
	$display("%b\t%b\n", softCPU.registerA, softCPU.registerB);
//----------------------------------------------------------------------------------

//Jfl
//----------------------------------------------------------------------------------
	softCPU.instructionPointer = 16'b0000000000000000;
	instruction = 26'b01010001000101010000111100;
	#20 $display("If regB is < 0. IP is 3");
	$display("regB = %b, address output is %b\n", softCPU.registerB, softCPU.instructionPointer);

	instruction = 26'b00010111111100000000000001;
	#20 $display("Changing regB to = 11111110\n");

	instruction = 26'b01010001000101010000111100;
	#20 $display("If regB is < 0. IP is 9");
	$display("regB = %b, address output is %b\n", softCPU.registerB, softCPU.instructionPointer);
//----------------------------------------------------------------------------------

//Jfe
//----------------------------------------------------------------------------------
	softCPU.instructionPointer = 16'b0000000000000000;
	instruction = 26'b01100001000101010000111100;
	#20 $display("If regB is == 0. IP is 3");
	$display("regB = %b, address output is %b\n", softCPU.registerB, softCPU.instructionPointer);

	instruction = 26'b00010000000000000000000001;
	#20 $display("Changing regB to = 00000000\n");

	instruction = 26'b01100001000101010000111100;
	#20 $display("If regB is = 0. IP is 9");
	$display("regB = %b, address output is %b\n", softCPU.registerB, softCPU.instructionPointer);
//----------------------------------------------------------------------------------

//Jfg
//----------------------------------------------------------------------------------
	softCPU.instructionPointer = 16'b0000000000000000;
	instruction = 26'b01110001000101010000111100;
	#20 $display("If regB is > 0. IP is 3");
	$display("regB = %b, address output is %b\n", softCPU.registerB, softCPU.instructionPointer);

	instruction = 26'b00010111111110000000000001;
	#20 $display("Changing regB to = 11111111\n");

	instruction = 26'b01110001000101010000111100;
	#20 $display("If regB is > 0. IP is 9");
	$display("regB = %b, address output is %b\n", softCPU.registerB, softCPU.instructionPointer);

	instruction = 26'b00010011111110000000000001;
	#20 $display("Changing regB to = 01111111\n");

	instruction = 26'b01110001000101010000111100;
	#20 $display("If regB is > 0. IP is 15");
	$display("regB = %b, address output is %b\n", softCPU.registerB, softCPU.instructionPointer);
//----------------------------------------------------------------------------------

//Add b 1 b test
//----------------------------------------------------------------------------------
	instruction = 26'b00011000000010000000010001;
	#20 $display("Add b 1 b testing");
	#20 $display("regB = %b\n", softCPU.registerB);
	#20 $display("regB = %b\n", softCPU.registerB);
	#20 $display("regB = %b\n", softCPU.registerB);

	$finish();
end

control_matrix softCPU(clock, instruction, instructionPointer, addressIn, valueIn, radValueIn, addressOut, valueOut, writeValueOut);

endmodule	
