pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
#include palettes.lua

c=cos
s=sin

--n-gon
function shape(ang,ang_ofs,r,n)
	a=r*cos(0.5/n)
	--b=cos(tri_wave(n*ang-0.5-t/2)/n)
	b=cos(tri_wave(n*ang-0.5-ang_ofs)/n)
	return a/b
end

--triangle wave, w/ period 1
function tri_wave(x)
	return abs((x+.5)%1-.5)
end

function rmin(rmax,n)
	return rmax * cos(0.5/n)
end

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
r_unit=12
scr_diag=64*q2
n=5
ang_ofs=0
ang_ofs2=0

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

--radius unit changes continuously 
--during the last 2.5 seconds of each 10 second interval
if ti%frames(10)>frames(7.5) then
	r_unit=rnd(6)+16
	r_unit=flr(r_unit)
end

if ti%frames(10)==frames(10)-1 then
	n=flr(rnd(5))+3
	ang_ofs=rnd(1)
	ang_ofs2=rnd(1)
end

--draw some circles around the screen once every second
if ti%frames(1)==0 then
	--rectfill(rnd(128),rnd(128),rnd(128),rnd(128),3)
	circfill(rnd(128),rnd(128),rnd(45),#pol/2-1)
end

--spawn some new particles somewhere at the center ring.
--roughly 18 particles / second
if rnd(1)<0.6 then
	add(pts,{r=r_unit,a=rnd(1),v=rnd(1)<0.5 and 1 or -1,c=#pol})
end

--spawn some black particles at the center.
--roughly 0.75 particles / second
if rnd(1)<0.025 then
	add(pts,{r=r_unit,a=rnd(1),v=rnd(1)<0.5 and 1 or -1,c=0})
end

for pt in all(pts) do

	if rmin(pt.r,n)>64*q2*q2 then
		-- if particle is far enough out to be 
		-- guaranteed to be off-screen,-- delete it.
		del(pts,pt)
	elseif pt.r%r_unit==0 then
		--if particle lines up with a ring,
		--just move it around.
		pt.a=movarc(pt.a,pt.r,pt.v)
		if rnd(1)<0.005*(10-pt.r/8) then
			--small chance that particle will be pushed outward.
			pt.r=pt.r+1
		end
	else
		--if particle lands between rings,
		--move it towards the next outer ring.
		pt.r=pt.r+1
	end
end

for pt in all(pts) do
	local a=pt.a
	local r=
	   1.00*shape(a,ang_ofs,pt.r,n)
	  +0.50*shape(a,ang_ofs2,pt.r,n+1)
      -0.35*shape(a,t,pt.r,n-1)
	x,y=64+r*c(a),64+r*s(a)
	if flr(pt.c)==0 then
		circ(x,y,2,c)
	else
		if rnd(1)<0.5 then
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
	avg=sum/9
	xset(x,y,avg)
end

for i=1,10 do
	x,y=xy()
	xset(x,y,0)
end

if ti<frames(5) then
	rectfill(0,128-8,128,128,0)
	print("change color scheme with ❎",1,128-7,7)
end

flip() goto ⌂
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
