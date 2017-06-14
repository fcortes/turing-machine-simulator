//Author: Gabriel Alvarez
// Simulator: https://turingmachinesimulator.com
// Initial state: qinit
// Accepting state: qfin
// Whole alphabet: 0,1,o,i

// Comments: We duplicate the size of
// a binary string by concatenating
// the string to its mirror image.
// i/o will be used as "markers" for
// the squares with 1's and 0's
// (respectively).

name: Duplicate binary string
init: qinit
accept: qfin

qinit,0
qinit,0,>

qinit,1
qinit,1,>

qinit,o
qinit,0,>

qinit,i
qinit,1,>

qinit,_
copying_from_right_to_left,_,<

//We place a marker (o/i) over the
//first number found. We ignore the
//squares already marked
copying_from_right_to_left,0
copying_0_to_the_right,o,>

copying_from_right_to_left,1
copying_1_to_the_right,i,>

copying_from_right_to_left,o
copying_from_right_to_left,o,<

copying_from_right_to_left,i
copying_from_right_to_left,i,<

//If we find a blank square -->
//we copy our value (marked) and
//come back
copying_0_to_the_right,_
copying_from_right_to_left,o,<

copying_1_to_the_right,_
copying_from_right_to_left,i,<

//If we find a non-blank square -->
//we ignore it and keep moving right
copying_0_to_the_right,0
copying_0_to_the_right,0,>

copying_0_to_the_right,1
copying_0_to_the_right,1,>

copying_0_to_the_right,o
copying_0_to_the_right,o,>

copying_0_to_the_right,i
copying_0_to_the_right,i,>

copying_1_to_the_right,0
copying_1_to_the_right,0,>

copying_1_to_the_right,1
copying_1_to_the_right,1,>

copying_1_to_the_right,o
copying_1_to_the_right,o,>

copying_1_to_the_right,i
copying_1_to_the_right,i,>

//When we finished copying the whole
//string --> it's time to remove the
//markers
copying_from_right_to_left,_
removing_the_markers,_,>

removing_the_markers,o
removing_the_markers,0,>

removing_the_markers,i
removing_the_markers,1,>

removing_the_markers,0
removing_the_markers,0,<

removing_the_markers,1
removing_the_markers,1,<

removing_the_markers,_
qfin,_,>
