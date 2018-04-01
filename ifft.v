// HISTORY    : VERSION-1 : INVERSE FAST FOURIER TRANSFORM
// AUTHORS    : PRAVEEN, HARIKA  



module ifft (clk,rst,pushin,dir,dii,pushout,dor,doi);

parameter width36 = 36;
parameter width32 = 31;
parameter width72 = 72;
parameter width28 = 27;
parameter width37 = 36;



input  clk,rst;
input [27:0] dir,dii;
input  pushin;
output [27:0] dor,doi;
output pushout;





reg pushout_1;

reg start;
reg [27:0] dor_1,doi_1;
reg [5:0]count,countm,count44,count4;

reg [20:0]inp_states,states,state,op_states;
reg [4:0]stage,stage_op,stage_op_nxt,stage_1,push_states,push_state;

wire [4:0]rd_cntr_r,wr_cntr_r; 
wire [4:0]rd_cntr_i,wr_cntr_i;


wire full_real,full_imag;
wire empty_real,empty_imag;
reg write_real,write_imag;


reg [4:0]rd_cntr_real_w,wr_cntr_real_r,rd_cntr_real_1,rd_cntr_real_2,rd_cntr_real_op; 
reg [4:0]rd_cntr_imag_w,wr_cntr_imag_r,rd_cntr_imag_1,rd_cntr_imag_2,rd_cntr_imag_op; 

reg [4:0]rd_cntr_real,wr_cntr_real; 
reg [4:0]rd_cntr_imag,wr_cntr_imag; 


reg [27:0]real_op[width32:0];
reg [27:0]imag_op[width32:0];

reg [width36:0]memreal[width32:0];
reg [width36:0]memimag[width32:0];

reg [width36:0]memreal_op_1[width32:0];
reg [width36:0]memreal_op_11[width32:0];

reg [width36:0]memimag_op_1[width32:0];
reg [width36:0]memimag_op_11[width32:0];


reg [width36:0]memreal_op_2[width32:0];
reg [width36:0]memreal_op_22[width32:0];

reg [width36:0]memimag_op_2[width32:0];
reg [width36:0]memimag_op_22[width32:0];

reg [width36:0]memreal_op_3[width32:0];
reg [width36:0]memreal_op_33[width32:0];

reg [width36:0]memimag_op_3[width32:0];
reg [width36:0]memimag_op_33[width32:0];

reg [width36:0]memreal_op_4[width32:0];
reg [width36:0]memreal_op_44[width32:0];

reg [width36:0]memimag_op_4[width32:0];
reg [width36:0]memimag_op_44[width32:0];


reg [width28:0]memreal_op_5[width32:0];
reg [width28:0]memreal_op_55[width32:0];

reg [width28:0]memimag_op_5[width32:0];
reg [width28:0]memimag_op_55[width32:0];


//mem32x64 memreal1(clk,wr_cntr_r,real_write_data,write_real,rd_cntr_real,real_read_data);
//mem32x64 memimag1(clk,wr_cntr_i,imag_write_data,write_imag,rd_cntr_imag,imag_read_data);
//reg [4:0]rd_cntr_real_w,wr_cntr_real_r,rd_cntr_real_1,rd_cntr_real_2,rd_cntr_real_op;
//reg [4:0]rd_cntr_imag_w,wr_cntr_imag_r,rd_cntr_imag_1,rd_cntr_imag_2,rd_cntr_imag_op;

//reg [4:0]rd_cntr_real,wr_cntr_real;
//reg [4:0]rd_cntr_imag,wr_cntr_imag;


reg  [width36:0]A_real,AA_real;
reg  [width36:0]A_imag,AA_imag;
reg  [width36:0]B_real,BB_real;
reg  [width36:0]B_imag,BB_imag;
wire  [35:0]twiddle_real;
wire  [35:0]twiddle_imag; 
wire [width36:0]C_real;
wire [width36:0]C_imag;
reg [width36:0]CC_real;
reg [width36:0]CC_imag;
wire [72:0]D_real;
wire [72:0]D_imag;
reg [72:0]DD_real;
reg [72:0]DD_imag;

reg push; 
wire pout;


reg [4:0]index_r,index_rr;
reg [4:0]index_i,index_ii;
wire [35:0]w_factor_r,w_factor_i;
reg [35:0]w_factor_rr,w_factor_ii;
reg rst_1,push_1;



// BUTTERFLY AND TWIDDLE MODULES

butterfly bf(AA_real, AA_imag, BB_real, BB_imag, twiddle_real, twiddle_imag, clk, rst, push_1, C_real,C_imag,D_real,D_imag,pout);
twiddle m1(index_rr,w_factor_r,index_ii,w_factor_i);


assign twiddle_real = w_factor_r;
assign twiddle_imag = w_factor_i;

assign pushout = pushout_1;
assign dor     = dor_1;
assign doi     = doi_1;




// REAL INPUTS

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        wr_cntr_real <= 4'd0;
//	rd_cntr_real <= 0;
    end
    else if (pushin)
	begin
	if(dir[27] == 1)
	begin
        wr_cntr_real        		 <= wr_cntr_real + 1'b1;
        memreal[wr_cntr_real]		 <= {5'b11111,dir,4'b0000};	 	
	//$display("mem loc= %d  mem data = %h",wr_cntr_real,memreal[wr_cntr_real]);	
	end
	else
	begin
        wr_cntr_real        		 <= wr_cntr_real + 1'b1;
        memreal[wr_cntr_real]		 <= {5'b00000,dir,4'b0000};	 	
	end
	end
    else
	begin
	write_real 	   <= 1'b0;
        wr_cntr_real       <= wr_cntr_real;
	end
end





// IMAGAGINARY INPUTS 

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        wr_cntr_imag <= 4'd0;
//        rd_cntr_imag <= 0;
    end
    else if (pushin) begin
	if(dii[27] == 1)
	begin
        wr_cntr_imag                     <= wr_cntr_imag + 1'b1;
        memimag[wr_cntr_imag]	         <= {5'b11111,dii,4'b0000};
        //$display("mem loc= %d  mem data = %h",wr_cntr_real,memimag[wr_cntr_imag]);
        end
	else
	begin
        wr_cntr_imag                     <= wr_cntr_imag + 1'b1;
        memimag[wr_cntr_imag]	         <= {5'b00000,dii,4'b0000};
	end
	end	
    else begin
        wr_cntr_imag       <= wr_cntr_imag;
    end
end



// STATE MACHINE TO GIVE INPUTS TO BUTTERFLY MODULE


always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
    stage      <= 0;
	inp_states <= 0;
w_factor_rr    <= 0;
w_factor_ii    <= 0;
rst_1          <= 0;
index_ii       <= 0;
index_rr       <= 0;
push_1	       <= 0;
AA_real        <= 0;
BB_real        <= 0;
AA_imag        <= 0;
BB_imag        <= 0;

	end		
	else
	begin
  	stage	   <= stage_1;			
	inp_states <= states; 
	AA_real    <= A_real;
	BB_real    <= B_real;
	AA_imag    <= A_imag;
	BB_imag    <= B_imag;
	w_factor_rr <= w_factor_r;
	w_factor_ii <= w_factor_i;
	index_rr    <= index_r;
	index_ii    <= index_i;	
	push_1     <= push;
	rst_1      <= rst;
	end
end

always @(*)
begin
stage_1        = stage;
push	       = push_1;
index_i        = index_ii;
index_r        = index_rr;
states         = inp_states;
A_real         = 0;
A_imag         = 0;
B_real         = 0; 
B_imag         = 0;
//w_factor_r     = w_factor_rr;
//w_factor_i     = w_factor_ii;


	case(inp_states)
	0:
		case(stage)
                0:	
                        if((wr_cntr_imag == 31) && (wr_cntr_real == 31))
                        begin
                                A_real         =   memreal[5'd0]; 
                                B_real         =   memreal[5'd16];
                                A_imag         =   memimag[5'd0]; 
                                B_imag         =   memimag[5'd16];
                                index_r        =   5'd0;	 			
                                index_i        =   5'd0;
                                states         =   1;
                                push           =   1'b1;	
                                

                    
                                
                        end
                        else
                        begin
                                       states  =   0;	
                                       stage_1 =   0;
                                A_real         =   0;
                                B_real         =   0;
                                A_imag         =   0;
                                B_imag         =   0;
                                push           =   0;
                                index_i        =   0;
                                index_r        =   0;

                        end

                1:
                        begin
                                A_real         =   memreal_op_1[5'd0];
                                B_real         =   memreal_op_1[5'd8];
                                A_imag         =   memimag_op_1[5'd0];
                                B_imag         =   memimag_op_1[5'd8];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   1;
                                rd_cntr_imag_2 =   rd_cntr_imag_op + 2;
                                rd_cntr_real_2 =   rd_cntr_real_op + 2;

                        end

		
                2:
                        begin
                                A_real         =   memreal_op_2[5'd0];
                                B_real         =   memreal_op_2[5'd4];
                                A_imag         =   memimag_op_2[5'd0];
                                B_imag         =   memimag_op_2[5'd4];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   1;
                                rd_cntr_imag_2 =   rd_cntr_imag_op + 2; 
                                rd_cntr_real_2 =   rd_cntr_real_op + 2;

                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd0];
                                B_real         =   memreal_op_3[5'd2];
                                A_imag         =   memimag_op_3[5'd0];
                                B_imag         =   memimag_op_3[5'd2];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   1;
                                
                                

                        end

                4:
                        begin
                                A_real         =   memreal_op_4[5'd0];
                                B_real         =   memreal_op_4[5'd1];
                                A_imag         =   memimag_op_4[5'd0];
                                B_imag         =   memimag_op_4[5'd1];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   1;
                                
                                

                        end
                default: stage_1 = 0;
                endcase
			
	1:
		begin
		
               case(stage)
               0:	
                        begin	
                                A_real  =   memreal[5'd1];
                                B_real  =   memreal[5'd17];
                                A_imag  =   memimag[5'd1];
                                B_imag  =   memimag[5'd17];
                                index_r =   5'd1;
                                index_i =   5'd1;
                                states  =   2;
                                
                                
                                states  = 2;
                        end

                1:
                        begin
                                A_real         =   memreal_op_1[5'd1];
                                B_real         =   memreal_op_1[5'd9];
                                A_imag         =   memimag_op_1[5'd1];
                                B_imag         =   memimag_op_1[5'd9];
                                index_r        =   5'd2;
                                index_i        =   5'd2;    
                                states         =   2;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd1];
                                B_real         =   memreal_op_2[5'd5];
                                A_imag         =   memimag_op_2[5'd1];
                                B_imag         =   memimag_op_2[5'd5];
                                index_r        =   5'd4;
                                index_i        =   5'd4;
                                states         =   2;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd1];
                                B_real         =   memreal_op_3[5'd3];
                                A_imag         =   memimag_op_3[5'd1];
                                B_imag         =   memimag_op_3[5'd3];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   2;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd2];
                                B_real         =   memreal_op_4[5'd3];
                                A_imag         =   memimag_op_4[5'd2];
                                B_imag         =   memimag_op_4[5'd3];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   2;
                                
                                
                        end

                default: stage_1 = 0;
                endcase
		end	


	2:
		begin

                case(stage)   
                0:
                        begin
                                A_real         =   memreal[5'd2];
                                B_real         =   memreal[5'd18];
                                A_imag         =   memimag[5'd2];
                                B_imag         =   memimag[5'd18];
                                index_r        =   5'd2;
                                index_i        =   5'd2;
                                states         =   3;
                                
                                
                        end


                1:
                        begin
                                A_real         =   memreal_op_1[5'd2];
                                B_real         =   memreal_op_1[5'd10];
                                A_imag         =   memimag_op_1[5'd2];
                                B_imag         =   memimag_op_1[5'd10];
                                index_r        =   5'd4;
                                index_i        =   5'd4;
                                states         =   3;
                                
                                
                        end
                2:
                        begin
                                A_real         =   memreal_op_2[5'd2];
                                B_real         =   memreal_op_2[5'd6];
                                A_imag         =   memimag_op_2[5'd2];
                                B_imag         =   memimag_op_2[5'd6];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   3;
                                
                                
                        end
                3:
                        begin
                                A_real         =   memreal_op_3[5'd4];
                                B_real         =   memreal_op_3[5'd6];
                                A_imag         =   memimag_op_3[5'd4];
                                B_imag         =   memimag_op_3[5'd6];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   3;
                                
                                
                        end
                4:
                        begin
                                A_real         =   memreal_op_4[5'd4];
                                B_real         =   memreal_op_4[5'd5];
                                A_imag         =   memimag_op_4[5'd4];
                                B_imag         =   memimag_op_4[5'd5];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   3;
                                
                                
                        end

                default: stage_1 = 0;
                endcase

		end

	3:
		begin
		
                case(stage)
                0:
                        begin
                                A_real         =   memreal[5'd3];
                                B_real         =   memreal[5'd19];
                                A_imag         =   memimag[5'd3];
                                B_imag         =   memimag[5'd19];
                                index_r        =   5'd3;
                                index_i        =   5'd3;
                                states 	       =   4;
                                
                                
                        end

                1:
                        begin
                                A_real         =   memreal_op_1[5'd3];
                                B_real         =   memreal_op_1[5'd11];
                                A_imag         =   memimag_op_1[5'd3];
                                B_imag         =   memimag_op_1[5'd11];
                                index_r        =   5'd6;
                                index_i        =   5'd6;
                                states         =   4;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd3];
                                B_real         =   memreal_op_2[5'd7];
                                A_imag         =   memimag_op_2[5'd3];
                                B_imag         =   memimag_op_2[5'd7];
                                index_r        =   5'd12;
                                index_i        =   5'd12;
                                states         =   4;
                                
                                
                        end
                3:
                        begin
                                A_real         =   memreal_op_3[5'd5];
                                B_real         =   memreal_op_3[5'd7];
                                A_imag         =   memimag_op_3[5'd5];
                                B_imag         =   memimag_op_3[5'd7];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   4;
                                
                                
                        end
                4:
                        begin
                                A_real         =   memreal_op_4[5'd6];
                                B_real         =   memreal_op_4[5'd7];
                                A_imag         =   memimag_op_4[5'd6];
                                B_imag         =   memimag_op_4[5'd7];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   4;
                                
                                
                        end

                default: stage_1 = 0;
                endcase

		end

	4:
		begin
		
                case(stage)
                0:
                        begin
                                A_real         =   memreal[5'd4];
                                B_real         =   memreal[5'd20];
                                A_imag         =   memimag[5'd4];
                                B_imag         =   memimag[5'd20];
                                index_r        =   5'd4;
                                index_i        =   5'd4;
                                states         =   5;
                                
                                
                        end

	        1:
                        begin
                                A_real         =   memreal_op_1[5'd4];
                                B_real         =   memreal_op_1[5'd12];
                                A_imag         =   memimag_op_1[5'd4];
                                B_imag         =   memimag_op_1[5'd12];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   5;
                                
                                
                        end
                2:
                        begin
                                A_real         =   memreal_op_2[5'd8];
                                B_real         =   memreal_op_2[5'd12];
                                A_imag         =   memimag_op_2[5'd8];
                                B_imag         =   memimag_op_2[5'd12];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   5;
                                
                                
                        end
                3:
                        begin
                                A_real         =   memreal_op_3[5'd8];
                                B_real         =   memreal_op_3[5'd10];
                                A_imag         =   memimag_op_3[5'd8];
                                B_imag         =   memimag_op_3[5'd10];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   5;
                                
                                
                        end
                4:
                        begin
                                A_real         =   memreal_op_4[5'd8];
                                B_real         =   memreal_op_4[5'd9];
                                A_imag         =   memimag_op_4[5'd8];
                                B_imag         =   memimag_op_4[5'd9];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   5;
                                
                                
                        end

                default: stage_1 = 0;
                endcase

		end

        5:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd5];
                                B_real         =   memreal[5'd21];
                                A_imag         =   memimag[5'd5];
                                B_imag         =   memimag[5'd21];
                                index_r        =   5'd5;
                                index_i        =   5'd5;
                                states         =   6;
                                
                                
                        end
			
                1:
                        begin
                                A_real         =   memreal_op_1[5'd5];
                                B_real         =   memreal_op_1[5'd13];
                                A_imag         =   memimag_op_1[5'd5];
                                B_imag         =   memimag_op_1[5'd13];
                                index_r        =   5'd10;
                                index_i        =   5'd10;
                                states         =   6;
                                
                                
                        end
                2:
                        begin
                                A_real         =   memreal_op_2[5'd9];
                                B_real         =   memreal_op_2[5'd13];
                                A_imag         =   memimag_op_2[5'd9];
                                B_imag         =   memimag_op_2[5'd13];
                                index_r        =   5'd4;
                                index_i        =   5'd4;
                                states         =   6;
                                
                                
                        end
                3:
                        begin
                                A_real         =   memreal_op_3[5'd9];
                                B_real         =   memreal_op_3[5'd11];
                                A_imag         =   memimag_op_3[5'd9];
                                B_imag         =   memimag_op_3[5'd11];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   6;
                                
                                
                        end
                4:
                        begin
                                A_real         =   memreal_op_4[5'd10];
                                B_real         =   memreal_op_4[5'd11];
                                A_imag         =   memimag_op_4[5'd10];
                                B_imag         =   memimag_op_4[5'd11];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   6;
                                
                                
                        end

                default: stage_1 = 0;
                endcase


                end

        6:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd6];
                                B_real         =   memreal[5'd22];
                                A_imag         =   memimag[5'd6];
                                B_imag         =   memimag[5'd22];
                                index_r        =   5'd6;
                                index_i        =   5'd6;
                                states         =   7;
                                
                                
                        end
                
                1:
                        begin
                                A_real         =   memreal_op_1[5'd6];
                                B_real         =   memreal_op_1[5'd14];
                                A_imag         =   memimag_op_1[5'd6];
                                B_imag         =   memimag_op_1[5'd14];
                                index_r        =   5'd12;
                                index_i        =   5'd12;
                                states         =   7;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd10];
                                B_real         =   memreal_op_2[5'd14];
                                A_imag         =   memimag_op_2[5'd10];
                                B_imag         =   memimag_op_2[5'd14];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   7;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd12];
                                B_real         =   memreal_op_3[5'd14];
                                A_imag         =   memimag_op_3[5'd12];
                                B_imag         =   memimag_op_3[5'd14];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   7;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd12];
                                B_real         =   memreal_op_4[5'd13];
                                A_imag         =   memimag_op_4[5'd12];
                                B_imag         =   memimag_op_4[5'd13];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   7;
                                
                                
                        end
        
                default: stage_1 = 0;
                endcase
                        
                        
                        
                end


        7:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd7];
                                B_real         =   memreal[5'd23];
                                A_imag         =   memimag[5'd7];
                                B_imag         =   memimag[5'd23];
                                index_r        =   5'd7;
                                index_i        =   5'd7;
                                states         =   8;
                                
                                
                        end
                
                1:
                        begin
                                A_real         =   memreal_op_1[5'd7];
                                B_real         =   memreal_op_1[5'd15];
                                A_imag         =   memimag_op_1[5'd7];
                                B_imag         =   memimag_op_1[5'd15];
                                index_r        =   5'd14;
                                index_i        =   5'd14;
                                states         =   8;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd11];
                                B_real         =   memreal_op_2[5'd15];
                                A_imag         =   memimag_op_2[5'd11];
                                B_imag         =   memimag_op_2[5'd15];
                                index_r        =   5'd12;
                                index_i        =   5'd12;
                                states         =   8;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd13];
                                B_real         =   memreal_op_3[5'd15];
                                A_imag         =   memimag_op_3[5'd13];
                                B_imag         =   memimag_op_3[5'd15];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   8;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd14];
                                B_real         =   memreal_op_4[5'd15];
                                A_imag         =   memimag_op_4[5'd14];
                                B_imag         =   memimag_op_4[5'd15];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   8;
                                
                                
                        end

                default: stage_1 = 0;
                endcase

                        
                        
                end


        8:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd8];
                                B_real         =   memreal[5'd24];
                                A_imag         =   memimag[5'd8];
                                B_imag         =   memimag[5'd24];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   9;
                                
                                
                                $display("first set of inputs 8th one --- %h   \n",memreal[5'd8]);
                        end
                        
                1:
                        begin
                                A_real         =   memreal_op_1[5'd16];
                                B_real         =   memreal_op_1[5'd24];
                                A_imag         =   memimag_op_1[5'd16];
                                B_imag         =   memimag_op_1[5'd24];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   9;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd16];
                                B_real         =   memreal_op_2[5'd20];
                                A_imag         =   memimag_op_2[5'd16];
                                B_imag         =   memimag_op_2[5'd20];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   9;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd16];
                                B_real         =   memreal_op_3[5'd18];
                                A_imag         =   memimag_op_3[5'd16];
                                B_imag         =   memimag_op_3[5'd18];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   9;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd16];
                                B_real         =   memreal_op_4[5'd17];
                                A_imag         =   memimag_op_4[5'd16];
                                B_imag         =   memimag_op_4[5'd17];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   9;
                                
                                
                        end
        
                default: stage_1 = 0;
                endcase
        
        
                end


	9:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd9];
                                B_real         =   memreal[5'd25];
                                A_imag         =   memimag[5'd9];
                                B_imag         =   memimag[5'd25];
                                index_r        =   5'd9;
                                index_i        =   5'd9;
                                states         =   10;
                                
                                
                        end
                        
                1:
                        begin
                                A_real         =   memreal_op_1[5'd17];
                                B_real         =   memreal_op_1[5'd25];
                                A_imag         =   memimag_op_1[5'd17];
                                B_imag         =   memimag_op_1[5'd25];
                                index_r        =   5'd2;
                                index_i        =   5'd2;
                                states         =   10;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd17];
                                B_real         =   memreal_op_2[5'd21];
                                A_imag         =   memimag_op_2[5'd17];
                                B_imag         =   memimag_op_2[5'd21];
                                index_r        =   5'd4;
                                index_i        =   5'd4;
                                states         =   10;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd17];
                                B_real         =   memreal_op_3[5'd19];
                                A_imag         =   memimag_op_3[5'd17];
                                B_imag         =   memimag_op_3[5'd19];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   10;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd18];
                                B_real         =   memreal_op_4[5'd19];
                                A_imag         =   memimag_op_4[5'd18];
                                B_imag         =   memimag_op_4[5'd19];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   10;
                                
                                
                        end
        
                default: stage_1 = 0;
                endcase
                        
                        
                end

	
        10:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd10];
                                B_real         =   memreal[5'd26];
                                A_imag         =   memimag[5'd10];
                                B_imag         =   memimag[5'd26];
                                index_r        =   5'd10;
                                index_i        =   5'd10;
                                states         =   11;
                                
                                
                        end
  
                1:
                        begin
                                A_real         =   memreal_op_1[5'd18];
                                B_real         =   memreal_op_1[5'd26];
                                A_imag         =   memimag_op_1[5'd18];
                                B_imag         =   memimag_op_1[5'd26];
                                index_r        =   5'd4;
                                index_i        =   5'd4;
                                states         =   11;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd18];
                                B_real         =   memreal_op_2[5'd22];
                                A_imag         =   memimag_op_2[5'd18];
                                B_imag         =   memimag_op_2[5'd22];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   11;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd20];
                                B_real         =   memreal_op_3[5'd22];
                                A_imag         =   memimag_op_3[5'd20];
                                B_imag         =   memimag_op_3[5'd22];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   11;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd20];
                                B_real         =   memreal_op_4[5'd21];
                                A_imag         =   memimag_op_4[5'd20];
                                B_imag         =   memimag_op_4[5'd21];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   11;
                                
                                
                        end

                default: stage_1 = 0;
                endcase
                
                
                end

		

        11:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd11];
                                B_real         =   memreal[5'd27];
                                A_imag         =   memimag[5'd11];
                                B_imag         =   memimag[5'd27];
                                index_r        =   5'd11;
                                index_i        =   5'd11;
                                states         =   12;
                                
                                
                        end
                     
                1:
                        begin
                                A_real         =   memreal_op_1[5'd19];
                                B_real         =   memreal_op_1[5'd27];
                                A_imag         =   memimag_op_1[5'd19];
                                B_imag         =   memimag_op_1[5'd27];
                                index_r        =   5'd6;
                                index_i        =   5'd6;
                                states         =   12;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd19];
                                B_real         =   memreal_op_2[5'd23];
                                A_imag         =   memimag_op_2[5'd19];
                                B_imag         =   memimag_op_2[5'd23];
                                index_r        =   5'd12;
                                index_i        =   5'd12;
                                states         =   12;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd21];
                                B_real         =   memreal_op_3[5'd23];
                                A_imag         =   memimag_op_3[5'd21];
                                B_imag         =   memimag_op_3[5'd23];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   12;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd22];
                                B_real         =   memreal_op_4[5'd23];
                                A_imag         =   memimag_op_4[5'd22];
                                B_imag         =   memimag_op_4[5'd23];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   12;
                                
                                
                        end
     
                default: stage_1 = 0;
                endcase
     
                       
                end


        12:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd12];
                                B_real         =   memreal[5'd28];
                                A_imag         =   memimag[5'd12];
                                B_imag         =   memimag[5'd28];
                                index_r        =   5'd12;
                                index_i        =   5'd12;
                                states         =   13;
                                
                                
                        end
                       
               1:
                        begin
                                A_real         =   memreal_op_1[5'd20];
                                B_real         =   memreal_op_1[5'd28];
                                A_imag         =   memimag_op_1[5'd20];
                                B_imag         =   memimag_op_1[5'd28];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   13;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd24];
                                B_real         =   memreal_op_2[5'd28];
                                A_imag         =   memimag_op_2[5'd24];
                                B_imag         =   memimag_op_2[5'd28];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   13;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd24];
                                B_real         =   memreal_op_3[5'd26];
                                A_imag         =   memimag_op_3[5'd24];
                                B_imag         =   memimag_op_3[5'd26];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   13;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd24];
                                B_real         =   memreal_op_4[5'd25];
                                A_imag         =   memimag_op_4[5'd24];
                                B_imag         =   memimag_op_4[5'd25];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   13;
                                
                                
                        end
       
                default: stage_1 = 0;
                endcase       
                       
                end



        13:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd13];
                                B_real         =   memreal[5'd29];
                                A_imag         =   memimag[5'd13];
                                B_imag         =   memimag[5'd29];
                                index_r        =   5'd13;
                                index_i        =   5'd13;
                                states         =   14;
                                
                                
                        end
                
                1:
                        begin
                                A_real         =   memreal_op_1[5'd21];
                                B_real         =   memreal_op_1[5'd29];
                                A_imag         =   memimag_op_1[5'd21];
                                B_imag         =   memimag_op_1[5'd29];
                                index_r        =   5'd10;
                                index_i        =   5'd10;
                                states         =   14;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd25];
                                B_real         =   memreal_op_2[5'd29];
                                A_imag         =   memimag_op_2[5'd25];
                                B_imag         =   memimag_op_2[5'd29];
                                index_r        =   5'd4;
                                index_i        =   5'd4;
                                states         =   14;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd25];
                                B_real         =   memreal_op_3[5'd27];
                                A_imag         =   memimag_op_3[5'd25];
                                B_imag         =   memimag_op_3[5'd27];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   14;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd26];
                                B_real         =   memreal_op_4[5'd27];
                                A_imag         =   memimag_op_4[5'd26];
                                B_imag         =   memimag_op_4[5'd27];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   14;
                                
                                
                        end

                default: stage_1 = 0;
                endcase
                        
                        
                end



        14:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd14];
                                B_real         =   memreal[5'd30];
                                A_imag         =   memimag[5'd14];
                                B_imag         =   memimag[5'd30];
                                index_r        =   5'd14;
                                index_i        =   5'd14;
                                states         =   15;
                                
                                
                        end
                        
                1:
                        begin
                                A_real         =   memreal_op_1[5'd22];
                                B_real         =   memreal_op_1[5'd30];
                                A_imag         =   memimag_op_1[5'd22];
                                B_imag         =   memimag_op_1[5'd30];
                                index_r        =   5'd12;
                                index_i        =   5'd12;
                                states         =   15;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd26];
                                B_real         =   memreal_op_2[5'd30];
                                A_imag         =   memimag_op_2[5'd26];
                                B_imag         =   memimag_op_2[5'd30];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   15;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd28];
                                B_real         =   memreal_op_3[5'd30];
                                A_imag         =   memimag_op_3[5'd28];
                                B_imag         =   memimag_op_3[5'd30];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   15;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd28];
                                B_real         =   memreal_op_4[5'd29];
                                A_imag         =   memimag_op_4[5'd28];
                                B_imag         =   memimag_op_4[5'd29];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   15;
                                
                                
                        end
        
                default: stage_1 = 0;
                endcase

        
                end
	

	
        15:
                begin

                case(stage)     
                0:
                        begin
                                A_real         =   memreal[5'd15];
                                B_real         =   memreal[5'd31];
                                A_imag         =   memimag[5'd15];
                                B_imag         =   memimag[5'd31];
                                index_r        =   5'd15;
                                index_i        =   5'd15;
                                states         =   0;
                                stage_1	       =   1;
                                
                                
                        end
                        
                1:
                        begin
                                A_real         =   memreal_op_1[5'd23];
                                B_real         =   memreal_op_1[5'd31];
                                A_imag         =   memimag_op_1[5'd23];
                                B_imag         =   memimag_op_1[5'd31];
                                index_r        =   5'd14;
                                index_i        =   5'd14;
                                states         =   0;
                                stage_1	       =   2;
                                
                                
                        end


                2:
                        begin
                                A_real         =   memreal_op_2[5'd27];
                                B_real         =   memreal_op_2[5'd31];
                                A_imag         =   memimag_op_2[5'd27];
                                B_imag         =   memimag_op_2[5'd31];
                                index_r        =   5'd12;
                                index_i        =   5'd12;
                                states         =   0;
                                stage_1	       =   3;
                                
                                
                        end

                3:
                        begin
                                A_real         =   memreal_op_3[5'd29];
                                B_real         =   memreal_op_3[5'd31];
                                A_imag         =   memimag_op_3[5'd29];
                                B_imag         =   memimag_op_3[5'd31];
                                index_r        =   5'd8;
                                index_i        =   5'd8;
                                states         =   0;
                                stage_1	       =   4;
                                
                                
                        end
		
                4:
                        begin
                                A_real         =   memreal_op_4[5'd30];
                                B_real         =   memreal_op_4[5'd31];
                                A_imag         =   memimag_op_4[5'd30];
                                B_imag         =   memimag_op_4[5'd31];
                                index_r        =   5'd0;
                                index_i        =   5'd0;
                                states         =   0;
                                stage_1	       =   0;
                                
                                
                        end
        
                default: stage_1 = 0;
                endcase

        
                end






	default: states = 0;
	endcase


end



// STATE MACHINE TO COLLECT THE OUTPUTS OF BUTTERFLY STRUCTURE

reg POUT1;

always @(posedge clk or posedge rst)
begin
if(rst)
begin
DD_real <= 0;
DD_imag <= 0;
POUT1   <= 0;
CC_real <= 0;
CC_imag <= 0;

end
else
begin
POUT1   <= pout;
DD_real <= D_real;
DD_imag <= D_imag;
CC_real <= C_real;
CC_imag <= C_imag;

end
end 








always @(posedge clk or posedge rst)
begin

if(rst)
begin
op_states = 0;
stage_op  = 0;
end
else
begin


case(op_states)

        0:
	    case(stage_op)
                0:

                if(POUT1)
                begin
                op_states =  1;
                memreal_op_1[5'd0]  = CC_real;
                memreal_op_1[5'd16] = DD_real[68:32];
                memimag_op_1[5'd0]  = CC_imag;
                memimag_op_1[5'd16] = DD_imag[68:32];
                $display("first output stage is 0th %h  \n",C_real,);
                end  
                else
                begin
                state = 0;	       
                end	    
                
                1:
                begin
                op_states =  1;
                memreal_op_2[5'd0] = CC_real;
                memreal_op_2[5'd8] = DD_real[68:32];
                memimag_op_2[5'd0] = CC_imag;
                memimag_op_2[5'd8] = DD_imag[68:32];
                end		
	     
                2:
                begin
                op_states =  1;
                memreal_op_3[5'd0] = CC_real;
                memreal_op_3[5'd4] = DD_real[68:32];
                memimag_op_3[5'd0] = CC_imag;
                memimag_op_3[5'd4] = DD_imag[68:32];
                end		

                3:
                begin
                op_states =  1;
                memreal_op_4[5'd0] = CC_real;
                memreal_op_4[5'd2] = DD_real[68:32];
                memimag_op_4[5'd0] = CC_imag;
                memimag_op_4[5'd2] = DD_imag[68:32];
                end			

                4:
                begin
                op_states =  1;
                memreal_op_5[5'd0]  =   CC_real[36:9];
                memimag_op_5[5'd0]  =   CC_imag[36:9];
                
                memreal_op_5[5'd16] = DD_real[68:41];
                memimag_op_5[5'd16] = DD_imag[68:41];
                $display("final first output %h \n",C_imag[36:9]);
               
                end		
                default: stage_op = 0;    
                endcase



        1:    
	    case(stage_op)
                0:
                begin   
                op_states =  2;     
                memreal_op_1[5'd1]  = CC_real;
                memreal_op_1[5'd17] = DD_real[68:32];
                memimag_op_1[5'd1]  = CC_imag;
                memimag_op_1[5'd17] = DD_imag[68:32];
                end

                1:
                begin   
                op_states =  2;     
                memreal_op_2[5'd1] = CC_real;
                memreal_op_2[5'd9] = DD_real[68:32];
                memimag_op_2[5'd1] = CC_imag;
                memimag_op_2[5'd9] = DD_imag[68:32];
                end

                2:	
                begin   
                op_states =  2;     
                memreal_op_3[5'd1] = CC_real;
                memreal_op_3[5'd5] = DD_real[68:32];
                memimag_op_3[5'd1] = CC_imag;
                memimag_op_3[5'd5] = DD_imag[68:32];
                end

                3:	
                begin   
                op_states =  2;     
                memreal_op_4[5'd1] = CC_real;
                memreal_op_4[5'd3] = DD_real[68:32];
                memimag_op_4[5'd1] = CC_imag;
                memimag_op_4[5'd3] = DD_imag[68:32];
                end

                4:
                begin
                op_states =  2;
                memreal_op_5[5'd8]  =   CC_real[36:9];
                memimag_op_5[5'd8]  =   CC_imag[36:9];
                
                memreal_op_5[5'd24] = DD_real[68:41];
                memimag_op_5[5'd24] = DD_imag[68:41];
                end		
                default: stage_op = 0;    
                endcase


        2:
	    case(stage_op)
                0:
                begin
                op_states =  3;
                memreal_op_1[5'd2]  = CC_real;
                memreal_op_1[5'd18] = DD_real[68:32];
                memimag_op_1[5'd2]  = CC_imag;
                memimag_op_1[5'd18] = DD_imag[68:32];
                end 
                
                1:
    	        begin
                op_states =  3;
                memreal_op_2[5'd2]  = CC_real;
                memreal_op_2[5'd10] = DD_real[68:32];
                memimag_op_2[5'd2]  = CC_imag;
                memimag_op_2[5'd10] = DD_imag[68:32];
                end 
    	    
                2:
                begin
                op_states =  3;
                memreal_op_3[5'd2] = CC_real;
                memreal_op_3[5'd6] = DD_real[68:32];
                memimag_op_3[5'd2] = CC_imag;
                memimag_op_3[5'd6] = DD_imag[68:32];
                end 
	
                3:
                begin
                op_states =  3;
                memreal_op_4[5'd4] = CC_real;
                memreal_op_4[5'd6] = DD_real[68:32];
                memimag_op_4[5'd4] = CC_imag;
                memimag_op_4[5'd6] = DD_imag[68:32];
                end 

                4:
                begin
                op_states =  3;
                memreal_op_5[5'd4]  =   CC_real[36:9];
                memimag_op_5[5'd4]  =   CC_imag[36:9];
                
                memreal_op_5[5'd20] = DD_real[68:41];
                memimag_op_5[5'd20] = DD_imag[68:41];
                end		
                default: stage_op = 0;    
                endcase




        3:
	    case(stage_op)
                0:
                begin
                op_states =  4;
                memreal_op_1[5'd3]  = CC_real;
                memreal_op_1[5'd19] = DD_real[68:32];
                memimag_op_1[5'd3]  = CC_imag;
                memimag_op_1[5'd19] = DD_imag[68:32];
                end 

                1:
                begin
                op_states =  4;
                memreal_op_2[5'd3]  = CC_real;
                memreal_op_2[5'd11] = DD_real[68:32];
                memimag_op_2[5'd3]  = CC_imag;
                memimag_op_2[5'd11] = DD_imag[68:32];
                end 

                2:
                begin
                op_states =  4;
                memreal_op_3[5'd3] = CC_real;
                memreal_op_3[5'd7] = DD_real[68:32];
                memimag_op_3[5'd3] = CC_imag;
                memimag_op_3[5'd7] = DD_imag[68:32];
                end 
                
                3:
                begin
                op_states =  4;
                memreal_op_4[5'd5] = CC_real;
                memreal_op_4[5'd7] = DD_real[68:32];
                memimag_op_4[5'd5] = CC_imag;
                memimag_op_4[5'd7] = DD_imag[68:32];
                end 
                

                4:
                begin
                op_states =  4;
                memreal_op_5[5'd12]  =   CC_real[36:9];
                memimag_op_5[5'd12]  =   CC_imag[36:9];
                
                
                memreal_op_5[5'd28] = DD_real[68:41];
                memimag_op_5[5'd28] = DD_imag[68:41];
                
                end		
                default: stage_op = 0;    
                endcase

        4:
           	    case(stage_op)
                0:
           	    begin                
                op_states =  5;
                memreal_op_1[5'd4]  = CC_real;
                memreal_op_1[5'd20] = DD_real[68:32];
                memimag_op_1[5'd4]  = CC_imag;
                memimag_op_1[5'd20] = DD_imag[68:32];
                end 

                1:    
                begin                
                op_states =  5;
                memreal_op_2[5'd4]  = CC_real;
                memreal_op_2[5'd12] = DD_real[68:32];
                memimag_op_2[5'd4]  = CC_imag;
                memimag_op_2[5'd12] = DD_imag[68:32];
                end 
        
                2:
                begin                
                op_states =  5;
                memreal_op_3[5'd8]  = CC_real;
                memreal_op_3[5'd12] = DD_real[68:32];
                memimag_op_3[5'd8]  = CC_imag;
                memimag_op_3[5'd12] = DD_imag[68:32];
                end 
                
                3:
                begin                
                op_states =  5;
                memreal_op_4[5'd8]  = CC_real;
                memreal_op_4[5'd10] = DD_real[68:32];
                memimag_op_4[5'd8]  = CC_imag;
                memimag_op_4[5'd10] = DD_imag[68:32];
                end 

                4:    
                begin                
                op_states =  5;
                memreal_op_5[5'd2]  =   CC_real[36:9];
                memimag_op_5[5'd2]  =   CC_imag[36:9];

                
                memreal_op_5[5'd18] =   DD_real[68:41];
                memimag_op_5[5'd18] =   DD_imag[68:41];
                
                 end 
                default: stage_op = 0;    
                endcase

                
                
        5:  
           	    case(stage_op)
                0:
           	    begin
                op_states =  6;
                memreal_op_1[5'd5]  = CC_real;
                memreal_op_1[5'd21] = DD_real[68:32];
                memimag_op_1[5'd5]  = CC_imag;
                memimag_op_1[5'd21] = DD_imag[68:32];
                end

                1:
           	    begin
                op_states =  6;
                memreal_op_2[5'd5]  = CC_real;
                memreal_op_2[5'd13] = DD_real[68:32];
                memimag_op_2[5'd5]  = CC_imag;
                memimag_op_2[5'd13] = DD_imag[68:32];
                end

                2:
           	    begin
                op_states =  6;
                memreal_op_3[5'd9]  = CC_real;
                memreal_op_3[5'd13] = DD_real[68:32];
                memimag_op_3[5'd9]  = CC_imag;
                memimag_op_3[5'd13] = DD_imag[68:32];
                end

                3:
           	    begin
                op_states =  6;
                memreal_op_4[5'd9]  = CC_real;
                memreal_op_4[5'd11] = DD_real[68:32];
                memimag_op_4[5'd9]  = CC_imag;
                memimag_op_4[5'd11] = DD_imag[68:32];
                end

                4:
                begin
                op_states =  6;
                memreal_op_5[5'd10]  =   CC_real[36:9];
                memimag_op_5[5'd10]  =   CC_imag[36:9];
                
                memreal_op_5[5'd26] = DD_real[68:41];
                memimag_op_5[5'd26] = DD_imag[68:41];
                
                end		
                default: stage_op = 0;    
                endcase
                
                
        6:
           	    case(stage_op)
                0:
                begin
                op_states =  7;
                memreal_op_1[5'd6]  = CC_real;
                memreal_op_1[5'd22] = DD_real[68:32];
                memimag_op_1[5'd6]  = CC_imag;
                memimag_op_1[5'd22] = DD_imag[68:32];
                end 

                1:
                begin
                op_states =  7;
                memreal_op_2[5'd6]  = CC_real;
                memreal_op_2[5'd14] = DD_real[68:32];
                memimag_op_2[5'd6]  = CC_imag;
                memimag_op_2[5'd14] = DD_imag[68:32];
                end 

                2:
                begin
                op_states =  7;
                memreal_op_3[5'd10] = CC_real;
                memreal_op_3[5'd14] = DD_real[68:32];
                memimag_op_3[5'd10] = CC_imag;
                memimag_op_3[5'd14] = DD_imag[68:32];
                end 

                3:
                begin
                op_states =  7;
                memreal_op_4[5'd12] = CC_real;
                memreal_op_4[5'd14] = DD_real[68:32];
                memimag_op_4[5'd12] = CC_imag;
                memimag_op_4[5'd14] = DD_imag[68:32];
                end 

                4:
                begin
                op_states =  7;
                memreal_op_5[5'd6]  =   CC_real[36:9];
                memimag_op_5[5'd6]  =   CC_imag[36:9];
                
                
                memreal_op_5[5'd22] = DD_real[68:41];
                memimag_op_5[5'd22] = DD_imag[68:41];
                
                end		
                default: stage_op = 0;    
                endcase
                
        7:          
           	    case(stage_op)
                0:
                begin
                op_states =  8;
                memreal_op_1[5'd7]  = CC_real;
                memreal_op_1[5'd23] = DD_real[68:32];
                memimag_op_1[5'd7]  = CC_imag;
                memimag_op_1[5'd23] = DD_imag[68:32];
                end 

                1:
                begin
                op_states =  8;
                memreal_op_2[5'd7]  = CC_real;
                memreal_op_2[5'd15] = DD_real[68:32];
                memimag_op_2[5'd7]  = CC_imag;
                memimag_op_2[5'd15] = DD_imag[68:32];
                end 
                
                2:
                begin
                op_states =  8;
                memreal_op_3[5'd11] = CC_real;
                memreal_op_3[5'd15] = DD_real[68:32];
                memimag_op_3[5'd11] = CC_imag;
                memimag_op_3[5'd15] = DD_imag[68:32];
                end 

                3:
                begin
                op_states =  8;
                memreal_op_4[5'd13] = CC_real;
                memreal_op_4[5'd15] = DD_real[68:32];
                memimag_op_4[5'd13] = CC_imag;
                memimag_op_4[5'd15] = DD_imag[68:32];
                end 
    
                4:
                begin
                op_states =  8;
                memreal_op_5[5'd14]  =   CC_real[36:9];
                memimag_op_5[5'd14]  =   CC_imag[36:9];
                
                
                memreal_op_5[5'd30] = DD_real[68:41];
                memimag_op_5[5'd30] = DD_imag[68:41];
                
                end		
                default: stage_op = 0;    
                endcase

    
        8:          
           	    case(stage_op)
                0:
           	    begin
                op_states =  9;
                memreal_op_1[5'd8]  = CC_real;
                memreal_op_1[5'd24] = DD_real[68:32];
                memimag_op_1[5'd8]  = CC_imag;
                memimag_op_1[5'd24] = DD_imag[68:32];
                $display("first stage 8th o/p %h -- %h",C_real,C_imag);
                end 
    
                1:
           	    begin
                op_states =  9;
                memreal_op_2[5'd16] = CC_real;
                memreal_op_2[5'd24] = DD_real[68:32];
                memimag_op_2[5'd16] = CC_imag;
                memimag_op_2[5'd24] = DD_imag[68:32];
                end 
                
                2:
           	    begin
                op_states =  9;
                memreal_op_3[5'd16] = CC_real;
                memreal_op_3[5'd20] = DD_real[68:32];
                memimag_op_3[5'd16] = CC_imag;
                memimag_op_3[5'd20] = DD_imag[68:32];
                end 

                3:
           	    begin
                op_states =  9;
                memreal_op_4[5'd16] = CC_real;
                memreal_op_4[5'd18] = DD_real[68:32];
                memimag_op_4[5'd16] = CC_imag;
                memimag_op_4[5'd18] = DD_imag[68:32];
                end 

                4:
                begin
                op_states =  9;
                memreal_op_5[5'd1]  =   CC_real[36:9];
                memimag_op_5[5'd1]  =   CC_imag[36:9];
//                $display("final first output %h \n",C_imag[36:9]);
                
                
                memreal_op_5[5'd17] = DD_real[68:41];
                memimag_op_5[5'd17] = DD_imag[68:41];
                
                end		
                default: stage_op = 0;    
                endcase
                
        9:          
           	    case(stage_op)
                0:
           	    begin
                op_states =  10;
                memreal_op_1[5'd9] = CC_real;
                memreal_op_1[5'd25] = DD_real[68:32];    
                memimag_op_1[5'd9] = CC_imag;
                memimag_op_1[5'd25] = DD_imag[68:32];
                end 

                1:
           	    begin
                op_states =  10;
                memreal_op_2[5'd17] = CC_real;
                memreal_op_2[5'd25] = DD_real[68:32];
                memimag_op_2[5'd17] = CC_imag;
                memimag_op_2[5'd25] = DD_imag[68:32];
                end 

                2:
           	    begin
                op_states =  10;
                memreal_op_3[5'd17] = CC_real;
                memreal_op_3[5'd21] = DD_real[68:32];
                memimag_op_3[5'd17] = CC_imag;
                memimag_op_3[5'd21] = DD_imag[68:32];
                end 

                3:
           	    begin
                op_states =  10;
                memreal_op_4[5'd17] = CC_real;
                memreal_op_4[5'd19] = DD_real[68:32];
                memimag_op_4[5'd17] = CC_imag;
                memimag_op_4[5'd19] = DD_imag[68:32];
                end 

                4:
                begin
                op_states =  10;
                memreal_op_5[5'd9]  =   CC_real[36:9];
                memimag_op_5[5'd9]  =   CC_imag[36:9];
                
                
                memreal_op_5[5'd25] = DD_real[68:41];
                memimag_op_5[5'd25] = DD_imag[68:41];
                
                end		
                default: stage_op = 0;    
                endcase


        10:          
           	    case(stage_op)
                0:
           	    begin
                op_states =  11;
                memreal_op_1[5'd10] = CC_real;
                memreal_op_1[5'd26] = DD_real[68:32];
                memimag_op_1[5'd10] = CC_imag;
                memimag_op_1[5'd26] = DD_imag[68:32];
                end 

                1:
           	    begin
                op_states =  11;
                memreal_op_2[5'd18] = CC_real;
                memreal_op_2[5'd26] = DD_real[68:32];
                memimag_op_2[5'd18] = CC_imag;
                memimag_op_2[5'd26] = DD_imag[68:32];
                end 

                2:
           	    begin
                op_states =  11;
                memreal_op_3[5'd18] = CC_real;
                memreal_op_3[5'd22] = DD_real[68:32];
                memimag_op_3[5'd18] = CC_imag;
                memimag_op_3[5'd22] = DD_imag[68:32];
                end 

                3:
           	    begin
                op_states =  11;
                memreal_op_4[5'd20] = CC_real;
                memreal_op_4[5'd22] = DD_real[68:32];
                memimag_op_4[5'd20] = CC_imag;
                memimag_op_4[5'd22] = DD_imag[68:32];
                end 

                4:
                begin
                op_states =  11;
                memreal_op_5[5'd5]  =   CC_real[36:9];
                memimag_op_5[5'd5]  =   CC_imag[36:9];
                
                memreal_op_5[5'd21] = DD_real[68:41];
                memimag_op_5[5'd21] = DD_imag[68:41];
                
                $display("5th output is %h",memreal_op_5[5'd5] );
                $display("5th output is %h",memimag_op_5[5'd5] );
                
                
                
                end		
                default: stage_op = 0;    
                endcase

       11:          
           	    case(stage_op)
                0:
           	    begin
                op_states =  12;
                memreal_op_1[5'd11] = CC_real;
                memreal_op_1[5'd27] = DD_real[68:32];
                memimag_op_1[5'd11] = CC_imag;
                memimag_op_1[5'd27] = DD_imag[68:32];
                end 

                1:
           	    begin
                op_states =  12;
                memreal_op_2[5'd19] = CC_real;
                memreal_op_2[5'd27] = DD_real[68:32];
                memimag_op_2[5'd19] = CC_imag;
                memimag_op_2[5'd27] = DD_imag[68:32];
                end 

                2:
           	    begin
                op_states =  12;
                memreal_op_3[5'd19] = CC_real;
                memreal_op_3[5'd23] = DD_real[68:32];
                memimag_op_3[5'd19] = CC_imag;
                memimag_op_3[5'd23] = DD_imag[68:32];
                end 

                3:
           	    begin
                op_states =  12;
                memreal_op_4[5'd21] = CC_real;
                memreal_op_4[5'd23] = DD_real[68:32];
                memimag_op_4[5'd21] = CC_imag;
                memimag_op_4[5'd23] = DD_imag[68:32];
                end 

                4:
                begin
                op_states =  12;
                memreal_op_5[5'd13]  =   CC_real[36:9];
                memimag_op_5[5'd13]  =   CC_imag[36:9];
                
                
                memreal_op_5[5'd29] = DD_real[68:41];
                memimag_op_5[5'd29] = DD_imag[68:41];

                end		
                default: stage_op = 0;    
                endcase
    
       12:          
           	    case(stage_op)
                0:
           	    begin
                op_states =  13;
                memreal_op_1[5'd12] = CC_real;
                memreal_op_1[5'd28] = DD_real[68:32];
                memimag_op_1[5'd12] = CC_imag;
                memimag_op_1[5'd28] = DD_imag[68:32];
                end 

                1:
           	    begin
                op_states =  13;
                memreal_op_2[5'd20] = CC_real;
                memreal_op_2[5'd28] = DD_real[68:32];
                memimag_op_2[5'd20] = CC_imag;
                memimag_op_2[5'd28] = DD_imag[68:32];
                end 

                2:
           	    begin
                op_states =  13;
                memreal_op_3[5'd24] = CC_real;
                memreal_op_3[5'd28] = DD_real[68:32];
                memimag_op_3[5'd24] = CC_imag;
                memimag_op_3[5'd28] = DD_imag[68:32];
                end 

                3:
           	    begin
                op_states =  13;
                memreal_op_4[5'd24] = CC_real;
                memreal_op_4[5'd26] = DD_real[68:32];
                memimag_op_4[5'd24] = CC_imag;
                memimag_op_4[5'd26] = DD_imag[68:32];
                end 

                4:
           	    begin
                op_states =  13;
                memreal_op_5[5'd3]  =   CC_real[36:9];
                memimag_op_5[5'd3]  =   CC_imag[36:9];

                memreal_op_5[5'd19] = DD_real[68:41];
                memimag_op_5[5'd19] = DD_imag[68:41];

                end 
                default: stage_op = 0;    
                endcase
  
       13:          
           	    case(stage_op)
                0:
           	    begin
                op_states =  14;
                memreal_op_1[5'd13] = CC_real;
                memreal_op_1[5'd29] = DD_real[68:32];
                memimag_op_1[5'd13] = CC_imag;
                memimag_op_1[5'd29] = DD_imag[68:32];
                end 

                1:
           	    begin
                op_states =  14;
                memreal_op_2[5'd21] = CC_real;
                memreal_op_2[5'd29] = DD_real[68:32];
                memimag_op_2[5'd21] = CC_imag;
                memimag_op_2[5'd29] = DD_imag[68:32];
                end 

                2:
           	    begin
                op_states =  14;
                memreal_op_3[5'd25] = CC_real;
                memreal_op_3[5'd29] = DD_real[68:32];
                memimag_op_3[5'd25] = CC_imag;
                memimag_op_3[5'd29] = DD_imag[68:32];
                end 

                3:
           	    begin
                op_states =  14;
                memreal_op_4[5'd25] = CC_real;
                memreal_op_4[5'd27] = DD_real[68:32];
                memimag_op_4[5'd25] = CC_imag;
                memimag_op_4[5'd27] = DD_imag[68:32];
                end 

                4:
                begin
                op_states =  14;
                memreal_op_5[5'd11]  =   CC_real[36:9];
                memimag_op_5[5'd11]  =   CC_imag[36:9];
                
                
                memreal_op_5[5'd27] = DD_real[68:41];
                memimag_op_5[5'd27] = DD_imag[68:41];
                
                end		
                default: stage_op = 0;    
                endcase
    
       14:          
           	    case(stage_op)
                0:
           	    begin
                op_states =  15;
                memreal_op_1[5'd14] = CC_real;
                memreal_op_1[5'd30] = DD_real[68:32];
                memimag_op_1[5'd14] = CC_imag;
                memimag_op_1[5'd30] = DD_imag[68:32];
                end 

                1:
           	    begin
                op_states =  15;
                memreal_op_2[5'd22] = CC_real;
                memreal_op_2[5'd30] = DD_real[68:32];
                memimag_op_2[5'd22] = CC_imag;
                memimag_op_2[5'd30] = DD_imag[68:32];
                end 

                2:
           	    begin
                op_states =  15;
                memreal_op_3[5'd26] = CC_real;
                memreal_op_3[5'd30] = DD_real[68:32];
                memimag_op_3[5'd26] = CC_imag;
                memimag_op_3[5'd30] = DD_imag[68:32];
                end 

                3:
           	    begin
                op_states =  15;
                memreal_op_4[5'd28] = CC_real;
                memreal_op_4[5'd30] = DD_real[68:32];
                memimag_op_4[5'd28] = CC_imag;
                memimag_op_4[5'd30] = DD_imag[68:32];
                end 

                4:
                begin
                op_states =  15;
                memreal_op_5[5'd7]  =   CC_real[36:9];
                memimag_op_5[5'd7]  =   CC_imag[36:9];
                
                
                memreal_op_5[5'd23] = DD_real[68:41];
                memimag_op_5[5'd23] = DD_imag[68:41];
                
                end		
                default: stage_op = 0;    
                endcase
    
       15:          
           	    case(stage_op)
                0:
           	    begin
                op_states =  0;
                stage_op = 1;
                memreal_op_1[5'd15] = CC_real;
                memreal_op_1[5'd31] = DD_real[68:32];
                memimag_op_1[5'd15] = CC_imag;
                memimag_op_1[5'd31] = DD_imag[68:32];
                end 

                1:
           	    begin
                op_states =  0;
                stage_op = 2;
                memreal_op_2[5'd23] = CC_real;
                memreal_op_2[5'd31] = DD_real[68:32];
                memimag_op_2[5'd23] = CC_imag;
                memimag_op_2[5'd31] = DD_imag[68:32];
                end 

                2:
           	    begin
                op_states =  0;
                stage_op = 3;
                memreal_op_3[5'd27] = CC_real;
                memreal_op_3[5'd31] = DD_real[68:32];
                memimag_op_3[5'd27] = CC_imag;
                memimag_op_3[5'd31] = DD_imag[68:32];
                end 

                3:
           	    begin
                op_states =  0;
                stage_op = 4;
                memreal_op_4[5'd29] = CC_real;
                memreal_op_4[5'd31] = DD_real[68:32];
                memimag_op_4[5'd29] = CC_imag;
                memimag_op_4[5'd31] = DD_imag[68:32];
                end 

                4:
                begin
                op_states =  0;
                stage_op = 0;

                memreal_op_5[5'd15]  =   CC_real[36:9];
                memimag_op_5[5'd15]  =   CC_imag[36:9];
                
                
                memreal_op_5[5'd31] = DD_real[68:41];
                memimag_op_5[5'd31] = DD_imag[68:41];
                
                end		
                default: stage_op = 0;    
                endcase
  default: state = 0;
  endcase
end   
end

 

///  state machine to push the final output

always @(posedge clk)
if(rst)
begin
push_states <= 0;
count4      <= 0;
end
else
begin
push_states <= push_state;
count4 <= count44;	
end


reg [4:0] final_states,final_state;



always @(posedge clk or posedge rst)
begin
//countm <= count;
if(rst)
begin
count <= 0;
dor_1 <= 0;
doi_1 <= 0;
pushout_1 <= 0;
final_states <= 0;


end
else
begin
		
		case(final_states)

		0:
		       if((op_states == 15) && (stage_op == 4))
			begin
				if(count < 32)
				begin
				final_states <= #1  1;	
                pushout_1    <= #1  1;
				count        <= #1  count + 1;
				dor_1        <= #1  memreal_op_5[count];
				doi_1        <= #1  memimag_op_5[count];
				end
				else
				begin
				final_states <= #1 0;	
				pushout_1    <= #1 0;	
				count        <= #1 0;
				dor_1        <= #1 0;
				doi_1        <= #1 0;	
				end	
			end			
			else
			begin
				final_states <= #1 0;	
				pushout_1    <= #1 0;	
				count        <= #1 0;
				dor_1        <= #1 0;
				doi_1        <= #1 0;	
			end	

		1:	
				if(count < 32)
				begin
				final_states <= #1  1;
		        pushout_1    <= #1  1;
				count        <= #1  count + 1;
				dor_1        <= #1  memreal_op_5[count];
				doi_1        <= #1  memimag_op_5[count];
				end
				else
				begin
                        final_states <= #1 0;
		                pushout_1    <= #1 0;
                		count        <= #1 0;
		                dor_1        <= #1 0;
		                doi_1        <= #1 0;
				end

		default: final_states <= 0;	
		endcase
end

end




endmodule

