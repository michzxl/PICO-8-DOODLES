pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function fflr(a,unit)
	return flr(a/unit)*unit
end

t=0
cls()

rh={[0]=0,1,2,2}

for i=0,7 do
	pal(i,i+8+128,1)
end

::♥::
t+=1/30

for i=1,1200 do
	local x,y=rnd(128),rnd(128)
	local xx=abs(sin(x/128)+sin(y/128))

	local c = (x+16)/(y+16) + t/3
	local diff = c%2 - flr(c%2)
	
	c=6*flr(c%2)
	c=c + x/16+y/16-t
	c=flr(c)+3*flr(xx)*(x/64-y/64-t/8)

	c=c%8+8
	if diff<(0.25-x/800) or (xx>=1 and (1.5*(xx-1))<(0.5)) then
		c=c-8
	end
	
	circ(x,y,1,c)
end

flip() goto ♥
