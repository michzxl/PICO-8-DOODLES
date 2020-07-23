pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
⧗=0
a1=50

::♥::
if ⧗>5 then
	⧗=-5
end
⧗+=0.0167---rnd(⧗)*0.05

--reset param every 1 sec-ish
if ⧗%1<0.05 then
	a1=rnd(50)+25
end

--partial screen clear
-- = fade effect
for i=1,1000 do
	x,y=rnd(128),rnd(128)
	circ(x,y,1,0)
end

--draw circles
for x=0,128,16+cos(⧗/24)*8 do
 for y=0,128,16+sin(⧗/8)*8 do
 	if y<=128 and x<=128 then
	  	r=  3.5 * sin(⧗)
	     + 4.5 * sin(x/17)
	     + 3.0 * sin(sin(y/a1%⧗/4))
	     + 3.0
		dx = x - (sin(⧗-x/8)*10)
	  circfill(dx,y,r,7)
 	end
 end
end

flip()goto ♥
