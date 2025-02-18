module decaleur(input logic  [2:0] nbDeBits,
		input logic [31:0] input_signal,
		output logic [31:0] output_signal);



always@(*)

case(nbDeBits)
	
	3'b000 : output_signal <= {24'b000000000000000000000000,input_signal[7:0]} ;
	
	3'b001 : output_signal <= {16'b0000000000000000, input_signal[15:0]};
		
	3'b010 : output_signal <= input_signal;
endcase 

endmodule 
		
