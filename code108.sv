module tb;
 
 reg clk = 0;
 
 reg req1 = 0;
 reg req2 = 0;
 int delay1 = 0, delay2 = 0;
 
 
 
 always #5 clk = ~clk;
 
 initial begin
 for(int i = 0; i < 4; i++)
 begin
 delay1 = $urandom_range(4,8);
 #delay1;
 req1 = 1;
 #20;
 req1 = 0;
 #30;
 end
 end
 
 initial begin
 for(int i = 0; i < 4; i++)
 begin
 delay2 = $urandom_range(3,5);
 #delay2;
 req2 = 1;
 repeat(delay2) #10;
 req2 = 0;
 #20;
 end
 end
 
 /////if req1 asserts, then it should remain stable for 2 clock ticks
 A1: assert property (@(posedge clk) $rose(req1) |-> req1[*2] ) $info("req1 rep suc @ %0t", $time); 
 
 ////////if req2 asserts, then it should remain stable for 3 to 5 clock ticks 
 
 A2: assert property (@(posedge clk) $rose(req2) |-> req2[*3:5] ) $info("req2 rep suc @ %0t", $time); 
 
 initial begin
 #250;
 $finish();
 end

endmodule