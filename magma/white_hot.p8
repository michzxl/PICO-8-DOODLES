pico-8 cartridge // http://www.pico-8.com
version 19
__lua__
t=0
█fade=800
█spread=500
█starter=200
b={
	x=20,y=-50,
	dx=5,dy=1,
	ax=0,ay=0.5,
	r=9
}

pal(1, 7,1)
pal(2, 10,1)
pal(3,9,1)
pal(4, 8,1)

function sqr(z) return z*z end

function dist(x1,y1,x2,y2)
	return sqrt(sqr(x2-x1) + sqr(y2-y1))
end

::♥::
rectfill(0,0,127,127,0)

t+=0.01

b.dx+=b.ax
b.dy+=b.ay
b.x+=b.dx
b.y+=b.dy

if (b.x-b.r<=0) b.dx=5*rnd(1)+1
if (b.x+b.r>=127) b.dx=-5*rnd(1)+1
if (b.y-b.r<=0) b.dy=5 
if (b.y+b.r>=127) then b.dy=-1*(rnd(4)+7) b.dx+=sgn(b.dx) end

for i=1,█fade do
	x,y=rnd(128),rnd(128)
	c=sget(x,y)
	if c>=1 and c<=4 then
		c=c%5+1
	else
		c=0
	end

	sset(x-1,y,c)
	sset(x+1,y,c)
	sset(x,y-1,c)
	sset(x,y+1,c)
end

a={1,0,-1}

for i=1,█spread do
	x,y=rnd(128),rnd(128)
	kx,ky=a[flr(rnd(3))+1],a[flr(rnd(3))+1]
	c=sget(x+kx,y+ky)
	c2=sget(x,y+1)
	if c2>=1 and c2<=4 then
		c=c%5+1
		
		sset(x-1,y,c)
		sset(x+1,y,c)
		sset(x,y-1,c)
		--sset(x,y+1,c)
	elseif c2>=1 and c2<=4 then
		c2=c2%5+1
		sset(x-1,y,c2)
		sset(x+1,y,c2)
		sset(x,y-1,c2)
		sset(x,y+1,c2)
	end
end

for i=1,█starter do
	ang=rnd(1)
	r=rnd(b.r)
	x=cos(ang)*r+b.x
	y=sin(ang)*r+b.y
	
	sset(x-1,y,1)
	sset(x+1,y,1)
	sset(x,y-1,1)
	sset(x,y+1,1)
end

sspr(0,0,128,128,0,0)

flip() goto ♥
