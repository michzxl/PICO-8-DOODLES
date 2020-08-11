pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include palettes.lua

-- "complex" triangle wave, range [center - amplitude/2, center + amplitude/2]
-- to visualize -> https://www.desmos.com/calculator/lbicgo2khe
function ctriwave(x, center, amplitude, period)
    local a, b, p = amplitude or 1, center or 0, period or 1
    local core = abs((x / p - 0.25) % 1 - 0.5)
    return 2 * a * core - a / 2 + b
end

-- "range" triangle wave, range [y1,y2]
function rtriwave(x, y1, y2, period)
    local amplitude = (y2 - y1)
    local center = (y1 + y2) / 2
    return ctriwave(x, amplitude, center, period)
end

function palettewave(x, palette, period)
	return ctriwave(x, #palette/2+1.1, #palette-1.2, period)
end

function sqr(a) return a*a end
function dist(x1,y1,x2,y2) return sqrt(sqr(x2-x1)+sqr(y2-y1)) end
function show_cpu(c1,c2) cp=flr(stat(1)*100) rectfill(0,0,12+4*#(tostr(cp)),6,c2) print("∧"..cp.."%",1,1,c1) end
function nsin(a) return (sin(a)+1)/2 end
function ncos(a) return (cos(a)+1)/2 end
function tan(a) return sin(a)/cos(a) end
function drw_mouse(x,y) spr(255,x,y) end
poke(0x5f2d, 1)--enable mouse
p={}
for i=1,#p do
	if p[i]~='' then
		pal(i,p[i],1)
	end
end

dt=0.0333
t=0

cls()
::♥::
t+=dt

if btnp(5) then
	next_palette()
end

for i=1,1000 do
	x,y=rnd(128),rnd(128)

	c = 0
	c=4*sin((x+t*8)/128)
		 +4*sin((y+sin(t/16)*64)/64)
		 +t*6
	c = c/2
	c = flr(c)
	  + 8*flr(16*(atan2(4,(x-64)/(y/32)/16)) - t/2)
	c = palettewave(c, palettes[curr_pal], 16)
	
	circ(x,y,1,c)
end

if t<2 then
	rectfill(0,120,128,128,0)
	print("press x press x",0,120,7)
end

flip() goto ♥
