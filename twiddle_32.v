module twiddle(index_r,w_factor_r,index_i,w_factor_i);

input [4:0] index_r, index_i;
output [35:0] w_factor_r,w_factor_i;
reg [35:0]  w_factor_1_r, w_factor_1_i;
assign w_factor_r = w_factor_1_r;
assign w_factor_i = w_factor_1_i;


always @(*) begin
    case(index_r) // 2 bit intiger 30 bit fraction
0: w_factor_1_r  = 36'h100000000;
1: w_factor_1_r  = 36'h0FB14BE7F;
2: w_factor_1_r  = 36'h0EC835E79;
3: w_factor_1_r  = 36'h0D4DB3148;
4: w_factor_1_r  = 36'h0B504F334;
5: w_factor_1_r  = 36'h08E39D9CD;
6: w_factor_1_r  = 36'h061F78A9A;
7: w_factor_1_r  = 36'h031F17078;
8: w_factor_1_r  = 36'h000000000;
9: w_factor_1_r  = 36'hFCE0E8F87;
10:w_factor_1_r  = 36'hF9E087565;
11:w_factor_1_r  = 36'hF71C62632;
12:w_factor_1_r  = 36'hF4AFB0CCC;
13:w_factor_1_r  = 36'hF2B24CEB7;
14:w_factor_1_r  = 36'hF137CA186;
15:w_factor_1_r  = 36'hF04EB4180;
default : w_factor_1_r = 36'h0;
endcase
    
    
    
    case(index_i)
0: w_factor_1_i  = 36'h000000000;
1: w_factor_1_i  = 36'h031F17078;
2: w_factor_1_i  = 36'h061F78A9A;
3: w_factor_1_i  = 36'h08E39D9CD; 
4: w_factor_1_i  = 36'h0B504F334;
5: w_factor_1_i  = 36'h0D4DB3148; 
6: w_factor_1_i  = 36'h0EC835E79;   
7: w_factor_1_i  = 36'h0FB14BE7F;
8: w_factor_1_i  = 36'h100000000;
9: w_factor_1_i  = 36'h0FB14BE7F;
10:w_factor_1_i  = 36'h0EC835E79;
11:w_factor_1_i  = 36'h0D4DB3148;
12:w_factor_1_i  = 36'h0B504F334;
13:w_factor_1_i  = 36'h08E39D9CD;
14:w_factor_1_i  = 36'h061F78A9A;
15:w_factor_1_i  = 36'h031F17078; 
default : w_factor_1_i = 36'h0;
    endcase
end
endmodule
