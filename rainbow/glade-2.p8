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
	
	for i=1,45 do
		ox,oy=get_oxy()
		for y=oy,oy+bk-1,1 do
			for x=ox,ox+bk-1,1 do
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
bbbbbbbbbbbbbbbbbbccccccdddddddeeeeevoooooo888888888888888888fffffff88888888qqqaabbbaaaaabbbbbccccccctddddoodddddddddddduueeeeff
cbbbbbbbbbbbbbbbbbcccccddddddeeeeeeeeffffoooo8888888888888888fff88888888889999qqqbbbbbbcccbbbbcccccdcctueeeeddddddddddddddueeeff
cccbbbbbbbbbbbbbbbcccccdddddeeeedeeeffffffffooooo8888888888888888888888889999999qrrbbbbcccbbbbcccddddduuueeedddddddddddddduuefff
ccccbbbbbbbbbbbbbccccccdddddeeeedeeefffffffffooooooo8888888888888888888889999999aarrrbbccccbbcccccccdddduuudddddddddddddddduufff
cbbbbbbbbbbbbbbbbbccccdddddeeeeedeeffffffffffffffooooo88888888888888888889999999aaaarssccccbbccccdddddddddutddddddddddddddddvvvf
ccbbbbbbbbbbbbbbbbbcccdddddeeeeedeefffffffffffffffffoooo8888888888888888999999a9aaaaassscccbbccccddddddddddtttddddddddddddddevvf
ccccbbbbbbbccccccccccddddddeeeeedeeeeeeeffffffffffffffoooooo888888888888999999a9aaaaabbssscbbccddddddddddddctttddddddddddddeeevv
cccccbbbbccccccccccccdddddeeeeeedeefffffffffffffffffffffffoooo888888888999999aaaaaaabbbbsssbccdddddddddddcccccttdddddddddddeeeev
cccccccbbccccccccccccdddddeeeeeeeefffffff88888888fffffffffffoooo8888888999999aaaaaaabbbbbbsoocddddddddddddcccccttddddddddddeeeef
cccccccbbcccccccccccddddddeeeeeeefffffff8888888888fffffffffffooooo88888999999aaaaaaabbbbbbsoocddddddddddddddccccttdddddddeeeeeef
cccccccbbcccccccccccddddddddeeeeeffffff888888888888ffffffffffffoooo888899999aaaaaaabbbbbbbbssstddddddddddddddccccttddddddeeeeeef
cccccccbbssssssscscdddddddddeeeeffffff888888888888888fffffffffffooooo8899999aaaaaaabbbbbbcossstttddddddddddddddccctteeeeeeeeeeff
ccbcbssssssssssssssttttttddeeeeeffffff88888f8888888888fffffffffffffffpppp999999aaaabbbbbooobbsctttddddddddddddddddduuueeeeeeeeff
ssccbsssssssssssssttttttuuuuuvfffffff888888f88888888888fffffffffffff888pp9999999aabbbbbbcccccccctttddddddddddddddddduuueeeeeefff
bbbbbbbbbssssssssbttttttuuuuuvvvvvvf88888888888888888888fffffffffff88888pp999999aabbbbbbcccccccctttdcdddddddddddddddduuueeeeefff
bbbbbbbbbbbbbbbbbbccccccdduuuvvvvvvvooo8888888888888888888ffffffff8888888ppp99a9aabbbbbbccccccccctttoooddddddddddddddduuueeeefff
bbbbbbbbbbbbbbbbbbccccccddddeeevvvvvoooooo88888888888888888ffffff888888888ppppp99aaaaaabccccccccccttttddddddddddddddddduuueeeeee
bcbbbbbbbbbbbbbbbccccccdddddeeeeeeevooooooo88888888888888888888ff88888888888ppqpaaaaaaabccccccccccccttttdddddddddddddddduuueeeee
ccccbbbbbbbbbbbccccccccdddddeeeeeeefffffoooooo8888888888888888888888888888898pqpqaaaaaabcccccccccccddutttdddddddddddddddduuuefff
cccccbbbbbbbbccccccccccddddeeeeeeeeffffffffoooooo888888888888888888888888899999qqqqaaaabccccccddccdddduutttddddddddddddddduuvfff
cccccccbbbbbccccccccccdddddeeeeeeefffffffffoooooooo8888888888888888888888899999qqqqqaaabcccccdddccddddduttttddddddddddddddduvvff
ccccccccccccccccccccccddddddeeeeeeffffffffffoooooooooooo8888888888888888889999999qqqqaabbbccccccccdddddduttttddddddddddddddvvvvf
ccbcbbcccccccccccccccddddddeeeeeeffffffffffffoffooooooo88888888888888888899999999aarrrsccabbcccccdddddddddutttddddddddddddeevvvf
ccccccbbbbbbcccccccccdcdddddeeeeefffffffff8ffoffffoooooooooo88888888888889999999aaaarrsssabbccccdddddddddddutttdddddddddddeeevvv
cccccccccccbccccccccddcdddddeeeeeeffffff888fffffffffffooooooooo88888888899999999aaaaassssscdddcddddddddddddduuttddddddddeeeeeevv
cccccccccccbcccccccddddddddeeeeeeefffff8888fff8888ffffffooooooooo888888999999999aaaaabbsssstddcdddddddddddddduuttdddddddeeeeeeev
cccccccccccbcccccccddddddddeeeeeeffffffffff88ff8888fffffffoooooooo8888899999999aaaaaabbbsstttddddddddddddddddduuttddeeeeeeeeeeev
cccccccccbbbccccccdddddddddeeeeefffffffffffff8888fff8fffffffoooooooo88888888999aaaaabbbbbsttttdddddddddddddddduuuueeeeeeeeeeeeee
ccccccccccccccccccddddddeddeeeeffffff888888f88888fff88ffffffffoooooop888888899aaaaaabbbbbctttttddddddddddddddddduuuueeeeeeeeeeee
ccccccccccccssssstttttddeeeeeeeffffff888888888888888888ffffffffooooppo89999aaaaaaaaabbbbbccttttdddddddddddddddddduuuueeeeeeeeeee
ccccccccccccsssssttttttteeeeeeefffff88888888888888888888ffffffffffpppo8p999aaaaaaaabbbbbcccctttttodddddddddddddddduuueffeeeeeeee
sssssssssssssssstttttttuuuuueeffffff888888888888888888888ffffffff88pppppp99aaaaaaaaabbbbcccccctttotdddddddddddddddduuuffeeeeeeee
sssssssssssssssstttttttuuuuuuufffff88888888o888888888888888ffff888888pppppqaaaabbbbbbbbccccccctttottddddddddddddddduuuffeeeeeeee
sssssssssssssssstttttttuuuuuuvvvvvoo8o88888o88888888888888888888888888ppppqqaaabbbbbbbcccccccccttotttdeeeedddddddddduvffeeeeeeef
ssssssssssssbbbcccttttuuuuuuuvvvvvooooooo88f8888888888888888888888888888pqqqqaabbbbbbbcccccccccctottuueeeeeedddddddddvuueeeeeeef
ssssssbbbbbbbcccscccccddduuuvvvvvoooooooooo88888888888888888888888888888pqqqqqrbbbbbbbcccccccccccttuuuueeeeeeddddddddovuueeeeeef
ssccccbbbbbbccccocccccddddddvvvvvooooffoooo888888888888888888888888888889qqqqqrrrbbcbcccccccccoccctuuuuueeeeeeeeeeeeeovvvueeeeef
ssccccccccccccccoccccccdddddeeeevooooffoooo8o88888888888888888888888888899qqqrrrrrbcbcccccccccccddduuuuudddddddeoooooovvvvueffff
bbccccccccccccccoccccccdddddeeeefffoovvoooo8oooo8888888888888888888888889999qrrrrrrcccccccccccdddddduuuuuddddddoeeeeddduuuuuffff
ooccccccccccccccoccccccddcddeeeefffffoooooooooooooo88888888888888888888999999rrrrrssscccccccccddddddduuuuuddddddddeedddduuuuvfff
ooccccccccccccccocccddddddedeeeffffffffffooooooooooo8o8888888888888888999999aaarrrssabcccccccdddddddduuuuuudddddddeedddddvvvvvff
bbccccccccccccccoccddddddeeddddeffffffff888ppooooooo8ooo88888888888888999999aaaarrssqrcccccccdddddddddduuuuuedddddeeedddeevvvvv8
ccccccccccccccccoccddddddeeddddefffffff888888ooopppp8ooooo888888888889999999aaaaasssqrscccccddddddddddduuuuuueddddeeeeedeevvvvv8
ccccccccccbbbbcccccddddddeedddeeffffff8888888opppppppooooooo888888888999999988p9qqqqrrssccccdddddddddddduuuuueeeedeeeeeeeeevvvvo
cccbbbbbbbbbcccccccdddddeeedddeefffff88888888888ppppppooooooo888888899999999a99aaaarrrsssscdddddddddddddduuuuueeeeeeeeeeeeeevvoo
cccccccccccccccccccdddddeeeddeeffffff8888888888888ppppppoooooo8888889999999aa9aaaaaarrsssssdddddddddddddddduuuuueeeeeeeeeeeevvoo
ccccccccccccccccccddddddeeedddefffff888888888888888ppppppoooooo888899999999aa9aaaaaarrttttttddddddddddddddduuuuuueeeeeeeeeeeevoo
ccccccccccccccccccdddddeeeededefffff8888888888888888888pppoooooo8889999999aaa9aaaaabrbtttttttddddddddddddddooouvffeeeeeeeeeeeeoo
cccccccccccccccccddddddeeeededeffff888888888888888888888ppppooooo889999999aaaaaaaaababctttttttdddddddddddddooouvvfeeeeeeeeeeeeev
cccccccccccccccccddddddeeeeeeeeffff88888888888888888888888pppppooppp999999aaaaaaaaababcctttttttddddddddddddddoovvvfeeeeeeeeeeeee
ccccccccccccccccddddddeeeeeeeeffff8888888888888888888888888ppppppppppp999aaaaaaaaabbbbcccttttttueeeeeedddddddduuuuuufeeeeeeeeeee
dcccssssssssccccddddddddeeeeefffff88888888888888888888888888ppppppppppp99aaaaaaaaabbbccccttttuuuueeeeeeeddddddduuuuuffeeeeeeffff
tttstsssssssssssttttttddeeeeeffff888888888888888888888888888ppppppppppppaaa9aaabbbbbbcccccttuuuuuueeeeeeedddddduuuuuffeeeeefffff
ttttttssssssssttttttttddeeeeefffoff888888888888888888888888888ppppppppppqaa9aaabbbbbbccccccuuuuuuuueeeeeeedddddduuuuvueeeeefffff
ttttttttttttsstttttttttduuuuffffbff88888888898888888888888888888ppppppppp999aabbbbbbccccccccuuuuuuueeeeeeeedddddduuuuuueeeffffff
ttttttttttttstttttttttttuuuuvvvvbf8888888899999888888888888888888ppppppppp99aabbbbbbccccccccduuuuuuueeeeeeeeddddduuuuuufefffffff
ttttttttttttttttttttttttuuuvvvvvbv88888888999999988888888888888888pppppppppaqabbbbbcccccccccdduuuuuueeeeeeeedddddduuuuuvffffffff
ttttttttsstttttttttttttuuuuvvvvvevooo888889999999998888888888888888ppp8cpppqqrbbbbbcccccccdcddduuuuuueeeeeeeedddddduuuuvvfffffff
ttttttttttttsstttttttttutttuuuuuuoooooo888999999999988888888888888888pqcppqqqrrbbbbcbccccccdddduuuuuuueeeeoeeeeeddduuuuvvfffffff
ttttttttttttttttttttuuuuuutuuuuuuoooooooo8p999999999988888888888888888qcppqqqrrrbbccccccccddddduuuuuuuueeeoeeeeeedduuvvvvfffffff
cccccccctttttttttttuuuuuuvuuuuvvvooooooooopp999999999998988888888888899cppqqrrrrbbcbcccccddddddduuuuuuueeeoeeeeeeeeevvvvvvvfffff
ccccccccccccttcccccdduuuuvuvvvooooooooooppppp99999999999988888888888999cppqqrrrrrbcccccccdddddddduuuuuuueeeeeooeeeeeevvvvvffffff
ccccccccccccccccccdddddddvvvvvoooooddooopppppppp999999999988888888889999cqqqrrrrrsccccddddddddddduuuuuuuueeeeeeeeeeeevvvvvvvffff
ccccccccccccccccccddddddeeeevooooooovoopppppppppp99999999999888888899999cqqrrrrrrsscccdddddddddddduuuuuuuueeeeeeeeeeeevvvvvvffff
ccccccccccccccccccddddddeeeeeoooooopppppppppppppppp99999999988888999999999rrrrrrrssscdddddddddddddduuuuuuueeeeeeeeeeeevvvvvvvfff
ccccccccccccccccccddddddeeeeeffffooppppppppppppppppp999999999889999999999aarqrrrrssssdddddddddddddduuuuuuuueeeeeefeeeeevvvvvvfff
dcccccccccccccccccdddddeeeeeffffff8ppppppppppppppppppp9999999999999999999aaaqrrrrsssttdddddddddeeeeduuvuuuuueeeeeeeeeeevvvvvvvff
ddcdcccccccccccccdddddeeeeeeffffff888ppppppppppppppppppp9999999999999999aaaaqrrrrssstttdddddddeeeeeeevvvuuuueeeeeeeeeeeevvvvvvff
dddddccccccccccdddddddeeeeeeffffff88888ppppppppppppppppp9999999999999999aaaaaarrrssstttddddddeeeeeeeevvvvvuuuffeeeeeefffevvvvvvf
dddddddccccccccddddddeeeeeeefffff888888pppppppppppppppppp99999999999999aaaaaaaarssstttttddddeeeeeeeeeevvvvvvvvffeeeeeffeevvvvvv8
dddddddddddccccddddddeeeeeeefffff88888888ppppppppppppppppp9999999999999aaaaaaaarsssssrsstddeeeeeeeeeeeevvvvvvvvffeeeefffevvvvvoo
ddddddddddddddddddddeeeeeeeeffff88888888888pqqpppppppppppppp9999999999aaaaaaaaaasssssrssttdddeeeeeeeeeevvvvvuueeeefeefffffvvvvvv
ddddddddddddddddddddeeeeeeeffffff88888888899qqqqppppppppppppp999899999999caaaaabbssssrssttdddeeeeeeeeeeevvvvvuueeeffeffffffooooo
ddddddddddddddddddddeeeeeeffffff8888888889999qqqqqqppppppppppp99899999999caaaaaaarsrrrrrsttddddeeeeedeeevvvvvvvueefffffffffooooo
dddddddddddddddddddeeeeeeefffff888888888999999qqqqqppppppppppppp999999999acaaaaaaasrrrrsstttdddeeeeeeeeeevvvvvvveeffffffffffoooo
ccbddddddddddddddddeeeeeeffffff888888888999999999qqqqqppppppppppp9999999aacaaaaaaasrrrttttttdeeeeeeeeeeeeevvvvvvvfffffffffffoooo
ccbdddddddddddddddedeeeeefffff88888888899999999999qqqqqpppppppppp9999999aacaaaaaabbrrrttttttdeeeeeeeeeeeeevvvvvvvffffffffffffooo
dddbdfcdddddddddddeeeeeeefffff888888888999999999999qqqqqpppppppppp99999aaacaaaaaabbrrrttttttueeeeeeeeeeeeevvvvvvvvfffffffffffooo
dddbcfcddddddddddeeeeeeeefffff8888888899999999999999qqqqqqpppppppppp99aaaa8aaaaabbbrrsttttttuueeeeeeeeeeeevvvvvvvvvfffffffffffoo
dddbdfcdddddddddddeeeeeeeffff888888888999999999999999qqqqppppppppppp99999o8aaaaabbbarstttttuuuueeeeeeeeeeeeevvvvovvfffffffffffoo
ddddfdddddddddddddeeeeeeeffff8888889999999999999999999qqqqqqqqqqqpqqaaaaao8aaaaaabbbcctttttuuuuueeeeeeeeeeeevvooovvvffffffffffoo
ddddfddddddddddddeeeeeeeeefff8888889999999999999999999qqqqqqqqqqqqqqqqaaao8aaaaabbbccctuuuuuuuuueeeeeeeeeeeeevvvvvvvfffffffffffo
uuutdddttttttddddeeeeeeeeeeff88888999999999999999999999qqqqqqqqqqqqqqqaaaa8aaaaabbbccccuuuuuuuuuufffffeeeeffevvvvvvvvffffffffffo
uuutttttttttttttuueeeeeeeeeff88888999999999999999999999qqqqqqqqqqqqqqqqaaa8aaaaabbbccccuuuuuuuuuuffffffeeefffovvvvvvfffffffffffp
uuuttttttttttttttueeeeeeeeef8888889999999999999999999999qqqqqqqqqqqqqqqaaa8aaaabbbcccccuuuuuuuuuvvfffffffeffffvvvvvvvfffffffff8p
uuuuuttttttttttuuuuuuuvfffff88888999999999999999999999999qqqqqqqqqqqqqqqaa8aoooabbccccduuuuuuuvvvvffffffffffefvvvvvvvfffffffff8p
uuuuuuutttttttuuuuuuuvvvvvf8888889999999999999999999999999qqqqqqqqqqqqqqqqbbbcccccccccdduuuuuvvvvvfffffffffffffvvvvvvvfffffff888
uuuuuuuuuuuuuuuuuuuuuvvvvvvoo8888999999999aaaaa99999999999qqqqqqqqqqqqqqqrbbbcccccccccdduuuuvvvvvvfffffffffeeevvvvvvvvffffff8888
uuuuuuuuuuuuuuuuuuuuuvvvvvvoooo8999999999aaaaa99999999999999qqqqqqqqqqqqqrbbccccccccccddduuuvvvvvvvfffffffffeevvvvvvvvff88888888
uuuuuuuuuuuuuuuuuuuuvvvvvvvooooo99999999aaaaaaaaaa99999999999qqqqqqqqqqqrrrbccccccccccdddduuvvvvvvvfffffffffffevvvvvvvvf88888889
uuuuuuuuuuuuuuuuuuuuvvvvvvvooooppp99999999aaaaaaaaa9999999999qqqqqqqqqqrrrrbcccccdccccdddduvvvvvvvvvvffffffffffvvvvvvvv888888889
u9uuuuutuuuuuuuuuuuvvvvvvvvoooopppp9999999aaaaaaaaaaa999999999qqqqqqqqrrrrrscccccdcccdddddvvvvvvvvvvvffffffffffoovovvvo888888899
uuuuuuuuuuuuuuuuuuuvvvvvvvooooooooop999999aaaaaaaaaaa9a9999999qqqqqqqqrrrrrssccccdcccddddevvvvvvvvvvvfffffffffffoooooooo88888899
uuuuuuuuuuuuuuuuuuvvvvvvvoooooopoooppp9999aaaaaaaaaaaaaa999999qqqqqqqrrrrrrsscccddcddddeeevvvvvvvvvvvvffffffffffoooooooo88888899
uuuuuuuuuuuuuuuuuvvvvvvvvoooooppooooppp99aaaaaaaaaaaaaaaa999999qqqqqrrrrrrrrsscccccdddeeeeevvvvvvvvvvfffffffffffoooooooo88888999
uuuuuuuuuutoooouuvvvvvvvooooooppooooppppqaaaaaaaaaaaaaaaaaa9999qqqqrrrrroqrerrrbcccdddeeeeevvvvvvvvvvvffffffffffooooooooo8888999
uuuuuuuuuutoooouvvvvvvvvooooooppooppppqqqaaaaaaaaaaaaaaaaaaaa999qqoooooooqrerrrbcccddeeeeeevvvvvvvvvvvffffffffffooooooooo8888899
vvuuuuuuuutoooovvvvvvvvvooooopppoopqqqqqqqaaaaaaaaaaaaaaaaaaaaaa9qoooooooqrerrrrcccddeeeeeeevvvvvvvvvvffffffffffffooooooo8888899
vvvuuuuuuuuoooovvvvvvvvvooooopppoopqqqqqqqqaaaaaaaaaaaaaaaaaaaaa9qqqqqqrrssssstdcccdeeeeeeeevvvvoooovvvf8ffffffff8oooooooo888899
vvvvuuuuuuuuuoovvvvvvvovooooopppppqqqqqqqqqqaaaaaaaaaaaaaaaaaaaaaarrrrrrsssssstdsccdeeeeeeeccuooooooooo88ffffffff8oooooooooo8899
vvvuuuuuuuuuvvvvvvvvvvovooooppppppqqqqqqqqqqqabaaaaaaaaaffaaaaaaarrrrrrrssssssttroodeeeeeeeeedooooooooo8offffffff8ooooooooooo999
vvvvvvuuuuuuvvvvvvvvuuuvvvoooooppqqqqqqqqqqqqaaaaaadaaaaaaffaaaaaarrrrrrssssstttrrccoddddddeedoooooooooo8fffffffffoooooooooo8888
vvvvvvuuuuvvvvvvvvvvvvvooopppppppqqqqqqqqqqqqqaaaaaaaaaaaaabaaaaaarrrrrrssssstttrsscodddddeeedoooooooooo88fffffffffoooooooo88998
vvvvvvuuuuvvvvvvvvvvvvvoooppppppqqqqqqqqqqrrrrqaaaaaaaaaaaaabaaaaaarrrrrsssssttttdddddddddeeedooooooooooo888fff8fffoooooooo89999
vvvvvvvvvvvvvvvvvvvvvvvoooppppppqqqqqqqqrrrqqqqaaaaaaaaaaaaabaaaaaarrrrrssssttttttddeddeeeeeedooooooooooo8888ff888fooopoooo89999
vvvvvvvvvvvvvvvvvvvvvvvooppppppqqqqqqqqqqqqqqrrrrbaaaaaaaaaaaaaaaaarrrrrssssttttttddedeeeeeeedevooooooooo88888fffffoooooooop9999
vvvvvvvvvvvvvvvvvvvoovvoopppppqqqqqqqqqqqqqqrrrrrrbbaaaaaaaaaaaaaaarrrrrrrssssttttddeeeeeeeeeeeeoooooooooo88888ffffooooooppp9999
vvvvvvvvvvvvvvvvvvvoooooppppppqqqqqqqqqqqqqrrrrrrrbbbaaaaaaaaaaaaaaarrsrrrssssttttteeeeeffffffefoooooooooo888888fffoooopppppp999
vvvvvvvvvvvvvvvvvvooooooppppppqqqqqqqrqqqqrrrrrrrrbbbbaaaaaaaaaaaaaarrrrrrssstttttteeeeefffffffovvoooooooo888888888oppppppppp99a
vvvvvvvvvvvvvvvvvvoooooopppppqqqqqqqqrqqqrrrrrrrrrbbbbbaaaaaaabaaaaaarrrrrssstttttteeeeffffffffoooooooooooo88888888ppppppppp9aaa
vvvvvvvvvvvvvvvvvoooooopppppppqqqqqqrrqqqrrrrrrrrrrbbbbbbaaaaaabaaaaarrrrrssstttttuueeeffffffffffooooooooooo8888888ppppppppp9aaa
vvvvvvvvvvvvvvvvooooooopppppppqqqqqqrrrrrrrrrrrrrrrbbbbbbbaaaaabaaaaaoorrrrssetttttueeeffffffffffooooooooooo88888888pppppppp9aaa
vvvvvvvvvvvvvvvvvvoooooppppoppppqqqrrrrrrrrrrrrrrrrbbbbbbbbbbaabaaaaaarsssssstttttuueefffffffffffooooooooopp88888888ppppppppaaaa
vvvvvvvvvvvvvvvovvooooppppppqpppqqqrrrrrrrrrrrrrrrrrbbbbbbbbbbaaaaaabbssssssttttttuuueffffffffffooooooooooo898888888ppppppppqaaa
vvvvvvvvvvvvvvoovvooooppppppqpppqqrrrrrrrrrrrrrrrrrrbbbbbbbbbbbbbbbbbssssststttsssuuufffffffffffopppooooooo898888888pppppppqqaaa
vvvvvvvvvvvvvooovvvooopppppqqpppqqrrrrrrrrrrrrrrrrrrrbbbbbbbbbbbbbbbbssssstttttsstuuuuefffffffffpppppoooooo8p8888888pppppppqqaaa
ovvvvvvvvvvvvvvvvvvooppppppqqpppqrrrrrrrrrrrrrrrrrrrrbbbbbbbbbbbbbbbbssssttttttsssuuuuefffoofff8pppppppooooo98888888ppppppqqqaaa
ovvvvvvvvvvvvvvvvvvooppppppqqpppqrrrrrrrrrrrrrrrrrrrrrbbbbbbbbbbbbbbbbssstttttttuuuuuuffffooff88ppppppppoooop8888888ppppppppppp9
ovvvvvvvvvvvvvvvvvvoopppppqqqpppqrrrrrrrrrrrrrrrrrrrrrrbbbbbbbbbbbbbbbsstttttttuuuuttttfff888888pppppppppooo88888888ppppppppppp9
ovvvvvvvvvvvvvvovvvoopppppqqqqqqqrrrrrrrrrrssssrrrrrrrrrbbbbbbbbbbbbbbsstttttttuuuuttooff88888888pppppppppoo99888888ppppppppppp9
ooovvvvvvvvvvvoovvoooppppqqqqqqqqrrrrrrrrrrrrrrrrrrrrrrrbbbbbbbbbbbbbbsttttttttuuuuttooff88888888ppppppppppo998889998pppppppppqq
ooooovvvvvvvvooovvvoooooppqqqqqrrrrorrrrrrssrrrrrrrrrrrrbbbbbbbbbbbbbbstttttttuuuuuttttf88888888ffoppppppppp999889999qqqppqqqqqq
ooooooovvvvvoovvvvoooooppqqqqqqrrrrorrrrrsssssrrrrrrrrrrbbbbbbbbbbbbbebsssstttuuuuuttttf88888888ffoppppppppp999999999qqqqqqqqqqq
oooooooooooooooovvoooooppqqqqqrrrrrrrrrrssssssrsssssssrrrbbbbbbbbbbbbcbsssstttuuuuutttt888888888ffoppppppppp999999999qqqqqqqqqqa
oooooooooooooooooooeeooppqqqqqrrrrrrrrrssssssssssssssssrrbbbbbbbbbbbccbsssstuuuuuvvvuvv888888888pppppppppppp99999999qqqqqqqqqqqq
ooooooooooooooooooooooppqqqqqqrrrrrrrrrsssssssssssssssssrbbbbbbbbbbbccbsss9suuuuuvvvvvv888888888pppppppppppp99999999qqqqqqqqqqqq
oooooooooooooooooo9pppppqqqqqrrrrrrrrrsssssssssssssssssssbbbbbbbbbbcccooss9tuuuuvvvvvvvff8888888pppppppppppppp999999qqqqqqqqqqqq
oooooooooooooooooo9ppppppqqqqqrrrrrrrssssssssssssssfsssssccbbbbbbcccccoos9stuuuuvvvvvvvff888888ppppppppppppppp999999qqqqqqqqqqqq

