// Possible (not yet proved to be) 5-state Busy Beaver

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
