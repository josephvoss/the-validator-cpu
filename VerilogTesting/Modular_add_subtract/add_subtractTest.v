`include "add_subtract.v"
module add_subtractTest();

reg [3:0] ain, bin;
wire [3:0] out;
reg clock;

initial begin
	clock = 1;
	$display("Ain\tBin\tOut");
//	$monitor("%b\t%b\t%b\t", ain, bin, out);
	ain = 4'b1010;
	#10 bin = 4'b0000;
	#10 bin = 4'b0001;
	#10 bin = 4'b0010;
	#10 bin = 4'b0011;
	$finish;
end

always begin
	#5 clock = ~clock;
end

always begin
	#10 $display("%b\t%b\t%b\t%b\t%d", ain, bin, out, clock, $time);
end

add_subtract whatImTesting(clock, 4'b0001, ain, bin, out); 
endmodule
