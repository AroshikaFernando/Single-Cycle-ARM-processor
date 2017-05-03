// Group-12
// Milestone 3 (project)- Problem 3
// A behavioral VHDL model for shift 12 bit number
// return 13 bit number


// module for test
module test_shift12;

reg [11:0] in;
wire [12:0] out;

shift_12bit s (out,in);

initial
begin
	in=12'b110000000011;             // check left shift with 13 bits
	#1 $display("in=%b out=%b",in,out);
end

endmodule

// module for shift 12 bit number
module shift_12bit(out,in);

input [11:0] in;
output reg [12:0] out;

always @(in)
begin
	out <= {in,1'b0};   // left shift to 13 bit
end

endmodule

