module rshift(
clock, //link to same clock as ALU and output would be updated simulaneously
distance,
in,
out
);

input clock;
input [3:0] in, distance;

output [3:0] out;

wire clock;
wire [3:0] in, distance;

reg [3:0] out;

integer max, i;

always @(posedge clock) begin
	max = 4; //Hardcoded value, currently working for 4 bit
	for (i=0; i<max; i = i+1) begin
		out[i] = in[i+distance];
	end
	for (i=0; i<distance+1; i = i+1) begin
		out[max-i] = 0;
	end
/*	if (distance == 0) begin  CURRENTLY UNDEFINED FOR DISTANCE = 0;
		out = 4'b0000;
	end
*/
end
endmodule
