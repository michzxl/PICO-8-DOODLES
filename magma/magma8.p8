pico-8 cartridge // http://www.pico-8.com
version 27
__lua__

#include _vec.lua

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

--@nusan
function clip(v)
    return max(-1,min(128,v))
end

function lerp(a,b,alpha)
    return a*(1.0-alpha)+b*alpha
end

-- draws a filled convex polygon
-- v is an array of vertices
-- {x1, y1, x2, y2} etc
function render_poly(v,col)
 vn = {}
 for vv in all(v) do
	add(vn, vv.x)
	add(vn, vv.y)
 end
 v = vn

 col=col or 5

 -- initialize scan extents
 -- with ludicrous values
 local x1,x2={},{}
 for y=0,127 do
  x1[y],x2[y]=128,-1
 end
 local y1,y2=128,-1

 -- scan convert each pair
 -- of vertices
 for i=1, #v/2 do
  local next=i+1
  if (next>#v/2) next=1

  -- alias verts from array
  local vx1=flr(v[i*2-1])
  local vy1=flr(v[i*2])
  local vx2=flr(v[next*2-1])
  local vy2=flr(v[next*2])

  if vy1>vy2 then
   -- swap verts
   local tempx,tempy=vx1,vy1
   vx1,vy1=vx2,vy2
   vx2,vy2=tempx,tempy
  end 

  -- skip horizontal edges and
  -- offscreen polys
  if vy1~=vy2 and vy1<128 and
   vy2>=0 then

   -- clip edge to screen bounds
   if vy1<0 then
    vx1=(0-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
    vy1=0
   end
   if vy2>127 then
    vx2=(127-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
    vy2=127
   end

   -- iterate horizontal scans
   for y=vy1,vy2 do
    if (y<y1) y1=y
    if (y>y2) y2=y

    -- calculate the x coord for
    -- this y coord using math!
    x=(y-vy1)*(vx2-vx1)/(vy2-vy1)+vx1

    if (x<x1[y]) x1[y]=x
    if (x>x2[y]) x2[y]=x
   end 
  end
 end

 -- render scans
 for y=y1,y2 do
  local sx1=flr(max(0,x1[y]))
  local sx2=flr(min(127,x2[y]))

  local c=col*16+col
  local ofs1=flr((sx1+1)/2)
  local ofs2=flr((sx2+1)/2)
  memset(0x6000+(y*64)+ofs1,c,ofs2-ofs1)
  pset(sx1,y,c)
  pset(sx2,y,c)
 end 
end

function polyf(tbl,c,cfunc)
	c=c or 15
	p1=tbl[1]
	if #tbl==1 then
		pset(p1.x,p1.y,c)
	elseif #tbl==2 then
		p2=tbl[2]
		x1,y1=p1:xy()
		x2,y2=p2:xy()
		line(x1,y1,x2,y2,c)
	else
		for i=0,#tbl-2-1 do
			ix=i+2
			p2=tbl[ix]
			p3=tbl[ix+1]
			render_poly({p1,p2,p3},4)
		end
	end
end

pal({
	2+128,
	2,
	8+128,
	8,
	9+128,
	9,
	10,
	7+128,
	7,
}, 1)

t=2
dt=0.016
█=1000
kill=0
function sqr(a) return a*a end

cls()
filler = 0b1010010110100101

::♥::
t+=dt
t8=t%8

if t8<dt*2 then t=rnd(1) end

st=sin(t)
st4=sin(t/4)
st2=sin(t/2)

hh=5000

for i=1,1000 do
	y=rnd(128)-64
	x=rnd(128)-64

	x=x - sin(y/32 - t)*(cos(t/16)*8)

	c = (-2*sin(y/(50+10*st) + t - 2*st2) - t) / 8
	c += sin(x/(64 + sin(x/16 + t)*8)) * sin((y+t*8)/32)
	
	c = ctriwave(c+t*2, 5.6, 8.8, 6+st4*1)
	
	
	circ(x+64,y+64,1,c)
end

s=(4+sin(t/8)*1.5)
kmod = rnd(1)<0.05
ps={}
for i=0,1,1/s do
	ang = i + t/4 + sin(t/2 + i/8)/16
	ymod = sin(t/8)*8
	r = 16 + sin(t/4 + i/2)*8
	w = 3 + rnd(1) + sin(t/4 + i)*1
	if kmod then 
		w*=2
		r=r-2 
	end
	add(ps, {ang=ang,r=r,w=w})
end
for i=1,s do
	p1 = ps[i]
	p2 = ps[i%s + 1]

	p1v = vec.frompolar(p1.ang, p1.r) + vec(64,64) + vec(0,p1.ymod)
	p2v = vec.frompolar(p2.ang,p2.r) + vec(64,64) + vec(0,p2.ymod)

	vector = (p2v-p1v):norm()
	orth = vector:perp()

	b1 = p1v + orth*p1.w/2
	b2 = p1v - orth*p1.w/2
	b3 = p2v - orth*p2.w/2
	b4 = p2v + orth*p2.w/2

	col=flr(ctriwave(t*2 + 1, 5.6, 8.8, 6+st4*1))
	render_poly({b1,b2,b3,b4},col)
end

flip() goto ♥
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
