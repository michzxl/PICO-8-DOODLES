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

--defines some settings for different actors' animations, at each frame.
--the key/index is the frame each value applies to.
--	mov - distance to move, in pixels
--	turn - appropriate turning frame
--	stop - appropriate stopping frame
anims = {
	player = {
		still = {
			{sx=0,  sy=0, sw=11,  sh=19, ofs = 0} },
		moving = {
			{sx=11, sy=0, sw=11,  sh=19, ofs = 0, mov=1},
			{sx=22, sy=0, sw=11, sh=19, ofs = 0, mov=2, turn=true},
			{sx=33, sy=0, sw=11,  sh=19, ofs = 0, mov=2},
			{sx=44, sy=0, sw=11,  sh=19, ofs = 0, mov=1, stop=true},
			{sx=55, sy=0, sw=11, sh=19, ofs = 0, mov=1},
			{sx=66, sy=0, sw=11, sh=19, ofs = 0, mov=2, turn=true},
			{sx=77, sy=0, sw=11,  sh=19, ofs = 0, mov=2},
			{sx=88, sy=0, sw=11,  sh=19, ofs = 0, mov=1, stop=true} },
		crouch = {
			{sx=0, sy=19, sw=11,  sh=19, ofs = 0},
			{sx=11, sy=19, sw=11,  sh=19, ofs = 0},
			{sx=22, sy=19, sw=11,  sh=19, ofs = 0} }
	}
}