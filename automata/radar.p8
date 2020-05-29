pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	greens={
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
	}
	
	for i=1,#greens do
		pal(i-1,greens[#greens-i],1)
	end

	t=0
	dt=1/30
	ct=0
	
	for i=1,100 do
		x,y=xy()
		sset(x,y,0)
	end
	
	cls()
end

function _update()
	t+=dt
	ct+=1
	
	sspr(0,0,128,128,0,0)
	
	line(64,64,64+90*cos(t/20),64+90*sin(t/20),1)
	
	for i=1,200 do
		x,y=xy()
		sx(x,y,mid(0,sget(x,y)-3,10))
	end
	
	for i=1,300 do
		x,y=xy()
		x=x-x%6
		s=sget(x,y)
		if s~=0 then
			sset(x,y,mid(0,s-3,10))
			x4=x+6*cos(t/20)
			y4=y+6*sin(t/20)
			--x4=x+6*cos(atan2(x-64,y-64))
			--y4=y+6*sin(atan2(x-64,y-64))
			x4=x4-x4%6+(tl(t/16) and 0 or 6)
			sset(x4,y,2+sget(x4,y))
			sset(x4,y4,1+sget(x4,y4))
		end
	end
	
	for i=1,5 do
		x,y=xy()
		sset(x,y,1)
	end
	
	for i=1,5 do
		x,y=xy()
		sset(x-x%6,y,0)
	end
	
	for i=1,300 do
		x,y=xy()
		c=boxblur(x,y,3)
		circ(x,y,1,c)
	end
end
-->8
function sx(x,y,c)
	--sset(x  ,y  ,c)
	sset(x+1,y  ,c)
	sset(x-1,y  ,c)
	sset(x  ,y-1,c)
	sset(x  ,y+1,c)
end

function xy()
	return rnd(128),rnd(128)
end

function boxblur(x,y,w)
	sum=0
	for ox=x-w/2,x+w/2 do
		for oy=y-w/2,y+w/2 do
			sum+=sget(ox,oy)
		end
	end
	return sum/w
end

function tl(t)
	return (3/8<t%1 and t%1<5/8)
end
