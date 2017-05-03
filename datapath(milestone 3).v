// Group-12
// A behavioral VHDL model for datapath without controller

module test_dataPath;

reg [15:0] address;
reg clock;
reg regDst,regWrite,aluSrc,MemWrite,MemRead,memToReg,branch,Jump;
reg [2:0] ALUOp;

wire [15:0] next_address;

dataPath dp(next_address , address , clock, regDst , regWrite , aluSrc , ALUOp , MemWrite , MemRead , memToReg , branch , Jump);

initial
begin	
	// check ADD operation
	// clock=0
	address=16'b0; regDst=1;  regWrite=1; aluSrc=0; MemWrite=1; MemRead=1; memToReg=0; ALUOp=3'b010;  branch=0; Jump=0; clock=0;
	#1 $display("address=%b regDst=%b aluSrc=%b ALUOp=%b memToReg=%b next_address=%b",address,regDst,aluSrc,ALUOp,memToReg,next_address);
	
	// clock=1
	address=16'b0; regDst=1;  regWrite=1; aluSrc=0; MemWrite=1; MemRead=1; memToReg=0; ALUOp=3'b010;  branch=0; Jump=0; clock=1;
	#1 $display("address=%b regDst=%b aluSrc=%b ALUOp=%b memToReg=%b next_address=%b",address,regDst,aluSrc,ALUOp,memToReg,next_address);

	// clock=0
	address=16'b0; regDst=1;  regWrite=1; aluSrc=0; MemWrite=1; MemRead=1; memToReg=0; ALUOp=3'b010;  branch=0; Jump=0; clock=0;
	#1 $display("address=%b regDst=%b aluSrc=%b ALUOp=%b memToReg=%b next_address=%b",address,regDst,aluSrc,ALUOp,memToReg,next_address);
	
	// clock=1
	address=16'b0; regDst=1;  regWrite=1; aluSrc=0; MemWrite=1; MemRead=1; memToReg=0; ALUOp=3'b010;  branch=0; Jump=0; clock=1;
	#1 $display("address=%b regDst=%b aluSrc=%b ALUOp=%b memToReg=%b next_address=%b",address,regDst,aluSrc,ALUOp,memToReg,next_address);

	// check SUB operation


end

endmodule


module dataPath (next_address , address , clock, regDst , regWrite , aluSrc , ALUOp , MemWrite , MemRead , memToReg , branch , Jump);

input [15:0] address;
input clock;
input regDst,regWrite,aluSrc,MemWrite,MemRead,memToReg,branch,Jump;
input [2:0] ALUOp;

output wire [15:0] next_address;

wire [15:0] read_address;
wire [3:0] i1;
wire [3:0] i2;
wire [3:0] i3;
wire [3:0] i4;
wire [11:0] jump;
wire [15:0] read_data1;
wire [15:0] read_data2;
wire [15:0] write_data;
wire [15:0] offset;
wire [3:0] mux1_out;
wire [15:0] mux2_out;
wire [15:0] ALU_result;
wire c_in=0;
wire c_out,lt,eq,gt,overflow;
wire [15:0] readData;
wire [15:0] shift_out;
wire [15:0] adder1_out;
wire [15:0] adder2_out;
wire [15:0] mux4_out;
wire and_out;
wire [12:0] shift12_out;


//call programe_counter module 
programe_counter pc (read_address , address , clock);

//call instruction_memory module
instruction_memory  instruction(read_address , i1 , i2 , i3 , i4 , jump);

//call mux module
bit4_mux2_to_1 mux1(mux1_out, i3, i4, regDst);

//call register_file module
register_file registerFile (read_data1 , read_data2 , i2 , i3 , mux1_out, write_data , regWrite , clock);

//call mux module for select whether read Data or a offset
bit16_mux2_to_1 mux2(mux2_out, read_data2, offset, aluSrc);

//call sign extended module
sign_extend signExtend(offset , i4);

//call ALU module
alu ALU(read_data1 , mux2_out , ALU_result , c_in , c_out , lt , eq , gt , overflow , ALUOp);

//call Data Memory module
data_memory dataMemory(ALU_result , read_data2 , readData , MemWrite , MemRead);

//call mux module
bit16_mux2_to_1 mux3(write_data, ALU_result ,readData , memToReg);
//call ALU again to write data in register file
register_file registerFile1 (read_data1 , read_data2 , i2 , i3 , mux1_out, write_data , regWrite , clock);

//call 16-bit shift register module
shift_16bits shift_16(shift_out , offset);

//call adder module for pc+2
add adder1(adder1_out,read_address,16'b10);

//call adder module for branch
add adder2(adder2_out,adder1_out,shift_out);

//call mux module for select whether branch or not
and(and_out,branch,eq);
bit16_mux2_to_1 mux4(mux4_out, adder1_out , adder2_out, and_out);

//call 12bit shift register
shift_12bit shift_12(shift12_out,jump);

wire [15:0] temp;
assign temp = {adder1_out[15:13],shift12_out} ;

//call mux module
bit16_mux2_to_1 mux5(next_address, mux4_out ,temp , Jump);

endmodule


//------------------Program Counter------------------------//

module programe_counter(out,in,clock);
 
input [15:0] in;
input clock;

output reg [15:0] out;

always @(posedge clock)
begin
	out <= in;
end

endmodule

//------------------Instruction Memory---------------------//

// Get the address from the pc
// Divide the instruction to parts(i1,i2,i3,i4,jump) and return
module instruction_memory(readAddress,i1,i2,i3,i4,jump);

reg [7:0] instruction_mem [256:0];

input [15:0] readAddress;

output reg [3:0] i1;
output reg [3:0] i2;
output reg [3:0] i3;
output reg [3:0] i4;
output reg [11:0] jump;

// initialize values for instruction memory
initial
begin
instruction_mem [0][7:0] = 8'b00101011;  
instruction_mem [1][7:0] = 8'b10100001;
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

//-------------------Register File----------------------------//

module register_file (read_data1 , read_data2 , read_reg1 , read_reg2 , write_reg , write_data , regWrite , clock);

	
	// Declare variables to be connected
	// to inputs
	reg [15:0] reg_file [15:0];

	// output and input registers
	output reg [15:0] read_data1;
	output reg [15:0] read_data2;
	input [3:0] read_reg1;
	input [3:0] read_reg2;
	input [3:0] write_reg;
	input [15:0] write_data;
	input regWrite , clock;

	// initialize values for register file
	initial
	begin
	reg_file [10][15:0] = 16'b10;  
	reg_file [11][15:0] = 16'b11;
	end
		
	always @ (posedge clock , regWrite)
	
	begin
	
	//load c value to the register given in c address
	if ( regWrite == 1 )          
		reg_file[write_reg] = write_data[15:0];
	end
	
	always @ (negedge clock)
	begin
	//values in register given A_addr and B_addr load to the A and B
		assign read_data1 = reg_file[read_reg1];
		assign read_data2 = reg_file[read_reg2];
		
	end
	
endmodule

//------------------------2x1 Multiplexers for 16bit------------------------//

module bit16_mux2_to_1 (out, i0, i1, s);
	
	// Port declarations from the I/O diagram
	output reg[15:0]out;
	input  [15:0]i0;
	input  [15:0]i1;
	input s;

	
	always @(s,i0,i1)
	begin	
	
		case (s)
			1'b0 : out = i0;
			1'b1 : out = i1;
			default : $display("Invalid signal");	
		endcase
	
	end	
	
	
endmodule

//------------------------2x1 Multiplexers for 4bit------------------------//

module bit4_mux2_to_1 (out, i0, i1, s);
	
	// Port declarations from the I/O diagram
	output reg[3:0]out;
	input  [3:0]i0;
	input  [3:0]i1;
	input s;
	
	always @(s,i0,i1)
	begin	
	
		case (s)
			1'b0 : out = i0;
			1'b1 : out = i1;
			default : $display("Invalid signal");	
		endcase
	
	end	
	
endmodule

//-----------------------Sign Extend-----------------------------//
module sign_extend(out,in);

// Declare variables to be connected to inputs and outputs
input [3:0] in;       // 4-bit input
output reg [15:0] out;  // 12-bit output

always @(in)
begin

if(in[3]==1)
out <= {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,in};   // sign extend with  1
else
out <= {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,in};   // sign extend with  0
end

endmodule

//----------------------- ALU ----------------------------//

module alu(x,y,z,c_in,c_out,lt,eq,gt,overflow,ALUOp);

// Declare variables to be connected to inputs and outputs
input [15:0] x;
input [15:0] y;
output reg [15:0] z;

input c_in;
output reg c_out=0;
output reg lt,eq,gt;
output reg overflow;
input [2:0] ALUOp;

always @(x,y,ALUOp)
begin
	case(ALUOp)
		3'b000: z = x & y;            // AND operation
		3'b001: z = x | y;            // OR operation
		3'b010: {c_out,z} = x + y + c_in;           // ADD operation
		3'b011: {c_out,z} = x + ~y + 1'b1;          // SUB operation
		3'b111: z = x < y;           // SLT operation
	endcase
	
	overflow = c_out;	

	// comparison indicator bits
	lt <= x < y;      // less than   
	eq <=  x == y;    // equals
	gt <= x > y;     // greater than
end

endmodule

//-------------------Data Memory------------------------------//

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

//-------------------16-bit shift register------------------//

module shift_16bits(out,in);

// Declare variables to be connected to inputs and outputs
input [15:0] in;
output reg [15:0] out;

always @(in)
begin
	out <= {in[14:0],1'b0};    // left shift
end

endmodule

//--------------------------Adder----------------------------//

module add(out,in,value);

// Declare variables to be connected to inputs and outputs
input [15:0] in;  // previous pc
input [15:0] value;
output reg [15:0] out;   // next pc

always @(in)
	out <= in + value;   // add value to the pc

endmodule

//------------------------16-bit shift register-----------------------//

module shift_12bit(out,in);

input [11:0] in;
output reg [12:0] out;

always @(in)
begin
	out <= {in,1'b0};   // left shift to 13 bit
end

endmodule
