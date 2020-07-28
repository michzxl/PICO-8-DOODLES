pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--doodle template
--micheal

█=500
dt=0.0166

t=0

p={0,1,12+128,0,15+128,14+128}
for i=1,#p do
	pal(i,p[i],1)
end

cls()

::♥::
t+=dt

for i=1,█ do
	ang=rnd(1)
	d=rnd(62)
	x=cos(ang)*d
	y=sin(ang)*d
	--x,y=rnd(128),rnd(128)
	
	if d<8 then
		c=7
	elseif d<45+sin(t/5)*10+sin(sin(t)*8)*8 then

		c=(atan2(y/8,x))*4
		--c=c%((sin(t/10))*7)
		c=c+2*t
		
		c=c+flr(x/12)+flr(y/(16))
		
		c=c%#p+1
	else
		c=0
	end

	circ(x+64,y+64,1,c)
end

flip()goto ♥
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000