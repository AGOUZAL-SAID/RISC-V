module decaleurSigned(input  logic [2:0] nbDeBits,
		input logic signed [31:0] input_signal,
		output logic signed [31:0] output_signal);



always@(*)

case(nbDeBits)
	
	3'b000 : output_signal <= {{24{input_signal[7]}},input_signal[7:0]} ;
	
	3'b001 : output_signal <= {{16{input_signal[15]}}, input_signal[15:0]};
		
	3'b010 : output_signal <= input_signal;
endcase 

endmodule 
		
