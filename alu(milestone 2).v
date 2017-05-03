// Group-12
// Milestone 2 - project part
// A behavioral model of a sequential ALU to support the KURM instruction set  

// module for test bench
module test_alu;

// Declare variables to be connected to inputs and outputs
reg [15:0] x;
reg [15:0] y;
wire [15:0] z;

reg c_in;
wire c_out;
wire lt,eq,gt;
wire overflow;
reg [2:0] ALUOp;

alu test(x,y,z,c_in,c_out,lt,eq,gt,overflow,ALUOp);

initial
begin
	// check AND operation
	x=16'h1;  y=16'h1; ALUOp=3'b000; c_in=0;
	#1 $display("x=%b y=%b ALUOp=%b z=%b lt=%b eq=%b gt=%b",x,y,ALUOp,z,lt,eq,gt);
	
	// check ORR operation
	x=16'h1;  y=16'h2; ALUOp=3'b001; c_in=0;
	#1 $display("x=%b y=%b ALUOp=%b z=%b lt=%b eq=%b gt=%b",x,y,ALUOp,z,lt,eq,gt);

	// check ADD operation without c_out
	x=16'h1; y=16'h2; ALUOp=3'b010;  c_in=0;
	#1 $display("x=%b y=%b ALUOp=%b z=%b lt=%b eq=%b gt=%b c_out=%b overflow=%b",x,y,ALUOp,z,lt,eq,gt,c_out,overflow);
	
	// check ADD operation with c_out
	x=16'hAAAA; y=16'hAAAA; ALUOp=3'b010;  c_in=0;
	#1 $display("x=%b y=%b ALUOp=%b z=%b lt=%b eq=%b gt=%b c_out=%b overflow=%b",x,y,ALUOp,z,lt,eq,gt,c_out,overflow);
	
	// check ADD operation with c_in
	x=16'hAAAA; y=16'hAAAA; ALUOp=3'b010;  c_in=1;
	#1 $display("x=%b y=%b ALUOp=%b z=%b lt=%b eq=%b gt=%b c_out=%b overflow=%b",x,y,ALUOp,z,lt,eq,gt,c_out,overflow);

	// check SUB operation
	x=16'h2; y=16'h1; ALUOp=3'b011;  c_in=0;
	#1 $display("x=%b y=%b ALUOp=%b z=%b lt=%b eq=%b gt=%b c_out=%b overflow=%b",x,y,ALUOp,z,lt,eq,gt,c_out,overflow);
	
	x=16'hAAAA; y=16'hAAAA; ALUOp=3'b011;  c_in=0;
	#1 $display("x=%b y=%b ALUOp=%b z=%b lt=%b eq=%b gt=%b c_out=%b overflow=%b",x,y,ALUOp,z,lt,eq,gt,c_out,overflow);

	// check SLT operation (x>y)
	x=16'h4; y=16'h2; ALUOp=3'b111; c_in=0;
	#1 $display("x=%b y=%b ALUOp=%b z=%b lt=%b eq=%b gt=%b",x,y,ALUOp,z,lt,eq,gt);
	
	// check SLT operation (x<y)
	x=16'h2; y=16'h4; ALUOp=3'b111; c_in=0;
	#1 $display("x=%b y=%b ALUOp=%b z=%b lt=%b eq=%b gt=%b",x,y,ALUOp,z,lt,eq,gt);
	
	// check SLT operation (x=y)
	x=16'h2; y=16'h2; ALUOp=3'b111; c_in=0;
	#1 $display("x=%b y=%b ALUOp=%b z=%b lt=%b eq=%b gt=%b",x,y,ALUOp,z,lt,eq,gt);

end

endmodule


// module for alu
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

