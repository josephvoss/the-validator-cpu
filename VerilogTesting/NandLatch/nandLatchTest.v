`include "nandLatch.v"
module nand_latch_test();
// Inputs regs output wires
reg in, reset;
wire out;

initial begin
	$display("time\tinput\treset\toutput");
	$monitor("%g\t%b\t%b\t%b", $time, in, reset, out);
	in = 0;
	reset = 0;
	#1 in = 1;
	#1 in = 0;
	#1 reset = 1;
	#1 reset = 0;
	#1 in = 1;
	#1 in = 0;
end

nand_latch testingLatch(
in,
reset,
out
);

endmodule	
