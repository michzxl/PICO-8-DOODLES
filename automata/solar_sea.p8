pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

local t = 0

function _init()
	cls(2)

	pal({
	[0]=0,
		1+128,
		1,
		2,
		8+128,
		8,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		7,
	}, 1)
end

function _update()
	t += 1/30

	for i=1,500 do
		local x,y = rnd(128),rnd(128)
		local p = pget(x,y)
		local c = (sin(x/64) + cos((y+x)/128 - t/8))
		c = c / 3 + 0.5
		circ(x,y,1,mid(0,5,c+p))
	end

	for i=1,150 do
		local x,y = rnd(128),rnd(128)
		local p = pget(x,y)
		local p2 = mid(0,p-1,5)
		circ(x,y,1,p2)
	end

	for i=1,150 do
		local x,y = rnd(128),rnd(128)
		local p = pget(x,y)
		circ(x,y,1,mid(0,p+1.5,5))
	end
	
	for i=1,500 do
		local x,y = rnd(128),rnd(128)
		local p = pget(x,y)
		if p~=0 or rnd(1)<0.2 then
			circ(x,y-2,1,p)
		end
	end

	local k = 2*sin(t/4)/2+0.5
	for i=1,100 do
		local x,y = rnd(128),rnd(128)
		circ(x,y,1,mid(0,5,k + boxblur(x,y,2)))
	end
end

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
