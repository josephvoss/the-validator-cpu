`include "2sComplementConverter.v"
`include "lshift.v"
`include "rshift.v"

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
wire [3:0] opcode, ain, bin, invBin, rshiftOut, lshiftOut;
reg [3:0] bValue;

wire internalClock; //for subtraction

reg [3:0] out;

always @ (posedge clock) begin
	if (opcode == 4'b0001 || opcode == 4'b0010) begin
		bValue = bin;
		if (opcode == 4'b0010) begin
			bValue = invBin;
		end
		out = ain + bValue;	
/*	end else if (opcode == 4'b1000) begin
		#1 out = rshiftOut; //Assignment at same time as the rshift value is updated. Issue? Non-blocking assignment, may work
		//Really don't like the solution just being a #1 delay. Any other options?
	end else if (opcode == 4'b1001) begin
		#1 out = lshiftOut;
		//Really don't like the solution just being a #1 delay. Any other options?
	end
*/
end
/*
	else if (opcode == 4'b0011) begin
		out <= ain * bin;
	end else if (opcode == 4'b0100) begin
		out <= ain / bin;
*/

twosCompliment inverter(bin, invBin);
//rshift rshifter(clock, bin, ain, rshiftOut);
//lshift lshifter(clock, bin, ain, lshiftOut);

endmodule		
