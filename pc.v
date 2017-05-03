// Group-12
// Milestone 3 (project)- Problem 3
// A behavioral VHDL model for program counter
// Rising edge triggered device


// module for test programe counter
module test_pc;

reg [15:0] in;
reg clock;

wire [15:0] out;

programe_counter pc (out,in,clock);

initial
begin
	clock=0; in=16'b1100000000000011;             // when clock=0
	#1 $display("clock=%b in=%b out=%b",clock,in,out);

	clock=1; in=16'b1100000000000011;             // when clock=1
	#1 $display("clock=%b in=%b out=%b",clock,in,out);
end

endmodule


// module for progarme counter
module programe_counter(out,in,clock);
 
input [15:0] in;
input clock;

output reg [15:0] out;

always @(posedge clock)
begin
	out <= in;
end

endmodule
