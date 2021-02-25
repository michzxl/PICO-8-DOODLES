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

	for i=0,7 do
		pal(i,i+8+128,1)
	end
end

function _update()
	-- cls()
	t+=dt
	tf+=1

	ct,st = cos(t/8),sin(t/8)
	act,ast = 0+8*ct,128+8*st
	st8 = sin(t/8)

	if rnd(1)<0.2 then
		lx,ly = rnd(128),128
		for i=1,5 do
			nlx,nly = lx+rnd(30)-15,ly-(rnd(30))
			line(lx,ly,nlx,nly,rnd(8)+8)
			lx,ly=nlx,nly
		end
	end
	
	for i=1,150 do
		ox,oy=get_oxy()
		for y=oy,oy+bk-1, 2 do
			for x=ox,ox+bk-1, 2 do
				local q = sqrdist(x,y,act,ast)/4000
				local diff = q - flr(q)

				local c = (x/16 + y/16) 
				+ sin(x/(64 + 16*st8))
				+ flr(q)
				+ t
				
				c = c%8+8
				
				if diff < 0.1 + y/250 then
					c -= 8
				end

				pset(x+0.5,y+0.5,c)
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
bbbbbbbbbbbbbbbcbcbccbccdcddeeeeeeeffoooo888888888888888888888ff8f88888888989qqoboa9a9babaccccccccccttdddddddddddddddddduuefeffe
cbbbbbbbbbbbbbbcccccccddddddeeeeeevfvffofofooooo88888888888888f888888888889899qrqbbbbcbccccccccccccccdttddddddodeddddddddooeeeff
ccbbbbbbbbbbbbbcbcbcbcccdcdcedeeeeefffffffff8o8o888888888888888888888888f8999999arababbbbbcccccdcdcccccttdedededdddddddddddvufee
cccbbbbbbbbbbbbcccccccddddddeeeeeefffffffffofoooo8o8888888888888888888888999999aarrrbcbccccccddcbdcddcdcutededodeddddddddoduveff
ccccbcbbbbbbbcccccccccccccddedeeeeffffffffffffofofof8ooo8888888888888888889999aaaaprasabcbcccccddddddddcdcutededdddddddddddedvee
bbbbobbbbbbbbbcccccccddddddedeeeeffffffffffofofofofoooooo88888888888888899999a9aaaabrrrbscccdcddbdcddddcdccttdddedddddddddeeevvf
bcbcbcbcbcbcccccccccccdcdcedeeeefeffffffffffffffffffofffooo8o888888888888989999a9aaaabsrscccccdddddddddddcdcuueeedeeddddddddedvo
bcbbobbbbbbcccccccccdddddcddeeeefeffffffff8o8o8offffffffffoooo8o8888888889899a9aaaaaababbsscddddbdcddddddddcdtttedededdedeeeeeev
ccccbcccccccccccccccccdcdcedeeeefefffff8f8f8f8f8ffffffffffffooooo888888989999o9a9aaaabbabsrccdbddddddddddddddctttddddeddddddedee
cbcbbbbccccccccccccdddddddedeeeeffffffff8f8f8f8f8fffffffffffooooo888888999999aaaaaaaababbbcstdtdbdoddddddddddddcuteeeedeeeeeeeee
bcbcocscscscccccccccdcddedeeeefefffffff88888888888f8ffffffffffffoooo888989999o99aaabbbbbbcrcstddddddddddddddddccctttdeddddeeeeee
scscsbsscscscsssscsdddddedeeeefeffffff8f8888888888888ffffffffffffoooop9999999aaa9a9bababbccccstcddddddddddddddddddueeeeeeeeeeeef
csbsossssssssssssstttdttutueeeeefffff8888888888888f8888fffffffffffffoppp9999a9999aabbbbbcccccctttdddddddddddddddcdcuuueeeeeeeefe
sssssbsbobobbssssststttdudueuevevfff8f8f888888888888888fffffffffffff8ppppp9aaaaa9aababaccccccbcsttddddddddddddddddduueeeeeeeefef
bbbbbbbbbsbsbbbbbbccsttttutuuuevvvvf888888888888888888888fffffffffff8888ppq8a9aababbbbbccccccccctttttdddddddddddddddduuueeeeeefe
bsbsbbbbrbrbbbbbbbcsctccdddudvvvvvvvofo8o88888888888888888fffffff8f8f8f88pppq9a99aaaacbccccccbcsctttttdddddddddddddddduueeeeefff
bbbbbbbbobbbbbbbbcbccccccdtdueuvvvvvovo8oooo8888888888888888of8f8f8f8f8f8oq8qpqababbbbcccccccccccccttdtddedddddddddddduuuueeeeee
cbbbbbbbsbsbrbbbccccccccddddeeeeeefffvoooooooo888o8o88888888fff8f8f88888888ppppr9bbbccccccbccbccccctctttddddododeddddddduuueffff
cccbbbbbabbbbbcccccccccocddddedeeefvfvfovooooo8o8o8888888888o8888f8f888888999qqqrabbbbcbccccccccdodccttetedddddddddddddduuueefff
cbcbbbbbbbbbbbcbccccccddddddeeeeeeefvffffofoooo8oooo888888888888888888888888999rrrrbccccccbccbdcdcdcddcutttdedededddddddduuvvfff
cccccbbbbbbbcbccccccccccccddeeeeeefefvfvvfofofoooo8o8o888888o88888888888889998aqrqrrababbcbcccdcdodcdddututddddddddddddddduuufof
cbcbcbbbbbbbccccccccccddddddeedeofefeffffffffffooooooooo888888888888888888889a9aaasssscccccddbdcdcdcdddddtttedeeedddddddddevvvff
bccccccbcbbbcbcccccccdccccddeeeefefeffffofo8f8fffoooooooooo88888888888889999989999brsrsrccocbcdcdodddddddutttdddddddddedddduuvof
cccccbcbcbcbcbccccccccdddcededdeoeeeefffff88888ofoofoooo8o8o88888888888888989a9aaabbsssssdbcdddddcdcdddddcttttededdededdeedeuvvv
cccccccccccccccccccccdccccdeeeeefffefffff8f8f8f88fffffooooooo8o8888888889999999aaababrssttbdbdbdcdddddddddddtttdddddededeeeevevo
cccccccbcbcccccccccdcddddoecedddoeeeefff8f888f8f8fffffofooooooo8o888888888989aaaababbbssstttdddddcdodddddddctttttdeddddedeeeeeeo
cccccccccccccbbcbcbdcddcdcdeeeeefffefffff8f888888f8f8ffffffooooooo8889899999999aaabbbbbbctrtbdcdcddddddddddddttttdddedeeeeeeeeef
bccccccccccccccccccdcdcddecededeofofof8f888f88888888o8ofofoffoooooo88898899999aaabobbbbbbsttttdddcdodddddddddddttttdddeeeeeeeeee
cccccccccccccccccccdcddoddeeeefefffffff888f88888888888ffffffffooooopop8999999aaaabbbbbccccrtrtcdddddddddddddddduuuueeeeeeeeeefef
csssssssscccccccctcddtdddeoeoeofoffff888888888888888f88foffffffooopop89899f999aaaaabbbbbccctttttddddddddddddddddduuuueeeeeeeefee
ssssssssssssssssctctdtdoddedeeffffffff8o8fff8f8888888888fffffffff8ppoppp99f99aaaabbbbbbcccbcrttttdddddddddddddddduuufeeeeeeeefff
csssssssssssssssststtttuoududfefefff88888888888888888888888fffff8f8ppopppfa999aaabbbbbbbccccctttttddddddddddddddddduuuueeeeeefee
ssssssssssssssstststtttttduuuvvvvffffffoff8f8888888888888888ffff8888oppppfqqaaaabbbbbcbcccbcoscttttdddddddddddddddduuuoeeeeeefff
ttsbsbsbssssssscsttttttuuuuuevevvvvoo8888888888888888888888888f888888ppppfq99aaaabbbbbbcccccccctttttdoedededddeddddduuuueeeeeeee
csbsbsrssssssbscscttstttttuuvvvvvvvvooo8888f888888888888888888888888888pfpqqqaabbbbbbcccccbcocdduuutttdddddddddddddduuoueeeeffff
ccccbbbbbssssbsccccccccduuuuvvvvvooooooooo88888888888888888888888888888pfpqppqqaabbbbcbccccccdcdduuuuutdeeedededdddddduuuufeeeef
cscbcbobsbsbscscocsccccdudueuvvvvovooooooooooo88888888888888888888888888fpqqqqqrbbbcccccccbdbddddduuuuueddddddddddddddouvueeeeff
cbcbcbbcbbbcbcbccccccddddddeeeevefoooooooooo8o8888888888888888888888888f88qpqqrrrrbbabcccccdcdddddduuuuuueedededededdduuuuvueeef
ccbcbbbbbbbcbcbcbcbccccddddedeeeefvooooooooopooooo888888888888888888888f9899qqrrrrrbcbacbcbdcdcddddduuuuudedededddddddeuvuuvefff
cccbcbccccccccbccccccdddddddeeeeefffffffoooopopoooo88888888888888888888f889p99rrrrrraacccdcdddddddddduuuuuedededddddddddvuvuuvef
cccccbcbcboccccccccdcddddddedeoeuevfffff8opppppppoooo8o888888888888888f8989999aqrrrrrbacbdbdcdcddddddduuuueeodddddddddedevuvvvff
cccccbccccccccbccccdcdddddedeeeeefoffff8888pppppppooooo888888888888888f898989aaarrrsaaabcdcdddddddddddduuuuueeededdddddeevvvvvff
cccccccbcboccccccccccdddddeeeeefeeeefffofof88ppppppoooooo8888888888888f89999aaaarrrrrsadbdbdcddododcdddduuuuueedddddddeeeevvvvvf
ccccccccccccccbccccdcdcdddddeeefeffff8888888888pppppppoooo88888888888f989999aaaaaarsqststdddddddddddddddduuuuueeededdeeeeeevvvv8
cccccccbcbocccccccdddddddeeeeeffffff8ffff88888888ppppooooooo888888899f989999aaaaaasrssrtrdbdcddcdddddddddduuuuueeeeeeeeeeeevvvvv
cccccccbcccccccccdcddddddddeeeefefff8888888888888p8pppppooooooo888889f9899899a9aababqstttttdddddddddddddduuuuuuueeeeeeeeeeeeevvo
ccccccccccccccccccdcdcddeeeeeeffffff8ff88888o8888888pppppooo8o888889f8989999aaaaaabarsrtstodbdddddddddddddduuuuuueeeeeeeeeeeevvv
cccbcbcbccccccccccccdddddeeeefefeff88888888888888888ppppopooooooo898f999998aaaaaaabbqctttttstcdddddddddddddduuuuuefeeeeeeeeeevoo
occcccccccccccccddddddddeeeeefffff888f88888888888888888opppppoopop89f9999aaaaaaaaabaabrtstotbddddddddddddddduuuuvufeeeeeeeeeeeev
dccccccccccccccdcdddddddeeeeefeffofofofo8ofo8o8888888888oppppppopopf9999898aaaaaaabboccctttstctddddddddddededduuuuueeeeeeeeeeefo
occcccccccccccdddddddddddedeefffff8888f8f8f888888888888p8o8oppppppppp9999a9aaaabbbbbacbbssotstttddedededdddddduuuuuueeeeeeeeeeff
ttttssssssccsostttdddeddeeeefffffo8o8o8o8ofo8o8888888888888p8ppppppfpopoa9aaaaaabbbb9cacctttuuuudeeeeeeeeededdduuuuueeeeeeeefeff
oscssssssssssttttttttteedeeeeffffff8f8f88888888888888888888p88ppppfppppa9a9a9obbbbbbccobosotstttteeeeeeeeddddddduuuuuueeeefeefff
tttttstssssssotttttttuuduueffffffo8o8o8o8ofo88888888888888o8888pppfpppppq9a9aabababbbbcbccdtuuuuuueeeeeeeeeedddduuuuufeeeeefffef
ctsttsssststotsttttttuuutuuufvfff8f88888888888888888888888888888ppfppppq9qaaaobbbbccccobocotsututuueeeeeededdddduuuuuueeeeeeffff
tttttttttttstctttttttuutuuuuvvvvoe8o8o8o8f88888888888888888888888fppppqpqpq9aababbbbbbcbcccccutuuuuueeeeeeeeeddddduuuvueeeefffff
ststststststotsttttutuuuuuuvvuvvvo8888888888888888888888888888888fpppqqqpqqob9bbbbccccbabbbdsututuuuueeeeeeedededeuuuuuuefefffff
ttttttttststttttttttututuuuvvvvvofoooo8o9f98989899888888888888888f8pppqpqpqprababbbbcbcbdcdcddcuuuuuueeeeeeeededddduuvvuefffffff
ttttstststatotsttttuuuuuuuvvvuvooooooooo898999999999888888888888fp88pppppqqqrqbabacbcbbbcccddddutuuuuueeeeeeeedededduuuvuvffffff
ttttttttttttttttttttuuutuuuvvvvovoooopoo88pc9898999998888888888888889pqpqpqqrqrababbcbdcdddddddsuuuuuueeeeeeeeeeeoeovovvvvffffff
tcccccccstacoctttttuuuuuuvvvvvvoooooooopoppp999999999988888888888888989qqqrqrqrqcbbbacbdcdcddddduuuuuuuueeeeeeeeeeeevvvvvvfffff8
cccccccccccctccccctuuuuuuuvvvvvoooooopoopop8p9p999999998888888888898999pqqqqrqrqr9bcccddddddddddduuuuuuueeeeeeeeeoeeevvvvvvfffff
ccccccccccacsccccdddddduuevvvoooooooopopppppppp999999999988988888888999qqqqqqqrqrbbbbcbdcddddddddduuououeeeeeeeeeeeeeevvvvvvfff8
ccccccccccccccccccddddddeeevfovoooopoppopoppppppp999999999898888989999989pqororprarcccdddddddddddduuuuuuuueeefeeeeeeeevvvvvvffff
cdccccccccccccccdcdcddddoeuevfvovovoovoppppppppppp9999999o9989989f98999999qrqrrrrrrsbdbdcdddddddddduouououueeeeeeeeeecvvvvvvvff8
cdccccccccccccccddddddeeeeeeffvfooopoppoppppoppppppp999999999998988898989oaororqrqsssccdddcdddddddduuuuuuufefeeeeeeeeeevvvvvv888
ddddccccccccccdddcdcddddoedeefefvovooopcpopopoppppppp9999999999f999999999a9rqrqsrssssdddddcddddededeuuovuuuveeeeeeeeeceevvovvvf8
cdcdcccocccccdcdddddddeeeeeffffff8oo8ppppppppppppppppppp99999999999999999999qrrrrssssscdddcdddeeeeeeeuvuovouoeeeeeeeeeeevvvvvoo8
dcdcdcdcdcccdcdddcdcddeeoeeffffff888o8cpoppppppppppppppp999999f9999999999a9a9srsrssssttddddddececededvvvvvuvuvefefefecefoooovov8
ddcdcdcccccadddddddddeeeeefffffff8f88888pppppppppppppppppp99999999999999a9a9qarrrssssttdddddedeeeeeeeeeuvvovovfefeeeeeeeevooooo8
dcdcdcdcdddddddddcddeeeeeefffffff88888888pppppppppppppppppp99999999999999a9a9basrsstttttdddedededededeevvvvvvvefefefeeeffoooooop
dddddddcdcdadddddddddeeeeeeffffff8f8f8888899qqpqpppppppppppp9999999999a9aaaa9b9brsrtststodeeedeeeeeeeeeevvovvvufeeeeefeeevoooooo
dcdcddddddddddddddddeeeeeefffff8888888888989qpqqqpppppppppppp9999999o9oa9a9a9babrssttttttetededededeeeevvvvvvvuvefefefooofooooop
dddddddcdcdadddddddddeeedeeffff8f8f88888999999qqqqpppppppppppp99999999aaaaaa9babssstststsueeedeeeeeeeeeeevovvuvueeeeeeeeefoooooo
ddddddddddddddddddddeeeefefffff888888889899999qqqqqqppppppppppp9999999aaaaaa9aabasrtsttttuttdddddeeeeeeeevvvvvuvefeeefooofooooop
dddddddcdddddddddddddeeedfefeff8f8c8f8989999999qqpqopppppppppopo9999a9aaaaaa9babbbstststsuuueeeeeeeeeeeeeeovvvvvveeeeeeffffooopo
ddddddddddddddddddddeeeefffffff8888888899989898oqqqqqqqpbpppppppp999aaaaaaaaaaababbtstsusustdededeeeeeeeevvvvvvvvvffffffffffopop
dddddddcdcdcaddddddedeeeefefe8f8f8f888889898989p9qqqqqppppppppppp9999aaaaaababbbbcbcttstsuutudeeeeeeeeeeoeovvvvvvvffffffffffoooo
dddddddddddddddddddeeeeefefe8f888888898999999999999qqqqqqpppppppp9qaaaaaaaaab9aaaabcstsusuutuueeeeeeeeeeeeevvvvvvvef8ffffffffoop
ddddddddddddddddddeddeeeeffff8f8f8888f8o999999999999qqqqqqppppppp9pqaaaaaaabbbbbbbccttsttuuuuuueeeeeeeeeeeevvvvvvvvfffff8foffopo
ddddddddddddddddddddeeefeffff888888889999999999999999qbqqqqqqqqqq9qqqaaaaabbbbbbbcbcbususuuuuuueeeeeeeeeeeeevvvvvvvv8ffffffffoop
dddddtdtdtbddddddddeeeefffffffff8888899999999999999999qqqqqqqqpqp9qqqqaaababbbbcbbcccctttuuuuuueeeeeeeeeefffovovvvvvfffffffff8po
dddtdtdttbdtdtdededeeeefffff88888899999999999999999999bqqqqqqqqqq9qqqqqaaabbbbbbbcbc8cststuuuuvvffeffffefeeeevvvvvovoffffffff8op
totdttttdtdtdtdddeoeeeeefeffffff888989999999999999999999qqqqqqqqq9qqqpqqabbbbbbccbcccccutuuuuuuuuffffffeefeevvvvvvvovfffffffff8o
uututtttbttttutuduuuuufffff88888899999989o999999999999999qqqqqqqq9qqqqqqaabbbbbcccccdcdctuuuvvvvvffffffffffeefvvvvvvvffffff8f88p
tutututubutututttuduuvvvvffff8f88889899999999999999999999qqqqqqqq9qqqoqqqaaaabbccccccdcduuuuvvvvvvffffeeeeeeevvvvvvvvfffffff888f
uuuuuutttututututuuuvuvvvvv8888899999999999999999999999999qqqqqqq9qqqqqqrrbbbbbccccdddddcuvuvuvvvvffffffffffffvvvvvvvvfff888fff8
uututtbututuuuutuuuuuvvvvvvvfo8888999999a9aaaaaa99999999999qqqqqq8qqqoqqrqbacbccacbdcdcdduvvvvvvvvfffffffffeeevvvvvvvvvff8f88888
uuuuuubututututuuuuuvvvvvvvooooo99999989999oa9aaa9999999999qqqqqq8qqqqqqqqrbbbbbccddddddduvuvuvvvvvfffffeffefeevovvvvvvfff8fff88
uuuuubuuuuuuuuuouuuvvvvvvooovooo889899a9a9oaoaaaa99999999999qqqoq8qoqoqqrrrbcbccacbdcdcdddvvvvvvvvvvfffffffffeevovovvvov88888889
tututuuuuuuuuuuuutuuvvvvvovooooppp99998a9a9a9aaaaaaa999999999qqq8qqqqqqqqqrrbbbocddddddeddvuvvvvvvvvfffffffffffvovvvvvvvff888888
ououuuuuuuutuuutuuuvuvuvvovovoooopp899a9aa9a9aaaaaaaa99999999qqqqqqqqrqrrrrrcbccbccdddddeevvvvvvvvvvfffffffffffvovoooooo88888889
uuuubuuuuuuuuuuuuuvuvvvvoooooooopopp998a9a9aaaaa9abaaaa9a99999qq8qqqqqqrrqrrrbbocdcddddeedeuvvvvvvvvvfffffffdffofoooooooo8888889
uuuuuuuuuuuuuuuuuuuuuvvvvovovopopopoq9a9aa9a9aaaaaaaaaa9999999qqqqqrqrqrrrsrsccocacbdbdeecevvvvvvvvvvvfffoffdffffooooooo88888899
duuuuuuuuuuuuuuouuvvvvvvooooooppopoppp9q9aaaaaaaaabaaaaaaaa9999q8qqqqrqrrrrrrrbcccdododeededvvvvvvvvvvfffffffffffoooooooo88888o9
uuuuuuuuuuuuuuuuuuvuvvvooooooppoppppqppp9aaaaaaaaaaaaaaaaa99999q8rqrqrrrorqrrsbbcbcbdbdcececvvvvvvvvvvfffffffffffooooooooo889899
uuuuuuuuuuuuuuuuvvvvvvoooooooppppppqpqqqqa9aaaaaaaaaaaaaaaa9a998qrqrrrrrrrrrrsrcccccdededeeevvvvvvvvvvvfffff8f8f8opooooooo888989
uuuuuuuuuuuuuuuuuuvvvvvooooooppoppppqpppqqaaaaaaaaaaaaaaaaaaa9a8qrqrrrrrrqrqrrrdcdcddeececeevvvvvvvvvvffffffffffffoooooooo889899
uuuuuuuuuuuuuuvvvvvvvvvooooopppppppqqqqqqqqaaaaabaaaaaaaaaaaaaa8arrrrrrrrsrsrssdcddddedeeeeevvovooovvvofffff8f8ffooooooooo898989
vvuuouuuuuuuuouuvvvvvvvooooooppoppqqqqpqpqqqaaaaadaaaaaaaaaaaaa8arrrrrrrrrrrrrrtsdcdcecdedeeovovovovvovoffffffffffoooooooo888898
uuuuuuuuuuuuuvuvvvvvvvvoooopopoppppqqqqqqqqqqaaaaaaaadadaaaaaaa8arrrrrrrssssstttrddedeeeeeeffoooooooooofdf8f88ffffoooooooo899989
uuuuouuvvvvvvvvovovovvovooooooppppqqqqoqoqeqqqaaaaaaaaaaaaaaaaa8aarrrrrrrrrrsrstsdbececdedeefvoooooooooof8f8ffffffoooopoppp99988
uuuuuuuuuuuuvuuvuvvvvovoooooopooppqqqqqqqqrqrqqaaaaaaaaaaaaaaa8aaaarrrrrsssssttttddedeeeeeefeoooooooooooof8f888f8ffooooooop9998a
vvuvuvuvvvvvvvvuvvvvvvovoopopoppqpqqqqoqqrrqrrbaaaaaaaaaaaaaaa8aaaarrrrrrrsrsrstsdseeeedeeeefeooooooooooo8f8ffffffoooppoppp99999
uuuuvuvuvvvvvvvvvvvvvvooooooppopoppqqpqqrqrrrrqraaaaaaaaaaaaaa8aaaarrrrrssssttttttdedeeeefeffebobooooooo8o8888888f8oooooopp9898a
vvvvvvvvvvvvvvvvvvvvvvoooopopoppqpqqqqqrrrrrrrrrbaaaaaaaaaaaaa8aaaaarrrsrsssstsrtrtbededeefefffovooo9ooooo888f8ffffoopppppppo999
vvvuvuvvvvvvvvvvvvvvooooooooopopoppqqqqrqrrrrrqrrbabaaaaaaaaaa8aaaarrrrrsssstststotededfefefefeovoooooooooo888888f8ooooopppp9999
vvvvvvvvvvvvvvvvvvovovoopppppppqpqpqqqqqrrrrrrrrrrbbabaaaaaaaa8aaaaarrssssssstsrtrtsedededfefffooooooooooo8888888f8oppppppppo9oa
vvvvvvvvvvvvvvvvvvovooooooopoppqpqqqqqqrrrrrrrrrrrbbbbaaaaaaa8aaaaaarsssrsrtsststotttededfefefeoooooooooooo888888888ppppppppp99a
vvvvvvvvvvvvvvvvvoovovoopppppqpqpqpqqrqrrrrrrrrrrrbbbbbbabaaa8eaaaaaassssssssttrtrtsededfefeffooooooooooooo88888888pppppppppo9oa
vvvvvvvvvvvvvvvvvvooooooppppppqqqqqrqrqrrrrrrqrrrrrbbbbbbaaaa8aaaaaassssssstttsssouteeeeffefefeooooooooooooo88888888ppppppppp99a
vvvvvvvvvvvvvvvvvoovovoppppppqpqpqqrqrrrrrrrrrorrrrrbbbbbbaafeaaaaaaassssstttttsustsedeefffffffoooooooooooo88888889pppppppppp999
vvvvvvvvvvvvvvvvovooooooppppqpqqqpqrrrqrrrrrrrrrrrrroboboboafaaababbsssssstttttotouueefeffefefeooooooooooooo88888888ppppppppp99a
vovvvvvvvvvvvvvovooooopppppppqqqqqqrqrrrrrrrrrrrrrrrbbbbbbbfbbbbbbbbbssrsrtststsutusuteffffffffoooooooooooo88888888pppppppppp9aa
vovvvvvvvvvvvvvooooooopoppppqqqqqqqrrrqrrrrrrrrrrrrrobobobfbbbbbbbbbbsssttttttttttuuuufeffefefeffoppopooooop8989898oppppppppppa9
oovovvvvvvvvvvvvvoooooooppppqqqqqqrrqrrrrrrrrrrrrrrrrrbbbbcbbbbbbbbbbbsrssttttutuuuuueefffffff8foopopoopoppop888888ppppqppppqaaa
oovovvovvvovovvovooooopoppppqpqqqrrrrrqrrrrrrrroororobobobocobbbbbbbbbsststotstttuuuvufeffefefe8opopppppooop888888888pppqppppp9a
oovovovovovvvovooooooooppppqqqqqqrrporrrrrrrrrrrrrrrrrbbbbbcbbbbbbbbosssttttttuuuuuuuffffffffff8oppppppooop8p888888ppppoppqqqaaa
ooooooovovoooovovooopppoppqpqqqqqrrrrrrrrrrrrsrrrrrrrrrbbbecobbbbbbbbstststststttuuuuufefffffff8fpopopppppop889888888pppqqqqqaa9
fovovovoooovoooooooooopppppqqqqqrrrqcrrrsssssrrrrrrrrrbbbbbbcbbbbbbbbsssttttttuuuuuuuvfffffff8f8ppppppppppf8o898888ppppqqpqqqqaa
ooooooovovooooooooooppppppqppqqqqrqrqrrrrsrsssssrrrrrrrbbbbbcbbbbbbbbsbssssssttuuuuuvvfffffff8f8fpopopppppop88888898pppqqqqqqaaq
oooooovvovovooooooopoopppppqqqqrrrrrorrsrsrsssssssrrrrrbbbbbcbbbbbbbbbtstttttuuuuuuvvvffd8f8f888ppppppppppp998898888pppqqqqqqqaa
oooooovvvvvvovooooooppppppqqqqqqqrrrrrssssrsssssssssrrrbebbbbcbbbbbbcsbssssssttutuuuvuffff8ff8f8fppppppppppp89898898ppqqqqqqqaaq
ooooooovooooooooooopopppppqqqqrrrrrrrsrsrssssssssssssrrbbbbbbcbbbbbbbbttttttuuuuuuuuvuff8888o8o8opppppppppppp9999999pqqqqqqqqqaa
oooooovvvvvvovooooopppppqpqqqqqqrrrqrrsrsssssssssssssssbebbbbbbbbbbbctsbtstttuuuuuuvvufvff8888f88ppppppppppp99999998qqqqqqqqqbba
ooooofoooooooooooopoppppppqpqqrqrrrrrsrsrsssssssssssssrbbbbbbbcbbbbbcbottttuuuuuuuvuvvff8888888p8ppppppppppppf999999qqqqqqqqqqqa
oooovofooooooooooopppppppqqqqqqrrrrrsrsssssssssssssssssssbbbbbbbbbcbcctbtsttuuuuuuuvvvvvf8888888pppppppppppp9999999qqqqqqqqqqqqa
oooooooooooooooooopoppppppqpqqrqrrrrssrssssssssssssssssccbbcbbbcbbcbcctttttuuuuuuvvvvv8f8888888p8ppppppppppppp999999qqqqqqqqqrqb

