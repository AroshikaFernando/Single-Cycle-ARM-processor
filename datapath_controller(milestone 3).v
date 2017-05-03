// Group-12
// A behavioral VHDL model for datapath with controller

module test_dataPath_with_controller;

reg [15:0] address;
reg clock;

wire [15:0] next_address;

dataPath_with_controller dp(next_address , address , clock);

initial
begin
	// check ADD operation
	address=16'b0; clock=0;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b0; clock=1;
	#1 $display("address=%b next_address=%b",address,next_address);
	
	address=16'b0; clock=0;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b0; clock=1;
	#1 $display("address=%b next_address=%b",address,next_address);


	//check SUB operation
	address=16'b10; clock=0;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b10; clock=1;
	#1 $display("address=%b next_address=%b",address,next_address);
	
	address=16'b10; clock=0;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b10; clock=1;
	#1 $display("address=%b next_address=%b",address,next_address);

	// check lw 
	address=16'b100; clock=0;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b100; clock=1;
	#1 $display("address=%b next_address=%b",address,next_address);
	
	address=16'b100; clock=0;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b100; clock=1;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b100; clock=0;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b100; clock=1;
	#1 $display("address=%b next_address=%b",address,next_address);


	// check Jump
	address=16'b110; clock=0;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b110; clock=1;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b110; clock=0;
	#1 $display("address=%b next_address=%b",address,next_address);

	address=16'b110; clock=1;
	#1 $display("address=%b next_address=%b",address,next_address);

end

endmodule


module dataPath_with_controller (next_address , address , clock);

input [15:0] address;
input clock;

output wire [15:0] next_address;

wire [15:0] read_address;
wire [3:0] i1;
wire [3:0] i2;
wire [3:0] i3;
wire [3:0] i4;
wire [11:0] jump;
wire regDst,regWrite,aluSrc,MemWrite,MemRead,memToReg,branch,Jump;
wire [2:0] ALUOp;
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

//call controller module
controller control(regDst,regWrite,aluSrc,ALUOp,MemWrite,MemRead,memToReg,branch,Jump,i1,clock);

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
bit16_mux2_to_1 mux3(write_data, ALU_result, readData , memToReg);
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
instruction_mem [0][7:0] = {4'b0010,4'b1111};  
instruction_mem [1][7:0] = {4'b1110,4'b0000};
instruction_mem [2][7:0] = {4'b0110,4'b1101};  
instruction_mem [3][7:0] = {4'b1100,4'b0001};
instruction_mem [4][7:0] = {4'b1000,4'b0101};  
instruction_mem [5][7:0] = {4'b0110,4'b0010};
instruction_mem [6][7:0] = {4'b1111,4'b0000};  
instruction_mem [7][7:0] = {4'b0000,4'b0100};
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
	reg_file [15][15:0] = 16'b11;  
	reg_file [14][15:0] = 16'b10;
	reg_file [13][15:0] = 16'b101;  
	reg_file [12][15:0] = 16'b11;
	reg_file [13][15:0] = 16'b101;  
	reg_file [12][15:0] = 16'b11;
	reg_file [5][15:0] = 16'b111;
	end
		
	always @ (posedge clock)
	
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

// initialize values for data memory
	initial
	begin
	data_mem [9][15:0] = 16'b1111;
	end   

always @(address,MemWrite,MemRead,writeData)
begin
	if(MemWrite == 1)         // write data to memory
		data_mem[address] = writeData[15:0];
	if(MemRead == 1)         // read data from memory
		readData[15:0] = data_mem[address];
end

endmodule

//---------------------16-bit shift register------------------//

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


//-------------------------------controller--------------------------------------//

// module for behavioral model for KRUM controller
module controller (RegDest,RegWrite,ALUSrc,ALUOp,MemWrite,MemRead,MemToReg,Branch,Jump,Instruction,clock);

// Declare variables to be connect to outputs
output reg RegDest,RegWrite;
output reg ALUSrc;
output reg [2:0] ALUOp;
output reg MemWrite,MemRead,MemToReg;
output reg Branch,Jump;

// Declare variables to be connect to inputs
input [3:0] Instruction;
input clock;

always @(posedge clock)
begin
	case(Instruction)

		// Instruction ADD - OPcode=2
		// Register destination,register write - 1
		// ALU control operation = 010  and others are zero
		4'b0010:  begin RegDest=1; RegWrite=1; ALUSrc=0; ALUOp=3'b010; MemWrite=0; MemRead=0; MemToReg=0; Branch=0; Jump=0; end
		
		// Instruction SUB - OPcode=6
		// Register destination,register write - 1
		// ALU control operation = 011  and others are zero
		4'b0110:  begin RegDest=1; RegWrite=1; ALUSrc=0; ALUOp=3'b011; MemWrite=0; MemRead=0; MemToReg=0; Branch=0; Jump=0; end 

		// Instruction AND - OPcode=0
		// Register destination,register write - 1
		// ALU control operation = 000  and others are zero
		4'b0000:  begin RegDest=1; RegWrite=1; ALUSrc=0; ALUOp=3'b000; MemWrite=0; MemRead=0; MemToReg=0; Branch=0; Jump=0; end

		// Instruction ORR - OPcode=1
		// Register destination,register write - 1
		// ALU control operation = 001  and others are zero
		4'b0001:  begin RegDest=1; RegWrite=1; ALUSrc=0; ALUOp=3'b001; MemWrite=0; MemRead=0; MemToReg=0; Branch=0; Jump=0; end

		// Instruction SLT - OPcode=7
		// Register destination,register write - 1
		// ALU control operation = 010 (ADD) and others are zero
		4'b0111:  begin RegDest=1; RegWrite=1; ALUSrc=0; ALUOp=3'b111; MemWrite=0; MemRead=0; MemToReg=0; Branch=0; Jump=0; end

		// Instruction LW - OPcode=8
		// Register destination,ALU source,Memory read - 1
		// ALU control operation = 010 (ADD) others are zero
		4'b1000:  begin RegDest=0; RegWrite=1; ALUSrc=1; ALUOp=3'b010; MemWrite=0; MemRead=1; MemToReg=1; Branch=0; Jump=0; end

		// Instruction SW - OPcode=A
		// Register destination, Memory write,Memory to register - 1
		// ALU control operation = 010 (ADD) and others are zero
		4'b1010:  begin RegDest=1; RegWrite=0; ALUSrc=1; ALUOp=3'b010; MemWrite=1; MemRead=0; MemToReg=1; Branch=0; Jump=0; end

		// Instruction BNE - OPcode=E
		// ALU control operation = 010 (ADD)
		// Branch - 1 others are zero
		4'b1110:  begin RegDest=0; RegWrite=0; ALUSrc=0; ALUOp=3'b010; MemWrite=0; MemRead=0; MemToReg=0; Branch=1; Jump=0; end

		// Instruction JMO - OPcode=F
		// There is no ALU control operation
		// Jump - 1 others are zero
		4'b1111:  begin RegDest=0; RegWrite=0; ALUSrc=0; MemWrite=0; MemRead=0; MemToReg=0; Branch=0; Jump=1; end

	endcase
end

endmodule
