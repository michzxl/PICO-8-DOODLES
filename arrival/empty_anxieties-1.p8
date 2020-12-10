pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
dt=1/30
t=0

pal(7,7,1)

a=rnd(2)
b=rnd(1)

cls()
::♥::
t+=dt

if t%2<0.2 then
	a=rnd(2)
end

if t%1<0.1 then
	b=rnd(1)
end

for i=1,300 do
	x,y=rnd(128),rnd(128)
	xa,ya=x-64,y-64

	c=sin(y/147-t/4)*x/64*a
	 *cos(x/64*b -t/2)*y/128/a
	 +(-(x*a+t*30)/32+(y)/32)
	
	if rnd(1) < (abs(x)+abs(y)) / 32 then
		c=4
	end
	
	c=flr(c%2)*7
	
	if c~=0 or abs(x-64)+abs(y-64) then
		circ(64-x/2,64-y/2,1,c)
		circ(64+x/2,64+y/2,1,c)
		circ(64+x/2,64-y/2,1,c)
		circ(64-x/2,64+y/2,1,c)
	end
end

for i=1,250 + 300*sin(t/6+0.2) do
	x,y=rnd(128),rnd(128)
	d=sqrt((x-64)*(x-64)+(y-64)*(y-64))
	if d<30 and d>18 then
		circ(64,64,d*(sin(t/3)+5)/4,7)
	end
end

for i=1,500 do
	x,y=rnd(128),rnd(128)
	if abs(x-64)+abs(y-64)>38 then
		if abs((y)-(x))<2 then
		circ(x,y,1,7)
		end
	end
end

flip()goto ♥
