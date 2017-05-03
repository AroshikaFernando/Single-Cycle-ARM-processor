// module for test counter
module test_counter;

reg [3:0] start_value;
reg load,hold,count_up,count_down;
reg clock,enable,reset;

wire [3:0] out_value;

counter grayCount(out_value,start_value,load,hold,count_up,count_down,clock,enable,reset);

initial
begin
	start_value=3'b1;  load=1;  enable=1;  clock=0;            // test load
	#1 $display("start_value=%b load=%b out_value=%b",start_value,load,out_value);

	start_value=3'b1;  load=1;  enable=1;  clock=1;
	#1 $display("start_value=%b load=%b out_value=%b",start_value,load,out_value);

	hold=1;  enable=1;  clock=0;                               // test hold
	#1 $display("start_value=%b hold=%b out_value=%b",start_value,load,out_value);

	hold=1;  enable=1;  clock=1;
	#1 $display("start_value=%b hold=%b out_value=%b",start_value,hold,out_value);

	start_value=3'b10;  count_up=1;  enable=1;  clock=0;       // test count up
	#1 $display("start_value=%b count_up=%b out_value=%b",start_value,count_up,out_value);

	start_value=3'b10;  count_up=1;  enable=1;  clock=1;
	#1 $display("start_value=%b count_up=%b out_value=%b",start_value,count_up,out_value);

	start_value=3'b10;  count_down=1;  enable=1;  clock=0;       // test count up
	#1 $display("start_value=%b count_down=%b out_value=%b",start_value,count_down,out_value);

	start_value=3'b10;  count_down=1;  enable=1;  clock=1;
	#1 $display("start_value=%b count_down=%b out_value=%b",start_value,count_down,out_value);
end

endmodule


// module for 4 bit shift gray code counter
module counter(out_value,start_value,load,hold,count_up,count_down,clock,enable,reset);

input [3:0] start_value;
input load,hold,count_up,count_down;
input clock,enable,reset;

output reg [3:0] out_value;

wire [3:0] shift_value;
reg [3:0] counter;


always @(posedge clock or negedge reset)
begin
if(enable)
begin
	if(!reset)
   	   out_value <= 4'd0;
	else if(load)
           out_value <= start_value;
	else if(count_up)
           counter <= start_value + 1;
        else if(count_down)
           counter <= start_value - 1; 
        else 
          out_value <= out_value; 
end

end

bit4_shiftregister shift(counter,shift_value,1'd1,1'd1,clock,enable,1'b0,1'b0);
wire [3:0]temp = counter;

always @*
begin
if(count_up || count_down)
   out_value = temp ^ shift_value;
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
