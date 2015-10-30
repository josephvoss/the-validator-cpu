`include "2sComplementConverter.v"
module converter_test();

reg [3:0] valueIn;
wire [3:0] out;
reg clock;

initial begin
	clock = 1;
	$display("Input\tOutput");
	$monitor("%b\t%b", valueIn, out);
	valueIn = 4'b0001;
	#2 valueIn = 4'b0100;
	#4 valueIn = 4'b0111;
	#6 valueIn = 4'b0101;
	$finish;
end

always begin
	#1 clock = ~clock;
end

twosCompliment testingConverter(valueIn, out);

endmodule
