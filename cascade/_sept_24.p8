pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

dt=1/30
t=0
tf=0

cls()
::♥::
t+=dt
tf+=1

local ct8 = cos(t/16)
local st8 = sin(t/16)

for i=1,1000 do
   x,y = rnd(128),rnd(128)

	local contour = 
		sin(x/128) + sin(y/128) 
		+ (x-(64))\128*(ct8-1)%1+64
		+ t


	local diff = contour - flr(contour)

	local c = 0
	if diff<0.5+0.3*sin(t/8)+0.2*sin(y/128+t/4) then
		c = 7
	end

   circ(x,y,1,c)
end

flip() goto ♥
