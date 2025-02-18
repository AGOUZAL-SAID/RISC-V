module uniteArithmetique ( input logic [31:0]rs1,
			   input logic [31:0]rs2,
			   input logic [31:0]Imm,
			   input logic signed [31:0]Srs1,
			   input logic signed [31:0]Srs2,
			   input logic signed [31:0]SImm,
			   input logic [4:0]operation,
			   output logic [31:0]resultat,
			   input logic AluSource);
									
				
									
logic [31:0] entre2;	
logic signed [31:0] Sentre2;	
				
					
							
always@(*)

	begin
	case(AluSource)
	
	1: begin entre2  <= Imm  ; 
	   Sentre2 <= SImm ; end
		
	0: begin entre2  <= rs2  ;
           Sentre2 <= Srs2 ; end 
		
	endcase

	
	case(operation)
	5'b00000: resultat <= Srs1 + Sentre2 ; //doute //je l'ai change en Sentre2 pour voir ...
	
	5'b01000: resultat <= Srs1 - Sentre2 ; //ca aussi je l'ai change en Sentre2 pour voir ...
	
	5'b00001: resultat <= Srs1 << Sentre2[4:0];
	
	5'b00010: resultat <= Srs1 < Sentre2 ;
	
	5'b00011: resultat <= rs1  < entre2  ;
	
	5'b00100: resultat <= rs1 ^ Sentre2 ;
	
	5'b00101: resultat <= rs1 >> entre2[4:0]; // >> = logique, >>> = arith
	
	5'b00110: resultat <= rs1 | Sentre2 ;
	
	5'b00111: resultat <= rs1 & Sentre2 ;
	
	5'b10000: resultat <= Srs1 == Sentre2;
	
	5'b10001: resultat <= Srs1 != Sentre2;
	
	5'b10100: resultat <= Srs1 <  Sentre2;
	
	5'b10101: resultat <= Srs1 >= Sentre2;
	
	5'b10110: resultat <= rs1 < entre2   ; 
	
	5'b10111: resultat <= rs1 >= entre2 ;

	default: resultat <= 0;
	
	endcase
	end 
endmodule		
