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

	pal({
		0,
		0,
		1+128,
		1,
		2+128,
		8+128,
		8,
		14+128,
		15+128,
		15
	},2)

	--poke(0x5f5f,0x10)
	memset(0x5f70, 0b11001100, 16)

	mode = 0

	show = true
end

function _update()
	-- cls()
	if tf%(30*10)<30*7 then t+=dt else t+=dt/6 end	
	tf+=1
	local st8=sin(t/8)
	local ct8=cos(t/8)
	local ss = (st8*0.5+0.5)

	if t>30 then
		t=rnd(17)-8
	end

	for i=1,70 do
		local ox=rnd(128-24+bk)-8+12
		local oy=rnd(128-24+bk)-8+12
		for y=oy,oy+bk-1,2 do
			for x=ox,ox+bk-1,2 do
				c = ((sin((-y*8)/(x+y+32)/16 + t/8))\1*6
					+ t 
					+ 4*ss * (((x+16)/32)\1)
					- 4*ss/2 * ((x+16)/32)\1 
					+ ( 
						sin((x+1*sin(t/8+y/32+x/8))/64) 
						+ cos(y/64 - t/8) 
						+ (t\4)
					)\1
					)\1 + (y/64-t/2)\1 + (y/90+t/2)\1*2

				pset(x,y,17.6 * abs(((c)/16-0.25)%1-0.5) + 1.1)
			end
		end
	end
end

function boxblur(x,y,width)
    sum=0
    count=(width*2+1)*(width*2+1)

    for xa=x-width,x+width,1 do
      for ya=y-width,y+width,1 do
        sum=sum+pget(xa,ya)
      end
    end

    return sum/count
end

function next_mode()
	mode = (mode+1)%4

	if mode==0 then
		poke(0x5f5f,0x0)
	else
		poke(0x5f5f,0x10)
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
	ox=rnd(128-24+bk)-8+12
	oy=rnd(128-24+bk)-8+12
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000h000000000000000000
0000i11i1i1o1111iiiiohohv0v0v00v0v0101010101u1u1u1u1uovouu8v8vfufufvuvuuvfuvuvuooov8v8080v0v0i0i80808h1hivuouou8uuuv8v8u8uu00000
0000vihohoho1u1uiuuuu8uo8080h0vvvfffvfvfvfvfufifiviooii1111111hhhh000v0vvv8v8fufuvvvvvv0v0uvu1iuio1ohohuhv1o181818ffff1f1f1v0000
000011hhhhhhhhh11111iiiiiiu181uvvvvvvvvhvhvh81v1v1h1h10hh1hhhh080uuu8u88uu8v8v8vuvuu8uuuuuu80808000000o0800i0i0o8huuoui8i8iu0000
0000u1vi0ihihih1h111i1ih1i18181v1vuvuvuv8v8v8viviuiih11hhhhhhhh00000000000u0vv8vuuuuuuuuuuu88v8888880o0o0101hohohoh0h0i0i0i0ih00
0000ii111111111iiiiooooooioififffffvfvfofofouufvfviioio1f1f111h00000000u0iuhuhvvvvvvuvvvvvvvvvvuuuuuu0v0f0000f01hh0h0h00h01v8000
0000uifo1o1o1o1iiiiiooi1ioi1i1ifififvfufufufuioifofofii111111h0hhhh0080000hhhhv1vvvvvvvvvvvuufuuuuu8u8080o0o0u0u080h0h10101h1000
00001uhhhhhhhh1111i11i1h1hhvhvhvv1vuvuvuvuvi88iuouvuvuhhhhhhh0000000000u010000u0u0u08uuuuuuuu8o8o8o8o8o8800000000000000000h0o000
000081vihihihh111111ii111i1h1h1v1v1viv8v8v8v8iiivivivuvvhvh0000u0000000000000000000uuuuu8uo88o888o8o8v8v8v8v8v8v8v0v00v0v0h0h000
0000iv1h1111iiiiiiiiiii1111h1f1ffffffffffffvuuuf8ffffffffv1uhh000000000o0i0hhhhhhhhhhh0vvvvuuu8u8u8u8u8uv888uuuuu00hhh0000f08000
0000iifofo1iiiiiiiiiiii1i11111111fffffffofuvfvfffffffffffuvuhu0f0v0h0000000h0hhhh0h0h0h0hhh8080808uiu1ufufvfufufufvvvvfvfvfvf000
00001u1h0hh1h1h1h111h1h1h0100h0vuvvvvvvvvvv888vvvvvvvvvvv8u8u80000000000010000000000000000000oo8o8o8o8o8uo88888888uv8u88u8vui000
000u1uuu881h1h1111111i111hhhhhhhhhh1v1u1iuiuuuvvvvvvvvvvu8u8u8uu8u8u0v00000000000000000000000000oo8u8h8huhuh8v8vuvuuuuvuvuvuv000
0000ivou111i1i1i1i1o111010i0h0h0hvfvfvfffffivuvvfffffffvuuuuuuuuuu0000000ihhhhhhhhh0h0hhhh0hhhhhhh888888vuuuuuuuvuufufvfvvvfi000
000vovuvuuu1o1o1i1i1iiihi1111111111iiivioiovvivfffffffvuuuuuuuufufufuf0h0h0h0h0hfh000000hhhhhhhhhhhu81uhuhuhufvfvvvvuvvvfvfvv000
0000uu18hhhhhhhhhh11hhh0h0h0000000uuuvuvvvviuuuvvvvvvvuuuu881818u8v8uu00000u0v0v00000000000000h0h0h0h0o0ooooooooooouuuu8u8u8v000
000uiu1818ohih1h1h11111011h1hohoho1o1o1vivivuvuvuvvvvuuuuu88888v8u8vuv0000000000v000000000000000000i1hh0000000u0u00uuuuuhu1uu000
0000vuvuv1111iiiiii11111111hhhhhhhh1vfffffffifvfffffffvvvvfvuuvuvuvvvvvvvv0f0f0v0ff0f0fhhh0hhhhhh0000hhhhhhh888i8i80uvuuuuvuf000
000uiu8uvuv1vivivivio1ihoi181818iiiiiiifififvfvffffvfvvvvvffuuuuuuvvvvvfvfv00000f0000h0h00h0hhhhh00hihi0000000000000hhhhihifi000
000088vhvhh111111hhhhhhhhhh00000hhhhhh1hvvvvvvvvuvvuvvuuuuou8u8vuuuuuuuuuuuuuu00vvvvv000000000000000000000000000000i0o8o8o08h000
000808o8uuuhuh1h1hhhhh00ohohooo1o101111v1v1v1vhvhuvuvu1u8uvuu888uuuuuuuuuuuuu0u0u0u0u000000000080u0010h000000000000001011o1oi000
0000uhf1viiiiiii1111111h11ihihi1i181i1i111ffffvfvvfvffvvvvfvufufuvvvvvvvvvvvvvvuffuf0v000000000000000hhhhh0000000h0h0h0h081h1i00
0000hf8vv1v1v1i1111111hh111ii88i1i1i1i1f1fif1f1v1v1vfvovovvvvvfvvvvvvvvvvvvvvvvvv0v0v0v0v000000h0h0hfh00000000000h0hh8h818181000
0000uhu1v111h1hhhhhhhhh0h1000hhhhhhhhhhhhhhvuvuuuuvuvvuuuuuvuvvvuvvuvuuuuuuuu888vv8u8u88huh0h0h000000000000000000000000000h0hu00
00000uuvuvuhuhhhhhhhhh00h1111ooihih1h1hhhvhvhuhuhuhuhuiuiuvuvvvvvvuuuuuuuuuuu888u8u8u8u0v0000h0000000000000000000h0101h1hihoh000
0000v1fifi1111111111111h1oh1111111111o1i1ohfhvvvvv1vfffvvvvvfuffffvfvfvvvvvuvuvuvvuvuvovhvhv1v000000000000h0hh000h0h0hhh0h111100
0000ffufvfv1u111111111hhhoioi88o1o1i1i1i1111v1v8vvvvivovovfffffffffffvvvvvvuuuuuvuvuvufufvvvv0v00000000000000000000i0ihoho080100
0000u0v1vhhhhhhhhhhhhhh01ihihihihihihihhhh00000uuuhvhvu1u1v8vvvvvvvvuuuuvu8888888u8v8vouiu0u0u0v00u000000000000000000000h0hh0h00
0000vvhvhhhhohhhhhhhhi0ihiiiiiiihihihihh0h0h0ououuuu1uouovvvvvvvvvvvvuuu888888ovuuuuv8vuvuuuu0u0u0u000000000000000000000000o0h00
00001hh1v1111111111111h1oo1o1o1o1i1i1i1ihhhhhhhh1v11iviifofifvffffffffvvfuufuuuuuuuuuu8v8fuvufuv0v0vu0u0u0v0h000000000hh1h11h000
0000fffff1f11111111o1o1818oooooo1o1o1ih1h1h1h1h1f1v8o88888f8fvffffffffvuuuuuuu8v8vvvfvfvfvvvvuvuv0v0v00000000000h000000h0h0iu100
0000hvhhuh8hohhhhhhhhihhi8hohihih1h1h10100000000h0iv111iv1v1vuvuvvvvvv88v88v888888888u8u8u8v8v8u8u8uu8u8u0u8u800000v0h0101080000
0000uvvvhhhhhhhhhhhihihihiiiiiii1ii111111100000000v01u1v1v1vvvvvvvvvvuu888v8o8ou8u8uuuuuuuvuu8u8u8u88008000000u00000000000010h00
0000fff111111111111oio1iooooooioiiiihihihhhhhhhh1hh11fffffff1fffffffvvvvfuuvuuuuuuuvvvuvufufufuvuvuuvuvuhuhuhuhuhf0fhf0fhihu1i00
0000vff811111111111oooioiooiooooii8iiiioiihhhhhhhhh1ooifififfffffffvvvvvvvfu8u8uuvuvvvuvuvfvfvvvvvuu8u8u8uhuh0f0f0h0h0h000000100
0000vuvhhhhhhhhhhiiiii11iiiioi1i11h1h1h100000000i0hihvhvvvvvhvhvhvvuvuvuvuuu88888uuuuuvuvv8v8v8u88o8v8v8o808080v0vvvvv0u0uhih100
0000uhvohhhhhhhhhiiiii1i11i1i1111hoh1h1h1110i0i0ihihiiiv1v1vvvvvvvuuuuuuuuo8o8o888uuuu8v8v8uvuvu8888o8o8o8o8o8vvv000000000000000
0000fvf111111o1oooooooiiooiiiiii1i1i1i1i1i11hhhho111111f1fffofofivfvfvfvfvfvfufufvfvfvfvfvu8uuuu8u8ufufu8u8u8fhfhf0f0v0vff1ihi00
0000v1f8f8o81818o8ooooioiiiiiii1i181i1i1iio1o18iu1o1ooo1ofifffffvvvvvvvvvvuv8v8ufvvvvfufufuvuuuuuuuu8u8u8u8u8uuffff0f0f0f0f0h000
0000vuvohohohoh8iiiiiiiiii1111h1h1h1hhhh1hihihi1i11hhhhhhvhv0v0uuuuuuuuuuuvuvuvvvuvv1uvuvuvvvvvvvvv8v8u8o8o8ovov8vuu0u0oviu1u100
0000uhvouoioioioioiii11i11111h1h1hoh1h1hiiihi1o1i1ihiiihihhvvvuuuuuuuuuuuuvuvuvvvvvuuv8v8v8888o88888o8o8o8o8ovvvvuvuv0v0v0u0u000
0000f8f81o181uo8oooooooooiii1ioi1i1i1111o1oioioioiiii111111fhvhvhvvvvvvvvvvvffffffffiffffvufuuuufufuvuvu8u8u8fufvvvvfvvvofoiiu00
0000v1v18ouoooooouououioiii1h10101u1u1u1uoooooooooooiiioioih1v1vvvvvvvvvvvvvffffffffffufuvuu8u8uvuvfvf8f8f8fufvffffvfvfvv0v0vv00
0000hohohohoioiiiiiiiii11ihhhhhhhhhh1h1h11i101i1i111h1h1h1010v0u0u0uuuuuvuvvvvvvvvvvvvvvu8uu8uouovo8o8o8888v88uuuuvuuuuuiviv1o00
0000uiuioi8iiiiiioi8i1111h1h1h1h1h8h8h8h8oiiiiiiiiii1i1i1i101vhuhuhuuuuvuuvvvvvvvvv1vv8v88o8o8o8u8uvuvovov8vuvuvvvvuvvvuvuvuvu00
000h1v1u1oooooooooooooi1io111111111o111iuiuiui8ioiiiii1i1ihihhfhvhhvhv1f1fffffffffffffvvvvvvvv8v8f8u8u8vufufuvvvfvvvvvvvovofi800
0000ou8u8ouoooooovoiiiiiiiiiiiioi8u8u8oiuioioioioii8ioioiohohohhhhh1v1v1fififivofififfvf8v8u8u8uvuvvff8fvfvfvfvffffffvfvfvfvff00
0000huh8iiiiiiiiiiii111h111h1hhhhhhhh1118181o1o1i111110101010000v00uhvhvhvvvv1vuvvvvu1ouououououoioioiuo88vuvuvuvvvvuuuuuuiu1o00
000088o8oioi8i8i8u111111111i1i1o1o8o8o81o1o1i1i11111111h10000000000huhvhv1v1v1uhuhh1vvvvvuvuvuuuuuvvvvuvuvuvuvuvvvvuvuvuvuouov00
00011uouoooooovoioiiiii1ioi1i111111ii1ii8i8i8i8ioiii1i11hihihhhhhhi1i1i1i1fifffffffvvvuv8v8v8v8v8u8ovfvuuvfvfvfvfffvvvvvvvvf1800
00008uuou8uovovouiiiiii1ioi1i1i18181888ioihioioiiii1i1ihuhhhhhhhh1111ififififio1i11i1fffvvvvvvvvv8fvfvvvvvvfvfvfvvvvvvvvuv8f8f00
000018i8iiiiiiui1111111hhhhh1hhhhh111118oooooio111h1h1hh010100000h1h1h1h1h111vhvhuhuuu8u8uououov88u1u8uiviv8v8vvvvuuuuuuvuuvu000
0000oi8i8ouiuiui81i1i1ih1i1h1hohoho1ooo1o1i1i1111h1h1h1h8000000hhhhhh1h1h1h1vhih1hh1hvhvuvuvuvuvvuvuvuvuvuvvvvvuuuuuuo8oooooo000
00008uuuuouovoviiiiiiiii1111i111iiiiiii8o8888i8iiiiiii11hihihhh1h1o1i1i1i1if1fffvvvvvvu1uiuiuvuvfofif8fifififvffvfvvvvvvfvvfv000
0000uoo8ooooioiiiiiiiio18o8181818i8i888i8i8iiii1i1i1i1i1uhhhhi1111111i1i1i111181i11i1o1ovovivvfffvfvfvfvfvfffvvvvvvvv8u88888o000
000088888u8uo1i111111111hhhhoho1o1o1o1i8i8oio1o1o1o1811hiiiiiiihihih1h1h1hhv0vuuuuuuuu81818181uuviviv1v1v1v1v1uvuvuuuuvuvv8vu000
00008oiiii1i1i111111i1ohohohhh1111111io1o1111h1h111h1h1ho0h011hhhhhhi111hhhhohohhhhihi1iu1u1v1vvvuvuvuuuuuuvuv8vuuvuvvuvovioo000
000uvvvvuvuvuiiiiiiiii1o11118i8i8i8i8i8uouoooioi1i1iuio1oioo1oo1o1o1i11111fffvvvvvvvvvuivifufvfvfvfvfif8fufuvuvfvfvfvffvfuuiv000
0000uoooioioiiiiiiiioi818181iiiiiiiiio8iiii111111ii1i1i18ho18o8o8ooooi11111111111i1h101vvffffifffvhv8vvvvvvfu8u8vvfvvfvfvfv8v000
0008uuuu8u8u8111111111hohh11o1o1o1oio1oo1818i1i1h11111h1h1hi1ihhih1h1hhhhhhuuuuuuuuuu181v1vuvuvuvuvuvhvhvhu8u8uvuvvvuuouo8818000
00008i1i1i1111111111o1hhh11111111o1o1iii1ih1h1h1h1111111iiiiiioioiiihhhhh1h1h1h1h1u0u0uhvvvvvv1v1vhvhvuuuu8u8u8ovuuuuvuvuvui1000
000ufvfvvvvvvhhhhhhhhh0888888o8o8o8o8ioiiuiioioiiiiioo1i1iioio1i1111111h11hhh8v888888iiififvfvfvfvfvf1f1v1vuvivivivovv8u8uuiu000
000hvviviviviiiiiii8i81iihihihihihi8ioii0i0i0i0i0iiiiooioioioio1i1i11h1h1h111i1iiivhv1f1fhffff1fifhfhvvvuvuvuvu8vvvvvfffvffuv000
0008vuiuuuuuu0000000000ooo1oiiiiiiiiihi11o11111111hihih1111i11hhhhhh00000h0h0h0h0101h101v1vovivivivivhuhvhvuuuuuuuuvviu8u8u1uh00
0000uu0u0u0u01011o1oio0100000000000i0ih10101000000i0i0i1i1i1h11h1h10h0h0h0hhh1h1ho0h8h8h80800vhvov0u0u1u1uiuiui1uuuvvvvvuvv8u000
000uf8o8v8i8ihhhhhhh11h888i8iioioi11o1iii8iiiiiiooooiohihi0i0i0i1ihihih1h1h1h1hih0ih1hhffffofouououo8v8vfhfvovovofof8ffffufhv100
0000vv0vhvhvhihoooo8o8h8hhhhhhhhihio1i1i0i0i0000000hhhoioioioii1ihihhh1h1h1h1hihi80101uhuhuhhf1fuvhvhvhvhv1vvvv1ffufufuf8f8vv000
0000v8ioio10101010ihi818o0101010h0h0101110101810000i010i00000000000101010h0h010100100000888h80888ooooooo0uuuiuiuivovovvvvov01h00
0000vu0v0v0u0i0iiihoho0i000000000001010101010000000000i1i111h110000000000000h0h0h101010h80801v8u8u0u0ououououovhvv8v8v8vovo1v000
0000vvvvvvihihhh11111uhu8hhhhh00000ooiiii0i0i0o0hhh1hihi000000000001h1hoh1h1h1h100i0000000u0u0u8o8o8o888h818i8ou8f8f8ffff8f8ii00
0000f0000hhhhh18ii1i1ihohhhhuhhh000h0h0h0h0o000hhhhhhhohi0101010hhhhhhhhhhhhhh000i11111010h00u0o01v10i0iioiiiiof8f8f8f8f8i8ifo00
0000uvuvu0u0h0hhhhhhh80810000000000i110i0008h0h000010101000000000000000h0h0h0h0h00h00000000080iiiiii1i1ohoho18o8o8o8ouvuvovu1100
0000v0u0u0u0uh18111111118h80800000000000000o0000000000h000h0hh01010i00000000000000hhh000000000010101o1o11o1818o8ovovovovo1v1vi00
0000vuuvu0v0h1h1h1h1huhu1h101010101oio1oo0808h8hhhhi0i0i00h0h00000h0hhhhhhh10101000000000001h1ooooooioioh81uou8u8u8888u8uouo8100
0000v0v0v0v1v1vuvvvvuuhuhuh00000i0i0o00000hhhhhhhhhh0hh00h1h1hh8h8h81h1hhh0000000010h00000hhihiiiiii1iiiiiiioo888f8f8f8f81fifo00
0000ou8uu0uh0h0h0h0h0808h0000000000ohiii00000o0000010h0100000000000h0h0h000h0h0h0h000000h0hhhh0h0iii1i1i080ooooooooooooioiiiih00
000000000000h0uuuuuu8u080808080o10h0100000000000000h0h0hvhhh000i0ihih0000000000000000000h11111111111h11111iiiiiiooooooouo8v8vi00
0000uvvvv0v0h0hhhhhvhv0u0u0u0u080000ihih0h0h0h0huhh0000i0i0i00h01111h1hh0h0h00h0h0h0h0hi0i0i01010ioiiihohohooo8888888o8oooooo100
00000000000000vhfhuhvvhv0v0u0808ohihihihi0h0h0h0h0h101h1hohiho0o0o0o111hhhhhhhhhhhhhh1iiiiiiiii1i111i1hiooooooooo8888o88o18u80h0
00008v8u8080u000000u0u0u0u0o0o0o0000000000000000001000000000hh0hhhhhhh0000000000000h01111101010101110i0i0i0i0i0iooiioiiiiiiii000
00000008000000u08080u00000000o0o000000000000000000000000v0000i0i0i0100000000i0h0i00h1111i1i1i1iihhhhh1h1i1i1i1i11o1i1iho1houo000
0000ffufu0v0v0000hhv0fhfhf0f0i0uhhhh0000000h000000h00hhhhh1h11h111h1hhhhhhhhhhhh111iiiiiiihihi0i0i1111hohohohoho1oooooooooooo100
00000h08000000v0v0v0v0hhhhhhhhhhhhh00hhhh0h0h0h0000000h0h0h01o0o8o0h0h0h0h0h0hhhh1iiiiiioioioioio1o1110ioioioioiioio1o1h1ihv8000
000hvu8uu0u0u0u0000000000v0u0108000000000000000000000000h0hhhhhhhh100000000000hhh1111111111111h1hhh1h1hhhh0i0i0ih111ihihi1iu0100
00000o0o0u000000000000000000000000000000000000000000000000h0hh0h1000000000000h0h00101011i1i1i1i1ihhhhh0hiiiiiiii11h1h1hhh10u0000
0001vv0v0v0u0u00000000h0h00hhfhuh0000000000h10h0hhhhhh1h11111101hhhhhhhhhh1h111iiiiiiiiiiiiiii1111111h1h1h111oii1iiiiiiooooi0i00
0000u8vofv000000000000hhhhhhhhh000000h0h0h0000000hih01h11010h10hih0h0h0h0h0hhhhhh1i1i1i1iiiii1111111111111o1ihii1i1i1ih1hi0u0000
00008u080808080000000000000000000000000000000000000000hh0h0h0h0000000000h0h0h1111h1h1h1111111hhhhhh0h0h0h0hho1o1111111111ii10100
0000v8u8u80808080000000000u000000000000000000000000h0hhhh0h0000000000000000hh01111111111111hhhhhhhhhh0hhhhhh11h1h1h1h10h0i080000
0000u80u0u0u0u00u0u0u0u0uhf0hhhhhh0h000000hh0hhhh0h01011010h0h0hhhhhhhhh1hhih1h11111i1iii1i1111111111111101i8iuiiiiiiiiiii8i0800
0000fufuvu0u0u0u000000hhhhvhv0h0000000000h0h0h0hh1h1111110h0hhihhhhhhhhh11iii1iiiiiiiiiii111111111o1hh1111ii1i1i1i1i1ii1i0ihi000
00008v0v080808000000000000v000000000000000000000000000000000000000000hh0h1111111hhhh1h1h1hhhhh0hhhhhhhhh1011o1o1h11101010i000000
0000vovovooo08080800000000000000000u0u000000000h0hhvhhhh0000000000000hh1101h1h111111111hh0hhhh0hihih00hh1110i00hhhhhh1hh00001000
000088h8h8h8h0h00u0v0vhv00f0f0000000000hhhhh1h1h101010h0h0h0hh0hhhh1111iiiiiiiiiii1ihih11111h111111111i1ihiivi1i1i0i0i01ioih8000
0000f8f8v8888888uu0h0001v00000000v0v0vhvhu0o0o01111111h1h0h0hf0hhhhh1iiii1o1i1iiiiiii1111h11h111i1i1iiiiiii8ohohhh11111100001000
0000iovovoooo0o00u0v000000v0u00000000000000hhhhhhhhhh000000000000hhhhh111111111111010h0hhh0hhihihihi1i1h101ouoh0000h0h0h1ihio000
0000vo0o0000000000000000u00000000u0u0u080808080uhuh00000000000000hhh11111h1h111111111i0hh0hhh1u1o1oho1oi81oooo1010h0hhhhh0h00000
0000i8v8f8888h8hhvhf00h000v0v0000000001h111111111111h0h0h0hhhhh11111iiiiiiiiiiiiiih1h1h1hi111o1o1oooi8ihihi818h8hhhhh101010o8000
0000o8h8hhhhhhhhhh0h000hvhhh00000v1v01010101010f0f00h0hhhhhhhhh1h1hihi1ii1i1iiiiioh1hohh1h1i1ioioiioiiiouii8i8i81h1h111110100000
00008ovov0o0o080080v00000000000u0uhu0uhuhvhhhhhhhh0000000v000h0hhh111111111111ih1h0h010101h0hihihiioioihih1o0o0o0o0h0h0h1h1oi000
00000o0o0000000000000000u0000000huhu0h0h0h0h0h0v0v0u000000000h0h1111h1h11h1h111ih1010i00hhh1h111iiiiiiii1i1o1o0o0ohhhhhhhihi0000
0000u8v8vh8huhu00u0f000000h0h0hv1v1v0v0fhfh11111hhhhhhhhhuhhh11iiiiii1i1i1i1ihohiihifi0iiiioiooo888888811oh8h8181o111111i1i0f000
0000hoh8hhhhhhh0000000hh0h00h0h0h8h001010101010f0f0vhuhhhhh111i1iiii1i1ii1ihio1i1ifihohiiiioooooo8o8ooooioioiih1h1111h111o1o0000
00008iuou0u0v0v800000000000000huhuhu0v0v0v0h0h0000000000080hh11111111h1h1010i010101010011i11iiooooooooohii0o0ohihihihhhhhhh0u000
0000hihi0000000000000000000000000o000h0hvh0h000v000000000hhhhh111111h1h11010h1h111010i0111iiiiioioioi0ii0i0101010hhhhhhhhi1ih000
0000uovovhv0v0fuu0000000hhhh1h1h1v1f0fhfhf0f0h0h0h0h0hhhhu1uiui0i0i1i1ihih1hihifihihi1hoiooioo8o8o8o8o8hoih8ho1o1o1o1h11110hv000
00001o1ohu0u0000000000hhhhhhhhhhhhhhf1f1f10h0h0h0h0hhhhh1h1hi1i1i1i11hhhhhhhhhhhhh0ihi1iooooo8o8o8o8o0oohihi0i0ii1i1ihohio181000
0000uiuiu0u0u0u8800000000hhhh0h0hvhv0v0v0v0v0u000000000h1h11111111101010h0h01010101h111i1iiiiioioioioioi110i0i1i1ihihhhh1h00u000
0000hiho080800800000000uhu000000000hvhvhv000000000000hhhh11h1h1h1h10h000000000000001h1hiiiioioioioioi0i1010101011i1i1iiiiih8h000
0000vvvvvvvvvuuuu000h0h1h1h1h1h1h1010f0f0f0000000hh101h1iiiiii1i1ih0h0h111i1iiiiiiiiiiioooo8o88888888i8iii1o1oioioio11ioiihhv000
0000ufuf8f8fu0u00000001v1vhhhhhhhhh111hhhhhhhh0hhhhh11iiiiihi1i1ih1hhhh1h1h1hihi11iiiooo8o88o8o8o8181010101010fhioioiooo888u1000
0000vo8o8o8o80o8000000hhhh0h0h0h0h0h0v0v0v000000000hhh11111111h10100000h0h01111111111iiii1io0o1oioio111111hihihi1i1iii1i11008000
00000vivvvvv8080000000h8hu000000000h000000000000000h1111111111u11000000h0h0101h1111i1ioioioioioih0h0h0h0h0h000101i1i1iooooo8h000
0000v8u8u8u88088080hhh1111h1h1h1h1f1vf0f0vh0hhhhh111iiiiiiiiiiiiii101011hihihi1i1iiioooooiouououou1u1i1i1i1i1i1iiiooooooio00u000
00000foufuvuf0u000hhhh1u1f8hhhh0000hhhhhhhhhhhhhh1iiiiiiiiiiiiiii0hhhhh1hihi1ihihoiooo8o8ouououi1f1f10101h1hihifioioo888888vh000
0000uo8o8oooo0oo0o0000hhhh0h0h0h0hu0uu0v0v000000hh11111111111111h1h0h0hho10101h111iiiiiii1i8i8i8i8hih1h1h1h1h1111ihi1i1i1i808000
00000iiiuiuiv0i0o0o0o00uouov0v0v00000000000000801111111111111111h000000h0101h10i0iiiiioi8i8i8181hvhvhvh0h01010100iioioooooou0000
0000v888o888808uhuhhhh1111h1h1010hvhvf0f0fhhhhh1iiiiiiiiiiiviv1v1f10101iui1i1iiiioiohooooiouououi8181u111i1iioioio1ohohoiou0u000
000000o0o0o0oho18h8h8hhv8vuv0v0v0000h0h0h0h0hhuhuhhhh01iiiiiii1118hh0hh1hihihohohuoooouou0u0u0801f1f1f1fifivihihhio1o1818h800000
0000uoioiooooho808080uhuh808080808uuuu08080o00111111111u101010h0h0h0h01001h1111i1i1i0iiiihihih1010h8h8hh1h1i1i1i1ihi0808v8808000
0000000000000i0u0u0u0808v88808080o0o0o80o0o08080800000u11111hhhhhi80808001v1u0uiuiuiui8i8v8vovo8h8h8h81818181vvu010huh0000000000
00000ov8v8v8v8v88uuuuuuuhi0i0i0u0vvvvu0uhuh0hihihihi0i0v00000010101u18i10i0i0i1ohohohooooho0i0ihih1uiuiui1ioioioiofov0f0f0u0u000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

