pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include maths.lua
#include vec.lua
#include poly.lua
#include palettes.lua
#include util.lua

function _init()
	dt=1/30
	t=0
	tf=0

	cls()

	fill = 0
end

function _update()
	-- cls()
	t+=dt
	tf+=1

	st4 = sin(t/4)
	st16 = sin(t/16)
	nc = 16 + 15*st16

	do 
		local polys,points = polly.cube(128)
		local angs = vec(t/16, t/9, t/8)

		local ux,uy,uz = angs:u_rot_yxz()
		foreach(points, function(p) 
			p:set( ux*p.x + uy*p.y + uz*p.z )
		end)

		for key,pol in ipairs(polys) do
			local normal = polly.normal(pol)
			if normal.z<1 then
				local light = -normal.y

				-- polyf(pol, vec(64,64), 0)
				polyv(pol, vec(64,64), palettewave(t, palettes[curr_pal], 16))
			end
		end
	end

	fill += pow2(rnd(16))
	bk=8
	for i=1,75 do
		ox=rnd(128+bk)-8
		oy=rnd(128+bk)-8
		local color = 0
		
		if (vec(ox,oy)-vec(64,64)):magn()<40 then
			color = 2
			
		end
		fillp(fill)
		rectfill(ox,oy,ox+bk-1,oy+bk-1,color)
		fillp()
	end

	hr = 9
	if t%8<4 then hr=1.02 end
	hy = 0
	if t%8>4 then hy=tf/2%2 end

	for n=1,nc do
		local cen = vec(
			64 + 16*cos(n/20 + t/2 + nc/32) , 
			64 - 8*cos(cos(n/20 + t/2)/16) + 7*sin(t + n/30)
		)

		local shape = {}
		local sides = 7 + 5 * sin(n/hr + t/2)
		local r = 24 + 16*sin(n/20) - 4*st4
		

		for _i=1,sides do
			local i = (_i-1) / sides
			local ang = i + n*4 + t/2 + hy
			local rf = r + sin(t/8 + ang*2)*8*(st16+1)/2

			add(shape, vec.frompolar(ang,rf))
		end

		polyf(shape,cen,0)
		polyv(shape, cen, palettewave(t+n, palettes[curr_pal], 16))
	end
end

function palettewave(x, palette, period)
	return ctriwave(x, #palette/2+1.1, #palette-1.2, period)
end

function pow2(n)
	local r = 1
	for i=1,n do
		r *= 2
	end
	return r
end
