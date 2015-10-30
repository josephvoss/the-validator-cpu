module nand_latch(
in,
reset,
out
);

input in;
input reset;

output out;

wire in;
wire reset;

reg out;

initial begin
	out = 1'b0;
end

always @ (posedge in or posedge reset)
begin: INPUT
	if (in == 1'b1) begin
		out = 1'b1;
	end
	else if (reset == 1'b1) begin
		out = 1'b0;
	end
end

endmodule
