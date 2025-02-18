module decoder (                 
					  output logic ALUsrc,
                 
					  output logic [4:0]rs1,
					  
					  output logic [4:0]rs2,
					  
					  output logic [4:0]rd ,
					  
					  output logic [4:0]operation,
					  
					  output logic jump,
					  
					  output logic branch,
					  
					  output logic write,
					  
					  output logic [31:0]Imm,

					  output logic [31:0]SImm,
					  
					  output logic store,

					  output logic [1:0]rdSrc,

					  output logic PCnext,
					  
					  input logic [31:0]instruction,
					  
					  output logic [2:0] nbDeBits 
					  
					  
					  );

					  
always@(*)
case(instruction[6:0])
	
	
	
	7'b0110011 : begin  // R-Type
					 rd        <= instruction[11:7] ;
					 operation <= {1'b0,instruction[30],instruction[14:12]};
					 rs1       <= instruction[19:15];
					 rs2       <= instruction[24:20];
					 ALUsrc    <= 0 ;
					 jump      <= 0 ;
					 store     <= 0 ;
					 write     <= 1 ; // doute 
					 Imm       <= 0 ;
					 SImm      <= 0 ;
					 rdSrc	   <= 0 ;
					 PCnext    <= 0 ;
					 nbDeBits  <= 3'b010;
					 branch    <= 0;
				 end	
	
	
	7'b0010011 : 	begin  // I-Type pour ALU (sans load/store)
					 rd        <= instruction[11:7] ;
					 operation <= {2'b00,instruction[14:12]};
					 rs1       <= instruction[19:15];
					 rs2       <= 0 ;
					 ALUsrc    <= 1 ;
					 jump      <= 0 ;
					 store     <= 0 ;
					 write     <= 1 ; // doute 
					 Imm       <= {20'b0,instruction[31:20]};
					 SImm      <= {{20{instruction[31]}},instruction[31:20]};				 
					 rdSrc	   <= 0 ;
					 PCnext    <= 0 ;
					 nbDeBits  <= 3'b010;
					 branch    <= 0;
					end
	
	7'b0000011 : 	begin // I-Type pour load
					 rd       <= instruction[11:7] ;
					 operation <= 5'b00000;
					 rs1       <= instruction[19:15];
					 rs2       <= 0 ;
					 ALUsrc    <= 1 ;
					 jump      <= 0 ;
					 store     <= 0 ;
					 write     <= 1 ; // doute // je l'ai change en 1 pour voir ...
					 Imm       <= {20'b0,instruction[31:20]};
					 SImm      <= {{20{instruction[31]}},instruction[31:20]};					 
					 rdSrc	   <= 1 ;
					 PCnext    <= 0 ;
					 nbDeBits  <= instruction[14:12] ;
					 branch    <= 0;
					 end	


	7'b0100011 : 	begin  // S-Type 
					 rd        <= 0 ;
					 operation <= 5'b00000;
					 rs1       <= instruction[19:15];
					 rs2       <= instruction[24:20] ;
					 ALUsrc    <= 1 ;
					 jump       <= 0 ;
					 store     <= 1 ;
					 write     <= 0 ; // doute 
					 Imm       <= {20'b0,instruction[31:25],instruction[11:7]};
					 SImm      <= {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
					 rdSrc	   <= 0 ;
					 PCnext    <= 0 ;
					 nbDeBits  <= instruction[14:12] ;
					 branch    <= 0;
					 end
	
	7'b1100011 : 	begin // B-Type
					 rd        <= 0 ;
					 operation <= {2'b10,instruction[14:12]};
					 rs1       <= instruction[19:15];
					 rs2       <= instruction[24:20] ;
					 ALUsrc    <= 0 ; // Modif
					 jump      <= 0 ;
					 store     <= 0 ;
					 write     <= 0 ; // doute 
					 Imm       <= {19'b0,instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0}; // Modif
					 SImm      <= {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
					 rdSrc	   <= 0 ;
					 PCnext    <= 0 ;
					 branch   <= 1 ;
					 nbDeBits  <= 3'b010;
					 end
	
	7'b1101111 : 	begin  // JAL
					 rd        <= instruction[11:7] ;
					 operation <= 5'b00000;
					 rs1       <= 0 ;
					 rs2       <= 0 ;
					 ALUsrc    <= 0 ;	 
					 jump      <= 1 ;
					 store     <= 0 ;
					 write     <= 1 ; // doute 
					 Imm       <=	{11'b0,instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
					 SImm      <= {{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
					 rdSrc	   <= 3 ;
					 PCnext    <= 0 ;
					 branch   <= 0 ;
					 nbDeBits  <= 3'b010;
					 end 
	
	
	7'b1100111 : 	begin  // JALR
					 rd        <= instruction[11:7] ;
					 operation <= 5'b00000;
					 rs1       <= instruction[19:15] ;
					 rs2       <= 0 ;
					 ALUsrc    <= 1 ;
					 jump       <= 1 ;
					 store     <= 0 ;
					 write     <= 1 ; // doute 
					 Imm       <=  {20'b000000000000,instruction[31:20]};
					 SImm      <= {{20{instruction[31]}},instruction[31:20]};
					 rdSrc	   <= 3 ;
					 PCnext    <= 0 ;
					 branch    <= 0 ;
					 nbDeBits  <= 3'b010;
					 end
	
	
	7'b0110111 : 	begin  // LUI
					 rd        <= instruction[11:7] ;
					 operation <= 5'b00000;
					 rs1       <= 0 ;
					 rs2       <= 0 ;
					 ALUsrc    <= 1 ;	 
					 jump       <= 0 ;
					 store     <= 0 ;
					 write     <= 1 ; // doute 
					 Imm       <= {instruction[31:12],12'b000000000000};
					 SImm      <= {instruction[31:12],12'b000000000000};
					 rdSrc	   <= 0 ;
					 PCnext    <= 0 ;
					 branch    <= 0 ;
					 nbDeBits  <= 3'b010;
					 end
					 
	7'b0010111 :    begin // AUIPC
					 rd        <= instruction[11:7] ;
					 operation <= 5'b00000;
					 rs1       <= 0 ;
					 rs2       <= 0 ;
					 ALUsrc    <= 1 ;
					 jump      <= 0 ;
					 store     <= 0 ;
					 write     <= 1 ; // doute 
					 Imm       <= {instruction[31:12],12'b000000000000}; 	
					 SImm      <= {instruction[31:12],12'b000000000000};
					 rdSrc	   <= 2 ;
					 PCnext    <= 0 ;
					 branch    <= 0 ;	
					 nbDeBits  <= 3'b010;		 
					end

	default : begin //default
					 rd        <= 0 ;
					 operation <= 5'b00000;
					 rs1       <= 0 ;
					 rs2       <= 0 ;
					 ALUsrc    <= 0 ;
					 jump      <= 0 ;
					 store     <= 0 ;
					 write     <= 0 ; // doute 
					 Imm       <= 0 ;
					 SImm       <= 0 ;  	
					 rdSrc	   <= 0 ;
					 PCnext    <= 0 ;
					 branch    <= 0 ;	
					 nbDeBits  <= 3'b010;		 
					end


endcase
endmodule	
