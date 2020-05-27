pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
p={10,9,9+128,8,8+128,2,2+128,
			2,8+128,8,9+128,9,}
for i=1,#p do
	pal(i,p[i],1)
end

t=0

cls()
::★::

t+=0.01

for i=1,1300 do
	x=rnd(128)
	y=rnd(128)
	s=sin(t/3)
	
	c=flr(
		     (x+sin(y/30+sin(t/5)*5)*6*s)/(24 * (s-1.8)) 
		    +y/(48 * (s-1.8))
		    +8*t
	  )
	c=c%(#p)+1
	c2=(c-1-1)%#p+1

	--if rnd(1)<0.75*s then
	--	c-=8
	--end
	
	fillp(0b1010101010101010)
	circ(x,y,1,c)
	fillp(0b1111000011110000.1)
	circ(x,y,1,c2)
end

print(stat(1),0,0,10)

flip() goto ★
