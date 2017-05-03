// module for test instruction memeory 
module test_instructionMem;

reg [15:0] readAddress;

wire [3:0] i1;
wire [3:0] i2;
wire [3:0] i3;
wire [3:0] i4;
wire [11:0] jump;

instruction_memory im (readAddress,i1,i2,i3,i4,jump);

initial
begin
	readAddress=16'b0; 
	#1 $display("readAddress=%b i1=%b i2=%b i3=%b i4=%b jump=%b",readAddress,i1,i2,i3,i4,jump);
end

endmodule


// module for instruction memory
// Get the address from the pc
// Divide the instruction to parts(i1,i2,i3,i4,jump) and return
module instruction_memory(readAddress,i1,i2,i3,i4,jump);

reg [7:0] instruction_mem [65536:0];

input [15:0] readAddress;

output reg [3:0] i1;
output reg [3:0] i2;
output reg [3:0] i3;
output reg [3:0] i4;
output reg [11:0] jump;

// initialize values for instruction memory
initial
begin
instruction_mem [0][7:0] = 8'b10101011;  
instruction_mem [1][7:0] = 8'b10101010;
end

// initialize outputs
always @(readAddress)
begin
	i1 = instruction_mem[readAddress][7:4];
	i2 = instruction_mem[readAddress][3:0];
	i3 = instruction_mem[readAddress + 16'b1][7:4];
	i4 = instruction_mem[readAddress + 16'b1][3:0];
	jump = {instruction_mem[readAddress][3:0],instruction_mem[readAddress + 16'b1][7:0]};
end

endmodule
