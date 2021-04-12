pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init()
	pal({[0]=7,6,12,12+128,1,1+128},1)

	noisedx, noisedy = rnd(1024), rnd(1024)

	cls(5)

	t = 0
	tf = 0
end

function _update()
	t += 1/30
	tf += 1

	local freq = 0.005
	local amp = 1
	local persistence = 0.2

	local dd = 0.0

	noisedx += rnd(0.002)
	noisedy += rnd(0.002)

	for i=1,700 do
		local x,y = rnd(128),rnd(128)
		local max_amp = 0
		local c = 0

		local h = 
			cos(x/128)/2 + cos(y/128)/2 
			+ x/64 - y/64
			- t/4
		local h = flr(h)%2

		local value = Simplex2D(x*freq+noisedx, y*freq+noisedx)
		value = (value + 1 + t/4)*2

		local diff = value - flr(value)

		if h%2==0 then
			if diff<0.5 - dd then
				c = 2
				c = c%6
			else
				c = 5
			end
		else
			if diff>0.5 - dd then
				c = 4
			else
				c = 3
			end
		end

		circ(x,y,1,c)
	end
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
		line(p1.x,p1.y,p2.x,p2.y,col)
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
		line(p1.x,p1.y,p2.x,p2.y,col)
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

local Perms = {
   151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
   140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
   247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
   57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68,   175,
   74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111,   229, 122,
   60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
   65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
   200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
   52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
   207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
   119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
   129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
   218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
   81,   51, 145, 235, 249, 14, 239,   107, 49, 192, 214, 31, 181, 199, 106, 157,
   184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93,
   222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
}

-- make Perms 0 indexed
for i = 0, 255 do
   Perms[i]=Perms[i+1]
end
-- Perms[256]=nil

-- The above, mod 12 for each element --
local Perms12 = {}

for i = 0, 255 do
   local x = Perms[i] % 12
   Perms[i + 256], Perms12[i], Perms12[i + 256] = Perms[i], x, x
end

-- Gradients for 2D, 3D case --
local Grads3 = {
   { 1, 1, 0 }, { -1, 1, 0 }, { 1, -1, 0 }, { -1, -1, 0 },
   { 1, 0, 1 }, { -1, 0, 1 }, { 1, 0, -1 }, { -1, 0, -1 },
   { 0, 1, 1 }, { 0, -1, 1 }, { 0, 1, -1 }, { 0, -1, -1 }
}

for row in all(Grads3) do
   for i=0,2 do
      row[i]=row[i+1]
   end
   -- row[3]=nil
end

for i=0,11 do
   Grads3[i]=Grads3[i+1]
end
-- Grads3[12]=nil

function GetN2d (bx, by, x, y)
   local t = .5 - x * x - y * y
   local index = Perms12[bx + Perms[by]]
   return max(0, (t * t) * (t * t)) * (Grads3[index][0] * x + Grads3[index][1] * y)
end

---
-- @param x
-- @param y
-- @return Noise value in the range [-1, +1]
function Simplex2D (x, y)
   -- 2D skew factors:
   -- F = (math.sqrt(3) - 1) / 2
   -- G = (3 - math.sqrt(3)) / 6
   -- G2 = 2 * G - 1
   -- Skew the input space to determine which simplex cell we are in.
   local s = (x + y) * 0.366025403 -- F
   local ix, iy = flr(x + s), flr(y + s)
   -- Unskew the cell origin back to (x, y) space.
   local t = (ix + iy) * 0.211324865 -- G
   local x0 = x + t - ix
   local y0 = y + t - iy
   -- Calculate the contribution from the two fixed corners.
   -- A step of (1,0) in (i,j) means a step of (1-G,-G) in (x,y), and
   -- A step of (0,1) in (i,j) means a step of (-G,1-G) in (x,y).
   ix, iy = band(ix, 255), band(iy, 255)
   local n0 = GetN2d(ix, iy, x0, y0)
   local n2 = GetN2d(ix + 1, iy + 1, x0 - 0.577350270, y0 - 0.577350270) -- G2
   -- Determine other corner based on simplex (equilateral triangle) we are in:
   -- if x0 > y0 then
   --    ix, x1 = ix + 1, x1 - 1
   -- else
   --    iy, y1 = iy + 1, y1 - 1
   -- end
   -- local xi = shr(flr(y0 - x0), 31) -- x0 >= y0
   local xi = 0
   if x0 >= y0 then xi = 1 end
   local n1 = GetN2d(ix + xi, iy + (1 - xi), x0 + 0.211324865 - xi, y0 - 0.788675135 + xi) -- x0 + G - xi, y0 + G - (1 - xi)
   -- Add contributions from each corner to get the final noise value.
   -- The result is scaled to return values in the interval [-1,1].
   return 70 * (n0 + n1 + n2)
end

-- 3D weight contribution
function GetN3d (ix, iy, iz, x, y, z)
   local t = .6 - x * x - y * y - z * z
   local index = Perms12[ix + Perms[iy + Perms[iz]]]
   return max(0, (t * t) * (t * t)) * (Grads3[index][0] * x + Grads3[index][1] * y + Grads3[index][2] * z)
end

--
-- @param x
-- @param y
-- @param z
-- @return Noise value in the range [-1, +1]
function Simplex3D (x, y, z)
   -- 3D skew factors:
   -- F = 1 / 3
   -- G = 1 / 6
   -- G2 = 2 * G
   -- G3 = 3 * G - 1
   -- Skew the input space to determine which simplex cell we are in.
   local s = (x + y + z) * 0.333333333 -- F
   local ix, iy, iz = flr(x + s), flr(y + s), flr(z + s)
   -- Unskew the cell origin back to (x, y, z) space.
   local t = (ix + iy + iz) * 0.166666667 -- G
   local x0 = x + t - ix
   local y0 = y + t - iy
   local z0 = z + t - iz
   -- Calculate the contribution from the two fixed corners.
   -- A step of (1,0,0) in (i,j,k) means a step of (1-G,-G,-G) in (x,y,z);
   -- a step of (0,1,0) in (i,j,k) means a step of (-G,1-G,-G) in (x,y,z);
   -- a step of (0,0,1) in (i,j,k) means a step of (-G,-G,1-G) in (x,y,z).
   ix, iy, iz = band(ix, 255), band(iy, 255), band(iz, 255)
   local n0 = GetN3d(ix, iy, iz, x0, y0, z0)
   local n3 = GetN3d(ix + 1, iy + 1, iz + 1, x0 - 0.5, y0 - 0.5, z0 - 0.5) -- G3

   -- Determine other corners based on simplex (skewed tetrahedron) we are in:
   local i1
   local j1
   local k1
   local i2
   local j2
   local k2
   if x0 >= y0 then
      if y0 >= z0 then -- X Y Z
         i1, j1, k1, i2, j2, k2 = 1,0,0,1,1,0
      elseif x0 >= z0 then -- X Z Y
         i1, j1, k1, i2, j2, k2 = 1,0,0,1,0,1
      else -- Z X Y
         i1, j1, k1, i2, j2, k2 = 0,0,1,1,0,1
      end
   else
      if y0 < z0 then -- Z Y X
         i1, j1, k1, i2, j2, k2 = 0,0,1,0,1,1
      elseif x0 < z0 then -- Y Z X
         i1, j1, k1, i2, j2, k2 = 0,1,0,0,1,1
      else -- Y X Z
         i1, j1, k1, i2, j2, k2 = 0,1,0,1,1,0
      end
   end

   local n1 = GetN3d(ix + i1, iy + j1, iz + k1, x0 + 0.166666667 - i1, y0 + 0.166666667 - j1, z0 + 0.166666667 - k1) -- G
   local n2 = GetN3d(ix + i2, iy + j2, iz + k2, x0 + 0.333333333 - i2, y0 + 0.333333333 - j2, z0 + 0.333333333 - k2) -- G2
   -- Add contributions from each corner to get the final noise value.
   -- The result is scaled to stay just inside [-1,1]
   return 32 * (n0 + n1 + n2 + n3)
end
__label__
chccccccchhhhhhhhhhhccccccccccccchccccchchccchcccchhhhchchhhhhhhhhhhhhhhhh111s1s111111111111111111111h1hhhhhhhhhhhhhhhhhhhchhhhh
hccccccccchhhhhhhhhhhccccccccccccccccccccccccchccchhhhhcchhhhhhhhhhhhhhhhc1111s1s11s1111111111111111h1hhhhhhhhhhhhhhhhhhhhhchhhh
ccccccccchhhhhhhhhhhhhcccccccccccccccccccccccccccchcchhchchhchhhhhh11hchchc1ss1s11s1s11111111111111111hhhhhhhhhhhhhhhhhhhhhhhhhh
ccccccchhhhhhhhhhhhhhccccccccccccccccccccchhccchchcccchhchhchchhhhhhhchchccssss11s1ssss1s11h1111111h1h1hhhhhhhhhhhhhhhhhhhhhchhh
cccccchhhhhhhhhhhchhccccccccccccccccccccchhhhchhhhhcchhhhhhhchhhhchhhhc1hcccss1s1sssssss1sh1111s11111shhhhhhhhhhhhhhhhhhhhhhhhhh
cccchhhhhhhhhhhcchccccccccccccccccchhchchhhhhhhhhhhhhhhhhhhhhhhhchchhhhhhcccc1s1sss1sss1ss1h11s1s111s1shhhhhhhhhhhhhhhhhhhhhhhhh
cccchhhhhhhhhhhhcccccccccccccccchchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhcchcchhhhc1ccs1ssss111ss1s11h1ss1111s1hhhhhhhhhhhhhhhhhhhhhhhhh
ccchchhhhhhhhhhcccccccccccccccccchchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchcccchh1cccscsssssss111s1ss1ssss11s1sshhhhchhhhhhhhhhhhhhhhhch
ccchhhhhhhhhhhccccccccccccccccchcchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchchcccccchcccscsssss1s111ss1s1sss1s1sssshhccchchhhhhhchhhhhhhhc
chhhhhhhhhhhhccccccccccccccccchchchhhhhhhhhhhhhhhhhhhhhhhhhhhhhchchhcccchcchcccccss11s1ssss1s1ssss11ssssshccccchcchhhchchchhhhhh
hhhhhhhhhhchhcccccccccccccchchchchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchcchcchchcchccccsss1sssssss11sss11sssss1cssccccchchchchchchhchh
hhhhhhhhhhhcchcccccccccccchchchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchccchchcccchhccsssssssssssssssss1ssssssssscccccchccchchcchchch
hhhhhhhhhhccccccccccccccchchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchchchchhccccccc1csssssssssssssss11ssssssssshccccccccccccccchchh
hhhhhhhhcccccccccccccccchhhhhhhhhhhhhhhhhhhhhchhhhhhhhhhhhhhhhhccchccchhhcccccccc1cccssssssssssssssssssssssssshccccccccccccchchh
hhhhhhhchccccccccccccccchhhhhhhhhhhhhhhhhhhhchhhhhhhhhhhhhhhhhhcccccccchhcccchccccccccssssssssssssssssssssssssshcchcccccccccccch
hhhhhhcccccccccchcccccchhhhhhhhhhhhhhhhhhhhhhchhhhhhhhhhhhhhhhhhcchhccchhcccccccccccccsssssssssssssssssssssssscschchcchccccccccc
hhhhhhhccccccccccchcchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchchcccccccchccccccccscssssssssssssssssssssssssssccchcchcccccccc
hhhhhhhcccccccccccchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchchcccccchchccccccccss1ssss1sss1sssssssssssssssshcccccccchcccc
hhhchhccccccccccccchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchhhhhhhhhhhhhhhcccchccccccccccccccccccs1ss1s1sss1sssssssssssssssccccchcccccccc
hhhhcccccccccccccchhhhhhhhhhhhhhhhhhhhhhhhhhhhhcchchhhhhhhhhhhchccccccccccccccccccchcccc1s1s11s1s1s1ss1ss1s11ssss1ccccccccchcchc
chhccccccccccccchhhhhhhhhhhhhhhhhhhhhhhhhhhhchhhhhhhhhhhhhhhhchccccccccccccccccccchchhccc1h1111s111s11111s11111s1c1c11c1cchchhcc
hccccccccccccchcchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchhchhcccccccchcccccchhchhchsh111111111111s11111s111c111111cchcccc
chccccccccccchchchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchchchcchcccchcccccccchchchhhhhhsh111ss1111111s11111111s1sc11111hcccccc
hccccccccccccchchhhhhhhhhhhhhhhhhhhchhhhhhhhhhhhhhhhhh1hhhchhhchhchcccccccchcchhhchchhhhhhhh111111111111111111111s1111c111chcchc
ccccccccccccchhhhhhhhhhhhhhhhhhhhhchhhhhhhhhhh1h1h1h11h1h1hhhchhhcccchccccccchhhhhcchhhhhhhh1h111111s11111111111111111111111chch
cccccccccccchchhhhhhhhhhhhhhhhhhhchchhhhhh1hh1h1h1h1111h1h1schcccccccchccccchchhhchchhhhhhhhh1h1111s1111111111111s11111s111111hh
ccccccccccchchhhhhhhhhhhhhhhhhhcc1111hc1h1c11h111111111111s1ssccccccccccccchchccchchchhhhhhhhh1h11111s1111111111111s111111111h11
cccccccccccchhhhhhhhhhhhhh1hhhc1c111c1111c1111h1111111111hhsshsccchccchchhhchccchhhchhhhhhhhhhch1c11s1sss11111s11111s1s111c1h11h
ccscscccccschhhhh1hhhhhhh1h1h1111111111111111111111111111hs1sss1ssccccchhhhhcccchhhcchhhhhhhcchcchc1sssssssss1s1ss1s1s1s11111111
cssscscssscshhhh1111hh11h11111111s1111111111111s11111111111s1sssssssc1chhhhhhcchhhhhchhhhhhchccchccsssssssssss1ssssssss111111111
cssssssssss1hhhhh11hc1111111111111111s1111111111s1111111111ssssssssssc1chchhhchhhhhhhhhhhhccchchccccssss1ssss1sssshsss111s111s11
ssssssss111111hh11111111c111111111111111111111111111111111s1ssssssss11cccchhhhhhhchhhcchchcccccchccc1s1ss1ss1s1sssshs1ss1ssss1s1
sssssss1111111111111111h1s1s111111111111s111111111111111s1ss1ssssss1s1s1ccch1hhhhhchcchchchcccccccccc1ssss1ss1sssssshss1s1s11s1s
sssss1111111111111111111s111s11111111s1s1111111111111s1sss1ss1ssssss1s111sc1h1hhhhhchcchccchchcccccccccsssssssssssshssss1ssss1ss
ssss1111111111111111111111111s1ss1111111111111111111s1sssss1sssssssssh1111cc1hhhhhchchcccccchcccccccccccsssssssssssssssssssssssh
ssssss1111111111111111111111s11s1s111111111111111111sshsssss1sss11s1s1111c1111hhchhhhcchccchcccccccccccssss1ssss1sssssss1sssss1s
sssssss11h11111111111111s1111111s1s11111111s1111111s1ssssssssss1111s1111s11111scschchchccchcccccchcccccchs1s1ss1ss1ssssssssssss1
ssssss11111111111111111111111111111s1111111111111111ssssss1ssssh11s1111111111shscsshccccccchcccchchhccchchs1hs1s11s1sss11sssssss
sssss1s111111111111111111s111111111s1111111111111111sssss1sssshs1s1ss111111111sssshsccccccccchchchhchhcccccssss1ss1ss111111ss1ss
ssssss111111111111111111111s111s11sss11111111111s111sssssss1shsss1111h111111s1s1s1sccccchccchchchhhhhchhchshss1s1s1s1s1111h1111s
sssss1111111111111111111111111111111111111111s1s1s1s1sssssss1ssss1111111111s1s1sshccscchchcchhchchhhchhhhchhhhs1111111s11s1s111s
ss1s111111111111111111111111111111111111111h11s1s11ss11ssss1s1ssss111s111s11s1sssssscshchhchhhhhhhhhhhhhhhhhhsh111111111s1s1s11s
ssss1111111111h1111111111s11111111111s1111111s1s1111s1s1ssssssss11s1s111s1ss1s1ssssssshhhchhhhhhhhhhhhhhhhhhhh11111111111s1s1111
sssss11111111h1111111s1111s111111111ss111111s1ss111s1s1sss1sss111111111s1s11s1ss1ssss1shhhhhhhhhhhhchhhhhhhhhhh11111111111111111
sssss111111111111111111111sh1111111s11s111111ss1s111sssss1s1s1s111111111s1ss11s1s1ss1s1hhhhhhhhhhhchhhhhhhhhhhhhh1111s1111111111
s1ssss1111111111111111111s1sh1111111s1111111111s11sssss1ss11111s1111111s1ss1ss1s11s1s1chhhhhhhhhhchhhchhhhhhhhhhhhh1s1s1111111s1
ss1sssh11111111111111111111s11111111111h11111s111sssss1s1s111111111s11s1s1ss11s1111s1sssh1hhhhchchhhchchhhhhhhhhhh1hc11111111111
sss1s111111111111111111111s1s111111111111111s1ss1ssssss1s1s11111111s1s1s1sssssss1111s1s11c1hhhhchhhhhcccchhhchhhhhcc1cc11s11s111
ssss1111111111111111111s111s111s11s1111111111sssssssssssss11111111s1s1s1s1ssssss111s1s1s11c1hhchchhhcccccchccchccchccc1cs1ss1s11
sssshs1111111111111111s1111s1s11111s1111ss11scsssss1sssss1s111111s1s1s1ssssssss1s111s1s11h1h1hhchhhcccccccccccccccccchcccs11sss1
sssss1s1s111111111111s1s111111111111111ss1s1cscsscssssshhs11111111s1ssssssssss1111111s111111shhhhhhcccccccccccccccccccccc111ssss
ssssss1s1s1111111111111s111111111111111s1s1s1csscscscshhhhsh1111111ssssssssss11111111111111sssshccchcccccccccccchcccchccc11sssss
sssssssss1111111111111111111111111111c1hscscccccscshscshhsh1h1h1s1sssssss11s1s11111111111111ssscccccccccccccccccccccccccccc1cscs
sss1sssss111111111111111s11111h11111c1c1c1cccccccshshsshhh1h1h1c1ssssssss1s1s111111111111s1s1scscccccccccccccccccccchcccccccccsc
sssss1ss1s1s1h111111111111111hh1h11h1c1hhccccccc1c1hhhshhhh1hsc1sssss1ssss1s111111111s11s1s1shscccchcccccccccccccccccccccccccccs
scssscs1s1s1s11111111111sh11hhhh1hhhcc1cccccccc1c1chhhcshh1hsh1ccssssssssss11s1h1111s1ss1s1s1shshccccccccccccccccccccccccccccccs
cscscscshsss1s1s11111111111h1chcchhcccchccccchc1hcchhhchhchch1hchcssscss111111s111111ss1sss1s1ssccccccccccccccccccccccccccccccsc
cccccc11sssss1s1s1111hh11c1cchcccchccchchcccccchchhchchhhhchsh1hccsscsc111111s111111s11ssssssssssccccccccccccccccccccccchccccccc
ccccccssscc11s1s1111ch1hc1c1ccccccccchchchcccccchchhchchhhhsh1hhccccscss11h11111111sss11ssssssssssccccccccccccccccccccccccchcccc
cccccccscccc111c111c1chc1c1ccccccccccccccchchcchhhhchhhhhhhhhhhhcccccsss111111h111hsss11sssssssssssccccchcccchccccccchcccccccccc
ccchccscccc1ccccc1c1c1ccc11ccchchcccccccccccccchhhchhhhhhhhhchccccccchs11s111111111ssss1sssssssssscschchchcchchhhccchhhccccchccc
cccchcccccccc1cccccc1hcccchccccccccccccccccccchhhhhhhhhhhhhccccccccchchhh111111s1111ss1ssssssshsscsshchchchcchhhhhhhhhhcccchhhch
ccccccccccc1cc1cccccc1hcccchccccccchcccccccccchhhhhhhhhhhhccccccccchchhhhh111111s111s1ssssssssshssssshcchhhccchhhhhhhhhcccchhhhc
ccccccccccccccchccccccc1ccccccccccccccccchcccchhhhchhhhchcccccccchhchchhh1111111111ssssssssssssssssss1chchchchchhchhhhhcccchhhch
hchccccccc1ccchchccccccccchccccccccccccchhhcchhhhhhhhhchcccccccchcchhchh1111111111sssssssssssssssss1111chchhhchhhhhhchhccchchhhh
hhchccccccccccchc1cccccccccccccccchccccchhhchhhhhhhhhhhchhchccchccchchhsh1111111sssssss1ssssssss111s111cchhchhhhhhhhhhhhhhchhhhc
hhhccccccccccccc1ccccccccccccccchhchccchchchchhhhhhhchchcccchchchchchhhhhh11111s1ssssssssssssss1111111hhchchhhchhchhchhhhhhhhhhh
hhchcccccchcccccccccc1ccccccccchchcccccchchchchhhhhchchcccccchhchcchhhhhhh111ss1s1s1ssssssssss1s11s1111hhhhhhhcchhhhhhhhhhhhhhhh
hchhhhccchchcccccccccccccchccccchccccccchchhhhhhhhhhchhccccchcchchchhhhhh1h1s1ss1s1s1ssssssss1s1s1ss11h1hchhhhhhchhhhhhhhhhhhhhc
hhhhhhhccchchhccccccccccccccccccccccccchhhhhhhhhhhhhhhchcccccchhhcchhhhhhhhh1s1sssssssssssssss1s11s1s111chhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhcccchchchcccccccccccchchchchcchchhhhhhhhhhhccchhcccccchhchchchhhhhhhh11sssssssssssssss1s11s1c1c1c1hhhhhhhhhhhhhhhhhhhhhhh
hhhhchhhcchchchchhhcccccchchhhchchhhhchchchhhhhhhcccchhcccccchchchhhhchhhhh111sssssssssssssss111s1s111c1hchhhchhchhhhhchhhhhhhhh
hhhhhhhhccchchchhhhhccchcchhhhhchhhhhhhhhhhhchhhccccchhccccccchchhhhchchhh1hhsss1sssssssssss1s1s1sss111chhchhhhchchhhhhchchhchhh
hhhchhhhhchhhhhhhhhcchhchchhhhcchhhhhhchhhhhhhhhccccccccccccchchchhhhhhchhhhchsssssssssss1ss11s1s1ss111hchhchhchchhhhhhhchhhhhhh
hhhhchhhhhhhhhhhhhhchchhchhhhcccchchhhhhhhhhhhhhhchccchccccccchchhhhhhshhhhchcssssssssssssh1s1ss11s111cshchhhhhchhhhchhhhhhhhhhh
hhchhchhhchhhhhhhhhchhcchhchhcchchhhhhhchhhhcchchchhchchchccccchchhhhhhhhhhccsssss1sssssssss1ss11111111hhhchhhchhhhhhchhhhhhhhhh
hhhhhhhhchhhhhhhhhhhchhhhchhhhhchhhhhhchhhcchcccchcccccccccccccchcchhhhhhcc1cssssssssshsssssssss111111shhhhhhchhhhhhhhchhhhhhhhh
chhhhhhhhchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhchcchchcccccccccccchhhccchhhhhhccccssssssssssshssssssss1111111hhhhhhchhhhhhhhhhhhhhhhhc
hchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhcchchchcccccccccchhhhhchchhhhhhccs1ssssss1sssssssssss1s1111111hchhchhhhhhchhhhhhchhhch
ccchhhhhchhhhhhhhhhhhhhhhhhhhhhhhhhchhhhhhccchhhchcccccccccchhhchhhhhhhhhhhhs1ssss1shsssssssss1s1111c111hhhhhchhhchhhhhhhhhchhhh
ccccchhchchhhhhhhhhhhhhhhhhhhhhhhccccchhhcccchhchcccccccccchhchhhhhhhhhhhhhc1sssssssshsssssssss1ss1s1c1hhhhhchhhchchhhhhhchhhhhh
cccccchhchcchchhhhhhhhhhhhhhhhhhchcccchhhhccchchchcccchccchchhhchhhhhhhhhhcccssssssssssssssssssssss1c11hhhhhchhhcchcchhhhhhhhhhh
chccchhchcccchchhhhhhhhhhhhchhcchchcccchhccccchchchchhchchhhchhhhhhhhhhh1ccccsssssssssssssssssssss1s1111chhhcchcchcccchhchhhchhh
cchcchhcchcccchhhhhhhhhhhhchccccchcccccchcccccccchchcchhhhhhhchchhhhhhhcccccscsssssssssssssssssssss1ss1chhhhchchhhhchccchhhhhhhh
cccccccccchchchhcchchcchhchchhcchhccccchcccccccccchccchchhhhhhchchhhhhchcccscssssss1ssssssssssssssssssscchhccchhhhhhchcccchhhhhh
ccccccccchchcchchccccccchhchhchchchchccccccccccccccccchhhhhhhcchhhhhhhhchchcss1ssshsssssssssssssssssssccccccchhhhhcchcchcccchhcc
cccccccccchccccccccccccccchcchchchcccccccccccchccccccchcchhhhhhhhhhhhhhhchc1s1ssssssssssssssssssssssscsccccccchhccchchhchccccccc
chccccccccccccccccccccccchcccchccccccccccccccchccccccchchhhhhhchhhhhhhhhhc111sssss1ssssssssssssssssssscccccccccccccchcchcccccccc
hchcccccccccccccchcccccchchccccccccccccccccccchhchchchchchhhhhhchhhhhhhhchc111ssssssssssssssssssssssssscccccccccccccccccccccccch
hhccccccccccccccchccccchchchcccccccccccccccccccchchchchcchhhhhhhchhhhhhhhch11ssss1sssssssssssssssssssscccccccccccccccccccccccccc
hhcccccccccccccccccccccchcccccccccccccccccccccchhhchccchhhhhchhhhhhhhhhhhh1c1sssssssssssssss1ssssssssssccccccchccccccccccccccccc
hchccccchhcccccccccccc1hccccccccchcccccchcccccchchhchchhhhhhhhhhhhhhhhhhh1c1sssssssss1ssssshsssssssssscccccccccccccccccccccccccc
chcchchhhhhcccccccccc1cccccccccccchccccccccccccchcchcchhhhhhhhhhhhhhhhhh11cs1s11111s1ssssssssssssssssscccccccccccccccccccccccccc
chchchhhhhhhcchccccccccccccccccchcchcccccccccchchhcchhchhchhhhhhhchhhhh1hchcs111s111s1ssssssssssssssscsccccccccccccccccccccccccc
hchchhhhhhhhhhchccccccccccccccchcchcccccccccchchhhhhhhhchhhchhhhhhhhhhhh1hch111s1s111s11ssssssssssscsscccccccccccccccccccccccccc
hhchhhhhchhhcchcscccccchcccccccchcccccccccccchhchhcchhchhhhhhhhhhhhhhhhhh1h111s1s1s11s111s1ssssssssssscccccccccccccccccccccccccc
hhhhhhhhhhhccccscscscchhhcccccchchcccccccccchhhhhhhhhhhhhhhhhhhhhhhhhhhh1h11111sss11s1s111s1s1sssssssscchcccccccccccccccccchcccc
hhhhhhhhhhhhcccsschhchhhhhcccccchcccccccccccchhhhhhhhhhchhhhhhhhhhhhhhh1h1h1111s1sss1s1s1s1s1sssssssscccchcccccccccccccccccchcch
hhhhhhhhhhhhhhhsshhhhhhhhhhccchccccccchhccchchhhchchhhhhchhhhhhhhhhhhhhh1h111111sssss1s1s1ss11ssssssccccccchccccchccccchcccccccc
hhhhhhhhchhhhhhhsshhchhchhscchhhccchchhhhchchchchcchhhhchhhhhhhhhhhhhh1h1111111111ss11111ss1sssssssscccccchcccchcchcccccccccccch
hh1hhhhhhshhhhhshsscsshshchhchhhcchchhhhhcchchchchhchchhhhhhhhchhhhhh1h11111111111111111111ssssss1scchccchcchchchccccccccchhcccc
hhhhhhhhhhshhhshhhhhhhshhhhhhchcccchchhhchcchchhhchhchchhhhhhchhhhhhhh111111111111111111111111s111h1hcchchhhchhhhhhhccccchhhhhcc
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhcccccchhhhhcchhhhhhhhhhhhchchhchhhhhhhhhh1111111111111111111111111h1hhhhhhhhhhhhhhhhhhhchhhhhhhhhc
hhhhhhhhhhh1h1hsh1hhh1hhhhhhhhchchscchhchhhhhhhhhhhhhhhhhhhhhhhhhhs1hhh11111111111111111111111111hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhchhhhh11h1h1hhhsh1h1hshshhchhhchcchhhhhhhhhhhhhhchhhhhhhhhhhhhhhh1h1111111111111111111111111111h1hhhhhhhhhhhhhhhhhhhhhhhhhhhh
chchhhhhh111h1hhhh1h11sshshhhhhhhhhchchhhhhhhhhhhhchhhhhhhhhhhhhhhs1h1h11s1111111111111111111111111hhhhhhhhhhhhhhhhhhhhhhhhhhhhh
cchhhh1h1hh11hhhhhh1h1shhhhhhchhhhhcchchhhhchhhhcchhchhhhhhhhhhhhhss111111s111111111111111111111111hhhhhhhhhhhhhhhhhhhhhhhhhhhhh
ccc11hc1hh1hh1hhhh1h1s1hhhhhhhhhhhhhcchchhchhhhhhhhchhhhhhhhhhchhhsss111111111111111111111111111111hhhhhhhhhhhhhhhhhhhhhhhhhhhhh
cc1chchch1h11hhhhhh11hh1hhhhhhhhhhhhhchhhhhchhhhhhhhhchhhhchhhchhhss11111s11111111111s111111111111hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
1cc1chch1h1111hhh1h1h1hhshhhhhhhhhhhshchhhhcchcchhhhchhhhcchhhhhhsssh111s11111111111h11ss111111111hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
c1cchccch111111h1h1h1h1hhhhhhhhhhhhhhchcchchcccchhhhhchhhhcchhhhhhshhh11s1111111111111111111111111hhhhhhhhhhhhhhhhhhhhhhhhhhchhh
1cccccccc111111111h1h1hhshhhhhhhhhhhhhchchhcccchchhcchchhhhhcchhhhhhhhhss11s11111s11111111111111111hhhhhhhhchhhhhhhhchhhchhcchhh
ccccc1cc1111111111hh11hhhshhhhhhhhhhhhhchchchccchccccchhhhhchcchhhschhs11s11s111s1s1s111111s111111hhhhhhhhchchhhchhccccchhchchhh
1ccccc1c111h11111h1h1hhhhhhhhhh1hhhhhhchchhhchhcccccccchhhchchcchscscs1s111s1s1s1s1s1s1s11s1sss11scchhchchcchchccccccccccchccchc
ccccccc1cch1h11111h1hhhh11hhhh1hhhhhhhhhhhhhhhchcccchccchhcchchcccccscsssss1sss1s1sss1ssssssssssscsccccchcccccccccccccccccccccch
ccccc11cccch1111h111hhhsh1shh1hhhhhhhhhhhhhhcchcccchchccccccccccccsccssssssssssssssssssssssssssssscccccccccccccccccccccccccccccc
ccccc1s1cc1111hh1h111hsh1hhhhhhhhhhhhhhhhhhhhccccccchccccccccccccsccsssssssssssssssssssssssssssssccccccccccccccccccccccccccccccc
ccccc11sc1c1hh1hh1111hh1hhhhhhhhsshhhhhhhhhhhcccccccccccccccccchcccscssssssssssssssssssssssssssscscccccccccccccccccccccccccccccc
cccccc111c1h1hh111h1hhhh1hhhhhhhhchchchhhhhhccccccccccccccccccccscccssssssssssssssssssssssssssssscsccccccccccccccccccccccccccccc
ccccccc1c1c1hhh1hhhhhhhhhhhhhhhhhhchchchhhccccccccccccchccccccccccsccsssssssssssssssssssssssssssssccccccccccccccccccccccccccsccc
cccccc1chc11hhhh1hhh1hhhhhhhhhhhhhhchchchccchhccccccccccccccccchchcccccsssssssssssssssssssssssssssscccchcccccccccccccccccccccscs
ccccccchchh1hhhhhhhhhhhhhhhhhhhhhhhhhcchhhchchccchcccccccccccccchcscccscsssssssssssss1sssssssssssssccccchccccccccccccccccccchccc
cccccccchcchhhhh1hhh1hhhhh1hhhhhhhhhhhchhhcchcccccccccccccccccccccccsscsssssssssssssssssssssssssssccccccccccccccccccchcccccccccc
cccchcchcchchhh1hhh1hhhhhhhshhhhhhhhhchhhhccccccccccccccccccccccccccccsssssssssssssssssssssssssssssccccccccchcccchcccccccccchcch
ccccccccc1chhh1hhhhhhhh1hhhhhhchhhhhhcchhccccccccccccccccccccccccccccccsssssssssssssssssssssss1ssssscccccchcchhcchhchchchchhcchc
cccccccc1chhh1hhhhhhhh1hhhhhhhhhhhchcchhhccccccccccccccccchchccccccccccsssssssssssss1s111ssssss1sssscccchhhchchchchhchhhchhhhhch
h1ccccchhhhh1h1hhhhhh1hhhhhhhhhhhhhhhchhhccccccccccccccccccccccchccccccccs1ssssssss1s1s11s11s11111s1hchhhhhhchhhchhhhhhhhhhhhhhc
1cccccchhhhhh1h1h1hhhhshhhhhhchhhhhhhhchcccccccccccchcccccccccchchccccccscs1s1ssss1s1s1hs1s11111111h1hhhhhhhhhhhhhhhhhhhhhhhhhhh

