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
hhhhhhhhhhhhhhhhhh1111111111111111o111111111111111111111o1oooooooooooooo8o888o8o8uuuuuu8u8u8u88888888888o88oooooooooooooooooooih
hhhhhhhhhhh1h1hhhh1h11111111111111o11111111111111111111o1oooooooooooooooooooo8oo8uuuuuuu88888888888888888oooooooooooooooooooo1io
1hhhhhhhhh1h111hhhh1111111111111111o11111111111111111111ooooooooooooooooooooooo8o88uuuuuuh88888888888888oooooooooooooooooooooi1o
hhhhhhhhhhh111hhhhh1h11111111111111o11111111111111111111uiooooooooo8oooooooooooo8ouuuuuu8h888888888o888o8oooooooooooooooooooioio
o1hhhhhhhhhh1hhhhhhh1h1h111111111111o111111111111f11111uiuiooooooo8oooooooooooo8o8o8uuuuuh8u888888o88888ooooooooooooooooooo1oooi
111hhh1hhhhh1hhhhhhhhhh1h11111111111o1111111111111f1111iuioooooooo88oooo8ooooooooo8u8uuuh8u8u8888ooo88oo8ooooooooooooooooooooooi
11hhh111hhhhhhhhhhhhhh1h1111111111111o111111111111f1111iuiooooouo88o8oo8o8ooooooo88uuuuuh8uu8888ooo8888ooooooooooooooooooooiooii
i11hh11111hhhhhhhhhhhh111111111111111o111111111111f111ioiuiooououo88888o8oooooooo88uuuuhuuuu88888oo88io8oooo8ooooooooooo8oioi1ii
1111111111hhhhhhhhhh11h11111111111111o111111111111f111oiouuo8ouuuo8888o8o8oooooooouu8uuhuuu8888o8ooo8i8o8oo8o8oooooooooooooi1i1i
111111111hhhhhhhjhh1h111h1111111111111o11111111111ff11iouuu8ouiuu8o8888u8o88ooooo8uuuuhuuuu88888ooo8i888oooo8oooooooo8oooo81i1ih
oi111111hhhj11hhhjhh1h1h11111111111111oi1111111111if1i1iuuuu8uuuuu8888u888888oooouuuuuhuuuu88888888i88888ooo8ooooooo888o88i8ii11
ooio111ihhjj111hhhhhh11h111111111111111o111111111i1f1iioiuuuuuuu8uuuuu8888888oooouuuuhhuuu8u888888i888888oo88ooo88o88888o81i8111
ooo1o1i1ii111111hh1h11h1111111111111111oii1i11o111ifiiiiouuuuuuuu8uuuuu888o888o8ouuuuhuuu8u8u8u888i888888o88ooo88888888881811111
oooooi1iiiij11o1o1j1ooo11111111111111111ooi11ooo1i1ifii8uuuuuuuu8u8uuu8o8o8o8oououuouhuuuu88uu8u8i88888888888o888888888888111111
ooooooiiiij11ooo1o1oooooh111111111111111oiooooooooiifo8f8uuuuuuuu8uuuuooooo88o8ouoouhuuuh8888uu8i88888888888o8888888888888i11111
88oooiiiii1ioooooooooooo1h11111111h1111ooioooooovooufff8fufuuuuuuuuuuuooooooooouuouohhuhv888u888i888888888888oo8888888888i1iooo1
8ooooooioiioooooooooooooo1111111111h111ioiioooovouufffffffufuuuuuuuuuooouooo8oouuoohhhvh8v88u88i888888888888oo88888888888oiooooo
888ooooooiooooooooooooooo1111111111hh11iooiioooou8uufffffffuuuuuuuuuuoooooo8ooouu8ohhvhvv88888ii888888888888u888888888888oooooo1
88oooooooooooooooo1ooooo111111111111hiioooihioooou8fffffffffuuuvuuuuuoooooooo80u88ohvuhv88888vi888888888888u888888888888o8ooooii
888oo8ooooooooooo1o1ooo1111111111111ihiioohiiooovovfffffffffuuvvvuuuo8oooooo888888ooihvuvu888iv88888888888uff888888888888oooii1i
88888ooooooooooooo11ooo11111111111111hioooohooooovffffffffffvvvvvvvv8o8uooo8888888hovhiuuuu8vi88888888888uffff888888888hooooiii1
888888oooooooioooi1i1o11111111o111111ohiooooho8ovvffffffffffvvvvvvvuv8uou008888888hohvuiuuu8i88888888888uf8ff888888888h88ooooi11
u888888oooioioio1oi1111111111111o1o1oohhooo8o8o8offffffffffffvvvvvvvooou0o888888888ohvvvuiii88i8u8888u8uf8888ff8888hh888ooooo111
u888888oiioiiii1111111111111111111oooooho8ooho8o8vfffffvffffvvvvvvvvvuvvooo88888888hovvvvuvi8i8iuu8uuuuf888888ufh88888888oooo111
8u8888o8oiiiiiii1111111111111111111oooooho88fhh8vv777fvfvfffvuvvvvvuvvvvvo888888888hovvvvvvvuiiiuuuuuufu88888u8u888888o8ooooo111
uuuu888oiiiiiiii11111iii11111111oo1oooohhh8f8uhh7777777offoououovuvvvvvvvuu8888888hvvovvvvvuuuiiiuuuufu88888u8u88888888ooooooioo
uuu8u88iiiiiiiiii111i1iio111111ofo11ofhohou8ufu87777777uooooouvvvvvvvvvvvvu8888888vvvvvvvvuuuuuiuuuu7u8u88888u8u8888888ooooooooo
uu8uuu8iiiiiiiiii1111i1ooo11111fof111ofhhho7huh777777777o8ooooovvvvvffvvvuvvu888ffvvvvvvvuuuuuuuuuu7u8uuuuu888uu8888o8oooooooooo
uuuuuuuuioiiiii81111111ooo8111off1o1offf7hho7o877777777o7o8oooovvvvffffffvvu8uhvuvuvvvvvvvuuuuuuuu7uuuuuuuuu8uuuu88o8ooooooooii1
uuuuuuuuvioi8ii881i11u1ooooffffvfv1o1ff7huoho8o777777777o8ooooovvvffffffvvvuu8vfvhvvvvvvvuuuuuuuu7uuuuuuuuuuuuuuu888o8ooooooioi1
uuuuuuuuu8vvi8881i1iu1uiooffffffvfoo18uhhhho8ohh7777777oooo7ojvvvffffffffvvu888vhvvvvvvvvvuuuuuu7ufuuuuuuuuuuuuuu88888oooooooioi
uvuuuu8u8uvvv88o88i88uu888ffffffffoo1ohhh88h8hvh7777777jo7777ojvff7ffffffff88vvhhvvvvvvvvuuuuvu7ffuuuuuuuuuuuuuuuu888o8oooooooio
uuuuu88u888vvv888888888888uf8ufffffoo1oh7hh8h8hhhh777hjj77777jj7f7f7ffffffufvhvhvvvvvvvvuuuuvu7fuuuuuuuuuuuuuuuuo8o888oooooooooo
uuuuuuuuu88888vv8888888888888ufffufff1h7h7h7878hhhh1h1hj77f77j7f777ffffffffvhvhhvvvvvvvuuuuuv7fuuuuuuuuuuuuu8u88oo8oo8oooooooooo
vuuu88uuuu888888888888888888uuufufuuh01h777778h7hhhh1huh7fvf7f777777ffffff8uhvhvhvvvvvvvfuu77fuuuuuuuuuuuuuuuu888oooooooooooooio
uuuuuu8u88888888888888888887vuuvfuuv0h1hh777777hh8ihhu1uuvfv77f7777f7ffff8f8hhhhv7vvvvvfuuufffuuuuuuuuuuuuuuuuou8ooooooooooooooi
vuuuuuuuuu88888888888888888vuvvvvuuuuu11777777777i8iihuuvuv7777777777uffff8hvhhvvv7vvvuuuuufu7uuuuuuuuuuuuuuoouuuooooooooooooooo
uuuuuuuuuuu88888888888888888vu7vv1uuuu717777777778iihiiuuv77777777u7v7uhfohoh8hvvvvvv8ufvufu7uuuuuuujuuuuuoouuuuuuoooooooooooooi
uuuuuuuuuu8888888888888888881fvu1u1uuuh1u77777777878hiiiv77777777u7v7vhvhhhhhh8vvvvvvvfuuffuuuuuuuujujuuoouuuuuuuooooooooooooooo
uuuu8uuuvu88888888v88888fffff1uvu11u8uuu1u7777777i1hhhi7ivu7f77777u7vfhhfhhhhhvvvvvvvv87ffuuuuuuuujujo8ouuuuuuuuuooooooooooooooi
uuu8u8uuuvv8888v8v8v88ffvvf8111uuvu1uuuh17777777i1i1hh0i0uuu77777u7ufhhhhhhhhovvvvvvfvvffuuuuuuuuouuooo8uuuuuuuoooooooooooooooii
uiu88888u88vv8vvvvvvvfffffvff111vv11uouu1u0777717ih10h00iuuf77777fuuhh7hhhhhovovvvvfvfffuuuuuuuuouuoouuuuuuuuuouooooooooooooii1i
iiiu888888888vvvvvvvvvfffffff111111111uhu1uuf7111hih0hh710f7f07777uhuhh7hhhfoovvvvvfffff88uuuuuuuouuiuuoooouuuoooooooooooooiiii1
ii8i888888888vvvvvvhvfffffv7f1111111111u71u8uu111ihh7o77777f7777777uhh7uuhh8vhvvvvffffu8uuuuuuuuuujhjiooojooooooooooooooooooiii1
iii8i8888v8vvvvvvvvvhhfffv7uf111111117u7u78u8uu11i00o777777ffff7777hh7uuuu8h877ufffffuuu8uuuuuuuuhhjh1oooooooooooooooooooooiiii1
ii8i88o8v8vvvvvvvv8uvvhhhfff1f11111178u77778800117077o7ffff0000ff7777u7uu7h877u7uffffuuuuuu8houuuuhhhj1jooooooooooooooooooiooioo
iiiiio8o8vvvvvvvvvvfv1vvhhhff11111118o7777780o7077700ff0000000000ff777uhhh77777uffvfv8u8uouhohuuuhuhuhh1j1ojoooooooooooooooooooo
iiiiioooo8vvvvvvvvvvfvvvf1hhh1111111oil7v70777o7177ff00000000000000ff77hh777777ffffvfu8uohhhhuuuujjuihjhjjjjooooooooooo8o8oooooo
iiiiiooo8ovvvvvvvvvfvvvf1711hh1111111l17u77777777ff000000000000000000ff777v777f7ffffuuu8uohhhuuuuujijihjjjjjjojoooo8oo8o8ooooooo
iiiiooo8o88vvvvvvvvvvvf77171f111h111117l7777777vf0000000000000000000000ffv77v777ffffvuuu8huhu8uuujiiijjjjj888jojo88888o8oooooooo
iiiiiooo88ovvvvvvvvvvf77777f77171h111187777077v7f000000000000000000000000f78777ffffvfvh8h8uu8uu7o7iijjjjjj88888o8888888ooooooooo
iiiioioooo888vvvvvvvvv777ff77777711h78788770077f00000000000000000000000000f0777fffffvh8h88uuuv777oijjjjjjjjj88o888uu8888oooooooo
iiioooooo8888uv7vvvvvvv7ffff777717hhh7887800077f000000000000000000000000000ff777ffff77u88u7f7vv77uojjujjjjjjj8888uu8u8888ooooooo
iioiouoououuuvuvvv77vvvv7ff7f7fl77lhhh778877770f00000000000000000000000000000f7777777i8u88ffv7v7uuujujujjjjjj888u88u8888oooooooo
oooououuuuuuuuvvfu7777vv777f7ff7ll7l7787878777f1000000000000000000000000000000f7h777iii87f00fv7ouuu8uujjjjjj8888888888888ooooooo
ooooouoouuuuuuufufv7777777777f77lgl7l8787877o0f01000000000000000000000000000000f777iiiiif000fouoou8u8ujjjjj88888888888888ooo8o8o
ooooooouuuuuuuu7fv7777777777f7777l7l7l88io0077f100000000000000000000000000000000ff77iiif0000ffouo8u8uujjj88888888888888888ooo8o8
oooooououuuuuv7uhh7777777f7f7h77l7l7l7l7800077f000000000000000000000000000000000j0f77uf00000ff8ououuuuu88888888888888888888ooo88
ooooooouuuuuvuv7vvhhhhhhhhfhh7hlhl7u7l7l700777f00000000000000000000000000000000j0j0f70f000000ff8ououuuu88888888888888888888oooo8
oooooooouuuvuvuvv7777ff7hhhhhhl7llu7uhh707777f00000i0000000000000000000000000000j000ff0000000f8uuvuuuuu8888888888888888o88o8oo88
oooooooouuuuv8vv7v7777777777777777fuhhhhh0077f0000i0i0000000000000000000000000000000ff0000000ffvvuvuuuuu888888888888888oo8888888
ooooooo88iuu8v8uv7vv7777777777777f7fhhhhhh777f10000iiiih000000000000000000000000000f0f00000000f7vvvvuuuu8888888o8o88888o8o888888
oiooooooiiiio8uvuvvff7777777777777f7o77007070f0100i0iihhh0000000000000000000000000f000f0000000f7vvv77u7uou8u88o8o8o88888o8888888
io8ooio8oii888vuvvfffffff77777777777uj07007i7f100i0iiihhh000000000000000000000000f0000f0000000f77f7777u7u8u8u811818o888888888888
i8o8io8o8888888vuvvffffffff77777777j70j070i0i7f000iii0ihi0j000000000000000000000f000000f000000f7f7777u7uuu8u8oio1111ooo888888888
ii8i8io8888888i8vvvvffffff7f777777j7jjhj0h0i77f00iii0i0iij0j0000000000000000000f0000000f000000f7777uv7uuuuuooioio111oooo8o888888
iiiiiiii88888i8vvvvffffffff777777f7j7hjhhhh0i7f00ii000i0iij0000000000000000000f000000000f00000f07vvvuvuuuuoo1oi11o1oioo8o8o88888
iiiiiiiii88888i8vvffffffffff777777f7h7h0h10107f000000000000000000000000000000f0000000000f00000f077uvvuuuuoooo1111o1ooo1ooo8o8888
iiiiiiioio88io8ovvvfffffffff7777777h7h7h1010177f00000000000000000000000000000f0000000000f00000f07vvuv88uuoooo11111oiooooo8o88888
ii1iiioioio7oio8ovv8fffffff777777777h0077100007f0000000000000000000000000000f000000000000f00000fv7vvu888oooooo111ioooooooo888888
11i1iiioio7i7ooovov7fffffff77777777777h17077007f000000000000000000000000000f0f00000000000f00000f7v7uuoooouoooo1oiooioooo8o8818o8
1i1iiiiiioi7i7ffffff7ufffi77ii7777777h1h1007777f00000000000000000000000000f0f000000000000f00000f77uuuovvvouuooooooioioooo8o1818o
11i1ii77fffffffouofuffuui7iiv7777777h7h10001777f7000000000000000000000000f000000000000000f00000f7v7uuvvvvv8oooooo1oioioooo1i18j8
777777ffioiiiiououufuu87iiuviv777777fh0000777777f77000000000000000000000f00000000000000000f0000f0vv7vvvvu888oooouo11ioooooi8i8i1
7111iiiiiiiiiiiou888888888uuv777f7fffff777007777f7f777hhhh0h0000h0000j0f000000000000000000f0000fvvvvvvvuvu88uuuuuoo1o1ooooooii1j
111i1iiiiiiiiio88888888888ufu7ff7f7fff77hh777777ff7f7h7hh00h000h0h0h07f0000000000000000000f0000ffuvvvuvvuu8uuuuuouuo1ouooooioij1
1111i1iiiiiii8i888888888888ufffff7f77777hhh77777fff777h7o0h00000h0h77f00000000000000000000f000ffufvvvvvvuuuuuuuuuuuuou8uoo8oi8oj
1111111iiiii8i888888888888ouuff777v7hhhhhhjj777f7f77770o1o7777777770f0000000000000000000000f00fjfvvuvvvvuuuuuuuuuuuuuuuu8888ooio
111111iiiiioi888888888888ouufu7777hhh77hhhjj0777f7f77701o7777o777000f0000000000000000000000f0f0vvvuvuvvvuuuuuuuuuuuuuuuu8u8uoioi
1111i1iii188o8888888888u88u8u8777hh77777h7j0087777f7777770707770000f00000000000000000000000f0f7vvuv7vuvvuuuuuuuuuuuuuuuuu8uoooio
111i1iiiii8888888888u888u88hh7vvv777777777008787777f70000707770000f00000000000000000000000f0f0777f7u7vuuuuuuuuuuuuuuuuuuuuuoooou
1111ii1iii88888888uuu8888uhhhvvvvv77777f7777780o777f0000007070000f000000000000000000000000f0f777f7f7vuuuuuuuuuuuuuuuuuuuuuuuoo8u
111111i1iiiio888fufuuu8878vvv77vv77777fff777hoo1o177f00077000000f000000000000000000000000f0f077f7fvvuvuuuuuuuuuuuuuuuuuuuuuuuuu8
1111iiiiiiiiii8iufufuu77vvv777f7777777fff777oooo17177f777070000f0000000000000000000000000f0f77777vvvvuu8uuuuu88uuuuuuuuuuuuuuuuu
i1i1iiiiiiii88iufufuu7vvv7777f777777777fu08o7oo1117777f7070000f00000000000000000000000h0f0f07777ffvvuuuuu8uu8888u8u88uuuuuuuuuuu
1ihiiiiii888888iufuuuvvu77o7u7777ff77777ff88o7h1h87777f000000f0f0000000000000000000000hhf0f7777ffffuuuuuuu8u88888888u8uuuuuuuuuu
ihiiiiiiii8888ii888vvu77uouuuf77fff7f77f7f787h777o00077f0000f0f000000000000000000000000hhfu7777fffvuuuuu8uu888888888888uuuuuuuuu
h11i11iiiii8iiii88887uu7ouuuffffffff7777f7f7h77770o00007f00f000000000000000000000000000fhh8u7vfffffvuuuuu88v8888888888uuuuuuuuui
hh11111iiiiiiii8888uuu7uuuuffffffffff777ff7fh7777o0h07i70f0f00000000000000000000000000ffvhh7vfvfffvvvuuuuuv888888888888uuuuuuuu8
h11i11iiiii8ii8888uvuvvuuuuffffffffv777fuffh777fo7o0h7ii7ff00000000000000000000000000ffv78hhhvffffhhvv8uuvu888888888888uuuuuuuuo
hi1111iiii8i8888u7vuvvuuuuffffffvfffv77vfuh777f7fo77788i7fff000000000000000000000000ff7fvv8hhhfuuhhhvvvvvu8888888888888uuuuuuuuu
1111i11i888o88887uuvuvuuuuufvvfvfvvv7vv7vh17777f777h7h87f000fff00000000000000000000f77f7v7v7hhhfhhhv7vvvvu88888888888888uu8uuuu8
1uui1i18u8o888888uuuvuuuuuuuuvvvvvvvv77v1h1777777777787f0000000ff0000000000000000ff777777v777hhhhhv7vvvvuu8888888888888888u8uu88
1uuui118888u888uuuuuuuuvuuvuvvvvvvvvvu87h1777777777777ff000000000fff0000000fffffff777777777787hhhhhvvvvuvu88888888888888888uu888
11uu8u888u1118u8u8ujjjjuov8vvvvvvvvvv77h77u7777777777777fff07v770077fffffff777off777777777777hhhhhhhvvvuuvv888888888888888888u88
1118u88111i1118u8ojjjjjooov8uvvvvvvvv7h77uvvv7vvu7777777707ff00000000000000000ff7f7777777777hhh88hhhhvuvuv8v888888888888888ou8oo
11188u1u1i1i1118j1jojojoouuuiuuvvoov7h77oovvvvvvff777777u7777fff0000000fffffff77f7777777777h7h7888hhhhvuu8vv888888888888888ooooo
1u8888u1o1i111111o1j1jjuuuuuuuvuvooou7uooovvvvvuf7f7777777777707fffffff7fuf8f7uu77777777f777h77888hhhohouuv8v888888888888ooooooo
uiu88ooou111111i1oo1o1uuuuuuuuuuuoooouooouuvvuvu77777777777777777ff7f7777f8f8fu7u777777f77777f788uuuuuohuuuv8888888i8i888ooooooo
iuuioooouu111111o1o11juuuuuuuuu8uooooooououuuvuv7777777777777v77f7ff77777778f77uf7777777f777fff888uuuuuuhuuuu888888ii8i8oooooooo
iiiiioo1uu11111i1o1j1juu8uuuuuuu8ooooooouuuuuuvu77v7777777777f777f7f7vv7u7uu777f7f77777uuf88ff88888uuuuuuhhu88i888iiiiiioooooooo
iiiiiii1iii111iiiji1juuuuuuuuuuu88oooooouuuuuuo7u77v77778777777777f7vvuvu7777777f777777uuuu8u888888uuuuuuuhhiii8iiiiiiiioooooooo
iiiiiiiiiiiiiiiiiiji1juuuuuuuuu8o8ooooooouuuoouo77777uuu7777uu877878uuv77777f7877f77777uuu8u888888888uuuuuuhhi8iiiiiiiiiiooooooo
iiiiiiiiiiiiiiiuiiiuj8uuouuuuu8u8oooooooouuuuoooo7777uuu777uuuf8u78uuuu777788f7877787777u8u888888888u8uuuuuoohh8iiiiiiiiiooooooo
iiiiiiiiiiiiiuiiuu8uuujououuoouooooooooooouooooo7o78uuuuu7uuu88888uuuv77777888878887877888888888888888uuu8ooohhh8iiiiiiiiiiiooi1
iiiiiiiiiiioiiuuuuuuujjjouio8oo8ooooooooooooooooo7888uuuuuuu88888u8uuuv77777888888888788888888888888888888oooihh8iiiiiiiiiiio1o1
iiiiiiiiiiiooiu7uuuuujjjj888oj8ooooooooooooooooooo88oo8vuuu8888888u8uu777777788888888888888888888888888888888i8ihiiiiiiii1ii1o1i
iiiiiiiiiioio8iu7uuujjj8888jj88oooooiioooooiioooooo8o88uuuuu8888888uuuu77777778888888888u888888888888888888888i8ihhii11i111111i1
iiiiiiiiiiio8i8iuuujjj8j88jj888oooioiiioiiiiiioooo8o8ouuu8uuu888888uuu77777778888888888uuv88o88888888888888888888iih11111111i1i1
iiiiiiiiiii888i8uujjjjj8jjj888oooooioiiiiiiiioooooooouuu888uuu88888uuuu7777f88888888888uv8888ooo88888o88888888888oi1i11111111i11
iiiiiii11i8i8881uu7jjjujjjj888ooooooiiiiiii88oooooooo8u8888uuu88888uuuu77788888888888888888i11ooo8888oo88888888888oii111111111i1
iiiiiii111i81111ijjjhujjjjjj8ooooooooiiiii8888oooooo8o88888ou888888uuuuu78788888888888888888111ooo888oo8888o88888oii1i11111111i1
iiiiiiii1111111ijjjhjhjjjjjjoooiooooioiiiii888ooooooo8oo888u8888888uuuu7u7v8v88uu8v888888881881ooo8888o8888888888i1ii1111111111i
iiiiiiiii1111111jjjjhjhjjiiiioiooooooiiioii8888oooooooooo88o888888u8u8uu7vuv8vuuvvu8u888oo888188ooo8888o8888888iiii1111111111111
iiiiiiii111111111jjjjhjjjiiiiiooooooiiiii8ii88ooooooooooooo8o8o8888u8uuvuuvuvvvvvv888uooo88o8888iihho888888888i8i1i111111111h111
iiiiiiii1111111111j1jjjjjiiiiiioooooiiiiii8ii8oooooooooooooo8888o8u8uuvuvvuvvvvvv8888oooo8oo888888ohho8i8i88ii8iiij11h1111hhhhh1
iiiiiiii1111111111jj1j1jjiiiiiiiooooiiiiii888oooooooooooooo8888o888u8uuvvvvvuvvvv888ooooooo8oo888oooohoiiiiiiiiii11hh1h1hhhhhhhh
iiiiiii1111i11111jjjj1j1jiiiiiiooooooiiiii8888ooooooooooooooo8o88888uvu88888vvvvv88oooooooooooo88ooohhooooiiiiiiihhjhhhhhhhhhhhh
iiiiii111iii111111jj111jiiiiiiioooioooiiioo88ooooooooooooooo8o888888vuv8888v8v8vvvooooooooooooo8o8ohhhhooiiiiiiiihhhhhhhhhhhhhhh
iiiiiii1ii111111111111iiiiiiiiiioiooooiiioooooooooooooooooooo88888888vuv88v8v88uvvvooooooooooooo8oo1h1h11iiiiiiiiihhhhjhhhhhhhhh
1iiiii1i1111111111111ooiiiiiiiiiiiiioioooio8ooooooooooooooooo8888888vuvu88vv888ouvvoooooooooooooooo11h11iiiiiiiiiiihhhhhhhhhhhhh
111iiii1i11111111111o1ooiiiiiiiiiiiiiiioooi88ooooooooooooooooo88o8888uuu88888888o8ooooooooooooooooooo11iiiiiiiiiiii1hhhhhhhhhhhh
11i1ii111111111111111oooiiiiiiiiiiiiiioooio88ooooooooooooooooooioii8u8u888888888888oooooooooooooooioooo1hiiiiiiiiiihhhhhhhhhhhhh
111i1ii1111111111111111iiiiiiiiiiiiiiiooio8ooooooo88ooooooooooioo88u8uuu88888888888oooooooooooooooo11o1hhhhiiiiii1ihhhhhhhhhhhhh
11111ii111111111111111iiiiiiiiiiiiiiioioiio8ooo8888ooooooooooioo8ou8uou8888888888888ooooooooooooooo1h1hhhh11iiii1i1ihhhhhhhhhhhh
1111iii1111111111111111ii11iiiiiiiiiiioiiooo8ooo8888oooooooo8oi8o88uoou888888888888o8ooooooooooooohh1hhhhh1h1ii1h1ihhhhhhhhhhhhh
jh1i1iii111111111111111i111iiiiiiiiiiiiiiiooooooo88o8ououoo8oioi88iiiuou888888888888ooioooooooooohoohhhhhhh111111hhhhhhhhhhhhhhh
j111ii11111111111111111i1111iiiiiiiiiiiiiiooooooo888ouuuou8u8oiiiiiii1u888888888888ooooooooooooohoohohhhhhhh1h1hhhhhhhhhhhhhhhhh

