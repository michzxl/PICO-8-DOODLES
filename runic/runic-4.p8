pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
#include palettes.lua

c=cos
s=sin

function xset(x,y,c)
	circ(x,y,1,c)
end

function fflr(a,unit)
	return a - a%unit
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
scr_diag=64*q2
n=5
ang_ofs=0
ang_ofs2=0

pts={}
add(pts,{
	x=8,y=0,v=1,c=pcol()
})

cls()
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
	r_unit=8+rnd(5)
	r_unit=flr(r_unit)
end

-- --draw some circles around the screen once every second
-- if ti%frames(1)==0 then
-- 	circfill(rnd(128),rnd(128),rnd(45),#pol/2-1)
-- end

--spawn some new particles somewhere at the center ring.
--roughly 18 particles / second
if rnd(1)<0.8 then
	add(pts,{x=0,y=fflr(rnd(128),r_unit),v=rnd(1)<0.5 and 1 or -1,c=#pol})
end

for pt in all(pts) do
	if pt.x<0 or pt.x>128 or pt.y<0 or pt.y>128 then
		-- if particle is far enough out to be 
		-- guaranteed to be off-screen,-- delete it.
		del(pts,pt)
	elseif pt.y%r_unit==0 then
		--if particle lines up with a ring,
		--just move it around.
		pt.x+=pt.v
		if rnd(1)<0.075 and pget(pt.x,pt.y+r_unit)<#pol/2 then
			--small chance that particle will be pushed outward.
			pt.y+=pt.v
		end
	else
		--if particle lands between rings,
		--move it towards the next outer ring.
		pt.y+=pt.v
	end
end

for pt in all(pts) do
	x,y=pt.x,pt.y
	y=x*cos(t/16)/2+y
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
