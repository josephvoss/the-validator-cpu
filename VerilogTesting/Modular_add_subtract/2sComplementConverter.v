module twosCompliment(
valueIn,
out
);

input [3:0] valueIn;

output [3:0] out;

wire [3:0] valueIn;
//reg [3:0] out;
wire [3:0] out;

assign out = ~valueIn + 1;

/*
always @ (posedge clock)
begin
	out <= ~valueIn + 1; //invert all bits then add one to convert to twos compliment
end
*/

endmodule
