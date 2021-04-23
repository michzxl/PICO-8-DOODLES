

function _init()
	t = -1/30

	
	pal(7,7,1)
	pal(15,1,1)

	lines = {
		"rend.",
		"tear it down.",
		"say something.",
		"i feel it",
		"please just",
		"may i?",
		"break this",
		"a last time",
		"loathing.",
		"vessel. empty",
		"saturate",
		"rend."
	}
	currline = 0
	currtext = ""
	currtimer = 0
	currspd = 3
	overtime = 0.8
	isover = false
	over = 0
	wait = 0.6

	oscalex = 0.9
	oscaley = 1

	next_line()
end

function next_line()
	currline = currline + 1
	currline = (currline-1)%#lines+1
	currtext = lines[currline]
	currtimer = 0
	side = rnd(1)<0.5

	for i=0,24 do
		mset(i,0,0)
	end
	for i=1,#currtext do
		local char = sub(currtext,i,i)
		if char~=" " then
			local sid = ords(char) + (p_font_index or 0)
			if char=="a" then
				sid = 58
			end
			mset(i-1,0,sid)
		else
			mset(i-1,0,59)
		end
	end
end

function _update()
	--cls(0)
	t += 1/30

	currtimer += 1/30
	if (currtimer-overtime-wait)*currspd>#currtext then
		next_line()
	end
	isover = currtimer*currspd>#currtext+wait
	over = max(0,currtimer*currspd - #currtext - wait)

	local scalex,scaley = oscalex,oscaley

	scalex,scaley = scalex + 0.1*mid(0,1,currtimer*currspd/#currtext-wait), scaley + 0.1*mid(0,1,currtimer*currspd/#currtext-wait)

	

	local ang = 0.1
	local rad = 8

	local w = 16
	local wp = w*8

	local split = 8 * (currtimer * currspd)

	---=========---

	local num = 50
	local bk = 8
	local hx = 1.5
	local hy = 1.5
	for i=1,num do
		local ox=rnd(128+bk)-8
		local oy=rnd(128+bk)-8
		--ox,oy = ox\8*8,oy\8*8

		for y=oy,oy+bk-1,hy do
			for x=ox,ox+bk-1,hx do
				pset(x,y,0)
			end
		end
	end

	

	---=========---

	rad *= scaley
	ang = ang

	local p1 = vec(8,64)
	local p2 = p1 + vec(wp*scalex-1,8*scaley-1)

	local mid1 = vec(p1.x + split*scalex,p1.y)
	local mid2 = vec(p1.x + split*scalex,p2.y)

	local glitch1 = true

	local rect1 = {
		(isover or glitch1) 
			and vec(
				  p1.x   + 16 + rnd(2)-1 - over*8
				, p1.y   - 48 + rnd(2)-1 - over*8
			) 
			or vec(p1.x,p1.y),
		(isover or glitch1)
			and vec(
				  mid2.x + 16 + rnd(2)-1
				, p1.y   - (true and 64/#currtext or 64) + rnd(2)-1
			) 
			or vec(mid2.x,p1.y),
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
	local cen = vec(0,126)
	cen.x += (rect1[2] - rect1[1]).x

	-- why is this in 2 for loops?
	-- only god knows
	for p in all(rect1) do
		local np = p - pivot
		p:set(rotate(np,0) + cen)
	end
	for p in all(rect2) do
		local np = p - pivot
		p:set(rotate(np,-ang) + cen)
	end

	-- try it
	--fillp(0b1010010110100101.1)

	local dd = rnd(1)<0.9
	local arclen = ang*(2*3.1415)*(8*scaley+rad)
	arclen = ceil(arclen)
	local anga = abs(ang)
	for a=0,-anga,-ang/arclen/4 do
		a += 1/4.2*sgn(ang)
		local p1 = vec.frompolar(a,rad) + cen
		local p2 = vec.frompolar(a,rad + 8*scaley-1) + cen
		--line(p1.x,p1.y,p2.x,p2.y,1)
		--pset(p1.x,p1.y,1)
		--pset(p2.x,p2.y,1)
		if (dd) tline(p2.x,p2.y,p1.x,p1.y,split/8,0,0,0.125* (1/scaley))
	end

	fillp()

	
	if (true) then 
		local fill = rnd(36000)
		--fill = fill | 0b1010010110100101
		fillp(fill)
		polyfill({
				vec(0,0),
				rect1[1],
				rect1[4],
				vec(0,127)
			},
			vec(0,0),
			1
		)
		fillp()
	end
	-- if isover then
	-- 	line(rect1[1].x,rect1[1].y,0,0,7)
	-- 	-- line(rect1[2].x,rect1[2].y,127,0,7)
	-- 	-- line(rect1[3].x,rect1[3].y,127,127,7)
	-- 	line(rect1[4].x,rect1[4].y,0,127,7)
	-- end

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

	if isover\1==1 then
		stop()
	end
end

function fflr(a,u)
	return a\u*u
end

function rotate(p,ang)
	local a,r = p:ang(),p:magn()
	a += ang
	return vec.frompolar(a,r)
end

function makeset(tbl)
	set={}
	for key,elem in pairs(tbl) do
		set[elem]=key
	end
	return set
end

puncts={
	'.', ',', '\"', "!", "#", 
	"-", "_", "=", "+", "?", 
	":", ";", "/", "\\", "(", ")", 
	"[", "]", "<", ">", "`", "|"
}
punctset=makeset(puncts)
function ords(c)
	o=ord(c)
	if ord('a')<=o and o<=ord('z') then
		return o - ord('a')
		-- A-Z : 0-25
	elseif ord('0')<= o and o<=ord("9") then
		return o - ord('0') + 26
		-- 0-9 : 26-35
	elseif punctset[c]>=1 then
		return 36 + punctset[c] - 1
		-- punct : 36-whatever
	else
		return 56 -- `NOT FOUND` ~ i.e. a ? in a box
	end
end

function replace_char(s,c,p)
	if sub(s,p,p)=="\n" or sub(s,p,p)==" " then return s end
	return sub(s,1,p-1) .. c .. sub(s,p+1,#s)
end

function quadv(a,b,c,d,col)
	line(a.x,a.y,b.x,b.y,col)
	line(b.x,b.y,c.x,c.y,col)
	line(c.x,c.y,d.x,d.y,col)
	line(d.x,d.y,a.x,a.y,col)
end

function polyfill(points,cen,col)
	local xl,xr,ymin,ymax={},{},129,0xffff
	for k,v in ipairs(points) do
		local p1, p2 = v + cen, points[k%#points+1] + cen
		local x1,y1,x2,y2,x_array=p1.x,flr(p1.y),p2.x,flr(p2.y),xr
		if y1 == y2 then
			xl[y1],xr[y1]=min(xl[y1] or 32767,min(x1,x2)),max(xr[y1] or 0x8001,max(x1,x2))
		else
			if (y1>y2) then x_array,y1,y2,x1,x2=xl,y2,y1,x2,x1 end
			for y=y1,y2 do
				x_array[y]=flr(x1+(x2-x1)*(y-y1)/(y2-y1))
			end
		end
		ymin,ymax=min(y1,ymin),max(y2,ymax)
	end
	for y=ymin,ymax do
		rectfill(xl[y],y,xr[y],y,col)
	end
end