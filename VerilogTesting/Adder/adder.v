module adder(
clock,
ain,
bin,
out
);

input clock;
input [3:0] ain;
input [3:0] bin;

output [3:0] out;

wire clock;

wire [3:0] ain, bin;

reg [3:0] out;

always @ (posedge clock)
begin: ADD
	out <= ain + bin; 
end

endmodule
