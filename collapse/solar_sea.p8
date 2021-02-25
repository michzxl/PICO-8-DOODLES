pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include vec.lua

local t = 0

function _init()
	poke(0x5f2e,1)
	poke(0x5f2d,1)

	cls(2)
	poke(0x5f5f,0x10)
	palmix(0b00001111,0,16)

	pal({
		[0]=0,
		1+128,
		1,
		2,
		8+128,
		8,
		
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		7,
	}, 1)

	pal({
		[0]=0,
		0,
		1+128,
		1,
		2,
		8+128,
		--8,

		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		14,
	}, 2)

	lines = {}
end

function _update()
	t += 1/30

	-- gen lines
	if rnd(1)<0.04 and #lines<16 then
		local ln = {}
		ln.x,ln.y = rnd(128),rnd(32)+96
		ln.majorlen = 32 + rnd(32) - 16
		ln.minorlen = 6 + rnd(4) - 2
		ln.rot = rnd(1)
		ln.vx,ln.vy = 0,-1 + rnd(0.5) - 0.025
		ln.vrot = 0.05 * (rnd(1)<0.5 and 1 or -1)
		ln.rotdamp = 0.95
		add(lines, ln)
	end

	for i=1,500 do
		local x,y = rnd(128),rnd(128)
		local c = (sin(x/64) + cos((y+x)/128 - t/8))
		c = c / 3 + 0.5
		circ(x,y,1,mid(0,5,c+pget(x,y)))
	end

	for i=1,150 do
		local x,y = rnd(128),rnd(128)
		local p2 = mid(0,pget(x,y)-1,5)
		circ(x,y,1,p2)
	end

	for i=1,150 do
		local x,y = rnd(128),rnd(128)
		circ(x,y,1,mid(0,pget(x,y)+1.5,5))
	end
	

	for i=1,500 * min(1, sin(t/16) + 1) do
		local x,y = rnd(128),rnd(128)
		local p = pget(x,y)
		if p~=0 or rnd(1)<0.2 then
			circ(x,y-2,1,p)
		end
	end

	local k = 2.5*sin(t/4)/2+0.5
	for i=1,100 do
		local x,y = rnd(128),rnd(128)
		circ(x,y,1,mid(0,5,k + boxblur(x,y,2)))
	end

	for i=1,200 do
		local x,y = rnd(128),rnd(128)
		circ(x,y,1,0.5 + boxblur(x,y,1))
	end

	for ln in all(lines) do
		ln.x = ln.x + ln.vx
		ln.y = ln.y + ln.vy
		ln.vrot = ln.vrot * ln.rotdamp
		ln.rot = ln.rot + ln.vrot
		ln.rot = alerp(ln.rot, 0.45, 0.035, 1)
	

		local pos = vec(ln.x,ln.y)
		local t1 = vec.frompolar(ln.rot, ln.majorlen / 2)
		local t2 = vec.frompolar(ln.rot + 0.25, ln.minorlen / 2)

		if rnd(1)<0.05 then
			local ofs = vec(rnd(16)-8)
			pos += ofs
			t1 -= ofs
			t2 += ofs
		end

		local v1 = pos + t1
		local v2 = pos - t1
		
		local va1,va2 = pos + t1:norm(t1:magn() - ln.minorlen / 2), pos - t1:norm(t1:magn() - ln.minorlen / 2)
		local wa1 = va1 + t2
		local wa2 = va1 - t2
		local wb1 = va2 + t2
		local wb2 = va2 - t2

		local c1,c2 = 15,3
		local f1,f2 = 0b0000000000000000, 0b1000010000100001.1

		fillp(f2)
		line__(v1.x,v1.y,v2.x,v2.y,c2)
		line__(wa1.x,wa1.y,wa2.x,wa2.y,c2)
		line__(wb1.x,wb1.y,wb2.x,wb2.y,c2)

		fillp(f1)
		line2(v1.x,v1.y,v2.x,v2.y,c1)
		line2(wa1.x,wa1.y,wa2.x,wa2.y,c1)
		line2(wb1.x,wb1.y,wb2.x,wb2.y,c1)

		fillp()

		if ln.y < 0 - ln.majorlen then
			del(lines, ln)
		end
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

function line2(x1,y1,x2,y2,c)
	local num_steps=max(
	 abs(flr(x2)-flr(x1)),
	 abs(flr(y2)-flr(y1)))
	local dx=(x2-x1)/num_steps
	local dy=(y2-y1)/num_steps
	for i=0,num_steps do
	 pset(x1,y1,c)
	 x1+=dx
	 y1+=dy
	end
  end

function line__(x1,y1,x2,y2,c)
	local num_steps=max(
	 abs(flr(x2)-flr(x1)),
	 abs(flr(y2)-flr(y1)))
	local dx=(x2-x1)/num_steps
	local dy=(y2-y1)/num_steps
	for i=0,num_steps do
	 circfill(x1,y1,2,c)
	 x1+=dx
	 y1+=dy
	end
  end

function alerp(a,b,t,p)
  a=a%p
  b=b%p
  if b-a>p/2 then
	  b=b-p
  elseif a-b>p/2 then
	  a=a-p
  end
  return a + t*(b - a)
end

function palmix(bits, region, length)
	if bits==nil then
		memset(0x5f70, 0, 16)
	else
		memset(0x5f70 + region, bits, length)
	end
end