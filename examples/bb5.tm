// 5-state Busy Beaver
// https://discuss.bbchallenge.org/t/july-2nd-2024-we-have-proved-bb-5-47-176-870/237

name: 5 State Busy Beaver
init: a

a,_
b,1,<

b,_
c,1,<

c,_
d,1,<

d,_
a,1,>

e,_
halt,1,>

a,1
c,1,>

b,1
b,1,<

c,1
e,_,>

d,1
d,1,>

e,1
a,_,>
