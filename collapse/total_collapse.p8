pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- basic template
function _init()
	poke(0x5f2d, 1)--enable mouse

	medium_rare={
		1+128,
		1,
		2+128,
		8+128,
		8,
		14+128,
		15+128,
		15,
		7,
	}
	pal(medium_rare, 1)

	scrw = 128
	scrh = 128

	scrw2 = 64
	scrh2 = 64

	circs = {}

	dt=1/30
	t=0

	cosa={}
	sina={}

	k=64

	mod=false

	for ang=0,1-1/k,1/k do
		cosa[ang]=cos(ang)
		sina[ang]=sin(ang)
	end

	for cir=0,7 do
		r=cir*(sin(sin(t/16))*4+10)
		circs[cir]={}
		local circ=circs[cir]

		for ang=0,1-1/k,1/k do
			local x=scrw2 + r*cos(ang)
			local y=scrh2 + r*sin(ang)
			add(circ, {x,y})
		end
	end

	cls()
end

function _update()
	--cls()
	t+=dt
	-- true during the last 8 seconds of each 16-sec interval
	mod = t % 16 > 8

	-- draw a centered rectangle with color 0
	if mod and chn(0.75) then
		local x, y = rnd(scrw2/4), rnd(32)+16
		rectfill(x, y, scrw - x, scrh - y, 0)
	end

	if chn(0.05) then
		local x = fflr(rnd(128),16)
		local width=16
		local skew=30
		c = rnd(8)
		polyf({
			{x               , 0   },
			{x + width       , 0   },
			{x + skew        , scrh},
			{x + skew + width, scrh}
		},c)
	end

	if chn(0.2) then
		x,y = 0,rnd(scrh)
		while x <= scrw do
			nx = x + 8
			ny = y + rnd(16) - 8

			line(x, y, nx, ny, rnd(10))

			x = nx
			y = ny
		end
	end

	z = mod and 500 or 1500
	for i = 1, z do
		local x, y = rnd(240), rnd(136)
		local p

		-- y=(scrh/scrw)*x is a line from top-left to bottom-right
		if y < (scrh / scrw * x) then
			-- left vs right half of screen:
			if x < scrw / 2 then
				p = pget(x - 1, y + 2)
			else
				p = pget(x - 2, y - 1)
			end
		else
			if x > scrw / 2 then
				p = pget(x + 1, y - 2)
			else
				p = pget(x + 2, y + 1)
			end
		end
		circ(x, y, 1, p)
	end

	ra = (function()
		local hh = (sin(sin(t / 16)) * 4 + 10)
		return function(cir)
			return cir * hh
		end
	end)()

	-- draw a centered, randomly size circle sometimes
	if chn(0.2) then
		circ(scrw2, scrh2, rnd(64), 2)
	end

	-- for each circle...
	for cir = 1, #circs do
		local circ = circs[cir]

		-- 20 times, pick a random point in the circle ...
		for i = 1, 20 do
			ix = flr(rnd(#circ)) + 1
			local p = circ[ix]

			-- 20% chances of resetting the point's position
			-- otherwise, just move it around randomly
			if chn(0.2) then
				ang = (ix - 1) / k
				r = ra(cir)
				p[1] = scrw2 + r * cos(ang)
				p[2] = scrh2 + r * sin(ang)
			else
				-- rnd(5)-4 is [-4,1)
				p[1] = p[1] + rnd(5) - 4
				p[2] = p[2] + rnd(5) - 4
			end
		end

		-- draw the damn circle.
		for i = 1, #circ do
			if chn(0.75) then
				p1 = circ[i]
				p2 = circ[i % #circ + 1] 
				
				c = (8 - cir + t / 2) % 8 + 1 + 1*sin(t/16)
				line(p1[1], p1[2], p2[1], p2[2], c)
			end
		end
	end
end

function fflr(a, unit)
    return flr(a / unit) * unit
end

function polyf(tbl,c,cfunc)
	c=c or 15
	p1=tbl[1]
	if #tbl==1 then
		pset(p1[1],p1[2],c)
	elseif #tbl==2 then
		p2=tbl[2]
		x1,y1=p1[1],p1[1]
		x2,y2=p2[1],p2[2]
		line(x1,y1,x2,y2,c)
	else
		for i=0,#tbl-2 do
			ix=i+2
			p2=tbl[ix]
			p3=tbl[ix+1]
			render_poly({p1,p2,p3},i+4)
		end
	end
end

function render_poly(v,col)
 vn = {}
 for vv in all(v) do
	add(vn, vv[1])
	add(vn, vv[2])
 end
 v = vn

 col=col or 7

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

function chn(prob)
	return rnd(1)<prob
end


__gfx__
01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17777100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17711100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
