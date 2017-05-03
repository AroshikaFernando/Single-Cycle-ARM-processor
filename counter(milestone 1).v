
module test_counter;

reg [3:0] start_value;
reg load,hold,count_up,count_down;
reg clock,enable,reset;

wire [3:0] out_value;

counter Counter(out_value,start_value,load,hold,count_up,count_down,clock,enable);

initial
begin
	start_value=4'b1;  load=1;  enable=1;  clock=0;            // test load
	#1 $display("start_value=%b load=%b out_value=%b",start_value,load,out_value);

	start_value=4'b1;  load=1;  enable=1;  clock=1;
	#1 $display("start_value=%b load=%b out_value=%b",start_value,load,out_value);

	hold=1;  enable=1;  clock=0;                               // test hold
	#1 $display("start_value=%b hold=%b out_value=%b",start_value,load,out_value);

	hold=1;  enable=1;  clock=1;
	#1 $display("start_value=%b hold=%b out_value=%b",start_value,hold,out_value);

	start_value=4'b1;  count_up=1;  enable=1;  clock=0; hold=0; load=0;      // test count up
	#1 $display("start_value=%b count_up=%b out_value=%b",start_value,count_up,out_value);

	start_value=4'b1;  count_up=1;  enable=1;  clock=1; hold=0; load=0;
	#1 $display("start_value=%b count_up=%b out_value=%b",start_value,count_up,out_value);

	start_value=4'b1;  count_down=1;  enable=1;  clock=0; hold=0; load=0;       // test count down
	#1 $display("start_value=%b count_down=%b out_value=%b",start_value,count_down,out_value);

	start_value=4'b1;  count_down=1;  enable=1;  clock=1; hold=0; load=1;
	#1 $display("start_value=%b count_down=%b out_value=%b",start_value,count_down,out_value);
	
	
end


endmodule

//-----------------------Counter---------------------------//

module counter(out_value,start_value,load,hold,count_up,count_down,clock,enable);

input [3:0] start_value;
input load,hold,count_up,count_down;
input clock,enable;

output reg [3:0] out_value;

reg [3:0] counter;


always @(posedge clock )
begin
if(enable)
	begin
		if(load)
			   out_value <= start_value;
		else if(count_up)
			   out_value <= start_value + 1;
			else if(count_down)
			   out_value <= start_value - 1; 
			else if (hold)
			  out_value <= out_value; 
	end
	
	//assign out_value = counter;
	
end

endmodule
