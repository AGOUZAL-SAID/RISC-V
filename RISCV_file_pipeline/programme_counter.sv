module prog_counter(   input logic clk,
			  input logic reset_n,
			  input logic [31:0] input_pc, 
			  output logic [31:0] output_pc, 
			  input logic IF  );

//logic [31:0]pc = 0;

always@(posedge clk)
	if (!reset_n)
		output_pc <= 0;
	else
		if (IF)
			output_pc <= input_pc;
endmodule 
		
