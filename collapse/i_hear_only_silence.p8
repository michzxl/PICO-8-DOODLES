pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- basic template

#include maths.lua
#include poly.lua
#include vec.lua
#include subpixel.lua

palettes={
	{
		3+128,
		1+128,
		1,
		12+128,
		12,
		7,
	},{
		1+128,
		1,
		3+128,
		3,
		11+128,
		11,
		10+128,
		10,
		7+128,
		7,
	},{
		3+128,
		1+128,
		1,
		2+128,
		8+128,
		8,
		14+128,
		15+128,
		15,
		7,
	},{
		0,
		0,
		7,
		7,
	},{
		2+128,
		2,
		8+128,
		8,
		9+128,
		9,
		10,
		7+128,
		7,
	},{
		0+128,
		2+128,
		13+128,
		5,
		6+128,
		6,
		7,
	}
}

function _init()
	t=0

	poke(0x5f2e,1)

	cls()
	pal(palettes[6],1)
end

function _update()
	--cls()
	t+=1/30

	if t%4>2 then
		fillp(0b1111000011110000.1)
		circfill(64,64,rnd(48),0)
		fillp()
	end

	for i=1,300 do
		local ang1,r1 = rnd(1),64
		local x1,y1 = r1*cos(ang1)+64,r1*sin(ang1)+64

		
		pset(x1,y1,mid(0,7,pget(x1,y1)+1))
	end
	
	fillp(0b1010010110100101.1)
	for i=1,300 do
		local ang1,r1 = rnd(1),sqrt(rnd(68*68))
		local x,y = r1*cos(ang1)+64,r1*sin(ang1)+64
		local c = boxblur(x,y,1)
		circ(x,y,1,c)
	end
	fillp()

	for i=1,500 do
		local ang1,r1 = rnd(1),64+(rnd(5*5))
		local ang2,r2 = ang1, r1 + 1.2
		local x1,y1 = r1*cos(ang1)+64,r1*sin(ang1)+64
		local x2,y2 = r2*cos(ang2)+64,r2*sin(ang2)+64

		circ(x2,y2,1,
			mid(0,7,pget(x1,y1) + (rnd(1)<0.5 and -1 or 0) )
		)
	end

	s = 64
	si = 16+15.99*sin(t/8)
	sii = s - si

	local ps = {}
	if si==0 then
		ps = {
			vec(0,0),
			vec(s,0),
			vec(s,s),
			vec(0,s),
		}
	else
		ps = {
			{
				vec(si,0),
				vec(sii,0),
				vec(sii,si),
				vec(si,si),
			},
			{
				vec(sii,si),
				vec(s,si),
				vec(s,sii),
				vec(sii,sii),
			},
			{
				vec(si,sii),
				vec(sii,sii),
				vec(sii,s),
				vec(si,s),
			},
			{
				vec(0,si),
				vec(si,si),
				vec(si,sii),
				vec(0,sii),
			},
			{
				vec(si,si),
				vec(sii,si),
				vec(sii,sii),
				vec(si,sii),
			}
		}
	end
	for p in all(ps) do
		foreach(p, function(v)
			v:set(v - vec(s/2,s/2))
		end)
	end

	local rot_ps = rotate_ps(ps, vec(
		0,
		0,
		-t/8
	))

	fillp(0b1010010110100101.1)
	foreach(rot_ps, function(p) 
		polyv(p, vec(64,64), 7)
		if rnd(1)<0.003 then
			polyf(p, vec(64,64), 7)
		end
	end)
	fillp()
end

function rotate_ps(ps, angs)
	local ux,uy,uz = vec.u_rot_yxz(angs)

	local rot_ps = {}
	for ty=1,#ps do
		local row = ps[ty]
		rot_ps[ty] = {}
		for tx=1,#ps[1] do
			local v = ps[ty][tx]

			w = ux*v.x + uy*v.y + uz*v.z

			rot_ps[ty][tx] = w
		end
	end

	return rot_ps
end

function boxblur(x,y,width)
	sum=0
	count=(width*2+1)*(width*2+1)

	for xa=x-width,x+width,1 do
		for ya=y-width,y+width,1 do
			sum=sum+pget(xa,ya)
		end
	end

	return sum/count
end
