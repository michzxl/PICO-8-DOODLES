pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--sketch
--micheal @???

t=1

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
}
for i=1,14 do
	pal(i,p[i],1)
end

cls()
::♥::
t+=0.01

for i=1,250 do
	x=rnd(128)
	y=rnd(128)
	
	c=sin(x/64)+sin(y/64)
	c=c%(t*2) 
	c=c+2*t --move it
	c=2*13*abs((c/16%1)-1/2)-13/2+7.5
	c=flr(c)
	c=c%14+1 -- [1,14]
	
	
	circ(x,y,1,c)
end

flip()goto ♥
