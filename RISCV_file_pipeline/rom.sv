module rom
  #(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=10)
   (
    input logic [(ADDR_WIDTH-1):0]  addr,
    input logic 		    clk,
    output logic [(DATA_WIDTH-1):0] rdata,
    output logic 		    rdata_valid
    );


   //`ifdef SIMULATION
   logic [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];
   initial
     begin
	// initialisation de la ROM avec le fichier d'initialisation
	$readmemh("rom_data.txt", rom);
     end
   //`else
   //(* ram_init_file = "../rom/rom_data.mif" *) logic [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];
   //`endif


   always @ (posedge clk)
     begin
	rdata <= rom[addr];
     end

   assign rdata_valid = 1'b1;

endmodule
