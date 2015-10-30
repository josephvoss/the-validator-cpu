module adder(
clock,
ain,
bin,
out
);

input clock;
input [7:0] ain;
input [7:0] bin;

output [7:0] out;

wire clock;

wire [7:0] ain, bin;

reg [7:0] out;

always @ (posedge clock)
begin: ADD
	out <= ain + bin; 
end

endmodule
