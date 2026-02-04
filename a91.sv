/*
Create a Single thread that will verify user must first write the data to RAM before reading. 
" There must be at least single write request (wr) before the arrival of the read request (rd)"
*/




module tb;

reg wr=0, rd=0, clk=0;

always #5 clk = ~clk;
initial #60 $finish;


initial
begin
  #30 wr = 1;
  #10 wr = 0;
end

initial
begin
  #10 rd = 1;
  #10 rd = 0;
end



initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0);
end



  sequence s1;
    (!rd ##[1:$] $rose(rd));
  endsequence

  property p1;
    @(posedge clk) wr within s1;
  endproperty

  label_p1: assert property(p1) $info("Assertion P1 Passed at time: %0d", $time);
  else   $error("Assertion P1 Failed at time: %0d", $time);


endmodule
