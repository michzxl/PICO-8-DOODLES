pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- basic template

function _init()
	dt=1/30
	t=0
	tf=0
	bk=8
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
	
	for i=1,70 do
		ox,oy=get_oxy()
		for y=oy,oy+bk-1,1.5 do
			for x=ox,ox+bk-1,1.2 do
				c = abs((x-64)/32)+64 + y/32
					+ t
					+ (x-64)\32*2*ct8+64
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
f8u8o8oiioiiiiooooooooooo8v888uouvuuuuuuuvvvvvvuuvuuuvuvvvvfffvvvvvvvvvvuuuuuuuuvuffffffffffffffuuuuuuuvvuvvvvvvvvvvvvvvvvvvvvvv
8iioofooiioiiiioooooooooooouu88ouvuuuuuuvuvvvvvvuvuuuuuvvvvvfffvvvvvuvuuvvvfffffffffffffffffffffuuuuuuvvvuuvvvvvvvvvvvvvvvvvvvvv
8iio888iiiiiiiioooioooooooo88888vvuuuuuuuuvvvvvvvvvvuvuuvvvfvvvvuvvvvvvvvvvfffvffffffffvffffffffuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvv
8fvvfffo888888888oioioooovvvv88ouvuuuuuuuvvvvvvvuvuuuuuuuvvvvfvvvvvvvvvvvvuf8fffffffffffffffffffuuuuuuvvvvvvvvvvvvvvvvvvvvvvvvvv
iiioiiooiiiiiiioooiiooooooou8888vuuuuufuvvvvuvvvvvvvvuuvuuuvvvvvvvvvvfvvvvvfffffffffffffffffffffuuuuvuvvvvvvvvvvvvvvvvvvvvvvvvvf
iiioiiiiiiiiiiiiuoiiiiooooouu888vuuuuuvuvfvvvvvvvvvvvvvvvffffvvvvvvvfvvvvvvffffffffvfffvffffffffuuuvuvvuvvvvvvvvvvvvvvvvvvvvvvvv
uooooooo8iioiiiii8i8iiioo88u8888vvvvvuuuuvvvufuuvvvfvuuvuuuuvvvvvvvfffvvvfvf8fffffffffffffffffffuuuvvuvvvvvvvvvvvvvvvvvvvvvvvvvv
iiioiiiiiiiiiiii8iiiviiio88u8888vuuuuuuuuvuuufuuuvvfvuuvuuuuvvvvvvvvvvvvvvvffffffffffffffvffffffuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
iiioiiiiiiiiiiiiiiiuiiiiiuuuuuuvvuuuuuvuvvvuvuuuuuvvvvvvvvvvfvvvvvfffvvfffvffffffffvffvfvfffffffuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
ooooooooiiiiiiiii8888uuoooo8oooouuuvvuuuuvuuuuuuuuvvvvvvuuuvvvvvvfffffvfffffvfffffffffffffffvfffuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
iiiiiiiiiiiiiioo8o8ooooo888888uouuuuuuuuuuuuuuuvvvffvvvvvfvvvvfvffffuffvvvffffffffffffvfvfffffffuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
iiooiiiiiiiiiiiiiiioooooooooiioouuufuuvvuuuuuuuuuuvvvvvvuuuufuuuffvfvvvvffffffffffffffffffffffffuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
iiiiiiiiiiiiiiiii88u8ooooooooooouuuuuuuuuuuuuuuuuuuuuvvvuuuuvuuvffffvfffffffvffffvffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvfvfv
iiiiiiiiiiioiiii8iioooooiiuiiiii88uuuuuuuuuuuuuuvvuuuvuvvvvvvuuuffffffffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvfvfffv
iiiiioooiiiiiiiiiiiiioooooooiioi888uuuuvuuuuuuuuuuvvvvvvuuuuvuuuffvfvvvufvfffffvvvvvfvffffvfffffvvvvvvvvvvvvvvvvvvvvvvvvvffvffff
iiiiiiiiiiiiiiiiii8iiiiiiioiiiiouuuuuuuuuuuuuuuuuuuuuuuuuuuuvuuvfffffffffffffffffffffffffvvfffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvvfff
iiiiiiiiiiiiiiii8iiiioioii8iiiii88888uuuuuuuuuuuuuuuuvuuuuuuuuuufffffffffffffffvvvffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvffffvvfff
iiiiiiiiiiiiiiiiiiiiiiiiooooiioi888888uvuuuuuuuuuuuuvuvvuuuuuuuuffvffffffffffffffvfffffvvvvvffffvvvvvvvvvvvvvvvvvvvvvvfffffvffff
oiiiiiiiiiiiii8iii8iiiiiiiiiiiiiuuuvuuvvvuuuufuuuuuuuuuuuuuuuvvfufvffffffffffffffvffffvvvvffffffvvvvvvvvvvvvvvvvvvvvvfvfvfvfffff
iiiiiiiiiiiiii8iiiiii8iiii8iiiii8u8888uuuuuuufuuuuuuuuuuuuuuuuuuffvfffffffffffffffffuffffvvvfvvvvvvvvvvvvvvvvvvvvvvffvffffffffff
ooiiiiiiiiiiii8iiiiiiiiiiiioiiii8u8888uuuuuuufuuuuuuuuuuuuuuuuuuffvffffffffffffffufffvvvvvvvvvfvvvvvvvvvvvvvvvvvvvvvvvvvvfffffff
iiiiiiiiiiiiiioiiiiiiiiioiioiiii88uuuuuvuuuuufuuuuuuuuuuuuuuuuvvvffffffffffffffffufvfvvvvvfvvvvvvvvvvvvvvvvvvvvvvvfffvffffffffff
i11iiiiiiiiiiioiiioooooooo88888i8v8888uuuuuuufuufffffuuufuuuuuvufffffffffffffffffvfffvfvvvvvvvvvvvvvvvvvvvvvvvvvvvffffffffffffff
o1111iiiiii8888iioiiiioooiioiiii8888u888uuuuuuuufuuuuuuuvuuuuuvvvffffffffffffffffvfvvvvvvvvvvvfvvvvvvvvvvvvvvvvvvvvvffffffffffff
iiii1iiiiiiiiioiiiiiiiioiiiiiiii888888uvuuuuuuuuvuuuuuuuufvvfvvvvfffvffffvfffffffffvvvfvvffvvvvvvvvvvvvvvvvvvvvvvvffffffffffffff
1111111iiii8oooooooiioooooooo8ii8u8888888uuuuuuvvuuuuuuuuuuufffvvffffffffffffffffffffffffffvvvvvvvvvvvvvvvvvvffvvvffffffffffffff
111111iioooooo8iioiiiiioiiiiiooouu88u888888uuuuuuuuuuuuuvuuuvvvvvvffffffffffffffffvvvvvvvfvvvvvvvvvvvvvvvvvvvvvvvvffffffffffffff
i1i11iiiiiiioiiooooiiiioiiiiioii8u888uu8v888uuuuuuuuuuuuuvuuvvvvffffffffffffffffffffffffvfvvvvvvvvvvvvvvvvvvffffffffffffffffffff
1111111oiiii8iioooo8oooo8oooooii8u888888888uuuuvvuuuuuuuuuuuvvvvffffffffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffff
111i111voooooooooo8iiiioiiiiiooo8u88888888888888u8uuuuuuuvuuuvvvfvffffffffvfffffvffvvvvvvvvvvvvvvvvvvvvvvvvfffvfffffffffffffffff
i8iiioiiiiiioiiooooiiiioiiiiioii88888uu8f8888888u888uuuuuuuuuuuufffffffffffffffvvvfvfvvvvvvvvvvvvvvvvvvvvvffffffffffffffffffffff
11111111111ioiiiiovvvvii8oiiiioi8u88888uuuuuuu88v8888uvuuuvuuuvvfffffffffvvffffvvvvvvvvvvvvvvvvvvvvvvvvvfvffffffffffffffffffffff
uiii11111111iiioiooiiiioiiiiiioi888888u8u8888888uuuuuuuuuuuuuuuufffffvffvvvfvvfvvvvvvvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffffff
11i11uiiiiiioiiiiioiiiiiiiiiiooi88u8888uu888v888v8888uuuuuuuuuuuffffffffffvvvvvvvvfffvvvvvvvfvvvvvvvvvvfvfffffffffffffffffffffff
11i1111111111iioio8888ioiiiiiioi888888u8uufuuu88v8888uvuuuuuuuuvfffffffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffff
u1ui111111111iiiioiiioiiiiiiiioi88u88888u8888888uuuuuuuuuuuuuuuuffffffffffvvvfvvvvvvvvvvvvvvvvvvvvvvvvvfvfffffffffffffffffffffff
11i11iiiiiiooooooiiioiiiiiiii8oi88u88888uuufvu88u8888uuuuuuuuuuuffffffffffvvvvvvvvfvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffffffff
1111111111111iiiii1iiiiiiiiiiioi888888uuv8v88888vvvvuuvuuuuvvvfufffffvvvfvvffffvvvvvvvvvvvvvvvvvvvvvvvffffffffffffffffffffffffff
u1iiii111i111iiiiiiiiiiiiiiiiiii88888uuuu8u88888uuuufffvfffuuuuuffffvvvvfvvvvvvvvvvvvvvvvvvvvvvvvvvvffffffffffffffffffffffffffff
1i11111111i1ooooii11ii1i11iii8oi88f888uuuuuufuuv8u8uuuuuuuu88uuuffffffffffvvvvvvvvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffffffffff
1111111111i1fo1iii111i1i111iiiii888888u888u888888888uuuuuuuuuuuuffffvvvvfvvvfvvffvvvvvvvfvvvvvvvvfvfffffffffffffffffffffffffffff
11111iioiio1111111iiiiiiiiiiiiii888888888888888888888888uuv888uufvvvvvvvfvvvfvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffffffffffffvv
11111111111111i11111111i111118oouf8888888888fvvv8v8888u8uuu8888ufvffffffvvvvvvvvvvvvvvvvvvvvvvvvvvffffffffffffffffffffffffffffff
1111111111i18oiiii11111i11111iii8888888888u8888888888888u8uuuuuufvvvvvvvvvvvvvvfvvfvvvvvvvvvvvvvvvffffffffffffffffffffffffffffff
11111111i11111i111i1111111i1iiii88888888888888888888888888vuvuuuvvvvvffffffvfvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffffffffffffff
11111111i11111i111iiii1i11111o1o888888888888uuvv888888888uuuuuuuffffffffvvvvvvvfffffvvvvvvvvvuvvffffffffffffffffffffffffffffvfvv
11111111i1181111iiiii11111111i1o888888888888888888888888u8uuuuuufffvvfffvvvvvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffffffffffffvvv
111111111111111111ii111111i1iiiouuu8888888888u8u8888888888vufuuufvfvvvvvfvvfvvvvvvvvvvvvvvvvuuvfffffffffffffffffffffffffffvvvvvv
ooii1111i11iiioiiiiiii1111111o1o8888888888ufuuvv888888888ff8uuuufvffffffvvvvvvvvvvvvvvvvvuvuuuvvfffffffffffffffffffffffffvvvvvvv
111111111111111111i111111111111ioooo888888888u8u8888888v8vv88uuuvvfvvvvvvvvvvvvvvvvvvvvvvvvvvvvvfffffffffffffffffffffvvffvvvvvvv
1111111oi11i111111i111111111i111888888v888888u8u8888v88v8888v88uvvvvvvvvvvvvvvvvvvvvvvvuuuvuuuuuffffffffffffffffffffffffvvvvvvvv
h111i1111111111111oi111111111111ooooo888888vuuuuuf88888v8888888ufvvvvfvvvvvvvvvvvvvvvvuuuuvuuuvvffffffffffffffffffffvvvfvvvvvvvv
111111111111111111o111111111111ioooooov888888u888888888f8ff88888vvfvvvvvvvvvvvvvvvvvvvvvvfvvvuuufffffffffffffffffffvvvvfvvvvvvvv
hh11hhhhohh1111111i1111111111111oo888888888uuu88888888vv8888u88ffvvvvvvvvvvvvvvvvvvvuuuuvvvvvuuuffffffffffffffvvvvvvffffvvvvvvvv
hhhhh1hh1111111111o111111111i111oooooo8o888u88uuuv8888888888u88vvvvvvvvvvvvvvvvvvvvuuuuuvvvvvvvvffffffffffffffffffvvvvvvvvvvvvvv
1hhhhhhhhhh111111111111111i1111ioooo8888888v8888888888888888uuuvffvvvfvvvvvvvvvvvvvvvvvvvfvvvuuuffffffffffffffffvfvvvvvvvvvvvvvv
hhhhhhhhvhh11h1111o1111111111111ooo888ooo8888888888888vv8888u88uvvvvvvvvvvvvvvvvvvvuuuuvvvvuuuuuffffffffffffffffvfvfvvvvvvvvvvvv
hhhhhhhhhvuuvu81o111111111111111ooouooooooo8888uuvuuv8v88888888vvvvvvvvvvvvvvvvvvvvvvfvvvvvvvuuufffffffffffffffffvfvvvvvvvvvvvvv
1hhhhhhhhhh11i11i1111111111111iio8ov8ooooooo8888888888v88888888uvvvvvfvvvvvvvvvvvvvvvfvvvfvuuuuuffffffffffffffvvvvvvvvvvvvvvvvvv
hhhhhhhhihhiiioii111111111i11111ooouooooo8ooo8o888888888888u888uvvvvvvvvvvvvvvvvvvuvuuuuuvvuuuuufffffffffffffvvvvvvvvvvvvvvvvvvv
hhhhhhhhhiiuiio1o111111111111111oooouoooooooo888u88888u88888888uvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuffffffffffffffffvvvvvvvvvvvvvvvv
hhhhh1hhiiiiii11i111118111111111oooo8oooooooo8oo8888888888888888vvffvvfvvvvvvvvvvvuvuuuuuuuuuuuuffffffffffffvvvvvvvvvvvvvvvvvvvv
hhhhhhhh1iii1i1h1111111111111111ooooooooooooo8ooo8888888888uu88uvvvvvvvvvvvvvvvuvuuuuuuuuuuuuuuufffffffffffffffvvvvvvvvvvvvvvvvv
h1hhhhiiiii81i11111111111111111iooooooooooooo888v88888u888888888vvvvvvvfffvvvvvvuuuuuuuuuuuuvuuufffffffffffffvvvvvvvvvvvvvvvvvvv
hhhhhhhh1iiiii1hhhh1111111111111oooouoooooooooooo8oo888888888888vvffvvvvvuuvuuuuuvufuuuuuuuuvuuvfffffffffffvvvvvvvvvvvvvvvvvvvvv
hhhhhhhhhi8i1i1hhhhh111111111111oooooooooooooo88u8u8888888888888vvvvvvvvvvvvuvuuuuuuuuuuuuuuuuuufffffffvvfvvvvvvvvvvvvvvvvvvvvvv
1111hhhhhhhhhi11111111111111111ioooooooooooo8888f888888u88888888vvvvvvvvfuuvuuuuuuuuuuuuuuuuuuuuffffffvvvvfvvvvvvvvvvvvvvvvvvvvv
hhhhhhhhhhhiiihhhhhhh1hh111o1111o8oooooooooooooo88u888888o888888vvvvvvfvfuuuuuuuuuvuuvvvuvuuuuuufffffffffvvvvvvvvvvvvvvvvvvvvvvv
hhhhhhhhhihhhihhhhhhhhh1i11111iioooooooooooo8oooo8u88888oo888888vvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuuffffvvvvvvvvvvvvvvvvvvvvvvvvvvvv
1111hhhhhhhhhoooo1hh111111111111oooooo8ooooo88uufuu8888888888888vvvvvvvvvuuvuuuuuuuuuuuuuuuuuuuufffvvfvvvvvvvvvvvvvvvvvvvvvvvvvv
hh1hhhihhhh1i1hhhhhhhoh111111i11oooooooo8o8o8ooooou88888ooo8o888vvvvvvfvfuuvuuuuuuuuuuuuuuuuuuuuffffffvvvvvvvvvvvvvvvvvvvvvvvvvv
ih1111hhh1hhhihhh1hhh111111111118ooooooouo8o8ooooou88888ooo8oo88vvvvvvvvvffvuuuuuuuuuuuuuuuuuuuufffvvvvvvvvvvvvvvvvvvvvvvvvuvvvv
ii1hhhhhhhhhhhohhhhhh1h111i11111oooooo8ooooo8ooooo88888o88888888vvvvvuvvvvfvvuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
iio1111111111hhhh1hhh1h111111111ooooo88o8o8o8ooooo888888ooo8ooo8vvfvvvvvvvvvuuuuuuuuuuuuuuuuuuuufvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvu
hhhhhhh1hhhhhhhhhhhhhihh1h1h1111vfffoouoooouuuuuooooo8ooooo8ooo8vvvuuuvvvuvuuuuuuuuuuuuuuuuuuuuuvvfvvvvvvvvvvvvvvvvvvvvvvvvvvvvu
hhhhhhh1hh11ihohhhhh11111h1hh1118ooooo8ooooo8oooooooo8o88888uuv8vuvuuuvvuuuuuuuuuuuuuuuuuuuuuuuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvuv
11hhhh1hhhhhhhhhhhhhh1hhh111o1118oooo888888o8ooooo888fuvu8888888fvfvvvvvvvvvuuuuuuuuuuuuuuuuuuvuvvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuu
hjhhhhh1hhhhhhhhhhhhh1hhhhihhh118888oo8oooo8888uooooo8o888888888uuvuuuuuuuuuuuuuuuuuuuuuuuuuuu8uvvvvvvvvvvvvvvvvvvvvvvvvvvvuvuuu
jjjhhhhhhhhhhhhhhhhh11111111i1oi888ooo8oooooooooooooofouuuuuu8v8uuvuuuuuuuuuuuuuuuuuuuuuuuuuu88uvvvvvvvvvvvvvvvvvvvvvvvvvvuuuuuu
j1jhhh1hhhhhhhhhhih111111111i1ii88iooo8oo8888ouooooo88u888888888vvvvvuuuvuuuuuuuuuuuuvuuufuu8uuuvvvvvvvvvvvvvvvvvvvvvvvvuuuuuuuu
jjjjhhhhhhhhhhhhh1h111181188iiii88888u888888888oooooooo888u8ooo8uuuvuuuuuuuuuuuuuuuuuuuuuu888u88vvvvvvvvvvvvvvvvvvvvvvvvvuuuvuuu
jjjjhhhhhhhhhhhhhhh111111111i1ii88iioo8oo8oooooooooo8v888u8888uuvvvuuuuuuuuuuuuuuuuuuuuu8u888888vvvvvvvvvvvvvvvvvvvvvvvuuuuuuuuu
jhjjjhhhhhhhhhhhhihhhhhhhhhiiiii88iiiiuoooo88o8ooooooo888888ooo8uuuuuuuuuuuuuuuuuuuuvuuuuuu88888vvvvvvvvvvvvvvvvvvvvvvvuvuuuuuuu
jjjjjjhhhhhhhhhhhhhhhhhih188iiii8u8uuuuoooooooooooooooooo888oooouuuuuuuuvuuuuuuuuuuuuu888u888888vvvvvvvvvvvvvvvvvvvvvvuuvuuuuuuu
jjjjhjhh1hhhh1hhhhh1hhhhhhhiiiii88iiiioiooooooooooooouooou8888uuvvuuuuuuuuuuuuuuuuuuu8888u888888vvvvvvvvvvvvvvvvvvvvvuuuvuuuuuuu
jjjjjjhhhhhhhhhhi1hhhhhhhhho1111o8iiiioiiooooooooooooo888888oooouuuuuuuvuuuvuuuuuuuuuuuuuuu88888vvvvvvvvvvvvvvvvvvvvvvuuuuuuuuuu
jjjhhhhhhhhhhhhhhhhhhhhhhhhhhhhhovoooooooooooooooooooooooooooooouuuuuuuuuuuuuuuuuuuuuu888u888888vvvvvvvvvvvvvvvvvvvvuuuuuuuuuuuu
jjhjhhh11hhhh1hhhhh1hhhhhhh1hhhhovooiooiioooooooooooo8ooooooo888uuuuuuuuuuuuuuuuuuuuuuuuuu888888vvvvvvvvvvvvvvvvuuuuuuuuuuuuuuuu
jj1j81hhhhhhhhhh11hhhhhhhhhh1h11ov8oiiooooooooooooooooo8oooooooouuuuuuuuuuuuuuuu8u88888uuuu88888vvvvvvvvvvvvvvvuuuuvvuuuuuuuuuuu
jjjhjhhhhhhhhhhhhhhuhhhhhhhhhhhhioooooo88oo8ooooooooooooooooo88ouuuuuuuuuuuuuuuuuuvuuuuuuu88v888vvvvvvvvvvvvvvvvvvuuuuuuuuuuuuuu
jjjjjjjhhhhhhhhhhhh1hhhhhhh1hhhhovooooooooooooooooooooooooooooo8uuuuuuuuuuuuuuuu8u88888uuu888888vvvvvvvvvvvvuuvuuuuuuuuuuuuuuuuu
jjjjjjjjhhhhhhhh1111111hhhhh1hhhiiooooo88ooooooooooooooooooooooouuuuuuuuuuuuuuuu8888888uvvvu8888vvvvvvvvvvvvuuvuuuuuuuuuuuuuuuuu
hjjhjjjjjjjhjjhhhhh1hhhhhhhhhhhhiiioioooooooouoooo8ooooooooooo88uvuuuuuuuuuuuv8uuuuuuuuuuuu88888vvvvvvvvvvvvvvuuuuuuuuuuuuuuuuuu
jhhhhjjjjjhhhh1hhhh1hh111hhhhhhhiioooo8ioiiiiioooooooooooooooooouuuuuuuuuuuu8u8u8888888u88888888vvvvvvvvvvvvuuuuuuuuuuuuuuuuuuuu
hjjhjjjjjjjjjjhhhhhhh1hhhhhhhhhhiiioiioi8iiiiiioooooooooooooooo8uuuuuuuuuuuuuuuu8u88888uuuv88888vvvvvvvvvvvuuvuuuuuuuuuuuuuuuuuu
1jjhjjjjjjjhjj1hhhhhhhhhhhhhhhhhiiioiiooooooo8oooooooo8ooo8ooooouuuuuvuuuu888u88888u888888888888vvvvvvvvvvuuuuuuuuuuuuuuuuuuuuuu
hhhhojjjjjhjhhhhh1111111hhhhhhhhiiiooo8ioiiiiiiiiiiioooooovooooouuuuuuuuuuuu8u888888888888888888vvvvvvvvvuuuuuuuuuuuuuuuuuuuuuuu
jjjjjjjjjjjhjjhhhhhhh1hhhhhhhhhhiioo8ioioiiiiiiii8ooofuuuuuooooouuuuuuu8uuuuuuu8u88888uuuu888888vvvvvvvuuuuuuuuuuuuuuuuuuuuuuuuu
j11oooujjjjijj11hhhhhohhhhhhhhhhiiiiooooooooo8ooiiiioiouuuuooooouuuuuuuuuuuuu888888u888888888888vvvvvvvvuvuuuuuuuuuuuuuuuuuuuuuu
jjjjhjjiiih1hhhhhhhhhhh1hhhhhhhhiiiiiiiioiiiiiiiiiiioiio8ooooooouuuuu888uuu88u888888888888888888vvvvvvuuuuuuuuuuuuuuuuuuuuuuuuuu
jjjjhjjiiihihhhjjjjhjjhhhhhhhhh1iooo8iiioooouoo8oooooooooooooooouuuuuuuuuuuu888888888888u8888888vvvuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
jjjjihhhhhhh1hhhh1hhhhh1hhhh1hh1iiiiioiiiiiouooviiiiuiiooooooooouuuuuuuuuu8888888888888888888888vuvuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
jjjjjjj111i11i1jjjjhjjh1hhhhhhh1iiiiiiiiiioooo88iiiioiiooooioooouuvuuuuuuu888u8888888888v8888uuuvvvvvuvuuuuuuuuuuuuuuuuuuuuuuuuu
jjjjhjjhhjjh1hhjjjjojjjjjj1j1111o8iiiiiiiiiiiiiooooooooooooooooouuuu888uuu88u88uuuu8888888888uu8uuvuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
jjjjjjjhhjjj1hhhh1hhhjjjjj1j11hhiiiiiiiiiiioiiiiiooo8oooiiiiioio8888888uu8888888888888888uuuuuu8uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
jjjjjjj11111111jjjjhjjj1jjjjhhh1oiiioiiii8iioouuuouooooooiiiioiiuuu88888u8888u8888888888u888888ouuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
jjjjuhhhhjjjhjhjjjjhjjjjjjjjhhhhiiiiiiiiiii8iiiiiiiiioiiiioooooo8u88888u8888u88888888888888888oouuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu8
jjjjjjjhhjjj1jjhhhhhhjjjjj1jhhhhiiiiiiiiiiiiiiiioiiiioiiiiiiioii8u8888888888u888888888888u888888uuuuuuuuuuuuuuuuuuuuuuuuuuuuuu88
jjjjjjjhhohhhhhhihh1hjj1jjjjjhhhiiii8iiiiiiiii88uiiuiiiioiiiioiiuuu88888u88888u888888888888u8ooouuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu8
jjjjj1hh111hhhjhhh8hhjjjjjjjjjjhiiiiiiiiiiiiiiiiiiiiiiiiiiioiioo8u88888888888888888888888888oooouuuuuuuuuuuuuuuuuuuuuuuuuuuu8888
jhhjjj1jjjjhjjjjhhhhhhhhi11ihhhhiiiiiiiiiiii88888iiiiiiiiiiiioiiuuu8888888888888888888888u888888uuuuuuuuuuuuuuuuuuuuuuuuuuu88888
jjjjjohjjjjhjjhhihhhhjjjjjjjjjjhioiooiiiiiiiiiiiiiioiiiioo8ooooou888888888888888888888888888oooouuuuuuuuuuuuuuuuuuuuuuuuuuu88888
hjhhhjhjjjjhjjjjjhjjjjjjjjjhhhhhiiiiiiiiiioiiiiiiiiiiiiiiioooooou8888888888888888888888888888ooouuuuuuuuuuuuuuuuuuuuuuuuuu888888
hhhhhhjjjjjhjjjjjjjjh11111hhhhhhi8iiiiiiiiiiiiiiiiiiiioiiioioiii88u88888888888888888888888888o8ouuuuuuuuuuuuuuuuuuuuuuu8uuuu8888
jjjjjhhjjjjhjjjhjjjjjjjjjjjjhhhhiiiiiiiiiiiiiiiiiiiiiiiioooiiiii88888u88888888888888888888888ooouuuuuuuuuuuuuuuuuuuuuuuuu8888888
hhhhhhjhjjjijjjjjjjjjjjjjjjjhhhhiiiiiiiioioiiiiiiiiiiioiiioiioii88u888888888888888888888o888888ouuuuuuuuuuuuuuuuuuuuuuuuu8888888
hhhhhhjhhjjijjjjhjjjjjj1jjjjjjhj18iiiiiiiioiiiiiiiiiiiooiooioiii88u88888888888888888888oo8o8oooouuuuuuuuuuuuuuuuuuuuuu8uu8888888
jhjhjhjjjjjhjjjhjjjjjjjjjjjjhhjji11111iioioiiiiiiiiiiioiiooiiiii88uuuuuu888888888888o888ooo8oooouuuuuuuuuuuuuuuuuuuuuu8888888888
hjjhhjjjjjj1jjjjjjjjjjjjjjjjjjhj1iiiiiiiiiiooooiiiiiiioiiiiiiiii88u888u888888888888oo8oooo8ooo8ouuuuuuuuuuuuuuuuuuuu8u8888888888
hhhjjhhhjjjjhjjjjjjjjjjhjjjjjjjj111111iiiiiiiiioii8ooiioooiioiii88u88888888888888888o8ooooo8ooo8uuuuuuuuuuuuuuuu8888888888888888
jjjhhhhhjhjjjjjjjjjjjjjjjjhhhhjji11111iioiooi1iiiiiiiiiiiiiiiiii88uuuuuu8888888888ooo88ooooooooouuuuuuuuuuuuuuuuuu88888888888888
hhhhhjhhhjjhjjjjjjjjjjjjjjjjjjhj1iii1o1iiiiioiiiiiiiiiiiiiiiiiii88u8uuu888888888o8ooo88ooo8ooooouuuuuuuuuuuuuuuu8u88888888888888
hhhhjhhhjhhjjjjjjjjjhjjhhhjjjjjj11111111i11111i1iiiiiioiooiioiii888u88888888888888888888oooooooouuuuuuuuuuuuuu8u8888888888888888
hhhhhhhhhhhhjjjjjhjjjjjjjjjjjjjj111111iiooooi1i111iiiiiiiiiiiiii8888888u888888ooo8ooo88ooo8ooooouuuuuuuuuuuuuuuuu888888888888888
hhhhhhhj1jjjjjjjjjjjjjjjjjh1hhhhiiii1o11111111i11iiiiiiiiiiiiiii88888888888888888888888ooooooooouu8uuuuuuuuuuuu88888888888888888
hhhjjhhhjhhhhhhhhjjjhjjhhhjjjjjh11ii1111111111i1111iiioioiiiiiii888v8888888888888888888ooooooooouuuuuuuuuuu8uu888888888888888888
hhhhhhhjjjjjjjjjjhjjjjhjjhjjjjjh11ii11111i11i1i11111iiiiiiiiiiii88u8888888888888888888888o8ooooouuuuuuuuuu88u8888888888888888888
hhhhhhhjhjjjhhjhhhjhjjjjj1iiiihhiiiiiii1i111111111111iiiiiiiiiii8888888888888888888888oooooooooouuuuuuuu8u88u8888888888888888888

