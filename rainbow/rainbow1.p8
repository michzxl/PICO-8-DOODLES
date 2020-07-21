pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
for i=0,7 do
	pal(i,i+8+128,1)
end

t=0
::★::

t+=0.01
st3=sin(t/3)
st5=sin(t/5)

for i=1,1700 do
	x,y=rnd(128),rnd(128)
	
	c=flr(
		     (x+sin(y/30+st5*5)*6*st3)/(24 * (st3-1.8)) 
		    +y/(48 * (st3-1.8))
		    +8*t
	  )
	c=c%8+8

	if rnd(1)<1.25*st3 then
		c-=8
	end
	
	circ(x,y,1,c)
end

flip() goto ★
