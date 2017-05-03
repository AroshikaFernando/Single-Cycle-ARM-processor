// Group-12
// Milestone 3 (project)- Problem 3
// A behavioral VHDL model for data memory


// module for test data memory
module test_dataMemory;

reg MemWrite,MemRead;
reg [15:0] address;
reg [15:0] writeData;

wire [15:0] readData;

data_memory m(address,writeData,readData,MemWrite,MemRead);

initial
begin
	address = 16'b1; writeData=16'b0; MemWrite=1;       // write data
	#1 $display("address=%b MemWrite=%b writeData=%b ",address,MemWrite,writeData);
	
	address = 16'b1; MemRead=1;                        // read data
	#1 $display("address=%b MemRead=%b   readData=%b",address,MemRead,readData);

	address = 16'b10; writeData=16'b1111; MemWrite=1;    // write data
	#1 $display("address=%b MemWrite=%b writeData=%b ",address,MemWrite,writeData);
	
	address = 16'b10; MemRead=1;                        // read data
	#1 $display("address=%b MemRead=%b   readData=%b",address,MemRead,readData);
	  
end

endmodule

// module for data memory
module data_memory(address,writeData,readData,MemWrite,MemRead);

reg [15:0] data_mem [15:0];

input MemWrite,MemRead;
input [15:0] address;
input [15:0] writeData;

output reg [15:0] readData;    

always @(address,MemWrite,MemRead,writeData)
begin
	if(MemWrite == 1)         // write data to memory
		data_mem[address] = writeData[15:0];
	if(MemRead == 1)         // read data from memory
		readData[15:0] = data_mem[address];
end

endmodule
