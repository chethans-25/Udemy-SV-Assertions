// CE must assert after sixth clock tick.

module tb;

reg ce=0, clk=0;

always #5 clk = ~clk;
initial #200 $finish;




initial
begin
  #60 ce = 1;
end

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0);
end

  property p1;
    // @(posedge clk) ##6 $rose(ce);
    @(posedge clk) nexttime[6] ce;
  endproperty

  initial
  begin 
    assert property(p1) $info("Assertion P1 Passed at time: %0d", $time);
    else   $error("Assertion P1 Failed at time: %0d", $time);
  end

endmodule