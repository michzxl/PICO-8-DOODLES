pico-8 cartridge // http://www.pico-8.com
version 29
__lua__



t=0
dt=1/30
tf=0
sqrt2=sqrt(2)

cls()
::HOME::
t+=dt
tf+=1

for ox=0,128,40 do
	for oy=0,128,40 do
		ox = ox + oy\48%2 * (16 + 4*sin(t/8))
		local parity = (ox\40+oy\40)%2*2-1
		local mod = ox/300+oy/250
		for i=1,75 do
			local ang,r = rnd(1),rnd(18)
			local a = flr(ang*6+parity/2)%2
			local j = 4 + 2*sin(t/8)
			local ar = 16 * max(0,sin(ang+a/j+t/2+mod+parity))

			local c = r<ar and 7 or 0
			local x,y = r*cos(ang)+ox,r*sin(ang)+oy
			circfill(x,y,1,c)
		end
	end
end

flip() goto HOME