// If CE assert then it must deassert within 5 to 10 clock cycles. Evaluate the property on positive edge of the clock.

p1: assert property (@(posedge clk) $rose(CE) |-> ##[5:10] $fell(CE));