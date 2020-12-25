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

	poke(0x5f5f,0x10)
	memset(0x5f70, 0b11001100, 16)

	mode = -1
	next_mode()

	show = true
end

function _update()
	-- cls()
	t+=dt
	tf+=1
	st8=sin(t/8)
	ct8=cos(t/8)

	if btnp(5) then
		next_mode()
	end

	if btnp(4) then
		show = not show
		rectfill(0,121,128,127,0)
	end

	if t>30 then
		t=rnd(17)-8
	end

	if mode==0 then
		for i=1,75 do
			ox,oy=get_oxy()
			for y=oy,oy+bk-1,2 do
				for x=ox,ox+bk-1,2 do
					c = 6*flr(sin((x*8)/(y+16)/16 + t/3))
						+ t
						+ (x+t*4)\32*ct8*st8
					c = flr(c) + flr(y/64-t/2) + 2*flr(y/90+t/2)
					c=_color(c)

					pset(x,y,c)
				end
			end
		end
	elseif mode==1 then
		for i=1,25 do
			local x,y = rnd(128),rnd(128)
			local c = (boxblur(x,y,1)+0.5)
			circ(x,y,1,c)
		end
		
		for i=1,60 do
			ox,oy=get_oxy()
			for y=oy,oy+bk-1,2 do
				for x=ox,ox+bk-1,1.2 do
					c = 6*flr(-sin((-x*8)/(y+16)/16 + t/4)*0x0.ffff)
						+ t
						+ (x+t*4)\32*ct8*st8
					c = flr(c) + flr(y/64-t/2) + 2*flr(y/90+t/2)
					c=_color(c)

					pset(x,y,c)
				end
			end
		end
	elseif mode==2 then
		for i=1,75 do
			ox,oy=get_oxy()
			for y=oy,oy+bk-1,2 do
				for x=ox,ox+bk-1,2 do
					c = 6*flr(sin((x*8)/(y+16)/16 + t/3))
						+ t
						+ (x+t*4)\32*ct8*st8
					c = flr(c) + flr(y/64-t/2) + 2*flr(y/90+t/2)
						- flr(sin(x/32 + y/32 - t/2))
						+ (sin(x/128) + cos(y/128) + t)
					c = _color(c)

					pset(x,y,c)
				end
			end
		end
	elseif mode==3 then
		for i=1,70 do
			ox,oy=get_oxy()
			for y=oy,oy+bk-1,2 do
				for x=ox,ox+bk-1,2 do
					c = 6*flr(sin(((x*8) - t)/(y+16)/16 + t/3))
						+ t
						+ (x+t*4)\32*ct8*st8
					c = flr(c) + flr(y/64-t/2) + 2*flr(y/90+t/2)
						- flr(sin(x/128 + y/64 - t/2))
						+ 2*flr(sin(x/128) + cos(y/128) + t)
					c = _color(c)

					pset(x,y,c)
				end
			end
		end
	end

	if show then
		rectfill(0,122,128,127,0)
		rect(-1,121,128,128,0)
		print(
			"press x. (" .. (mode+1) .. "/4). press z to hide.",
			0,
			123,
			7
		)
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000vvvvviviiiiiiiivivovovoihvivivivivivfvfvfvfhf111f1f1f1i1iii1iovvfvfvuvffffffffff1f1f1f11f1f1f1f1f1f1f1ifofofofo0o000
0000ovuvuvuvivioi1iviviviu0o0oioioihihihihvhvifffvfv1vfvfiififiiiiii0iiii1i111f11o1of0ffffvffffffffff1f1f1ufufh1h1h1h1h1i0i0i000
0000uhuhuuuuivivviviiiiiiiivioiiiiiihvivovivivfvvvvfvfvfiffffff1f1i1i1i1i1i11v1viv1fffffffffffffffffv1f1f111111vh1h1h111o1o0o000
0000uvhuhuhviiiiiiiviuiu0iviiiiiiiivvvvvihihvvfvfvfvfvfvfvvfifiiiiiifiiiiii111111i1if1f1ffff1f1ffffffffff1uvuvhfhfhfh1h1vovoi000
0000uhuhuuuvivivvvviviiiiiiiiiiiiiiiiioioviviv1vvvvvvvvvvfvfvffifiiiiiiii1i1111111111111ffffffffff1ffffffffffffvf1v1h11111101000
0000uvhuhuhviiiiiiiiiiiiiiiiiiiiiiioiovoooiviv1vfvfvfvfvfvvfvfviiiiifiiiiii111111111111111ff1f1f1f1f1f1f11ovfvffffff1fhfvvvvi000
0000uhuiuvuvvvivvvviiiiiiiiiiiiiiiiiiiiiiviviv1vvvvvvvvvvfvfvffvfvviviiiiiii1v1v1v111111111111f1ffff1ffff1ff1ffiffvfvfvfvfviv000
0000vvvuvuvvvviiiiiiiiiiiiiiiiiiiiiiiiiiioiiiv1v1v1vfvfvfvvvvvvvvvvifivivii111111111111111111111111fffffifo1fiffffffffvfvvvvi000
000ouvuvuvuvvviuvviiiiiiiiiiiiiiiiiiiiiiiiivvvvvvvvvvvvvvfvvvvfvfvvvvviiivii1v1v1v1111111111111111111f1fffffffffffvfvfvfvfv1v000
0000uvuuuuuvvviiiiiiiiiiiiiiiiiiiiiiiiiiioiivivivvvvvvvvvvvvvvvvvvvvvvvvvvvvf111111111111111111111111111if1ffffffffifivviiiii000
000ouvuvuvuvvvvuiviiiiiiiiiiiiiiiiiiiiiiiiiiivvvvvvvvvvvvfvvvvfvfvfvvvvvvvvf11f1111f1111111111111111111111111hffffffffvfvov1v000
0000uuuuuuuvvvvvvviiiiiiiiiiiiiiiiiiiiiiioiiiivvvvvvvvvvvvvvvvvvvvvvvvvvvvffffff1111111111f1f111111111111111111ffffifiviiiiiv000
000ovvvvvvvvvvvuvviiiiiiiiiiiiiiiiiiiiiiiiiiiiiivvvvvvvvvfvvvvfvfvfvvvvvvvvffffffffuffff1f1111111111111111111h11111ffffffff1f000
0000uuuuuuuvvvvvvviiiiiiiiiiiiiiiiiiiiiiiiiiiiiiivvvivvvvvvvvvvvvvvvvvvvvvvfvffffffff1f1fffffv111111111111111111111i1iiiiiiio000
000ovvvvvvvvvvvuvviiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiivivvvvvvvv1v1vfvvvvvvvvfffffffvfvfvf1f1111111111111111111h1111111111f1fuf000
000vuvuuuuuvvvvvvvvviviiiiiiiiiiiiiiiiiiiiiiiiiiiiiiivvvivvvvvvvvvvvvvvvvvvfvfvffffffffffffffv1f11111111111111111111h1h1h1iuu000
000ovvvvvvvvvvvuvvviiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiivivvvv1v1vfvvfvfvhvffffffffffffffff1f111111111v1f111111111111111111u1000
000vuvuuuuuvvvvvvvvviviviiiiuiuiuiiiiiiiiiiiiiiiiiiiiiivivivvvvvvvvvvvvvvvvfvfvfvfvfvfvfvfvvvv1f1f1f1f1f111111111111h1h1h1iuu000
0000vvvhvhvhvuvuvuiuiuiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiivvvv1v1v1v1fffvvvffffffffffffffffffff1f1f1ff111f11111111111111111f1000
000vovuuuuuvvvvvvvvvvviviviiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiivivvvvvvvvvvvfvifvfvfvfvfvfvfvfvvvvffffffff1f1v1v1v1v1111h1h1h1iuu000
0000vvhiuiuiuuvuvvvviviiiiviiiiiiiiiiiiiiiiiiiiii1iiiiiiiiiiiv1v1v1vfvvvvivififfffffffffffvfffffffffffff1f11111111111111111i1000
000vovuuuuuvvvvvvvvvvviviviviiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiivivvvvvv1vifffffffffffvfvfvfvfffffffffffff1f1v1v1111111111vvu000
0000vviiuiuiuuvuvvvviviviiuiuiuiiiiiiiiiiiiiiiiii1iiiiiiiiiiii1v1v1v1vvvvvvfffffffffffffffvfffffffffffffff11111111111h1h1h1vv000
000vovuuuuuvvvvvvvvvvvvviuiuiuiuiiiiiiiiiiioiiiiiiiiiiiiiiiiiiiiii1viviviviffffffffffffffffffffffvfvffffffff111111f1f1f1f1vf1000
0000vviiuiuiuuvuvvvvvvivivuuuiuiiiiiiiiiiiiiiiiii1i1i1i1ii1i1i1i1i1v1vvvvvvffffvfvffffffffffvfvfffffffffffffff1ffff1fv1h1h1vv000
0000ouuuuuuvvvvvvvuuuuvuiuiuiuiuiiiiiiiiiiiuii1i1i1i1iiiiiiiiiiiiiiiivivivifififvfvfvffvfvfvfvfvvvfvfffffffffffff1v1v1v1v1vf1000
0000vvoivivvvvvvvvvvvvivivuuuiuiiiiiiiiiiiiiiiiiiii1i1i1ii1i1i1i1i1iivivvvvffffiffffffffffffvffffffffffffffffvfffffffffvfvfv8000
0000ohuuuuuvvvvvvvuvuuvvvviiiiiii8i8i8i8i8iiii1i1i1i1iiiiiiiiiiiiiiiiiiiivifififififvifvfvfvfvfv1vfvffffffffffffffffvfvfvfvfi000
0000uvoiuuuvuvvvvvvvvvvvvvvviiuiiiiiiiii8i8i8i8i8iiiiiiiiiiiiii8i8i8i8i8i8vufuufufufufuffffffffufufufufufffffffufufufufofffvu000
0000vhuuouov8v8v8vvvvvvvvviiiiiii8i8i8i8i8iiiii8i8i8i8i8iiiiiiiiiiiiiiiiiiififififvfvifvfvfvfvfvfvuvuvufufufufufufufvfvfvfvfv000
0000uuouuuuvuvvvvvvvvhvuvuvuiivivioioiiu8u8u8u8i8i8i8i8iiiiiiiiiiiiii8i8i8iu1ufififfffffufufufuuuuuuuuuuuuuuuvuufufufufuufuuu000
0000v8u8uuuvuvvvvvvvvvvvuvuvuiuio8o8o8o8o8oiiii8i8i8i8i8ioioiiiiiiiiiiiiiii1i1ifififiiuiuvuvuvuvfvuvuvuuuuuuuuuuuuuuvuvfvfvfv000
0000uuouuuuuuuvuvuvuvuvuvuvuviuiuioioiio8o8o8u8888888888888888i8i8i8iiiiioio1i1iiiufufufufufuvuuuuuuuuuuvvvvvifufufufufufffif000
000018u8uou8u888888o8o88u8u8u8u8u8o8o8u8u8o8i888888888888o8o8iiiiiuiuuuu8u8ooooouoiuivivvvvvuvuvuvuiuiuvuvuvuuuuuuuuuuffffvfv000
0000uuuuuuuuuu8u8u8u8u8uouououuuuuououuu8o8o8u8u8uouuuu8u8u8u8i8i8i8ii8i8o8ooioiiiiiiiuiuvuvuvuvuvuvuvuvivvvvifuvuvuvuvuvffif000
0000uhu8uou8u8o8o8oooooououououuuuu8u8u8u8u8uu8v8i8o8o8ouououiiiiiuiuiui8o88o8o8o8i8i8i8i8i8888v8vuiuiuvuvuvufufuvuf8fffffvfv000
0000uuuuuuuuuuououououououououuuuuuuoouououououuuuuuuuu8u8u8u8i8i8i8iiuiuouo8i8iiiiiiiuiuiuiuiui8v8v8v8viuiuvufuvuvuvuvuv8v8f000
0000uiuiuou8u8o8o8oooooououououuuuuuuuuuuuuuuouououiuiuvuuuuuuiuiuuiuiuiuouo8i8i8iiii8888888888ioivivivivi8i8v8f8f8i8vfifivvi000
0000uuuuuuuuuuouououououu0uuouououououuuuuuuuuuuuuuuuuiuiuuuuuuuuuuuiiiiiiiiiii8i8i8i8888i8i8i8i88888888i8i8f8f88888888888v8f000
0000uiuiuiuooooooooooououououououuuuuuuuuuuuuouououiuiuvuuuuuuiuiuuiuiuiuouo8i8i8iuii8888888888ioi8i8i8i8i8i8i818f8f8ffffifif000
0000uououuuuuuououououououououououououuuuuuuuuuiuiuiuiuuuuuuuuuuuuuuiiiiiiiiiiiiiiiiii8i8i8i888888i8i8i88888888888888888888hf000
0000uiuiuiiooooooooooouououuuuuuuuuuuuuuuuuuuuuuuuuiuiuvuuuuuuiuiuiuiuiuuuuu888888ii88888888888ivuiiiiiiii888888888881fffifif000
0000uuuuuuuuuuooooooooooouououuuuuuuuuuuuuuuuuviviviviuiuvuuuuuuuuuuuiuiu8i8i8i8i8iiii8i8i8i888888i8i8i888888888888888888888u000
0000uiuiuoiuooooooooooouuuuuuuuoooouuuuuuuuuuuuuuuiiuiuvuuuuuuiuiuiuiuiuiuiui8u8i8ii8i8i8i8i8i8i8i8i8i8i8i8888888888u1u1uiuiu000
0000uuuuuuuuuuooooooooooououoouuuuuuuuuouuuuuuvvviviuiuiuvuiuiuiuiuiuiuiu8i8i8i8i8iii88888888888i8i8i8i888888888888888888888f000
0001ouuvuoiuooooooooooouuuououoooouououuuuuuuuuuuui8u8uvuuuuuuuuuuuuiuiuiuiui8i888888888888i8i8i8i8i8888888888888888u1u1uiuiu000
0000uuuoooooooooooooooooououooououououuououuu8uuvuvuuuuuuuuuuuuuuuuiuiuiu8i8i8888888888888i8i8i888888888888i88888888888u8u8f8000
0001ouiuioioououououoooouooooooooooououuuuuuuuuuu8vvuvuvuvuvuvuvuvuuiuiuiuiui8i888888888888i8i8i8i8i8888888888888888u1u1uiuiu000
0000oioioioiooooooooooooououooooouououuououuu8uuvuvuuuuuuuuuuuuuuuuuuuuuuuu88888888888888888i88888888888888i88888888888u8u8f8000
000ioiioioiooooooooooooouooooooooooouououuuuuuuuu8v8v8v8vvuvuvuvuvuuiuiuiuiui8i888888888888i8i8i8i8i88888888888888888888i8iii800
0000oioioioiooooooooooooouououououoooououououvuu8uvuuuuuuuuuuuuuuuuuuuuuuuu888888888888888888888888888888888o8888888888o8u8o8000
000ioiioioiooooooooooooouooooooooooououououuuuuuu8v8v8v8v8u8u8u8u8u8v8v8i88888888888888888888i8i8i8i88888888888i88888888i8iii800
0000oioioioi1oooooooooooouoooooooooooouououou0uu8uvuuuuuuuuuuu8u8u8u8u8uuuu888888888888888888888888888888888o8o88888888o8o818000
000ioiioioioooooooooooooooooooououoooooooouuuuuuu8v8vuvuvuuuuuu8u8uuiuiu8u8888888888888888888888888888888888888888888888888ii800
0000oioioioiooooooooooooouooooooooooouuuuuuuuuuuvuvuuuuuuuuuuu8u8u8u8u8uuuu88888888888888888888888888888888888188888888888818000
000ioiioioioooooooooooooooooooooooovooouououou8uv8v8vuvuvuuuuuuuu8uuuuuuuuu888888888888888888888888888888888888888888888888i8800
0000oioioioiooooooooooooouoooooooooooooouuouou8u8u8uuuuuu8u8uu8uvuvuvu8uuuu88888888888888888888888888888888888181818o8o8o8o0o000
000ioiooioioooooooooooooooooooooooooooouououou8uv8v8vuvuvuuuuuuuuuuuuuuuuuu8888888888888888888i8i8i8i888888888888888888888888800
0000vuoouiuiooooooooooououoooooooooooooouuou8u8u8u88u8u8u8u8uu8uvu8u8u8u88888888888888888888888888888888888888o8o8o8o8o8o8o0o000
0000o0oiiiioooooooooooooooooooooooooooouououououo8u8uuuuvuuuuuuuuuuuuuuuuuu8888888888888888888888888i8888888o8o8o8888o8o8i8f8000
0000vuouoioiooooooooooooooooooooooooooooouououuuuuu8u8u8u8u8uu8uvu8uuuuuu8u88888888888888888888888888i8i888888o8o8o8o8o8o8oio000
0000ovoiiiiooooooooooooooooooooooooooouoououououo8o8uuuuvuuuuuuuuuuuuuuuuuu8888888888888888888888888i8888888888888888o8o8o8f8000
0000vo8ooiooooooooooooooooooooouooooooooououououuuuuuuu8u8uuuu8u8u8uuuuuu8u88888888888888888888888888i8i888888o8o8o8o8o8o8o8o000
0000oooiiiioooooooooooooooooooooooooooooououououo8oououuuuuuuuuuuuuuu8u8u8u8888888888888888888888888ii88888i8o8o8o8o8o8o8i8i8000
0000hi8ioiioooooooooooooooooooooooooooooououououuuuuuuu8u8uuu8v88888u8u8u8u888888888888888888888888888888888o8o8o8o8o8o8o8o8o000
0000oooiiiiooooooooooooooooooooooooooooouoooooovovoououuuuuuuuuuuuuuuuuuuuu88888888888888888888888888i88888i8i8o8o8o8o8oiiiii000
0000hi8ioiiooooooooooooooooooooooooooooooouuuuuuouuouuu8u8uvu8v88888u8u8u8u8888v8888888888888888888888888888o8o8ooo8o8o8o8o88000
0000oooiiiiooooooooooooooooo8ooooooooooo8oooooooooouuuuuuuuuuuuuu8u8uuuuuuu888888888888888888888888u8u8u8888888888888i8ioioio000
0000hioioiioooooooooooooooooooooooooooooooouuuuuouoouuuvuvuvu8u8uu8uuuuuuuu8888u88888888888888888888888888888888888888o8o8o88000
0000o8oioioioooooooooooooooo8ooooooooooooooo8o8o8o8ouuuuuuuuuuuuu8u8uuuuuuu88888888888888888888888888888u8u88888888o8o8oooooo000
0000hioioiiooooooooooooooooooooooooooooooooouuuuouoouo88u8uuu8u8uu8u8uuuuuu88888888888888888888888888888888888888888888888o88000
0000f8o8oioiooooooooooooooooooooooooooooo8oo8o8o8o8oouuouououuuuuuuuuuuuuuu88888888888888888888888888888u8888888888888o8o8o8o000
0000oioioiioooooooooooooooooooooooooooooooooouuuouo8ououuuuuuuu8uuuuuuuuuuu8888888888888888888888888888888888888888o8o8o8ooo8000
0000f8o8oioioo8o8o8o8ooooooooooooooooooooooo8o8o8o8ooou8u8u8uuuuuuuuuuuuuuu88888888888888888888888888888u8888888888888o8o8o8o000
0000oooooooooooooooooooooooooooooooooooooooooouuouo8ouououuuuuu8uuuuuuuuuuu8888888888888888888888888888888888888888o8o8o8ooo8000
0000o8o8oioioovooooooooooooooooooooooooooooo8o8o8o8oooo8uuuuuuuuuuuuuuuuuuu888888888888888888888888888u8u888888888888888o8o8o000
0000ovovovoooooooooooooooooooooooooooooooooooooouou8uouuuuuuuuuuuuuuuuuuuuu8888888888888888888888888888888888888888o8o8o8o8oo000
0000o8o8oioioovoiooooooooooooioooooooooooooo8o8888888888ouououuuuuuuuuuuuuu8888888888888888888888888u88888888o8o8o888888o8o8o000
0000ovovovoiooooooooooiooooooooooooooooooooooooouou8uouuuu8uuuuuuuuuuuuuuuu88888888888888888888888o8888888888o8o8o8o8o8o8o8o8000
0000ohohoioooooooooooooooooooooooooooooooooooiooo8o8888o8u8u8uuuuuuuuuuuuuu888888888888888888888888888888888888888888888o8o8o000
0000iooooooiooooooooooioooooooooooooooooooooooououuuuuuouu8uuuuuuuuuuuuu8u8o8888888888888888888888o8o88888888o8ooo8o8o8o8o8o8000
0000oooooiooooooooooooooooooooooooooooooooooo8o8o8o8888o8u8u8uouououooo8ouo88888888888888888888888888888u888888888888u8u8uouo000
0000iooooooiooooooooooooooooooooooooooooooooooooouuuuuu8u88o8ououuuuuuuu8u88888888888888o8o8o8o8o8ooo88888888o8ooo8o8888888o8000
0000oooooiooooooooooooooooooooooooooooooooooooooo8o8888o8u8u8uououuuuou8ouu8888888888888888888888888888uu888888888888u8u8u8o8000
0000iooooooooooooooooooooooooooooooooooooooooo8oououuuuuuu8o8ououuuuu8u8o888888888888888o88888888888888888888o8888888888888o8000
0000voiooiooooooooooooooooooooooooooooooooooooooooo8888o8u8u8uououuuuuuuouu888888888888888888888888888888888888888888u8o8o8o8000
0000iiioioiooooooooooooooioiiioooooooooooooooo8o8o8u8u8u8u8888u8u8u8u8u8o8o8o88888888888o88888888888u8u888888o8888888888888o8000
0000voioiiioioooooooooooooooooooooooooooooooo8o8ooooooooououououououuuuuouu88888888888888888888888888888888888888888oooooo8o8000
0000iiiiiiiioioioioioioiooooioiooooooooooooo8o8o8o8u8u8u8u8888u8u8u8u8u8uuu8888888888888o88888888888888888888o88888888888888o000
0000voioiviooooooooo1oooooooooooooooooooooooo8i8ooooooooouououououououuu8uu88888888u8u8u8u8888888888888888888o8o8888888888888000
000huiiiiiiioioioiiiiiiiiooooooooooooooooooo8o8o8o8ooo8o8u8o8uuuuuuuuuuouuu8888888888888o8888888888888u8888u88888888888888888000
0000vuiuiiioooooioioioioooooooooooooooioioioi8i8o8ooooooouououuuuuuuuuuuouu888888888o888888u8u8u8uuu8u8u8u8u88888888888888888000
000huiuiiiiioioioiiiviviioooooooooooooooooioooooooooooooouooououououuuuouuu8888888888888o8uu8888888888u8888o888888888888u8u88000
0000ouiuiiioooooooioioioooooooooooooooioioiiiooooooioioiuouououuuuuuuuuuouo8o8o8o8o8o8u8888u8u8888u888888888888888888888u8o80000
000huiuiiiiioioioiiiiiiiioooooooooooooioioioooooooooooooooooououououuuuouuu8888888888u8uouoo8888888888uuuuuuu88888888888u8u8o000
0000ouivi1ioooooooioioioooooooooooioioioioiiiooooooioioiuiuiuiuouououuuuouo8o8ouo8o8o8u8888u8u8888o888888888888888888888u8o80000
000huouv1v1iioioioioioiiioioooooooooooioioiooooooooooooioioiouiuiuiuuuuouuu8888888888uuuuuuo8i8u8u8u8uuuuuuuu88888888888u8u8o000
0000oi1i1i1oioioioioiiiiooooooooooioiiiiiiiiioioioiioioioiuiuiuouououuuuouo8o8ouuuuuuuuu8u8u8u8888o888888888888888888888u888o000
000huouviv1iioioioioioiiiiiioioiooooooioioioiooooooooooioioiouiuiuouvuvovuv8888888888ouououooiuuuuuuuuuuuuuuu88888888888u8u8o000
0000i1i1111oioioioioiiiiiiioioioioioiiioioioioioioiooioioiuiuiuououovuvuouo8o8ouuuuuuuuuuuuuuuu8u8o8u8u8uu8u8u8u8u888888u888i000
0000uo1o1111ioioioioioiiiiiiiiiiioioioioioioioioooooioioiiiiiiiiiioovovovuv8u8u8u8u8uuuuuuuooiuuuuuuuuuuuuououu8u8u8u8u8u8uoo000
0000i1i1111oioioioioiiiiiiiiiiiiiiiiiiiiiiiiiiiiioiooiiiiivivivovovoivovovououououuuuuuuuuuuuuu8u8u8u8u8uuuuuuuuuuu8u8u8u8iii000
0000ou1o1111iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiooooioioioioioiiiioiivivvvvuuuuuuuuuuuuuuuuooiouuuuuuuuuuuououuuuuuuuuu8u8uoo000
0000i11o111iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioiooioi1ivivivovovoivovovououoooouououououuuuuuuuuuuuuuuuuuuuuuu8u888o8o8iii000
0000iu1o1111iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioioioioioiiiiiiiioivvvvvvvuuuouuuuuuuuuuuuuuuouououououououououuuuuuuu8u8uoi000
0000i11o111iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioioooooooiovovovovoioooooiooooououououuuuuuuuuuuuuuuuuuuuuuuuuuuu8u8u888i8i8000
0000iv111111iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioioooooioiiiiiiiioivivvvvvuuuououuuuuuuuuuuuuuuuuuuuuuuououuuuuuuuuuuu8u8uou000
0000i811111iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioioioooo1iovovovovoioooooiooooooouoooooouououuuuuuuuuuuuuuuuuuuuuou8u888o8o8000
0000iv111111iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioioioiooooooooioioioioivivivvvuuuooouuuuuuuuuuuuuuuuuuuuuuuouuuuuuuuuuuuuu8u8uiu000
0000u811111iiiiiiiiiviviiiiiiiiiiiiiiiiiiiiiiiioioioioooooooioioioioioioioioooooooooooooouououuuuuuuuuuuuuuuuuuuuu8u8u888o8o8000
0000iv1111oiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiooooooooioioioiovivvivvvuuuuouuouuuuuuuuuuuuuuuuuuuuuouuuuuuuuuuuuuuuu8uou000
0000u8111111iiiiiiiiviviiiiiiiiiiiiiiiiiiiiiioioioioioooooooioioioioioioioioooooouououououououououououuuuuuuuuuu8u8u8u8u8u8o8000
0000ivi1111iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioioioooioioioioiivvivivuuuuououuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu8uou000
0000u8i81111iiiiiiiiviviuiiiiiiiiiiiiiiiiiiiioioioioioooooooioioioioioioioioooooouououououooouououououuuuuuuuuuu8u8u8u8u8u8o8000
0000vvu1v1viviiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioioioioooooioioioiovvivivuuuuouoouuuuuuuuuufuouuuuuuuuuuuuuuuuuuuuuuuuu8uou000
0000u8i81111iiiiiiiiviviuiiiiiiiiiiiiiiiiiiiioioioioioooooooioioioioioioioioooooouououououooouououououuuuuuuuouo8u8u8u8uouoo8000
0000uuvuvuvuviiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioioioioooooioioioioivivivouuuouoouuuuuuuuuufuouuuuuuuuuuuuuuuuuuuuuuuuuouou000
000008i8i8iiiiiioiuiuiuiuiiiiiiiiiiiiiiiiiiiooooooooooooooooooioioioioioioioooooofofofofofooooououuuuuuouououiui8u8u8u8uouov8000
0000uovuvuvuviiiiiiiiiiiiiiiiihihihihihihhhhhhhhhhvioioioooooioioioioivivivouuuouooooouououuuuuouuuuuuuuuuuuououou1uuuuuuouou000
000000i0i1iiiiii0i1i8i8181iiiiiiiiiivuviiiiioooooooo0ououoi8i8i8i8ioioiofofoooooofofofofofooooooouuuuuu0iui1i1o1ououououuuf0f000
00000huhvuvuvuiuiui0i8ii0iiiiiiiiiiiiiiiiiivivoi1iuiuiuiuououoioiooooioiiiiiooooooooooooooooouio8ououuuuuuuuououou1uuuuuuvufu000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

