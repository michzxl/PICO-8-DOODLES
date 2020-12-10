pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--cascade 3
--by ???

-- press ❎/🅾️ to swap palette

pn=0
p={
	[0]={7+128,10,10+128,11,11+128,3,3+128,1,1+128,1+128,1+128,1+128},
	{7+128,10,9,9+128,8,8+128,2,2+128},
}
for i=1,14 do
	pal(i,p[pn][i],1)
end

t=rnd(10)
k=sqrt(2)
rr=60.98*k
pi=3.14

cls()
::♥::
--cls()
t+=0.01

if btnp(4) or btnp(5) then
	pn=(pn+1)%2
	for i=1,#p[pn] do
	pal(i,p[pn][i],1)
end
end

for i=1,500 do
	ang,ra=rnd(1),rnd(64*k)
	if ra>rr*.2 then
		ca,sa=cos(ang),sin(ang)
		x,y=ra*ca,ra*sa
		
		r2=ra-1.5
		ang2=ang+2/360
		ca,sa=cos(ang2),sin(ang2)
		smpl=pget(r2*ca+64,r2*sa+64)
		
		if smpl~=10 then
			circ(x+64,y+64,1,smpl)
		elseif rnd(1)<0.01 then
			circ(x,y,1,0)
		end
	end
end

for i=1,250 do
	ang,r=rnd(1)+t/8, rnd(rr)
	r2=sqrt(r)*10*sin(rr)
	
	sa=sin(ang)
	 + 0.5 * cos(-t/2 + sin(t/3))
	ca=cos(ang)
	 + 0.5*sin(t/2 + 0.5*cos(t/3))
	
	x,y=r*ca,r*sa
	x2,y2=r2*ca,r2*sa
	
	--this is just cascade.
	c=sin(x/64)+sin(y/64)
	c=c%(2*t)+2*t
	c=26*abs((c/16%1)-1/2)-13/2+7.5
	c=flr(c)+x/16
	
	l=#p[pn]
	a=l+0.5
	c=2*a*abs((c/a/2)%1-1/2)+1
	
	--c=c%(#p[pn]+1)+1

	circ(x2+64,y2+64,1,c)
end

flip() goto ♥
__gfx__
01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17777100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17711100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000