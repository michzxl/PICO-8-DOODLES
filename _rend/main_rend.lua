

function _init()
	dt = 1/30
	t = -dt
end

function _update()
	cls(0)
	t += dt

	local ang = 0+0.501*sin(t/24)
	local rad = 0

	local scalex = 2
	local scaley = 2

	local w = 7
	local wp = w*8

	split = wp/2 + wp/4*sin(t/12)

	-------

	rad *= scaley
	ang = ang
	
	

	local p1 = vec(8,64)
	local p2 = p1 + vec(wp*scalex-1,8*scaley-1)

	local mid1 = vec(p1.x + split*scalex,p1.y)
	local mid2 = vec(p1.x + split*scalex,p2.y)

	local rect1 = {
		vec(p1.x,p1.y),
		vec(mid2.x,p1.y),
		vec(mid2.x,mid2.y),
		vec(p1.x,mid2.y),
	}

	local rect2 = {
		vec(mid1.x,mid1.y),
		vec(p2.x,mid1.y),
		vec(p2.x,p2.y),
		vec(mid1.x,p2.y),
	}

	local pivot
	if ang<0 then
		pivot = rect1[2] - vec(0,rad)
	else
		pivot = rect1[3] + vec(0,rad)
	end
	local cen = vec(64,64)
	if ang<=0 then
		cen -= vec(0,8*scaley/2+rad-1)
	else
		cen += vec(0,8*scaley/2+rad-1)
	end

	-- why is this in 2 for loops?
	-- only god knows
	for p in all(rect1) do
		local np = p - pivot
		p:set(rotate(np,ang/2) + cen)
	end
	for p in all(rect2) do
		local np = p - pivot
		p:set(rotate(np,-ang/2) + cen)
	end

	-- try it
	--fillp(0b1010010110100101.1)

	local arclen = ang*(2*3.1415)*(8*scaley+rad)
	arclen = ceil(arclen)
	local anga = abs(ang)
	for a=-anga/2-0.01,anga/2-0.01,ang/arclen/4 do
		a += 1/4.2*sgn(ang)
		local p1 = vec.frompolar(a,rad) + cen
		local p2 = vec.frompolar(a,rad + 8*scaley-1) + cen
		--line(p1.x,p1.y,p2.x,p2.y,1)
		--pset(p1.x,p1.y,1)
		--pset(p2.x,p2.y,1)
		--tline(p1.x,p1.y,p2.x,p2.y,split/8,0,0,1/8/scaley)
	end

	fillp()

	tquad(
		rect1[1].x,rect1[1].y,
		rect1[2].x,rect1[2].y,
		rect1[3].x,rect1[3].y,
		rect1[4].x,rect1[4].y,
		0,0,
		split/8,1
	)

	tquad(
		rect2[1].x,rect2[1].y,
		rect2[2].x,rect2[2].y,
		rect2[3].x,rect2[3].y,
		rect2[4].x,rect2[4].y,
		split/8,0,
		w - split/8,1
	)
end

function fflr(a,u)
	return a\u*u
end

function rotate(p,ang)
	local a,r = p:ang(),p:magn()
	a += ang
	return vec.frompolar(a,r)
end
