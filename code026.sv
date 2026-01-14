// Design Code
module dff (input d,  
              input rstn,  
              input clk,  
              output q, qbar);  
  
    reg temp_q    = 0;
    reg temp_qbar = 1;
  
  
   always @ (posedge clk)  
    begin      
      if (!rstn) 
        begin 
          
          temp_q    <= 1'b0;
          temp_qbar <= 1'b1;
        end
       else 
         begin
          temp_q    <= d; 
          temp_qbar <= ~d;
         end
    end
 
  ////////////////////////////////////////
    always@(posedge clk)
    begin
      A1: assert (temp_q == ~temp_qbar) $info("Suc at %0t",$time);  else $info("Error at %0t", $time);
    end
    
   assign q    = temp_q;
   assign qbar = temp_qbar;
  
endmodule 
 

// Testbench

module tb;
  reg d = 0;
  reg clk = 0;
  reg rstn = 0;
  wire q, qbar;
  
  dff dut (d,rstn, clk, q, qbar);
  
  always #5 clk = ~clk;
  
  always #13 d = ~d;
  
  initial begin
    rstn = 0;
    #30;
    rstn = 1;
  end
  
    initial begin 
    #200;
    $finish();
  end
   
endmodule