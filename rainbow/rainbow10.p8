pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include maths.lua
#include vec.lua
#include poly.lua

function drw_player_moving(self)
	local v = t/8
	local r = 12
	local aa = (63/64)*v
	local a = aa + t/12
	local va = -t
	local angs = vec(aa/1.2, -aa/2,a/4)

	local polys,points = polly.cube(r*2)

	local ux,uy,uz = angs:u_rot_yxz()
	foreach(points, function(p) 
		p:set( ux*p.x + uy*p.y + uz*p.z )
	end)

	for key,pol in ipairs(polys) do
		local normal = polly.normal(pol)
		if normal.z>0 then
			local light = -normal.y

			local fill_col = v*4 + -8*flr(light) + t*2 - light
			local bord_col = (fill_col-8)

			polyf(pol, vec(64,64), fill_col)
			polyv(pol, vec(64,64), bord_col)
		end
	end
end

for i=0,7 do
	pal(i,i+8+128,1)
end

function _init()
	dt=1/30
	t=0
   tf=0

	cls()
end

function _update()
	--cls()
    t+=dt
    tf+=1

	for i=1,1000 do
		local v = vec(rnd(128)-64,rnd(128)-64)
		local ang,r = v:polar()

		local c = 
			  (ang*(8 - r/64) + t/32)
			+ r\8*8
			+ flr( r\8*0.01 - t/4 + ang*11) 
			+ t/4
		
		diff = c - flr(c)

		if 0.2<diff and diff<0.24 then
			c = c + 8
		elseif diff<0.33 then
			c = (c - 8)%8
		end
	

		circ(v.x+64,v.y+64,1,c)
	end

	drw_player_moving()
end
