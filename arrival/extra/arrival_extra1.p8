pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
dt=0.0333
t=0

function sqr(a) return a*a end

cls()
::♥::
t+=dt

for i=1,1000 do
	x,y=rnd(128),min(sqr(rnd(15)),128-19)
	
	c=sin(y/147-t/4)*x/64
	 *cos(x/64 -t/2)*y/256
	 +(-x/16+(y-64)/(1+(y+64+t*64)%200))
	c=flr(c)
	
	--c=c%8+8
	c=flr(c%2)==0 and 0 or 7
	c=c+(sin(x/16+(t%10)/y*10)+1)*0.6
	c=flr(c)

	circ(x,y,1,c)
end

for i=1,100 do
	x,y=rnd(128),sqrt(rnd(15)+128-16)+102
	c=x/18+t
	c=flr(c%8+8)
	c=c+x/37+t/.75
	c=flr(c%8+8)
	circ(x,y,1,c)
	--pset(x,y,c)
end

for i=1,50 do
	x,y=rnd(128),rnd(11)+128-12
	c=sin(x/16+y/16)+(sin(t/4)+1)/2*1.5*sin(x/16-y/16)
	c=c+(sin(abs((x-64)/16+y/32))+1)*abs(x-64)/16
	c*=2
	c=c+10
	circ(x,y,1,c)
end

flip()goto ♥
