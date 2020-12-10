pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
t=0
k=sqrt(2)
pal(1,7,1)
::♥::
t+=1/30

p={2+128,13+128,0,13,6,7}
for i=1,#p do
	pal(i,p[i],1)
end

for i=1,1150 do
	ang,r=rnd(1),rnd(64*k)
	r2=sqrt(r)*10
	
	sa=sin(ang)
	ca=cos(ang)
	
	x,y=r*ca,r*sa
	x2,y2=r2*ca,r2*sa
	st8=sin(t/8)
	
	c=0
	maxr=30 + 5*st8
	if r<maxr then
		a=15 + 10*(st8+1)
		c=x/32+y/32+t
		c=flr(c)
		c=c+x/16-y/16-t
		
		c=c%8+8

		c=c+x/16+t/2
		c=c%7
	end
	
	circ(x2+64+cos(t)*2,y2+64+sin(t)*2,1,c)
end

flip() goto ♥
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055667700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700055667700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000