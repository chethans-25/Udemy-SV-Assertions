**************************************************************
// SECTION 1 : INTRO TO SVA

Verilog vs SV

Implementation in Verilog
More complex

Implementation in System Verilog
Simple to implement due 


s_eventually

It is a strong temporal property operator used to specify that a condition must eventually occur at least once during the simulation.

s means strong : Must happen before end of simulation otherwise assertion fails

eg:   
initial assert property (@(posedge clk) s_eventually start) $display("SVA Suc at %0t",$time);

In SVA, there are repetition operators to make things easy


assertion statements in Synthesizer

**************************************************************
// SECTION 2: Immediate Assertions


************Simulation Regions***********

Preponed: Sampling

Active: Execution of BA, CA, RHS of NBA, $display

Inactive:  #0 statements Execution

NBA: assignment to LHS

Observed: Concurrent assertion Execution

Reactive: Pass/ Fail statements

Postponed: $monitor, $strobe Execution



assert (y==a^b);
a=1;
b=1;

a gets value 1 before b (simulation glitches), assertion fails in simple Immediate

Observed Deferred Immediate: Observed region
#0

Final Deferred Immediate: Postponed region
final keyword


Concurrent assertion: Observed region


***********Format of Assertion types***********

simple Immediate:
assert keyword

Observed deferred Immediate:
assert #0

Final deferred Immediate:
assert final

Concurrent:
assert property


***********Rules for Immediate assertion***********

SIA requires procedural blocks: initial, always_comb, always_ff , always 

ODIA and FDIA: procedural blocks are required for sequential circuits

SIA: Multiple pass/ fail action is supported, but rarely used
ODIA and FDIA : only single pass / fail action 

************Disabling Assertion************

Collective Disable
// for all the assertions
$assertoff() 
$asserton() 

// For specific Checks
disable <assertion_label>
// disable is not available for SIA
// disable is available for ODIA and FDIA

// Assertion control tasks
$asserton
$assertoff
$assertkill
$assertcontrol
$assertpasson
$assertpassoff
$assertfailon
$assertfailoff
$assertnonvacuouson
$assertnonvacuousoff


**************************************************************
// SECTION 3: Concurrent Assertions

*************Layers**********

****Build a boolean expression
evaluate to True/ False

****Create sequence using expression
Linear and non Linear
operators: delay, repetition, matching, multiple
Linear means We know the exact relationship bw the signal


****build property between sequences
combine multiple property
select particular property
use implication

****assert property
assert
assume
cover


Assertion for all valid clk edge of only for single edge?

for single edge
use initial
use temp variable and keep only one transition and work with that

for all valid edge, don't use initial

****Understanding Clk edges*****

posedge, negedge, and edge

posedge_label: assert property ( @(posedge clk) expression)) <pass_statement>; else <fail_statement>;
negedge_label: assert property ( @(negedge clk) expression)) <pass_statement>; else <fail_statement>;
edge_label: assert property ( @(edge clk) expression)) <pass_statement>; else <fail_statement>;

***Clocking Block and Default clocking****

clocking c1
@(posedge clk);
endclocking

clocking c2
@(negedge clk);
endclocking

default clocking c2;
posedge_label: assert property (expression)) <pass_statement>; else <fail_statement>;


****Disabling Concurrent assertion ******

A2: assert property ( @(posedge clk) disable iff(rst)    req |=> ack )$info("Suc at %0t",$time);




**************************************************************
// SECTION 4: Implication Operators

Overlapping   |->

antecedent  |->  Consequent
in the same clk tick


Non Overlapping   |=>

antecedent  |=>  Consequent
in the next clk tick

If antecedent itself is false, result will be success ( it is called vacuous success)

$assertvaccuousoff(0); //to disable vacuous success


Sequences

  sequence cewr (logic a, logic b);
    a && b;
  endsequence

Properties

  property p1;
    (@(posedge clk) $fell(rst) |-> cewr(ce,wr));
  endproperty
  
  
  ///////////////////////////////////////////////
  
  
  
  property p2(logic a,logic b);
    (@(posedge clk) $fell(rst) |=> (a && b));
  endproperty
  
  ////////////////////////////////////////////////
  
  CHECK_CE_WR:assert property ( p1) $info("p1 CHECK_WR @ %0t", $time);
    
  CHECK_CE_rd:assert property (  p2(ce,rd))  $info("p2 CHECK_RD @ %0t", $time);


****************System Tasks******************

$sampled(<variable>)
reporting macros return value of variable at reactive region
$sampled(<variable>) gives value of variable at preponed region

when using concurrent assert, $sampled is not necessary as by default preponed value is returned


$rose(<variable>, <clocking event>)
returns true if variable changes from 0,x,z to 1
In case of multibit variable, only lsb is considered


$fell(<variable>, <clocking event>)
returns true if variable changes from 1,x,z to 0
In case of multibit variable, only lsb is considered

$past(<variable>, <no_of_clk_ticks>, gating, <clocking event>)
returns past value

if gating is 0, new value is not evaluated, last calculated past value is considered
if gating is 1, normal operation

*******Typical Use cases*********
// if a assert, b must assert in next clk tick
assert property (@(posedge clk) $rose(a) |=> $rose(b));

// Each new request must be followed by an acknowledgement
assert property (@(posedge clk) $rose(req) |=> $rose(ack));

// if rst deassert, CR must assert in same clk tick
assert property (@(posedge clk) $fell(rst) |-> $rose(CE));

// Wr request must be followed by rd request
assert property (@(posedge clk) $rose(wr) |=> $rose(rd));

// current calue of addr must be one greater than prev value if start assert
assert property (@(posedge clk) $rose(start) |=> addr == ($past(addr) + 1));

// if rst deassert, dout must be zero
assert property (@(posedge clk) $fell(rst) |-> dout==0);

// if load_in deassert, dout must be equal to load_value
assert property (@(posedge clk) $fell(load_in) |-> dout==load_value);

// if rst deassert, output of shift reg must be shifted to left by 1 in the next clk tick
assert property (@(posedge clk) $fell(rst) |=> sout=={sout[6:0],0});

// if rst deassert, current value and past value of the signal differ only in single bit
assert property (@(posedge clk) $fell(rst) |=> $onehot(a ^ $past(a)));

// in DFF, output must remain constant if CE is low
assert property (@(posedge clk) !(CE) |=> dout == $past(dout));

// in TFF, if CE assert, output must toggle
assert property (@(posedge clk) $rose(CE) |=> tout == ~$past(tout));


****************System Tasks******************
$changed()
returns true if variable is changed from prev clock tick

$stable()
returns true if variable is not changed from prev clock tick

$onehot()
returns true if variable is in onehot encoded pattern, i.e only one bit of variable is high

$onehot0()
returns true if atmost one bit of variable is high, similar to onehot but all zeros evaluates to true

onecold
This is not a standard task. We can make use of $onehot() task to implement onecold
onecold = $onehot(~<variable>);
returns true if variable is in onecold encoded pattern, i.e only one bit of variable is low

$isunknown()
returns true if any bit of variable has unknown value (x or z)

$countbits(variable, matching_value)
returns the number of bits of matching_value present in variable

$countones(variable)
returns the number of bits of 1 present in variable


********************Sequence Operators********************

Delays
Constant delay
##n

A1: assert property (@(posedge clk) $rose(req) |=> ##2 $rose(ack)) $info("Suc @ %0t",$time);

variable delay
##[min: max]

A1: assert property (@(posedge clk) $rose(req) |-> ##[2:5] $rose(ack)) $info("Suc @ %0t",$time);


Unbounded delay
##[ : $]

A1: assert property (@(posedge clk) $rose(req) |-> ##[0:$] $rose(ack)) $info("Suc @ %0t",$time);

Unbounded delay is weak, it does not print error on the console. Needs infinite sim time for it to consider assertion failure

Strong property: Need to complete before sim end
Unfinished attempts are considered failire at the end of simulation

Weak property: They do not need to finish

Use strong keyword to explicitly make strong
A1: assert property (@(posedge clk) $rose(req) |-> strong(##[0:$] $rose(ack))) $info("Suc @ %0t",$time);

********************Repetition Operators********************

consecutive repetition
[*n]                n >= 0
[*m:n]             m,n >= 0    //range of repetition

Non consecutive repetition
[=n]                
