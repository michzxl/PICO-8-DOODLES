pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function sqr(a) return a*a end
function dist(x1,y1,x2,y2) return sqrt(sqr(x2-x1)+sqr(y2-y1)) end

dt=1/30
t=0

function sqr(a) return a*a end

cls()
::♥::
t+=dt

if t%1<0.1 then
	cls()
	circ(64,64,64,rnd(3)+5)
end

for i=1,500 do
	x,y=rnd(128),rnd(128)
	d=dist(64,64,x,y)
	c=d/35+t/4
	c=flr(c)%2
	c=c+d/79+t/8+sin(x/64-cos(y/128))
	c=c%2
	circ(x,y,1,c)
end

r=(sin(t/4)+1)/2*30+20
circ(64,64,r+rnd(3)-1,7)

if rnd(1)<0.2 then
	a1=rnd(1)
	a2=rnd(1)
	r=(sin(t/4)+1)/2*30+20
	x1,y1=r*cos(a1),r*sin(a1)
	x2,y2=r*cos(a2),r*sin(a2)
	line(x1+64,y1+64,0,t*64%128)
	line(x2+64,y2+64,128,128-t*64%128)
	line(x1+64,y1+64,t*64%128,128)
	line(x2+64,y2+64,128-t*64%128,0)
end

flip()goto ♥
