pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- basic template

function _init()
	dt=1/30
	t=0
	tf=0
	bk=9
	cls()

	medium_rare={
		3+128,
		1+128,
		1,
		2+128,
		8+128,
		8,
		14+128,
		15+128,
		15,
		7
	}
	noir={
		0,
		0,
		7,
		7
	}
	reds={
		2+128,
		2,
		8+128,
		8,
		9+128,
		9,
		10,
		7+128,
		7
	}
	pal(medium_rare, 1)
end

function _update()
	-- cls()
	t+=dt
	tf+=1
	st8=sin(t/8)
	ct8=cos(t/8)
	
	for i=1,80 do
		ox,oy=get_oxy()
		for y=oy,oy+bk-1,1.5 do
			for x=ox,ox+bk-1,1.2 do
				c = abs((x-64)/32)+64 + y/32
					+ t
					+ (x-(64+st8*16))\32*2*(ct8-1)%1+64
				c = flr(c)
				c=_color(c)

				pset(x,y,c)
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

function _color(x)
	return 17.6 * abs((x/16-0.25)%1-0.5) + 1.1
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

-->8
palettes={
	blues={
		3+128,
		1+128,
		1,
		12+128,
		12,
		7,
	},
	greens={
		1+128,
		1,
		3+128,
		3,
		11+128,
		11,
		10+128,
		10,
		7+128,
		7,
	},
	medium_rare={
		3+128,
		1+128,
		1,
		2+128,
		8+128,
		8,
		14+128,
		15+128,
		15,
		7,
	},
	noir={
		0,
		0,
		7,
		7,
	},
	reds={
		2+128,
		2,
		8+128,
		8,
		9+128,
		9,
		10,
		7+128,
		7,
	},
	grays={
		0+128,
		2+128,
		13+128,
		5,
		6+128,
		6,
		7,
	}
}

-->8


function get_oxy()
	ox=rnd(128+bk)-8
	oy=rnd(128+bk)-8
	local ch = rnd(1)
	if ch<0.05 then
		ox-=1
	elseif ch<0.1 then
		ox+=1
	end
	return ox,oy
end
__gfx__
01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17777100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17711100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
fvvvvvffvvvvvvvvvuuvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuu888uu88888uu8uuuuu88888uuuuuuuuuuvuuvvvvvvvvvvvvvvvvvvvvvfvfffffffvvvvvv
ffffvvffvvvvvffvvffffvvvvvvvvvvvvvvvvvuvvuvvvuvuuuuuuuuuu8u88888888888888uuuuuuuuuuuuuuuvvuuvvvvvvvuvvvvvvvvvvuvvvvvvvvvvffvffff
ffffvvvvvvvvvffffffffvvvvvvvvvvvvvvvuuuuuvvvvuvvuuuuuu88888uu8u88uuu8uuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvffvffff
ffvffvffvvvvvvvvfvfffvvvvvvvvvvvvvvvvvvuvvvvvuuuuuuuuuuuuu8uu8uuuuuu8uu8888uuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvfffvvfvvvvvvf
ffffvvvfvvvvvfffvffffvvvvvvvvvvvvvuvvvuuuuvvvuvvuuuuuuuuu8uuu888888888888uuuuuuuuuuuuuuuuvvvvvvvvvvuvvvvvvvvvvvvvvvvffffffffffff
ffffffvfvvfffffffffffvvvvvvvvvvvvvvvuvvuvvvvvuvvuuuuuuuuuuuuu8uuuuuu8uuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvffffffffffffvv
vfvvfvvffvfffffvffffffvvvvfvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuu8888uu8uuuuu8uuuuuuuuuuuuvvvvuvvvvvvvvvvvvvvvvvvvvvffffffffffffvfff
vvfvfffffvfffffffffffvffvvffvvvvvvuvvvuuvuvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvuuuuuvuvvvvvvvvvvfffffffffffvfff
fffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvuvvvvvvvvvvvvvvvvfffffffffffvvvv
fffffffffffffffvffffffffvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuu8uuuuuuuuuuuuuuuuuuuvvvvvvuvvvuuuvvvvvvvvvvvvvvvffffffffffffvfff
ffffffffffffffffffffffffvvvvvvvvvvvuvvvvvuvvvvvuvuuuu8uuuuuuuuuuuuuuuuuuuuuuuuuuuuvuvvvvvvvvvvvvuvvvvvvvvuuvvvvvffffffffffffvfff
ffffffffffffffffffffffffvfvvvvuvvuvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvuvvvvvvvuvvvvvvvffffffffffffffff
vffffffffffffffvffffffffffvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvuvvvvvvvvvvffffffffffffvfff
ffffffffffffffffffffffffvffvvvvvvvvvvvvvvvvvvvvvuuuuu8uuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvvvvffvvffvffffffffffffffff
vvffffffffffffffffffffffffvvvvvfvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvfffffffffffffffvff
vvvfffffffffffffffffffffffffvvvffvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvvvffffvffffffffffvfvffffff
vvvfffffffffffvfffffffffffffffvvvfvvvvvvvuvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvvffffffffffffffffffffvvvvf
vvvvvffffffffffffffffffffffffffffffffvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvuvvvvvvvvvvvvvvvvvvvvvvvffffffffffvffffvffffv
vvvfffffffffffffffffffffffffffffffvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvffvvvvvfffffffffvffffffffvv
vvvvvvffffffffffffffffffffffffffffffffvvvuffvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvffvfvvffffffffffvvffffvvvvvvf
vfvvvvvffffffffffffffffffffffffffffffffvvvvvvvvvuvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvuvvvvvvvvvvvvvfffffffvffffffffffffvffvfvvvv
ffffffffffffffffffffffffffffffffffvfffvvvvfffvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvuvvvvvvvvvvvvvvvvvfffffvfffffffvffffffffffffvvvv
ffffvvvfvfffffffffffffffffffffffffffffffvuvvuvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvuvvvvvvvvvvvvvvvvvvvvvvffffffffvffffffvfffffffff
fffffffffffffffffffffffffvfffffffffffffffffffvfvvvvuvuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvuvvvvvvvvvvvvvvvffffffffffvfffffffffvfvvvvv
ffffffvfffffffffffffffffffffffffffvffffvfffffvfvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuvvuvvvvvvvvvvvvvvvfffffffffffffffffffffffffvvvvvvv
ffvvvvvvvvfffffffffffffffffffffffffffvfffvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvfffffffffffvfffffffffffffvvf
vfvvvvfvvvffffffffffffffffvvvvvvvffffvfffffffvfvvvvuvuuuuuuuuuuuuuuuuuuuuuuuuvvuvvvvvvvvvvvvvvvvvvffffffffffffffffffffffvvvvvvvv
ffffffvvvffffffffffffffffffvvvvvvvvvvvfvfffffvfvvvvuvvuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvfvffffffffvffffffffffffffffvvvfvvvvvf
ffvvvvvvvvvffffvvffvfffffvvvvvvvvffffvfffvvvvuvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvfffffffffffffvfffvvfvvvvfffvvf
vvvvvvfvvvvvfffffffffffffffffvvvvffffvffffffffffvvvuvuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffvvvvvvvvvvvvv
vffffffvvvvfvfffvffvfffffffffvvvvvffvfffffffffffvuuuuuuuuuuuuuuuuuuuuuuuvvuuuvvvvvvvvvvvvvvvfvfffffvffffffffffffffffvffvvvvvvvvv
vvvvvvfvvvvvvvffffvvvvvvvvvvffvvvvvffvffffffffvfvvvuvvuvuvuuuuuuuuuuuuuvuvuuvvvvvvvvvvvvffvvvfvffffffffffffffffffffvvfvvvvvvvvvv
vvvvvvfvvvvvfvfffffvfffffffffffffvffffffffffffffvvvuvvvuuuuuuuuuuuuuuuvvvvvvvvvvuvvvvvvvvvvvvffffffvffffffffffffffffvffvvvvvvfvv
vffvffffffffffffffvvvvvvvvvffvvvvvffvfffffffffffvvvvuuuuuuuuuuuuuuuuvuvvvvvvvvvvvvvvvvfvvvvfffffffffffffffffvfffffffvvvfvvffffvv
vvvvvvfvvvvvfvffffffffffvfffffffvvvvvvvfvfffffvfvvvvvvuvvuuvuuuuuuuuuuuuuvvvvvvvvvvvvvfffffvffffffffffffffffffffffvvvfvvvvvvvfvv
ffvvvvfvvvvvfvffffvvffvfvffffffffvffvfffffffffffvvvvvvuuvvvvvuuuuuuuuuuvuvvvvvvvvvvvvfffvvffffffffffffvffffffffffffvvvvvvvvvvfvv
vvvvvvfffffffffvfffffffvvvfffvfvvvffffffffffffffvvvvvvuvvvvuvuuuuuuuuuuuuuuvuvvvvvvvvvffffffffffffffffffffffffvfffvvvvvfvvfffvvv
vvvvfvfvvvvvvvvvvfffffffvffffvfffvfffvvfvfffffffvvvvvvuvvuuuuvvvvuvvvvvvvvvvvvvvvvvvvfffvfffffffffffffffffffffffvfvvvfvvvvvvvfvv
vvvfvvvffvfffffffvvvvfffffffffffffffffffffffffffvvvvuvvvvvvvvvvuuuuuuuuuuvvvvvvvvvvvvffffffffffffffffffffffffffffvvvvvvvvvfffvfv
vvvvvvvvfvfvvvvvvffffffffvfffvvfffffffffffffffffvvvvvvvvvvvuvvvvvuvvvvuvvvvvuvvvvvvvfffvfvfffffffffffffffffffffffvvvvvvvvvvfvvvv
vvvvvfffffffvvvvvffffffffffffvvvfffffvvfvfffffffvvvvvvvvvvvvvvvvvuvvvvuvvvvvvvvvvvvvvfffffffffffffffffffffffffffvfvvvfvvvvvvvvvv
vvvvvvffffffffvvvfffffffffffffffffffffffffffffffuvvvuvvvvvvvvvvvvvuvvvuuvvvvvvvvvvffffffffffffffffffffffffffffffvvvvvvvvvvvfvvvv
vvvvvvvfvvvvvvvvvffffffffffffvvvvfffffffffffffffvvvvvvuvvvvvvvvvvvvvvvvvvvvvvvvvvvffffvfffffffffffvfffffffffffffvvvvvvvvvvvvvvvv
vvvvvvvvfvfffvffvvfffffffffffvvvvfvvfffffvffffffvvvvvvvvvvvvvvvvvuvvvvvvvvvvvvvvvfffffffffffffffffvfffffffffffffvvvvvvvvvfvvvvvv
vvvvvvvvvvvvvvvvfffffffffffvvffvvvffffffffffffffvvvvvvvvvvvvvvvvvvvvvvuvvvvvvvvvffffffffffffffffffvfffffffffffffvvvvvvvvvvvvvvvv
vvvvvvvvvvvfvvvvvvfffffffffffvvvvfvvvffffffffffvvvvvvuvvvvvvvvvvvvvvvvvvvvvvvvvvvvffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvv
vvvvvvvvvvvffvffvvfffvfffffvvvvvvvvvfffffvffvfffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvffffffffffffffffvfvffffffvffffvvvvvvvvvvvvvvvvvv
uvvvvvvvvvvvvvvvvffffffffffvvvvvvvvvvfvfffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvffffvfffffffffffffffffffffffffvfvvvvvvvvvvvvvvvv
uuvuvvvvvvvvvvvvvvfffvfvffffffvvvfvvvfvvfffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffvfffvfffffvvvvvvvvvvvvvvfvvvv
vvvvvvvvvvvvvvvfvvvvvvfvvvvvvvvvvvvvvvffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvfffffffufffffffvffffffffvffvvvvvvvvvfvvvvvvuuuuu
uuvuuvvvvvvvvvvvvffvvvfvvvvvvvvvvvvfvvvvvvffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuffvvfffffffffffffffffffvfvfvvvvvvvvfvvvvuvuvvvv
uuvuuuuvvvvvvvvvvvfffvffffffvfvvvfvvvvfffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvfffvfffffffffffffffffffffffvvfvvvvvvvvvvvvvvvvuu
vvvvuvuuvvvvvvvvvfvvvvvvvvvvffffffffvfffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvfffffffufffffffvfffffffvvvvvvfvvfffvfvvuuuvuuuuu
uuuuuuuvvvvvvvvvvfvvvvvvvvvvffffffvffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvffvvfffffffffffffffffvvvvvvvfvvffffvvvvvvvvvuvu
uuuuuvuuuvvvvvvvvvvvvvvfvfffffffffffvffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvffffvffffvfffffffffffvfvvvvfffvvvvvvvvvvvvvvuuuu
vvvvuvuuuuvvvvvvvfvvvvvvvvvvvvvvfvvvvvfffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvffvfvvfffffffffffffffvfvvvvvvfvvfffvvvvfvvvvuuuu
vuuuuvuvvvvvvvvvvvvvvvvvvvvvvvvvfvvvvvvfvffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvfffffffffffffvffvvvvvvvvvvvvvvvvvvvvvuvuuuu
uuuuuuuuuuuvuvvvuvvvvvvvvfffffffffffvvfvvfffffvvffffffvvvvvvvvvvvvvvvvvvvvvvvvvvffvfvfffffffffffffffvvvvvvvvvvvvvvuuvuuuuuuvuuuu
vvvuuuvuuvvvvvvvuvuvvvvvvvvvvvvvfvvvvvvvvvfffffffvvvvvvvvvvvvvvvvvvvvvvvvvffvvvfffvfvfffffffffffffvvvvvvvvvvvvvvvuuuvuuuuvvvuvuu
uuuuuuuuuvvvvvvvuuuvvvvvvvvvvvvvfvvvvvvfvvvfffvvffffffvvvvvvvvvvvvvvvvvvfvffvvvvfvvfvfffffffffffffvvvvvvvvvvvvvvvuuuuvvvuuuvuuuu
uuuuuuuuuuvvvvvvuuuuuvvvvvvfvvffffffvvfvvvvfffvvffffffvfvvvvvvvvvvvvvvvvvvvvvvffffvfvffffffffffffvvvvvvvvvvvvvvvvuuuuuuuuvvvvvuu
vvvuuuvuuuuvvvvvuvuuuvvvvvvvvvvvfvvvvvvvvvvvfffffvffvvvvvvvvvvvvvvvvvvvffvffffffffffvffffffffffvvvvvvvvvvvvvvvvvuuuuuuuuuvvvuuuu
uvuuuuuvuvvvvfvvuuuvuuvvvvvvvvvvfvvvvvvvvvvffvvvffffffvffvvvvvvvvvvvfvfffvfffffvffffffffffffvfffvvvvvvvvvvvvvvvvvuuuuvvvffffuvuu
uvuuuuuuuuuvvvvvuuuuuuuvvvvvfvffffffvfffffffffvvffffffvvvvvvvvvvvvvvvvvvvvvvffffffffffffffffffvvvvvvvvvvvvvvvvvvuuuuuuuuuuuvuuuu
vvvuuuvuuuuvvvvvvvvvvvvvvvvvvvvvfvvvvvvvvvvffvfvffffffvvvvvvvvvvvvvfffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuvuuuu
uuuuuuuvuvvvvvvvuvvuuuvvvvvvvvvvfvvvvvfffffffvvvfffffffvvvvvvvvvvvvvfffffvfffffvfffffffvffffvvvvvfvvvvvvvvvvvvvvvuuuuvuuuuuuuuuu
vuuuuuvuuuuvvvvvvvvuuuvuvvvvfvffffffvvvffffffffffffffffffvvvvvvvvvvvvvffffffffffffffffvfvvvvvvvvvvvvvfvvvvvvvvvvuuuuuuuuuuuuuuuu
vvvvvvvvvvvvvvvvvvvvvuvuuvvvvvvvfvvvvvfffffffvfvfffffffffvvvvvvvvvvvfffffffffffffffffffvvvvvvvvfffffffvvvvvvvvvvuuvuuuuuuuuuuuuu
vuuvvvvvvvvvvvvvuvvuuuvuuvvvvfvvfvvffffffffffvfvfffffffffvvvvvvvvvvvffffffffffffffffvvvvvvvvvfvvvvvvvvvvvvvvvvvvvvvvuvuuuuuuuuuu
uuuuuuvvvvvvvvvvuuvvvuvuuuvvfvvvfvvvvffffffvfffffffffffffffvvvvvvvvfffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuvuuuuuuuuuuuuu
uuuuuuvvvvvvvvvvvuuvvvvvvvvvffffvvvvfffffffffvfvffffffffffffffffvvffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuu
vuuuvvvvvvvvvvvvvvvvffvfvvvfvfvvvvvvvvvvvfffvfvvffffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuvuuuuuuuuuu
uuuuuuvvvvvvvvvvvuuvvvvvvvvfvvvvvvvvvvfffffvfffffffffffffffffffffffffffffffffffffffvvvvvvfvvvvvvvvvvvvvvvvvvvvvvuuuvuuuuuuuuuuuu
uuuuuuvvvvvvvvvvvuuvvvvvvvvvvvvvvvvvfvvvvfffffvvfffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuvvvvvuvuuuuuvuu
uuuuuvvvvvvvvvvvvvvvvvvvvvvfvvvvfvvvvvvvvfffffvvfffffffffffffvffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuvuuuuvuuuuuuu
uuuuuuuuuuvuuvvvvuuvvvvvvvvfvvvvfvvvvvvvvffffvfffffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuvuuuuvuuuuuuu
uuuuuuvuvuuuvvuvvvvvvvvvvvvvvvvvvvvvfvvvvfffvvvvfffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuvvvuuuuuuuuuuuu
uuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvfvvvvvvvvvfffvvvffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuvuuuuuuuuuuuu
uuuuuuuuuuuuuvvvvvvvvvfvvvvvvvvvvvvvvvvvvvvffvffffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvuvvvvuuuuuuuvuuuuuuuuuuuu
uuuuuuuuvuuuuuuuuuuvvvvvvvvvvvvvuvvvvvvvvfffvfvvffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuvuuuuuuuuuuuuuu
uuuuuuuuuuuvvvvvvvvvvvvvvvvfvvvvuuvvvvvvvvvfvvffffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuvuuvuuuuuvvvvvvvvvvvvvvvfvffffffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvuvvuuuuuuuuvuuuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvuuvuvvvvffffvfvfffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuu
uuuuuuuuuuuvuuuvvvvvuuuuuuuuvvvvuuuuuuuuuuvvfvvvvvffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvuuvuuuuuvuuvuuuuuuuuuuuuv
uuuuuu88uuuuuuuuuuuuuuuuuuuuvvvvvvvuuuuuvuvvffvffffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuu
uuuuuuuuuuuuuuuvuvvvvvvvuuvvvvvvuuuuuuuvuuvuuvvfvvvfffffffffffffffffffffffffffffvvvvfvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuvuvuu
uuuuuv888uuuuuuuuuuuuuuuuuuuuuvvuuuuuuuuuuuvvvvvvfffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvuuuuuuuuvvvvvvvvuuuuuuuuu
88888u8888uuuuuuuuuuuuuuuuuuuuuuvvvuuuuuvuuuuuuvvvvfffffffffffffffffffffffffffffffvvvfvvvvvvvvvvvvvvvvvuuuuuuuuuuuuu8uuu88uuuuuu
u8uuuuuuuuuuuuuuuuuuvuuvuuvvvvvvvvuuuuuvuuvuuuuvvvvfffffffffffffffffffffffffffvfffvvfvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuvuuuuuuuu8
88888u88888u8uuuuuuuuuuuuuuuuuuuvuuuuuuuuuuuvvvvvvvvffffffffffffffffffffffffffffffvvfvvvvvvvvvvvvvvvuuuuuuuuuuuvvuuu8uu888uuu8u8
88888u88888u88uuuuvuuuuuuuuuuuuuuuvuuuuuuuuuuuuvvvvvvffffffffffffffffffffffffffvvvvvvvfvvvvvvvvvvvvvuuuuuuuvuuuuu8uu8u8888uuuuuu
u88888uuuuuuuuuuuuuuuuuvuvvvvuvvvvuuuuuuuuuuuuuvvvvvffffffffffffffffffffffffffffffffffffvvvvvvvuvvuuuuuuuuuuuuuuuuuuuuuuuuuu88u8
88888888888u88u8uuuuuuuuuuuuuuuuuuvuuvuuuuuvvvvvvvvvvfffffffffffffffffffffvvvffvfvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuu8uu88888888u8
88888uuuuuuuuuuuvvvuvuuuuuuuuuuuuuvuuvuuuuuuuuuvvvvfffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuu888888888uuuuuu
u8uuu888uuuuuuuu8uuuuuuuuuuvvuuuuuuuuuuuuuuuuuuvuvvffffffffffffffffffffvvvvvvvvfvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuu8888888
88888888888uuuuu88uuuuuuuuuuuuuuuuuvuuuuvvvvvvvvvvfvvffffffffvfffffffffvfvvvvvfvvvvvvvvvvvvvuvvuuuuuuuuuuuuuuuuuuuu8uu88888888u8
88u8888u888uuuuuuuuuvuuuuuuuuuuuuuuuuuuuuuuuuuuvuvvvvfffffffffffffffffvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuu8u8888uuu888u888
8888u888888uuuuu888uuuuuuuuuvvuuuuuuuuuuuuuuuuuvuvvvvvvvvfffffffffffvvvvvvvvvvvfvvvvvvvvvvvvuuuuuuuuuuvuuuuuuuuuuuuuuuuuu888u888
8u88888u888u8uuuuuuuuuvuuuuuuvuuuuuvuuuuvvvvvvvvvvvvvvvffffffvffffvfvvvvfvvvvvfvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuu8888888uuuuuu
8u88888u888uuuuu88uuuuuvvuuuuuuuuuuuuuuuvvvuuuuvuvvvvfvvvvffffffffvvfvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuu888888uuu888u888
8u888uuu8uuuuuuu88uuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvfvfvffvvvvvvvfvvvvvvvvvvuvvvvvvuuuuuuuuuuuuuuuuuuuuuu888888888888u888
88888888888u8uuu8uuuuvvvvuvuuvuuuuuvuuuuvvvvvvvvvvvvfvvvffvvffvvvvvvvvvffvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuvuvvvuu8u88888888uu8uuu
uu8888888888uuuu88uuuuuvvuvvuvuuuuuuuuuuvvvvvvvvvvvvvfvvvvvfvvvfffvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuu88888888u888u888
8888uuu888u8888u8uuuuuuuuuuuuvuuuvuuuuuvvvvvvvvvvvvvvvvvvvvfvvvvvvvvvvvvvvvvvvvvvvvuvuuuuuuuuuuuuuuuuuuuuuuuuuuu888888888888u88u
8888888888u888888uuu88888u8uuuuvvvvvvvvvvvvvvvvvvvvvfvvvffffffvvvvvvvvvvvfvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuu8u8888888888u888
888888888888uuuuuuuuuuuuuuuuuuuuuuuuuuuvuvvvvvvvvvvvvvvvvvvfvvvvfvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuu888u88888888u888
8888888888u8888u8uuu88888u88u8uuuvuuuuuvuuvvvvvvvvvvvvfvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuu8uu888888888888u88u
888888888888888uu88888888u88uvuuvvvvvvvvvvvvvvvvvvvvfvvvvvvffffvvvvvvvvvvvvvvvvvuvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu88u8888888888888
888888888888uuuu888888uuuuuuu88uuvuuuuuvuuvvvvvvuvvvvvvvvvvvfffvvvvvvvvvvvvvvvvvvuuuvvuvuuuuuuuuuuuuuuuuuuuuuuuu888u888888888888
88888u8888u8888u888888888u88u888uvuuuuuuuuuuuvvvvvvvvvvvvvvvvvfvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuu8u8888u8888uuuuuuuuu
o88888888888888uu88888888u88uuuuuvuuvvuvvvvvvvvvuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuu8uuuuu888u8888888888888
oo88888888888888888888uuuuuuu8888uuuuuuuuuuuuvvvuvvvvvvvvvvvffffvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu8888u8888888888o88
ooo8888u8uuuu888888888888u888888888888u88uuuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuu8u8888u8888u8888uu8888888
oo8o888888888888u88888888uu88888888888uvvvvvuvvvuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuvuuuuuuuuuuuuuuuuuuuuuuuuuu88888888888888888888
oooo888888888888u88888uuuuuuu8888u888uu888uuuuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvfvvvuuuuuuuuuuuuuuuuuuuuuuu8uuu888888888888888888o88
oooo8o8uuuuuuuu8u888u8888u888888888888u8888uuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvfvvuuuuuuuuuuuvuuuuuuu8uu88u888888888888888o8888ooo
8888888888888888888888888uu88888888888uuuuuuvuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvfvvuuuuuuuuuuuuuuuuvu888uuuuu888888888888888888oooo
oooo8o888888888u888888u88888uuuuuuuuu8888888uuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvfvfuuuuuuuuuuuuuuuuuuuuuu888u8888888888888888888oooo
oooo8o8u888888888888888888888888888888u88888u88vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuu888888uuuu888888888888o88ooooo
888888888888888888888uuuuuu88888888888uuuuuuvuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuu888uu8888888888888888ooooooo
oooo8o888888888888888888888uuuuuuuuuuuu88888888uuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuu8uu888888888888888888888o8o8oooo
888888888888888888888888888uuuuuuuuuuuuuvuuuuuuuvuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuu8888888u8888888888888888o8oo
oo88888888888888888888888u8u8uuuuuuuuuuuuuu8888uuuuvvvvvvvvvvvvvvvvvvvvvvvuuvvvuuuuuuuuuuuuuuuuuuuu888888888888888888888888ooooo
oo8u8888888888888888888888888uuuu88uuuuuuuu8888uuuuvvvvvvvvvvvvvvvvvvvvvvvvuuvuuuuuuuuuuuuuuuuuu8u8888888888888888888888888ooooo
oo888888888888888888888888888uuuu88u8uuuuuuuuuuuuvuvuuuuuvvvvvvvvvvvvvvvuvuuvvuuuuuuuuuuuuuuuuu8uu888888888888888888888888oooooo
oo88888888888888888u888888888uuuuuuuuuuuuuu8888uuuuvuuuuuvuvvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuuu888888888888888888888888888ooooo
ooo888888oooo8ooo888888888888uuuu88888uuuuu8888uuuuvvvvvvvvvvvvvvvvvvvuuuvvuuvuuuuuuuuuuuu8uuuu888888888888888888o8oooo88ooooooo
oo8888888ooooooooo88888888888uuuu88u888uuuuuuuuuuuuuuuuuuvuvvvvvvvvvvvvvvvvvuuuuuuuuuuu888888u88888888888888888888888888oooooooo

