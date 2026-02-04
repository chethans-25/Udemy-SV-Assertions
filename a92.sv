// RST remain asserted until CE become active high.

module tb;

reg rst=1, ce=0, clk=0;

always #5 clk = ~clk;
initial #60 $finish;


initial
begin
  #20 rst = 0;
end

initial
begin
  #20 ce = 1;
end

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0);
end

  property p1;
    @(posedge clk) rst s_until $rose(ce);
  endproperty

  label_p1: assert property(p1) $info("Assertion P1 Passed at time: %0d", $time);
  else   $error("Assertion P1 Failed at time: %0d", $time);

endmodule