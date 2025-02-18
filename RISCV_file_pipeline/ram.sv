// Quartus II Verilog Template
// Single port RAM with single read/write address
// specified with an initial block

module ram
  #(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=10)
   (
    input [(DATA_WIDTH-1):0]  wdata,
    input [(ADDR_WIDTH-1):0]  addr,
    input 		      we, clk,
    output [(DATA_WIDTH-1):0] rdata,
    output 		      rdata_valid
    );

   // Declare the RAM variable
   reg [DATA_WIDTH-1:0]       ram[2**ADDR_WIDTH-1:0];

   // Variable to hold the registered read address
   reg [ADDR_WIDTH-1:0]       addr_reg;

   // The $readmemb and $readmemh system tasks load the contents of a 2-D
   // array variable from a text file.  QIS supports these system tasks in
   // initial blocks.  They may be used to initialized the contents of inferred
   // RAMs or ROMs.  They may also be used to specify the power-up value for
   // a 2-D array of registers.
   //
   // Usage:
   //
   // ("file_name", memory_name [, start_addr [, end_addr]]);
   // ("file_name", memory_name [, start_addr [, end_addr]]);
   //
   // File Format:
   //
   // The text file can contain Verilog whitespace characters, comments,
   // and binary ($readmemb) or hexadecimal ($readmemh) data values.  Both
   // types of data values can contain x or X, z or Z, and the underscore
   // character.
   //
   // The data values are assigned to memory words from left to right,
   // beginning at start_addr or the left array bound (the default).  The
   // next address to load may be specified in the file itself using @hhhhhh,
   // where h is a hexadecimal character.  Spaces between the @ and the address
   // character are not allowed.  It shall be an error if there are too many
   // words in the file or if an address is outside the bounds of the array.
   //
   // Example:
   //
   // reg [7:0] ram[0:2];
   //
   // initial
   // begin
   //     $readmemb("init.txt", rom);
   // end
   //
   // <init.txt>
   //
   // 11110000      // Loads at address 0 by default
   // 10101111
   // @2 00001111
   initial
     begin
	$readmemh("ram_data.txt", ram);
     end

   always @ (posedge clk)
     begin
	// Write
	if (we)
	  ram[addr] <= wdata;

	addr_reg <= addr;
     end

   // Continuous assignment implies read returns NEW data.
   // This is the natural behavior of the TriMatrix memory
   // blocks in Single Port mode.
   assign rdata = ram[addr_reg];

   assign rdata_valid = 1'b1;

endmodule
