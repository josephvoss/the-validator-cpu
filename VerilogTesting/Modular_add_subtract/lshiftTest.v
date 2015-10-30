`include "lshift.v"
module lshift_test();

reg [3:0] valueIn, distance;
wire [3:0] out;
reg clock;

initial begin
	clock = 1;
	distance = 2;
	$display("Input\tOutput");
	$monitor("%b\t%b", valueIn, out);
	valueIn = 4'b0010;
	#2 valueIn = 4'b0100;
	#2 valueIn = 4'b0110;
	#2 valueIn = 4'b1011;
	$finish;
end

always begin
	#1 clock = ~clock;
end

lshift lshifter(clock, distance, valueIn, out);

endmodule
