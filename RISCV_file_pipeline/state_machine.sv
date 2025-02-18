module state_machine(input logic clk,
			 input logic reset_n,
		     output logic IF,
		     output logic ID,
		     output logic EX,	
		     output logic MEM,
		     output logic WB
		     );


logic [2:0] state;

/*
always @(*)
begin
	IF <= (state == 0);
	ID <= (state == 1);
	// ...
end
*/

always@(posedge clk)

if (!reset_n)
	begin
		state <= 0;
	   	IF  <= 1;
	   	ID  <= 0;
	   	EX  <= 0;
	   	MEM <= 0;
	   	WB  <= 0;
	end
else
case(state)
	0: begin state <= 1;
	   IF  <= 0;
	   ID  <= 1;
	   EX  <= 0;
	   MEM <= 0;
	   WB  <= 0;
	   end
	
	1: begin state <= 2;
	   IF  <= 0;
	   ID  <= 0;
	   EX  <= 1;
	   MEM <= 0;
	   WB  <= 0;
	   end
	
	2: begin state <= 3;
	   IF  <= 0;
	   ID  <= 0;
	   EX  <= 0;
	   MEM <= 1;
	   WB  <= 0;
	   end
	
	3: begin state <= 4;
	   IF  <= 0;
	   ID  <= 0;
	   EX  <= 0;
	   MEM <= 0;
	   WB  <= 1;
	   end
	
	4: begin state <= 0;
	   IF  <= 1;
	   ID  <= 0;
	   EX  <= 0;
	   MEM <= 0;
	   WB  <= 0;
	   end

endcase

endmodule 
		
