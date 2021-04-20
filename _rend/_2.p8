pico-8 cartridge // http://www.pico-8.com
version 30
__lua__

_const_a = 1007/1024
_const_b = 441/1024
_const_c = 5/128

vec = {
	frompolar = function(ang,r)
		return vec(r*cos(ang), r*sin(ang))
	end,
	unit=function(rot)
		return 
			vec(1,0,0),
			vec(0,1,0),
			vec(0,0,1)
	end,

	ZERO = 0.001,

	copy = function(self)
		return vec(self.x,self.y,self.z)
	end,

	polar = function(self)
		return self:ang(), #self
	end,
	ang = function(self)
		return atan2(self.x,self.y)
	end,
	r = function(self)
		return #self
	end,
	turn = function(self, ang)
		local v = self:copy()
		v:setang(self:ang() + ang)
		return v
	end,

	setc=function(self, x, y, z)
		self.x=x or 0
		self.y=y or 0
		self.z=z or 0
		return self
	end,
	set=function(self,v)
		self.x=v.x or 0
		self.y=v.y or 0
		self.z=v.z or 0
	end,
	setang = function(self,ang)
		return self:setpolar(ang, #self)
	end,
	setr = function(self, r)
		self:setpolar(self:ang(), r)
	end,
	setpolar = function(self, ang, r)
		return self:setc(r*cos(ang), r*sin(ang))
	end,

	magn = function(self)
		return #self
	end,
	sqrmagn = function(v)
		return v.x*v.x + v.y*v.y + v.z*v.z
	end,

	-- https://www.flipcode.com/archives/Fast_Approximate_Distance_Functions.shtml
	-- is only 2D
	approx_magn = function(v)
		local mmin = min(v.x,v.y)
		local mmax = max(v.x,v.y)
		return _const_a*mmax + _const_b*mmin
			- (mmax < 16*mmin and _const_c*mmax or 0)
	end, 

	norm=function(self, len)
		len = len or 1
		if self:nearzero(vec.ZERO) then
			return vec()
		else 
			return self/#self * len
		end
	end,
	perp = function(self, len)
		return vec(-self.y, self.x):norm(len)
	end,
	perpl=function(self)
		return vec(-self.y,self.x)
	end,
	cross = function(A, B)
		return vec(
			A.y*B.z - A.z*B.y,
			A.z*B.x - A.x*B.z,
			A.x*B.y - A.y*B.x
		)
	end,
	dot = function(v,w)
		return v.x*w.x + v.y*w.y + v.z*w.z
	end,
	cmult = function(a,b)
		return vec(
			a.x*b.x,
			a.y*b.y,
			a.z*b.z
		)
	end,
	nonzero = function(self,unit)
		return not (self.x==0 and self.y==0 and self.z==0)
	end,
	nearzero = function(self,dist)
		return #self<dist
	end,

	constrain = function(self,anchor,dist)
		return (self - anchor):norm(dist) + anchor
	end,
	constrain_min = function(self,anchor,dist)
		local v = self - anchor
		return #v<dist and self:constrain(anchor,dist) or self
	end,
	constrain_max = function(self,anchor,dist)
		local v = self - anchor
		return #v>dist and self:constrain(anchor,dist) or self
	end,

	xy = function(self)
		return self.x,self.y
	end,
	-- yz = function(self)
	-- 	return self.y,self.z
	-- end,
	-- xz = function(self)
	-- 	return self.x,self.z
	-- end,
	xyz=function(self)
		return self.x,self.y,self.z
	end,
	cx=function(self)
		return vec(self and self.x or 1,0,0)
	end,
	cy=function(self)
		return vec(0,self and self.y or 1,0)
	end,
	cz=function(self)
		return vec(0,0,self and self.z or 1)
	end,
	distr = function(self,f)
		return vec(
			f(self.x),
			f(self.y),
			f(self.z)
		)
	end,
	zip = function(self,v,f)
		return vec(
			f(self.x,v.x),
			f(self.y,v.y),
			f(self.y,v.y)
		)
	end,
	fflr = function(self, unit)
		return self:distr(function(a) 
			return fflr(a, unit or 1)
		end)
	end,
	fflrz = function(self, unit)
		local signs = self:distr(sgn)
		local fv = self:distr(abs):fflr(unit)
		return fv:cmult(signs)
	end,
	rot_x = function(v, ang)
		return vec(
			v.x, 
			v.y * cos(ang) - v.z * sin(ang), 
			v.y * sin(ang) + v.z * cos(ang)
		)
	end,
	
	rot_y = function(v, ang)
		return vec(
			v.z * sin(ang) + v.x * cos(ang), 
			v.y, 
			v.z * cos(ang) - v.x * sin(ang)
		)
	end,
	
	rot_z = function(v, ang)
		return vec(
			v.x * cos(ang) - v.y * sin(ang), 
			v.x * sin(ang) + v.y * cos(ang), 
			v.z
		)
	end,

	rot_yxz = function(v, a)
		local nv = v:copy()
		nv = vec.rot_y(nv, a.y)
		nv = vec.rot_x(nv, a.x)
		nv = vec.rot_z(nv, a.z)
		return nv
	end,

	u_rot_yxz = function(angs)
		local cx,sx,cy,sy,cz,sz = angs:cache_trig()
		local x,y,z = angs:xyz()
		local ux = vec(
			cy*cz - sy*sx*sz,
			cy*sz + sy*sx*cz,
			-sy*cx
		)
		local uy = vec(
			-cx*sz,
			cx*cz,
			sx
		)
		local uz = vec(
			sy*cz + cy*sx*sz,
			sy*sz - cy*sx*cz,
			cy*cx
		)
		return ux,uy,uz
	end,

	rrot = function(v, config, a)
		local nv = v:copy()
		for i=1,#config do
			local func = self["rot_"..sub(config, i,i)]
			nv = func(nv, a[i])
		end
		return nv
	end,

	cache_trig = function(angs)
		return 
			cos(angs.x),sin(angs.x),
			cos(angs.y),sin(angs.y),
			cos(angs.z),sin(angs.z)
	end,
}

_vec={
	__index=vec,
	__add=function(p1,p2)
		return vec(p1.x+p2.x,p1.y+p2.y,p1.z+p2.z)
	end,
	__sub=function(p1,p2)
		return vec(p1.x-p2.x,p1.y-p2.y,p1.z-p2.z)
	end,
	__mul=function(p,a)
		return vec(p.x*a,p.y*a,p.z*a)
	end,
	__div=function(p,a)
		return vec(p.x/a,p.y/a,p.z/a)
	end,
	__unm=function(p)
		return vec(-p.x,-p.y,-p.z)
	end,
	__len=function(p)
		return sqrt(sqr(p.x)+sqr(p.y)+sqr(p.z))
	end,
	__tostring=function(self)
		return "<"..flr(10*self.x)/10 ..","..flr(10*self.y)/10 ..","..flr(10*self.z)/10 ..">"
	end,
}

setmetatable(vec, {
	__call = function(self,x,y,z)
		return setmetatable({
			x=x or 0,
			y=y or 0,
			z=z or 0,
		}, _vec)
end})

function sqr(a) return a*a end


-- ---@alias sprite_id integer

-- ---@param n sprite_id
-- ---@param x number
-- ---@param y number
-- ---@param w number
-- ---@param bx map_buffer_x
-- ---@param by map_buffer_y
-- function tspr(n, x, y, w, h, bx, by, ps)
-- 	-- allow variable widths?
-- 	-- 	x-widths < 8 already possible.
-- 	-- no rotation yet.

-- 	ps = ps or {}
-- 	local shx_0,shy_0,scx,scy =
-- 		ps.shx_0  or 0,
-- 		ps.shy_0  or 0,
-- 		ps.scx    or 1, ps.scy or 1

-- 	local w,h=8,8

-- 	mset(bx,by,n)
-- 	local mdx, ssy, ydir, nh = 0.125/scx, (ps.scale_shear and scy or 1), sgn(scy), scy*h
-- 	for dy=0,nh+ydir,ydir do
-- 		local xm = ((ps.shx_1 or 0)-shx_0)*(ps.scale_shear and scx or 1)*dy/nh + shx_0
-- 		tline(
-- 			x + xm,
-- 			y + dy + ydir*shy_0*ssy,
-- 			x + xm + scx*w-1,
-- 			y + dy + ydir*(ps.shy_1  or 0)*ssy,
-- 			bx,
-- 			by + dy/h/scy,
-- 			mdx * sgn(scx)
-- 		)
-- 	end
-- end

function tsprrect(x,y,sw_rot,mx,my,w,h)
	local dx, dy, r, cs, ss = 0, 0, max(w,h)/2, cos(sw_rot), -sin(sw_rot)
	if w>h then dy = (w-h)/2 else dx = (h-w)/2 end
	local ssx, ssy, cx, cy = mx - 0.3 -dx, my - 0.3 -dy, mx+r-dx, my+r-dy

	ssy -=cy
	ssx -=cx

	local delta_px = max(-ssx,-ssy)*8

	--this just draw a bounding box to show the exact draw area
	rect(x-delta_px,y-delta_px,x+delta_px,y+delta_px,5)

	local sx, sy =  cs * ssx + cx, -ss * ssx + cy

	for py = y-delta_px, y+delta_px do
		 tline(x-delta_px, py, x+delta_px, py, sx + ss * ssy, sy + cs * ssy, cs/8, -ss/8)
		 ssy+=1/8
	end
end

function tsprsqr(x,y,sw_rot,mx,my,r)    
	local cs, ss = cos(sw_rot), -sin(sw_rot)    
	local ssx, ssy, cx, cy = mx - 0.3, my - 0.3, mx+r/2, my+r/2

	ssy -=cy
	ssx -=cx

	local delta_px = -ssx*8

	--thst draw a bounding box to show the exact draw area
	rect(x-delta_px,y-delta_px,x+delta_px,y+delta_px,5)

	local sx, sy =  cs * ssx + cx, -ss * ssx + cy

	for py = y-delta_px, y+delta_px do
		 tline(x-delta_px, py, x+delta_px, py, sx + ss * ssy, sy + cs * ssy, cs/8, -ss/8)
		 ssy+=1/8
	end
end

function tquad(xa, ya, xb, yb, xc, yc, xd, yd, mx, my, w, h)
	w=sgn(w)*(abs(w)-0x0.0001)
	h=sgn(h)*(abs(h)-0x0.0001)
	local sxa, sya = mx, my
	local sxb, syb = mx+w, my
	local sxc, syc = mx+w, my+h
	local sxd, syd = mx, my+h

	while ya>yb or ya>yc or ya>yd do
		xa, ya, sxa, sya, xb, yb, sxb, syb, xc, yc, sxc, syc, xd, yd, sxd, syd = xb, yb, sxb, syb, xc, yc, sxc, syc, xd, yd, sxd, syd, xa, ya, sxa, sya
	end

	local x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6 = xa, ya
	local sx1, sy1, sx2, sy2, sx3, sy3, sx4, sy4, sx5, sy5, sx6, sy6 = sxa, sya
	local d

	if yc >= yb and yc >= yd then
		x6, y6, sx6, sy6 = xc, yc, sxc, syc

		if yb <= yd then
			x2, y2, sx2, sy2 = xb, yb, sxb, syb
			x4, y4, sx4, sy4 = xd, yd, sxd, syd

			d = (yb-ya)/(yd-ya)
			x3 = xa + d*(xd-xa)
			sx3 = sxa + d*(sxd-sxa)
			sy3 = sya + d*(syd-sya)

			d = (yd-yb)/(yc-yb)
			x5 = xb + d*(xc-xb)
			sx5 = sxb + d*(sxc-sxb)
			sy5 = syb + d*(syc-syb)
		else
			x2, y2, sx2, sy2 = xd, yd, sxd, syd
			x4, y4, sx4, sy4 = xb, yb, sxb, syb

			d = (yd-ya)/(yb-ya)
			x3 = xa + d*(xb-xa)
			sx3 = sxa + d*(sxb-sxa)
			sy3 = sya + d*(syb-sya)

			d = (yb-yd)/(yc-yd)
			x5 = xd + d*(xc-xd)
			sx5 = sxd + d*(sxc-sxd)
			sy5 = syd + d*(syc-syd)
		end
	else
		if yb >= yd then
			x6, y6, sx6, sy6 = xb, yb, sxb, syb

			x2, y2, sx2, sy2 = xd, yd, sxd, syd
			x5, y4, sx5, sy5 = xc, yc, sxc, syc

			d = (yd-ya)/(yb-ya)
			x3 = xa + d*(xb-xa)
			sx3 = sxa + d*(sxb-sxa)
			sy3 = sya + d*(syb-sya)

			d = (yc-ya)/(yb-ya)
			x4 = xa + d*(xb-xa)
			sx4 = sxa + d*(sxb-sxa)
			sy4 = sya + d*(syb-sya)
		else
			x6, y6, sx6, sy6 = xd, yd, sxd, syd

			x2, y2, sx2, sy2 = xb, yb, sxb, syb
			x5, y4, sx5, sy5 = xc, yc, sxc, syc

			d = (yb-ya)/(yd-ya)
			x3 = xa + d*(xd-xa)
			sx3 = sxa + d*(sxd-sxa)
			sy3 = sya + d*(syd-sya)

			d = (yc-ya)/(yd-ya)
			x4 = xa + d*(xd-xa)
			sx4 = sxa + d*(sxd-sxa)
			sy4 = sya + d*(syd-sya)
		end
	end

	if y1<y2 then
		local yk2, xk2, xk3 = y2-y1, x2-x1, x3-x1
		local sxk2, sxk3 = sx2-sx1, sx3-sx1
		local syk2, syk3 = sy2-sy1, sy3-sy1

		for yy = y1, y2 do
			local n = (yy-y1)/yk2

			local xx2 = x1+n*xk2
			local xx3 = x1+n*xk3
			local d = abs(xx3-xx2)

			local sxx2 = sx1+n*sxk2
			local syy2 = sy1+n*syk2
			local sxx3 = sx1+n*sxk3
			local syy3 = sy1+n*syk3

			tline(xx2, yy, xx3, yy, sxx2, syy2, (sxx3-sxx2)/d, (syy3-syy2)/d)
		end
	end

	local yk4, xk4, xk5 = y4-y2, x4-x3, x5-x2
	local sxk4, sxk5 = sx4-sx3, sx5-sx2
	local syk4, syk5 = sy4-sy3, sy5-sy2

	for yy = y2, y4 do
		local n = (yy-y2)/yk4

		local xx4 = x3+n*xk4
		local xx5 = x2+n*xk5
		local d = abs(xx5-xx4)

		local sxx4 = sx3+n*sxk4
		local syy4 = sy3+n*syk4
		local sxx5 = sx2+n*sxk5
		local syy5 = sy2+n*syk5

		tline(xx4, yy, xx5, yy, sxx4, syy4, (sxx5-sxx4)/d, (syy5-syy4)/d)
	end


	local yk6 = y6-y4

	if yk6 == 0 then return end

	local xk4, xk5 = x6-x4, x6-x5
	local sxk4, sxk5 = sx6-sx4, sx6-sx5
	local syk4, syk5 = sy6-sy4, sy6-sy5

	for yy = y4, y6 do
		local n = (yy-y4)/yk6

		local xx4 = x4+n*xk4
		local xx5 = x5+n*xk5
		local d = abs(xx5-xx4)

		local sxx4 = sx4+n*sxk4
		local syy4 = sy4+n*syk4
		local sxx5 = sx5+n*sxk5
		local syy5 = sy5+n*syk5

		tline(xx4, yy, xx5, yy, sxx4, syy4, (sxx5-sxx4)/d, (syy5-syy4)/d)
	end
end

function ttri(xa, ya, xb, yb, xc, yc, sxa, sya, sxb, syb, sxc, syc)
	if ya > yb then
		xa, ya, sxa, sya, xb, yb, sxb, syb = xb, yb, sxb, syb, xa, ya, sxa, sya
	end

	if ya > yc then
		xa, ya, sxa, sya, xc, yc, sxc, syc = xc, yc, sxc, syc, xa, ya, sxa, sya
	end

	if yb > yc then
		xb, yb, sxb, syb, xc, yc, sxc, syc = xc, yc, sxc, syc, xb, yb, sxb, syb
	end

	local ykb, ykc = yb-ya, yc-ya
	local xkb, xkc = xb-xa, xc-xa
	local sykb, sykc = syb-sya, syc-sya
	local sxkb, sxkc = sxb-sxa, sxc-sxa

	if ya<yb then
		for y = ya, yb do
			local nb = (y-ya)/ykb
			local nc = (y-ya)/ykc

			local x0, x1 = xa + nb*xkb, xa + nc*xkc
			local d = abs(x1-x0)

			local sx0, sx1 = sxa + nb*sxkb, sxa + nc*sxkc
			local sy0, sy1 = sya + nb*sykb, sya + nc*sykc

			tline(x0, y, x1, y, sx0, sy0, (sx1-sx0)/d, (sy1-sy0)/d)
		end
	end

	ykb = yc-yb
	xkb = xc-xb
	sykb = syc-syb
	sxkb = sxc-sxb

	if yb<yc then
		for y = yb, yc do
			local nb = (y-yb)/ykb
			local nc = (y-ya)/ykc

			local x0, x1 = xb + nb*xkb, xa + nc*xkc
			local d = abs(x1-x0)

			local sx0, sx1 = sxb + nb*sxkb, sxa + nc*sxkc
			local sy0, sy1 = syb + nb*sykb, sya + nc*sykc

			tline(x0, y, x1, y, sx0, sy0, (sx1-sx0)/d, (sy1-sy0)/d)
		end
	end
end





function _init()
	t = -1/30

	lines = {
		"rend.",
		"tear it open.",
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
	cls(0)
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

	local w = 12
	local wp = w*8

	local split = 8 * (currtimer * currspd)

	---=========---

	rad *= scaley
	ang = ang

	local p1 = vec(8,64)
	local p2 = p1 + vec(wp*scalex-1,8*scaley-1)

	local mid1 = vec(p1.x + split*scalex,p1.y)
	local mid2 = vec(p1.x + split*scalex,p2.y)

	local glitch1 = rnd(1) < 0.0

	local rect1 = {
		(isover or glitch1) 
			and vec(
				  p1.x   + 48 + rnd(4)-2 - over*8
				, p1.y   - 48 + rnd(4)-2 - over*8
			) 
			or vec(p1.x,p1.y),
		(isover or glitch1)
			and vec(
				  mid2.x + 32 + rnd(4)-2
				, p1.y   - (over-wait>overtime/4 and 64/#currtext or 64) + rnd(4)-2
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

	
	if (isover) then 
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



__gfx__
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11177111177777111177771117777111177777711777777111777711177117711777777111111771177117711771111117711171177117711777777117777711
11777711177117711771177117717711177111111771111117711771177117711117711111111771177177111771111117771771177717711771177117711771
17711771177777111771111117711771177777111777771117711111177117711117711111111771177771111771111117777771177777711771177117711771
17711771177117711771111117711771177111111771111117717771177777711117711111111771177771111771111117717171177777711771177117777711
17777771177117711771177117717711177777711771111117711771177117711117711117711771177177111771111117711171177177711771177117711111
17711771177777111177771117777111177777711771111111777771177117711777777111777711177117711777777117711171177117711777777117711111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11777711177777111177777117777771177117711771177117711171177117711771177117777771117777111117711111777711117777111111771117777771
17711771177117711777111111177111177117711771177117711171177117711771177111117711177117711177711117711771171117711117771117711111
17711771177117711177771111177111177117711771177117711171111771111177771111177111177177711117711111117711111777111177771117777711
17717771177777111111177111177111177117711777777117717171111771111117711111771111177717711117711111177111111117711770771111111771
17777711177177711111177111177111177117711177771117777771177117711117711117711111177117711117711111771111177117711777777117711771
11771771177117711777771111177111117777111117711117771771177117711117711117777771117777111177771117777771117777111111771111777711
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11777711177777711177771111777711111111111111111111717111111771111171171111111111111111111111111111111111117777111117711111177111
17711111111117711771177117711771111111111111111111717111111771111777777111111111111111111111111111171111177117711117711111177111
17777711111177111177771111777771111111111111111111111111111771111170071111111111111111111177771111171111111177111111111111111111
17711771111771111771177111111771111111111111111111111111111771111170071117777771111111111111111117777711111771111111111111111111
17711771111771111771177111117711111771111117711111111111111111111777777111111111111111111177771111171111111111111117711111177111
11777711111771111177771111777111111771111117711111111111111771111171171111111111177777711111111111171111111771111117711111177111
11111111111111111111111111111111111111111177111111111111111111111111111111111111111111111111111111111111111111111111111111771111
11111111111111111177111111117711117777111117777111117711117711111a1a1a1a11111111111111111111111111111111111111111111111111111111
1111117117111111177111111111177111771111111117711117711111177111a077770117777771111771111111111111111111111111111111111111111111
11111711117111111771111111111771117711111111177111771111111177111770077a17777771117777111111111111111111111111111111111111111111
1111711111171111177111111111177111771111111117711771111111111771a000770117777771177117711111111111111111111111111111111111111111
11171111111171111771111111111771177111111111771117711111111117711007700a17777771177117711111111111111111111111111111111111111111
1171111111111711177111111111177117711111111177111177111111117711a000000117777771177777711111111111111111111111111111111111111111
17111111111111711771111111111771177111111111771111177111111771111007700a17777771177117711111111111111111111111111111111111111111
1111111111111111117711111111771117777111117777111111771111771111a1a1a1a111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
__map__
0d0e3b0b0e150400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
