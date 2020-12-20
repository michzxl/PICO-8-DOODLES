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
	
	for i=1,70 do
		ox,oy=get_oxy()
		for y=oy,oy+bk-1,1.2 do
			for x=ox,ox+bk-1,2 do
				c = flr(sin(x/64+y/16)-y*(sin(x/64)))/40
					+ sin(x/80 - t/8)
					+ t
					+ x\32*st8
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
-- by @felice on pico-8 bbs
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
8888888o8oooioiooooooioii0iioioiiiioiooooooooooo8o8888888888888888080000080o0ooooooooo0i0i0iiiii1111111111111111111111111i1i0i0i
88888888888oo8iooooooooioi0ooooiiiiiiioooooooooooo8o88888080880888888080088ooooooooooooiiii0iiii11111111111111111111111i1iiiiioi
8o8o8o8o8o8oooiooooooooooo0o0o0iiiiiiiiooooooooooo8o88808888888888888080088ooooooooooooiiii0iiii111111111111111111111111101iii0i
8o8o8o8o8o8ooo0ooooooooooo0oooooiiiiiiii0o0ooooooooo888888888888888080800888oooooooooooo0i0i0i0i010101011111111111111111i1iioooo
8o8o8o8o0o0o0o0ooooooooooo0oooooiiiiiiiiooo0oooooooo8880888888888888880888888oooooooo0oooiiiiiii11111111111111111111111111iiiiii
8o8o888o0o0o0o0oooooooooo0i0ooooiiiiiiiioooooooooooo8880808888888888888888888oooooooooo0o0i00i0ii1111111101111111111111111iiiiii
8o8oo8oo0oooooooooooooooo0i0ooooiiiiiiioooo0o0ooooo8o8808088888888888080888888oooooooooooiiiii0ii1111111111111111111111111iiiiii
888o8o8o0oooooooooooooooooooioioiiiiiiiioio0o0o0o0o0o08080888888888888888888888ooooooooooiiiii0i010101000001111111111i1i10iiiiii
888o8o80808o8oooooioooooooooioioiiiiiiiioioo0oooooooo888808888888888888888888888oooooooooiiiii0iii1i1111111111101111110101i1iiii
88808o8o8o8o8ooooooooooooooo0oioiiiiiiiiooooooooooooo88880888808888888888888888ooooooooooiiiii0iii1i1111111111111111010101i1iiii
88808o8oooooo0ooooooooooooooioioiiiiiii0i0oooooo0o0o08080088888888888888888888888oooooooooiiiiiiii1111111111111111110101i1i1iiii
8u8888808o8o8oooooooooooooooioioiiiiiiiiiiioooooooo0o0000080888888888888888888888oooooooooiiiiiii11111111111111111011111i1i1iiii
8u88888o8o8o8ooooooooooooo000iiiiiiiiiioioioooooooooo8o80080888888888888888888888oooooooooiiiiii01000000111h1h1h1i0i11i1i1i1iiii
8u88888o8o8o80oooooooooooooo0oioiiiiiiiiiiioooo0ooooooo8808080808808080888888888oooooooooo0i0i0i010111111h1h1h1h1i1i1i1iiiiiiioi
8u88888o8o8o8oooo8ooio0o0o0o0oioiiiiiiiiiioiooooooooooo880808080888888088888888880o0o0o0o0iiiiii0i0110111111h11010111111i1i1iiii
8u8888888o8o8oooo8ooioio0o0o0o0o0i0i0iiiiiioooo000000000808080808888888888088888ooooooooooiiiiii010110101h1h1h1h10111111iiiiiiii
88888o888o8o8oooo8oooooooooo0o0oiiiiiiiiiiioo0o0ooooo8o8888888888888888880888888ooooooooooiiiiii010110111h1h1h1h101111111i1iiiii
8u8888888888o8o8o8oooooooooo0o0oiiiiiiiiiiioi0o0oooooooo088888888888888888088888o8ooooooooiiiiii110111111h1h1h1h10101010iiii0iii
80o00888888888o8oooooooo0oooooooiiiiiiiiiiioi0o0oooooooo88888888888888888808888888ooooooooiiiiii110111111h1h0h0h101111111i11i1ii
888888ooo888888o8888ooooooooooooiiiiiiiiiii0i0o0oooooo0o88888888888808080808088888ooooooooioii0i0101111111h1h1h0h01111111111i1ii
888888o8o8888888o8o8ooooooooioioiiiiiiiiiii0i0i0o0o0o0000088888888888888880808888oo0ooooooiiiiii1101010101h1h1hhhhh111111111i1ii
888888o8o8o888888o8oo0ooooooooooiiiiiiiiiii0i0i0oooooo0o080808080888888888080888888oooooooiiiiii1101010101hhhhhhhhh111111111i10i
8u88888o888888888o8oo0ooooooooooiiiiiiiiiii0i0i0oooooo0o080808080808080808088888888oooooooiii0i01101010101hhhhhhhhh111111i11i1oi
808o8o8o88888888888oo0ooooooooooiiiiiiiiiii0i0i0oooooo0o080808088888888808088888888ooooooooiiiii11111101010h0h0h0h010101010i0i0o
0u08o8o0o8888888808oooooooooooooiiiiiiiiiii0i0i0o0o0o000000888888888888808088888888oo0o000oiiiii1111110111hhhhhhhhhh111111i1010i
8u8u888o88888888808oooooooooooooi0iiii0iiii0i0i0o0o0o0000808888888888888880808888888ooooooiiiiii1111110h01h1h1hhhhhh1111110i0i0i
808o8o8888o8o8o8o0o0o0oooooooioiiiiiii0000i0i0o0o0o0000o08088888808080888808888888888ooooooiiiii1100000011hhhhhhhhhh111111ii0i0i
u0uouo888808o8o8o0ooooooooooooooiiiiiiiiii0ii0o0o0o0000o088888888080808888088888888880oo0oooiiii1111100010hhhhhhhhi1111111iiiiii
u8u8u8888808o8ooo0ooooooooooooooiiiiiiiiiiiio0o0o00000ooo888888880808088880888888888ooooooooiiii11111000101h1h11i1i111111111iiii
u8u8u8o80808ooooo08oooooooooooooiiiiii0i0iiio0i0ooooooooo8888888808080888888880888888oooooooiiii1111100111h1h1h1h10111111111iiii
u8u8u8o80808080o008oooooooooooooiii0i0i0i0i0i0i0iooooooo88888888888888888888880888888oooooooiiii11i1101111h1h1h1h1i1111i111ioioi
888888o80888888o8000ooooooooooooiii0iiiiiiiiioi0oooooooooo888888888888888888880888888oooooooiiii011110111111011111i1i10101iiiiii
u8u8u8o8080808080080o0o0o0ooooooiiiiiiiiiiiiioi0iooooooooo888888888888888888888888888oooooooiiiii1111011110111111111i10i0ii1i1ii
u8u8u8080888888880808080o0ooooooiiiiiiiiiiiiioi0iooooooooo888888888888888888888088888oooooooiiiii010101010101h1h111101i1i0i1i1ii
8888888808888o8o8o8o80o0o0ooooooiiiiiiiii0i0i0i0iooooooooo888888088888888888888888888oooooooiiiii1111111h1h1hhhh010101i1i0i1i1oi
88888u8u08888o8o8o8o8o80o0ooooooiiiiiiiiiiiiiii0iiooooooo0808088888888888888888888888oooooooii0i01011111h1hhhhhh1h1101iiiiiioioi
88u8uuuu0uu88o8o8888888oo0o0o0o0i0i0i0iiiiiiiii0i0i0o0oooo888888888888888888888888888oooooooiiiii11111h1hhhhhhhh1h1101010ii1i1oi
u8u8ou0u0uu88o8o8o8o8o8oooooooooiiiiiiiiiiiiiii0ioooooooooo888888888888808888888888888ooooooi0iii11111h1hhhhhhhh1h110111iii1o1oi
80uuuuuu0u0u080o88888888ooooooooiiiiiiiiiiiii0i0iooooooo0oo888888888888088888888888888ooooooiiiii1111110hhhhhhhh1h110111iii1i1oi
u0uuuuuu0u00000o88888888o0ooooooiii0iiiiiiiii0i0i0oiooooooo888888888888008888888888888ooooooiiiii11011hhhhhhhhhh0h010111iiiiiioi
u8uuuuuu0u0u080o080888888oooooooiiiiiiii0i0iiiiii0i0o0ooooo888888888888008888888888888oooo0oiiiii1111hh1hhhhhhhh0h01010i0iiioioi
u8u00u0u0u8u8088880808080o0oooooiiiiiiiiiiiiiiiiiiiioooooo888888888808000u888888888888oooooo0iiii1111hhhhhhhhhhhhhh0h11iiiiioioo
u8uu8u8u0u88888o880888888ooo0o0oiiiiiiiiiiiiiiii0i0iooooooo888888888888000808888888888ooooooiiiii1111hhhhhhhhhhhh1h1h110i0ioooio
808u8u8u8u8888888o0o8o8o8oooooioii0i0iiiiiiiiiiiiiiioooo0oo8888888888880008uuuu88888888ooo0oi0iii1111h1hhhhhhhhhh1h1h110i0iiooii
888u8u8u8u8888888808888o80o0ooooiiiiiiiiiiiiiiiiiiiiooooooo888888888888000u0u8u88888888ooo0oiiii11111h1hhhhhhhhhh1h1h1010iiioooi
o8o0008080888u8888o88888ooooooooiiiiiiiiiiiiiiiiiiiiooooooo8888888880880u0uuuuu88888888ooooooii011111h1hhhhhhhhhh1h11101iiiiooii
88u0u08088888u88o8o88o8oooooooooiiiiiiiiiiiiiiiiiiiiioooooo888888888088uuuuuuuu888888880o000i0i01111111h1h1hhhhhh1h1h101iiiiooii
88u8u00088888u8888888oooooooooooiiiiiiiiiiiiiiiiiiiiooooooo888880808088uuuuuuuu88888808ooooooii011111h1h1h1hhhh1h0h1h101iiiiooii
88u8u0808080808000888oooooooooooiiiiiiiiiiiiiiiiiiioioooooo888888888888uuuuuuuuu8888888ooooooii011111h1h1h1hhhhhhhhh1h01iiiio0i0
88u8u08088888uo8o88888oooo80o0o0i0iiiiiiiiiiiiiiiiiiiooooooo888888888888uuuuuuuuu888888ooooooii010111h1h0h1hhhh1h0hh0h01i1iio0oi
80u0u80888888u8uouo808o8oo8oooooiiiiiiiiiiiiiiiiiiiiiooooooo88888888888uuuuuu0u0u088888ooooooii011111h1h1h11hhhhhhhh0h0h010i0000
o8o80808888888888u888888ooooooooiiiiiiiiiiiii0iiiiiiiioooooo88888888888uuuuuuuuuu888888o8ooooii010111hhhhhhhhjhjhhhhhhh0h11i1iio
88u8u808888888888u888888o080o0o0i0i0iiiiiiiiiiiiiiiioioooooo0808888888uuuuuuuuuuu888888o8ooooiii11111hhhhhhjhjhj1j0h0h0hh11i1iio
0808080888u888888u888888o88oooooi0i0i0i0i0i0iiiiiiiiiioo0o0o8888888888uuuuuuuuuuuu88888ooooooii0101010h0h1hjhj0j0jhhhhhh11ii1oio
88888888u8u8u08888888888o88oooooiiiiiiiiii1iiiiiiiiiiioooooo0888888888uuuuuuuuuuuuu888888oooooii11010hh0h1hjhjhj1jjhhhhhh11i1iio
88888888uuu8u0880u080888888oooooiiiiiiiiii00iiiiiiii0i0o0o0o8888888888uuuuuuuuuuuuu888888oooooiii1111h1101hjjjjjjjjhhhhhh11i1iio
888888uuuuu8u8u88uuu888888ooooooiii0i0i0i000iiiiiiiiii0o0o0o888088888uuuuuuuuuuuuu0888888ooooiii11111hh0h0h0jhjhjhjhhhh1h11i1iio
888888uuuuu8u8u88u888888o8ooooooiiiiiiiii101i11iiiiiiioooooo888888888uuuuuuuuuuuuuu888888oooooii11010hhhh1hjjjjjjjjhhhh1h11i1iio
8u8888uu8u8888u88uu8888888ooooooiiiiii0ii1i1i11iiiiiiioooooo888888888uuuuuuuuuuuuuuu8888ooooooii01010h0h010h0h0h0hjhh1hhhh1111i0
8u88uuuuuuu8u8uuuuuu888888o8ooooiiiiiiiii1iiiiiiiiiiiiiooooo888888888uuuuuuuuuuuuuuu8888oooooiiii1111h1h010hjhjhjhjh1hihih0111io
8u8uuuuuuuu888u8uuuu888888ooooooiiiiiii1i1i1i11iiiiiiiiooooo888888888uuuuuuuuuuuuuuu8888oooooo0i01010h0h0h0hjhjhjhjhhhhhhh1111oi
080u8u8u8u880888u8u888888oooooooiiiiiii11111111iiiiiiiiooo0o888888888uuuuuuuuuuuuu8u8888ooooooii11101h1h0h0jjhjhjhjh1hhhhh1111oi
8u8uuuuuuuu8u8u8uuuu88888oooooooii0iiii111111111iiiiiiioo0oo888888888uuuuuuu0u0u0u080888oooooo0ii1111h1h0h0j0h010h1h1hhhhh1111oi
8u0u8u8uuuu8u8u8uuuuu888ooooooooii0iiii1111111i1iiiiiiioo0oo88888888u0uuuuuuuuuuuu8u888800ooooii11111h1h0j0j0h0hhhhhhhhhh1111iii
8uuuuuuuuuu8u8u8u8u8u888o8oooo0o0i0ii1i11111i1i1iiii0i0oo0ooo8888888u0u0u0u0uuuuuu8888880o0oooii11111h1h0h0h0h0hhjhhhhhhhh1111ii
88uuuuu8u8u0u008u8u8u888080o0o0o0i0ii1i1111111i1iiiiiiioo0ooo8888888800uuuuuuuuuuuuu888800o0o0i010101h1h0j0j0h0hjhhhh0hhh11111ii
8uuuuuuuuuu0u0u888888888o8oooo0o0iiii111111111i1iiiiiiioo0ooo8888888u0uuuuuu0u0u0u0u08088oo0o0i011110h0h0j0j0h0hhjhhhhhh111111ii
88uuuuu8u8u0u0u0u080808080oooooo0iiii111111111i1iiiiiiioo0o08888888880u0u0u00u0u0u0u08088oooooii11110h0h0j0j0h0hjjhhhhhhh11111ii
8uuuu8u0u0u0u0u8u888888888oooooo0iiii111110101010i0iiiioo0o0o88888888uuuuuuuuuuuuuuu88888oooooii10111hhh0h0h0h0hjhjhhhh1h11i11ii
8u0u0u0uuuu0u0u88888088888oooooo0iiii01111010101010iiiiiooooo88888888uuuuuuuuuuuuuuu888880o0o0i011111hhh0h0j0h0hjhjhhhh1h1111iii
8uuuuuuu0u00u0uu8888088888oooooo0iiii11111010101010iiiioo0o0888888888uuuuuuuuuuuuuuu88888oooooii01010h0h0h0h0h0hjhjhhhh0111111ii
8u0u0u0u0u88u0uuu888088888ooooooiiii010101010101010iiiiiooooo88080808uuuuuuuuuuuuuuu888888oooiii1111hhhhjhjjjhjhjhjhhhh1011111ii
8u0u8888u8u8u0u0u080088888ooo0o0i0i0111111111011010iiiiiooooo88888888uuuuuu0u0uuuu0u088888oooiii1111hhhhjhjjjhjhjjjjhhhh11111iii
888u8u8uuuu8u0u0uu8u888888ooooooiiii101010111111010iiiiiooooo888888uuuuuuuuuuuuuuuuu888888oooiii111hhhhhjhjjjhjjjhjhhhh011i10iii
088u8u8uuuu8u8u8uu8u8888o88oooooiiii101010101011010iiiiiooooo888888uuuuuuuuuuuuuuuuuu88888oooiii111hhhhhjhjjjhjhjjjjhhhh11i10i0i
808u0u0u0uuuuuu88u8u8888888oooooiiii101010110101010iiiiiooooo888888uuuuuuuuuuuuuuuuuu88888ooooiii11h10h0h0h0jhjhjjjjhhhh11i10iii
888u8uuuuuu8u8u8uu8u8888888oooooiiii111111111111010iiiiiooooo888888uuuuuuuu0uuuuuuuuuu8888oooiii111hh0h0jjjjjjjjjjhjhhhh11110iii
888u8u8uuuuuuuu8u0008088888oooooiiiii101111111110100iiiiooooo8888888uuuuuuuuuuuuuuuuuu8888oooiii111111hhjjjjjjjjjjjjhhhh11110iii
888u8uuuuuuuuuu8uu8u8808080o0oooiiii111111111111111iiii0ooooo8888888uuuuuuuuuuuuuuuuu88888o0oiii111hh1hjjjjjjjjjjjjjhhhh11110iii
888u8uuu8uuuuuuuuuuu8u88888oooooi0i0i11111111111111iiiiiooooo8888888uuuuuuuuuuuuuuuuu88888ooooii111hh0hjjjjjjjhjhjjjhhhh11i1oiii
888u8uuu8u8uuuuuuuu08088888oooooiiii1010101111111110i0i0ioooo888888uuuuuuuuuuuuuuuuuuu8888ooooii1010h1hhjjjjjjjjjjjjhhhhh11ioiio
808u8uuu8u8uuuuuuuu000080808ooooiiii1111111101010100i0i0ooooo8888888uuuuuuuvuvuuuuuuuu8888ooooii1110h1hjjjjjjjjjjjjjhjjhh0hi1iio
88uu8uuu8uuuuuuuuuu0uu080808o0o0iiii111111111011111iiii0ioooo8888888uuuuuuuuvvuvuuuuuu0808ooooii1110h1hjjjjjjjhjhjjjhjjhh1hi1oio
80uu8u8u0u0u0uuuuuuuuu080808o0o0iiii1111111010101010i0iiiioooo888888uuuuuuuvvvvvuuuuuu0888o0o0i01010h1hjhjjjjjjjjjjjhjjhh1h11ioo
80u08u8u8u0vuvuuuuuu88888oo0o0ooiiii111111111011111iiiiiiioooo888088uuuuuuuvvvuvuuuuuu8888oooooi1110h1hjjjjjjjjjh0hjhhjhhhhh111i
88888u8u8u0vuvuuuuuuuuu88888o0o0iiii1111111110111111iiiiiioooo808080uuuuuuuvvvvvuuuuuu8888ooooii1111hhhhjjjjjjjhj0j0j0jhh1h1111i
80u08u8u8v0v0vuvuuu8uuu8888880ooiiii1111111100111111iiiiiooooo888888uuuuuvvvvvvvuuuuuu8888oooooi1111hhhjjjjjjjjhj0h0h01h1h1h111i
88u88u8u8v0v0vuvuuuuuuu8888880ooiiii1111111111111111iiiiiioooo888888uuuu0uvvvvvvvvuuuu8080oooooi1110h0hjjjjjjjj0j0h0h0jhhhhh111i
88u88u8uuuvvvvvvuuuuuuu8888880ooiiii11111111111111111iiiiioooo8888880uuuuuvvvvvvvuuuuu8888oooooi1111hhhjjjjjjjjhj0j0h01h1h1hi1ii
o8880uuuvvvvvvvvuuuuuuu88o8080ooiiii11111111111111111iiiiiooo8888888uuuuuvvvvvvvv0uuuu8888oooooi1111hhhjjjjjjjj0j0j0h0hhhh1h111i
o88u8u8uvvvvvvv0u0u0u0u0808oooooiiii111111111111111i10iiiooooo8888u8uuu00v0vvvvvv0u0uu8888oooooi1111hhhjjjjjjjjjjjjjh0hhhh1h111i
o88uuuuuvvvvvvvvuuu0u0u0808o8ooiiiii11111111101010111iiiioooo888888uuu0u0vvvvvvvvuuuuu88880o0o0i0111hhhhj000jjjjjjjjhhh1h11111oi
000uuuuuvvvuvuvu0u0000u0808o8ooiiiii11111111111111111iiiioooo8888888uuuu0vvvvvvvvvuuuu8888oooo0i0111hhhjjjjjjjjjjjjjhhhhhh1111ii
000uuuuuuvuuvu0u0u0uu888808o0ooiiii111111111h11111111iiiiio0o888888uuuuu0vvvvvvvvvuuuu8888oooo0i01010h0hhhjjjjjjjjjjjhjhh1hiioii
088uuuuuvvvvvuvu0u0uu080808o0ooiiiii11111111h11110111iiiiio0o888888uuuuu0v0vvvvvvvuuuu8888oooo0i0101hhhhjhjjjjjjjjjjjhjhh1h1110i
008uuuuuuvvvvvvu0u0uu888808000ooiii1111111h1h11111111iiiiio0088888uuu0u00v0vvvvvvvuuuu8888oooo001111hhhhjhjhj0j0jhjjjhjhh11111ii
888uuuuuuvvvvvvvvvuuuuu8808o0ooiiii011111111110111111iiii0ooo808080u00000v0v0v0vvvuuuuu888o0o0i01011hhhjjjjjjjjjjjjjjhjhh1h1i1ii
o88uuuuuuvvvvvvvvvuuuuuu888800ooiii1111111hhh111111111iiiiooo888888uuuu0u000000vvvuuuuu8080oooii1111hhhj0jjjjjjjjjjhjhj1h1h1i1ii
8888uuuuuvvvvvvvuvuuuu8u88080oooiii1111111hhhh01111111iii0o0o888888uuuu0vv0v0vvvvvuuuuuu88ooooii111hhhhjjjjjjjjjjjjjjhjhj1hi1ii0
8888uuuuuvuvuvuvvvvuuuuu88880oooiii1111111h1h10h111111iii0ooo888888uuuuvvvvvvvvvvvuuuu0u080o0o0i111hhhhjjjjjjjjjjjjjjhjhj1h111ii
8888uuuuvvvvvvvvvvvuuuuu08080oooiii1111111hhhh1h011111iii0oooo88888uuuuvvv0v0vvvvvuvuu0u088oooii111hhhjjjjjjj0jjjjjjjhjh01i111ii
8u8u0u0vuvuvuvuvvvvuuuuu8888ooooiii111111hhhhh1h011111iiiioo0o08088uuuuvvvvvvv0v0vvvuuuu888oooii111hhhjj0jjjjjj0jjjjjhjh0hh111ii
8u8u8u0v0v0v0v0vvvvvuuuu8888ooooiii111111hhhhh1h010111iiiioooo88888uuuu0vvvvvvvvvvvvuuuu888oooii111h0j0j0jjjjjjjjjjj0j0h0hh111ii
ou8u8u0v0v0v0vuvuvuvuuuuu888ooooiiii11111h0h0h0h0111111iiioo0o88888uuuuvvvvvvvvvv0vvuuuu880o0ooi11hhhjjj0j0jj0jjjjhj0j0j0hh11i1o
ou0uuuuuvvvv0v0vuuvuuuuuu888ooooii1111111h1hhh1h1111111iii0o0o88888uuuvvvvvvvvvvvvvvuuuu888oooii11hhhjhjjjjjjjj0jjjj0j0j0hh1111i
oo08080v0v0v0v0vuuvuuuu8u888ooooii1111111hhhhhhh1h11111iiiooo888880u0uvvvvvvvvvvvvvvuuuu888oooii111hhjjj0j0jjjj0jjhj0j0j0hh111ii
8u0uuuuvvvvvuvuuuuvuuuu8u88o0oooii111111hhhhhhhh1h1101iiiioooo8888u0uuvvvv0v0vvvvvvvuu0u888oooii11hhhjjjjjjjjj0j0j0j0j0j01h11i1o
8uuuuuuvvvvvvvvvvuvuvuu8u88oooooi0i11111hhhhhh0h010101iiiioooo8888u0uuvv0v0v00vvvvvvuuuu888oooii11hhhjjjjjjjjjjjjjjjjjjjhhhh111i
88u8uuuuvvvvvvvvvuvuvuuuu8880oo0i0i11111hhhhhhhhh111111iiioooo8888u00000v0vvvvvv0vvvuuuu888oooii11hhhjjjjjjjjjjjjjjjjjjjhhhh111i
8808uuuuvvvvvvuvvuvuvuuuu8880oooi0i011011hhhhhhhh1h1111iiioooo8088uuuuvvvvvvvvvvvvvvuuu0888oooii11hhhhjjjjjjjjjjjjjjjjjjhhhh111i
88u8vuvuvuvuvuvuvuvuvuuuu8088oooi0i01010h0h0h0h1hhh1111iiiiooo88888uuuvvvvvvvvvvvvvvuuuu888oooii11hhhhjjjjjjjjj00jjjjjjjhhhhi1ii
8uu0v8vuvuvuv0v0vuvuvuuu08088oo0i0i01010hhhhhhhhh1h1111iiiiooo80888uuuvvvvvvvvvvvvv0uuuu888oooii11hhhhjjjjjj0j0j0jjjjjjjhhhh11ii
88u8u8080uuuuuvvvuvvvuuu08080oooiii111101hhhhhhhhh11010i0i0ooo80888uuuvvvvvvvvvvvvv0vuuuu88ooooi111hhjjjjjjjjjjj0j0jjjjjhhhh11ii
8uu8v8v8vuvuv0vvvuvvvu0u0u088oooii101111h10hh0hhhhh1111iiiioo080888uuuvvvvvvvv0vv0vvvuuu888ooooi111hhhjjjjjjjjjjjjjjjjjjhhhh11ii
8uu8vuvuvuvuvuvuvuvuvuuu0u088oooiii1111010h0h0hhhhh1111iiiiooo80888uuuvvvvvvvvvvvvvvvuuuu88oooii11hhhjj0j0j0j0j0jjjj0jjjhh1h11ii
8uu8vuvuvuvuvvuvvvvvvuuu0u088oooii111111hhhhh0h0hh01011iiii0o00088uuuuvvvvvvvvvvvvvvvuuuuu88oooi111hhjh0jjjjjjjj00jjjjhjhh11i1ii
8uu8vuv0v0vvvvuvvvvuvuuu0u8888ooii111111hhhhhhhhhh01011iiiiooo88808uuuvvvvvvvvvvvvvvvuuuu88ooooi111hhjjjjjjjjjjjjjj0j0hhhh0111ii
8uu8u8uuuuvvvvvvvvvuvuuu080808ooii111111hhhhhhhhhhhh11010iiooo88808uuuvvvvvvvfvvvvvv0uuuuu88oooi111hhjjjjjjjjjjjjjjjjjjjhhh1111i
8uu8uu0u0uuvvvvvvvvvvuuuuu8888ooii1111h1hhhhhhhhhhhh1111iiiooo888u8uuvvvv0vvvfvfvvvvvvuuuu88ooii11hhhjjjjjjjjjjjjjjjjjjjhhhh111i
8u888uuuuvvvv0v0v0vvvuuuuu8888ooii1111h1hhhhhhhhh0hh1111iii0o0808uuuuvvvvvvvvfvvvvvvvvuuuu88ooi010hhhjjjjjj0j0j0jjjjjjjjhhh11i1o
8uu8uuuvuvvvv0v0v0vvuu0u0u8888ooiii11111hhhhhhhhhh001010iiiooo888uuuuvvvv0v0v0vfvvvvvvuuuu88ooii11h0h0j0j0jjjjjjjjjjjjhjhh111iio
8o000u0vuvuvv0v0v0vuvuuuu88088ooii1111hhhhhhhhhhhhhh1111iiiooo888uuuuvvvvvvvfffffvvvvvuuuu88ooii11hhhjjjjjjjjjjjjjjjjjjhhhh11iio
uuuu8vuvuvuvuvvv00vvuuuuu88088ooii1111hhhhhhhhhhhhh01010iiiooo888uuuuv0v0v0v0ffffvvvvvuuu80oooii11hhhjjjjjjjjjjjjjjjjjjhhhh11iio
uuuu0v0vuvuvvvvvvvvvuuuuu880ooooii1111hhhhhhhhhhh0h01010iiiooo8888uuuv0v0v0f0f0fvvvvvvuuu888ooii11hh0hjjjjjjjjjjjjjjjjjhh0h010i0
uuuu8vuv0fvvvvfvvvvvvuuuu8808oooii1111hhhhhhhhhhhhh00010i0i0o0808uuuuu0vvvvffffffvvvvvuuu888ooii11hhhhjjjjjjjjjjjjjjjjhjhjhh10i0
uuuuvvuvufuvvvfvvvvvvuuuu88080ooii1111hhhhhhhhhhhhhh1111iiiooo8888uuuv0vvvvfffffffvvvvuuu088ooiii111hjjjjjjjhjjjjjjjjjjjjjhh10io
uuuu8vuv0fvvvvvvvvvvuuuuu8808oooiii11h1h0hhhhhhhhh0h0111iiiooo88880u0v0v0v0f0fffffvvvvuuu088ooiii10h0hhjjjjjjjjjjjhjjjjjjjhh10io
uuuvvvuv0fvvvvfvvvvvvvuuu8808oooii111hhhhhhhhhhhhhhh1111iiiooo8888uuuv0vvvvfffffffvvvvuuu888ooiii10h0jjjjjjjhjjjj0h0jjjjjjhh10io

