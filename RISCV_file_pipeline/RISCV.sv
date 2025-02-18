module RISCV
  (
   input logic 	       clk,
   input logic 	       reset_n,

   // RAM contenant les données
   output logic [31:0] d_address,
   input logic [31:0]  d_data_read,
   output logic [31:0] d_data_write,
   output logic        d_write_enable,
   input logic 	       d_data_valid,

   // ROM contenant les instructions
   output logic [31:0] i_address,
   input logic [31:0]  i_data_read,
   input logic 	       i_data_valid
   );

// -----[IF]----- //
// fils pour le Program Counter (PC)
logic [31:0] PCNextResult_5;
logic [31:0] PC_before_1;
logic [31:0] PC_1;
logic IF;
logic ID;
logic EX;
logic MEM;
logic WB;
logic [31:0] PC_plus_4_1;
// [!!!]
// il faudrait PCNextResult_5 pour .input_pc, mais il reste des problemes logiques...
// du coup pour le moment on ne traite que le cas de pc+4 ...
// [!!!]
prog_counter program_counter(.input_pc(PC_plus_4_1), .clk(clk), .reset_n(reset_n), .output_pc(PC_before_1), .IF(1)) ;
// calculs de PC+4
always @(*)
  begin
    PC_plus_4_1 <= PC_1 + 4;
  end
// traverser le clk entre IF et ID
logic [31:0] PC_plus_4_2;
logic [31:0] PC_2;
always@(posedge clk)
  begin
    PC_plus_4_2 <= PC_plus_4_1;
    PC_2 <= PC_1;
  end

// -----[ID]----- //
// fils pour l'Instruction Memory (IM)
logic [31:0] Instr_2;
always @(*)
  begin
    i_address <= PC_1;
  end
// fils pour le Décodeur
logic jump_2;  
logic branch_2; 
logic PCNext_2;
logic MemWrite_2;
logic [31:0]ImmExt_2;
logic signed [31:0]SImmExt_2; 
logic [4:0]adr_rs1_2;
logic [4:0]adr_rs2_2;
logic [4:0]ALUop_2;
logic ALUsrc_2;             
logic [2:0] nbDeBits_2;
logic [1:0]rdSrc_2;
logic RFwrite_2;
logic [4:0]adr_rd_2;
decoder decoder(.instruction(Instr_2),.ALUsrc(ALUsrc_2), .rs1(adr_rs1_2),  .rs2(adr_rs2_2), .rd(adr_rd_2), .operation(ALUop_2), .jump(jump_2), .branch(branch_2), .write(RFwrite_2), .Imm(ImmExt_2), .SImm(SImmExt_2), .store(MemWrite_2), .rdSrc(rdSrc_2), .PCnext(PCNext_2), .nbDeBits(nbDeBits_2));
// calculs de PC+Imm
logic [31:0] PC_plus_imm_2;
always @(*)
  begin
    PC_plus_imm_2 <= PC_2 + SImmExt_2; 
  end
// traverser le clk entre ID et EX
logic jump_3;  
logic branch_3; 
logic PCNext_3;
logic [31:0] PC_plus_4_3;
logic [31:0] PC_plus_imm_3;
logic MemWrite_3;
logic [31:0]ImmExt_3;
logic signed [31:0]SImmExt_3; 
logic [4:0]ALUop_3;
logic ALUsrc_3;             
logic [2:0] nbDeBits_3;
logic [1:0]rdSrc_3;
logic RFwrite_3;
logic [4:0]adr_rd_3;
logic [4:0]adr_rs1_3; //df
logic [4:0]adr_rs2_3; //df
always@(posedge clk)
  begin
    jump_3 <= jump_2;
    branch_3 <= branch_2;
    PCNext_3 <= PCNext_2;
    PC_plus_4_3 <= PC_plus_4_2;
    PC_plus_imm_3 <= PC_plus_imm_2;
    ImmExt_3 <= ImmExt_2;
    SImmExt_3 <= SImmExt_2;
    ALUop_3 <= ALUop_2;
    ALUsrc_3 <= ALUsrc_2;
    nbDeBits_3 <= nbDeBits_2;
    rdSrc_3 <= rdSrc_2;
    RFwrite_3 <= RFwrite_2;
    adr_rd_3 <= adr_rd_2;
    MemWrite_3 <= MemWrite_2;
    adr_rs1_3 <= adr_rs1_2; //df
    adr_rs2_3 <= adr_rs2_2; //df
  end

// -----[EX]----- //
// fils pour le Register File (RF)
logic [31:0] rs1_3; // (partie EX)
logic [31:0] rs2_3;
logic [31:0] rs1_df_3; 
logic [31:0] rs2_df_3;
logic writeRF_5; // (partie WB, les valeurs seront definies dans [WB])
logic [31:0] rd_5;
logic [4:0] adr_rd_5;
regs RF(.clk(clk), .rs1(adr_rs1_2), .rs2(adr_rs2_2), .rd(adr_rd_5), .val_rd(rd_5), .write_enable(writeRF_5), .val_rs1(rs1_3), .val_rs2(rs2_3));
// fils pour l'Arithmetic and Logic Unit (ALU)
logic [31:0] ALUResult_3;
uniteArithmetique ALU(.rs1(rs1_df_3), .rs2(rs2_df_3), .Imm(ImmExt_3), .Srs1(rs1_df_3), .Srs2(rs2_df_3), .SImm(SImmExt_3), .AluSource(ALUsrc_3), .operation(ALUop_3), .resultat(ALUResult_3));
// fils pour le Decaleur WriteData
logic [31:0] WD_3;
decaleur decalWD(.nbDeBits(nbDeBits_3), .input_signal(rs2_df_3), .output_signal(WD_3));
// calculs de PCNextResult
logic TargetAddr_3;
logic [31:0] TargetAddrResult_3;
logic [31:0] PCNextResult_3;  
always@(*)
  begin
    TargetAddr_3 <= jump_3 || (branch_3 && ALUResult_3[0]);
    case (TargetAddr_3)
      0: TargetAddrResult_3 <= PC_plus_4_3;
      1: TargetAddrResult_3 <= PC_plus_imm_3;
    endcase
    case(PCNext_3)
      0: PCNextResult_3 <= TargetAddrResult_3;
      1: PCNextResult_3 <= ALUResult_3;
    endcase
  end
// traverser le clk entre EX et MEM
logic [31:0] PCNextResult_4;
logic [31:0] PC_plus_4_4;
logic [31:0] PC_plus_imm_4;
logic [31:0] ALUResult_4;           
logic [2:0] nbDeBits_4;
logic [1:0]rdSrc_4;
logic RFwrite_4;
logic [4:0]adr_rd_4;
always @(posedge clk)
  begin
    PCNextResult_4 <= PCNextResult_3;
    PC_plus_4_4 <= PC_plus_4_3;
    PC_plus_imm_4 <= PC_plus_imm_3;
    ALUResult_4 <= ALUResult_3;
    nbDeBits_4 <= nbDeBits_3;
    rdSrc_4 <= rdSrc_3;
    RFwrite_4 <= RFwrite_3;
    adr_rd_4 <= adr_rd_3;
  end

// -----[MEM]----- //
// fils pour le Data Memory (DM)
logic [31:0] RD_dataMem_4;
always @(*)
  begin
    d_data_write <= WD_3;
    d_address <= ALUResult_3;
    d_write_enable <= MemWrite_3;
  end

always @(posedge clk) RD_dataMem_4 <= d_data_read; // Modif

// fils pour le Decaleur ReadData
logic [31:0] RD_4;
decaleurSigned decalRD(.nbDeBits(nbDeBits_4), .input_signal(RD_dataMem_4), .output_signal(RD_4));
// calculs de rd
logic [31:0] rd_4;
always@(*)
  case(rdSrc_4)
    0: rd_4 <= ALUResult_4;
    1: rd_4 <= RD_4;
    2: rd_4 <= PC_plus_imm_4;
    3: rd_4 <= PC_plus_4_4;
  endcase
// traverser le clk entre MEM et WB
logic RFwrite_5;
always @(posedge clk)
  begin
    PCNextResult_5 <= PCNextResult_4;
    rd_5 <= rd_4;
    RFwrite_5 <= RFwrite_4;
    adr_rd_5 <= adr_rd_4;
    writeRF_5 <= RFwrite_4; //  Modif 5 -> 4
  end

// -----[WB]----- //
// il n'y a rien a faire ici ... peut etre

// State Machine
state_machine SM(.clk(clk), .reset_n(reset_n), .IF(IF), .ID(ID), .EX(EX), .MEM(MEM), .WB(WB) );


//data forwarding
always@(*)
begin
  if ( (adr_rs1_3 == adr_rd_4) && (RFwrite_4) && (adr_rd_4 != 0) ) 
    rs1_df_3 <= rd_4;
  else 
    begin
    if ( (adr_rs1_3 == adr_rd_5) && (adr_rd_4 != adr_rd_5)  && (RFwrite_5)  && (adr_rd_5 != 0) ) 
      rs1_df_3 <= rd_5;
    else 
      rs1_df_3 <= rs1_3;
    end

  if ( (adr_rs2_3 == adr_rd_4) && (RFwrite_4)  && (adr_rd_4 != 0) ) 
    rs2_df_3 <= rd_4;
  else 
    begin
    if ( (adr_rs2_3 == adr_rd_5) && (adr_rd_4 != adr_rd_5)  && (RFwrite_5)  && (adr_rd_5 != 0) ) 
      rs2_df_3 <= rd_5;
    else 
      rs2_df_3 <= rs2_3;
    end

end

// qqch-warding
always@(*)
begin
if ( ((branch_3) && (ALUResult_3[0] == 1)) || (jump_3) )
  begin
    PC_1 <= PCNextResult_3;
    Instr_2 <= 32'b110011;
  end
else 
  begin
    PC_1 <= PC_before_1;
    Instr_2 <= i_data_read;
  end 
end

endmodule // RISCV
