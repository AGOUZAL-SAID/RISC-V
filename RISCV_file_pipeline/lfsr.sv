module lfsr(input logic clk,
            input logic reset_n,
            output logic [15:0] randomNumber);

logic [15:0] start_state = 16'hACE1;
logic [15:0] Bit;

always@(posedge clk)
begin
    if (!reset_n) 
        begin
            randomNumber <= start_state;
            Bit <= (((start_state >> 0) ^ (start_state >> 2) ^ (start_state >> 3) ^ (start_state >> 5)) & 16'h1);
        end
    else
        begin
            Bit <= (((randomNumber >> 0) ^ (randomNumber >> 2) ^ (randomNumber >> 3) ^ (randomNumber >> 5)) & 16'h1);
            randomNumber <= ((randomNumber >> 1) | (Bit << 15));
        end
end

endmodule

/*
logic [15:0] randomNumber;
logic [31:0] randomNumber_extended;
assign randomNumber_extended = {16'b0,randomNumber};
lfsr LFSR(.clk(clock_50),
          .reset_n(reset_n),
          .randomNumber(randomNumber));

*/