// CE must become high immediately if reset deassert. Property must failed if rst never become high.


module tb;

reg rst=1, ce = 0, clk=0;

always #5 clk = ~clk;
initial #600 $finish;


initial
begin
  #500 ce = 1;
end

initial
begin
  #500 rst = 0;
end

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0);
end


  property p1;
    @(posedge clk) $fell(rst)[->1] #-# $rose(ce);
  endproperty

  initial
    begin
      assert property(p1) $info("Assertion P1 Passed at time: %0d", $time);
      else   $error("Assertion P1 Failed at time: %0d", $time);
    end

endmodule