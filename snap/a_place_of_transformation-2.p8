pico-8 cartridge // http://www.pico-8.com
version 30
__lua__

#include vec.lua
#include tex.lua
#include _2_util.lua

#include _15_util.lua
#include _15_text.lua

t=13
orot = 0
pal({[0]=0,8,11+128,10,12+128,14,12,},1)

dots = {}

function _init()
	ttonum(torus)
	tet = {
		v = {vec(1, 1, 1),vec(ヌ☉★1, ヌ☉★1, 1),vec(ヌ☉★1, 1, ヌ☉★1),vec(1, ヌ☉★1, ヌ☉★1),},
		l={{1,2},{2,3},{3,4},{1,4},{1,3},{2,4},},
		f={{1,2,3, },{1,2,  4},{1,  3,4},{  2,3,4},},
	}
	local tot = vec(1, 1, 1) + vec(ヌ☉★1, ヌ☉★1, 1) + vec(ヌ☉★1, 1, ヌ☉★1) + vec(1, ヌ☉★1, ヌ☉★1)
	avg = tot / 4
end

function _update()
	t+=1/30

	if t%16<8 then cls() end

	if t%16<2 then
		circinv(64,64,(t%16)*50,4,4,0)
	end

	if #dots<100 then
		add(dots,{
			pos=vec(64,64),
			dir=vec.frompolar(rnd(1),1),
			spd=4,
			dmp=0.95,
		})
	end

	drw_gridlines()

	set_transform()
	local vs = transform_obj()

	draw_obj_light(vs)
	draw_obj_dark(vs)

	local x,y = 80+32*cos(t/4),40+32*sin(t/4)
	circfill(x,y,6+cos(t/2),0)

	if t%16>13 and t%16<15.5 then
		draw_lightning()
	end

	rectfill(1,1,126,2,0)
	rectfill(125,1,126,126,0)
	rectfill(126,126,1,125,0)
	rectfill(2,126,1,1,0)


	if t%16>15.5 then
		draw_grill()
	end

	for dot in all(dots) do
		dot.spd = dot.spd * dot.dmp
		dot.pos:set(dot.pos + dot.dir*dot.spd)
		local p1 = dot.pos
		local p2 = dot.pos + dot.dir*dot.spd*2
		line(p1.x,p1.y,p2.x,p2.y,0)
		if dot.spd<0.1 then
			del(dots,dot)
		end
	end

	draw_text("are", 8, 4,     2, 2, -1/16)
	draw_text("you", 70, 32,   2, 2, 1/24)
	draw_text(",", 75, 60,     2, 2, 1/48)
	draw_text("one", 32, 50,   2, 2, 0-1/64)
	draw_text("?",   110, 110, 2, 2, -1/48)
	draw_text("too", 70, 95,   2, 2, 1/48)

	line(0,0,127,0,7)
	line(127,0,127,127,7)
	line(127,127,0,127,7)
	line(0,127,0,0,7)
end

--[[--====================================
==========================================
--]]--====================================

function set_transform()
	orot += rnd(0.00) + (sin(t/8)+0.5>0 and sin(t/8)*0.025 or 0)
	us = vec(-t/8+orot,t/12 + t/4\0.01*0.01,-t/8):u_rot_yxz()
	scale = vec.one() * (32 + rnd(8)*sin(t/8))
	trans = vec(64,64,0)
end

function drw_gridlines()
	g=gen()
	local max = 20
	local r = 32
	for i=0,max-1 do
		poke(0x5f5e,g())
		local ang = i/max+t/8
		local pos = vec.frompolar(ang,r)
		local dir = pos:norm()*64
		pos += vec(64,64)
		local prp = dir:perp()

		for m=1,0,gcos(t+8,-1,-0.12,16) do
			if rnd(1)<0.975 then
				local p1x,p1y = (pos + dir*m + prp*m):xy()
				local p2x,p2y = (pos - dir*m + prp*m):xy()
				local p3x,p3y = (pos - dir*m - prp*m):xy()
				local p4x,p4y = (pos + dir*m - prp*m):xy()
				line(p1x,p1y,p2x,p2y,15)
				line(p2x,p2y,p3x,p3y,15)
				line(p3x,p3y,p4x,p4y,15)
				line(p4x,p4y,p1x,p1y,15)
			end
		end
	end
end

function transform_obj()
	local vs = {}
	for v in all(tet.v) do
		local v = v - avg
		local nv = us:dot(v:scale(scale)) + trans
		add(vs,nv)
	end
	return vs
end

function draw_cute_rectangle()
	local ti = (t%16-8)/8
	local hh = (t*64-16)%(128)
	local h = min(0,12*sin(ti/1.5))
	if h<0 then
		rectfill(hh,120+h,hh+3,120,0)
	end
end

function draw_lightning()
	local a,r = rnd(1),48
	local v = vec.frompolar(a,r)
	for i=1,64 do
		local na,nr = rnd(0.1)+a,rnd(4)-2.25+r
		local nv = vec.frompolar(na,nr)
		line(v.x+64,v.y+64,nv.x+64,nv.y+64,0)
		a,r,v=na,nr,nv
	end
end

function draw_grill()
	local ti = (t%16-15.5)+0.5
	fillp(0b1010010110100101)
	for x=-8,128,16 do
		line(x,8,x+16,128,0)
	end
	fillp()
end

function draw_obj_light(vs)
	-- draw outline fill
	local g = gen()
	for f in all(tet.f) do
		local buf = {}
		for vi in all(f) do
			add(buf, (vs[vi]-vec(64,64))*2+vec(64,64))
		end
		poke(0x5f5e,g())
		--line(buf[1].x,buf[1].y,buf[2].x,buf[2].y,15)
		trifill(buf[1]*(sin(t/8)*0.1+1),buf[2]*(sin(t/8)*0.1+1),buf[3]*(sin(t/8)*0.1+1),15)
	end
end

function draw_obj_dark(vs)
	-- draw inner black obj
	local g = gen()
	for f in all(tet.f) do
		local buf = {}
		for vi in all(f) do
			add(buf, vs[vi])
		end

		poke(0x5f5e,0b11110001)
		line(buf[1]*(sin(t/8)*0.1+1),buf[2]*(sin(t/8)*0.1+1),buf[3]*(sin(t/8)*0.1+1),0)
		poke(0x5f5e,0b11111111)
		trifill(buf[1]*(sin(t/8)*0.1+1),buf[2]*(sin(t/8)*0.1+1),buf[3]*(sin(t/8)*0.1+1),0)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000077777000077770007777000077777700777777000777700077007700777777000000770077007700770000007700070077007700777777007777700
00777700077007700770077007707700077000000770000007700770077007700007700000000770077077000770000007770770077707700770077007700770
07700770077777000770000007700770077777000777770007700000077007700007700000000770077770000770000007777770077777700770077007700770
07700770077007700770000007700770077000000770000007707770077777700007700000000770077770000770000007707070077777700770077007777700
07777770077007700770077007707700077777700770000007700770077007700007700007700770077077000770000007700070077077700770077007700000
07700770077777000077770007777000077777700770000000777770077007700777777000777700077007700777777007700070077007700777777007700000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700077777000077777007777770077007700770077007700070077007700770077007777770007777000007700000777700007777000000770007777770
07700770077007700777000000077000077007700770077007700070077007700770077000007700077007700077700007700770070007700007770007700000
07700770077007700077770000077000077007700770077007700070000770000077770000077000077077700007700000007700000777000077770007777700
07707770077777000000077000077000077007700777777007707070000770000007700000770000077707700007700000077000000007700770770000000770
07777700077077700000077000077000077007700077770007777770077007700007700007700000077007700007700000770000077007700777777007700770
00770770077007700777770000077000007777000007700007770770077007700007700007777770007777000077770007777770007777000000770000777700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700077777700077770000777700000000000000000000707000000770000070070000000000000000000000000000000000007777000007700000077000
07700000000007700770077007700770000000000000000000707000000770000777777000000000000000000000000000070000077007700007700000077000
07777700000077000077770000777770000000000000000000000000000770000070070000000000000000000077770000070000000077000000000000000000
07700770000770000770077000000770000000000000000000000000000770000070070007777770000000000000000007777700000770000000000000000000
07700770000770000770077000007700000770000007700000000000000000000777777000000000000000000077770000070000000000000007700000077000
00777700000770000077770000777000000770000007700000000000000770000070070000000000077777700000000000070000000770000007700000077000
00000000000000000000000000000000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000770000
00000000000000000077000000007700007777000007777000007700007700001a1a1a1a00000000000000000000000000000000000000000000000000000000
0000007007000000077000000000077000770000000007700007700000077000a077770107777770000770000000000000000000000000000000000000000000
00000700007000000770000000000770007700000000077000770000000077001770077a07777770007777000000000000000000000000000000000000000000
0000700000070000077000000000077000770000000007700770000000000770a000770107777770077007700000000000000000000000000000000000000000
00070000000070000770000000000770077000000000770007700000000007701007700a07777770077007700000000000000000000000000000000000000000
0070000000000700077000000000077007700000000077000077000000007700a000000107777770077777700000000000000000000000000000000000000000
07000000000000700770000000000770077000000000770000077000000770001007700a07777770077007700000000000000000000000000000000000000000
0000000000000000007700000000770007777000007777000000770000770000a1a1a1a100000000000000000000000000000000000000000000000000000000
