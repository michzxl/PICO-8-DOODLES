pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
dt=1/30
t=0

kk=128*128

pal(1,7,1)
pal(2,0,1)

cls()
::♥::
t+=dt

for i=1,1000 do
	x=sqrt(rnd(kk))
	y=sqrt(sqrt(rnd(kk))*164)-16

	c=x/64 * sin(y/147-t/4)
	 +(-x/32+y/32)
	c%=2

	circ(x,y,1,c)
end

flip()goto ♥
