/*
If signal 'rst' deassert and signal 'mode' assert then value of signal 'dout' in the next clock tick must be one greater than its the previous value.
*/

//if assert and deassert in the question mean to use transition of inputs, then we need to use $rose and $fell tasks otherwise not.
property p1;
  @(posedge clk) $fell(rst) && $rose(mode) |=> dout == ($past(dout ) + 1);
  // @(posedge clk) (~rst && mode) |=> dout == ($past(dout ) + 1);
endproperty

always begin
  label_p1: assert property(p1) $info("Assertion Passed at time: %0d", $time);
  else   $error("Assertion Failed at time: %0d", $time);
end

