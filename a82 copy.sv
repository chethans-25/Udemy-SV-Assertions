/*
If a assert then a must remain true until en remains true.
*/

module tb;
  reg a = 0, b = 0,en = 0;
  reg clk = 0;
  
  always #10 clk = ~clk;
 
  initial #20 en = 1;
  initial #80 en = 0;
  initial #100 en = 1;
  // initial #140 en = 0;

  initial #40 a = 1;
  initial #60 a = 0;
  initial #120 a = 1;
  initial #151 a = 0;


  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #200;
    $finish();
  end
 
  /// Add your code here

 sequence s1;
//  ##[1:$] $fell(en);
 ##[0:$] !(en);
 endsequence

  property p1;
    // @(posedge clk) $rose(a) |-> a throughout $fell(en) ;
    // @(posedge clk) $rose(a) |-> (a until $fell(en)) ;//fail
    // @(posedge clk) $rose(a) |-> (a until en) ; //pass
    // (@(posedge clk) $rose(a) |-> a[*1:$] intersect (en[*1:$]));
    // @(posedge clk) $rose(a) |-> (a throughout (en) ##0 !en);
    // @(posedge clk) $rose(a) |-> (a until (!en)) ##1 (en) ;

    // @(posedge clk) $rose(a) && en |-> (a==1) throughout s1 ;
    @(posedge clk) $rose(a) && en |-> strong((a==1) throughout (##[0:$] !(en)));
  endproperty

  label_p1: assert property(p1) $info("Assertion P1 Passed at time: %0d", $time);
  else   $info("Assertion P1 Failed at time: %0d", $time);


endmodule