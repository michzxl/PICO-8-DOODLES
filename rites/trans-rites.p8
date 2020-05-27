pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
█=5500
⧗=0
num=6
dist=50
shape=2

pal(2,2+128,1)
pal(13,13+128,1)

function sqr(a) return a*a end

function lerp(a,b,t) return a + t * (b - a) end

function ll(a,b,c,ym) 
	line(a.x,a.y+ym,b.x,b.y+ym,c)
	line(a.x,a.y+ym+1,b.x,b.y+ym+1,c)
end

function llc(ym,c1,c2,c3)
	--side one
	ll(pp[6],pp[16],c1,ym)
	ll(pp[16],pp[15],c2,ym)
	ll(pp[15],pp[14],c3,ym)
	ll(pp[14],pp[13],c2,ym)
	ll(pp[13],pp[12],c1,ym)
	
	--side two
	ll(pp[3],pp[11],c1,ym)
	ll(pp[11],pp[10],c2,ym)
	ll(pp[10],pp[9],c3,ym)
	ll(pp[9],pp[8],c2,ym)
	ll(pp[8],pp[7],c1,ym)
	
	ll(pp[2],pp[6],c1,ym)
	ll(pp[8],pp[16],c2,ym)
	ll(pp[9],pp[15],c3,ym)
	ll(pp[10],pp[14],c3,ym)
	ll(pp[11],pp[13],c2,ym)
	ll(pp[3],pp[5],c1,ym)
end

cls()
::⌂::
pp={}
⧗+=0.0166

if btnp(0) then shape-=1 end
if btnp(1) then shape+=1 end

rr=rnd(1)<0.1

--slight clear screen
for i=1,█ do
	x,y=rnd(108)+10,rnd(128)
	pset(x,y,0)
end

for i=1,num do
	ang=i/num
	local x=dist*1*cos(ang+⧗/4)+64
	local y=dist*0.65*sin(ang+⧗/4)+64
	add(pp,{x=x,y=y})
end

for i=0,0.9,0.2 do
 add(pp,{
 x=lerp(pp[2].x,pp[3].x,i),
 y=lerp(pp[2].y,pp[3].y,i)
})
end

for i=0,0.9,0.2 do
 add(pp,{
 x=lerp(pp[5].x,pp[6].x,i),
 y=lerp(pp[5].y,pp[6].y,i)
})
end

for i=1,num do
	x,y=pp[i].x,pp[i].y
	
	ss=(i+num/shape)%num+1
	c=7
	if ss==2 then c=1 end
	p1=pp[flr(ss)]
	p2=pp[ceil(ss)%num+1]
	
	line(x+3,y+47,p1.x-3,p1.y+40,2)
	line(x,y+40,p2.x,p2.y+40,2)
end

--llc(40+rnd(2),2,2,2)

for i=1,num do
	x,y=pp[i].x,pp[i].y
	
	ss=(i+num/shape)%num+1
	c=7
	if ss==2 then c=1 end
	p1=pp[flr(ss)]
	p2=pp[ceil(ss)%num+1]
	
	line(x,y+10,p1.x,p1.y+20,1)
	line(x,y+10,p2.x,p2.y+20,1)
end

--llc(20,1,1,1)

for i=1,num do
	x,y=pp[i].x,pp[i].y
	
	ss=(i+num/shape)%num+1
	c=7
	if ss==2 then c=10 end
	p1=pp[flr(ss)]
	p2=pp[ceil(ss)%num+1]
	
	line(x,y,p1.x,p1.y,13)
	line(x,y,p2.x,p2.y,13)
end

llc(-20,12,14,7)

circ(63,-10 + 10*sin(⧗/2+.02)+30,5,8)
circ(63,-10 + 10*sin(⧗/2)+30,5,8)

print(stat(1),0,0,10)
--print(shape,0,10,10)

flip()goto ⌂
