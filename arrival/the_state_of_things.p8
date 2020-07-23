pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
--the state of things
--by ???

function _init()
	pal({
		[0]=0,7,--black/white
		2,8+128,
		13+128,13,--lavender
		1,12+128,--blue
		3+128,3,--green
		135,142,--yellow/orange
		8+128,8,--red
		6,7,--white/gray
	},1)

	period=4
	t=-1

	cls()

	pattern_i=1
	patterns={
		pattern0,
		pattern1,
		pattern2,
	}
	pattern=patterns[pattern_i]
end

function _update()
	t+=1/60

	if (t+3)%(period/2)<=1/60 then
		if rnd(1)<0.33 then
			for i=1,rnd(5) do
				pattern_i=pattern_i%#patterns+1
			end
		else
			pattern_i=1
		end
		pattern=patterns[pattern_i]
	end

	ct4,st2=cos(t/period),sin(t/(period/2))
	st16=sin(t/16)
	st8=sin(t/8)

	smpl=1300*abs(ct4)
	for i=1,smpl do pattern() end

	-- point where xo,yo=0,0
	circfill(32*st2+64, 32*ct4+64, 2, t*16%15+1)
end

function pattern0()
	-- distribution of xo,yo is a uniform rectangle.
	xo=rnd(80) - 64 -- [-64,16]
	yo=rnd(150) - 75 -- [-75,75]

	-- rotate & scale x,y
	x=(xo+32)*st2 - yo*ct4
	y=(xo+32)*ct4 + yo*st2

	c = -st8 * x/16
	+ cos(x/64 - t/2) * y/32
	+ (xo/32 + yo/32 + y)/(st16*4+12)
	+ t
	
	c=flr(c%2)--{0,1}
	c+=fflr(t+1,period/2)--{k,k+1}
	
	circ(x+64,y+64,1,c)
end

function pattern1()
	xo=rnd(80) - 64
	yo=rnd(150) - 75

	x=(xo+32)*st2 - yo*ct4
	y=(xo+32)*ct4 + yo*st2

	c = -st8 * x/16
	+ cos(xo/64 - t/2) * y/32
	+ t
	
	c=flr(c%2)
	c+=fflr(t+1,period/2)
	
	circ(x+64,y+64,1,c)
end

function pattern2()
	xo=rnd(80) - 64
	yo=rnd(150) - 75

	x=(xo+32)*st2 - yo*ct4
	y=(xo+32)*ct4 + yo*st2

	c=sin(xo/64-t/4)+sin(y/64)
	c=c%(t*2) 
	c=c+2*t

	c=flr(c%2)--{0,1}
	c+=fflr(t+1,period/2)--{k,k+1}

	circ(x+64,y+64,1,c)
end

function fflr(a, unit)
	-- slightly wrong
	return a - a%unit
end
