`include "add&subtract.v"
module adder_test();

reg [3:0]  ain, bin;
wire [3:0]  out;
reg clock;

initial begin
	clock = 1;
	$display("A value\tB value\tOutput");
	$monitor("%b\t%b\t%b", ain, bin, out);
	ain = 4'b0000;
	bin = 4'b0000;
	#2 ain = 4'b0001;
	#4 bin = 4'b0001;
	#6 ain = 4'b0011;
	#8 bin = 4'b0111;
	#10 ain = 4'b1001;
	$finish;
end

always begin
	#1 clock = ~clock;
end

add_subtract testingAdder(clock, 4'b0001,  ain, bin, out);

endmodule
