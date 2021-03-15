pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

--https://www.desmos.com/calculator/mfcwyga0ky

poke(0x5f5f,0x10)

cc={0,5+128,7,5+128,0,}
cc2={0,0+128,6+128,0+128,0,}
for i=1,#cc do
	pal(i,cc[i],1)
end
pal(cc2,2)

local lcc = #cc

pal(15,4,1)
pal(15,15+128,2)

pal(14,4+128,1)
pal(14,14+128,2)

local funcs = {
	function(x,y)
		local c=(
			abs(x/22) 
			+ y/22 * sin(st128)
		)
		c=(c-t/2)%lcc+1
		
		circ(x+cen,y+cen,1,c)
	end,	
	function(x,y)
		local c= (
			abs(x/15+st8*y/32+sin(y/64)*0.25) 
			+ 1.7*flr(y/44-t) 
			- y/44%st16 
			- sin(x/64)*0.5
			- t/2
		)%lcc+1
		
		circ(x+64,y+64,1,c)
	end,
	function(x,y)
		local c=(
			abs(x/22) 
			+ y/22 * sin(st128)
			+ flr((x)/(y+72)*2)
			+ 0.25*flr(sin(x/64)+cos(y/64))
		)
		c=(c-t/2)%lcc+1
		
		circ(x+cen,y+cen,1,c)
	end,
	function(x,y)
		local c=(
			abs(x/22) 
			+ y/22 * sin(st128)
			+ flr(x/32) + flr((y-t)/32)
			
		)
		c=(c-t/2)%lcc+1
		
		circ(x+cen,y+cen,1,c)
	end,
	
	function(x,y)
		local c=(
			(abs(x/15))
			+ 1.7*abs(y/44-t)
			-y/44%sin(t/16)
		)
		c=(c-t/2)%lcc+1
		
		circ(x+cen,y+cen,1,c)
	end,
	function(x,y)
		local c=(
		flr(abs(x/15))
			+ 1.7*abs(y/44-t/2)-y/44%sin(t/32)
		)
		c=(c-t/2) %#cc+1
		
		circ(x+cen,y+cen,1,c)
	end,
	function(x,y)
		local c=abs(x/15)
		c=c + 1.7*flr(y/44-t/2) 
		c=c - y/44%sin(t/32)
		c=(c-t) %#cc+1 --color
		
		circ(x+cen,y+cen,1,c)
	end,
	
}
local lfuncs = #funcs

t=-1/30
st128 = 0
st16=0
st8=0
cen = 64

function _init()
	palmix(0b00110011,0,16)
end

function gg(y)
	return 2*sin(t/4 + y/32)
		+ 1*cos(t - y/16)
end

function _update()
	t+=1/30
	k = 12
	cen = 64
	st128 = sin(t/128)
	st16 = sin(t/16)
	st8 = sin(t/8)
	local funcs = funcs

	local bk=7
	local hx=1
	local hy=1

	for i=1,1300 do
		local x,y=rnd(128)-cen,rnd(128)-cen
		local g = gg(y)
		if x<g then
			local i = flr((t+k*0.75)/k)%lfuncs+1
			funcs[i](x,y)
		elseif x>=g+1 then
			local i = flr((t+k*0.25)/k)%lfuncs+1
			funcs[i](x,y)
		end
	end

	if cos(t/k)<0 then
		--line(cen,0,cen,127,3)

		for y=0,127,2 do
			local x = gg(y)
			pset(x+cen,y,3)
		end
	end
	
	local col = 0xef
	local fill = 0b1010010110100101.1010010110100101
	fill = fill<<>(t*2)
	fill = fill\1

	local fill2 = 0b1000010000100001.1000010000100001
	fill2 = fill2<<>(t*4)
	fill2 = fill2\1

	fillp(fill)

	local w = 2
	local ew = 2.5

	local ox = (64+4+32)*max(0,-sin(t/k))-32
	local px = (64+4+8)*max(0,-sin(t/k-0.06))-8
	for y=0,127,w do
		local x = ox
			+ 1*sin(t/4 + y/64) + 2*cos(t/2+y/24)
			- 0.5*sin(t + y/16)
			- 4
		rectfill(-1,y,x,y+w-1,col)
		rectfill(x+1,y,x+ew,y+w+2,0)

		local wx = px - 50
			+ ctriwave(t*16+y,0,8,32)
			+ 2*cos(y/64)
		local nx = wx
		fillp(fill2)
		rectfill(-1,y-1,nx,y+w-1-1,0x76)
		rectfill(nx+1,y-1,nx+ew,y+w-1-1+1,0x0)
		fillp(fill)
	end

	local ox = (64+4+32)*max(0,-sin(t/k + 0.5))-32
	local px = (64+4+8)*max(0,-sin(t/k-0.06+0.5))-8
	for y=0,127,w do
		local x = ox
			+ 1*sin(t/4 + y/64) + 2*cos(t/2+y/24)
			- 0.5*sin(t + y/16)
			- 4
		rectfill(128,y,128 - x,y+w-1,col)
		rectfill(128-(x+1),y,128-(x+ew),y+w+2,0)

		local wx = px - 50
			+ ctriwave(t*16+y,0,8,32)
			+ 2*cos(y/64)
		fillp(fill2)
		rectfill(128,y-1,128-wx,y+w-1-1,0x76)
		rectfill(128-(wx+1),y-1,128-(wx+ew),y+w-1-1+1,0x0)
		fillp(fill)
	end

	fillp()

	
end

function palmix(bits, region, length)
	if bits==nil then
		memset(0x5f70, 0, 16)
	else
		memset(0x5f70 + region, bits, length)
	end
end

-- triangle wave, period 1, range [0,0.5]
function triwave(x)
    return abs((x + .5) % 1 - .5)
end

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