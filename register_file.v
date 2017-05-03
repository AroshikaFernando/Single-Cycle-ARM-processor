// Group-12
// Lab 2 Exercise 
// A behavioral VHDL model for a 4-bit shift register

// ctrl0=0 ctrl1=0 -> load
// ctrl0=0 ctrl1=1 -> hold
// ctrl0=1 ctrl1=0 -> shift left
// ctrl0=1 ctrl1=1 -> shift right

module test_regFile;
	
	// Declare variables to be connected
	// to inputs
	reg [3:0] read_reg1;
	reg [3:0] read_reg2;
	reg [3:0] write_reg;
	reg [15:0] write_data;
	reg regWrite,clear,clock;
	
	wire [15:0] read_data1;
	wire [15:0] read_data2;
	
	register_file register (read_data1 , read_data2 , read_reg1 , read_reg2 , write_reg , write_data , regWrite , clear , clock);
	
	initial
		begin
		
			// There is no any value in register file at this time. 
			// Output: A=xxxxxxxxxxxxxxxx  B=xxxxxxxxxxxxxxxx
			read_reg1 = 4'b0010; read_reg2 = 4'b0011;  clock=1; 
			#1 $display("regWrite=%d read_reg1=%b read_reg2=%b read_data1=%b read_data2=%b",regWrite,read_reg1,read_reg2,read_data1,read_data2);   
		
			// Load value of C to C_address position in the register file
			// Store that value to A 
			write_data = 16'd1;   write_reg = 4'b0001;   regWrite = 1;  clock = 1;  read_reg1 = 4'b0001;
			#1 $display("regWrite=%d write_data=%b write_reg=%b read_reg1=%b read_data1=%b",regWrite,write_data,write_reg,read_reg1,read_data1); 

			// Store value which is in the C_address of the register file to B
			// In this situation clock is 0
			// Therefor output: B=xxxxxxxxxxxxxxxx
			clock = 0; read_reg2 = 4'b0001;
			#1 $display("clock=%d write_data=%b write_reg=%b read_reg2=%b read_data2=%b",clock,write_data,write_reg,read_reg2,read_data2); 
			
			// Store value which is in the C_address of the register file to B
			// In this situation clock is in a rising edge
			// Therefore output: B=0000000000000001
			clock = 1; read_reg2 = 4'b0001;
			#1 $display("clock=%d write_data=%b write_reg=%b read_reg2=%b read_data2=%b",clock,write_data,write_reg,read_reg2,read_data2); 

			// Check clear
			clear = 0;
			#1 $display("clear=%d read_reg1=%b read_data1=%b read_reg2=%b read_data2=%b",clear,read_reg1,read_data1,read_reg2,read_data2); 
			
			  
		
		end

endmodule

// module for register file
module register_file (read_data1 , read_data2 , read_reg1 , read_reg2 , write_reg , write_data , regWrite , clear , clock);

	
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
	input regWrite,clear,clock;
	
	integer i;
		
	always @ (posedge clock , clear , regWrite)
	
	begin
	
	//load c value to the register given in c address
	if ( regWrite == 1 )          
		reg_file[write_reg] = write_data[15:0];
	
	//clear all values in the registers in register file
	if (clear == 0)
		begin
			for(i=0 ; i<= 15 ; i=i+1)
				reg_file[i] = 16'b0;
					
		end

	//values in register given A_addr and B_addr load to the A and B
			read_data1 = reg_file[read_reg1];
			read_data2 = reg_file[read_reg2];
		
	end
	
endmodule
