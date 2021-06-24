pico-8 cartridge // http://www.pico-8.com
version 30
__lua__


function _init()
	cls()

	t = -1/30

	poke(0x5f2d, 0b001)

	pal({
		[0]=3+128,
		0,
		1+128,
		9+128,--14+128,
		9,--15+128,
		2,
		3,
		10+128,
		1
	},1)

	pal(10,11+128,2)

	co = vec()
	ao = 0

	tt = {}
	for i=0,7-1 do

		local pos = vec(8 + i*16+rnd(4)-2, 8 + rnd(16))
		local w = vec(16,0)
		local h = vec((10+rnd(2)-1) * (rnd(1)<0.5 and 1 or -1),64+32+rnd(16)-4)
		local rect = {
			pos,
			pos + w,
			pos + w + h,
			pos + h
		}
		add(tt, rect)
	end
end

---=========---

function _update()
	-- cls()
	t += 1/30
	mx,my = stat(32),stat(33)

	local w = 5

	for i=1,45 do
		local x = rnd(128)\8*8
		local y = rnd(128)\8*8
		rectfill(x,y,x+7,y+7,0)
	end



	draw_interface(w)

	if t%8>6 then
		local s = ""..(t*500\8*8)
			.."\n"..(t*2000)..(t*30\5)
			.."\n"..(t*800\1)
			.."\n"..(t*2000)..(t*30\5)
			.."\n"..(t*2)..(t*30\5)
			.."\n"..(t*3000)..(t*30\5)
			.."\n"..(t*2000)..(888)
			.."\n"..(t*32000)..("00")
			.."\n"..(t*80)..(t*20)
			.."\n"..(t/80)..(t*30\5)
			.."\n"..(t*2000)..(t*30\5)
			.."\n"..(t*2)..(t*30\5)
			.."\n"..(t*800/6*t)..(t)
			.."\n"..(t*2000)..(t\1*32.6)
			.."\n"..(t*2\1)..(t*2)
			.."\n"..(t*8)..(t\1)
			.."\n"..(t/32)..(t*8\1)
			.."\n"..(t)..(t*30\5)
			.."\n"..(t*t*t*t)
		print(s,7,7,0)
		print(s,64,7,0)
	end

	circ(64+8*cos(t/8),64+8*sin(t/8),9,0)
	fillp(0b1010010110100101.1)
	circfill(64+8*cos(t/8),64+8*sin(t/8),44,1)
	fillp()
	circfill(64+8*cos(t/8),64+8*sin(t/8),40,1)
	circ(64+8*cos(t/8),64+8*sin(t/8),48,1)
	fillp(0b1100110000110011)
	circ(64+8*cos(t/8),64+8*sin(t/8),49,1)
	fillp()

	if rnd(1)<0.025 then
		co = vec(
			rnd(8)-4,
			rnd(8)-4
		)
	end

	if rnd(1)<0.1 then
		local a = 1/32
		ao = rnd(a) - a/2
	end

	if rnd(1)<0.25 then
		for i=0,7-1 do
			local _i = rnd(7)\1
			local pos = vec(3 + (_i)*16 + rnd(4)-2, 3 + rnd(16)) + vec(8*sin(t/8),8*cos(t/8))
			local w = vec(16+rnd(4)-2,0)
			local h = vec((10+rnd(2)-1) * (rnd(1)<0.5 and 1 or 1),64+32+rnd(16)-4)
			local rect = {
				pos,
				pos + w,
				pos + w + h,
				pos + h
			}
			tt[_i+1] = rect
		end
	end


	rectfill(0,0,w,127,2)
	rectfill(127-w,0,127,127,2)
	rectfill(0,0,127,w,2)
	rectfill(0,127-w,127,127,2)

	line(w,w,127-w,w,8)
	line(w,w,w,127-w,8)
	line(127-w,127-w,w,127-w,8)
	line(127-w,127-w,127-w,w,8)


	line(0,0,5,0,1)
	line(0,0,0,5,1)
	pset(1,1,1)
	pset(1,2,1)
	pset(2,1,1)

	line(127-0,0,127-5,0,1)
	line(127-0,0,127-0,5,1)
	pset(127-1,1,1)
	pset(127-1,2,1)
	pset(127-2,1,1)

	line(0,127-0,5,127-0,1)
	line(0,127-0,0,127-5,1)
	pset(1,127-1,1)
	pset(1,127-2,1)
	pset(2,127-1,1)

	line(127-0,127-0,127-5,127-0,1)
	line(127-0,127-0,127-0,127-5,1)
	pset(127-1,127-1,1)
	pset(127-1,127-2,1)
	pset(127-2,127-1,1)

	---===---

	for i=0,7-1 do
		local rect = tt[i+1]
		tquad(
			rect[1].x,rect[1].y,
			rect[2].x,rect[2].y,
			rect[3].x,rect[3].y,
			rect[4].x,rect[4].y,
			i,0,
			1,1
		)
	end

	draw_cross(vec(40-2,64+2) + co, 3)
	draw_cross(vec(40,64) + co, 4)
end

function draw_interface(w)
	local col = 1

	ui_bar(7,7,66,12,		1,-(웃|-∧),-t/2%1\0.1*0.1,"-x")
	ui_bar(7,89,12,32,	1,0b1010010110100101.1010010110100101,t%1,"-x")
	ui_bar(20,89,12,32,	1,0b1010010110100101.1010010110100101>><t,t%1,"+x")
	ui_bar(33,109,56,12,	1,flr(2*sin(t/4)) * (😐),t%1,"+y")
	ui_bar(33,90,18,18,	1,0b1010101010101010,sin(t/2),"-x")
	ui_bar(7,79,30,9,		1,-☉\1,sin(t/2),"-x")
	ui_bar(7,71,7,7,		1,-0b1010010110100101,1,"+x")

	ui_bar(7,20,16,50,	1,0b011100010000100001,t\0.25*0.25%1,"+y")
	ui_bar(90,101,32,20, 1,0b1010010110100101.1100110000110011>><t*8,t*4%1,"+y")

	ui_bar(90,w+2,31,10,	1,0b1010010110100101,0.5+0.5*sin(t/4),"-x")
	ui_bar(98,w+13,23,8,	1,0b1010010110100101,1 + 0.5*sin(t/8),"+x")
	ui_bar(74,7,15,32,	1,0b1000010000100001,t/2%1,"+y")
	ui_bar(90,18,7,8,		1,0b1010010110100101,0.5+0.5*sin(t/16),"+y")
	ui_bar(90,27,15,20,	1,0b1111000011110000,0.5+0.5*sin(t/2),"+x")
	ui_bar(106,27,15,48,	1,flr(2*sin(t/4)) * (♥),-t*2%1,"+y")
	ui_bar(106,76,15,8,	1,-ˇ\1,1,"+y")
	ui_bar(106,85,15,15,	1,-∧\1>><t*4,0.8,"+y")
end

function ui_bar(x,y,w,h,col,fill,per,side)
	rect(x,y,x+w-1,y+h-1,col)

	fillp(fill)

	local wa,ha = w-4,h-4

	if side=="+x" or side=="-x" then
		local p = wa*mid(0,0.99,per)
		if side=="+x" then
			rectfill(x+2,y+2,x+2+p,y+2+ha-1,col)
		else
			rectfill(x+2+p,y+2,x+1+wa,y+2+ha-1,col)
		end
	elseif side=="+y" or side=="-y" then
		local p = ha*mid(0,0.99,per)
		if side=="+y" then
			rectfill(x+2,y+2,x+1+wa,y+2+p)
		else
		end
	end

	fillp()
end

function draw_cross(cen, col)
	local col1 = col
	local col2 = col
	local col3 = 5
	local ang = 9/32 + 1/128*(sin(t/4)) + ao
	local len1 = 48
	local len2 = 28
	local thick1 = 4
	local thick2 = 4
	local inlen1 = 16 + min(0,4*sin(t/16))
	local inlen2 = 16 + min(0,4*sin(t/16))
	local bezres = 8
	local cen = cen
	local of1 = max(0,2*sin(t/4))
	local of2 = max(0,2*cos(t/4))

	---=========---

	local dir1 = vec.frompolar(ang,len1)
	local dir2 = vec.frompolar(ang + 0.25,len2)

	local ofs1 = dir2:norm(thick1/4+1+of1)
	local ofs2 = dir1:norm(thick1/4+1+of2)

	local d1p1l = cen + dir1 + ofs1
	local d1p2l = cen - dir1 - ofs1
	local d1c1l = cen + dir1:norm(inlen1) + ofs1
	local d1c2l = cen - dir1:norm(inlen1) - ofs1
	local d1p1r = cen + dir1 - ofs1
	local d1p2r = cen - dir1 + ofs1
	local d1c1r = cen + dir1:norm(inlen1) - ofs1
	local d1c2r = cen - dir1:norm(inlen1) + ofs1

	linefill(d1c1l.x, d1c1l.y, d1p1l.x, d1p1l.y, thick1/2, col1)
	linefill(d1c2l.x, d1c2l.y, d1p2l.x, d1p2l.y, thick1/2, col1)
	linefill(d1c1r.x, d1c1r.y, d1p1r.x, d1p1r.y, thick1/2, col1)
	linefill(d1c2r.x, d1c2r.y, d1p2r.x, d1p2r.y, thick1/2, col1)

	linefill(d1c1l.x, d1c1l.y, d1p1l.x, d1p1l.y, thick1/2, col1)
	linefill(d1c2l.x, d1c2l.y, d1p2l.x, d1p2l.y, thick1/2, col1)
	linefill(d1c1r.x, d1c1r.y, d1p1r.x, d1p1r.y, thick1/2, col1)
	linefill(d1c2r.x, d1c2r.y, d1p2r.x, d1p2r.y, thick1/2, col1)


	local d1p1l = cen + dir2 + ofs2
	local d1p2l = cen - dir2 - ofs2
	local d1c1l = cen + dir2:norm(inlen2) + ofs2
	local d1c2l = cen - dir2:norm(inlen2) - ofs2
	local d1p1r = cen + dir2 - ofs2
	local d1p2r = cen - dir2 + ofs2
	local d1c1r = cen + dir2:norm(inlen2) - ofs2
	local d1c2r = cen - dir2:norm(inlen2) + ofs2

	linefill(d1c1l.x, d1c1l.y, d1p1l.x, d1p1l.y, thick2/2, col1)
	linefill(d1c2l.x, d1c2l.y, d1p2l.x, d1p2l.y, thick2/2, col1)
	linefill(d1c1r.x, d1c1r.y, d1p1r.x, d1p1r.y, thick2/2, col1)
	linefill(d1c2r.x, d1c2r.y, d1p2r.x, d1p2r.y, thick2/2, col1)

	local b1 = dir1:norm()
	local b2 = dir2:norm()

	local dir1in = dir1:norm(inlen1)
	local dir2in = dir2:norm(inlen2)
	local ps = {}
	for i=0,bezres do
		local t = i/bezres
		local d1 = (dir1in*t)
		local d2 = (dir2in*(1 - t))

		add(ps, {
			lerp(dir1in*t,dir2in*(1-t),1-t) + dir1:norm(thick1/2+of2) + dir2:norm(thick2/2+of1),
			lerp(dir1in*-t,dir2in*(1-t),1-t) - dir1:norm(thick1/2+of2) + dir2:norm(thick2/2+of1),
			lerp(dir1in*t,dir2in*-(1-t),1-t) + dir1:norm(thick1/2+of2) - dir2:norm(thick2/2+of1),
			lerp(dir1in*-t,dir2in*-(1-t),1-t) - dir1:norm(thick1/2+of2) - dir2:norm(thick2/2+of1),
			t
		})
	end

	for i=1,#ps-1 do
		local pp1,pp2 = ps[i], ps[i+1]
		for i=1,4 do
			local p1 = pp1[i] + cen
			local p2 = pp2[i] + cen
			linefill(p1.x,p1.y,p2.x,p2.y,lerp(thick1,thick2,1-pp2[5])/2,col2)
		end
	end
end

function lerp(a,b,t)
	return a + (b - a)*t
end

-- linefill x0 y0 x1 y1 r [col]
-- draw a tick line
function linefill(ax,ay,bx,by,r,c)
    if(c) color(c)
    local dx,dy=bx-ax,by-ay
 -- avoid overflow
    -- credits: https://www.lexaloffle.com/bbs/?tid=28999
 local d=max(abs(dx),abs(dy))
 local n=min(abs(dx),abs(dy))/d
 d*=sqrt(n*n+1)
    if(d<0.001) return
    local ca,sa=dx/d,-dy/d

    -- polygon points
    local s={
     {0,-r},{d,-r},{d,r},{0,r}
    }
    local u,v,spans=s[4][1],s[4][2],{}
    local x0,y0=ax+u*ca+v*sa,ay-u*sa+v*ca
    for i=1,4 do
        local u,v=s[i][1],s[i][2]
        local x1,y1=ax+u*ca+v*sa,ay-u*sa+v*ca
        local _x1,_y1=x1,y1
        if(y0>y1) x0,y0,x1,y1=x1,y1,x0,y0
        local dx=(x1-x0)/(y1-y0)
        if(y0<0) x0-=y0*dx y0=-1
        local cy0=y0\1+1
        -- sub-pix shift
        x0+=(cy0-y0)*dx
        for y=y0\1+1,min(y1\1,127) do
            -- open span?
            local span=spans[y]
            if span then
                rectfill(x0,y,span,y)
            else
                spans[y]=x0
            end
            x0+=dx
        end
        x0,y0=_x1,_y1
    end

end

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
	one = function()
		return vec(1,1,1)
	end,
	up = function()
		return vec(0,-1,0)
	end,
	down = function()
		return vec(0,1,0)
	end,
	left = function()
		return vec(-1,0,0)
	end,
	right = function()
		return vec(1,0,0)
	end,
	forward = function()
		return vec(0,0,1)
	end,
	back = function()
		return vec(0,0,-1)
	end,

	copy = function(self)
		return vec(self.x,self.y,self.z)
	end,
	ang = function(self)
		return atan2(self.x,self.y)
	end,
	setang = function(self,ang)
		local m = #self
		return vec(m*cos(ang),m*sin(ang))
	end,
	rot = function(self,ang)
		return self:setang(ang + self:ang())
	end,

	set=function(self,v)
		self.x=v.x
		self.y=v.y
		self.z=v.z
		return self
	end,
	setc=function(self, x, y, z)
		self.x=x
		self.y=y
		self.z=z
		return self
	end,

	magn = function(self)
		return #self
	end,
	sqrmagn = function(v)
		return v.x*v.x + v.y*v.y + v.z*v.z
	end,
	dist = function(a,b)
		return (b-a):magn()
	end,
	sqrdist = function(a,b)
		return (b-a):sqrmagn()
	end,

	lerp = function(a,b,t)
		return vec(
			a.x+t*(b.x-a.x),
			a.y+t*(b.y-a.y),
			a.z+t*(b.z-a.z)
		)
	end,
	approach = function(a,b,dist)
		if a:sqrdist(b) <= dist*dist then
			return b
		end
		local ang = atan2(b.x-a.x, b.y-a.y)
		return a + vec(
			dist * cos(ang),
			dist * sin(ang)
		)
	end,

	project = function(v,w)
		return b * (v:dot(w) / b:sqrmagn())
	end,

	norm=function(self, len)
		return self/#self * (len or 1)
	end,
	perp = function(self)
		return vec(-self.y, self.x)
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
	scale = function(a,b)
		return vec(
			a.x*b.x,
			a.y*b.y,
			a.z*b.z
		)
	end,
	nonzero = function(self,unit)
		return not (self.x==0 and self.y==0 and self.z==0)
	end,

	constrain = function(self,anchor,dist)
		return (self - anchor):norm(dist) + anchor
	end,
	constrain_min = function(self,anchor,dist)
		return (self - anchor):sqrmagn()<dist*dist and self:constrain(anchor,dist) or self
	end,
	constrain_max = function(self,anchor,dist)
		return (self - anchor):sqrmagn()>dist*dist and self:constrain(anchor,dist) or self
	end,

	xy = function(self)
		return self.x,self.y
	end,
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
		return vec(ux,uy,uz)
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
		return sqrt(p.x*p.x+p.y*p.y+p.z*p.z)
	end,
	__tostring=function(self)
		return "<"..(self.x\0.1*0.1)..","..(self.y\0.1*0.1)..","..(self.z\0.1*0.1)..">"
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

function boxblur(x,y,width)
	sum=0
	count=(width*2+1)*(width*2+1)

	for xa=x-width,x+width,1 do
		for ya=y-width,y+width,1 do
			sum=sum+pget(xa,ya)
		end
	end

	return sum/count
end

function triv(a,b,c,col)
	line(a.x,a.y,b.x,b.y,col)
	line(b.x,b.y,c.x,c.y,col)
	line(c.x,c.y,a.x,a.y,col)
end

function trifill(a,b,c,col)
	local x0,y0,x1,y1,x2,y2 = a.x,a.y,b.x,b.y,c.x,c.y
	color(col)
	if(y1<y0)x0,x1,y0,y1=x1,x0,y1,y0
	if(y2<y0)x0,x2,y0,y2=x2,x0,y2,y0
	if(y2<y1)x1,x2,y1,y2=x2,x1,y2,y1
	if max(x2,max(x1,x0))-min(x2,min(x1,x0)) > y2-y0 then
		col=x0+(x2-x0)/(y2-y0)*(y1-y0)
		p01_trapeze_h(x0,x0,x1,col,y0,y1)
		p01_trapeze_h(x1,col,x2,x2,y1,y2)
	else
		if(x1<x0)x0,x1,y0,y1=x1,x0,y1,y0
		if(x2<x0)x0,x2,y0,y2=x2,x0,y2,y0
		if(x2<x1)x1,x2,y1,y2=x2,x1,y2,y1
		col=y0+(y2-y0)/(x2-x0)*(x1-x0)
		p01_trapeze_w(y0,y0,y1,col,x0,x1)
		p01_trapeze_w(y1,col,y2,y2,x1,x2)
	end
end
function p01_trapeze_h(l,r,lt,rt,y0,y1)
	lt,rt=(lt-l)/(y1-y0),(rt-r)/(y1-y0)
	if(y0<0)l,r,y0=l-y0*lt,r-y0*rt,0
	y1=min(y1,128)
	for y0=y0,y1 do
		rectfill(l,y0,r,y0)
		l+=lt
		r+=rt
	end
end

function p01_trapeze_w(t,b,tt,bt,x0,x1)
	tt,bt=(tt-t)/(x1-x0),(bt-b)/(x1-x0)
	if(x0<0)t,b,x0=t-x0*tt,b-x0*bt,0
	x1=min(x1,128)
	for x0=x0,x1 do
		rectfill(x0,t,x0,b)
		t+=tt
		b+=bt
	end
end


DOTS = {
	stones = {},
	throwers = {},
}
__dots = DOTS

function makethrower(self, pos, freq, maxstones, burst, gravity, damp)
	local m = {}
	m.stones = {}
	m.deadqueue = {}

	m.pos = pos
	m.throwing = true
	m.freq = freq
	m.timer = 0
	m.maxstones = maxstones
	m.gravity = gravity or vec()
	m.damp = damp or vec.one()

	m.burst = burst
	m.burst_num = m.maxstones

	m.usepool = maxstones>=1
	m.pooled = false
	m.override_pool = true
	m.lifo = true
	m.pool = {}

	m.use_area = false
	m.area_width = 0
	m.area_height = 0

	m.factory = {
		col = 7,
		life = 30*3,
		life_spread = 0,
		ang = 0,
		ang_spread = 1,
		spd_init = 1,
		killspd = 0x0.001,
		spd_spread = 0,
		size_init = 0,
		size_spread = 0,
		updoverride = nil,
		postupd = nil,
		drwoverride = nil,
	}

	add(DOTS.throwers, m)
	setmetatable(m, _thrower)
	return m
end

thrower = {
	upd = function(self)
		self:throw()
		for p in all(self.stones) do
			p:upd()
			if p.dead then
				add(self.deadqueue, p)
			end
		end

		self:recycle()
	end,
	drw = function(self)
		for stn in all(self.stones) do
			stn:drw()
		end
	end,
	grabstone = function(self)
		local x,y = self.pos:xy()
		if self.use_area then
			local width,height = self.area_width,self.area_height
			x = x + flr(rnd(width)) - width / 2
			y = y + flr(rnd(height)) - height / 2
		end

		local stn = {}
		local lenpool = #self.pool
		if self.usepool and #self.stones + lenpool == self.maxstones then
			stn = self.pool[lenpool]
			deli(self.pool,lenpool)
		else
			stn = stone()
		end

		local fact = self.factory
		local override = self.override_pool
		local ang = fact.ang + rnd_spread(fact.ang_spread)
		local spd = fact.spd_init + rnd_spread(fact.spd_spread)
		local size = fact.size_init + rnd_spread(fact.size_spread)
		local life = fact.life + rnd_spread(fact.life_spread)
		stn:set(
			override and vec(x,y) or stn.pos,
			vec.frompolar(ang,spd),
			self.gravity,
			self.damp,
			fact.killspd,
			size,
			life,
			override and fact.col or stn.col
		)
		stn.updoverride = fact.updoverride
		stn.postupd = fact.postupd
		stn.drwoverride = fact.drwoverride
		stn.dead = nil
		return stn
	end,
	throw = function(self)
		if self.throwing then
			if self.burst then
				--TODO:
			else
				self.timer += self.freq
				if self.timer >= 1 then
					local amt = self:get_throw_amount(self.timer)
					for i=1,amt do
						self:addstone(self:grabstone())
					end

					self.timer -= amt
				end
			end
		end
	end,
	get_throw_amount = function(self, num)
		if (self.maxstones ~= 0 and #self.stones + flr(num) >= self.maxstones) then
			return self.maxstones - #self.stones
		end
		return flr(num)
	end,
	addstone = function(self, stn)
		add(self.stones, stn)
	end,
	delstone = function(self, stn)
		add(self.deadqueue, stn)
	end,
	recycle = function(self)
		for s in all(self.deadqueue) do
			if self.usepool then
				add(self.pool, s)
			end
			del(self.stones, s)
			del(DOTS.stones, s)
		end
		self.deadqueue = {}
	end,
	set_area = function(self,use,width,height)
		self.use_area = use
		self.area_width = width
		self.area_height = height
	end,
}
_thrower = {__index = thrower}
setmetatable(thrower, {
	__call = makethrower
})

function makestone(pos,vel,grav,damp,killspd,size,col)
	local stn = setmetatable({},_stone)
	add(DOTS.stones, stn)
	return stn:set(pos,vel,grav,damp,killspd,size,col)
end

stone = {
	set = function(stn,pos,vel,grav,damp,killspd,size,life,col)
		stn.pos = pos
		stn.vel = vel
		stn.grav = type(grav)=="number" and vec(0,grav,0) or grav
		stn.damp = damp
		stn.initspd = vel and vel:magn() or 0
		stn.killspd = killspd
		stn.size = size
		stn.col = col
		stn.life = life
		return stn
	end,
	drw = function(self)
		if (self.drwoverride) then return self:drwoverride() end
		if self.size < 1 then
			pset(self.pos.x,self.pos.y,self.col)
		else
			circ(self.pos.x,self.pos.y,1,self.col)
		end
	end,
	upd = function(self)
		if (self.updoverride) then
			self:updoverride()
			if self.postupd then self:postupd() end
			return
		end
		local pos,vel,grav,damp = self.pos,self.vel,self.grav,self.damp

		vel:set(vel * damp + grav)
		pos:set(pos + vel)
		self.life -= 1
		if pos.x<0 or pos.x>127 or pos.y<0 or pos.y>127 then self.dead = true end
		if self.life<0  then self.dead = true end

		if (self.postupd) then self:postupd() end
	end,
}
_stone = {__index = stone}
setmetatable(stone, {
	__call = makestone
})

function rnd_spread(spread)
	return rnd(spread * sgn(spread)) * sgn(spread)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000ff0000fffff000077770007777000077777700777777000777700077007700777777000000770077007700770000007700070077007700777777007777700
00ffff000ff11ff00770077007717700677666000770000007700770077007700007700000000770077077006770000007770770677067706776677007711770
0ff11ff00fffff000770000007711770677777000777770007700000077007700007700000000770077770006770000007777770677767706770677007711770
0ff11ff00ff11ff00770000007711770677660000770000007707770077777700007700000000770077770006770000007707070677777706770677007777700
0ffffff00ff11ff00770077007717700677000000770000007700770077007700007700007700770077077006770000007700070677677706770677007700000
0ff00ff00fffff000077770007777000677777700770000000777770077007700777777000777700077007706777777007700070677667706777777007700000
00000000000000000000000000000000666666000000000000000000000000000000000000000000000000006666660000000000660066006666660000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700077777000077777007777770077007700770077007700070077007700770077007777770007777000007700000777700007777000000770007777770
07711770077117700777000000077000077007706770677007700070077007700770077000007700077117700077700007700770070007700007770007700000
07711770077117700077770000077000077007706770677007700070000770000077770000077000077177700007700000007700000777000077770007777700
07717770077777000000077000077000077007706770777007707070000770000007700000770000077717700007700000077000000007700770770000000770
07777700077077700000077000077000077007706677770007777770077007700007700007700000077117700007700000770000077007700777777007700770
00770770077007700777770000077000007777000667700007770770077007700007700007777770007777000077770007777770007777000000770000777700
00000000000000000000000000000000000000000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700077777700077770000777700000000000000000000707000000770000070070000000000000000000000000000000000007777000007700000077000
07700000000007700771177007711770000000000000000000707000000770000777777000000000000000000000000000070000077007700007700000077000
07777700000077000077770000777770000000000000000000000000000770000070070000000000000000000077770000070000000077000000000000000000
07711770000770000771177000000770000000000000000000000000000770000070070007777770000000000000000007777700000770000000000000000000
07711770000770000771177000007700000770000007700000000000000000000777777000000000000000000077770000070000000000000007700000077000
00777700000770000077770000777000000770000007700000000000000770000070070000000000077777700000000000070000000770000007700000077000
00000000000000000000000000000000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000770000
00000000000000000077000000007700007777000007777000007700007700000a0a0a0a000000000000000000000000f0000000000000000000000000000000
0000007007000000077000000000077000770000000007700007700000077000a077770007777770000770000000000000000000000000000000000000000000
00000700007000000770000000000770007700000000077000770000000077001770077a07777770007777000000000000f00000000000000000000000000000
0000700000070000077000000000077000770000000007700770000000000770a0007700077777700771177000000000000f0000000000000000000000000000
00070000000070000770000000000770077000000000770007700000000007701007700a0777777007711770000000000000f000000000000000000000000000
0070000000000700077000000000077007700000000077000077000000007700a000000007777770077777700000000000000f00000000000000000000000000
07000000000000700770000000000770077000000000770000077000000770001007700a077777700770077000000000000000f0000000000000000000000000
0000000000000000007700000000770007777000007777000000770000770000a0a0a0a00000000000000000000000000000000f000000000000000000000000
__label__
000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh000000
000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh000
00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00
0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0
0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0
0hhhh1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111hhhh0
hhhhh1jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj1hhhhh
hhhhh1j000000000000000000000000000000000000000000000000000000000000000000j000000000000000j0000000000000000000000000000000j1hhhhh
hhhhh1j0jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj0j0jjjjjjjjjjjjj0j0jjjjjjjjjjjjjjjjjjjjjjjjjjjjj0j1hhhhh
hhhhh1j0jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj000j000j000j000j000j000j0jj00jj00jj000j000j000j0j0j0j0j0j0j0j0j0j0j0j0j0j0j0j0j0j0j1hhhhh
hhhhh1j0jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj00j000j000j000j0000jj00j000000000000000jj00j000jj0j0jj0j0j0j0j0j0j0j0j0j0j0j0j0jj0j1hhhhh
hhhhh1j0jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj000000000000000jj000000000000000j0j0j000000jj000j0j0j0j0j0j0j0j0j0j0j0j0j0j0j0j0j0j1hhhhh
hhhhh1j0jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj00jj00jj00jj0jj00000000000jj00jjj0j0jj000j0000j000j0jj0j0j0j0j0j0j0j0j0j0j0j0j0jj0j1hhhhh
hhhhh1j0jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj000j000j00j000000000000j000j000jj0j0j0j000j00000jjj0j0j0j0j0j0j0j0j0j0j0j0j0j0j0j0j1hhhhh
hhhhh1j0jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj00j000j0j000000000j000j0000000000000000j000j000j000jjj0j0j0j0j0j0j0j0j0j0j0j0j0jj0j1hhhhh
hhhhh1j0jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj0000000j000000000000000000000000j0j0j000j000j000j0j0000jjjjjjjjjjjjjjjjjjjjjjjjjj0j1hhhhh
hhhhh1j0jjjjjjjjjjjjjjjjjjjjjjjjjjjj9j9999j0j0000000000000j000j000j000j00000j000j000j0000j0000000000000000000000000000000j1hhhhh
hhhhh1j0jjjjjjjjjjjjjjjjjjjjj9999999999999000000000000000j0j0j0j0j0j0j0j0j0j0j000j000j000jjjj000jjjjjjjjjjjjjjjjjjjjjjjjjj1hhhhh
hhhhh1j00000000000000000000000000999999999000000000000000000000000000000000000j000j000j0000000000000000000000000000000000j1hhhhh
hhhhh1jjjjjjjjjjjjjjjjjjjjjp999pp999999999000jjj0000000j0j0000000000000000000000000j000j0j0jjjjj00jjjjjjjjjjjjjjjjjjjjjj0j1hhhhh
hhhhh1j0000000000000000jjjppp99pp9999999990jjjj00000j0j00000000000000000000000000000j0000000j0jj0j0jj0j0j0j0j0j0j0jjjjjj0j1hhhhh
hhhhh1j0jjjjjjjjjjjjjj0jjjppp99pp999999999jjjj0j0j0j00000000000000000000000000000000000j0j0j0j0j0j000j0j0j0j0j0j0jjjjjjj0j1hhhhh
hhhhh1j0j0j000j000j00j0jjjjpp99pp999999999jjj0j0j0j00000000000000000000000000000000000000000j0j00j0jj0j0j0j0j0j0j0jjjjjj0j1hhhhh
hhhhh1j0j00j000j000j0j0jjjjpp99pp9999999990j0j0j0000000000000000000000000000000000000000000j0j0qqqqqqqqqqqqj0j0j0jjjjjjj0j1hhhhh
hhhhh1j0jj00jj00jj00jj0jqqqpp99pp999999999j0j0j000000000000000000000000000000000000000000000j0jqqqqqqqqqqqqjjjjjjjjjjjjj0j1hhhhh
hhhhh1j0jj000j000j000j0jqqqpp99pp9999999990j0j0000000000000000000000000000000000000000000000000qqqqqqqqqqqq00000000000000j1hhhhh
hhhhh1j0j0j000j000j00j0jqqqppp9pp999999999j0j00000000000000000000000000000000000000000000000000qqqqqqqqqqqqjjjjjjjjjjjjjjj1hhhhh
hhhhh1j0j00j000j000j0j0jqqqppp9pp9999999990j000000000000000000000000000000000000000000000000000qqqqqqqqqqqqj0000000000000j1hhhhh
hhhhh1j0jj00jj00jj00jj0jqqqppp0pp99999999900000000000000000000000000000000000000000000000000000qqqqqqqqqqqq0jjjjjjjjjjjj0j1hhhhh
hhqqqqj0jqqqqj000j00qqqqqqqqqqqpp999999999000000000000000000000000000000000000000000000000000000qqqqqqqqqqqqjj00jj00jj0j0j1hhhhh
hhqqqqj0jqqqq0j000j0qqqqqqqqqqqpp999999999000000000000000000000000000000000000000000000000000000qqqqqqqqqqqq0000j000j00j0j1hhhhh
hhqqqqj0jqqqq00j000jqqqqqqqqqqqppp99999999900000000000000000000000000000000000000000000000000000qqqqqqqqqqqq00jj000j000j0j1hhhhh
hhqqqqj0jqqqqj00jj00qqqqqqqqqqqppp99999999900000000000000000000000000000000000000000000000000000qqqqqqqqqqqq00000j0j0j0j0j1hhhhh
hhqqqqj0jqqqqj000j00qqqqqqqqqqqqpp99999999900000000000000000000000000000000000000000000000000000qqqqqqqqqqqqjj00jj00jj0j0j1hhhhh
hhqqqqj0jqqqq0j000j0qqqqqqqqqqqqpp9999999990000000qqqq000000000000000000000000000000000000000000qqqqqqqqqqqqj0000000j00j0j1hhhhh
hhqqqqj0jqqqq00j000jqqqqqqqqqqqqpp9999999990000000qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000000qqqqqqqqqqqq0000000j000j0j1hhhhh
hhqqqqj0jqqqqj00jj00qqqqqqqqqqqqpp9999999990000000qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000033qqqq333333000j0j0j0j0j0j0j1hhhhh
hhqqqqj0jqqqqj000j00qqqqqqqqqqqqpp9999999990000000qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000033qqqq3333330j0j000j00jj0j0j1hhhhh
hhhqqqq0j0qqqqj000j0qqqqqqqqqqqqpp9999999990000000qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000033qqqq33333300j0jjj0jjj00j0j1hhhhh
hhhqqqq0j0qqqq0j000jqqqqqqqqqqqqpp9999999990000000qqqq0000000000000qqqqqqqqqqqq0qqqq000qqqq000033qqqq333333j0j0j00jj000j0j1hhhhh
hhhqqqq0jjqqqq00jj00jqqqqqqqqqqqpp9999999990000030qqqq0000000000000qqqqqqqqqqqq0qqqq000qqqq000033qqqq3333330000jj0j0jjjj0j1hhhhh
h33qqqq0j3qqqq000j000qqqqqqqqqqqpp99999999900000000qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000033qqqq333333q0j00jj00jjjj0j1hhhhh
h33qqqq0j3qqqqj000333qqqq3333qqqpp99999999900000000qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000033qqqq3333330q000jj0jjjjj0j1hhhhh
h33qqqq0j3qqqq0j00333qqqq3333qqqpp99999999900000000qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000033qqqq3333330000jjjj00jjj0j1hhhhh
h33qqqq0j3qqqq003j333qqqq3333qqqpp99999999900000000qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000033qqqq33333300000jjj0jjjj0j1hhhhh
h33qqqq0j3qqqq003j333qqqq3333qqqpp99999999900000000qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000033qqqq33333300j00jjj0jjjj0j1hhhhh
h33qqqq0j3qqqqj030333qqqq3333qqqpp99999999900000000qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000033qqqq33333300000jjj0j0jj0j1hhhhh
hh33qqqqj03qqqqj00333qqqq3333qqqpp99999999900000033qqqq0000000000000qqqqqqqqqqqqqqqq000qqqq000033qqqq333333003030jjj00jj0j1hhhhh
hh33qqqqqj3qqqq0jj333qqqq3333qqqppp9999999990000033qqqq0000000000033qqqq3333qq33qqqq003qqqq0030033qqqq3333330030000j0j000j1hhhhh
hh33qqqqqj3qqqq00j333qqqq3333qqqpp99999999990000033qqqq0000000000033qqqq3333qq33qqqq003qqqq0030033qqqqqqqqqq00030j000j000j1hhhhh
hh33qqqqq03qqqq000333qqqq3333qqqqp99999999990000033qqqq0000000000333qqqq3333qqq33qqqq003qqqq000033qqqqqqqqqq00q0j00000jj0j1hhhhh
hh33qqqqq03qqqqj000333qqqq3333qqpp9999pp999900000033qqqq0000000000033qqqq3333qq33qqqq003qqqq000033qqqqqqqqqq000q000j00jj0j1hhhhh
hh33qqqqqj3qqqq0jj0333qqqq3333qqpp999999999900000033qqqq0000000000033qqqq3333qq33qqqq003qqqq000033qqqqqqqqqq0000000j00000j1hhhhh
hh33qqqqqq3qqqq0030333qqqq3333qqpp99999p999990000033qqqq0000000000033qqqq3333qq33qqqq003qqqq000033qqqqqqqqqq000q0j00j0000j1hhhhh
hh33qqqqqq3qqqq003j333qqqq3333qqpp99999p999990000033qqqq0000000000033qqqq3333qq33qqqq003qqqq000033qqqqqqqqqq0000j000j0jj0j1hhhhh
hh33qqqqqq3qqqqj030333qqqq0j33qqp999999p999999000033qqqq0000000000033qqqq3333qq33qqqq003qqqq000033qqqqqqqqqq000q000j00jj0j1hhhhh
hhh33qqqqqq3qqqqjj0333qqqq3033qqp99999ppp99999900033qqqq0000000000033qqqq3333qq33qqqq003qqqq000033qqqqqqqqqq00j0j0jjj0000j1hhhhh
hhh33qqqqqq3qqqqjjj333qqqq0333qp999999pppp9999990033qqqq0000000000033qqqq3333qq33qqqq003qqqq0030033qqqqqqqqqq00j0j0jj0000j1hhhhh
hhh33qqqqqq3qqqqjjj333qqqq3033q99999900ppp9999999933qqqq0000000000033qqqq3333qq33qqqq003qqqq0030033qqqqqqqqqq0j0j0jjj0jj0j1hhhhh
hhh33qqqqqq3qqqqjjj333qqqq0j339999999000ppp99999999999999999999999993qqqq3333qq33qqqq003qqqq0030033qqqqqqqqqq00j0j0jj0jj0j1hhhhh
hhh33qqqqqq3qqqqjjj333qqqqj0999999990000pppp99999999999999999999999933qqqq3333q33qqqq003qqqq0030033qqqqqqqqqq0j0j0jjj0000j1hhhhh
hhh33qqqqqq3qqqqjjj3399999999999999000000ppppp999999999999999999999933qqqq0033qq33qqqq003qqqq000033qqqq33330000j0j0jj0000j1hhhhh
hhh33qqqqqq9999999999999999999999pqq000000pppppp9999999999999999999933qqqq0033qq33qqqq003qqqq000033qqqq3333000j0j0jjj0jj0j1hhhhh
hhh33qqqqqq999999999999999999999pqqq00000000pppppppppp9ppp999999999933qqqq0033qq33qqqq003qqqq000033qqqq33330000j0j0jj0jj0j1hhhhh
hhh33qqqqpp999999999999999999ppqqqqq0000000000ppppp9999999999999999993qqqq0033qq33qqqq003qqqq000033qqqq333300000j0jjj00j0j1hhhhh
hhhh33qqqppp9999999999ppp9pppp3qqqqq0000000000009999999999999999999993qqqq0033qq33qqqq003qqqq000033qqqq33330000j0jjj0jjj0j1hhhhh
hhhh33qqqppp99999999999999999999qqqq0000000000099999999999999999999993qqqq0033qq33qqqq003qqqq000033qqqq3333000j0jjjj00jj0j1hhhhh
hhhh33qqqqpp9999999999999999999999qq00000000099999999999999pppppppp033qqqq0033qq33qqqq003qqqq0000033qqqq3333000j0jjj00jj0j1hhhhh
hhhh33qqqqpp9999999999999999999999990000000099999999ppppppppppppppp033qqqq0033qq33qqqq003qqqq0030033qqqq333300j0jjjj0jjj0j1hhhhh
hhhh33qqqqpp99999999999999999999999990000009999999ppppppp0000000000033qqqq0033qq33qqqq003qqqq0030033qqqq33330j0j0jjj0jjj0j1hhhhh
hhhh33qqqqpppppppppppppppppppp999999990000p999999p033qqqq00000000003033qqqq0033q33qqqq003qqqq0030033qqqq333300j0jjj0j0jj0j1hhhhh
hhhh33qqqqpppppppppppppppppppppp999999000p999999000033qqqq0000000000033qqqq0033q33qqqq003qqqq0030033qqqq33330j0jjjj00jjj0j1hhhhh
hhhh33qqqqqqqqqqqpp3p333qqqqppppp99999900p999990000033qqqq0000000000033qqqq0033qq33qqqq003qqqq000033qqqq33330030jjj0jjjj0j1hhhhh
hhhh33qqqqqqqqqqqpp3p333qqqq0jpppp999999p9999990000033qqqq0000000000033qqqq0033qq33qqqq003qqqq000033qqqq33330303jjj0jjjj0j1hhhhh
hhhhh33qqqqqqqqqqqqq3333qqqqj03pppp99999p9999900000033qqqq0000000000033qqqq0033qq33qqqq00qqqqq000033qqqq00000000000j00000j1hhhhh
hhhhh33qqqqqqqqqqqqqj333qqqq0j33ppp99999p9999900000033qqqq0000000000033qqqq0033qq33qqqq00qqqqq000033qqqq00030j0jjj0j0jjjjj1hhhhh
hhhhh33qqqqqqqqqqqqqj333qqqqj033qppp999999999900000033qqqq0000000000033qqqq0033qq33qqqq00qqqqq0000033qqqq0000000000000000j1hhhhh
hhhhh33qqqq33qqqqqqqj333qqqqjj33qppp9999pp999900000033qqqq0000000000033qqqq0033qq33qqqq00qqqqq0000033qqqq0030j0jj000jjjj0j1hhhhh
hhhhh33qqqq33qqqqqqqj333qqqqjj33qqpp999999999900000033qqqq0000000000033qqqq0033qq33qqqq00qqqqq0000033qqqq0000j0000j00j0j0j1hhhhh
hhhhh33qqqq33qqqqq000333qqqq0033qqpp999999999900000033qqqq0000000000033qqqq0033qq33qqqq00qqqqq0030033qqqq30300000000000j0j1hhhhh
hhhhh33qqqq33qqqqqjj3333qqqqjj33qqpp999999999000000033qqqq00000000003033qqqq0033q33qqqq00qqqqq0030033qqqq00000000j00000j0j1hhhhh
hhhhh33qqqq33qqqqqj03333qqqqj033qqppp999999999000000033qqqq0000000000033qqqq0033q33qqqq00qqqqq0030033qqqqj0jj0j0j0j0j0jj0j1hhhhh
hhhhh33qqqq33qqqqq003333qqqq0j33qqppp999999999000000033qqqq0000000000033qqqq0033q33qqqq00qqqqq0030033qqqq00jjjj00jjjjjjj0j1hhhhh
hhhhh133qqqq33qqqqq000333qqqq0033qqpp999999999000000033qqqq0000000000033qqqq0033qq33qqqq00qqqqq000033qqqqj00000j000000000j1hhhhh
hhhhh133qqqq33qqqqq00j333qqqq0033qqpp999999999000000033qqqq0000000000033qqqq0033qq33qqqq00qqqqq000033qqqqjjjj0j0jjjjjjjjjj1hhhhh
hhhhh133qqqq33qqqqq0j0333qqqq0j33qqpp999999999000000033qqqq0000000000033qqqq0033qq33qqqq00qqqqq000033qqqqj000000000000000j1hhhhh
hhhhh133qqqq33qqqqqjjj333qqqq0033qqpp999999999000000033qqqq0000000000033qqqq0033qq33qqqq00qqqqq0000033qqqq0j00jjjjjjjjjj0j1hhhhh
hhhhh133qqqq33qqqqq000333qqqq0j33qqpp999999999000000033qqqq0000000000033qqqq0033qq3333qqqqqqq000000333qqqqqqqqqqqq000j0j0j1hhhhh
hhhhh133qqqq33qqqqqqqj333qqqqj033qqpp999999999000000033qqqq0000000000033qqqq0033qq3333qqqqqqq00000j033qqqqqqqqqqqq0j000j0j1hhhhh
hhhhh133qqqq333qqqqq03333qqqq0033qqpp999999999000000033qqqq0000000000033qqqq0033qq3333qqqqqqq0000j0j33qqqqqqqqqqqq00000j0j1hhhhh
hhhhh133qqqq333qqqqq03333qqqqjj33qqpp999999999000000033qqqq00000000003033qqqq0033q3333qqqqqqq000j3j033qqqqqqqqqqqqj0j0jj0j1hhhhh
hhhhh133qqqq333qqqqq03333qqqqjj33qqpp9999999990000000033qqqq0000000000033qqqq0033q3333qqqqqqq00q030j33qqqqqqqqqqqq000j0j0j1hhhhh
hhhhh1j33qqqq333qqqq0q333qqqq0j33qqpp999999999j000000033qqqq0000000000033qqqq0033q3333qqqqqqq0q0j3jj33qqqqqqqqqqqq0j000j0j1hhhhh
hhhhh1j33qqqq333qqqq0q333qqqqjj33qqpp9999999990000000033qqqq0000000000033qqqq0033qq3333qqqqqqq0q0jjj33qqqqqqqqqqqq00000j0j1hhhhh
hhhhh1j33qqqq333qqqq0q3333qqqqj033qpp999999999j0j0000033qqqq0000000000033qqqq0033qq3333qqqqqqqq0jjjj33qqqqqqqqqqqqj0j0jj0j1hhhhh
hhhhh1j33qqqq333qqqq0j0333qqqqqqqqqpp99999999900090j0033qqqq0000000000033qqqq0033qq3333qqqqqqq0qjjj0033qqqqqqqqqqqq00j0j0j1hhhhh
hhhhh1j33qqqq333qqqq0jj333qqqqqqqqqpp999999999j0j000j033qqqq0000000000033qqqq0033qq3333qqqqqqqjjqq00j33qqqqqqqqqqqqqqqqq0j1hhhhh
hhhhh1j33qqqq333qqqq0j0333qqqqqqqqqpp999999999j00j0j0j33qqqqqqqqqqqq00033qqqq0033qq3333qqqqqqqjjq000j33qqqqqqqqqqqqqqqqq0j1hhhhh
hhhhh1j33qqqq333qqqq0j3333qqqqqqqqqppp9999999990jj00j033qqqqqqqqqqqq00033qqqq0j33qq3333qqqqqqqj000jj333qqqqqqqqqqqqqqqqq0j1hhhhh
hhhhh1j33qqqq333qqqq0j3333qqqqqqqqqppp9999999990jj0j0j33qqqqqqqqqqqq00033qqqqj033qq3333qqqqqqq0j00jj333qqqqqqqqqqqq000000j1hhhhh
hhhhh1j33qqqq333qqqq0j3333qqqqqqqqqqpp9999999990jj0jjj33qqqqqqqqqqqq003033qqqqqqqqqqq3333qqq0000jj00j333333333333qq3qqqqqj1hhhhh
hhhhh1j03333jjjj333j0j0333qqqqqqqqqqpp99999999900j0jjjj33qqqqqqqqqqqq30q33qqqqqqqqqqq3333qqqjj00003003333333333330000000001hhhhh
hhhhh1j03333jjjj333j0jj333qqqqqqqqqqpp999999999j0000jjj33qqqqqqqqqqqq03033qqqqqqqqqqq3333qqqjjjjqq3jj333333333333qq33qqqq01hhhhh
hhhhh1j03333jjjj333j0j0333qqqqqqqqqqpp9999999990j0jj00j33qqqqqqqqqqqq30333qqqqqqqqqqq3333qqqj0jjj03jj3333333333330jjj0jjj01hhhhh
hhhhh1j03333jjjj333j0jj333qqqqqqqqqqpp9999999990jj00jj033qqqqqqqqqqqqjjj33qqqqqqqqqqqq3333qqqjj00jj00j333333333333j00jj0j01hhhhh
hhhhh1j03333jjjj333j0j0j333qqqqqqqqqpp9999999990jj0jjj033qqqqqqqqqqqqjjj33qqqqqqqqqqqq3333qqqjjj0jjj0j333333333333jj0jjjj01hhhhh
hhhhh1j03333jjjj333j0jj0333qqqqqqqqqpp999999999jjj0jjjj33qqqqqqqqqqqq00033qqqqqqqqqqqq3333qqqj000j000j333333333333000j00j01hhhhh
hhhhh1j03333jjjj333j0j03333qqqqqqqqqpp9999999990000jjjj33qqqqqqqqqqqq0jj33qqqqqqqqqqqq3333qqq0jjj0jjj0333333333333jjj0jjj01hhhhh
hhhhh1j03333jjjj333j0jj3333333333333pp999999999jjjjjjjj33qqqqqqqqqqqqjjj33qqqqqqqqqqqq3333qqqjj00jj00j333333333333j00jj0j01hhhhh
hhhhh1j03333jjjj333j0j03333333333333pp9999999990000000033qqqqqqqqqqqq00033qqqqqqqqqqqq3333qqqjjj0jjj0j333333333333jj0jjjj01hhhhh
hhhhh1j0j3333jjjj3330jj0333333333333pp999999999jjjjjjjj333333333333jjjj3333qqqqqqqqqqq3333qqqj000j000j333333333333000j00j01hhhhh
hhhhh1j0j3333jjj03330j0j333333333333pp999999999jjjjjjjjj333333333333jjjjj33qqqqqqqqqqq3333qqq0jjj0jjj0333333333333jjj0jjj01hhhhh
hhhhh1j0j3333jjjj3330jj0333333333333pp9999ppp0jjj0jjj0jj333333333333j0jjj33qqqqqqqqqqq3333qqqjj00jj30jj00jj00jj00jj00jj0j01hhhhh
hhhhh1j0jjjjjjjj0j0j0j0j333333333333pppppppppjj0jjj0jjj0333333333333jjj0j333333333333jjj33330jjj0jj30jjj0jjj0jjj0jjj0jjjj01hhhhh
hhhhh1j0jjjjjjjjjj0j0jj0333333333333pppp00jj00jj00jj00jj33333333333300jj03333333333330jj33330j000j030j000j000j000j000j00j01hhhhh
hhhhh1j0jjjjjjjj0j0j0j0j3333333333333jjjjjjjjjjjjjjjjjjj333333333333jjjjj333333333333jjj033330jjj0jjj0jjj0jjj0jjj0jjj0jjj01hhhhh
hhhhh1j0jjjjjjjjjj0j0jj0j3333333333333jjj0jjj0jjj0jjj0jj333333333333j0jjj3333333333330jj03333jj00jj00jj00jj00jj00jj00jj0j01hhhhh
hhhhh1j0jjjjjjjj0j0j0j0j03333333333333j0jjj0jjj0jjj0jjj0333333333333jjj0j333333333333jjj03333j0jjjjjjj3333333333330jjj0jj01hhhhh
hhhhh1j0jjjjjjjjjj0j0jj0j3333333333333jj00jj00jj00jj00jj33333333333300jj03333333333330jj03333j33jjjjjj333333333333jjjjjjj01hhhhh
hhhhh1j0jjjjjjjjjj0j0jjjj3333333333333jjjjjjjjjjjjjjjjjj333333333333jjjjjj3333333333333j03333j33jjjjjj333333333333jjjjjjj01hhhhh
hhhhh1j000000000000j0000033333333333330000000000000000003333333333330000303333333333330003333000000000000000000000000000001hhhhh
hhhhh1jjjjjjjjjjjjjjjjjjj3333333333333jjjjjjjjjjjjjjjjjjj333333333333jjjjj333333333333jjj3333jjjjjjjjjjj33333333333jjjjjjj1hhhhh
0hhhh1111111111111111111111111111111111111111111111111111333333333333111113333333333331113333111111131111111111111111111111hhhh0
0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh333333333333hhh3333hhhhhhh3hhhhhhhhhhhhhhhhhhhhhhhhhh0
0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh333333333333hhh3333hhhhhhh3hhhhhhhhhhhhhhhhhhhhhhhhhh0
00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh3333hhhhhhh3hhhhhhhhhhhhhhhhhhhhhhhhh00
000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh000
000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh000000

__map__
0d0e3b0b0e150400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
