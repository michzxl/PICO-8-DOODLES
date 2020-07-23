pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
⧗=0
a1=50

::♥::
if ⧗>5 then
	⧗=-5
end
⧗+=1/60

--reset param every 1 sec-ish
if ⧗%1<0.05 then
	a1=rnd(50)+25
end

for i=1,1000 do
	x,y=rnd(128),rnd(128)
	circ(x,y,1,0)
end

--draw circles
for x=0,128,16 do
 for y=0,128,16 do
  r=  3.5 * sin(⧗)
    + 4.5 * sin(x/17)
    + 3.0 * sin(sin(y/a1%⧗/4))
    + 4.0
  circfill(x,y,r,7)
 end
end

flip()goto ♥
