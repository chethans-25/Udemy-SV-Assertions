module temp;
 
 reg a = 0;
 reg clk = 0;
 
 always#5 clk = ~clk;
 
 
 initial begin
 
 for(int i = 0; i < 15; i++ ) begin
 
 a = $urandom_range(0,1);
 
 @(posedge clk);
 
 end
 
 end
 
 
 
 
 always@(posedge clk)
 
 begin
 
 $display("Value of a:%0b $changed(a):%0b $stable(a):%0b @ %0t", a, $changed(a),$stable(a), $time); 
 
 $display("-------------------------------------------------------------"); 
 
 end
 
 
 
 initial begin
 
 #100;
 
 $finish;
 
 end
 
 
 
endmodule