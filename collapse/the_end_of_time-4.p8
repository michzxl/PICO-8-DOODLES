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

function sqr(a) return a*a end

function dist(x1,y1,x2,y2)
	return sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))
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
+y/128
	add(lines, {
		x,y,x+8+ff(x,y),y+8+4*sin(t/4),
		x,y,x-8-ff(x,y),y+8-4*sin(t/8)+cos(t/16)
	})
end

-- DRAW THE LINES
for key,ln in ipairs(lines) do

	line2(ln[1],ln[2],ln[1] - ln[3] + (ln[2]-64)/2+64,ln[4],7)

	-- CONNECTING LINES BETWEEN EACH ARROW
	if key~=#lines then 
		ln2 = lines[(key+1)]
		line2(ln[1],ln[2],ln2[1],ln2[2],7)
		line2(ln[1]+1.2*(-key+#lines/2),ln[2],ln2[1]+1.2*(-key+#lines/2),ln2[2],7)

	end
end


flip() goto ♥