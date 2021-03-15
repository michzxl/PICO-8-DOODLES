pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init()
	dt=1/30
	t=0
   tf=0

	pal(2,1+128,1)

	scrw,scrh = 128,128

	cls()
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

function _update()
	--cls(0)
   t+=dt
   tf+=1
	T = t

	for i = 1, 900 do
		local x, y = rnd(128), rnd(128)
		local p

		if x<=64 and y<=64 then
			p = pget(x+(rnd(1)<0.5 and -1 or 1),y+2)
		elseif x>64 and y>64 then
			p = pget(x+(rnd(1)<0.5 and -1 or 1),y-2)
		else
			local v2 = vec(x-64,y-64):turn(0.008)
			p = pget(v2.x+64, v2.y+64)
		end

		if p~=0 or rnd(1)<0.75 then
			circ(x,y,1,p)
		end
	end

	local r = 8
	local x = 64 + cos(t/8)*32
	local y = 64 + sin(t/8)*32
	local w = 4
	for i=1,w do
		circ(x,y,r-i+1+rnd(2)-1,0)
	end

	local k = sqrt(2)
	for i=1,100 do
		local ang,r = rnd(1),rnd(64*k)
		local ang2,r2 = ang, r-3

		local x1,y1 = 64+r*cos(ang),64+r*sin(ang)
		local x2,y2 = 64+r2*cos(ang2),64+r2*sin(ang2)

		local p = pget(x1,y1)
		if p==0 then
			circ(x2,y2,1,2)
			line(x1,y1,x2,y2,2)
		end
 	end


	local vs = {
		vec(20,20),
		vec(20,-20),
		vec(-20,-20),
		vec(-20,20),
	}

	vs = subdivide(vs, 3, false)

	for i=1,#vs do
		local v = vs[i]

		local ang,r = (v):polar()
		ang = ang - T/8
		r = r + 2*sin(t/16 + i/(8 + sin(t/18)))
		v = vec.frompolar(ang,r)

		v = v + vec(5*cos(T/4 - i/(#vs/3)),sin(T/8 + i/(#vs/5))*8) + vec(0,i%2*3)

		vs[i] = v
	end

	polyv(vs,vec(64,65),0)
	polyv(vs,vec(64,62),0)
	polyv(vs,vec(64,67),1)
	polyv(vs,vec(64,64),13)
end

function sqr(a)
	return a*a
end

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

function append(t1, t2)
	for elem in all(t2) do
		add(t1, elem)
	end
	return t1
end

-- TODO: add a "levels" parameter...
function subdivide(vs, levels, is_path)
	if (levels<=0) return vs
	if (levels==nil) levels = 1
	local res = {}

	local length = is_path and (#vs-1) or #vs 
	for i=1,length do
		local v = vs[i]
		local w = is_path and vs[i+1] or vs[i%length+1]

		local line = subdivide_line(v,w,levels)
		line[#line] = nil

		append(res, line)
	end

	if is_path then
		add(res, vs[#vs])
	end

	return res
end

function subdivide_line(a, b, levels)
	if (levels<=0) return {a,b}

	-- a --- avg --- b
	local avg = (a + b)/2
	local aa = subdivide_line(a,  avg,levels-1)
	local bb = subdivide_line(avg,b,  levels-1)
	aa[#aa] = nil
	append(aa,bb)
	return aa
end

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
__label__
0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhdhddhdhhhh0hhhhhhhhhhhh0h0d00d00d000000h000000000000000h0h000h00000000h00000
hhhhhhhhhhhhhhhhhhhhhhhh1hhhhhhhhhhhhhhhhhhhhhhhhdhdddhhdhhhhhh0hhhhhhhhhhhhhh0hd0d0hdhh00h0h0h00000000000h00000000000000h000000
hhhhhhhhhhhhhhhhhhhhhhh1h1hhhhhhhhhhhhhhhhhhhhhhhhddddhdhhhhhh0h0hhhhhhhhhhhhhhhhd0hdhhhhh0hhh0h0h000000000000h0h00000000h000000
hhhhhhhhhhhhhhhhhhhhhhhh1hhhhhhhhhhhhhhhdhhhhhhhhhhhdhdhdhhhhhh0h0hhhhhhhhhhhhhhhhhhhhhhh0hhhhhhh00h0000h0000h0h000000000000h000
hhhhhhhhhhhhhhhhhhhhhhhhh1hhhhhhhhhhhhhdhdhhdhhhhhhhhdhdhhhhhhhh0h00hhhhhhhhhhhhhhhhhhhhhhhh0hhhhhh00000000000000hh000000000h000
0hhhhhhhhhhhhhhhhhhhhh1h1hhhhhh1hhhhhhhhdhdhhdhhhhhhhhddhhhhhhh0h00h0hhhhhhhhhhhhhhhhhhhhhh0h0hhhhhh000h00000000h0h0h000000h0000
h0hh0hhhhhhhhhhhhhhhh1h1h1hhhh1h1hhhhhhdhdhdhhhhhhhhhdhdhhhh0h0h0hh0hhhhhhhhhhhhhhhhhhhhhhhh0hhhhhhhh0h0h0hh00000hhh0000000h0000
0h00h0hhhhhhhhhhhhhhhh1h1h1hh1111hhhhhhhdhdhhhhhhdhhdhdhdhhhhhh0h0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0h0h0h000000hh0h0000000000
h0hh0hhhhhhhhhhhhhhhhhh1h1h1h11111hhhhhdhdhhhhhhdhdhhhhdhhhhhh0h0h0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0h000h00000h0h000000h0h
0h00h0hhhhhhhhhhhhhhhhhh1h1h1h1h11hhhhdhdhdhhhhhhdhhhhhhhhhhh0h0h0h0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00000h00000h000000hhh0
00000hhh0h0hhhhhhhhhhhh1h1h1h1h1h11h1dhdhdhdhhhhdhdhddhhhhhh0h0h000h0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh000h0hh00hh00h00000h0h
0000hhh0h0h0hhhhhhhhhhhh1h1h1h1h111111dhdhdhhhhhhdhdddhhhhh0h0000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhh0hhh00h000h0
00000hhh0h0hhhhhhhhhhhh1h1h1h1h1h11111hdhdhhhhhhhhdhdhdhhhhhh0000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0h00hhhh0h0h0000h
000h00h0h0h0hhhhhhhhhhhh1h1h1h1h111111dhdhd1hhhhhdhdddhhhhhhhh000hh0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0hhhhhh0hhh0h00
0hh0hhhh0h0hhhhhhhhhhhhhh1h1h1h1h1111hhdhd1d1hhhhhhhdhhhhhhhh000h00h0h0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0h0
h0hhh0hhh0hhhhhhhhhhhhhhhhhh1h1h1h111hdh1h11hhhhhhhdhdhh0hhdhh0h0h000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0h
0hhhhhhhhhhhhhhhhhhhhhhhhhhhh1h1h1h1h1h1h111hhhhhhdhdhd0h0dhh0d0h00h000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0
h0hhhhhhhhhhhhhhhhhhhhhhhhhh1h1h1h1h1h1h11111hhhhhddhdhd0h0d0d000hh0h0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
0hhh0hhhhhhhhhhhhhhhhhhhhhhhh1hhh1h1h1h1h1d1h0hhdddddhdhh0d0d00hdh0h0h0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
h0h0h0hhhhhhhhhhhhhhhhhhhhhh1h1h1h1h1d1dhd1d0d0dhdddddhdhh0h01hdhhh0h0hhhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hh0h0hhhhhhhhhhhhhhhhhhhhhhhhhh1h1h1h1d1dhd1d0d0dddddhdhhhh0101hhhhhhhhhh0hhhhhhhhhhhhhhhhhhhhhhhhhhh1hhhhhhhhhhhhhhh00hh0hhhhhh
hhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhh1h1h111d1d1d1d0h0ddhddh1hhhh010h1hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh1hhhhhhhhdhhhhhhhh000h0hhhhh
hh0h00hhhhhhhhhhhhhhhhhhhhhhhhh1h1h11111d1d1d0h0d0dd1d1h1hhh1011h1hhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0h00hhhhh
h0h00h0hhhhhhhhhhhhhhhhhhhhhhhhh1h1h111d1d0h010d0dd1d1d1h1hd01hh1hh00h00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhh0h00hhhhhh
0h0hh0hhhhhhhhhhhhhhhhhhhhhhhhh1h1h111d1d0hhh0hhd0dh1d1h1hhh1hhhhhhhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0hhhh
h0hh0hhhhhhhhhhhhhhhhhhhhhhhhh1h1h111d1d1dhhhdhdddhdh1h1hhhhdhhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhh0hhhhh
0h0hhhhhhhhhhhhhhhhhhhhhhhhhh1h1h11111d1d1dhh01ddddh1h1hhhhdhhhhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhdhhhhhhhh0h00hhh
00hhhhhhhhhhhhhhhhhhhhhhhhhh1h1h11111h1d1dhhhhdhdhhdhhdhhhhhdhhhhhhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhh1hhhhhhhdhdhhhhhhhhh000hh
0hhhhhhhhhhhhhhhhhhhhhhhhhh1h1h11111h1h1d0dhhhhdhddhhhhhh0hhh0hdhhhhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh1hhhdhhhdhdhhhhhhhhhhhhh
0hhhhhhhhhhhhhhhhhhhhhhhhhhh11111111101hhd0hhhhhdddhhhhhhh0h0h0hdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh1111hhhdhdhhdhhhhhhh0hhh
hhhhhhhhhhhhhhhhhhhhhhhhhhh111111111h10hhhd0dhhhh0dhhhhhhhh0hdhdhhhhhhhhhhhhhh0hhhhhhhhhhhhhhhhhhhhddhh1h1hh1hhhdhhhhhdhhhhhh00h
hhhhhhhhhhhhhhhhhhhhhhhhhhhhh11111h11110h00dhdhhhh0dhhhhhh0hdhd0dhhhhhhhhh0hh0h0h0hhhhhhhhhhhhhhhhhddhhh1hhhhhhhdhdhhdhdhhhhhh00
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh11111h11000dhhdhhhh0dhhdhhh0h0ddhd0hhhhhhhh000hh00000hhhhhhhhhhhhhhhhhhhhhhhhhddddhdhdhhddhdhhhhh0
hhhhhhhhhhhhhhhhhhhhhhhhhhhhh11111h0h1d0dhdhhdhh0h0ddh0hdh0h0dd0hd0hdhhhhhh0hhh000h000h0hdhhhhhhhhhhhhhhhhh1hddhdhdddddhdhhhhh0h
0hhhhhhhhhhhhhhhhh1hhhhhhhhhh111110h1hdd0dh0dhd0hhh0d0h0hd00dd0dd0ddhdhhhhhhhhhhh0h000000hhhhhhhhhhhdhhhddhh1dddhddhdhddhhhhhhh0
hhhhhhhhhhhhhhhhhhh1hhhhhhhh1h1111hhh1d0dhhhhd0d0h00000hd000dd000d0ddhhhhhhhhhhhhhhhh00000hhhhhhhhhhhhhhhhhhh1ddddhdddhddhhhhhhh
hhhhhhhhhhhhhhhhhhhh1hhhhhh1h1h11hhhhh0hh1hhhhd0h000h0h0dd0d000d00dhdhhhhhhhhhhhhhhhhh0000hhhhhhhhhhdhhhhhhhhhddddddddhdhhhhdhhh
hhhhhhhhhhhhhhhhh1h1h1hh1h1h1h1hh1hhh0hhhh1hh0hd00hh0h0ddd000dddd000hh0hhhdhhhhh0hhhh0h00h00h00hhhhdhdhhhhhhhhddddhddhdhhhhhhhhh
hhhhhhhhhhhhhhhh1h1h1hh1h1h1h1hhhh1hhhhhh1h11hd0ddh0h00000d1ddd00d0001h0hhhdhhhhhhhh0h00h00h0h00hhhhdhdhdhhhhh1dddddddhhdhhhhdhh
hhhhhhhhhhhhhhhhh1h1h1hh1h1h1h1hhhh0hhhh1h11hdhd00000010ddddd00100d00h1h0hhh0hhh0hhh00000000h000hhhhhdddhdddhdhdddddddhhhhhhdhdd
hhhhhhhhhhhhhhhh1h1h1hhhh1h1h1hhhhhhhhh1h101dh0000hhhhdddd000111100d00110hhhd0hhh0hhhh000000h0000hhhhhdddddddhhhdhdddhhhhhdhhddd
hhhhhhhhhhhhhhhhh1h1h1hhhh1h1hhhhhhhhd1h1010h0010ddddd00001111111100d1010hh000hhhhhh0hhh000h0h00hhhhhhhdddddddhhhdhdddhhdhhhddhd
hhhhhhhhhhhhhhhhhhhh1h1hh1h11hhhhhh0d1d00d000h101d0000h11111111111100d10h000000hhh0hh0hh000hh0hddhhhhhdhdddddddhhhdhddhdhhhhhhdh
h0hhhhhhhhhhhhhhhhhhh1hhhh1hhhh10h0h0d00d0d0h001d01h1111111h1111h111d0d0hh00000hh0h0000hh0hhhhddddhhhhhdddhdddddhdhdhhdhhhhhhhhh
0h0hh1hhhhhhhhhhhhhhhhhhhhh1hh1d10h0ddd00d0dd0dd0111111h11h1h11111111d0d0hh1100hhh00000000hhhhdddddhhhhddhdhdddhhhdhhdhdhhhhhdhd
h0hh1h1hhhhhhhhhhhhhhhhhhh1hhhd1d10hdd00d0dd0dd0011h11h1h1hh1hh1h11111dd000111hhhhh00d00000hhhhdddddhhdhddhdddddhhhhhhdhhhhhhhdh
0hhhh1hhhhhhhhhhhhhhhhhhh1h1hhhdh1h0hddd0d00dd0010h1111h1h1hh11h1h111010d000100hhh000ddd0000hhhhdddddhhddddddddhdhhhhhhhhhhhhhhd
hhhhhh1hhhhhhhhhh1hhhhhh1h1h11dh1h1hddd0d000d001d0dh11h1h11h1111h1h111010dd1000hhh00d0ddd00000000hddhhdhddddddddddhhhhhdhhhhhhhh
h0hhh1h1hhhhhhhh1h1hh1h1h1h11h1dh1hdhddd000d001dd00hhh1h11h1h1111hhh1111100d1000hh00dd00dd000000000ddhhdddddddddhdhhhhhhdhhhhhhh
hhhhhh1hhhhhhhhhh1h1hh1h111h11d11h1dd001dd0d01d0d0hhhhh1hh1h1h111hhh11111000dd00h00d011100d000000000hdhhdddddddhdhhhhhhdhdhhhhhh
h0hhh1h1hhhhhhhhhh1hh1h111h1h11111h11d1d10d0d0d11ddhhh1hhhh1h1111h111111111000d0000d11110d00h00000d00hhhhddddddhhhhhhhhhdhhhhhhh
hhhhhh1h1hhhhhhhhhh1hh11111h11111h11111101010d011dhdhhhhhh1h1h11h1h11111h111000d00d01000d1000000000000hhhdhdddhhhhhhdhhhhhhhhhhh
hhhhhhh1hhhhhhdh1h1h1h1111h1h11111h11111111110111d0hhhhhhhh1h1hhhh11111hhhh01100d0d10000dh1h0h000000000hhhdhdddhhhhdhdhhhhhhhhhh
hhhhhh1hhhhhhdhdh1h1h111111h1hhh1h1hh111111111111d0dhhhhhhhh1h1hh11111hhhh1h0110dd01000d01h010h00000000hhhhhhddddhhddhhhhhhhhhhh
hhhhh1hdhhhhdhdhdh1h111111h1hhhhhhh1dh111111111h11dhhhhhhhh1h1h1111111hhh1h110110d100dd01h010h0000000000hhhhddddhhhhhhhhhhhhhhhh
hh0hhhdhdhhdddhdddh1h1111h1hhhhhhhh0111111h1111dh1ddhhhhhhh11h1h111hhh1hhh111111d0d00d001100h0000h0h000hhhhhhdddhhhdhhhhhhhhhhhh
h0h0hdhhhhhhdhdddd1h1h11h1hhhhhhhhh111111111111h11dhhhhhhh111111h1hhh11hh1111d10d10dd00100000000h0000000hhhhdddddhdhdhhhhhhhdhhh
0h0hdhh1hhhhhdhddhd1h1111hhhhhhhhh01111111111111h1ddhhhhh11111111hhh11h1h111dhd0d100d1100000hhh000h00000hhhhdhddhdhdhhhhhhhhhhhh
h1hdhddhhhhhhhd1hdhd1111111hhhhh1hh11111111111111hdhhhhhhh1111111hhh111h111dhhhd111001h000000hhh00h0000hhhhhhddddhdhhdhhhhhhdhhh
1h1hddddhhhhhd1d1hdhdh1111h11hh1h1h111111111111110d0hhhhhhh1h11hhhhhh11111hddh0d1h1111d0h0hhh000hh0h000hhhhhhhddhdhddhhhhhhdhdhh
h1h1hdddhhhhdh1hddhdd1h11h1111hh1h1h11111111111110dhhhhhhh1h1h1hhhhh11111hhh100d11111h0hhh00000000h00000hhhhhdhdhhddhhhhhhhhdhhh
1h1h1dd1hhhhhhh1dddd1d1hh11111hhh1h1h1111111111110d1hhhhh1h11111hhh111111hhh10d11111hhhhh00000000000000hhhhhhhddhhhhhhhhhhdhhhhh
11h1hd1d1hhh1hh11dddd1hh111111hh1h1h1111111111111d1hhhhhhh1111111h11111111h111d1h11hhh00000000000000000hhhhhhhhhdhdhhhhhhdhdhhhh
111h11d1d1h1111h1ddddh11h1111h1hh1h11111111111110d1hhhhhhhh11111hhh111111h1h10d1hhhhhhh0000000000h0h0000hhhhhhddhdhdhhhhhhdhdhhh
11111d1d1d1111h111ddhdh11h1111h11h1h111111111110dd11hhhhhhh11111hhh1111111h110d11hhhhh000000000000h0000hhhhhhdhhdhdhhhhhhhddhhhh
h111d1ddd11111d11ddddhdh1111hh111hh1h1111111111d0d11hhhhhhhh11111h1h111111111d1d1hhhhhh00000000000000000hhhhhhddhdhhhhhhhdhddh0h
h1111ddddd111d1d11ddhhdh111h1hh1hh1h1111111111d00d1hhhhhhhhhh111h1h1111111111d11hdhhhhh00000000000000000hhhhhhhddhhhhhdhdhddddh0
1111d1dddd1111d11dddhdhdh1h1hhh111h1111111111110d11hhhhhhhhhhh11111h111111101d1d1hhhhh0h00000000000000000hhhhhddddhhhdhdhdhddhdh
h11dddddd1d11111d1d1dhdh1h1hhh1h1111hh11011111h1d11hhhhhhhhhhhhh11h1h1111111ddd1h1hhhhh000h0000000000h00hhhhhddddddhdhdhhhhhhd00
h1hddddddd1d111d1d1h11d111hhh1h1111hh1101001hhhhd11hhhhhhhhhhhhhhh1h1h11111d1d1d1hhhhhhh000h0000000000h0hhhhhhddddddhdhdhhhhhhh0
1111ddddddd1d11111h1hd1d11h11hh111hhh111011010h0d111hhhhhhhhhhhh1hh1h11111h1ddddhhhhhhh0h000hh0h000h00000hhhhhdddddhdhdhhdhhhhhh
11111ddddd1d1111111h1hdh1h11hhhhh1hhhh11110100d0d1hhhhhhhhhhhhhhh1hh1h1111dhdddhdhhhhhh00h0hhh00h0hhh000hhhhhhhdddhdhdhddhdhhhh0
111hd1dddddd11111111h1h1hhhh1hhh1hhhhh1111100ddd1hhhh0hhh1hhhhhhhh11h111111dddhdhhdhhhhh00hhh0hh000h0hh0hhhhhhdddddhdhdhddhhhhhh
11hd1dddd1dddd11d1111h1h1hhhh1h1hhhhhhh10000001d10h00h0hhhhhhhhhh1h11111111d1dhhhdhhhhh0hhhhh0000000h000hhhhhdhdddddddhddddhhhhh
1111d1d11ddddd111d111hh11hh1hhhhhhhhhh100000000d100000hhhhhhhhhh1h11111111d1ddhhdhdhhh000hhhh000000hhh0h0hhhdhddddddddddddhdhhhh
1h111d1d1dddd1111d111111h11hhhhhhhhhhhh0dddddd0d1d00000hhhhhhhh1h1h111111d1d1dhhhdh0h00dh0hh0hh00000h0hhhhhhhddddddddddddhdhdhhh
h1111dd1d1ddd11111111111111hhhhhhhhhhh0d00000dddddd0000h0hhhhh0hhhh11111d1d1hd000h0h00dh0hh0h0000000000hdhhhhdddddddddddhdhdhhhh
1h11111d11ddd111111111111111hhhh1hhhhh0dd00000d100d00000h0hhhhhhh0h1111d1d1ddd0000000000hhhh0h00000000h0hdhdhdddhddddddddhdhhhhh
h1111111111dd111111111111111hhh1h1hhhh0d11111d01000d000000d0hhhhhh111111d1d1ddd00000dd00hhh0h0hh0000000hdhdhddddddddddddhdhhhhh0
1111111d11d1d111111111111111hh1h1hhhhhd11101d111111d000000000hhhh01111111d1d11ddd000d00hdhdhhh00h00000h0hdhdddddhddddddddhdhhhh0
hh1111d1d11d111111111111111h1hh11hhhhhd1001d00111110d0000hh0000hhh01111101d1d10ddd00dd0dhdhdhhhh00000h0hhhdhdddhdhddddddddddhhh0
1h1111111111111111111111111hhhh111hhh0d101d001111111d00000h0h000h001h1101d0d11100dddd1dhdhdhdhhhh00000hhhdhdhdhdhdhddddddddhhhh0
h1111111111111d11111111111h1hhhh11hhh0d1dd0011h1h1110d000h0hhh0dh01h1h1101d1d11110ddddddhdhdhhh000000hhhdhdhdhdhdhdddddhdhhdhhhh
1h111111d111111d11111111111h1hhhhhhhhd1d00h11hhh1h111d000hhhhhd0h1h1h1d01dhd1d11100ddddddddhdhh0h00000hdhdhdhdhdhdhdddddhdhhhhh0
hhh11111111111d1d11111111111hh1hhhhh0dd0hh1111hhhh1110d0000hhh00101h000d0hd1d1000111dd11ddhdhd0h0h000hdhdhhhdhdddhdddddhdhhhhh00
hhh111111111111dd1111111111h1hh1hhhhh01h11111h1hh11111dd000000h0010000d0d01dh00h0ddd11111d1hd0h0h0h0h0hdhhhhhdhdddddddddhhhhh0h0
h1h1111111d111dd1d111111h11hhhhh0hhh0111111111h11111110dd000000000100d0dh1dh00ddd001111111dh0h0h0h0h0h0hhhhhhhdhddddddddhhhhhh00
1h1h111111111d1dd1d111111h11hhhhh1h0h1111111111hh1111110d0d000000101d0dhhhh00d000d01111111hdh0h0hh0hh0h0hhhhhdhddddddddhhhhhh00h
h1h11111111111d11dd11111111h1hhhh11011h1111111111h1111110ddd000000100dhdhh0hd000d111110111dh0h0hhhh00h0hhhhhdhddddddhddhhhhhh0h0
hhh11111111111111d1d11111111hhhhhh0111111111111111111111100dd0d000000hhh00hd00111d111h1d1dhdh0hhhhhhh0hhhhhhhdhdddddddhdhhhhhh0h
hh1h111111111111ddd11111111111hhhh111111111111111111111111100dddd00000h000d00111d1111111d0dhdh0hhh000hhhhhhhdhdhddddhhdhhhhhh0h0
0hh1h1111111111111d1d1111111111hh1h1111111111111111111111111100ddd0000h00d001111111111110dhdhhh0h0000hhhhhhdhdhdhdddhhhhhhhhhh0h
10hh111111111111111d111111111111h11h1111111111111111111d110110d00ddddd00d001111111111111d0dhh0hh0hh0hhhhhhdhdhdhhhdhhhhhhhhhhh0h
0hhhh11111111111111111111111111111h1111111111111111111d1d10001111000dddd001111111111111d0dhd1hh0h0hh0hhhhhhdhdhhhhhhhhhhhhhhhhhh
hhhh1h11111111111111111111111111111h1111111111111111111111100111110d00d001111111111111ddd1d1h10h0hhhhhhhhhdhdhdhhhhhhhhhhhhhhhhh
hh01h1111h111h111111d11111111111111111111111111111111111111111111111dd0011111111111111hd1dhh1h1hhhhhhhhhhhhdhdhhhhhhhhhhhhhhhhhh
h0h011h1h1h1h1111111111d11111111111111111111111111111111111111111111111111011111h111111hd1dhh1hhhhhhhhhhhhhhdhdhhhhhhhhhhhhhhhhh
h00h1h111hhh1h111111111d111111111111111111111111111111111111111111111d111110111h0h1101h11d11hhh0hhhhhhhhhhhdhdhdhhhhhhhhhhhhhhhh
hhhhhhh1111hhh111111111111111111111111111111111111111111111111111111d1d111h110h0h1h0111hh11h1h0h0hhhhhhhhhdhdhdhdhhhhhhhhhhhhhhh
hhh0hhhh111hh11111111111111111111111111111111111111111111111111111111d111111110h11111111h1h1hhh0h0h0hhhhhdhdhhhdhhhhhhhhhhhhhhhh
hhhhh1h1h1111hh11111111111111111111111111111111111111111111111111111d1d111h11010h1111h111h1hhh0h0h0hhhhhhhdhhhhhhhhhhhhhhhhhhhhh
hhhhhhhh11111hhhh1111111111111111111111111111111111111111111111111111d1111110101111111hhh1h1hhh0h0h0hhhhhhhhhhhhhhhhhhhhhhhhhhh0
hhhhhhhh111111hhhh1111111111111111111111111111111111111111110101111d1111h111101011111h1h1h1h1hhhhh0h0hhhhhhhhhdhhhhhhhhhhhhhhh0h
hhhhhhhhhh111h1hh1111111111h11111111111111111111111111111111101111d1111h1h110h01111111h1h1h1h11hhhh0hhhhhhhhhdhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhh1hhh1111111111h1h111111111111111111111111111111111111d1d1111h1h0h0111hh1111h1hhh1hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0
hhhhhhhhhhhhh1h111111111111h11111111111111111111111111111111111111d1111h1h1h0h0101h111h1hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0h
hh00hhhhhhhh1h1hh1h1111111111h111111111111111111111111111111111111111111h1h1hhh01hh11h1h1hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00
h0h00hhhhhhhh1111h1hh1111111111111111111111111111111111111111111111111111h1hhh0hhhh111h1hhhhhhhhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhh00
hh00hhhhhhhhhh1110h11h1111111111111111111111111111111111111111111111111111h11hh0hhhh111h1hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0
hh0h0hhhhh0h0hhh0101h11111111111111111111111111111111111111111111111111111d1hhhh0hhh11h1h1hhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00
hhh0h0h0h0h0h00hh01111h11111111111111111111111111111111111111111111111111d1hhhhhhhh1h11h1h1hhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0
hh0hhh00hh0h00hh0h101hhh11111111111111111111111111111111111111111111d11111d1hhhh0h1h1h10h1hhhhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
h0hh000h0h0h0h00h00hhhhh11111111111111111111111111111111hh11111111111d11111h1h00hhh1h1hh1h1hhhhh0h0hhhhh1hhhhhhhhhhhhhhhhhhhhhhh
hhhh0000hhh0h000h0h00hh1hh11111111111111111111111111111hhhhh1111111111111111h0h0hh1h1h1hh1h1h1h1h0h0hhhhhhhhhhhhhhhhhhhhhhhhhhh0
00hh00hhhhhh000h0h0h001hhhh11111111111111111111111111111hhhh11111111111111111h0hhhh1h1hhhhhh1h1hhh0hhhhhhhhhhhhhhhhhhhhhhhhhhhh0
0h00hhh00hh00000h0h0hhhhhhhhh111111111111111111111111111111h1111111h1111111111h0hhhh1h1hhhhhh1hhhhhhhhh1hhhhhhhhhhhhhhhhhhhhhh0h
h0hhhhh0000hh00000hhhhhhhhhhhhh111h11111111111h111111111111111111111h11111111h0h0hhhh1hdh01hhh1hhhhhhhhhhhhh1h1hhhhhhhhhhhhhhhh0
0h00hh000h0h0h0000h00hhhhhhhhhh11hhh111111111h1h1111111111111111111h1h111111hhh0hhhh1h1hdhh1hhh1hhhhhhhhhhhhh1hhhhhhhhhhhhhhhhh0
000000h0h0h0h0h000000hhhh0hhhhhh1hh11h11111111h1hh1111111111h1111111h1111111hhdhhhhhh10dhd1hhhhhhhhhhh1hhhhh1h1hhhhhhhhhhhhhhh0h
0000hhhhhh000hhh00000hhh0hhhh000hhh1h1h11111111hh1h11111111h1h1h11111111111hhh01hhhh101hdhh1hhh1hhhhh1h1h1h1h1h1hhhhhhhhhhhh0hh0
00000hhh0h000hhhhh00h0h00hhh0000hhhhhh1h111111111h1h11111111h1h1h111h11111hhhh1hhhhh01h1h0hh1h1hhhhh1h1h1h1h1h1hhhhhhhhhhhhhhh0h
0h0000h0h0h0h0hhhh000h000hh000001hh1hhhhh1111111h1h1h11111h1111h1h1h1h11111hh1h1h0h0hh1h1h01h1h1hhhhh1h1h1h1hhhhhhhhhhhhhhhhh0h0
h00000000h0h000hh0h00000h0hhhh00hhhh1hhhhh1111111h1h1hh11h1h1hh1h1h1111111111h1h1h0h01h1011d1h1hhhhhhh1h1h1h1hhhhhhhhhhhhhhhhh00
00h0000hh0000000h00h00000hhhhhh00hhhhhhhhhhh111h111hhhhhh1h1hhhh1hhh111111111111h1h001101111h1hhhhhhh1h1h1h1h1hhhhhhhhhhhhhhhhhh
0h00000hh00000000000h0000hhhh000h0h00hh0hhhhh0h1h0h0hhhh1hhh1hhhhhhhhh1hhd1d11111h10101d111d1hhhhhhh1h1h1hhh1hhhhhhhhhhhhhhhhhh0
000000h000000000000h0h000hhh0hhh00000hhhh10h0h0h000hhhhhhhhhh1hhhh1h1hhhh1d11111111101d111d1d1hhhhhhh1hhhhhhhhhhhhhhhhhhhhhhhhhh
000h0000000000000000000000h00hhh000000h00h0000hh0000h1hhhhhhhhhh11h11hh11d1d1111111d1d11111d1dhhhhhh1h1hhhhhhhhhhhhhhhhhhhhhhhhh
00h0000000000000000000h0000000hhh0h00h00h000h0hh00000010hhh0hhh1h1hhhhhhh1dhd111d1hhd1d111d1dhhhhhh1h1h1hhhhhhhhhhhhhhhhhhhhhhhh

