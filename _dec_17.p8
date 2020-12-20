pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- basic template

#include maths.lua
#include poly.lua
#include vec.lua
#include subpixel.lua

function _init()
	t=0

	cls()
end

function _update()
	--cls()
	t+=1/30

	for i=1,100 do
		local ang1,r1 = rnd(1),rnd(80)
		local ang2,r2 = ang1, r1 + 1
		local x1,y1 = r1*cos(ang1)+64,r1*sin(ang1)+64
		local x2,y2 = r2*cos(ang2)+64,r2*sin(ang2)+64

		circ(x2,y2,1,
			pget(x1,y1)
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

	foreach(rot_ps, function(p) 
		polyv(p, vec(64,64) + vec(0,sin(t/8)), 0)
		polyv(p, vec(64,64), 7)
	end)
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