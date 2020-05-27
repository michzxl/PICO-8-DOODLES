pico-8 cartridge // http://www.pico-8.com
version 21
__lua__

-- round down a to the nearest multiple of unit
function fflr(a, unit)
	return a - a%unit
end

-- palette defined in pairs.
pal({
	[0]=0,7,--black/white (0 omitted)
	2,8+128,
	13+128,13,--lavender
	1,12+128,--blue
	3+128,3,--green
	135,142,--yellow/orange
	8+128,8,--red
	6,7,--white/gray
},1)

t=-1

-- time it takes for the rectangle's movement to repeat.
-- note that at t=k*period/2 (for all int k), the rectangle has area=0
period=4

cls()
::♥::  -- label. goto(♥) takes us back here.
t+=1/60

--cache some shitty trig (which all trig is)
ct4,st2=cos(t/period),sin(t/(period/2))
st16=sin(t/16)
st8=sin(t/8)

-- sampling rate proportional-ish to area of rectangle.
smpl=1200*abs(ct4)
for i=1,smpl do
	xo=rnd(80) - 64 -- [-64,16]
	yo=rnd(150) - 75 -- [-75,75]
	-- distribution of xo,yo is a uniform rectangle.

	x=(xo+32)*st2 - yo*ct4
	y=(xo+32)*ct4 + yo*st2
	-- rotate & scale x,y

	c = -st8 * x/16
	  + cos(x/64 - t/2) * y/32
	  + (xo/32 + yo/32 + y)/(st16*4+12)
	  + t
	
	c = flr(c%2) -- map c to 0 or 1

	-- the color will change each time the rectangle's area=0
	c += fflr(t+1,period/2)
	
	-- draw, adjust center to (64,64)
	circ(x+64,y+64,1,c)
end

-- draw a lil circle to the point where xo,yo=0,0
-- (this traces out the path of the rectangle)
circfill(32*st2+64,32*ct4+64,2,t*16%15+1)

flip() goto ♥
