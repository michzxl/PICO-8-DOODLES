pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
#include palettes.lua
#include vec.lua
#include poly.lua
#include util.lua

function _init()
	dt=1/30
	t=0
    tf=0
    k2=sqrt(2)

    cls(0)
end

function _update()
	-- cls()
    t+=dt
    tf+=1

    local st4 = sin(t/4)

    if rnd(1)<0.5 then
        local x,y = rnd(128), rnd(128)
        local p = rnd(#palettes[curr_pal])+1
        line(x-4,y-4,x+4,y+4,p)
        line(x-4,y-3,x+3,y+4,p)
        line(x-3,y-4,x+4,y+3,p)
        line(x-4,y+4,x+4,y-4,p)
        line(x-4,y+3,x+3,y-4,p)
        line(x-3,y+4,x+4,y-3,p)
    end

    for i=1,25 do
        local x,y = rnd(128), rnd(128)
        local p = pget(x,y)
        if p~=0 then
            if rnd(1)<0.5 then
                circfill(x,y,4,p)
            else
                line(x-4,y-4,x+4,y+4,p)
                line(x-4,y-3,x+3,y+4,p)
                line(x-3,y-4,x+4,y+3,p)
                line(x-4,y+4,x+4,y-4,p)
                line(x-4,y+3,x+3,y-4,p)
                line(x-3,y+4,x+4,y-3,p)
            end
        end
    end

    if rnd(1)<0.1 then
		x,y = 0,rnd(128)
		while x <= 128 do
			nx = x + 8
			ny = y + rnd(16) - 8

			line(x, y, nx, ny, rnd(10))

			x = nx
			y = ny
		end
	end

    local circle = {}
    local sides = 24
    local r = 24
    for i=0,1,1/sides do
        local ang = i + t/2 + sin(i/16 + t/6)
        local r = 
              r 
            + sin(t/8 + ang*2)*4 
            + 8*sin(sin(ang/8))
            + i*sides%2*((st4*2+2)%4)

        add(circle, vec.frompolar(ang,r))
    end

    for i=1,175 do
        local x,y = rnd(128),rnd(128)
        local p = flr(boxblur(x,y,2) + 0.5)
        circ(x,y,1,p)
    end

    polyf(circle,vec(64,64),0)
    polyv(circle,vec(64,64),palettewave(t-4, palettes[curr_pal], 16))

    for i=1,1200 do
        local ang1,r1 = rnd(1),sqrt(rnd(64*64*2))
        local ang2,r2 = ang1, r1 + 1.2

        local x1,y1 = r1*cos(ang1),r1*sin(ang1)
        local x2,y2 = r2*cos(ang2),r2*sin(ang2)

        local smpl = pget(x1+64,y1+64)

        if smpl~=0 then
            circ(x2+64,y2+64,1,smpl)
        end
    end
end

function palettewave(x, palette, period)
	return ctriwave(x, #palette/2+1.1, #palette-1.2, period)
end
