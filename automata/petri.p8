pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
local t=0

function sqrdist(x1,y1,x2,y2)
	return (y2-y1)*(y2-y1) + (x2-x1)*(x2-x1)
end
function pxset(x,y,c)
	circ(x,y,1,c)
end

pal(1,12+128,1)
pal(2,1,1)

fillp(0b1010010110100101)
cls(1)

fill1 = 0b1010010110100101
fill2 = 0b0101101001011010.1

::♥::
t+=1/30

if rnd(1)<0.01 then
	fillp(rnd(1)<0.5 and 0b1010010110100101.1 or 0b0101101001011010.1)
	local x,y = rnd(32)+16,rnd(32)+16
	rectfill(x,y,128-x,128-y,2)
	fillp()
end

if rnd(1)<0.01 then
	local x,y = rnd(128),rnd(128)
	rectfill(x,y,128-x,128-y,0)
end

for i=1,10 do
	local x,y=rnd(128),rnd(128)

	local c = 0x1

	if pget(x,y)==0 then

		fillp(rnd(1)<0.5 and fill1 or fill2)
		circfill(x,y,rnd(2)-1+5,c)
	
		fillp()
	end
end

for i=1,50 do
	local x,y=rnd(128),rnd(128)

	if pget(x,y)~=1 then
		local r = rnd(1)
		if r<0.25 then
			pxset(x+1,y+1,0x1)
		elseif r<0.5 then
			pxset(x-1,y-2,0x2)
		elseif r<0.15 then
			pxset(x+1,y-1,0x1)
		else
			pxset(x-1,y+1,0x1)
		end
	end
end

for i=1,3000 do
	local x,y=rnd(128),rnd(128)

	if pget(x,y)~=0
			and (pget(x-1,y)~=0
			or pget(x+1,y)~=0
			or pget(x,y-1)~=0
			or pget(x,y+1)~=0
			or pget(x-1,y-1)~=0
			or pget(x-1,y+1)~=0
			or pget(x+1,y-1)~=0
			or pget(x+1,y-1)~=0) then
		pxset(x,y,0)
	end
end

flip() goto ♥
