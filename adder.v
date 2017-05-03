// Group-12
// Milestone 3 (project)- Problem 3
// A behavioral VHDL model for add 2 or any value to pc


// module for test bench
module test_adder;

// Declare variables to be connected to inputs and outputs
reg [15:0] in;
reg [15:0] value;
wire [15:0] out;

add add_2(out,in,value);

initial
begin
	in=16'b1;   value=16'b10;                      // add 2
	#1 $display("in = %b, out = %b \n", in,out);

	in=16'b11;  value=16'b11;                      // add 3
	#1 $display("in = %b, out = %b \n", in,out);

	in=16'b111;  value=16'b10;                      // add 2
	#1 $display("in = %b, out = %b \n", in,out);

	in=16'b11111111;   value=16'b100;               // add 4
	#1 $display("in = %b, out = %b \n", in,out);

end

endmodule


// module for adder
module add(out,in,value);

// Declare variables to be connected to inputs and outputs
input [15:0] in;  // previous pc
input [15:0] value;
output reg [15:0] out;   // next pc

always @(in)
	out <= in + value;   // add value to the pc

endmodule
