module regs(input logic clk,
	    input logic [4:0]	rs1,
	    input logic [4:0]	rs2,
	    input logic [4:0]	rd,
	    input logic [31:0]	val_rd,
	    input logic		write_enable,
	    output logic [31:0]	val_rs1,
	    output logic [31:0]	val_rs2);

   logic [31:0]			regs[32];

   // Ecriture synchrone
   always @(posedge clk)
     if (write_enable)
       regs[rd] <= val_rd;

   // Lecture synchrone
   always @(posedge clk)
     if (rs1 == 0)
       val_rs1 <= 0;
     else
       val_rs1 <= regs[rs1];

   always @(posedge clk)
     if (rs2 == 0)
       val_rs2 <= 0;
     else
       val_rs2 <= regs[rs2];
   
endmodule // regs
