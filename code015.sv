// Still figuring out how to synthesize in edapg


module synth(
input a,b,sel,
output reg y
);
 
///////Behavior check
always_comb
begin
if(sel == 1'b1)
assert (y == a) else $error("y is not equal to a");
else
assert (y == b) else $error("y is not equal to b");
end
 
/////actual RTL
always_comb
begin
if(sel == 1'b1)
y = a;
else
y = b;
end
 
endmodule