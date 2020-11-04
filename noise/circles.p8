pico-8 cartridge // http://www.pico-8.com
version 19
__lua__
pal(1,7,1)

cls()

cs={}
for i=1,3 do
	r=rnd(16)+16
	c={x=rnd(128-r*2)+r,y=rnd(128-r*2)+r,
	   r=r,
	   xv=0.5,yv=-.5}
	add(cs,c)
end

function upd(c)
	c.x+=c.xv
	c.y+=c.yv
	if c.x-c.r<0 or c.x+c.r>127 then
		c.xv*=-1
	end
	if c.y-c.r<0 or c.y+c.r>127 then
		c.yv*=-1
	end
end

::♥::

foreach(cs,upd)

for i=1,1400 do
	local x=rnd(128)
	local y=rnd(128)

	local num=0
	for c in all(cs) do
		local xcx,ycy,cr = x-c.x, y-c.y, c.r
		if xcx*xcx + ycy*ycy < cr*cr then
			num+=1
		end
	end

	if pget(x,y)==1 and num%2==0  then
		circ(x,y,1,6)
	else
		circ(x,y,1,num%2)
	end
end

flip() goto ♥
