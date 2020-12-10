pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--sketch
--micheal @???

t=0

p={
	7,
	7+128,
	10,
	10+128,
	11,
	11+128,
	3,
	3+128,
	1,
	1+128,
	3,
	11,
	10,
	7+128
}
for i=1,14 do
	pal(i,p[i],1)
end

rectfill(0,0,128,128,1)
::♥::
t+=0.01

for i=1,500 do
	x=rnd(128)
	y=rnd(128)
	
	c=sin(sin(x/64-t/5) / (2.5*sin(t/10))) 
		 +sin(sin(y/64-t/10) / (2.5*sin(t/8)))
	c=c%(t*2)
	c=c+2*t --move it
	c=c%14+1 -- [1,14]
	
	circ(x,y,1,c)
end

flip()goto ♥
