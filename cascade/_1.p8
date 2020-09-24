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

for i=1,1000 do
   x,y = rnd(128),rnd(128)
	local contour = sin(x/64) + sin(y/64) + t
	local diff = contour - flr(contour)

	local c = 0
	if diff<0.1 then
		c = 7
	end

   circ(x,y,1,c)
end

flip() goto ♥
