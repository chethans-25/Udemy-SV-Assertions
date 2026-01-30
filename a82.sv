/*
If a assert then a must remain true until en remains true.
*/

module tb;
  reg a = 0, b = 0,en = 0;
  reg clk = 0;
  
  always #10 clk = ~clk;
 
  // always #10 a = ~a;

  // always #15 en = ~en;

  initial
  begin:a_label
    #20 a=1;
    #40 a=0;
    #40 a=1;
    // #40 a=0;


  end

  initial
  begin:en_label
    #20 en = 1;
    // #60 en = 0;
    // #20 en = 1;
    // #35 en = 0;
    #110 en = 0;
    
  end

  
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
 strong (##[1:$] !(en));
 endsequence

  property p1;
    // @(posedge clk) $rose(a) |-> a throughout $fell(en) ;
    // @(posedge clk) $rose(a) |-> (a until $fell(en)) ;//fail
    // @(posedge clk) $rose(a) |-> (a until en) ; //pass
    // (@(posedge clk) $rose(a) |-> a[*1:$] intersect (en[*1:$]));
    // @(posedge clk) $rose(a) |-> (a throughout (en) ##0 !en);
    // @(posedge clk) $rose(a) |-> (a until (!en)) ##1 (en) ;

    @(posedge clk) $rose(a) && en |-> a throughout s1 ;
  endproperty

  label_p1: assert property(p1) $info("Assertion P1 Passed at time: %0d", $time);
  else   $info("Assertion P1 Failed at time: %0d", $time);


endmodule