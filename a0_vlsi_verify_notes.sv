assertion advantages: synthesis skipped, more readable, 

$fatal
$error
$warning
$info

Never Assert a sequence,use implication operator
concurrent assertion expressions are:
*sampled in preponed region
*evaluated in obs region
*execute pass/fail statement in reactive region

|-> overlapping implication operator
|=> non-overlapping implication operator
implication can be nested

##[min:max]

##[1:$]

Repetition
[*n]                n >= 0  and  n != $ 				consecutive Repetition

[*m:n]             m,n >= 0  and  n != $

[=m]                m >= 0  and  m != $         non-consecutive Repetition

[=m:n]             m,n >= 0  and  n != $

[->n]               n >= 0  and  n != $         go-to Repetition

use [->1]  instead of [1:$] 

[*0]  empty sequence

and operator
s1 and s2
both should start at a time, and match. Individual end time can be different 

intersect operator
s1 intersect s2
similar to and operator but Individual end time should match

or operator
s1 or s2
both should start at a time, and either of them should match.

not operator


first_match() operator
first_match(s1 ##[2:6] s2);
subsequent matches are discarded

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


if-else
based on antecedent, we use an if-else condition in consequent expression

ended construct
seq.ended
returns true if seq has reached the end point, at that point in time.

local variables can be used in sequence and property


Sampled value functions (can also be used in procedural code):
$rose(exp [, clk event]) 
    returns true if LSB changes to 1 in from previous clk event

$fell(exp [, clk event]) 
    returns true if LSB changes to 0 in from previous clk event

$stable(exp [, clk event])
    returns true if value of exp did not change from 
    its sample value at previous clk

$past(exp [,num_cycle] [,gating_exp] [, clk event]) 
    returns the sampled value of exp num_cycle prior to $past
		gating signal has to be true


System functions and tasks:
$onehot(exp)    returns true if only one bit of exp is HIGH

$onehot0(exp)    returns true if atmost one bit of exp is HIGH

$isunknown(exp)    returns true if any bit of exp is z or x

$countones(exp)    returns the count of ones in exp.


disable iff(condition)  gives local control in the source of assertion

$assertoff(level [,list of modules, instance or assertion identifier])
    temporarily turns OFF execution of assertion
    level: 0 - all levels below 
           n - n level of hierarchy below

$asserton(level [,list of modules, instance or assertion identifier])
    default. Turns ON execution of assertion

$assertkill(level [,list of modules, instance or assertion identifier])
    Kills all currently executing assertion


7 types of properties

sequence
negation (not operator)
disjunction (or operator)
conjunction (and operator)
if .. else
implication
instantiation


Recursive property
-declaration involves an instantiation of itself
-two properties can be mutually Recursive
Restrictions:
should use non-overlapping |=> operator
not operator can not be used in Recursive property instances
disable iff operator can not be used in declaration of Recursive property 


Multiple clock sequences
concatenated using ##1

eg: @(posedge clk1) sig1 ##1 @(posedge clk2) sig2
match of sequence starts with the match of sig1 at posedge clk1
then ##1 moves the time to the nearest strictly subsequent posedge clk2
match of the sequence ends at the point with a match of sig2 

Restrictions
only ##1 can be used. Not any other
and, or, intersect, etc operators are illegal to use in sequence with Multiple clocks
and, or , not operators can be used in Multiple clock properties ( not in sequences)


clock resolution
sequence instance has a clock
property itself has a clock
Infer clock from procedural block that calls assertion
Infer clock from clocking block where property is declared
clocks need to be explicitly specified for multiple clk assertions. Cannot infer from procedural block

Binding
bind <dut_specific_instance_path> <assertion_module> <instance>

bind <dut_module> <assertion_module> <instance>

Expect statement
procedurally blocking that allows waiting on a property evaluation
same syntax as assert.
Does not infer clock from procedural block. Need to specify explicitly in sequence or property

tip: Label meaningfully

Static casting
int`(2.0 * 3.0)  No return value on pass fail condition possible

Dynamic casting
$cast(dest, source)
returns a pass/ fail condition
can be used as a function or as a task
use an assert() around $cast() to catch wrong casting


usage of macro
`define assert_clk(arg, enable_error = 0, msg = " ")\
	assert property (@(posedge clk) arg)\
	else if (enable_error) $error("%0t: %m: %s",$time, msg)

`assert_clk ((q==$past(d),1,"********Error*******))

%m provides hierarchy


strict keyword
Syntax: strict(expression)
It is used to ignore vacuous success of assertion


using parameter inside property definition and calling it
module generic_chk (input logic a, b, elk);
parameter delay = 1;
property pl6;
@(posedge elk) a |-> ##delay b;
endproperty
al6: assert property(pl6);
endmodule
// call checker from the top level module
module top() ;
logic elk, a, b, c, d;
generic_chk #(.delay(2)) il (a, b, elk);
generie_chk i2 (c, d, elk);
endmodule


select operator/ ternary operator
property p1;
©(posedge elk) c ? d == a : d == b;
endproperty


`true expression
used to extend time for a cycle 

`define true 1
sequence sl8a_ext;
©(posedge elk) a ##1 b ##1 "true;
endsequence

.matched operator
Used to detect end point of a sequence
eg:
property p_match;
©(posedge clk2) s_a.matched |=> s_b;
endproperty




// Anil-Chaya session

// Deferred Immidiate assertion
can be used outside procedural block

// concurrent assertions
evaluated at every clock tick
synchronization
improve debug quality


Active region
$display
$finish

postponed region
$monitor
$strobe

preponed
values are sampled

observed
values evaluated

reactive region
pass fail statement
program block

 