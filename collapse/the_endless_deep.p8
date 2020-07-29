pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include maths.lua
#include vec.lua
#include poly.lua
#include palettes.lua

cors={}

function _init()
	dt,t,tf=1/30,0,0

	cls(7)
end

function _update()
	--cls()
   t,tf=t+dt,tf+1

	foreach(cors, coresume)

	mc=vec(64,64)
	mr=64

	bk=16
	hx=1
	hy=1
	for i=1,35+sin(t/16)*25 do
	    ox=rnd(128+bk)-8
	    oy=rnd(128+bk)-8
		rectfill(ox,oy,ox+bk-1,oy+bk-1,2)
	end

	bk=8
	hx=1
	hy=1
	if rnd(1)<0.25 then
		nump=2+rnd(2)
		points={}
		for s=1,nump do
			local p = vec(rnd(128+32)-16,rnd(128+32)-16)
			add(points,p)
		end
		polyv(points,vec(),((t)%#paltbl)+1)
	end
	
	for i=1,3.5+sin(t/12)*2 do
		nump=8+rnd(4)

		points = {}
		ang,r = rnd(1), sqr(rnd(sqrt(mr)))
		for p=1,nump do
			ang,r=ang+rnd(0.125)+t/16, (r+sin(t/8)*4+4)
			local p = vec.frompolar(ang,r)
			add(points,p)
		end

		polyp(points,mc,((t+r/8*(cos(t/16)+1.2)/2)%#paltbl)+1)
	end

	xx=flr(tf/2)*4%128
	yy=64*(sin(t/8)+1)/2
	line(xx,yy,xx,128-yy,((t)%#paltbl)+1)
end

--------------------------------------------

-- === ff8peg ===

-- bk=8
-- hx=1
-- hy=1
-- for i=1,50 do
--     ox=rnd(128+bk)-8
--     oy=rnd(128+bk)-8
--     for y=oy,oy+bk-1,hy do
--         for x=ox,ox+bk-1,hx do
--             c=x/16+y/16+t
--             pset(x,y,c)
--         end
--     end
-- end
