pico-8 cartridge // http://www.pico-8.com
version 30
__lua__
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

local t=0

pal({
	0+128,
	2+128,
	2,
	8+128,
	8,
	9+128,
	9,
	10,
},1)

camera(-64,-64)

cls()

::♥::
t+=1/30

local n=16
local r=24

local as = {}
for i=0,n-1 do
	local a=i/n+t/128
	as[i*2] = cos(a)
	as[i*2+1] = sin(a)
end

local k=8

for i=1,200 do
	local x,y = rnd(128)-64,rnd(128)-64
	circ(x,y,1,0.5+boxblur(x,y,1))
end

--for i=1,750 do
for i=1,10 do
	local ox,oy=rnd(128-k)-64,rnd(128-k)-64
	
	for x=ox,ox+k-1 do
		for y=oy,oy+k-1 do
			local res=0
			for i=0,n-1 do
				local ca,sa=as[i*2],as[i*2+1]
				local g=x*ca+y*sa
				if g>=r then
					res += 1
				end
			end
			
			--circ(x,y,1,res)
			pset(x,y,res)
		end
	end
end
--end

flip()goto ♥
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000