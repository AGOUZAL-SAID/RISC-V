 module DE1_SoC
    #(parameter ROM_ADDR_WIDTH=10, parameter RAM_ADDR_WIDTH=10)
    (
     ///////// clock /////////
     input logic 	clock_50,

     ///////// hex  /////////
     output logic [6:0] hex0,
     output logic [6:0] hex1,
     output logic [6:0] hex2,
     output logic [6:0] hex3,
     output logic [6:0] hex4,
     output logic [6:0] hex5,

     ///////// key ///////// 
     input logic [3:0] 	key,

     ///////// ledr /////////
     output logic [9:0] ledr,

     ///////// sw /////////
     input logic [9:0] 	sw,

     ///////// VGA  /////////
     output logic 	VGA_CLK,
     output logic 	VGA_HS,
     output logic 	VGA_VS,
     output logic 	VGA_BLANK,
     output logic [7:0] VGA_R,
     output logic [7:0] VGA_G,
     output logic [7:0] VGA_B,
     output logic 	VGA_SYNC

     );



   // Génération d'un reset à partir du bouton key[0]
   logic 			    reset_n;
   gene_reset gene_reset(.clk(clock_50), .key(key[0]), .reset_n(reset_n));

   // Instantication de la RAM pour les données
   logic [31:0] 		    ram_addr;
   logic [31:0] 		    ram_rdata, ram_wdata;
   logic 			          ram_we;
   logic 			          ram_rdata_valid;
   logic [2:0]          periph_choice;


    logic [31:0] d_address;
    logic [31:0] d_data_write;
    logic d_write_enable;
    logic [31:0] d_data_read;

    logic [31:0] gpu_data_out;

  always @(*) 
    begin
      ram_addr        <= d_address;
      ram_wdata       <= d_data_write;
      periph_choice   <= d_address[31:29];

      /// Bits de poids forts :
      /// 000 : RAM
      /// 001 : Switchs
      /// 010 : LEDs
      /// 011 : Afficheurs 7-segments
      /// 100 : frame buffer

      ram_we <= (periph_choice == 3'b000) && d_write_enable;

    end

   ram #(.ADDR_WIDTH(RAM_ADDR_WIDTH)) ram_datad_data_valid // ?
     (
      .clk         ( clock_50                         ),
      .addr        ( ram_addr[(RAM_ADDR_WIDTH-1)+2:2] ),
      .we          ( ram_we                           ),
      .wdata       ( ram_wdata                        ),
      .rdata       ( ram_rdata                        ),
      .rdata_valid ( ram_rdata_valid                  )
      );

   // Instantication de la ROM pour les instructions
   logic [31:0] 		    rom_addr;
   logic [31:0] 		    rom_rdata;
   logic 			    rom_rdata_valid;

   rom #(.ADDR_WIDTH(ROM_ADDR_WIDTH)) rom_instructions
     (
      .clk         ( clock_50                         ),
      .addr        ( rom_addr[(ROM_ADDR_WIDTH-1)+2:2] ),
      .rdata       ( rom_rdata                        ),
      .rdata_valid ( rom_rdata_valid                  )
      );



   // Ajout des périphériques de lecture

always @(*)
  begin
  case(periph_choice)

    3'b000 : d_data_read <= ram_rdata;

    // Switchs
    3'b001 : d_data_read <= {22'b0,sw[9:0]}; // NoModif


    3'b100 : d_data_read <= gpu_data_out;

  endcase
  end


   // Ajout des périphériques d'écriture
 
   // LEDs
logic led_enable;

always @(*)
  led_enable <= (periph_choice == 3'b010) && d_write_enable;


always@(posedge clock_50)
	if (led_enable)
    ledr[9:0] <= d_data_write[9:0];

    // Afficheurs 7 segments
logic aff_7_seg_enable;
logic [6:0] d_hex0, d_hex1, d_hex2, d_hex3, d_hex4, d_hex5;

always @(*)
  aff_7_seg_enable <= (periph_choice == 3'b011) && d_write_enable;


    dec7seg dec7seg0
     (
      .E         (d_data_write[3:0]),
      .SevenSeg  (d_hex0)
     );

    dec7seg dec7seg1
     (
      .E         (d_data_write[7:4]),
      .SevenSeg  (d_hex1)
     );

    dec7seg dec7seg2
     (
      .E         (d_data_write[11:8]),
      .SevenSeg  (d_hex2)
     );

    dec7seg dec7seg3
     (
      .E         (d_data_write[15:12]),
      .SevenSeg  (d_hex3)
     );

    dec7seg dec7seg4
     (
      .E         (d_data_write[19:16]),
      .SevenSeg  (d_hex4)
     );

    dec7seg dec7seg5
     (
      .E         (d_data_write[23:20]),
      .SevenSeg  (d_hex5)
     );


always@(posedge clock_50)
	if (aff_7_seg_enable)
    begin 
      hex0 <= d_hex0;
      hex1 <= d_hex1;
      hex2 <= d_hex2;
      hex3 <= d_hex3;
      hex4 <= d_hex4;
      hex5 <= d_hex5;
    end

  // Frame buffer
logic gpu_enable;
logic [23:0] color;
logic [15:0] xy_addr;


always @(*)
  gpu_enable <= (periph_choice == 3'b100) && d_write_enable;


  GPU gpu (
      .clk(clock_50),
      .gpu_enable(gpu_enable),
      .input_address(d_address),
      .input_data(d_data_write),
      .data_out(gpu_data_out), // pour le moment il dit juste si cest occupe ou pas en 80000014, dataout=0 <=> free 
      .reset_n(reset_n),
	    .VGA_CLK(VGA_CLK),
      .VGA_HS(VGA_HS),
      .VGA_VS(VGA_VS),
      .VGA_BLANK(VGA_BLANK),
      .VGA_R(VGA_R),
      .VGA_G(VGA_G),
      .VGA_B(VGA_B)
      );




   // Instanciation du processeur
   RISCV riscv
     (
      .clk            ( clock_50        ),
      .reset_n        ( reset_n         ),
      .d_address      ( d_address       ),
      .d_data_read    ( d_data_read     ),
      .d_data_write   ( d_data_write    ),
      .d_write_enable ( d_write_enable  ),
      .d_data_valid   ( ram_rdata_valid ),
      .i_address      ( rom_addr        ),
      .i_data_read    ( rom_rdata       ),
      .i_data_valid   ( rom_rdata_valid )
      );


logic [15:0] randomNumber;
logic [31:0] randomNumber_extanded;
assign randomNumber_extanded = {16'b0,randomNumber};
/*
lfsr LFSR(.clk(clock_50),
          .reset_n(reset_n),
          .randomNumber(randomNumber));
*/

endmodule
