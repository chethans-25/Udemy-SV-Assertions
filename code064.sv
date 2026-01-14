module tb;
 
 reg [3:0] b;
 reg clk = 0;
 
 
 always #5 clk = ~clk;
 
 
 initial begin
 b = 4'b0100;
 #10;
 b = 4'b0101;
 #10;
 b = 4'b0100;
 #10;
 b = 4'b0101;
 #10;
 b = 4'b0100;
 #10;
 b = 4'b0101;
 #10;
 b = 4'b0000;
 
 
 end
 
 always@(posedge clk)
 begin
 $info("Value of b :%0b and $rose(b) : %0b", $sampled(b), $rose(b));
 end 
 
 
 initial begin
 $dumpfile("dump.vcd"); 
 $dumpvars;
 #60;
 $finish();
 end
 
 
endmodule