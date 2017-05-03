// Group-12
// Milestone 1(project) - Problem 5
// Implemented as a rising edge triggered device
// A behavioral VHDL model for a 4-bit shift register

// ctrl0=0 ctrl1=0 -> load
// ctrl0=0 ctrl1=1 -> hold
// ctrl0=1 ctrl1=0 -> shift left
// ctrl0=1 ctrl1=1 -> shift right

module stimulus;

	// Declare variables to be connected
	// to inputs
	reg [3:0]input_val;
	reg ctrl0,ctrl1;
	reg msb,lsb,clock,enable;
	
	wire [3:0]output_val;
	
	bit4_shiftregister shift(input_val,output_val,ctrl0,ctrl1,clock,enable,msb,lsb);
	
	initial
	begin
		
		//load
		input_val = 4'b1010; ctrl0 = 0; ctrl1 = 0; enable = 1; clock = 0; msb = 1; lsb = 0;
		#1 $display("ctrl0=%b , ctrl1=%b , clock=%b, input=%b , output=%b , msb=%b , lsb=%b",ctrl0,ctrl1,clock,input_val,output_val,msb,lsb);

		input_val = 4'b1010; ctrl0 = 0; ctrl1 = 0; enable = 1; clock = 1; msb = 1; lsb = 0;
		#1 $display("ctrl0=%b , ctrl1=%b , clock=%b, input=%b , output=%b , msb=%b , lsb=%b",ctrl0,ctrl1,clock,input_val,output_val,msb,lsb);
		
		//hold
		input_val = 4'b1010; ctrl0 = 0; ctrl1 = 1; enable = 1; clock = 0; msb = 1; lsb = 0;
		#1 $display("ctrl0=%b , ctrl1=%b , clock=%b, input=%b , output=%b , msb=%b , lsb=%b",ctrl0,ctrl1,clock,input_val,output_val,msb,lsb);
		
		input_val = 4'b1010; ctrl0 = 0; ctrl1 = 1; enable = 1; clock = 1; msb = 1; lsb = 0;
		#1 $display("ctrl0=%b , ctrl1=%b , clock=%b, input=%b , output=%b , msb=%b , lsb=%b",ctrl0,ctrl1,clock,input_val,output_val,msb,lsb);
		
		//left shift
		input_val = 4'b1010; ctrl0 = 1; ctrl1 = 0; enable = 1; clock = 0; msb = 1; lsb = 0;
		#1 $display("ctrl0=%b , ctrl1=%b , clock=%b, input=%b , output=%b , msb=%b , lsb=%b",ctrl0,ctrl1,clock,input_val,output_val,msb,lsb);

		input_val = 4'b1010; ctrl0 = 1; ctrl1 = 0; enable = 1; clock = 1; msb = 1; lsb = 0;
		#1 $display("ctrl0=%b , ctrl1=%b , clock=%b, input=%b , output=%b , msb=%b , lsb=%b",ctrl0,ctrl1,clock,input_val,output_val,msb,lsb);
		
		//right shift
		input_val = 4'b1010; ctrl0 = 1; ctrl1 = 1; enable = 1; clock = 0; msb = 1; lsb = 0;
		#1 $display("ctrl0=%b , ctrl1=%b , clock=%b, input=%b , output=%b , msb=%b , lsb=%b",ctrl0,ctrl1,clock,input_val,output_val,msb,lsb);

		input_val = 4'b1010; ctrl0 = 1; ctrl1 = 1; enable = 1; clock = 1; msb = 1; lsb = 0;
		#1 $display("ctrl0=%b , ctrl1=%b , clock=%b, input=%b , output=%b , msb=%b , lsb=%b",ctrl0,ctrl1,clock,input_val,output_val,msb,lsb);
		
	end
	
endmodule


//function for 4 bit shift register
module bit4_shiftregister(input_val,output_val,ctrl0,ctrl1,clock,enable,msb,lsb);

	//declare variables
	output reg [3:0] output_val;
	input [3:0] input_val;
	input ctrl0,ctrl1,clock,enable,msb,lsb;
	
	//loop until ctrl0,ctrl1 and clock changed
	always @(ctrl0,ctrl1,posedge clock)
	if(clock == 1 && enable == 1)

	//check cases
	begin
	
		case({ctrl0 , ctrl1})
		
			2'b00 : output_val <= input_val;    			// load
			2'b01 : output_val <= output_val;   			//hold
			2'b10 : output_val <= {output_val[2:0] , lsb};	//left Shift
			2'b11 : output_val <= {msb , output_val[3:1]};	//right shift

		endcase
		
	end
	
endmodule



