function _init()
	init_stalks()

	load_cartdata()

	menuitem(1, "toggle debug", toggle_debug)
end

function toggle_debug()
  debug = not debug
  dset(0, (dget(0) + 1) % 2)
end

function _update60()
	if btnp(d.z) or btn(d.x) then
		flora.arr={}
		init_stalks()
	end
end

function _draw()
	cls()

	rectfill(0,0,128,128,clr.navy) --sky
	rectfill(0,121,128,128,clr.dark_green) --ground

	if debug then draw_debug() end

	for plant in all(flora.arr) do
		local plant_type = plant[1].type
		flora[plant_type].drw(plant)
	end
end

function load_cartdata()
  cartdata("cab2_micheal")
  debug = (dget(0) == 1)
end

function draw_debug()
  color((stat(7) < stat(8)) and 8 or 7)
  print("" .. stat(7) .. "/" .. stat(8))
  color((stat(1) > 0.999) and 8 or 7)
  print("cpu: " .. stat(1)*100 .. "% / fps")
  color((stat(0) >= 2048) and 8 or (stat(0) >= 1024 and 9 or 7))
  print("mem:" .. flr(stat(0)) .. "/" .. "2048 kIb (" .. flr(stat(0))/2048*100 .. "%)")
end

function init_stalks()
	local num = 20
	local interval = 128/num
	for i=1,num do
		flora.stalk.new(interval*i - interval/2,120,2,8,20,100)
	end
end

--static numeric codes for PICO-8 input
--also used to indicate direction
d = {
  l = 0, left  = 0, 
  r = 1, right = 1,
  u = 2, up    = 2,
  d = 3, down  = 3,
  o = 4, z     = 4,
  x = 5
}

--PICO-8 colors
clr = {
	black = 0,
	navy = 1,
	magenta = 2,
	dark_green = 3,
	brown = 4,
	dark_gray = 5,
	light_gray = 6,
	white = 7,
	red = 8,
	orange = 9,
	yellow = 10,
	green = 11,
	blue = 12,
	indigo = 13,
	pink = 14,
	peach = 15
}

function nop()
end

function chance(probability)
	return rnd(1) < probability
end

function ternary(cond, r1, r2)
	return cond and r1 or r2
end

--generates an integer between min and max. inclusive.
function rand_int(min, max)
	if max<min then 
		return -1 
	else
		return flr(rnd(max-min+1)) + min 
	end
end
