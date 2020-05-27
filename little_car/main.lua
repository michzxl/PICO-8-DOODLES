function _init()
	init_packages()
	time = 0
	ang = 0
	x, y = 64, 64
	spd = 1
	cls()
end

function _update60()
	input_turn()
	input_forward()
	nang = round(ang, 1 / 16)
	time = time + 1 / 60
end

sqrt2 = sqrt(2)
sqr=function(a) return a*a end

function _draw()
	for i = 1, 250 do
		x1, y1 = rnd(128), rnd(128)
		d=sqrt(sqr(x1-x)+sqr(y1-y))
		a=atan2(x1-x,y1-y)
		f=d/32
		x2,y2=x1-f*cos(a),y1-f*sin(a)
		p=pget(x2,y2)
		circ(x1, y1, 1, p)
	end

	stackspr(0, 0, 1, 6, x, y, nang, 1, 1, 1)
end