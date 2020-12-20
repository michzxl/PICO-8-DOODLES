pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--assembly okay
--@???

function _init()
	dt=1/30
	t=0
	tf=0
	bk=9
	cls()

	medium_rare={
		0,
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

	if t>30 then
		t=rnd(17)-8
	end
	
	for i=1,80 do
		ox,oy=get_oxy()
		for y=oy,oy+bk-1,1.8 do
			for x=ox,ox+bk-1,1.2 do
				c = abs((x-64)/16)+64 + y/64
					+ t
					+ (x-64+t*4)\32*2*ct8+64
				c = flr(c) + flr(y/64-t) + 2*flr(y/90+t)
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
8ooooooiii0iiii0iii1iii1iiiiiooooooooooiiii1iiiiiiii11111111000iiiiiiiioiiooooooo8o8888888888vvvvvvvvvvvvffffffffff00fffffvvuvu8
o8ooi1iiiiiioooooiiiiiiiiiiiooooooioiiiiii1iiiiiiiiiiii11111hoiiiooooooooioioooo888888888888vv000vvvvvvvvffffffffffffffffvvvuufu
8ooooooii11iiii1iii1iiiiiiiioooooooooiiiiii1iiiiiiiiiii11111hhiiiiiiiooooooooooooo888888888o888vvvvvvvvvvfffffffffff0ffffvvvuvuu
iiiiiooiooiii1iiii1iiiiiiiiioooooiiiiiiiiiiii1iiiii1h1111111hoiiiooooooooiiioooo8o8888888888vv000v0vvvvvvvfffffffffffffffvvvuuv8
vvouuuuooiiii1iii1ii888i8888oooooooiooiiiiiiii88888888811111hhiiiiiooooooooooooooo8888888888vvvvvvvvvvvvuuufufffffuuuufu88vvuvu8
iiooooooooiiiooooi1iiiiiii1iohoooooioiiiiiiiiiiiiiii1i1111111oiooooooooooooooooo8o888880888888vvvvvvvvvvvffffffffffffffffvvvuuv8
ioooooiooiii111111ii88888888uuiiii0ioooiiiiiiii88i88888111h11oiooooooooooooooooooo8888888888vvvvvvvvvvvvuuufufffffuuuufu88vvvuu8
iooooooooooiiuuuu8i88iiiiiiiiooooi0iiiiiiu88i8888iii11111111ooioooooooooooooooo880888880888888vvvvvvvvvvffffffffffffffffvvvvuu88
ioooooiooiii111i10ii88888888uuoooooioooiiiiii1iiiii11i1111111oiooooooooooooooooooooo88888888vvvvvvvvvvvffufuuuuufuuuuufu88vvv888
ovvuuouuuooiiuuuu8i88i1i8888uuuuuooiooiiiu88i8888iii11111111ooiooooooiooooooooo8v0vvvvv0v888vvvvvvvvvvvvffffuuuufuuufffvvv88ooo8
ivvuuouuuoooiuuuuui88iiiii1i1hhiiiiioooiiiiii11i1ii1111111111uiuuuuuiuoooooooooooooo888o88888vvvvvvvvvvffufuuuuufuuuuuf888vvu888
ooooooiooiiiiiii1iiiiiii8888uuuuuooiuouuuuu88888811111111111ooioooooooooooooooooooo8888o8888vvvvvvvvvvvuuuuuuuuufuuuuuv88888ooi8
ovvvuouuuoiiiuuuuu18811118881uuuuuuuuuuui888i1i1111011111111uuouuuuuouooooooooooo0oooooo88888vvvvvvvvvuuufuuuuuufuuuffvvvvvv8888
ooooiooiiiiiiiiiiiiiii1i8881uuuuuuuiuuuuuuu888888888188111111uiuuuuuouooooooooooooo8888888888vvvvvvvvvfffufuuuuufuffffvvvv88ooi8
ovvvuouuuoiiiiiiiiiiii1i18881uuuuuuuuouuuuuu88888818888888oouuiuuuuuooooooooooooo8oooooo88888vvvvvvvvuuuuuuuuuuufuuuffvvvvvvvoii
ooooooooooiiii1iiuiuu8888881uuuuuuuiuuiiiiiiiii8888888818ooo11iiiooooooooooooo0ooooo888888888vvvvvffvvv0fufuuuuufuffffvvvv88ooio
ovvvvouuuiiiiiiiiiiiii1i11101ouuuuuuuuuuuuu888888818881888oo1oiiiioooooooooooooooooooo8o88888vvvvvvvvuuuuuuuuuuufuuuff888888oiii
ooooooioooiii0ii1u1uu888888ivuuuuuuiuuuiiiiiiii88888888188oo11oiioooooooooooooooo8oo888888888vvvvvvvvfffffffffffffff0fvvv88u8oii
ouuuuooiiiuiuuuuuiu1111111111ouuuuuuuuuuuuu888888888888888oo1ooiiiooooooooooooooo888oo8888888vvvvvvvuuuuuuuuuufffffffv888888iiii
ouuuuuiuu0iii0iiuuuuuu8888i81o1uuuuiuuuuu8uu8u8888i1888188oo1ooooouuuuuouuooooooo8ooo88888888vvvvvvvfuuufffffffuufuu888vv88v8iii
ouuuuuouuiuiuuuuuiui111888818uuuuuuuuuuiui8u888888888888888o1ooooouuuuuouuoooooo88888888888888vvvvvvuuufuuvvvvv00f0ffv880888iiuo
oooooo0iiiiiiiiiuuuuuu8888888u1uuuuuuuuuuuuu8u8888888888888o1uuooooooooooo8ooooo8o880888uuuu88vvvvvvuuuuuuuuuuuuuuuu888vv88v8iii
ouuuuuouuouiuuuuu0ui0i1888818uuuuiuuuuuiuiu8888i81i1111111111ooooouuuuuouuoooooo888888888vvf8vvvvvvuuuuuuuuuuufuuuu088880888iiv8
voooiiiiiiuiuuuuuuuuuuu888888uuuuuuuuuuuuuuuiu8888888118oooo1uuoooooooooooooooooo88888888vvf8vvvvvvvuuuuuuuufuuuuuuu888uu88v8iii
vuuuuuouuoiiiiiiii1uiuu888888u1uoo0ooooiioiiii888i88881111111oouuouuuuuoo888ooo8o88888u8888888vvfvvuuuuuuuuuuuuuuuuv888888888iii
ouuuuouuuuuuuuuuuuuu8u8888818uuuuuuuuuuuuuuuiuu888888118ooooouuuuuuouo8uuu8uuvvvvvvvvvvvvvffvvvvvvvuuuuuuuuvvv0uu0u888888888iiii
vvuuuuouuoiiiiuuuuuuuuuu8888v1uoooooooiiiiiiii888i888811111111ouuiuuuuuoo888ovvvovvvvvv8vvfvvvvvvvvuuuuuuuuuuuuuuuu88888v888ii8i
vuouuuuuuu0uuuuuuuuuuuuu88888uuuouuuiuuuuuuu8uu8888881111ooooouuuuuouo8uuu8uuvvvvvvvvvvvvfffvvvvvvuuuuuuuuuuuvv00000888888888iii
vvooooooooiiiiiiuuuuuiu888888vvuuuuuuuuuuuiuii888i8888818888u1ouuouuuuu8888ouvvvvvvvvvv8vvfvvvvvvv0uuuuuuuuuuuuuuu8v8888v888iiii
vuuuuuuuuuuuuuuuuuuuuuuu88888vvvuouuiii88i88888888888i111ooo1ouuuouuuuuuuu8uuvvvvvv8vvvvvfffvvvvvvuuuuuuuuuuuvvuuu8v88888888iiii
vvooooooouuu8iuuuuuuu8u8ii888vuuuuuuuuiiiiii8888888888888888uuuooouuuuuuuuu8uvvvvvvvvvvvvvfvfvvvvvuuuuuuuuufffvvvvvuuuu8v888iiii
vvuuuouuuuuuuuuuuuuuuuuu88888vvvu0uuiiiiiiiiu8i88888i881oooooouuuuuuuuuuuuuuvvvvvvv8vvvvvfffvvvvvuuuuuufffffvvvvvv8888888888iiii
ouuuuouuuuuuuuuuuuuuu8uu11888vuuuuuoooiioiii8888888888888888uuuooouuuuuouu88vvvvvvvvvvvvfffuvvvvvufuuuffffffffvvvvuuuuu88888iiii
vvooooiioiiuuuuuuuuuuuuu88888vvvuuuuuu88i888u888888888888888uouuuuuuuuuuuuuvvvvv8vvvv8vvvffffvvvvuuuuuuffffuuuvuu88888888888iiii
ouuuuuuuuuuuuuuuuuouiiii11888vuuuuuoooooo8u88o8888i0ii1ooooooouuu8uuuuu8uuuuvvvvvvvvvuvvvvvvfvvvvufuuuufffffvvvvvvuuuvu88888iiii
ooooooooooiuuuuuuuuuuuuu88888vvvvuuuuuu8iiuuu88u888888888888u1uuuuuuuuuuuuuvvvvvuvvvvuvvvffffvvvuuuuuuuffffuuuuuu88888888888iiio
vuvuuuuuuuuuuuuuuuu88i8888iiii888888ooooo888uu888888i888ooioouuuu8uuuuu8uvuuv0vuvuvvvvvvvffffvvvuuuuuuvuuuuuuuvu888uu8888888iiii
v8ouuuuuouvuuuuuuuuuuuuu8i888ouuuuuouuu888uu888u88888888888oouu888uuuuuuuvvvvvvvvvvvvvvuvvvufvvvuuuuuuuuvuuvvvuu8888888u8888iiio
vuvouuuuuvuuuuouuu88uuuuu8888uvvvuuuuuuuuuuu8uouuuoiiiii000000000uuuuuuuvv88888uvuvvvvvvvvvffvvvffvvuuvuuuuuuuvu8888u8888888i8ii
vuuvuuuuuvvuuuuuuuuu888888i888v8uu0uuuuuo8uu88888888i88iiiii0i1uouuuuuuuuvvvvvvvvvvvvvvufvfufvvuuu8uuuuuvuuvvvu8u888888o8888ioii
v8vvvvuuouuuuuuuuuuuuuuuu8888uvvvuuuuuuuuuuuu88888888i0i88888ivv8uuuuuuuvvv88fufvfvvvvfvfffffvvufvvuuuuuvuuuuuvu8888u888u8888iii
vuu8vvvvvovvuuuuuuu8888888888vu8uuuuuuuuoouuu8u88888o88888888uuuuuuuuuuuvvvvvvvvvvvvvvvvfvffvuvuuu8uuuuvuuuuuvuouooooouooooo0ooo
vvvvvvvuouuuuuuuuu8uuuuuui888ivvvvuuuuuuuuuuu88888888i8888iiii8uuuuuuuuvvvv88fffvfvvvvfvffffvvvuuu8uuuuuvuuv0vv888888888o8888iii
vvvvvvvvvvvvuuuuuuu8888uu8888vvvvuuuuuuuuuuuuuu88888o88888888uuuuuuuuuuuvv888vvvvfvvvvfvffffuuu8888v88uvuuuuu8uoooooo888u8888iii
vvvvvvvuuuvvuuuuuu8uuuuuuu888vvuvvuuuuuuuouuuuu888888i8888888uuuuuuuuuuvvvv88vvvvvvvvfffffffvvvuuuuuuuuu8uu88v8vuvu88888o880uu11
vvvvvvvvvvvvuuouuuuuu8uuu8888vvvvuuuuuuuuuuuuooioo888u888888ouuuuuuuuuuvv88v8ffffffffffvffffvvuuuuuuvvvuuuuvuu8ooooououuu88u8iii
vvvvvvvuvuuuuuuuuuuuuuu888888vvuvvvuuuu0oouuuuuu888u8uu888u88uuuuuuuuuuuuvvvvvvvvvvvvfffffffvvuuuu8vvv808888uu8v88888888o88uoo11
vvvvvvvvvvvv000uuu0uuuuuu8888vvvvuu8uuuuouuuuuu888888i888888uvvuuuuuvuu0888v8fffffffufuffvffvuuuuuuuvvvuuuuvu88oooo88888o88u8iii
vvvvvvvvvvvvuuvuuuuuuuu888888vvvvvvvvvvvvvuuuouu88ouuuu888u88uuuuuuuuuuvvvvvv8vvvvvvffffffffvuuuuuvvvv8v8888u88u8888uuuu0uuuuuuo
fvvvovvvvvvovvouuu0uuuuuuu888vvvvuuvuuuuuuuuuuuuuo888i888800ii8vvvvuuuu8vvvf8fffffufffffvvvfvu8uuuuuvvvuuuuvu88o8888ooooooouoouo
vvvvvvvuvvvuuuvouuuuuiuuuu888vvvvvuvvvvvvv0ooooo0iiuuuuu8u88uuvuuuuuuvvvfffffffvvvvvffffffffvuuuu8888v888v888oooooouooouuuuuuuuo
080oo8vvvvvovvvuvuuuuuuuu8uuuffvvvuvuuuuuuuuuuvuuouuuuuiuuu88vivvuvuuvvvfvf8f08vvvvvffffffffuu8uuuuuvvvuuuuvu88ooooouoooooouooii
vfvvvvoo0ovvvvvivvuuuiuu88088vvvvvuvvvuuvuuuuuvuuuuuuuuuuu88uuvuuuvvvv88ffffffffvvvvfffffvffuuuuuuu888888v88ooooooouooouooooou11
v0vvvvvooooovvovvvuuuuuuu8uuuffvvvuvuuuuuuuooooiiiuuuuuuuu88uuuuuuuuvvvvfvfff0fvvvvvfffvvfffuu8uuvvvvvvuuuu88888oooouuouooooouii
vfvvvvvvvvvvvvvvvvvvvuvvuuu88vvvvvvvvuuuvuuuuuvvvuuuuuuuuuu88uuuuvuuvff8fff88fffvvvfffffvvvvvv88888888888888ooooooouooou8808iiii
000008o0ovvuuouuuvvuuuuuui8uufvvovvovvvuvvvvoooiiiuuuuuuuuuuvvvvvvvvffffvfv8ff0vvvvffffvvfffuu8uu8888888uuu8o888ououuuouooooiiii
vfvvvvvvvvvvvvvvvvvvvuvvvuuuuffvvvvvvuuuvvvvvuvvvuuuuuuuuuuuvuuuuvuuvfffffffffffffufffvfvvvvv88888888888888ooooooooooooo88o8iiii
00000vvvvvvvvvvuuoouuuuuuuuuuvvvvvvvvvuuvvvvvuvvvuuuiuuu88uuvv8vvvvvfffffffffffffffffuuuufffuuuuu88888888888oooo88888u88ooooiiii
vvvvvvvvvvvvvvvvvvvvvuvvvuuuufffffvvvvvvvvouuuuouuuuuuuuuuuuuvvvvvvffvvfvfffffffffffvvvvvvvvv88888888888888ooooooooooooo88ooiiii
vffffvfvvvvvvvvvvvvuuuuuuuuuuvvvvvvvvvuuvvvvvuvvvuuuuuuuuuuufvvvvvvvffffffffffffffffuufffffuvvvvv8888888888ooooo88888o88oooiiiih
vfvvvvvfvvvvvvvvvvvvvuuuuuuuuffvf0vvvvvvvvuouoooo0uuuu0uuuu8ufvvvvvffvvfffffffffffffvvvvvvvvv8888888888888oooooo88888o88ooii1111
fffffvfvvvvvvvv0vvouuuuuuuuuuvvvvfvfffvvvvvvvvvvvuuuuuuuuuuufvvvvvvvffffffffffffffffvvvfvvvuvv88v8888888888ooooooooooooooioi1111
ffffffvfovvvuovvvvvvvvvuuuuuuffvfvvvvvvvvvvovooooouuuuuuuuu8fffv8fffvfvffffffffffffvvvvvfvvvv8888888888888ooooooooooooooooii111h
ffffffvfvvvvvvvovvuuvuuuvvvvufffffvvvvvuvvvvvvvuvuuuuuuuuuuufffvvfffffffffffffffvfvvvvvvvvvvv8888888888888oooooooooooooooioiiihh
fffffffvfffvvvvvvvvvvvvuuuuuuuvfffvfvvvvvvvvvvvuuuuuuuuuuuiuufvv8vvvvfffffffffffffffvvvvvvvv88888888888888oooooooooooooooiiiu11h
ffffffvfvuvvvvvvvvuvvuuuuvvvuffffffvvvvvvvvvvvvuvuuvuvvuuuuufffvvfffffffffffffffvfvvvvvvvvvvv88888vvv888ovooooooooooooouuu0u111h
fffffffvffffvvvvvvvvvvvuuuuuufffffvfvvvvvvvvvvvuuuuvuvvuuuuuffvv8vvfffffffffffffvvvvvvvvvvvv888888888888o8oouooooooooooooiii1i1h
fffvvvvvvvvvvooououuvvuuuuuuuuvvfvvvvvvv000ouvvvvvvvvvviuuuuffffvffffffffffffffffvvvvvvvvvvv88888808v888ovoooooooooooooooiiii11h
fffffffvffffvvvvvvvvvvvuuiuuufffffvfvvvvvvvvvvvuuvvvvvvvuuuuffvvvvfffffffffffffvvvvvvvvvvuvvv88888888888oooouooooooooooooiii1i1h
fffffffffffffvvvvvvvvvvuuuuvvffvfffvvvvv000vvvvvvvvvvvvuvuuuffffvffffvfffffffffffvvvvvfvvvvv888888888888ooooooooooooooooiiii0110
ffffffffffffffvvvvuvvuuuuuuuufffffvffvvvvvvvvvvuuvvvvvvvuuuuu8vvvvfffffffffffffvvvvvvvvvvvvvv8888888888o8oooouooooooooooiiii111h
fffffffuffffv8v8vuvvvvuuuuuvvffffffvvvvfvvvvvvvvvvvvvvvuvuuufffvvffffffffffffffvvvvvvvvvvvvv8888888888888oooooooooooooooii00000h
fvffffffffffffvvvvuvvuuuuu880fff0fvffvvvvvvvvvuuuvvvvvvvuuuuufvvvvffffffffffffffvvvvvvvvvvvv88888888888o8oooo8ooooooooooiiii111h
fffffffvffff088uvuvvuuuuuuuvvfffffffvvvfvvvvvvvvuvvvvvvuvvuufffvvffffffffffffffvvvvvvvvfvvvv8v88888888888oooooooooooooiiiiii0ihh
fvfffffffffffffvvvvvvuuuu0uu0uvvvv0fffvvvvvvvvvvuvvvvvvvvvuuffvvvvvffffffffffffvvvvvvvvvvvvvv888888888oo8oooo8oooooooooiiiiii11h
vvvvfffffvff088uuuuuuuuuoo0vvffvffffvffffvvvvvv08vvvvvuvvuouuffvffffvffffffffffvvvvvvvvvvvvv8v8888888888ooooooooooooooi00iiii11h
vvvffffffffffffvvfvvvvvvvvuu0ffffvvfffvvvvvuvvuuvuvvvvvvvuuuuffvffffffffffffffff0fffvvvvvvvv8888uoo888ooooooo88888888oiiiiiiihhh
uuuvfffffvff088uuuuuuuuuuvvvvfffffffvffffvvvvvvuuuuvuuuuuuuuufvvvvv0vvvffffffffvvfvvvvvvvvvv8v88888888ooooooo8oo88880oooiiiii11h
ffvffvfffvffffuvvffuvvvvvvuu00fffvvvvvvvvvvuvvvvvvvvvvvvvuuuuffvffffffffffffffffv0vvvvvvvvvv888o888888oooooooiii8o8oooiiiiiiihhh
vvvvfffffvff088uu8uuuuu00vvuvfffffffvffffvvvvvvvvvuvuvvvvvuuuffvfffffffffffffvvfvfvvvvvvvvvv8v88888888ooooooo0oo0088ooiiiiiii11h
ffvffffffvffffvvvffuvvvvvvuvvffffffffffffvfuvvv0v0vvvvvvuuuuuuuufffffffffffffffffvvvvvvvvvvv8888888888oooooooo0ooo8oooiiiiii01hh
ffffffvvfvvvvvvvvvvvuuuuuvvuvffffffvvvvvvvvvvvvvvvvvvvvvvvuuuffffffffffffffffvvfvvvvvvvvvvvv888888888oooooooooooooiioiiiiiiiihhh
fffvvffffvffffuvvffvvvvvvvvvvffffffffffffvfvvuvuvvvvvvvuuuuu0fffffffffffffffffffvvvvvvvvvvvv888888888ooooooooooooo0ooiiiiiiii1hh
vfvvfvffffvvvvvvvvvvvvvvvvvvfffffffvvfffvfvvvvvvvvvvvvvvuuuuuffffffffffffffffvf0vvvvvvvvvvvv88888888oooooooooooooooooiiiiiiiihhh
vffvvvvffvvvffffvffvfvvvvvuvvffffffvfffffvfvvvvvvvvvvvvuuuuuufffffffffffffffffffvvvvvvvvvvvu88888888oooooooooooooo0oiiiiiii11100
vfvvffff00vvvvvvvvvffvvvvvvvfffffffvfffffffvvvvvvvvvvvvvuvuuufffffffffffffffvvvvvvvvvvvvvvvu88888888ooooooooooooooooiiiiiiiiih10
vfvvfvfffffvffffvfvvffvvvvvvvvffffffvfffvffvvvvvvvvvvvuuuouuufffffffffffvvffffffvvvfvvvvvvvu8888888o8oooooooooooooooiiiiii111100
vfffffffffvvffffvfvfffvvvvvvvvfufffffffffvfvvvvvvvvvvvuuuvvuufufffffffffffvfvvvvvvvvvvvvvvvu8888888ooooooooooooooooiiiiiiiiihhhh
vfvvfvv0fvfvvfffvvvvvfvvvuvvvfffffffffffvffvvvvvvvvvvvuuuuuuuffffffffffvfvffvvvvvvvvvuvvvvvu8888888oooooooooooooooooiiiiiiiiihh0
vffffvffff0vffffvffffffvvvvvvffffffffffvvvvvvvvvvvvvvvuuuvvvufffffffffffffvfvvvvvvvvvvvvvvvu88888888oooooooooooooooiiiiiiiiihhhh
vvvvfffffffvvffffvvvvffvvvvvvfffffffffffvfffffvvvvvvvuuuvvvvfffffffffffvvvvvvvvvvvvvvvvvvvvu8888888ooooooooooooooooiiiiiiiiiiihh
vvvffvffffffffffvffffffvvvvvvffffffff0fvvfvvvvvvvvvvvvuvvvuuuffffffffffvfffvvvvvvvvvvvvvvvuu88888888oooooooooooooioiiiiiiiiihhhh
vvvfffffffffffffffvffffvfvvvvvfffffffffffvvfffvvvvvvvv0vvvvvfufff0000000fffvvvvvvvvvvvvvvvuu8888888oooooooooooooooiiiiiiiiiiiihh
vvvffffffffffffvffvfuuuvuvvvvfffffffffvvvvvvvvvvvvvvvvuuvuuuuffffffffffffffvvvvvvv8v88888vovu88888oooooooioooooooioiiiiiiiiihhhh
ffffffffffffvfffffvffuuvuvvv8vvffffffffffvvffffvvvvvvvvvvvvvfufff0ffffffffvvvvvvvvvvvvvvvvuu888888ooooooooooooooooiiiiiiiiiiiihh
vvvvfffffffffffvffvvvvvvvvvvvffffffffffffvvfvvvvvvvvuvuuuuuuuffffffffffffffvvvvvvvvvvuuvvvvvu88888oooooooooooooooioiiiiiiiiihhhh
vfffvvvffffffffffvfuuuuvvvvv8888ufuuuuffvvvuuuuvvvvvvvvvvvvvuuufuuuuffffffvvvvvvvvvvvuuvuvuu88888ooooooooooooooooiii1i111ii1iihh
88vv888ufuuufffffffvvvvvvvvvvf88uuuuuuuuuffuuuuvvvvvuvvvvvvvuufffffffffffvvvvvvvvvvuuuuvvvuvu888o8ooooooooioooooohhhihhhhiiihhhh
fffffffffffffvffvvvvvvvuvvvv888ffuuuufuuufffvffvvvvvvvvvvvvvuuufuuuuvfffffvvvvvvvvvvvuuuuuvuiii8i111ooooooooooiooiiiiiiiiiiiihh0
888f8888fuuufffffffvvvvvvvvvvf888fuuuuffffvffffvvvvvvvvvvvvuuuufuuuufffffvv88v88888vvvuuuuuuuuooooooiiooooioo1o1hhhhhhhhhhhhhhhh
888f888uffffffffvvvvvvvuvvvv888ffuuuufuuuuuuvuuvvvvvvvvvvvvvuufffvffffvffv88888v88vvvuuuuuuuiii8i111ooooooioiioooiiiiiiiiiiii1h0
88ff8888fuuufffffvfvvvvvvvvvvf888uuuuuuuufvfffvvvvvvvvvvvvvvuuufuuuuvffffvvvvvvvvvvvvvuuuuuuuiio11111iiiiiooi1o1hhhhhhhhhhhihhhh
88888888fuufffuuuuuvuuvvvvvvuvfffuuuufuuuuuufuuvvvvvfvvvvvvvuuvvvvvvvvvffv88888888v888v0ooooiiii1111ooooooioiiii11iiiiiiiiihhhhh
8fv88888f8uufffffffvvvvfvvvvvf888uuuuuuuuuuuuufuvvvfvvvvvvvvuuufuuuuffffffffvvvvvvuvvvuuuuuuuiio11111oooooooi1o1hhhhhhhhhhhhhhhh
888f8888ffffffuuuuuvuuvvvvvvuvfvfffffffuuuuuuuuuvvvvvvvvvvvvuuvvvvvvvvvvvvvfvv8888v888vuooooiii11111oiooiiiiiiii11iihhhhhihhhhhh
8v888888u8u00vvv0vfvvvvvvvvv8f8uuuuuuuuuuuufuuvvvvvvvvvvvvvvvfffffuuufuu88fvvvv88v88888uooouoii111111ooooioiiii1ihhhhhhhhhhhhh1h
888v8888ffffffuuuuuuuuuuuuvu8f8uuufffffuuuuuuuuuvvvvvvvvvvvvuuuvvvvvv0fffv888v8888u888vuooooui1111111iiiiiiiiii1110hhhhhhhhhhhhh
8v888888u8u00vvv0vvfvvvvvvvvvvfff8uuuuuuuuufuuuvvvvvfffvvvvvvfvfffuuuuu8888vvv888888888vooouoi1111111i1oiiiiiii1ihhhhh1hh1111110
888888u8uuffffuuuuuuuuuuuuvu8f8uu8ufuuuuuuuuuuuuvvvvvvvvvvvvuuuvvvuuuvu88888888888uvvvvuooooui111111100000iiiiihhhhhhhhhhhhhhhhh
88888888v88vvfuuuuuuuuvvvvvvvfvvvvvuuuufuuufuuuvvvvvfffvvvvvvv0vvvvuuuu8f8888v8888888o8voooooi1111111i11iiiiii11111i0iiiii1i1110
88888888uufffvvvfffufuuuuuvu8v88uuvuuufuuuuuuuuuvvvvvvvvvvvvuuuuuuuuuv888888888888uuuuvvuuuuu8oiioiiiii111i111hhhhhh1hhhhhhhhhhh
8v8888uvvvvvvfvffffuuvvvvvvvv8vvuuuuuuuuuuufuuuvfvvvvvfvvvvvvvvvuvuuuu8888888u88888888o8oooooi1111111111111111hhhh1h1111111hhhh0
888888u8uuuuuvuuuufuuuuuuuvuv8888uuuuuuuuuuuuuufvvvvvvvvvvvvuuuuuuuuuu888888888888uuuu88ooouo1uiiiiiiiiiiiiii11hhhhh1hhhhhhh1hh0
88888888888uuuuffffuuuuuuuvuu88v888uu88uufuuuuuuvvvvfffvvvvvuuuvuvuuuu8v8uu88u8888888ooioooio1111111111111111hhhhh1h111hhhhhhhhh
888888v8vvfvvvuuuuuuuuuvvvvvv8888u8uuuuuuu8uuufuuvvvvvvvvvvvuuuuuuuuu888v888888888uuuuuiiiuiih1i11111i1hhhihh00hhhhh1hh000101h00
88888888888u8uuuuu8uuuvuvvvuu8888888uu88ffffffffffffffffvvvv8uuuuvuuuu8v8vu88u8888888ooiooi0ihi11i11111111111hhhhh1h11111hhhhhhh
888888v8vvfvvvvuuuuuuuuuuuuuu8888888uuuuuuvuuufuuvvvfvvvuvvvuu8uuuuu8v88v88888888o88ooouoouuuuuihhhhhihhhhih000hhhhh1hh00h1h0hhh
888o8888888u8uuuuuuu8uuuuuuvuo88888uuu8888v8fffffffffvvvvvvv8uuuuuu88o88ooooououuuuuuuoiiiiuihihhhhh11111111hhhhhh1hhhhhhhhhhhh1
88vvvv88v8uuuu88888uuuuuuuuvu8888888u88fvfvv88f888uuuufuuuuvu888vvvv888ov888o8888o88ooouoooo181iiiiiiiiihh1hhhhhhh0h11111010h111
888o888888888uu8888uu8uuuuuvuoooo888uuuuu8uuvffffffffvfvvvvvvvvv8v888oooo888o8888oouuuuuuuuu0u0hhhhh1111i11h1111hhh0hhhh00hhhhh1
oo8888o8888888u88f8uuu88uuuvo888888888888f8888f888uuuuvuuuuvu888vvvv88ovo888o8888uoooiiuiiiihihhhiiiiiiiii1hhhh0hh01000100h0hhh1
888888f8888888f8888uu8uuuuu8uoooo88888uu8u888uufuffvffffuuvvv8uuu8u888oov888o8888oouuuuu88u888ihhihhhhhiiih00001hhh0hhhh000h1111
vo888v888v8888f888ffff88f88uoooo88ff88888f88ffffff88uuvuuuuv0vvvvvvv8oovoo8o88888u8oooooiooihih11111i110000h1hhhhhhhhhhh00h0hhh1
ov8888v888vff8v8888uu8uuuuu8ooooo888888u8uf80fffffvuuuuuuuvuv8uuu8u8oooovoooooouooouuuiuiiiihhhhhhhhhhhhiih000000000000000hh1h11
oooooo8888oo8oo888ffffffffuuu88oo888888u8u88ffffff888ufuuuuvuo888vov8oo0ooooooooouioooooiooi11111111011hhh000000hhh0hhhh00hhh11i
oooo88ooooo8oo888888f8888888oooooo88888888f8ffffffvuuuuuuuuuu888888oooooooooooo88oooooooiooiihhhhhhhhhhhii0000000000000000hhh111
ooooooooooooooo888uuvuu8uuuuuooooo8ooooo8888ffffff888uvuuuuvuoo888oooooooooooooooouuuiiiiiiihhhhhhhhhhhhh00000000000000000hhh1h1
ooooooofffv888888888u8888888oooooo88888888v8ffffffvffuuuuuuuuv888v88ooovoooooooooiiiiiiiiiiiihhhhhhhhhhhh00000000000000000hhh111

