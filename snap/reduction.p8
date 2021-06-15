pico-8 cartridge // http://www.pico-8.com
version 30
__lua__

#include vec.lua
#include tex.lua
#include _2_util.lua
#include subpixel2.lua

local t=0
orot = 0

local gen = (function()
	local i=0
	return function()
		i=i+1
		if i%3==0 then
			poke(0x5f5e, 0b11110001)
		elseif i%3==1 then
			poke(0x5f5e, 0b11110010)
		else
			poke(0x5f5e, 0b11110100)
		end
	end
end)

pal({
	[0]=1+128,
	8+128,
	3,
	4,
	12+128,
	2,
	3+128,
	6+128,
},1)
pal(15,7,1)
pal(14,14+128,1)
pal(13,3+128,1)

local boxes = {}


function _init()
	ttonum(torus)

	tet = {
		v = {
			vec(1, 1, 1),
			vec(-1, -1, 1),
			vec(-1, 1, -1),
			vec(1, -1, -1),
		},
		l={
			{1,2},
			{2,3},
			{3,4},
			{1,4},
			{1,3},
			{2,4},
		},
		f={
			{1,2,3, },
			{1,2,  4},
			{1,  3,4},
			{  2,3,4},
		},
	}
	local tot =
		  vec(1, 1, 1)
		+ vec(-1, -1, 1)
		+ vec(-1, 1, -1)
		+ vec(1, -1, -1)
	avg = tot / 4

	genboxes()

	cls()
end

function _update()
	t+=1/30
	--	cls()

	poke(0x5f5e, 0b11111111)
	for i=1,8 do
		local x,y=rnd(128),rnd(128)
		rectfill(x,y,x+32,y+32,0)
	end

	local x,y
	x=64
	y=64

	local g = gen()

	local shape = {}
	local sides = 32
	local r_ = 32
	for i=1,sides do
		local ii = i / sides
		local ang = ii + t/16 + 0.1*sin(t/4+i/sides)
		local r = r_
		r = (r-16)%80+16
		r = r + (i%2*8*r/32)
		local v = vec.frompolar(ang,r)
		add(shape, v)
	end
	add(shape,shape[1])

	--poke(0x5f5e, 0b111111111)

	for i=1,#shape-1 do
		local v1 = shape[i] + vec(64,64)
		local v2 = shape[i+1] + vec(64,64)
		if i%4==0 then g() end
		poke(0x5f5e, 0b11111111)
		line(v1.x,v1.y,v2.x,v2.y,14)
	end

	local shape = {}
	local sides = 4
	local r_ = 32
	for i=1,sides do
		local ii = i / sides
		local ang = ii + t/16 + 0.1*sin(t/4+i/sides)
		local r = r_
		r = (r-16)%80+16
		r = r
		local v = vec.frompolar(ang,r)
		add(shape, v)
	end
	add(shape,shape[1])

	--poke(0x5f5e, 0b111111111)

	--polyfill(shape,vec(64,64),13)

	for i=1,#shape-1 do
		local v1 = shape[i] + vec(64,64)
		local v2 = shape[i+1] + vec(64,64)
		if i%4==0 then g() end
		poke(0x5f5e, 0b11111111)
		line(v1.x,v1.y,v2.x,v2.y,14)
	end

	local f = circfill

	updboxes()

	drwboxes()

	if rnd(1)<0.02 then
		genboxes()
	end


	--

	local us = vec(-t/8, t/12, -t/8):u_rot_yxz()
	local scale = vec.one()*16
	local trans = vec(64,64,0)

	local vs = {}
	for v in all(tet.v) do
		local v = v - avg
		local nv = us:dot(v:scale(scale)) + trans

		add(vs,nv)
	end
	local g = gen()
	for f in all(tet.l) do
		local buf = {}
		for vi in all(f) do
			add(buf, vs[vi])
		end

		poke(0x5f5e, 0b11111111)
		--g()

		local a,b = buf[1],buf[2]
		line(a.x,a.y,b.x,b.y,    15)
		line(a.x+1,a.y,b.x+1,b.y,15)
		line(a.x-1,a.y,b.x-1,b.y,15)
		line(a.x,a.y+1,b.x,b.y+1,15)
		line(a.x,a.y-1,b.x,b.y-1,15)
	end

	g()
end

function genboxes()
	local bs = {}
	for i=1,5 do
		local xo,yo = 32,32
		local b = {
			x=rnd(128-xo)+xo/2,
			y=rnd(128-xo)+xo/2,
			dir=rnd(1),
			l=rnd(16)+8,
			w=rnd(8)+8
		}
		add(bs,b)
	end
	boxes = bs
end

function updboxes()
	local i1 = flr(rnd(#boxes))+1
	local box1 = boxes[i1]
	local i2 = flr(rnd(#boxes-1))+1
	local box2 = boxes[i2]
	if i2==i1 then
		box2 = boxes[#boxes]
	end

	local b1p = vec(box1.x,box1.y)
	local b2p = vec(box2.x,box2.y)

	if not box1.d then box1.d = (b2p-b1p):magn() end

	local pos = b2p
	local dif = b1p - b2p
	local d = lerp(dif:magn(),64,0.05)
	dif = dif:norm(d)
	box1.d = d
	local newpos = pos + dif
	box1.x,box1.y = newpos:xy()
end

function drwboxes()
	local g = gen()
	for box in all(boxes) do
		local pos = vec(box.x,box.y) + vec(rnd(1)*sin(t/8),rnd(1)*sin(t/8))
		local dir = vec.frompolar(box.dir+rnd(0.025*(sin(t/8+box.x/256)*0.5+0.5)),1)
		local prp = dir:perp()
		local l,w = box.l,box.w

		local p1 = pos + dir*l + prp*w
		local p2 = pos - dir*l + prp*w
		local p3 = pos - dir*l - prp*w
		local p4 = pos + dir*l - prp*w

		g()
		line(p1.x,p1.y,p2.x,p2.y,15)
		line(p2.x,p2.y,p3.x,p3.y,15)
		line(p3.x,p3.y,p4.x,p4.y,15)
		line(p4.x,p4.y,p1.x,p1.y,15)
		trifill(p1,p2,p3,15)
		trifill(p1,p3,p4,15)

		local p1 = pos + dir*l + prp*w + dir*l*(1.75+0.25*sin(t/8+box.x/128))
		local p2 = pos - dir*l + prp*w + dir*l*(1.75+0.25*sin(t/8+box.x/128))
		local p3 = pos - dir*l - prp*w + dir*l*(1.75+0.25*sin(t/8+box.x/128))
		local p4 = pos + dir*l - prp*w + dir*l*(1.75+0.25*sin(t/8+box.x/128))

		g()
		line(p1.x,p1.y,p2.x,p2.y,15)
		line(p2.x,p2.y,p3.x,p3.y,15)
		line(p3.x,p3.y,p4.x,p4.y,15)
		line(p4.x,p4.y,p1.x,p1.y,15)
		trifill(p1,p2,p3,15)
		trifill(p1,p3,p4,15)
	end
end

function ttonum(obj)
	for k,e in pairs(obj) do
		if type(e)=="table" then
			ttonum(e)
		elseif type(e)=="string" then
			obj[k] = tonum(e)
		end
	end
	return obj
end

function boxblur(x,y,width)
	local sum=0
	local count=(width*2+1)*(width*2+1)

	for xa=x-width,x+width,1 do
		for ya=y-width,y+width,1 do
			sum+=pget(xa,ya)
		end
	end

	return sum/count
end
