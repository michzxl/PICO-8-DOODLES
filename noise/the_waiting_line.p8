pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
t=0
█=1000
function sqr(a) return a*a end
cls()
::♥::
t+=0.0333

for i=1,1500 do
	local y=rnd(128)-64
	local x=rnd(128)-64

	local fill = nil
	
	local c=x/16+sin((y)/200)
	c=c+abs(sin(t/16))*flr(x/60+y/64)
	c=c+sin(x/128)
	c=c+t
	
	c=c%8+8
	c=c%2

	local diff = c - flr(c)
	c = flr(c) * 7
	if diff<0.2 then
		fill = 0b1111000011110000
		c = 0x67
	end
	
	fillp(fill)
	circ(x+64,y+64,1,c)
	fillp()
end

flip() goto ♥
