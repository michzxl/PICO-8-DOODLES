pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
poke(0x5f2d, 1)--enable mouse

dt=1/30
t=0
w=2
count=(2*w+1)*(2*w+1)

cls()
::♥::
t+=dt
mx,my = stat(32),stat(33)

for i=1,10 do
	x,y=rnd(128),rnd(128)
	c=rnd(24)
	circ(x,y,1,c)
end

for i=1,300 do
	x,y=rnd(128),rnd(128)
	sum=0
	for ox=x-w,x+w do
		for oy=y-w,y+w do
			sum+=pget(ox,oy)
		end
	end
	circ(x,y,1,sum/count)
end

for i=1,500 do
	x,y=rnd(128),rnd(128)
	ang=atan2(x-mx,y-my)
	ang=ang+t/8
	d=4
	c=pget(x-cos(ang)*d,y-sin(ang)*d)
	circ(x,y,1,c)
end

circfill(mx,my,1,7)

flip() goto ♥
