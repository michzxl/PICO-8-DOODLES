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

local ct8 = cos(t/8)
local st8 = sin(t/8)

for i=1,1000 do
   x,y = rnd(128),rnd(128)

	local contour = 
		sin(x/100 + t/8) + sin(y/500) 
		- sin(x/1200)*((cos(y/128-t/7) + 1) /2) + 2*cos(y/400)/((x + 64)/256)
		+ t

	local diff = contour - flr(contour)
	
	contour = flr(contour) + sin(x/256 - t/16) + sin(y/256) + t

	diff = diff + (2*sin(t/16)-1.75)*(contour - flr(contour))

	local c = 0
	if diff<0.1 then
		c = 7
	end

   circ(x,y,1,c)
end

flip() goto ♥
