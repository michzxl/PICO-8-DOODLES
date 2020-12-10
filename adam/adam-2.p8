pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

-- todo: test rotup()
-- todo: implement draw_objs()
--         should have drawing order for lines

function _init()
	angz=0
	angy=0
	angup=0
	sc=10

	orig = pt(0,0,0)

	⧗ = 0.00
	pi = 3.14159

	pal(1,12,1)
	pal(2,12+128,1)
	pal(3,7)
	pal(4,5)
end

function _update60()
	⧗ += 1/60
	t = ⧗
	--if ctr==1 then ctr=0 end

	angz = angz + 0.002*sin(t/8) - 0.002
	--angz = angz + 0.01
	angy = 0.1*sin(t/6)
end

function _draw()
	rectfill(0,0,128,128,0)

	--circfill(64,64,3.5*sc,13)
	draw_obj('head', objects, {x=64,y=64}, sc, angy, angz, 1)
	draw_obj('left_eye', objects, {x=64,y=64}, sc, angy, angz, 3)
	draw_obj('right_eye', objects, {x=64,y=64}, sc, angy, angz, 3)
end

function draw_obj(name, objs, loc, scale, ay, az, color)
	local obj = objs[name]
	local verts = obj.v
	local lines = obj.l

	local rotverts = {}
	for vert in all(verts) do
		local scalevert = scaled(vert,scale)
		local rotvert = roty(scalevert, orig, ay) -- rotate about z
		local rotvert = rotz(rotvert, orig, az) -- rotate about y

		add(rotverts, rotvert)
	end

	for ln in all(lines) do
		local v1 = rotverts[ln[1]]
		local v2 = rotverts[ln[2]]

		local color = color
		if v1.y < 0 and v2.y < 0 then
			color = color + 1
		end

		if v1.y > 15*(sin(v1.x/64-t/4) + sin(v1.y/64+t/4)) - 10 then
			line2(v1.x+loc.x,(v1.z+loc.y),v2.x+loc.x,(v2.z+loc.y),color)
		end
	end
end

function line2(x1,y1,x2,y2,c)
 local num_steps=max(
  abs(flr(x2)-flr(x1)),
  abs(flr(y2)-flr(y1)))
 local dx=(x2-x1)/num_steps
 local dy=(y2-y1)/num_steps
 for i=0,num_steps do
  pset(x1,y1,c)
  x1+=dx
  y1+=dy
 end
end

function pt(x,y,z)
	return {
		x=x,
		y=y,
		z=z
	}
end

function scaled(point,a)
	return pt(
		point.x*a,
		point.y*a,
		point.z*a
	)
end

function rotz(point, origin, ang)
	local sina,cosa=
		sin(ang), cos(ang)

	local p = pt(
		point.x-origin.x, 
		point.y-origin.y, 
		point.z-origin.z)

	return {
		x = p.x * cosa - p.y * sina + origin.x,
		y = p.x * sina + p.y * cosa + origin.y,
		z = p.z + origin.z
	}
end

function roty(point, origin, ang)
	local sina,cosa=
		sin(ang), cos(ang)

	local p = pt(
		point.x-origin.x, 
		point.y-origin.y, 
		point.z-origin.z)

	return {
		x = p.z * sina + p.x * cosa + origin.x,
		y = p.y + origin.y,
		z = p.z * cosa - p.x * sina + origin.z
	}
end

objects = {
	left_eye = {
		v = {
			{x=0.87,y=-3.27,z=0.70},
			{x=1.53,y=-3.00,z=1.00},
			{x=0.60,y=-3.38,z=-0.00},
			{x=0.87,y=-3.27,z=-0.70},
			{x=1.53,y=-3.00,z=-1.00},
			{x=2.18,y=-2.72,z=-0.70},
			{x=2.45,y=-2.61,z=-0.00},
			{x=2.18,y=-2.72,z=0.70}
		},
		l = {
			{2,8},
			{8,7},
			{7,6},
			{6,5},
			{5,4},
			{4,3},
			{3,1},
			{1,2}
		}
	},
	right_eye = {
		v = {
			{x=-2.18,y=-2.72,z=0.70},
			{x=-1.53,y=-3.00,z=1.00},
			{x=-2.45,y=-2.61,z=-0.00},
			{x=-2.18,y=-2.72,z=-0.70},
			{x=-1.53,y=-3.00,z=-1.00},
			{x=-0.87,y=-3.27,z=-0.70},
			{x=-0.60,y=-3.38,z=-0.00},
			{x=-0.87,y=-3.27,z=0.70}
		},
		l = {
			{2,8},
			{8,7},
			{7,6},
			{6,5},
			{5,4},
			{4,3},
			{3,1},
			{1,2}
		}
	},
	head = {
		v = {
			{x=0.00,y=-0.00,z=3.50},
			{x=1.23,y=1.23,z=3.03},
			{x=2.14,y=2.14,z=1.75},
			{x=2.47,y=2.47,z=0.00},
			{x=2.14,y=2.14,z=-1.75},
			{x=1.23,y=1.23,z=-3.03},
			{x=0.00,y=3.03,z=-1.75},
			{x=0.00,y=1.75,z=3.03},
			{x=1.74,y=-0.00,z=3.03},
			{x=3.03,y=0.00,z=1.75},
			{x=3.49,y=0.00,z=0.00},
			{x=3.03,y=0.00,z=-1.75},
			{x=1.74,y=0.00,z=-3.03},
			{x=1.23,y=-1.23,z=3.03},
			{x=2.14,y=-2.14,z=1.75},
			{x=2.47,y=-2.47,z=-0.00},
			{x=2.14,y=-2.14,z=-1.75},
			{x=1.23,y=-1.23,z=-3.03},
			{x=0.00,y=0.00,z=-3.50},
			{x=0.00,y=-1.75,z=3.03},
			{x=0.00,y=-3.03,z=1.75},
			{x=0.00,y=-3.49,z=-0.00},
			{x=0.00,y=-3.03,z=-1.75},
			{x=0.00,y=-1.74,z=-3.03},
			{x=-1.23,y=-1.23,z=3.03},
			{x=-2.14,y=-2.14,z=1.75},
			{x=-2.47,y=-2.47,z=-0.00},
			{x=-2.14,y=-2.14,z=-1.75},
			{x=-1.23,y=-1.23,z=-3.03},
			{x=-1.74,y=0.00,z=3.03},
			{x=-3.03,y=-0.00,z=1.75},
			{x=-3.49,y=0.00,z=0.00},
			{x=-3.03,y=0.00,z=-1.75},
			{x=-1.74,y=0.00,z=-3.03},
			{x=-1.23,y=1.23,z=3.03},
			{x=-2.14,y=2.14,z=1.75},
			{x=-2.47,y=2.47,z=0.00},
			{x=-2.14,y=2.14,z=-1.75},
			{x=-1.23,y=1.23,z=-3.03},
			{x=0.00,y=3.03,z=1.75},
			{x=0.00,y=3.49,z=0.00},
			{x=0.00,y=1.75,z=-3.03}
		},
		l = {
			{8,35},
			{38,7},
			{39,19},
			{1,35},
			{34,19},
			{1,30},
			{29,19},
			{1,25},
			{24,19},
			{1,20},
			{1,14},
			{13,19},
			{1,9},
			{40,3},
			{4,41},
			{6,42},
			{6,19},
			{42,19},
			{7,42},
			{41,7},
			{8,40},
			{1,8},
			{36,40},
			{41,37},
			{42,39},
			{40,41},
			{37,32},
			{33,38},
			{39,34},
			{30,35},
			{36,31},
			{38,39},
			{37,38},
			{36,37},
			{35,36},
			{34,29},
			{25,30},
			{31,26},
			{27,32},
			{33,28},
			{33,34},
			{32,33},
			{31,32},
			{30,31},
			{20,25},
			{26,21},
			{22,27},
			{28,23},
			{24,29},
			{28,29},
			{27,28},
			{26,27},
			{25,26},
			{14,20},
			{21,15},
			{16,22},
			{23,17},
			{18,24},
			{23,24},
			{22,23},
			{21,22},
			{20,21},
			{9,14},
			{15,10},
			{11,16},
			{17,12},
			{13,18},
			{18,19},
			{17,18},
			{16,17},
			{15,16},
			{14,15},
			{10,3},
			{4,11},
			{12,5},
			{6,13},
			{9,2},
			{12,13},
			{11,12},
			{10,11},
			{9,10},
			{2,8},
			{7,5},
			{5,6},
			{4,5},
			{3,4},
			{2,3},
			{1,2}
		}
	}
}

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
	one=function()
		return vec(1,1,1)
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

	-- TODO: implement better version of this thing:
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

function polydraw(vecs,cen,col)
	cen = cen or vec()
	for i=1,#vecs do
		local p1 = vecs[i] + cen
		local p2 = vecs[i%#vecs+1] + cen
		line2(p1.x,p1.y,p2.x,p2.y,col)
	end
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

function polypath(vecs,cen,col)
	cen = cen or vec()
	for i=1,#vecs-1 do
		local p1 = vecs[i] + cen
		local p2 = vecs[i+1] + cen
		line2(p1.x,p1.y,p2.x,p2.y,col)
	end
end

function polycen(poly)
	local v = vec()
	for point in all(poly) do
		v = v + point
	end
	return v / #poly
end

function poly_normal(poly)
	local v1 = (poly[2] - poly[1]):norm()
	local v2 = (poly[3] - poly[2]):norm()
	return vec.cross(v1,v2)
end

	--[[
				 4____________________1 (s2,s2,s2)
			   / |                  /|
			 /                    /  |
		  /     |              /    |
		3____________________2      |
		|       |            |      |
		|                    |      |
		|       6_ _ _ _ _ _ | _ _ _5
		|     /              |     /
		|   /                |   /
		| (-s2,-s2,-s2)      | /
		7/___________________8

	--]]
function poly_cube(s)
	local s2 = s/2
	local v = {
		vec(s2,s2,s2),
		vec(s2,-s2,s2),
		vec(-s2,-s2,s2),
		vec(-s2,s2,s2),
		vec(s2,s2,-s2),
		vec(-s2,s2,-s2),
		vec(-s2,-s2,-s2),
		vec(s2,-s2,-s2),
	}
	local f = {
		{ 1,2,3,4 },
		{ 5,6,7,8 },
		{ 1,4,6,5 },
		{ 1,5,8,2 },
		{ 2,8,7,3 },
		{ 3,7,6,4 },
	}
	return f, v
end

function init_shapes() 
	local cube_f, cube_v = poly_cube(1)
	local cube = {
		f = cube_f,
		v = cube_v,
	}

	SHAPE = {
		cube = cube,
	}
	return SHAPE
end

polyv = polydraw
polyp = polypath
polyf = polyfill