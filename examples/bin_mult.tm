// Input: a#b (where a and b are binary numbers)
// Ouput: a*b
// Example: 101#10 outputs 1010
//
// Binary Multiplication Algorithm
// for Turing Machine Simulator 
// turingmachinesimulator.com
// by Pedro Aste - ppaste@uc.cl
// 
//
// ------- States -----------|
// q0 - qStart               |
// q1 - qInCopy              |
// q2 - qInCopyBack          |
// q3 - qAnalize             |
// q4 - qShift               |
// q5 - qSum                 |
// q6 - qErase               |
// q7 - qSumaBack            |
// q8 - qCarry               |
// q9 - qFinalCopy           |
// q10 - qFinal              |
//---------------------------\'

name: Binary Multiplication
init: q0
accept: q10

// Moves right until finds the "#".

q0,0,_,_
q0,0,_,_,>,-,-

q0,1,_,_
q0,1,_,_,>,-,-

// Reads "#", moves second number to second tape.

q0,#,_,_
q1,_,_,_,>,-,-

q1,0,_,_
q1,_,0,_,>,>,-

q1,1,_,_
q1,_,1,_,>,>,-

// Finishes the previous movement.

q1,_,_,_
q2,_,_,_,<,-,-

q2,_,_,_
q2,_,_,_,<,-,-

q2,0,_,_
q3,0,_,_,-,-,-

q2,1,_,_
q3,1,_,_,-,-,-

// Reads the first number from
// the last digit to the first,
// if the digit is a 0, does
// nothing, otherwise, sums the
// number on the second tape to
// the third, keeping the sum on
// the third tape. Then multiplies
// the number on the second tape by 2.

q3,0,_,_
q4,0,_,_,-,-,-

q3,1,_,_
q5,1,_,_,-,<,<

q3,_,_,_
q6,_,_,_,>,-,-

// Shift left, second tape.

q4,0,_,_
q3,0,0,_,<,>,-

q4,1,_,_
q3,1,0,_,<,>,-

// Sum

q5,1,0,0
q5,1,0,0,-,<,<

q5,1,0,1
q5,1,0,1,-,<,<

q5,1,1,0
q5,1,1,1,-,<,<

q5,1,1,1
q8,1,1,0,-,<,<

q5,1,0,_
q5,1,0,0,-,<,<

q5,1,1,_
q5,1,1,1,-,<,<

q5,1,_,0
q5,1,_,0,-,<,<

q5,1,_,1
q5,1,_,1,-,<,<

q5,1,_,_
q7,1,_,_,-,>,>

// Sum Carry.

q8,1,1,1
q8,1,1,1,-,<,<

q8,1,1,0
q8,1,1,0,-,<,<

q8,1,0,1
q8,1,0,0,-,<,<

q8,1,0,0
q5,1,0,1,-,<,<

q8,1,0,_
q5,1,0,1,-,<,<

q8,1,1,_
q8,1,1,0,-,<,<

q8,1,_,0
q5,1,_,1,-,<,<

q8,1,_,1
q8,1,_,0,-,<,<

q8,1,_,_
q5,1,_,1,-,<,<

// Head goes back to the end of the second and third tape.

q7,1,_,0
q7,1,_,0,-,>,>

q7,1,_,1
q7,1,_,1,-,>,>

q7,1,0,_
q7,1,0,_,-,>,>

q7,1,1,_
q7,1,1,_,-,>,>

q7,1,0,0
q7,1,0,0,-,>,>

q7,1,0,1
q7,1,0,1,-,>,>

q7,1,1,0
q7,1,1,0,-,>,>

q7,1,1,1
q7,1,1,1,-,>,>

q7,1,_,_
q4,1,_,_,-,-,-

// First tape deletion.

q6,0,_,_
q6,_,_,_,>,-,-

q6,1,_,_
q6,_,_,_,>,-,-

q6,_,_,_
q9,_,_,_,<,<,<

// Moves the output to the first tape.

q9,0,0,0
q9,0,_,_,<,<,<

q9,0,0,1
q9,1,_,_,<,<,<

q9,0,1,0
q9,0,_,_,<,<,<

q9,0,1,1
q9,1,_,_,<,<,<

q9,1,0,0
q9,0,_,_,<,<,<

q9,1,0,1
q9,1,_,_,<,<,<

q9,1,1,0
q9,0,_,_,<,<,<

q9,1,1,1
q9,1,_,_,<,<,<

q9,0,_,_
q9,_,_,_,<,-,-

q9,1,_,_
q9,_,_,_,<,-,-

q9,_,0,_
q9,_,_,_,-,<,-

q9,_,1,_
q9,_,_,_,-,<,-

q9,_,_,0
q9,0,_,_,<,-,<

q9,_,_,1
q9,1,_,_,<,-,<

q9,0,0,_
q9,_,_,_,<,<,-

q9,0,1,_
q9,_,_,_,<,<,-

q9,1,0,_
q9,_,_,_,<,<,-

q9,1,1,_
q9,_,_,_,<,<,-

q9,0,_,0
q9,0,_,_,<,<,<

q9,1,_,0
q9,0,_,_,<,<,<

q9,0,_,0
q9,0,_,_,<,<,<

q9,0,_,1
q9,1,_,_,<,<,<

q9,1,_,1
q9,1,_,_,<,<,<

q9,_,0,0
q9,0,_,_,<,<,<

q9,_,0,1
q9,1,_,_,<,<,<

q9,_,1,0
q9,0,_,_,<,<,<

q9,_,1,1
q9,1,_,_,<,<,<

q9,_,_,_
q10,_,_,_,-,-,-
