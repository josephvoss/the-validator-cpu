module add_subtract(
clock,
opcode,
ain,
bin,
out
);

input clock;
input [3:0] opcode;
input [3:0] ain, bin;

output [3:0] out;

wire clock;
wire [3:0] opcode, ain, bin;

reg [3:0] out;

always @ (posedge clock) begin
	if (opcode == 4'b0001) begin
		out <= ain + bin;
	end else if (opcode == 4'b0010) begin
		out <= ain - bin;
	end else if (opcode == 4'b0011) begin
		out <= ain * bin;
	end else if (opcode == 4'b0100) begin
		out <= ain / bin;
	end
end

endmodule		
