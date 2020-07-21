pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
for i=0,7 do
	pal(i,i+8+128,1)
end

t=0
::★::

t+=0.01

for i=1,1300 do
	x=rnd(128)
	y=rnd(128)
	s=sin(t/3)
	
	c=flr(
		     (x+sin(y/30+sin(t/5)*5)*6*s)/(24 * (s-1.8)) 
		    +y/(48 * (s-1.8))
		    +4*t
	  )
	  + cos(x/(32)+cos(y/64)*sin(t/6)*(0.1)) * sin(y/48-t+sin(y/128)*1)
	c=c%8+8

	if rnd(1)<1.25*s then
		c-=8
	end
	
	circ(x,y,1,c)
end

flip() goto ★
