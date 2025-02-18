module dec7seg(
            input logic [3:0] E,
            output logic [6:0] SevenSeg
        );

always @( *)
        case(E)
          0:  SevenSeg <= 7'b1000000;
          1:  SevenSeg <= 7'b1111001;
          2:  SevenSeg <= 7'b0100100;
          3:  SevenSeg <= 7'b0110000;
          4:  SevenSeg <= 7'b0011001;
          5:  SevenSeg <= 7'b0010010;
          6:  SevenSeg <= 7'b0000010;
          7:  SevenSeg <= 7'b1111000;
          8:  SevenSeg <= 7'b0000000;
          9:  SevenSeg <= 7'b0010000;
          10: SevenSeg <= 7'b0001000;
          11: SevenSeg <= 7'b0000011;
          12: SevenSeg <= 7'b1000110;
          13: SevenSeg <= 7'b0100001;
          14: SevenSeg <= 7'b0000110;
          15: SevenSeg <= 7'b0001110;
        endcase

endmodule

