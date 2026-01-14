module tb;
 
  
  reg clk = 0;
  reg rst = 0;
  
  integer i = 0;
  
  
  integer count = 0;
  int rst_count = 0;
   
  
  initial begin
    rst = 1;
    #30;
    rst = 0;
  end
  
  always #5 clk =~clk;
  
 
////////////////Verilog
 
 
 
  task countrst();
    
          @(posedge clk);
          
          for(int j = 0; j < 3 ; j++)
             begin
               if(rst)
                 rst_count++;
                 @(posedge clk);
             end
          
           for(int i = 0; i< 16; i++)
              begin
               if(rst)
                count++;
                @(posedge clk);
              end
 
  endtask
  
  
  
  task check();
    if(count == 0 && rst_count == 3)
       $display("Suc at %0t",$time);
    else
        $error("Failure at %0t",$time);  
  endtask
  
    initial begin
    countrst();
    check();
  end
  
  
  initial assert property (@ (posedge clk) rst[*3] ##1 !rst[*17]) $info("Suc at %0t",$time);
  
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $assertvacuousoff(0); 
    #200;
    $finish;
  end
  
  
endmodule