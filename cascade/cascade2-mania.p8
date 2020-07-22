pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init()
	░=250 --default sampling rate
	dt=0.01
	t=0

	poke(0x5f2d, 1) --enable mouse/keyboard

	pp={
		7,
		7+128,
		10,
		10+128,
		11,
		11+128,
		3,
		3+128,
		1,
		1+128,
		0,
		0,
		0,
		1,
		3+128,
		3,
		11+128,
		11,
		10+128,
		10,
		7+128 
	}
	for i=1,#pp do
		if pp[i]~='' then
			pal(i,pp[i],1)
		end
	end

	dg=100
	for i=1,dg do
		ang=i/dg
		line(64,64,
			64+64*q.k*cos(ang),64+64*q.k*sin(ang),
			rnd(#pp)+1)
	end

	--block state (don't need to touch)
	fs={b=1,t=0,rp=true} 

	init_blocks()
end

function _update()
	--cls()
	t+=dt 
	fs.t+=1/30
	_mouse()

	draw()
	check_timer()
end

-->8
--prog

q={
	k=sqrt(2),
	rr=61*sqrt(2),
	rr2=60.98*sqrt(2)
} --you can cache values here if you want.
q.rr2=61*q.k

function init_blocks()
	f={
		--{t=1,go=nil,tab={},wrap=nil,drw=nil,next=nil}
		{t=4,go=c1,nowrap=true},
		{t=4,go=c2,nowrap=true},
		{t=4,go=c3,nowrap=true}
	}
end

function c1(tab)
	for i=1,1000 do
		ang,ra=rnd(1),rnd(64*q.k)
		if ra>q.rr*.2 then
			ca=cos(ang)
			sa=sin(ang)
			x,y=ra*ca,ra*sa
			--circ(x+64,y+64,1,7)
			r2=ra-1
			smpl=pget(r2*ca+64,r2*sa+64)
			circ(x+64,y+64,1,smpl)
		end
	end

	for i=1,250 do
		ang,r=rnd(1),rnd(q.rr)
		r2=sqrt(r)*10*sin(q.rr)
		
		sa=sin(ang)+cos(t/2+sin(t/3))/2
		ca=cos(ang)+sin(t/2+(cos(t/3)/2))/2
		
		x,y=r*ca,r*sa
		x2,y2=r2*ca,r2*sa
		
		c=sin(x/64)+sin(y/64)
		c=c%(t*2) 
		c=c+2*t --move it
		c=2*13*abs((c/16%1)-1/2)-13/2+7.5
		c=flr(c)
		c=c%#pp+1 -- [1,14]

		circ(x2+64,y2+64,1,c)
	end
end

function c2(tab)
	for i=1,500 do
		ang,ra=rnd(1),rnd(64*q.k)
		if ra>q.rr*.2 then
			ca=cos(ang)
			sa=sin(ang)
			x,y=ra*ca,ra*sa
			--circ(x+64,y+64,1,7)
			r2=ra+1.5
			ang2=ang+2/360
			ca=cos(ang2)
			sa=sin(ang2)
			--smpl=pget(r2*ca+64,r2*sa+64)
			smpl=pget(x+64-1,y+64-3)
			if smpl~=10 then
				circ(x+64,y+64,1,smpl)
			elseif rnd(1)<0.01 then
				circ(x,y,1,0)
			end
		end
	end

	for i=1,500 do
		ang,r=rnd(1),rnd(q.rr)
		r2=sqrt(r)*10*sin(q.rr)
		
		sa=sin(ang)+cos(t/2+sin(t/3))/2
		ca=cos(ang)+sin(t/2+(cos(t/3)/2))/2
		
		x,y=r*ca,r*sa
		x2,y2=r2*ca,r2*sa
		
		c=sin(x/64)+sin(y/64)
		c=c%(t*2) 
		c=c+2*t --move it
		c=2*13*abs((c/16%1)-1/2)-13/2+7.5
		c=flr(c)
		c=c%#pp+1 -- [1,14]

		circ(x2+64,y2+64,1,c)
	end
end

function c3(tab)

	for i=1,500 do
		ang,ra=rnd(1),rnd(64*q.k)
		if ra>q.rr2*.2 then
			ca=cos(ang)
			sa=sin(ang)
			x,y=ra*ca,ra*sa
			--circ(x+64,y+64,1,7)
			r2=ra+2
			smpl=pget(r2*ca+64,r2*sa+64)
			if smpl~=10 then
				circ(x+64,y+64,1,smpl)
			elseif rnd(1)<0.01 then
				circ(x,y,1,0)
			end
		end
	end

	for i=1,250 do
		--x,y=rnd(128),rnd(128)
		--ang,r=atan2(x-64,y-64),dist(x,y,64,64)
		ang,r=rnd(1),rnd(q.rr2)
		--r2=sqrt(r)*10
		r2=sqrt(r)*10*sin(q.rr2)
		
		sa=sin(ang)+cos(t/2+sin(t/3))/2
		ca=cos(ang)+sin(t/2+(cos(t/3)/2))/2
		
		x,y=r*ca,r*sa
		x2,y2=r2*ca,r2*sa
		
		l=32
		--c=sin(x/l)+sin(y/l)
		--c=c+(-x/32-y/32)%2
		c=sin(x/64)+sin(y/64)
		c=c%(t*2) 
		c=c+2*t --move it
		c=2*13*abs((c/16%1)-1/2)-13/2+7.5
		c=flr(c)
		c=c%#pp+1 -- [1,14]

		circ(x2+64,y2+64,1,c)
	end
end

-->8
--control
--system helper funcs

function draw()
	(f[fs.b]).go(f[fs.b].tab or {})
end

function check_timer()
	block=f[fs.b]
	if fs.t>block.t then
		fs.t-=block.t
		fs.b=((fs.b+1)-1)%(#f)+1 --hmm
	end
end

-->8
--util
--various util

function isf(a) return type(a)=='function' end
function makef(a) 
	if not a or isf(a) then 
		return a
	else 
		return function() 
			return a 
		end 
	end
end

--math
function sqr(a) return a*a end
function dist(x1,y1,x2,y2) return sqrt(sqr(x2-x1)+sqr(y2-y1)) end
function nsin(a) return (sin(a)+1)/2 end
function ncos(a) return (cos(a)+1)/2 end
function rsin(a,r1,r2) return nsin(a)*r2 + r1 end
function rcos(a,r1,r2) return ncos(a)*r2 + r1 end
function tan(a) return sin(a)/cos(a) end

--util
function stats()
	pprint("∧"..flr(stat(1)*100).."%".."\n⧗:"..flr(t).." ("..flr(fs.t*10)/10 ..")".."\n█:"..fs.b,1,1,2,11)
end
function drw_mouse(x,y) spr(0,x,y) end
function _mouse() mx,my=stat(32),stat(33) end
function pprint(s,x,y,fg,bg)
	bg = bg or 12
	fg = fg or 4
	cursor(x,y)
	color(bg)
	print(s,x+1,y+1+1)print(s,x+1,y+2+1)
	print(s,x-1+1,y+2+1)
	print(s,x+1+1,y+2+1)
	print(s,x+1+1,y+1+1)
	print(s,x-1+1,y-1+1)
	print(s,x-1+1,y+1+1)
	print(s,x+1+1,y-1+1)
	print(s,x+1,y-1+1)
	print(s,x+1+1,y+1)
	print(s,x-1+1,y+1)
	color(fg)
	print(s,x+1,y+1)
end

__gfx__
0b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b2b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b22b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b222b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b2222b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b22bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bb2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
