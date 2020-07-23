pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
dt=1/30
t=0

cls()
::♥::
t+=dt

for i=1,1000 do
	x,y=rnd(128),rnd(128)
	xa,ya=x-64,y-64

	c=sin(y/147-t/4)
	  *x/64
	  *cos(x/64-t/2)
	  *y/128
	 +(-x/32+y/32)
	
	c=flr(c%2)*7
	circ(x,y,1,c)
end

flip()goto ♥
