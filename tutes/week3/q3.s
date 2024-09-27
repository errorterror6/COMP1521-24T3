
    int u;
    int v = 42;
    char w;
    char x = 'a';
    double y ;
    int z[20]; 
    char a[40] = {0};
    int b[4] = {1, 2, 4, 5}
	.data
	#global variables, string literals, arrays go here!!
u:
	.space 	4 
v:
	.word 	42
w:
	.space	1
x:
	.byte	'a'
y:
	.space	8
z:
	.space	20*4
a:
	.byte	0:40
b:
	.word  1, 2, 4, 5