pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function ff(y)
	local ay
	if (y+t*32)%64<8 then
		ay = 4*sin(t/8)-4
	else
		ay = 0
	end
	return ay
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

function fflr(a,unit)
	return a\unit*unit
end

function perp(x,y)
	return -y, x
end

function norm(x,y)
	local d = dist(x,y,0,0)
	return 
		x / d,
		y / d
end

function dist(x1,y1,x2,y2)
	return sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))
end

cc={0,5+128,7,5+128}
for i=1,#cc do
	pal(i,cc[i],1)
end

t=0

cls()
::♥::
cls()
t+=1/30

pos = -t*16

-- GENERATE THE LINES
unit=5+sin(t/16)*2
ox=64
lines = {}
for y=pos%unit-1-16,128+unit,unit do
	x = ox + 4*sin(t + y/32)
	y = y + 4*sin(y/32 + t)

	
	x = x + sin(t/16)*16 * sin(t/16 + y/64)

	add(lines, {
		x,y,x+8+ff(x,y),y+8+4*sin(t/4),
		x,y,x-8-ff(x,y),y+8-4*sin(t/8)
	})
end

-- DRAW THE LINES
for key,ln in ipairs(lines) do
	-- ARROW SHAPE: /\
	line2(ln[1],ln[2],ln[3],ln[4],7)
	line2(ln[5],ln[6],ln[7],ln[8],7)

	-- CONNECTING LINES BETWEEN EACH ARROW
	if key~=#lines then 
		ln2 = lines[(key+1)]
		line2(ln[1],ln[2],ln2[1],ln2[2],7)
		line2(ln[3],ln[4],ln2[3],ln2[4],7)
		line2(ln[7],ln[8],ln2[7],ln2[8],7)
	end
end

flip() goto ♥
