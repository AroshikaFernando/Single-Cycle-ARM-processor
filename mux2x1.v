// Group-12
// Milestone 3 (project)- Problem 3
// A behavioral VHDL model for 2x1 multiplexer

// s=0 -> out=i0
// s=1 -> out=i1

// module for test bench
module stimulus;

	// Declare variables to be connected to inputs
	reg [15:0] in0;
	reg [15:0] in1;
	reg s;
	
	// Declare output wire
	wire [15:0]out;
	
	// Instantiate the multiplexer
	mux2_to_1 mux(out, in0, in1, s);
	
	// Stimulate the inputs
	// Define the stimulus module (no ports)
	initial
	begin
		// set input lines
		in0 = 16'b1; in1 = 16'b0;
		#1 $display("in0= %b, in1= %b\n",in0,in1);
		// choose in0
		s = 0;
		#1 $display("s = %b, out = %b \n", s, out);
		// choose in1
		s = 1;
		#1 $display("s = %b, out = %b \n", s,out);
		
	end
	
endmodule


// Module 2-to-1 multiplexer.
module mux2_to_1 (out, i0, i1, s);
	
	// Port declarations from the I/O diagram
	output [15:0]out;
	input  [15:0]i0;
	input  [15:0]i1;
	input s;

	reg [15:0]tempout;
	
	always @(s,i0,i1)
	begin	
	
		case (s)
			1'b0 : tempout = i0;
			1'b1 : tempout = i1;
			default : $display("Invalid signal");	
		endcase
	
	end	
	
	assign out=tempout;
	
endmodule



