pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function ssin(a)
	return sin(sin(a))
end

t=0
cls()

::♥::
t+=1/30

for i=1,1000 do
	r1=sqrt(rnd(
		128*6*10 * (2*ssin(t/8) + 2.5)
	))
	r2=rnd(128)

	-- distribution of x,y is centered at (0,0)...
	r1,r2 = r1-64,r2-64
	x=r1*cos(t)-r2*sin(t)
	y=r1*sin(t)+r2*cos(t)

	c = sin(y/147-t/4) * x/16
	  + cos(x/64 -t/2) * y/32
	c=flr(c%2)*7 -- c -> {0,7} i.e. black-or-white

	-- draw, but adjust center to (64,64)
	circ(x+64,y+64,1,c)
end


flip()goto ♥
