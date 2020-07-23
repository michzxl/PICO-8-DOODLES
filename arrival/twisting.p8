pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
t=0

cls()
::♥::
t+=1/30

for i=1,1000 do
	r1=sqrt(rnd(
		128*6*10 * (2*sin(sin(t/8)) + 2.5)
	))
	r2=rnd(128)

	r1,r2 = r1-64,r2-64
	x=r1*cos(t)-r2*sin(t)
	y=r1*sin(t)+r2*cos(t)

	c = sin(y/147-t/4) * x/16
	  + cos(x/64 -t/2) * y/32
	c=flr(c%2)*7

	circ(x+64,y+64,1,c)
end

flip()goto ♥
