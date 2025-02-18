module GPU (input logic  clk,
     input logic    reset_n,
     input logic gpu_enable,
     input logic [31:0] input_address,
     input logic [31:0] input_data,
     output logic [31:0] data_out,
     
	 output logic 	VGA_CLK,
     output logic 	VGA_HS,
     output logic 	VGA_VS,
     output logic 	VGA_BLANK,
     output logic [7:0] VGA_R,
     output logic [7:0] VGA_G,
     output logic [7:0] VGA_B);

 
logic [31:0] rectangle_coord, buffer;
logic [15:0] point_coord;
logic [23:0] color, color_buffer;
//logic [7:0] action, status;
logic DRAW_POINT, DRAW_RECTANGLE, WHITE_BG, IDLE;
//logic init, enable_counter;
logic [7:0] x_counter, y_counter;



always @(*)
begin
    case (input_address[15:0])
        16'h4: data_out <= rectangle_coord;
        16'h8: data_out <= {16'b0, point_coord};
        16'hC: data_out <= {8'b0, color};
        16'h14: data_out <= {31'b0,!IDLE};
        default: data_out <= 0;
    endcase
end


always @(posedge clk)
begin

    if (!reset_n)
    begin
        IDLE <= 1;
        DRAW_POINT <= 0;
        DRAW_RECTANGLE <= 0;
    end

    else
        begin


        if ((input_address[15:0] == 16'h4) && gpu_enable && IDLE)
            rectangle_coord <= input_data;

        if ((input_address[15:0] == 16'h8) && gpu_enable && IDLE)
            point_coord <= input_data[15:0];

        if ((input_address[15:0] == 16'hC) && gpu_enable && IDLE)
            color <= input_data[23:0];

        if ((input_address[15:0] == 16'h10) && gpu_enable && IDLE)
            case(input_data[7:0])
                8'b00: begin WHITE_BG <= 1;
                        IDLE <= 0;
                    end

                8'b01: begin DRAW_POINT <= 1;
                        IDLE <= 0;
                    end

                8'b10: begin DRAW_RECTANGLE <= 1;
                        IDLE <= 0;
                    end

                default : IDLE <= 0;
            endcase
///
        if (IDLE) 
        begin
            x_counter <= rectangle_coord[23:16];
            y_counter <= rectangle_coord[31:24];
        end

//pas utilisé
        if (WHITE_BG)
        begin
            x_counter <= 0;
            y_counter <= 0;
            color_buffer <= color;
            color <= 24'hffffff;
            if (x_counter == 200)
                begin
                    if (y_counter == 150)
                        begin
                            y_counter <= 0;
                            IDLE <= 1; 
                            WHITE_BG <= 0;
                            color <= color_buffer;
                        end
                    else 
                        begin
                            y_counter <= y_counter + 1;
                            x_counter <= 0;
                        end
                end
            else x_counter <= x_counter + 1;     
        end
        
//pas utilisé
        if (DRAW_POINT)
        begin
            if ( (x_counter == point_coord[7:0]) && (y_counter == point_coord[15:8]) )
            begin
                IDLE <= 1;
                DRAW_POINT <= 0;
            end

            else
            begin
                x_counter <= point_coord[7:0];
                y_counter <= point_coord[15:8];
            end
        end


        if (DRAW_RECTANGLE)
        begin
            if (x_counter == (rectangle_coord[7:0]))
                begin
                    if (y_counter == (rectangle_coord[15:8]))
                        begin
                            y_counter <= rectangle_coord[31:24];
                            x_counter <= rectangle_coord[23:16];
                            IDLE <= 1; 
                            DRAW_RECTANGLE <= 0;
                        end
                    else 
                        begin
                            y_counter <= y_counter + 1;
                            x_counter <= rectangle_coord[23:16];
                        end
                end
            else x_counter <= x_counter + 1;
                
        end
    end
end



// Connection au VGA Controller
logic [15:0] xy_addr;
logic fb_enable;

always @(*)
begin
    fb_enable <= (!IDLE);
    if (DRAW_RECTANGLE)
    xy_addr <= {y_counter,x_counter};
    else
    xy_addr <= point_coord[15:0];

end

VGA_controller vga_controller 
    ( 
      .clk(clk),
      .fb_enable(fb_enable), 
      .xy_addr(xy_addr), 
      .color(color),   
      .reset_n(reset_n),
	  .VGA_CLK(VGA_CLK),
      .VGA_HS(VGA_HS),
      .VGA_VS(VGA_VS),
      .VGA_BLANK(VGA_BLANK),
      .VGA_R(VGA_R),
      .VGA_G(VGA_G),
      .VGA_B(VGA_B)
      );



endmodule 
		
