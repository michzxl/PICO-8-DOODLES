pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include palettes.lua
#include maths.lua
#include poly.lua
#include vec.lua

-- basic template
function _init()
	poke(0x5f2d, 1)--enable mouse

	medium_rare={
		1+128,
		1,
		2+128,
		8+128,
		8,
		14+128,
		15+128,
		15,
		7,
	}
	pal(medium_rare, 1)

	scrw = 128
	scrh = 128

	scrw2 = 64
	scrh2 = 64

	circs = {}

	x_x,x_y = 32,32

	weird = 3

	dt=1/30
	t=0

	cosa={}
	sina={}

	k=64

	mod=false

	for ang=0,1-1/k,1/k do
		cosa[ang]=cos(ang)
		sina[ang]=sin(ang)
	end

	for cir=0,7 do
		r=cir*(sin(sin(t/16))*4+10)
		circs[cir]={}
		local circ=circs[cir]

		for ang=0,1-1/k,1/k do
			local x=scrw2 + r*cos(ang)
			local y=scrh2 + r*sin(ang)
			add(circ, {x,y})
		end
	end

	cls()
end

function _update()
	--cls()
	t+=dt
	-- true during the last 8 seconds of each 16-sec interval
	mod = t % 16 > 8

	-- draw a centered rectangle with color 0
	if chn(0.5) then
		local x, y = rnd(scrw2/4), rnd(32)+16
		rectfill(x, y, scrw - x, scrh - y, 0)
	end

	local num = 8 + 2*sin(t/8)
	for i=0,1,1/num do
		local nr = 32

		local ang = i + sin(t/16)/2 + t/4
		local r = nr-4 + sin(t/8 + ang)*8

		local n = flr(i*(num))%num
		local mod = n%2==0 and 1 or -1

		local x,y = r*cos(ang),r*sin(ang)

		local cr_ang = ang + mod*sin(ang/4+t/8)
		if n==weird%num then cr_ang = rnd(1) end
		local cr_r = 4
		local ca,sa = cr_r*cos(cr_ang), cr_r*sin(cr_ang)

		line(64+x+ca,64+y+sa,64+x-ca,64+y-sa,10)

		cr_ang = cr_ang + 0.25
		if n==weird then cr_ang = rnd(1) end
		local ca,sa = cr_r*cos(cr_ang), cr_r*sin(cr_ang)

		line(64+x+ca,64+y+sa,64+x-ca,64+y-sa,10)	
	end

	if chn(0.01) then weird = rnd(num*2)%num end

	do
		x,y = 0,rnd(scrh)
		while x <= scrw do
			nx = x + rnd(24) - 8
			ny = y + rnd(16) - 8

			line(x, y, nx, ny, palettewave(x/16+t*4,medium_rare,16))

			x = nx
			y = ny
		end
	end

	do
		x_x, x_y = (x_x+(rnd(3)-1))%64, (x_y+(rnd(3)-1))%64
		local x,y = x_x,x_y
		line(x,y,128-x,128-y,1)
		line(182-x,y,x,128-y,1)
	end

	for i = 1, 500 do
		local x, y = rnd(240), rnd(136)
		local p

		-- y=(scrh/scrw)*x is a line from top-left to bottom-right
		if y < (scrh / scrw * x) then
			-- left vs right half of screen:
			if x < scrw / 2 then
				p = pget(x - 1, y + 2)
				circ(x, y, 1, p)
			else
				p = pget(x - 2, y - 1)
				circ(x, y, 1, p)
			end
		else
			if x > scrw / 2 then
				p = pget(x + 1, y - 2)
				circ(x, y, 1, p)
			else
				p = pget(x + 2, y + 1)
				circ(x, y, 1, p)
			end
		end
	end

	-- draw a centered, randomly size circle sometimes
	if chn(0.2) then
		circ(scrw2, scrh2, rnd(64), rnd(10))
	end

end

function chn(prob)
	return rnd(1)<prob
end

function palettewave(x, palette, period)
	return ctriwave(x, #palette/2+1.1, #palette-1.2, period)
end
