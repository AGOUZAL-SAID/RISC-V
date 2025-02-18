module gene_reset(key, clk, reset_n);
   input  clk;
   input  key;
   output reset_n;

   logic [1:0] R;

   always @(posedge clk or negedge key)
     if(!key)
        R <= '0;
     else
        R <= {R[0],1'b1};

   assign reset_n = R[1];

endmodule
