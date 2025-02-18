module tb ();

    logic clock_50;

     ///////// hex  /////////
     logic [6:0] hex0;
      logic [6:0] hex1;
      logic [6:0] hex2;
      logic [6:0] hex3;
      logic [6:0] hex4;
      logic [6:0] hex5;

     ///////// key /////////
      logic [3:0] 	key;

     ///////// ledr /////////
      logic [9:0] ledr;

     ///////// sw /////////
      logic [9:0] 	sw;

     ///////// VGA  /////////
      logic 	VGA_CLK;
      logic 	VGA_HS;
      logic 	VGA_VS;
      logic 	VGA_BLANK;
      logic [7:0] VGA_R;
      logic [7:0] VGA_G;
      logic [7:0] VGA_B;
      logic 	VGA_SYNC; 

  DE1_SoC dut
    (
     ///////// clock /////////
     clock_50,

     ///////// hex  /////////
     hex0,
     hex1,
     hex2,
     hex3,
     hex4,
     hex5,

     ///////// key /////////
     key,

     ///////// ledr /////////
     ledr,

     ///////// sw /////////
     sw,

     ///////// VGA  /////////
     VGA_CLK,
     VGA_HS,
     VGA_VS,
     VGA_BLANK,
     VGA_R,
     VGA_G,
     VGA_B,
     VGA_SYNC

     );

    always
    begin
        #10ns
        clock_50 <= !clock_50;
    end

    initial begin
        clock_50 <= 0;
        key <= 4'b0000;
        #100ns
            key <= 4'b1111;
    end


endmodule