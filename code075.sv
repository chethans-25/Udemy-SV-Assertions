module tb;
 
 reg a = 1 , clk = 0;
 reg en = 0;
 reg [3:0] b = 0;
 
 always #5 clk = ~clk; //10 ns clock
 
 
 initial 
 begin
 en = 1;
 #100;
 en = 0;
 end
 
 
 initial 
 begin
 for(int i =0; i< 15; i++) 
 begin
 b = $urandom_range(0,20);
 a = $urandom_range(0,1);
 @(posedge clk);
 end
 end
 
 
 
 
 
//$past( Signal, No. of clock tick, Gating, Clocking )
 
 
 
 
 always@(posedge clk)
 begin
 $display("Value of a:%0d and b:%0d", $sampled(a), $sampled(b));
 $display("Value of $past(a):%0d $past(b):%0d", $past(a), $past(b));
 $display("-----------------------------------");
 //$info("Value of $past(a) : %0d", $past(b,1,en));
 end 
 
 
 
 
 /*
 always@(posedge clk)
 begin
 $display("Value of a:%0d , b:%0d and en:%0d @ %0t", $sampled(a), $sampled(b), $sampled(en), $time);
 $display("Value of $past(a):%0d $past(b):%0d", $past(a,1,en), $past(b,1,en));
 $display("-----------------------------------");
 //$info("Value of $past(a) : %0d", $past(b,1,en));
 end 
 */
 
 
 
initial begin
$dumpfile("dump.vcd");
$dumpvars;
#300;
$finish();
 
end
 
 
 endmodule