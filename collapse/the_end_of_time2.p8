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
t+=1/30

pos = -t*16

-- CLEAR THE SCREEN OUT A BIT
for i=1,50 + sin(t/32)*25 do
	local ox=rnd(128+16)-8
	local oy=rnd(128+16)-8
	rectfill(ox,oy,ox+16,oy+16,0)
end

rr=rnd(1)<0.05
rh=rnd(128)-64

-- GENERATE THE LINES
unit=5+sin(t/16)*2
ox=64
lines = {}
for y=pos%unit-1-16,128+unit,unit do
	x = ox + 4*sin(t + y/32)
	y = y + 4*sin(y/32 + t)

	-- IF RR IS TRUE, THEN SHIFT ALL X'S IN THE LINES BY RH
	if rr then
		x=x+rh
	end

	-- MAYBE SHIFT THIS SINGLE X VALUE
	if rnd(1)<0.008 then 
		x=x+rnd(80)-40
	end
	
	x = x + sin(t/16)*16 * sin(t/16 + y/64)

	add(lines, {
		x,y,x+8+ff(x,y),y+8+4*sin(t/4),
		x,y,x-8-ff(x,y),y+8-4*sin(t/8)
	})
end

-- DRAW THE LINES
for key,ln in ipairs(lines) do
	-- ARROW SHAPE: /\
	line(ln[1],ln[2],ln[3],ln[4],7)
	line(ln[5],ln[6],ln[7],ln[8],7)

	-- STRAIGHT HORIZONTAL LINES TO THE EDGES
	if rnd(1)<0.02 then
		line(ln[3],ln[4],128,ln[4],2)
		line(ln[7],ln[8],0,ln[8],2)
	end

	-- CONNECTING LINES BETWEEN EACH ARROW
	if key~=#lines then 
		ln2 = lines[(key+1)]
		line(ln[1],ln[2],ln2[1],ln2[2],7)
		line(ln[3],ln[4],ln2[3],ln2[4],7)
		line(ln[7],ln[8],ln2[7],ln2[8],7)
	end
end

ang = fflr(t/4,1/8)+rnd(0.01)+sin(t/8)/16
r=1
ax,ay=r*cos(ang), r*sin(ang)
L1=16+sin(t/8)*8
L2=48

pts = {}
for i=L1,L2,(L2-L1)/6 do
	local lx,ly = 64+ax*i, 64+ay*i
	local axn,ayn = norm(ax,ay)
	axn,ayn = perp(axn,ayn)
	axn,ayn = axn*sin(t/16 + lx)*2,ayn*sin(t/8)*2

	add(pts, {lx+axn,ly+ayn})
end

for i=1,#pts-1 do
	local pt1 = pts[i]
	local pt2 = pts[i+1]

	if rnd(1)<0.1 then
		local vx,vy = pt2[1]-pt1[1], pt2[2]-pt1[2]

		local aang = atan2(vx,vy) + rnd(1)
		local rr = dist(vx,vy,0,0)
		if rnd(1)<0.1 then rr=64 aang = atan2(vx,vy) + 1/4 end

		vx,vy = rr*cos(aang), rr*sin(aang)
		pt2 = {pt1[1]+vx, pt1[2]+vx}
	end

	line(pt1[1],pt1[2],pt2[1],pt2[2],8)
end


-- line(
-- 	64+ax*L1,
-- 	64+ay*L1,
-- 	64+ax*L2,
-- 	64+ay*L2,
-- 	8
-- )


flip() goto ♥
