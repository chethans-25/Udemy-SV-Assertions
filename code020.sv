module tb;
  
 
  reg am = 0;
  reg bm = 0;
  
  wire a, b;
 
  assign a = am;
  assign b = bm;
  
 
 initial begin
   am = 1;
   bm = 1;
   #10;
   am = 0;
   bm = 1;
   #10;
   am = 1;
   bm = 0;
   #10; 
 end
  
  always_comb
  begin
  // A1 : assert (a == b) $info("a and b are equal at %0t",$time);  //Simple Immediate Assertion
  // A1 : assert #0 (a == b) $info("a and b are equal at %0t",$time);  //Observed deferred Immediate Assertion
  A1 : assert final (a == b) $info("a and b are equal at %0t",$time);  //Final deferred Immediate Assertion
  else $error("assertion failed at %0t",$time);
  end
  
  
  
 endmodule