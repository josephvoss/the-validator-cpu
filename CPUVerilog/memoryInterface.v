`include "simple_softCPU.v"
module memory_interface(
clock,
addressBus,
dataBus,
pOE,
pWE,
tOE,
tWE
);

input clock;
output pOE, pWE, tOE, tWE; //SET CE TO GROUND
output [15:0] addressBus;
inout [7:0] dataBus;

reg pOE, pWE, tOE, tWE; //SET CE TO GROUND
reg [15:0] addressBus;
reg [7:0] rDataBus;

wire clock;
reg [25:0] instruction;
wire [15:0] ip;
wire [15:0] addressIn;
reg [7:0] valueIn;
wire readValueIn, writeValueOut;
wire [15:0] addressOut;
wire [7:0] valueOut;

task setDataPins;
input[15:0] addressBus;
input inputFlag;
//Three pins to rule them all (HA)
//CE OE WE.
// L  X  L 	Writes data out
// L  L  H  Reads data In
// H  X  X  disables output
// L  H  H  not selected, whatever that means      
//OE can be held at zero. WE enable
begin
	if (inputFlag) begin
		if (dataBus[15]) begin
			pOE = 0; pWE = 0; //writes flash
			tOE = 1; tWE = 1; //disables output
		end else begin
			pOE = 1; pWE = 1; //disables output
			tOE = 0; tWE = 0; //writes NVRAM
		end
		if (dataBus[15]) begin
			pOE = 0; pWE = 1; //reads flash
			tOE = 1; tWE = 1; //disables output
		end else begin
			pOE = 1; pWE = 0; //disables output
			tOE = 0; tWE = 0; //reads NVRAM
		end
	end
end
endtask

assign dataBus = rDataBus;

always @(posedge clock) begin
	pOE = 0; pWE = 1; tOE = 1; tWE = 1; //data pins remain constant for reading instructions from flash
		addressBus = ip;
		#1 instruction[25:24] = dataBus[1:0];
		addressBus = ip + 1;
		#1 instruction[23:16] = dataBus;
		addressBus = ip + 2;
		#1 instruction[15:0] = dataBus;

	#3 //wait for cpu to catch-up, then 1 for calculations, 1 for transfer

	if (readValueIn) begin
		addressBus = addressIn;
		setDataPins(addressBus, readValueIn); //add delay?
		valueIn = rDataBus; //delay?
	end
	if (writeValueOut) begin
		addressBus = addressOut;
		setDataPins(addressBus, !writeValueOut); //add delay?
		rDataBus = valueOut; //delay?
	end
end

control_matrix softCPU(clock, instruction, ip, addressIn, valueIn, readValueIn, addressOut, valueOut, writeValueOut);

endmodule
