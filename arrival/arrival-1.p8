pico-8 cartridge // http://www.pico-8.com
version 30
__lua__
local dt=1/60
local t=0

local kk=128*128

local fills = {
	0b1111111111111111,
	0b0111111111111111,
	0b0111111111011111,
	0b0101111111011111,
	0b0101111101011111,
	0b0101101101011111,
	0b0101101101011110,
	0b0101101001011110,
	0b0101101001011010,
	0b0001101001011010,
	0b0001101001001010,
	0b0000101001001010,
	0b0000101000001010,
	0b0000001000001010,
	0b0000001000001000
}

function _init()
	pal(1,7,1)
	pal(2,0,1)

	cls()
end

function _update60()
	t+=dt

	for i=1,750 do
		local x = rnd(128)
		local y = rnd(128)

		local fill = fills[max(1,flr((
			x/320
			+ 0.3 * sin(t/8) 
			+ 0.05 * sin(x / (64 + 8*sin(t/8))) 
			+ (y-16) / 160
			- flr(x/16 + y/32)*sin(t/16)/16
			- flr(-x/32+y/32+t/8)%2/4
		)*(#fills)))]

		local c =
			x/64 * sin(y/147-t/4)
			+ (-x/32 + y/32)
		c %= 2

		fillp(fill)
		circ(x,y,1,c)
		fillp()
	end
end
