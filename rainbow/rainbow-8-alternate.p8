pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include vec.lua
#include maths.lua
#include poly.lua

points={}

function _init()
	t,dt,tf=0,1/30,0

	for i=0,7 do
		pal(i,i+8+128,1)
	end
	
	cls()
end

function _update()
	t+=dt
	tf+=1

	ct8=cos(t/8)
	ct16=cos(t/16)
	k=64 + 8*ct16
	refresh = rnd(1)<0.2
	height = 5 + sin(t/8)*3

	for i=1,1000 do
		local ox,oy=rnd(128),rnd(128)
		
		local x=ox-32+16*ct16
		local y=oy-32+32*ct16

		local ang=atan2(x,y,ox,oy)

		c=(dist(x,y,0,0)%k
		)/32 - t/2 + flr(ang*(6-sin(t/16))+t/3) + ang*(4+1*ct16)+t/3

		c=c%8+8
		local diff=c-flr(c)
		if diff<0.5+0.4*ct8 or (ang-t/32)%0.2<0.1 then
			c = c-8
		end
		
		circ(ox,oy,1,c)
	end

	cen = vec(3*cos(t/8),3*cos(t/8))

	if refresh then
		ang=rnd(0.1)+t/4
		r=rnd(8)+16
		points={}
		for i=0,1,rnd(0.15)+0.2 do
			local a=ang + i + (sin(t/8)+1)/2*rnd(1)
			local p = vec.frompolar(a,r+rnd(2)-1)
			add(points, p)
		end
	end

	polyf(points,vec(64,64+height)+cen,0)
	for i=1,height do
		polyv(points,vec(64,64+i)+cen,0)
	end
	polyv(points,vec(64,64)+cen,8)
end

-->8
function dist(x1,y1,x2,y2)
	return sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
end
