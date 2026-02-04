// RST must become low after 4 clock tick.

module tb;

reg rst=1, clk=0;

always #5 clk = ~clk;
initial #200 $finish;




initial
begin
  #40 rst = 0;
end

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0);
end

  property p1;
    @(posedge clk) nexttime[4] !rst;
  endproperty

  initial
  begin 
    assert property(p1) $info("Assertion P1 Passed at time: %0d", $time);
    else   $error("Assertion P1 Failed at time: %0d", $time);
  end

endmodule