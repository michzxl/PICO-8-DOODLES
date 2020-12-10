pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--sketch
--micheal @???

#include _vec.lua

function render_background()
	for i=1,50 do
		ox,oy = rnd(128+bk)-8,rnd(128+bk)-8
		for y=oy,oy+bk-1,2 do
			for x=ox,ox+bk-1,1.8 do

				c=sin(x/64)+sin(y/64)
				c=c%(t*2) 
				c=c+2*t --move it

				c=c+cos((x+32)/(y+32) + sin(t/8))
				 -sin(-(128-x+32)/(128-y+32) - sin(t/8))

				c=2*13*abs((c/16%1)-1/2)-13/2+7.5
				c=flr(c)
				c=c%14+1 -- [1,14]

				pset(x,y,c)
			end
		end
	end
end

function lerp_ang(a,b,t,p)
	a=a%p
	b=b%p
	if b-a>p/2 then
		b=b-p
	elseif a-b>p/2 then
		a=a-p
	end
	return a + t*(b - a)
end

function pos_points()
	local k = (o.num-1)/2*o.width
	for i=0,o.num-1 do
		l = -k + i*o.width
		local pos = o.pos + o.pos:perp():norm(l)
		add(o.pts, pos)
	end
end

function sample(x,y)
	local x,y = flr(x),flr(y)
	local sum = 
		 pget(x,y)
		+pget(x-1,y)
		+pget(x+1,y)
		+pget(x,y-1)
		+pget(x,y+1)
		+pget(x-1,y-1)
		+pget(x+1,y+1)
		+pget(x-1,y+1)
		+pget(x+1,y-1)
	return sum/9
end

t=0
bk=8

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

o={
	pos=vec(64-16, 128),
	opos=vec(64,128),

	num=5,
	width=8,
}
pos_points()

cls()
::♥::
t+=0.01

o.vel = vec.frompolar(0.25 + 0.01*cos(t/3) + 0.05*sin(t), 2)
o.opos = o.pos
o.pos = o.pos + o.vel
o.pos.y = (o.pos.y+8)%(128+16) - 8

for i=0,o.num-1 do
	local pt = o.pos + o.vel:perp():norm(16-i*5)

	c=t*8+i
	c=2*13*abs((c/16%1)-1/2)-13/2+7.5
	c=flr(c)
	c=c%9+2 -- [1,14]
	circfill(pt.x,pt.y,1,c)
end

render_background()

flip()goto ♥ 
