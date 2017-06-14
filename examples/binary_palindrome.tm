// Input: a binary number n
// Ouput: accepts if n is a palindrome
// Example: accepts 10101
//
// Palindrome Algorithm
// for Turing Machine Simulator 
// turingmachinesimulator.com
//
// --------- States -----------|
// qCopy - copy to second tape |
// qReturn - return first tape |
// qTest - Test each character |
// qaccept - accepting state   |
//-----------------------------|

name: Fast binary palindrome
init: qCopy
accept: qAccept

qCopy,0,_
qCopy,0,0,>,>

qCopy,1,_
qCopy,1,1,>,>

qCopy,_,_
qReturn,_,_,-,<

qReturn,_,0
qReturn,_,0,-,<

qReturn,_,1
qReturn,_,1,-,<

qReturn,_,_
qTest,_,_,<,>

qTest,0,0
qTest,0,0,<,>

qTest,1,1
qTest,1,1,<,>

qTest,_,_
qAccept,_,_,-,-
