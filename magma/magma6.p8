pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
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

pal(palettes.reds, 1)

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

t=0
dt=0.016
█=1020
kill=0
function sqr(a) return a*a end
cls()
::♥::
t+=dt

if t%16<dt then t=0 end

st=sin(t)
st2=sin(t/8)
st1=sin(t/4)

for i=1,1000 do
	y=rnd(128)-64
	x=rnd(128)-64


	c= (x - 2*(y/(50+10*st) + t/2 - 2*st1) - t/2) / 8
	
	c=c + sin((x-st*10)*(y-t*5-st2*10)/500)
	
	c=c + sin(x/32) * sin((y+t*10%100)/32)

	
	c=c*x/32+y/32+x/(64*(st2+1.1))
	--c=c/1.33
	c=c/8
	c=c+cos(st1/2)

	--p={10,9,8}
	c = ctriwave(c+t*2, 5.6, 8.8, 4)
	--c=c%#palettes.reds+1
	
	
	circ(x+64,y+64,1,c)
end


flip() goto ♥
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
