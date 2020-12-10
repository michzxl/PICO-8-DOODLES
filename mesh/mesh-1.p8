pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
█=1000
dt=0.0333
t=0

function sqr(a) return a*a end
function dist(x1,y1,x2,y2) return sqrt(sqr(x2-x1)+sqr(y2-y1)) end
-- "complex" triangle wave, range [center - amplitude/2, center + amplitude/2]
-- to visualize -> https://www.desmos.com/calculator/lbicgo2khe
function ctriwave(x, center, amplitude, period)
    local a, b, p = amplitude or 1, center or 0, period or 1
    local core = abs((x / p - 0.25) % 1 - 0.5)
    return 2 * a * core - a / 2 + b
end
function line2(x1,y1,x2,y2,c)
 local num_steps=max(
  abs(flr(x2)-flr(x1)),
  abs(flr(y2)-flr(y1)))
 local dx=(x2-x1)/num_steps
 local dy=(y2-y1)/num_steps
 for i=0,num_steps do
  pset(x1,y1,c)
  x1+=dx
  y1+=dy
 end
end

pal({
	2+128,
	2,
	8+128,
	8,
	9+128,
	9,
	10,
	7+128,
	7,
}, 1)

cls()

::♥::
cls()
t+=dt

k=64
j=20
for xa=-k,128+k,j do
	for ya=-2*k,128+2*k,j do
		x,y=xa+cos(t/6)*8,ya+sin(t/8)*16
	
		h=3*(sin(sin(y/256-t/8)+1)+1)
			+4*(sin(x/256-t)+1)
		
		--circ(x,y,1,5)
		fillp(0b1010010110100101)
		line(x,y,x,y-h+1,1)
		fillp()
		
		x2,y2=xa,ya
		x2,y2=x2+cos(t/6)*8,y2+sin(t/8)*16
		h2=3*(sin(sin(y2/256-t/8)+1)+1)+4*(sin(x2/256-t)+1)
		line2(x,y-h,x2,y2-h2,5)
		
		x2,y2=xa+j,ya
		x2,y2=x2+cos(t/6)*8,y2+sin(t/8)*16
		h2=3*(sin(sin(y2/256-t/8)+1)+1)+4*(sin(x2/256-t)+1)
		line2(x,y-h,x2,y2-h2,2)
		
		c=(sin(x/512)*16+sin(y/128)*4)
		c = ctriwave(c, 5.6, 8.8, 16)
		circfill(x,y-h,(sin(t)+6)/2+sin(x/17),0)
		circfill(x,y-h,(sin(t)+6)/2+sin(x/17)-2,0)
		circ(x,y-h,(sin(t)+6)/2+sin(x/17),c)
	end
end

flip()goto ♥
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
