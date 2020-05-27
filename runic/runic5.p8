pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
#include palettes.lua

c=cos
s=sin

function xset(x,y,c)
	circ(x,y,1,c)
end

function xfill(x,y,c)
	circfill(x,y,1,c)
end

function fflr(a,unit)
	return a - a%unit
end

function movarc(a,r,mov)
	return a+mov/(r*2*pi)
end

function frames(sec)
	return sec*30
end

palnum=1
palette=pals[palnum]
for i=1,#palette do
	pal(i,palette[i],1)
end
pol=palette

function pcol()
	cs={}
	k=9
	local e=rnd(k)
	if e>=#pol+1 then
	 return 0
	else 
		return e
	end
end

function xy()
	return rnd(128),rnd(128)
end
-->8
t=0
ti=0
dt=1/30
q2=sqrt(2)
pi=3.1415926
r_unit=8

pts={}
add(pts,{
	r=8,a=0,v=1,c=pcol()
})

cls(3)
::⌂::
--cls()
t+=dt
ti+=1

if btnp(5) or btnp(4) then
	pal()
	if btnp(5) then
		palnum=(palnum)%#pals+1
	elseif btnp(4) then
		palnum=(palnum-1-1)%#pals+1
	end
	palette=pals[palnum]
	for i=1,#palette do
		pal(i,palette[i],1)
	end
	pol=palette

	pts={}

end

if t%6>4.5 then
	r_unit=rnd(10)+12
	r_unit=flr(r_unit)
end

if ti%frames(1)==0 then
		for pt in all(pts) do
			pt.r-=1
		end
end

if ti%frames(0.5)==0 then
	for i=1,1 do
		--rectfill(rnd(128),rnd(128),rnd(128),rnd(128),3)
		circfill(rnd(128),rnd(128),rnd(25),#pol/2-1)
	end
end

curr=1

add(pts,{r=r_unit,a=rnd(1),v=rnd(1)<0.5 and 1 or -1,c=#pol})

if rnd(1)<0.05 then
	add(pts,{r=r_unit,a=rnd(1),v=rnd(1)<0.5 and 1 or -1,c=0})
end

for pt in all(pts) do
	if pt.r>64 then
		del(pts,pt)
	elseif pt.r%r_unit==0 then
		pt.a=movarc(pt.a,pt.r,pt.v)
		if rnd(1)<0.005*(10-pt.r/8) then
			--pt.r=pt.r+1
		else
		end
	else
		pt.r=pt.r+1
	end
end

for pt in all(pts) do
	local a,r=pt.a,pt.r
	x,y=64+r*c(a),64+r*s(a)
	if flr(pt.c)==0 then
		circ(x,y,2,c)
	else
		rr=rnd(1)
		if rr<0.5 then
			xset(x,y,pt.c)
		else
			pset(x,y,pt.c)
		end
	end
end

for i=1,250 do
	x,y=xy()
	sum=pget(x,y)
	  +pget(x-1,y)
	  +pget(x+1,y)
	  +pget(x,y-1)
	  +pget(x,y+1)
	  +pget(x-1,y-1)
	  +pget(x-1,y+1)
	  +pget(x+1,y-1)
	  +pget(x+1,y+1)
	avg=sum/8.5
	xset(x,y,avg)
end

for i=1,1 do
	x,y=xy()
	xset(x,y,0)
end


if ti<frames(5) then
	rectfill(0,128-8,128,128,0)
	print("change color scheme with ❎",1,128-7,7)
end

rectfill(0,0,30,12,0)
print(stat(0),0,0,7)
print(stat(1),0,6,7)

flip() goto ⌂
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
