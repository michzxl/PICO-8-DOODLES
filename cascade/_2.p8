pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

dt=1/30
t=-1

cls()
::♥::
cls()
t+=dt

for i=1,1000 do
   x,y = rnd(128),rnd(128)
	local contour = sin(x/256 + t/32) + sin(y/128 - t/16) + t
	contour = contour % t + t/8
	contour = contour + flr(x/64)%2*3
	local diff = contour - flr(contour)

	local c = 0
	if diff<0.1 then
		c = 7
	end

   line(x,y-2,x,y+2,c)
end

flip() goto ♥
