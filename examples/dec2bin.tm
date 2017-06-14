//////////////////////
// turing: dec to bin
//////////////////////

// Copyright (c) 2013 Max von Buelow
// Copyright (c) 2013 kd3x
// License: CC BY-NC-SA 3.0

// Simulator: turingmachinesimulator.com
// Initial state: qinit
// Accepting state: qfin

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Greetings to the course 'FGdI 1' 
// at the TU Darmstadt.
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

name: Decimal to binary
init: qinit
accept: qfin

qinit,0
qinit,0,>
 
qinit,1
qinit,1,>
 
qinit,2
qinit,2,>
 
qinit,3
qinit,3,>
 
qinit,4
qinit,4,>
 
qinit,5
qinit,5,>
 
qinit,6
qinit,6,>
 
qinit,7
qinit,7,>
 
qinit,8
qinit,8,>
 
qinit,9
qinit,9,>
 
qinit,_
halve,0,<
 
// Halve and go to addHalf to add the goBack
halve,0
halve,0,<
 
halve,1
addHalf,0,>
 
halve,2
halve,1,<
 
halve,3
addHalf,1,>
 
halve,4
halve,2,<
 
halve,5
addHalf,2,>
 
halve,6
halve,3,<
 
halve,7
addHalf,3,>
 
halve,8
halve,4,<
 
halve,9
addHalf,4,>
 
// Add 0.5 to the right
addHalf,0
jump,5,<
 
addHalf,1
jump,6,<
 
addHalf,2
jump,7,<
 
addHalf,3
jump,8,<
 
addHalf,4
jump,9,<
 
// Jump back
jump,0
halve,0,<
 
jump,1
halve,1,<
 
jump,2
halve,2,<
 
jump,3
halve,3,<
 
jump,4
halve,4,<
 
// If we halved successfully, we first remove the zero if there is one and then we go back
halve,_
removezero,_,>
 
removezero,0
removezero,_,>
 
removezero,1
goBack,1,>
 
removezero,2
goBack,2,>
 
removezero,3
goBack,3,>
 
removezero,4
goBack,4,>
 
removezero,5
goBack,5,>
 
removezero,6
goBack,6,>
 
removezero,7
goBack,7,>
 
removezero,8
goBack,8,>
 
removezero,9
goBack,9,>
 
// qfinished
removezero,_
qfin,_,>
 
// normal goBack
goBack,0
goBack,0,>
 
goBack,1
goBack,1,>
 
goBack,2
goBack,2,>
 
goBack,3
goBack,3,>
 
goBack,4
goBack,4,>
 
goBack,5
goBack,5,>
 
goBack,6
goBack,6,>
 
goBack,7
goBack,7,>
 
goBack,8
goBack,8,>
 
goBack,9
goBack,9,>
 
// rest
goBack,_
rest,_,<
 
rest,0
rest0,_,>
 
rest0,_
setrest0,_,>
 
rest,5
rest1,_,>
 
rest1,_
setrest1,_,>
 
setrest0,0
setrest0,0,>
 
setrest0,1
setrest0,1,>
 
setrest1,0
setrest1,0,>
 
setrest1,1
setrest1,1,>
 
setrest0,_
continue,0,<
 
setrest1,_
continue,1,<
 
// continue
continue,0
continue,0,<
 
continue,1
continue,1,<
 
continue,_
continue2,_,<
 
// delimiter
continue2,_
halve,0,<
