pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

poke(0x5f2e,1)

█=6000
⧗=0
t=0
num=5
dist=50
shape=2

function sqr(a) return a*a end

pal({
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
},1)


cls()
::⌂::
pp={}
⧗+=0.0166
t+=0.0166

rr=rnd(1)<0.1
for i=1,100+sin(t/32)*100 do
	x,y=rnd(128+16)-8,rnd(128+16)-8
	rectfill(x,y,x+8,y+8,0)
end

for i=1,num do
	ang=i/num
	local x=dist*1*(sin(cos(ang+⧗/4))/8  + cos(ang+⧗/4))+64
	local y=dist*0.65*sin(ang+⧗/4)+64
	add(pp,{x=x,y=y})
end

for i=1,num do
	x,y=pp[i].x,pp[i].y
	
	ss=(i+num/shape)%num+1
	p1=pp[flr(ss)]
	p2=pp[flr(ss-1)%num+1]
	
	line(x,y+40+rnd(3),p2.x,(p2.y+40+rnd(3)+p1.y),2)
	line(x,y+20+rnd(3),p2.x,(p2.y+20+rnd(3)+p1.x),3)
	
	line(x,y,p1.x,(p1.y+p2.x)/2,10)
	line(x,y,p2.x,(p2.y+p1.x)/2,10)
end

for i=1,5 do
	x,y=pp[i].x, pp[i].y+8*cos(t/8+i/8)-4*sin(t/2)
	x1,y1 = x-4,y-4
	for i=1,3 do
		ox,oy = rnd(8)+x1, rnd(8)+y1
		ox2,oy2 = rnd(8)+x1, rnd(8)+y1
		fillp(rnd(32000))
		rect(ox,oy,ox2,oy2,(t*4+i*rnd(3))%10+1)
		fillp()
		line(ox,oy,ox2,oy2,(t*4+i*rnd(3))%10+1)
	end
end

circ(63,10*sin(⧗/2+.02)+30,5,6)
circ(63,10*sin(⧗/2)+30,5,6)


flip()goto ⌂
