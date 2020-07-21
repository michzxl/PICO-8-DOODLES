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

		-- 20 times, pick a random point in the circle:
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

		-- draw the fucking circle.
		for i = 1, #circ do
			if chn(0.75) then
				p1 = circ[i]
				p2 = circ[i % #circ + 1] 
				-- trust me when i say this gets the point adjacent to p1.
				
				c = (8 - cir + t / 2) % 8 + 1 + 1*sin(t/16)
				line(p1[1], p1[2], p2[1], p2[2], c)
			end
		end
	end
end

-->8
function sqr(a) 
	return a*a 
end

function dist(x1,y1,x2,y2) 
	return sqrt(sqr(x2-x1)+sqr(y2-y1)) 
end

function sqrdist(x1,y1,x2,y2) 
	return sqr(x2-x1)+sqr(y2-y1) 
end

-- moves a towards b with factor t.
-- if t=0, returns a. if t=1, returns b.
function lerp(a,b,t)
    return a + t * (b - a)
end

-- like lerp, but with a constant factor (as opposed to a relative factor)
function approach(a,b,t)
    if a<=b then
        return min(a+t,b)
    elseif a>b then
        return max(a-t,b)
    end
end

function lerp_slow(a,b,t)
    if b-a==0 then return a end
    return a + 1 / (t * (b - a))
end

function fflr(a, unit)
    return flr(a / unit) * unit
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

-- n-gon, n sides and maximum radius 1
-- visualize it -> https://www.desmos.com/calculator/njxxfrv23z
function ngon(ang, n)
    local top = rmax * cos(0.5 / n)
    local bot = cos(triwave(n * ang - 0.5) / 2 / n)
    return top / bot
end

-- ngon, n sides and minimum radius 1
function ngon_min(ang,n)
    local top = 1
    local bot = cos(triwave(n * ang - 0.5) / 2 / n)
    return top / bot
end

-- returns a func that represents an n-gon with max radius 1
-- if use_min is true, 1 will instead be the min radius of the n-gon
function ngon_maker(n, use_min)
    local tmp=use_min_radius and 1 or cos(0.5/n)
    return function(ang)
        local top = tmp
        local bot = cos(triwave(n*ang-0.5)/2/n)
        return top / bot
    end
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

mcos=cos
msin=sin
function rotx_gl(x, y, z, ang)
    return x, y * mcos(ang) - z * msin(ang), y * msin(ang) + z * mcos(ang)
end

function roty_gl(x, y, z, ang)
    return z * msin(ang) + x * mcos(ang), y, z * mcos(ang) - x * msin(ang)
end

function rotz_gl(x, y, z, ang)
    return x * mcos(ang) - y * msin(ang), x * msin(ang) + y * mcos(ang), z
end

function rotyxzc(x, y, z, ay, ax, az, cx)
    local ox, oy, oz = 0, 0, 0
    ox, oy, oz = roty_gl(x, y, z, ay)
    ox, oy, oz = rotx_gl(ox, oy, oz, ax)
    ox, oy, oz = rotz_gl(ox, oy, oz, az)

    ox, oy, oz = rotx_gl(ox, oy, oz, cx)
    return ox, oy, oz
end

-- mode is a string that specifies the axis of each rotation specified in the args
-- i.e. 'xyzyxz' for 6 rotations in x,y,z,y,x,z global axes, in that order.
function rotmode(x,y,z,mode,...)
  for i=1,#mode do
    local s = string.sub(mode,i,i)
    func=rotmodes[s]
    if rotmodes[s] then
      return func(x,y,z,arg[i])
    end
  end
end
local rotmodes={
  x=rotx,
  y=roty,
  z=rotz
}

function chn(prob)
	return rnd(1)<prob
end

function rotyxz_cam(x, y, z, ay, ax, az, cy, cx, cz)
    x, y, z = roty_gl(x, y, z, ay)
    x, y, z = rotx_gl(x, y, z, ax)
    x, y, z = rotz_gl(x, y, z, az)

    x, y, z = roty_gl(x, y, z, cy)
    x, y, z = rotx_gl(x, y, z, cx)
    x, y, z = rotz_gl(x, y, z, cz)
    return x, y, z
end

-- https://www.lexaloffle.com/bbs/?tid=2477
-- by @Felice on pico-8 BBS
-- a: array to be sorted in-place
-- c: comparator (optional, defaults to ascending)
-- l: first index to be sorted (optional, defaults to 1)
-- r: last index to be sorted (optional, defaults to #a)
function qsort(a,c,l,r)
    c,l,r=c or ascending,l or 1,r or #a
    if l<r then
        if c(a[r],a[l]) then
            a[l],a[r]=a[r],a[l]
        end
        local lp,rp,k,p,q=l+1,r-1,l+1,a[l],a[r]
        while k<=rp do
            if c(a[k],p) then
                a[k],a[lp]=a[lp],a[k]
                lp=lp+1
            elseif not c(a[k],q) then
                while c(q,a[rp]) and k<rp do
                    rp=rp-1
                end
                a[k],a[rp]=a[rp],a[k]
                rp=rp-1
                if c(a[k],p) then
                    a[k],a[lp]=a[lp],a[k]
                    lp=lp+1
                end
            end
            k=k+1
        end
        lp=lp-1
        rp=rp+1
        a[l],a[lp]=a[lp],a[l]
        a[r],a[rp]=a[rp],a[r]
        qsort(a,c,l,lp-1       )
        qsort(a,c,  lp+1,rp-1  )
        qsort(a,c,       rp+1,r)
    end
end


__gfx__
01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17777100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17711100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
