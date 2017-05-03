// Group-12
// Milestone 3 (project)- Problem 3
// A behavioral VHDL model for sign extend
// Extend 4-bit number to a 16-bit number


// module for test
module test_extend;

// Declare variables to be connected to inputs and outputs
reg [3:0] in;
wire [15:0] out;

sign_extend extend(out,in);

initial
begin
	in=4'b0011;                        // check for zero extend
	#1 $display("in=%b out=%b",in,out);

	in=4'b1110;                        // check for sign extend
	#1 $display("in=%b out=%b",in,out);

end

endmodule

// module for sign extend
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
