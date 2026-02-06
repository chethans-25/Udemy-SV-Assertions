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

Non consecutive repetition (weak)
[=n]

[=m:n]

[->n] goto operator: similar to non consecutive but, in the Immidiate next clock tick, tell expression should match

[->m:n] 

*****************Typical Use cases********************

// If read do not assert before timeout, then system should reset

!read[*1:$] ##1 timeout |-> rst;


//  write req must be followed by read req.

$rose(wr) |-> $rose(rd);


// If a assert, b must assert with in five clk ticks

a |-> ##[0:4] b;


// If reset deasserts, then CE must assert within 1 to 3 clock ticks

$fell(rst) |-> ##[1:3] $rose(CE);


// If req assert and ack not received in the 3 clock ticks, then req must re-assert
$rose(req) ##1 !ack[*3]  |-> $rose(req);

// If a assert, a must remain high for 3 clk ticks
$rose(a) |-> a[*3];


// System operation must start with rst asserted for 3 consecutive clk ticks
initial A1: assert property (@(posedge clk) rst[*3]);

// CE must assert somewhere during the simulation, if rst deasserts
$fell(rst) |-> ##[1:$] $rose(CE);


// transaction start with CE become high and ends with CE become low. Each transaction must contain atleast one read and write req;

$rose(CE) |-> (rd[->1] and wr[->1])   ##1 $fell(CE);

// If CE assert somewhere after rst deasserts, then  wr req must be high atleast once

$fell(rst) ##[1:$] $rose(CE) |-> wr[->1] ## !wr; // wr must not be high for 2 consecutive clk, so !wr

// a must assert twice during simulation
a[->2]

a[=2]

// If a become high somewhere, then b must become high in the immediate next clk tick
$rose(a) |=> $rose(b);


// If req is received and all the data is sent to slave indicated by done signal, then ready must be high in the next clk tick.
$rose(req) ##1 done[->1] |=> ready;


*********************Working with Multiple Sequences **********************
********Boolean Operators
AND, OR, NOT

s1 and s2; // both sequences should evaluate to true
both should start at a time, and match. Individual end time can be different 


s1 or s2; // either of the sequences should evaluate to true
both should start at a time, and either of them should match.


not(s1); // sequence s1 should not evaluate to true

********Used Cases*************

// Perform atleast one read and write cycle on the DUT after reset is deasserted

sequence s1;
  wr[*1];
endsequence

sequence s2;
  ##1 rd[*2];
endsequence


assert property (@(posedge clk) $fell(reset) |=> s1 or s2);


// Read and write cycle should not be performed at the same time
sequence wrrd;
  strong(##[0:$] wr && rd);
endsequence

assert property (@(posedge clk) $fell(reset) |=> not(wrrd));

******** matching Operators


throughout() operator
sig1 throughout s1
exp1 throughout s1
useful to test if a signal or an expression is true throughout a sequence
LHS cannot be another sequence
eg:
$fell(a) ##0
(!a) throughout s1;

within operator
completion of one sequence within another

intersect operator
s1 intersect s2
similar to and operator but Individual end time should match


*************temporal logic operators *********************

**********eventually
//weak
eg: eventually a; //a must go high somewhere in the simulation

**********s_eventually
//strong 

**********use cases**********
//CE assert eventually
s_eventually CE;

// rst must go down within  3 to 10 clk ticks
s_eventually [3:10] $fell(rst); 

// CE assert eventually and remains high
s_eventually always CE;


// rst deassert eventually and stays low
s_eventually always !rst;


**********nexttime and s_nexttime

nexttime [ n ] property_expr
n represents number of clock ticks

property_expr should evaluate to true after n clk ticks


*********until and until_with
until - non Overlapping
until_with - Overlapping : signals overlap for one clk

eg: sig1 until sig2

// s_until and s_until_with
strong versions of until and until_with


**********followed by Operators
#-#   non Overlapping
#=#   Overlapping

They are duals of implication operators

A  #-# C    is equivalent to 
not (A |-> not C)

A  #=# C    is equivalent to 
not (A |=> not C)

In simple words, they are similar to implication operators except for the following point:
If antecedent fails, assertion fails while using followed by operators, 

whereas for implication operator
If antecedent fails, assertion passes and it is a vacuous success


********************Local Variables*******************

*************Fundamentals
defined inside a property or sequence block
Have existence only if an expression given to it.

eg:

property p1;
  logic i = 0;
  (start, i++) |-> (done, i++);
endproperty

******behavior of local variable
For each independent thread, var will be local to that thread.
count value will be 1 for the following snippet, it won't increment.

property p1;
 int count = 0;
 ($rose(start), count = count++, $display("Value of count: %0d",count));
endproperty


count will be incremented for the following snippet, but only 1 pass will be identified

($rose(start), count = 1) |-> ## [1:$] ($rose(start), count = count + 1) ##[1:$] ($rose(start), count++, $display("Count : %0d", count) ) ; 


*********Common Examples*************

*****Boolean Operators

// Both a and b must be high
assert property ( @(posedge clk) a && b);

// Either a or b should be high
assert property ( @(posedge clk) a || b);

// One should be high, other should be low
assert property ( @(posedge clk) a ^ b);

// Both must be low
assert property ( @(posedge clk) !a && !b);


*****Implication Operators

// If antecedent is high, consequent also must be high
assert property ( @(posedge clk) a |-> c);

// If antecedent is high, consequent also must be low
assert property ( @(posedge clk) a |-> !c);


*****Sequence Operators

*****fixed Delay

// a must be high after 2 clk tick 
(##2 a)

// if a assert, a must remain high for 2 clk tick
$rose(a) |=> a[*2];
//or
$rose(a) |=> a && $past(a);

// if a assert, b should assert after 4 clk
$rose(a) |=> ##4 b;

// a followed by b followed by c
a ##1 b ##1 c;


*****Range of Delay (bounded)

// rst should necome low within 4 to 5 clk
##[4:5] !rst;

// if rst deassert, then ce must assert within 2 to 5 clk
!rst |-> ##[2:5] ce;

// ack should be granted to the new req within 0 to 1 clk
req |-> ##[0:1] ack;

*****Range of Delay (unounded)
// if a assert, b must assert at same clk tick or anytime later during the simulation
$rose(a) |->  ##[0:$] b;  //weak; use strong keyword if necessary

or

$rose(a) |-> s_eventually b;

// if a assert, b deassert in the next clk tick or somewhere during the simulation.
$rose(a) |=> ##[0:$] !b;
or
$rose(a) |-> ##[1:$] !b;
or
$rose(a) |=> s_eventually !b;


// rst must go low somewhere during simulation
##[1:$] !rst;
or
(s_eventually !rst);

*******repetition operator

// if rd assert, then it must stay high for 2 clk
$rose(rd) |-> rd[*2];

// three consecutive wr should be followed by 2 rd req
wr[*3] |=> rd[*2];

// if rst deassert, then ce must remain high
$fell(rst) |-> ce[*1:$];


***********Projects**************
