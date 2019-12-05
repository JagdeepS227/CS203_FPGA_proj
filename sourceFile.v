`timescale 1ns / 1ps


module sevenSegDisp(
   input clk,
   input clr,
   input start,
   input stop,
   input btnU,
   input wire A,B,C,E,F,H,I,J,K,L,O,P,S,U,
   output reg [15:0]led, 
   output reg [6:0] a_to_g,
   output reg [3:0] an,
   output wire dp
    );
    
  reg [25:0] clkdiv = 26'b0;
  wire [3:0] s;
  wire [3:0] s2;
  wire [1:0] c;
  wire [1:0] p;
  reg [3:0] state;
  wire [3:0] aen;
  reg [1:0] mode = 2;
  reg [3:0] rand_num;
  reg [3:0] rand_num2;
  reg [3:0] rand_seed = 4'b0001;
  reg [3:0] rand_seed1 = 4'b0011;
  reg [3:0] rand_seed2 = 4'b0111;
  reg [3:0] rand_seed3 = 4'b0101;
  reg [2:0] score = 4'b000;
  reg counted =0;
        
  assign dp = 1;
  assign p = clkdiv[19:18];
  assign s = rand_num[3:0];
  assign s2 = rand_num2[3:0];
  assign c = clkdiv[25:24];
  assign aen = 4'b1111;
        
              
        
  always@(posedge clk) begin
    if(clr==1)begin
       mode <= 2;      // RESET STATE
       score <=0;
    end   
    else if(start==1) begin
       mode <= 1;     // PLAY LVL 2
       score <=0;
    end
    else if(stop==1) begin
       mode <= 0;     // PLAY LVL 3
       score <=0;
     end
    else if(btnU==1 || score >= 3) begin
              mode <= 3;     // GAME END     
    end
  end
       
  always @(*)begin
   if(mode == 1)
     case(s)
       0:state = 0;
       1:state = 1;
       2:state = 2;
       3:state = 3;
       4:state = 4;
       5:state = 5;
       6:state = 6;
       7:state = 7;
       8:state = 8;
       9:state = 9;
       10:state = 10;
       11:state = 11;
       12:state = 12;
       13:state = 13;
       14:state = 14;
       15:state = 15;
     endcase
   else if(mode == 2 )
     case(p)
        0:state = 13;
        1:state = 0;
        2:state = 8;
        3:state = 10;
     endcase
   else if(mode == 3 )
          case(p)
             0:state = 5;
             1:state = 0;
             2:state = 3;
             3:state = 13;
          endcase
   else if(mode == 0)
     case(s2)
        0:state = 0;
        1:state = 1;
        2:state = 2;
        3:state = 3;
        4:state = 4;
        5:state = 5;
        6:state = 6;
        7:state = 7;
        8:state = 8;
        9:state = 9;
        10:state = 10;
        11:state = 11;
        12:state = 12;
        13:state = 13;
        14:state = 14;
        15:state = 15;  
      endcase
    end
      
   always @(*)  begin
      case(state)
         //////////<---MSB-LSB<---
         //////////////gfedcba////////////////////////////////////////////                                                                
         0:a_to_g = 7'b0001000;         //A                                      
         1:a_to_g = 7'b0000000;         //B                                                                                                         
         2:a_to_g = 7'b1000110;         //C                                     
         3:a_to_g = 7'b0000110;         //E   
         4:a_to_g = 7'b0001110;         //F                                      
         5:a_to_g = 7'b0001001;         //H                                                                                                         
         6:a_to_g = 7'b1111001;         //I                                     
         7:a_to_g = 7'b1100001;         //J      
         8:a_to_g = 7'b1000111;         //L                                      
         9:a_to_g = 7'b1000000;         //O                                                                                                         
         10:a_to_g = 7'b0001100;        //P                                     
         11:a_to_g = 7'b0010010;        //S   
         12:a_to_g = 7'b1000001;        //U      
         13:a_to_g = 7'b0010001;        //Y                                 
         14:a_to_g = 7'b0111111;        //-                                            
         15:a_to_g = 7'b0111111;        //-
       default: a_to_g = 7'b0111111;    // U
        
       endcase
   end
      
 always @(*) begin
    if(mode == 2 || mode ==0 || mode == 3)
          begin  
            an=4'b1111;
            an[p]=0;            
           end 
    else if(mode ==1)
       case(c)
            0:an=4'b1110;
            1:an=4'b1101;
            2:an=4'b1011;
            3:an=4'b0111;
            default:an=4'b1111;
       endcase
  end
        
  always @(posedge clk ) begin
     if ( clr == 1)
        clkdiv <= 0;
     else if(start==1)
        begin
            clkdiv=0;     
        end    
     else if(stop==1)
        clkdiv<=0;
      else begin
        clkdiv <= clkdiv+1;
        if(clkdiv==0)begin
            counted=0;
           rand_num <= (rand_num+rand_seed)%14;
           rand_seed1 <= (rand_num+rand_seed)%14;
           rand_seed2 <= (rand_num+rand_seed1)%14;
           rand_seed3 <= (rand_num+rand_seed2)%14;
           if((rand_num+5)<=13)
                rand_seed <= rand_seed+2;
           else
                 rand_num <= (rand_num+rand_seed)%9;  
         end
      end
  end
  
  always@(*)begin
  if(p==0)
   rand_num2 = rand_num;
  else if(p==1)
   rand_num2 = (rand_num+rand_seed1)%14; 
  else if(p==2)
   rand_num2 = (rand_num+rand_seed2)%14;
  else
   rand_num2 = (rand_num+rand_seed3)%14;
  end

 always@(posedge clk) begin 
   if(mode==1  && counted == 0)
     begin
        if(state == 0 && A ==1)
            begin
               score <= score+1;
               counted = 1;
            end
         else if(state == 1 && B ==1)
            begin
               score <= score+1;
            end
         else if (state == 2 && C ==1)
             begin
               score <= score+1;
               counted = 1;
             end
         else if(state == 3 && E ==1)
             begin
               score <= score+1;
             end
         else if (state == 4 && F ==1)
             begin
               score <= score+1;
             end
         else if(state == 5 && H ==1)
             begin
               score <= score+1;
             end
         else if (state == 6 && I ==1)
             begin
               score <= score+1;
             end
         else if(state == 7 && J ==1)
             begin
               score <= score+1;
             end
         else if (state == 8 && L ==1)
             begin
               score <= score+1;
             end
         else if(state == 9 && O ==1)
             begin
               score <= score+1;
             end
         else if (state == 10 && P ==1)
             begin
               score <= score+1;
             end
         else if(state == 11 && S ==1)
             begin
               score <= score+1;
             end
         else if (state == 12 && U == 1)
             begin
               score <= score+1;
             end              
         end
   end
 /*   
    always @(*)begin
        if(score >= 3)
            mode = 3;    
    end
    */
    
    always @(*)begin
    if(mode==3)
    case(clkdiv[25:22])
        0:led = 16'b0000000000000000;
        1:led = 16'b1000000000000001;
        2:led = 16'b1100000000000011;
        3:led = 16'b1110000000000111;
        4:led = 16'b1111000000001111;
        5:led = 16'b1111100000011111;
        6:led = 16'b1111110000111111;
        7:led = 16'b1111111001111111;
        8:led = 16'b1111111111111111;
        9:led = 16'b1111111001111111;
        10:led = 16'b1111110000111111;
        11:led = 16'b1111100000011111;
        12:led = 16'b1111000000001111;
        13:led = 16'b1110000000000111;
        14:led = 16'b1100000000000011;
        15:led = 16'b1000000000000001;
      endcase
    end
    
endmodule
