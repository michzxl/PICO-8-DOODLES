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

for i=1,1000 do
	x,y=rnd(128),rnd(128)
	xx=abs(sin(x/128)+sin(y/128))

	c = (x+16)/(y+16) + t/3
	tmp1 = c%2 - flr(c%2)
	
	c=6*flr(c%2)
	c=c + x/16+y/16-t
	c=flr(c)+3*flr(xx)

	c=c%8+8
	if rnd(1)>3*tmp1 or (xx>=1 and rnd(1)>1.5*(xx-1)) then
		c=c-8
	end
	
	circ(x,y,1,c)
end

flip() goto ♥
