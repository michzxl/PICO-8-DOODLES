pico-8 cartridge // http://www.pico-8.com
version 30
__lua__

#include vec.lua
#include tex.lua
#include _2_util.lua
#include subpixel2.lua

local t=rnd(100)
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
	[0]=0,
	8,
	11+128,
	10,
	12+128,
	14,
	12,
	7
},1)

function _init()
	ttonum(torus)

	tet = {
		v = {
			vec(1, 1, 1),
			vec(ヌ☉★1, ヌ☉★1, 1),
			vec(ヌ☉★1, 1, ヌ☉★1),
			vec(1, ヌ☉★1, ヌ☉★1),
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
		+ vec(ヌ☉★1, ヌ☉★1, 1)
		+ vec(ヌ☉★1, 1, ヌ☉★1)
		+ vec(1, ヌ☉★1, ヌ☉★1)
	avg = tot / 4
end

function _update()
	t+=1/30
	cls()

	local x,y
	x=64
	y=64

	local f = circfill

	g = gen()

	for j=0,4 do
		if rnd(1)<0.02 then
			fillp(rnd(36000)\1+0b0.1)
		else
			fillp()
		end

		local vs = {}
		local sides = 8
		local r_ = 32
		for i = 1,sides do
			local ii = i / sides
			local ang = ii + t/8 + abs(0.1*sin(t/8+i/sides/2))
			local r = r_+16*sin(j/4+t/8+i/6)
			local v = vec.frompolar(ang,r)
			if rnd(1)<0.01 then v += vec(rnd(32)-16,rnd(32)-16) end
			vs[i] = v
		end
		vs[sides+1] = vs[1]

		for i=1,sides do
			local p1 = vs[i]
			local p2 = vs[i+1]
			line(p1.x+64+8*cos(j/8+t/16),p1.y+64+8*sin(j/8+t/16),p2.x+64+8*cos(j/8+t/16),p2.y+64+8*sin(j/8+t/16),7)
		end

		g()
		polyfill(vs,vec(64,64),15)
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
	sum=0
	count=(width*2+1)*(width*2+1)

	for xa=x-width,x+width,1 do
		for ya=y-width,y+width,1 do
			sum=sum+pget(xa,ya)
		end
	end

	return sum/count
end
