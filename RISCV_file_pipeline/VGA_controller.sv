module VGA_controller(input logic  clk,
     input logic fb_enable,
     input logic [15:0] xy_addr,
     input logic [23:0] color,
     input logic    reset_n,
	 output logic 	VGA_CLK,
     output logic 	VGA_HS,
     output logic 	VGA_VS,
     output logic 	VGA_BLANK,
     output logic [7:0] VGA_R,
     output logic [7:0] VGA_G,
     output logic [7:0] VGA_B);

 


assign VGA_CLK = clk;
logic [10:0] pos_h, pos_v;
logic [7:0] pos_x, pos_y;
logic [23:0] VGA_color;
logic hsync, vsync, blank;
assign VGA_HS = hsync;
assign VGA_VS = vsync;
assign VGA_BLANK = blank;



always @(posedge clk)
begin
  if (!reset_n)
    begin
        pos_h <= 0;
        pos_v <= 0;
        pos_x <= 0; 
        pos_y <= 0;
        hsync <= 1; 
        vsync <= 1; 
        blank <= 0;
    end

  else
  begin
  pos_h <= pos_h + 1;

  if(pos_h==1040) 
  begin
    pos_h <= 0;
    hsync <= 1;
    pos_v <= pos_v + 1;
  end
  
  if (pos_h>=65 & pos_h<=864)
  begin

    if (pos_v>=23 & pos_v<=622) blank <= 1;

    pos_x <= (pos_h - 65) >> 2;
    pos_y <= (pos_v - 23) >> 2;

  end

  if(pos_h==865) blank <= 0;
  if(pos_h==920) hsync <= 0;
  if(pos_v==660) vsync <= 0;
  if(pos_v==666) 
  begin
    pos_v <= 0;
    vsync <= 1;
  end

  end
end


true_dual_port_ram_single_clock #(.DATA_WIDTH(24), .ADDR_WIDTH(16)) framebuffer (.data_a(color), .addr_a(xy_addr), .we_a(fb_enable), 
                                                                                   .addr_b({pos_y,pos_x}), .we_b(0), .q_b(VGA_color), .clk(clk) );
                                                                                   

always @(*)
begin
    VGA_R <= VGA_color[7:0];
    VGA_G <= VGA_color[15:8];
    VGA_B <= VGA_color[23:16];
end

endmodule 
		
