// Group-12
// Milestone 3 (project)- Problem 3
// A behavioral VHDL model for shift 16 bit number


// module for test 16 bit shift
module test_shift16;

// Declare variables to be connected to inputs and outputs 
reg [15:0] in;
wire [15:0] out;

shift_16bits s(out,in);

initial
begin
	in=16'b1100000000000011;             // check left shift
	#1 $display("in=%b out=%b",in,out);
end

endmodule

// module for 16 bit shift
module shift_16bits(out,in);

// Declare variables to be connected to inputs and outputs
input [15:0] in;
output reg [15:0] out;

always @(in)
begin
	out <= {in[14:0],1'b0};    // left shift
end

endmodule
