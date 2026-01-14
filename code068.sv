module tb;
 
 
 reg a = 1;
 
 reg clk = 0;
 
 
 always #5 clk = ~clk;
 
 
 initial begin
 
 for (int i = 0; i < 10; i++)
 
 begin
 
 a = $urandom_range(0,1);
 
 #10;
 
 end
 
 end
 
 
 
 always@(posedge clk)
 
 begin
 
 $info("Value of a :%0b and $fell(a) : %0b", $sampled(a), $fell(a));
 
 end 
 
 
 
 
 
 initial begin
 
 $dumpfile("dump.vcd"); 
 
 $dumpvars;
 
 #120;
 
 $finish();
 
 end
 
 
 
endmodule