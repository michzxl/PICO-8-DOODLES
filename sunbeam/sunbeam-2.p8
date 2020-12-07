pico-8 cartridge // http://www.pico-8.com
version 19
__lua__

⧗=0
speed=.5

p={7+128,10,9,9+128,8,8+128,
			2,2+128,7,12,12+128,1,1+128}
for i=1,#p do pal(i,p[i],1) end

-- helper func
function t(a)
	return flr(⧗ * a*speed)
end

function sqr(a)
	return a*a
end

rectfill(0,0,128,128,8)
circfill(64,64,52,13)
::⌂::
⧗+=1/60

for i=1,250 do
	x0,y0=rnd(128),rnd(128)
	
	x = abs(x0-64) + 64
	y = y0
	
	c= x/16
	 + (y+⧗*16)/32
	 + x/12 + y/32 + y/64
	
	dist=(sqr(x-64)+sqr(y-64))
	if dist<sqr(40+cos(⧗/8)*20) then
		c=c*-1
		c=c%5+9
	elseif dist<sqr(50+sin(⧗/4)*45) then
		c=rnd(1)<0.99 and 8 or 7
	else
		c=c%8+1
	end
	
	circ(x0,y0,1,c)
end

for i=1,1000 do
	x,y=rnd(128),rnd(128)
	
	p=pget(x-1*sgn(x-64),y+2)
	
	p=p~=0 and p or 8
	
	if rnd(1)<0.0004*(128-y) then
		if rnd(1)<0.5 then
			circfill(x,y,4,p)
		else
			line(x-4,y-4,x+4,y+4,p)
			line(x-4,y-3,x+3,y+4,p)
			line(x-3,y-4,x+4,y+3,p)
			line(x-4,y+4,x+4,y-4,p)
			line(x-4,y+3,x+3,y-4,p)
			line(x-3,y+4,x+4,y-3,p)
		end
	end
	circ(x,y,1,p)
end

flip()goto ⌂