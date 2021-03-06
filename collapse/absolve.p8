pico-8 cartridge // http://www.pico-8.com
version 30
__lua__
#include palettes.lua
#include vec.lua
#include poly.lua
#include util.lua
#include subpixel.lua

local parts = {}

function _init()
    pal({
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
        0+128,
        2+128,
        5+128,
        5,
        6+128,
	},1)

	dt=1/30
	t=0
    tf=0
    k2=sqrt(2)

    cls(0)
end

function _update()
	-- cls()
    t+=dt
    tf+=1

    local st4 = sin(t/4)
    local ct4 = cos(t/4)

    if rnd(1)<0.5 then
        local x,y = rnd(124)+2, rnd(124)+2
        local p = rnd(#palettes[curr_pal])+1
        line(x-4,y-4,x+4,y+4,p)
        line(x-4,y-3,x+3,y+4,p)
        line(x-3,y-4,x+4,y+3,p)
        line(x-4,y+4,x+4,y-4,p)
        line(x-4,y+3,x+3,y-4,p)
        line(x-3,y+4,x+4,y-3,p)
    end

    for i=1,25 do
        local x,y = rnd(124)+2, rnd(124)+2
        local p = pget(x,y)
        if p~=0 then
            if rnd(1)<0.5 then
                circfill(x,y,4,p)
            else
                line(x-4,y-4,x+4,y+4,p)
                line(x-4,y-3,x+3,y+4,p)
                line(x-3,y-4,x+4,y+3,p)
                line(x-4,y+4,x+4,y-4,p)
                line(x-4,y+3,x+3,y-4,p)
                line(x-3,y+4,x+4,y-3,p)
            end
        end
    end

    if rnd(1)<0.1 then
		x,y = 0,rnd(124)+2
		while x <= 128 do
			nx = x + 8
			ny = y + rnd(16) - 8

			line(x, y, nx, ny, rnd(10))

			x = nx
			y = ny
		end
	end

    local circle = {}
    local sides = 24
    local r = 24
    for i=0,1,1/sides do
        local ang = i + t/2 + sin(i/16 + t/6)
        local r = 
              r 
            + sin(t/8 + ang*2)*4 
            + 8*sin(sin(ang/8))
            + i*sides%2*((st4*2+2)%4)

        add(circle, vec.frompolar(ang,r))
    end

    for i=1,175 do
        local x,y = rnd(124)+2,rnd(124)+2
        local p = flr(boxblur(x,y,2) + 0.5)
        circ(x,y,1,p)
    end

    polyf(circle,vec(64,64),0)
    polyv(circle,vec(64,64),palettewave(t-4, palettes[curr_pal], 16))

    for i=1,1200 do
        local ang1,r1 = rnd(1),sqrt(rnd(60*60*2))+2
        local ang2,r2 = ang1, r1 + 1.2

        local x1,y1 = r1*cos(ang1),r1*sin(ang1)
        local x2,y2 = r2*cos(ang2),r2*sin(ang2)

        local smpl = pget(x1+64,y1+64)

        if smpl~=0 then

            circ(x2+64,y2+64,1,smpl\1)
        end
    end

    if rnd(1)<0.4 then
        local x,y
        if rnd(1)<0.5 then
            x = -1
            y = rnd(128)
        else
            x = rnd(128)
            y = -1
        end
        local pos = vec(x,y)

        local ang = -1/6 -1/32 + rnd(1/32)-1/64
        local spd = 4
        local vel = vec.frompolar(ang,spd)

        add(parts,{
            pos = pos,
            vel = vel,
            life = 180
        })
    end

    for part in all(parts) do
        local pos,vel = part.pos,part.vel

        part.life -= 1

        pos:set(pos + vel)

        local p1 = pos
        local p2 = pos + vel*4
        local c = pget(p1.x,p1.y)
        local p = c~=0 and c or 2
        line2(p1.x,p1.y,p2.x,p2.y,p)

        if pos.x>150 or pos.y>150 or part.life<0 then
            del(parts,part)
        end
    end

    if t%8>7 then
        local ox,oy = rnd(16)-8,rnd(16)-8
        fillp(rnd(36000))
        rectfill(64-12-ox,64-12-oy,64+12+ox,64+12+oy,12)
        fillp()

        local ang = t
        local r = 12
        local dir = vec.frompolar(ang,r)
        local pdir = vec.frompolar(ang+0.25+0.25*sin(t/2),r + sin(t/8)*2)
        local ori = vec(64,64)
        
        local p1 = ori + dir
        local p2 = ori - dir

        local p3 = ori + pdir
        local p4 = ori - pdir

        line(p1.x,p1.y,p2.x,p2.y,10)
        line(p3.x,p3.y,p4.x,p4.y,10)

        for part in all(parts) do
            part.vel = (part.pos - vec(64,64)):norm(rnd(2)+2)
            part.pos = vec(64,64)
        end
    end
end

function palettewave(x, palette, period)
	return ctriwave(x, #palette/2+1.1, #palette-1.2, period)
end
__label__
ih1h1ooooooooooio111o1111h8h11111111111h1o1oiooihih1iiiioiioo1o1oiooiojojoii1iioi1i1ihj1j111111111111hh111h11111h11111h111111hhj
hih1ooooooooooioio1o1o11u11hh1111111111ioooioooiih1i8ii8oioiio1iiooioiojoio1i1oioi1iiihj11o1111111111h1h1h111111111i1h1h1111hhjh
iioooooooooooooii1o1oo1111111111111111i1ioooiooiiii8i88i8oiooiooiiooioiooiii1oooi1jjijijoo1o1i11111111h111h1111111iii1h111111hhj
ihioooooooooiioioi11oo11111111111111111iiooiooooiiii8i88oiiioooioioooooiiiiooiiiioi1iiioooo1iii1111111111111111111iii11111111hhh
hiiiiiooooooiiioii11101111111111111i111iiiooooouioiii8iooiiiiiioioioooooiiooooiooioi1iiioiiiiiii1111111111111i111iiiii111111111h
iiiiioiooooioiiii1i111i11111111111iiii1iioiooooo8f8iioo8ooiiiiiioiiooooooooooioiooiiiiiioiiiiiiii1111111111ii1i1iiiiii11111111ih
h1iiiiioooooiiiiii111111111111i11iiiioo1oioooii8f8ffoioooiiiiiioiiioooooooooooiiiiiiiiiiuiioiiii11111111iiiiiiii1iiii1i11111111h
111iiiiioooii10iiiii111iii111iiiiiiiioiooouoiiii8ff8foioiiiiiiiiiiooooooooooooiiiiiiiiioioiiiiii1111111oiiiiiiiiiiiiii11111111h1
111iiiiiiiiiii111iii1i1iiii11iiiiiiiiiiiiiiiiiiiof8fo8iioiiiiiiiioooooooooooooiiiiiiiioooiiiiiiiii1i1iooviiiiiiiiiiiji1111111111
o1ooiiiiiiiiiii111ihi1i1iii1iiiiiiiiiiiiiiiiiiiiiif88f8o8oiiiiiiiioooooooooooiiiiiiiiioioiiiiiiiiiioiooviviiiiiiiiijjjii11j11111
ooooooiiiiiiiiihhhhhhiiiiiiiiiiiiiiiioiiiiiiiiiiio8of8f8o8iiiiiiioioooooooooo8iii88iiiioiiiiiiiiiioooiooviiiiiiiiiijjjiijj1j1111
ooooooiiiiiiiiiihhhhi1i1iiiiioiiiiiio0ooiiiiiiiifiiiof8o8ooioiiiii8i8ooooooooo8o888ioiiiiiiiiiiiiioooovoiviooiiiiiiijjjjjjj11111
oooooooiiiiiiiiihhhh1i1i1iiiiiiioooo0oooiiiiiiviiiioi88888ioioiii888o8ooooooo8o8o8iiio8iiiiiiiiiioioovoooiooooiiiiiiijjjjj1111j1
ooooooooiiiiiiiiihiii1iiiiiiiiioooooooooiiiiiviviiii888888iioiii88888o8ooooooo888iiio8i8iiiiiiiiiioioioooiiooiioioijjhjjjjj1jj11
ooooooooiiiiiii1iiiiiiiiiiioiiiioooooooooiiio8vviiiiii8io88ooo8ho8888888oo8oo88888io888iiiiiiiiiiiiooiooiiiiiioioooihjjjjjjjjjjh
oooooooooiiiiiiiiiiiiiiiiioioiiiooooooooiiio8v8vviiiiiioio8oooo88u888888oooo8o88i88i888iiiiiiiiiiooooooooiiiioiooojijjjjjjjjjjjj
oooooooooiiiiiiiiiiiiiiiiiiooooooooooofoiio888vvvvviiioio8iioo88u8u88888ooooo88i8i8ii8iiiiiiiiiiooooooooooiiiiooohijjjjjjjjjjjjj
oooooooooooiiiiiiiiiiiiiiiioioooooooofoffou888ivvvviiiioiiiio888uu88888oooooo888iooiiiiiiiiiiiiiooooooooooiiiooiiiijjjjjjjjjjjjj
uoooooooooiiiiiiiiiiiiiiiiiiooooooooooffffou88ii8voiiiiiiiiiiuuu8uof88o8ooo8u8iioioiiiiiiiiioiiiooooooooooooooiiiiiiojjjjjjjjjjj
oouo8fooooiiiiiiiiiiiiiiuiioiiooooooooofffuu8f88o8ooiiiiiiiiuuuuuuf8f8oo888u8iiiioiii1iiiiioiooiioooooooooooooiiiiiiijjjjjjjjjjj
ououfffooooiiiiiiiiiiiiuiuuuoiioooo888ffffuuu88o8o8oiiiiiii8iuuuufff8uou8888uiiiiiii1iiiiiiiooooiooooooooooooiiiiiiijjjjjjjjjhhh
oouvufffoiiiiiiiiiiiiiiiuuoooooooo88888ffuuuuof8o8f8oiiiiiiiuuuuffffufu8u88888iiiiiii1iiiiiiio88ioooo8oooooooiiiiiiijjjjjjjjjjhh
fffuvfffiiiiiiiiiiiiiiiiioooooooooo888888fuuofo88f8f8oiiiiiiuufffffuuu8uu8u8888iiiii1ii1iiiioo888i88888oooooioiiiiiiijjijjhhhhjh
ffffuuuifiiiiiiiiiiiiii8iooooooooooo8888fuuufof8uvf8oiiiiiiiuuuufffufufu8uu888iiiii1iii11iiiooo88888888oooooooiiiiiiijijihhhhhhj
fffffuuuiuiiiiiiiiiii8iiiiooooooooooo88o8uuuof8uvuvfiiiiiiiiuuufuffffuufuu88uuiiiiijiiiii8ijiooo888888oooooooiiiiiiiiii1j1hhhhhh
fffffu8uiiiiiiii8iiiiiiiioooooooooooooooouuufffouvviiiiiiiiiifuufffufuuuuu8uuuiiiijijii18ijijooo8888oooooooooiiiiiiiii111hhhhhhh
ffffu8i8iiiiihiiiiuuiooiioooooooooooooofo8uoffffovfiufiiiiiififfffufufuuu8uuuiiuiijjii8jo8jj8oo88888oooooooooiioiiiiii111h1hhhhh
ffffff8iiiiiiiiiiiuuuooouuoooojooooooooofuouuffovovufuiioiiiifvffffufuuuuuuuuuuouoi88888j88oo8o888888o8ooooooooooiiii11111h1hhhh
fffuuiiiiiiiiiiiiiiuuuuuouoojjojooojjo8fffu7uuff7vvfufuiiiiifvffffffuuuuuuuuuuuuoi88oo8joo8ouo88888o88o8oooooooooiiii1111111hhhh
ffufiiiiiiiiiiiiiiiiuuuouoojoojo1o1jjjff7f7f77f7vvfvfuvf77if7ffffffuuuuuuuuuuuuoo8888ooo8oouou888888o88oooooooooiiii111111i1hhhh
ufffuiiiiiiiiiiiiiiii8u8oooojoo1j1j1j8o777f77777777ffvfv77f7f7fffffuuuuuuuuuuuuuu8o8888oooouu888888oooooooooooooooi1i11111iihhhi
uufffuiiiiiiiiiiiiii8u8888oooo8j1j1joo77777777777777ffv7777f77f7fffuuuuuuuuuuuuuu88888oooouuuu8u8888uooooooooooooooi111111iiihii
uuufvfiiiiiiiiiii8ii8888888o88jojjj88787777777777777ff777777777f7v7fuuuuuuuuuuuu8o88o8oooouuu8uuu88uooouoooooooooooo111111hiiiii
iuuufvifiiiiiiii8i88i88888888fojjjjj7877777777777777f77777777777vvvuuuuuuuuuuuuuu8oouo8oouououuuuuuuoouo8oooooooooo1o111111iiiii
uiuuuiiiiiiiiiiii88i88888888ffjjjojjj777777777777777777777777777vvvuuuuuuuuuuuuu8uooooooouuououuuuuuuuu888oooooooooi11111hiiiiii
i88uiiiiiiiiiiiio8o8u888uu88jjjuuoojjj77777777777777777777777777vvvuuuuu7uuuuuu88uuooooouuuoouuuuuuuuuuu8oo8ooooooioo111hiiiiiii
jhu8iiiiiiiiiii88o8o8888uuuj8juuuof77777777777777777777777777777uuuuuuu7u7uuuu888uuuooououuuuuuuuuuuuuuuoo8o8oooooooooo1hiiiiiii
h1i1iiiiiiiiii8o88o888888uuujuuuff7777777f7777777777770077777777uuuuuuuu7uuuu888uuuooooououuuuuuuuuuuuuu888ooooooooooh1oiiiiiiii
111111ihiiiiiio8888888888uuuuuu877f7777ff7ff7700077777777777777u7uuuuuuuf8uu8888uuooouooouuuuuvuuuuuuuu8888ooooooooohjh111iiiiii
111111iiiiiiiii8o888888u88uuuuf7f77777fffff7f7777077777v777u77077uuuuuuu8f87888888oouuuooouuuuuvuuuuuuu888ooooooooohjhj11i1iiiii
1111111iiiiiii8i88o8uuu8uuuuuuuf7777777ff07f70777f7777v0v0u7uu77u7uuuu77f877u8888o8uuuuuouuuuuuuuuuuu88888oooo8ooooohj1i11iiiiii
h111111iiiiii8i8888uuuuuuuuu7ufuf77777777777777077f7777v007u77v77ufuu77777777u88888uuu8uuuuuuuuuuuuuuu88888o8888ooojhoi1iooiiiii
hh1i1iiiiiiiii88888uuuvvuuu7v7ufu7777777077777777777777770070v777fuf7777777778888888v8v8uuuuuuuuuuuuuuu8888888888ooooooioiiiiii1
hhihiiiiiiiiioiu8888vvvfuuvv777uu7777777077700777777777770777777777777777ff7f888888vvv8vuuuuuuuuuuuuuu88888888o8ooooooooiiiiiiii
h1hi1iii1iiho8o8uv8vvvvvvvvv7777777777777700i07777777770077770077777777777fff78888fvvvvuuuuuuuuuuuuuuu88888888ooooooooooioiiiiii
1h11h1ioi1h1hooovfvvvvvvvvv77777777777778000000000007700000007777777777777777f888fffvvvvuuuuuuuuuuuuu8u888888ooooooooooooiooiiii
h1hhhhoioi1hhohofvvvvvvvvvvh77v77777777878000000000700000000000000077777777777ff7ffffvvvuuuuuuuuuuuu8u8888888ooooooooooooooooiii
hhhhhhhhohoo1houuuuuvvvvvvv77h77777777778700000007700000000000000000007777777f77f7ffffvvvuuvuuuuuuuu888888888oooo8uuuooooiooii11
hhhhhhhhhoh1ohuuuuuuuvvvvvvvh7777777777707000007770000000000000000000007777777f77f7fffvvvvvuuuuuuuuu8888888u8ooo8o8uuuuoooiiiii1
hhhhhhhhhhhhhoouuuuuvvvvvvvvvh77777777701170000770000000000000000000000077777777777ffffvvvvvuuuuuuuuu888uuuuuoouu8uuuuuuoiiiii1h
hhhhhhhhhoh11vuuuuuvvvvvvuvvvhhhh7777700117000770000000000000000000000000777777777fffffffvfuuuuuuuuuu888uuuuuouuouuuuuuuuiiiiih1
hhhhhhhhhh1hvhvuuuvvvvvvuvuvhhhhhh777107117000700000000000000001000000000j77777777ffff7ffffffuuuuuuuuuu88uuuouuuoouuuuuuiiiiiiii
hhhhhhhh1oo1hvvvuv8vvvvvvuhhhhh7777770000000077770070iiiiihhhh1017777777j7jh777777ff77fffffffu7vuuuuuuuuuuuuuuuoouuuuuuuiioioiio
hhhhhhhho1oh1vvvv8v8fvfv7vvhhh77777777000000777770070iiiiihh0j010100777j7jh0h0777f7f7ffffffu77v7vuuuuuuuuuuuuuo8ououuuuuuoiioooi
hhhhhhhoioiohivvvv8vvfv777vhhhh777787700000077777007iiiii100j0j010000000j0jh0h07j7f7f7f7ff77u77vuuuuuuuuuuuuuuuouououuuuouioiooo
hhh11hhioioiiiovovvvvv77777vhhh77777007000007777700iiii01i100j00000000000j00h0jj0j777f7777u7777uuuuuu8u8uuuuuuuuououuu8uuooioooo
hh1h1hhohoihii8ovhvv7vv77777vv777777001700007777707iii0001ii00000000000000000j0jj0777777777f777vuuuu8u8u8uu8uouuuou8u8u8u8o8oooo
h1h1hvhhohhih8h8ivh7v77777777777177710h170007700770iio0000ii000000000000000000j00007777777vvf7vuuuuu88u8u88o88ouuoo88888888o8ooo
hh1vhvvuh88hhh88v8vu7777777777777107000h700077007077o00000000000000000000000000000h7777777vvvvuuu8uuuuuu8888oo8oooo8888888o8oooo
hhvhvvvv8888h8888vu7u777777777777707000o7700707o07770000000000000000000000000000000h77777v7v7uuu888uuuuu88888oooooo8888888oooooo
vhhvvvvvv88f8f88fuvu777777777777777007o7o7707070o77700000000000000000000000000000000h77777v7vuuv8888uuu88888oooooooo88888ooooooo
vvuvvvvvvvfvffffffufu777777777777770707o707070700i7000000000000000000000000000000000007777uv7vv88888888888888ooooooo8888ooooooo1
vuvuvvvvvvvfvfffffffvu77777777f77777878700077007i7i0000000000000000000000000000000000007777uv7v88888888888888oooooo8o8888o8ooooo
vvuvuvvvvuvvfvfffffvuvuv777f7f7f777878780007700i0i7000000000000000000000000000000000000077u77v8v788888888888888o8888888888o8ooio
uuuuvuvvuvuuvffffffuvuuuvufuf7f777778780o7077770i77h0000000000000000000000000000000000007777u7v777uu8u88888o888888888888888oiiii
ouu1u888vouuuuffffuvuu7777uf7f777777787o7o7777077770000000000000000000000000000000000000h777ou777uuuu81888888888888888888888oiii
uo1v1o88oiouuvfffffuu7777uu7f777777777ovv7877077777000000000000000000000000000000000000h07770oo7uuuu8u8u888u88888888888888888oii
1vv1iiiiioi8uuufuuuuuu77u7ff7777777777vvvv7777077770000000000000000000000000000000000000h077o77ouuuuu8uuu8uuu888888888888888oioi
v1iiiiiioi8ufufufuuuuuuu777777777777777vv7877077077000000000000000000000000000000000000000777777vuuuuuuu8uuu888888888888888oioii
1iiiiiiooo88ufufuuuuuuu7u7777777777777777700770070700000000000000000000000000000000000000077777v7vuuuuuuuuu88888888888888888o8oi
11iiiioooo888u8uuuuuuu7u777777777777f77770i00700077000000000000000000000000000000000000000777777v7uuuuuuuuu888888888888888888888
1111118oo888888uuuuuuuu7u777777777777f7u7o0i0i700070000000000000000000000000000000000000000777777uuuu8uuuu8888888888888888888888
111118o88888888uuuuuuuuuuu77777777777787o0o077770077h0000000000000000000000000000000000000077777u7uuuuuuuu8888888888888888888888
111i1888888888uuuuuuuuuuuuu77777777777777o07070700070h00000000000000000000000000000000000007777078uuuuu8uuuu8888888888888888888i
11i18i8888888uuufuuuuuuuuuu77777777770777070000770007000000000000000000000000000000000000007777f7vvuuuvuvvuuu8888888888888888888
i11ii8i888888fufufufuuuuuuuuu777f7707707000000077000700000000000000000000000000000000000000777f7fvvvuv7vvvuu88888888888888888888
1iiiii888888fufufufffvuuvuuu7u77777777700000000707000700000000000000000000000000000000000007707f77vvvvvvv88888888888888888888888
i11i88888888u8ufufvvvuvuuvuuu7f7777777700000000077000770000000000000000000000000000000000007707777fvvvvvv88888888888888888888ooo
11188o8888888u888vvvvvufvuvuufvf7777077700000000770070770000000000000000000000000000000000077877v7vvvvvv8v888888888888888ooooooo
h11oo8o88888888vvvvvvvfvvvuuff77777ff777000000000700070700000000000000000000000000000000000787v77v7vvvvvvv888v888888o88888oooooo
11o1oo8o8888888vvvvvvffvvvuff7f777fff77770000000007000007000000000000000000000000000000000778v7777vvvfvvvvv888888ooooo8o8ooooooo
111o11o188888vvvvvvvfvfffffuff7ffffffo7777000000007000000700000000000000000000000000000000787vv777vvfvvvvvv888o8ioiooooooooooooo
111111i81888vvvvvuuvvfvfuffffffffffff77777000j00077000000700000000000000000000000000000000770vvv7vvvvvvvvvvv8o8iiioio88ooooooooo
h1hiiiio8o88vvvvvuuuvvvufuffffffffff77777770j0j0707700000070000000000000000000000000000h0777vvvvvvvvvvvvvvvvv8oiiiioooo8oooooooi
1h1iiio8o8oo8v8vvvuuuvuuuffffufffff7777777770j0007077000000700000000000000000000000000h0h77vv7vvvvv8vvvvvvvvivoiiiiioooooooooooo
111iii8o8888888vvvvuuuuuuufvffffffffffff7f777000000007700000700000000000000000000000000h77777vvvvv8v8uvvvvv8ioioiiiooooooooooooo
hoiioii8888888888vvvuuuuuuufvffffffffff7f77777000000000700007000000000000000000000000000707777v7vvv8uvuv8v8ooooiiiiiooooooiooooo
ohooi88888888888888uuuuuuuuvfvf7fffffffff7787770000000007000070000000000000000000000000077777vf77vvuuuu8u8oooooiiiioiiooooooiojo
hooo8888888888888uuuuuuuuuuuv77fffffffffffv7877700000000070000700000000000000000000000077777ff77vu88uuuu8uooooooiioiiiiiiooioijj
11o8o88888888888uuuuuuuuuuuu7f7fffffffffffvf777870000000077700700000000000000000000000777777777v7vv88u88u8oooooiiiioiiiiioiiijij
111o88888888888u8uuuuuuuuuuff7fffffffvfffff7f787770000000070700700000000000000000000077077777777vv8v8888888oooiiiiii1i1io1oiiiji
11111188o8888888u8uuuuuuuuffffffffffffvvv7vf7778777000000000077070000000000000000000777777777777uuv888888888ooiiiiiii1i11oiiihih
1111118o8oo8888888u8u8uuufffffffffffffvvvuv7uuf7777770000000000707000000000000000077777777777777u888888o88i88iiiiiiiii1i1ihihhhj
111i88i88oooo888vuuuuvvuvvffffffffffffvvvvvvuuuf77uuu770000000007700000000000000070777777777ii7o888888o8oooioioiiiiiiii1ihhhhhhh
1hi8i88888oo8888uuuuvuvvvvfffffffffffvvvvvvuvuuuuuuuu77770000000007000000000000070777777777iiii7oo8o8oooooooooioiiiiiii1hhhhhhhh
1iii8i88o8oooo888uuvuvvvvvvfffffffffvvvvvvvuu7uuuuuu77870770000000000000000000770777777777u7ii77oufooooiiooooooooiiiiiihhhhhhhhh
1iiii81oooooooo88uvvvvvvvvvvvfffffffvvvvvvv7u77uuuu77777777770000000000000007777777777777777v7uuofuooiiiiiooooooooiiiiihhhhhhhhh
1iiii11ooooooo8uuvvvvvvvvvvvvffffvfvvvvvvvvv7uuuuu7877u7o7o7777000000000777707777f777787787v7vuooufooiiiiiioooooooii1i1ihhhhhhhh
ih1i1111ioiiiou8uvvvvvvvvvvvvfffffvuvvvvuvvvuuuuuuu78u7u7o77o7777000777777777777f7f7ui7u8787vu7ououoiiiiiiiiiiooooi1i1i1hhhhhhhh
1111111iiiiiiiiiivvvvvvvvvvvfffufffuuvvuvuvuuuuuuuuuuou7o7oo7o7uv777f77787777777vffuuuu8u888uovfofuoiiiiiiiiioioooiii11i11hhhhhj
h1111111iiiiiiioivvuuvvvvvvffffuufffuuvvuuuuuuuuuouuuuoooooooouvuv7f7fu777u77777vfvfuu8u888888fffufoiiiiiiiiiioooi1ii1111111h1hh
1h11111iiiiiiiiivvuuuuvvvuvfffuuuuffuvvvuuvuuuuuuu88uooooooooovuvvu7fu7uvu77f77vvvfuuu888888888fffu8oiiiiiiiiioii1i1i11111111h1h
h111111iiiiiiiiiiuuuoiuuuuuuuuuuufufuuvuuuuuuuuuuuu8ooooooooovouvuvuuuuvuvuf7f7vvviiuo8o88o8888ffu8uiiiiiiiiiiii111111111111111h
h111111iiiiiiiiiuioouuouuuuuuuuuuuuuuuuuuuuuuuuuuuuo8ooooooooouvuvuuuuuuvu77f777vviiiiu88o8off8888u8ooiiiiiiii1i11111111111111hh
1h11111iiiiiiiiiioioouuuuuuuuuuuuuuuuuuuuuuuuuuoououo8oooooooovufuuuuuuuu7fuf777viviiuouf8off8f88888ooioioiiiiiii111111111111hhh
i1h111i1iiiiiiiiiioouooouou8uu8uuuuuuuuuuuuuu8uououoooooooooooofuuuvuuuuuu7fuff77viioiuoooooif8o88888ioioiiiiiii1i1111111111hhhh
hhh1111i1iiiiiiiiioooo888o8uuuuuuuuuuuuuuuuuuuooouoooooooooooofuuuvuuuuuuuu77fvfvviiooioiooiiioo8o88iiiooiiiiiiii11111111111hhhh
hhhhii11iiiiiiiiii8oo888888uuu8uuuuuuuuuuuuffooooo8oooooooooofvuuvvuuuuuuuuuf7fvvvvoooiioiooiiooo888iiioioiiiiiiiii1111111111hhh
1h1iiii11fifiiiiiii8i8888888u8uuuuuuufuuuufff8oooooooooooooofvufuvuuuuuuf7uu78f8fvooooiiiiooooooo8888iiioiiiiiiiiii111111111111h
h1h1ii11f1fifiiiiiii8i8888888uuuuuuuuuuuuuff8fooooooooooooofoffuvuvu7u777777vf8ffooooioiiiiooioooo88iiiiiiiiiiiiiii1ii1111hhh11h
1h11h1111fffiiiiiii8888888888uuuuuuuu8uuuuf8f8oooooooooooofofv8ouvuv777777778vfffoooioiiiiiiiioooooooioiiiiiiiiiiiiiiii11hhhhhhh
h11h1h11fffiiiiiii8o888888888uuuu8ufffuuuuii8o8ouoooooooooufvuv8ouvou77f7778vfffffoiiiiiiiiiioioooooooiiiiiiiiiiiiiiii1111hhhhhh
h111hiiiffiiiiiii8888888888888uu8fffffuuuufii8ooooooooooouuvuvoo8oouooo7ff8787fvffuuuiiiiiiiiioooooooiii1iiiiiiiiiii11hhhhhhhhhh
1111ii1fuffiiiii888888888888888888fffufiuuiiiioooooooooouuuuvuoooo7ooooo78o878fuvuuuuuiiiiiioooiiooooiii11i1iiiiiii1hhhhhhhhhih1
111o1i11ffiiiii8i88888888888888888iiufiiiuufiooooooooooouuuuuuuoooooooooo78888ouuuuuuuiiiiiiioiiiioooii1111i1iiiii1ihhhhhhhii1i1
11o1of11iifiiiii8i8888888888888888iifuiiuuuooooooooooooouuuuuu88oooooooooo8o8ouuuuuuuuuuiiiiiiiiiiioioiii111ii1111ihhhhhhhhhii1i
111offfi1iiiiiiiii888o88888888888oioiiuiuuiooooooooooooiouuuu8u88oooooooo8o8oiuuuuuuuuuiuiiiiiiiiiiiiiiii111i111111hhhhhhhhhiiii
1111ff11i1iiiiiiiio8o8o888888888oioiiiiuiiooooooooooooioiuuu8u88oooooooooo8ooouuuuuuuuuuiiiiiiiiiiiiiiiiiiii1111111hhhhhhhhhiiii
j1iiii111i1iiiiiiii88o8888888o8iioiiiiiiiioooooooooooioi8iu8u88o8oooooooooooooouuuuuuuiuiiiiiiiiiiiiiiiiii1ii1111111hhhhhhhiiiii
1i1iiiiii1iiiiiiii8888888888oooiiioiiiiiiiooooooooooioi8i8uu8uo8oo88ooooooioooiouuuuuuuiiiiiiiiiiiiiiiiii1i1i1111111hhhhhhhiiiii
hhiiiiiiiiiiiiiiii8888888888oooiiiiiiiiiiiioooooooooio888uuuuuooouoooooooioiiiouuuuuuiiiiiiiiiiiiiiiiiiiii11111111111hhhhiiiiii8
h1iiiiiiiiiiiiii11o8888888888oiiiiiiiiiiiiiiiooooooioi888uuuuuuuuouoooooooiiiiiiuuiuiiiiiiiii1iii1iiiiiii111i111111111hhiihiii8i
hhiii11iiiiiiii1118888i888o88iiiiiiiiiiii1iiooooooooioo8uuuuuuuuuuuuooiooooiiiiiiiuiiiiiiiiiii1i111iiiii11ii1i111111118188ih88i8
hhhi11iiiiii1iiiiiiiiiii8oohhhiiihiiiiii111ohooooooooooouuuuuuuuuuuuiioooooiiiiiiiiiiiiiiiiii11111111i1i1iiii11111111811o8888888
hh111iii1iiii1iiiiiiiiiiiohohhhihhiiiiii11h1hhioooooooouuuuuuuuuuuuuoioooooiiiiiiiihiihhhiiiii111111iii1i1iii1111111111o1o888888
h11iiii111iiiiiiiiiiihhihioh1hhhhhiiiii11h1h1hiiiooooooouuuuuuu8uouoioooooooiiiiiiiihhhhih1iii11111iiiiiii1ii11i11111111o8888o88
11iiiii1111iihhihiiiihhhhhihhhhhiiiihii1hhh1hoiioiooooooouuuuiuuoioioo1ooooiiiih1iihhhhihi1iiii111h1iiiiiii11hih1h1111188888o88h
11iiii1111111hhhihiihhhhhhhihhhihhihjj1ihhhhoiiiioooooooouuuuuuuuoiui1ooooiiiihih1hhhhhhihhhii111h1hhiiiiii111hii111111188h88o88

