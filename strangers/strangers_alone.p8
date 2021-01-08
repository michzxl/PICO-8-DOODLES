pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init()
	t = 0

	pal({
		2+128,
		2,
		8+128,
		8,
		15+128,
		14+128,
		15,
		7,
	},1)

	_square_points = {
		vec(1,-1),
		vec(0,-1),
		vec(-1,-1),
		vec(-1,0),
		vec(-1,1),
		vec(0,1),
		vec(1,1),
		vec(1,0),
	}

	cls()
end

function _update()
	t += 1/30
	printh("---")
	
	local x,y = 64,64
	local r = 32
	local n = 8

	for i=1,800 do
		local x,y = rnd(128),rnd(128)
		local p = (boxblur(x,y,1))
		circ(x,y,1,p)
	end

	local k = rnd(0.005)
	vs = {}
	for i=1,n do
		local ang = i/n
		local ang_ofs = t/8
		local ofs_s = -t/8 + 0.1*sin(t/16)
		local ofs_c = sin(t/8 + ang/16 + i%2/8 + k) - k - t/8 + 1*cos(i%2/8)

		local sv = square(i,ang_ofs + ofs_s)
		local cv = circle(i,ang + ang_ofs + ofs_c)

		local fv = lerp(sv, cv, sin(t/8)/2+0.5)

		add(vs, fv * r)
	end

	polyv(vs, vec(x+cos(t*0.8),y+sin(t*0.8)), 8)
	polyf(vs, vec(x,y), 0)
	
end

function square(i, ang)
	local s = _square_points[i]
	local a,r = s:polar()
	printh(a.." "..r)
	printh(s)
	printh(vec.frompolar(a + ang,r))
	printh("")
	return vec.frompolar(a + ang,r)
end

function circle(i, ang)
	return vec.frompolar(ang,1)
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

function nsin(a)
	return (sin(a)+1)/2
end

function lerp(a,b,t)
	if t==1 then return b end
	return a + (b - a)*t
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

function sqr(a) return a*a end

_const_a = 1007/1024
_const_b = 441/1024
_const_c = 5/128

vec = {
	new = function(x,y,z)
		return setmetatable({
			x=x,
			y=y,
			z=z
		},_vec)
	end,

	frompolar = function(ang,r)
		return vec(r*cos(ang), r*sin(ang))
	end,
	unit=function(rot)
		return 
			vec(1,0,0),
			vec(0,1,0),
			vec(0,0,1)
	end,
	ones=function()
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
__label__
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuuu7777uuuuu7uuuu7uuuuuu7uuuuuuuuuuuuuuuuuuuuuuu777uuuuuuuuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuu7u777uuuuuu7uuuuuuuuu777uuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7u7uuuuuuu777u7uuuuuu7uuuuuuuu777uuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuuuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7u7uuuuuu7777uuuuuu7uuuuuuuu7u7u7uuuuuuuuuuuuuuuuuuuuu7uuuuuuuuuuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuu77uuuuu7u7u7uuuuu7uu7uuuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuuuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuuuuuuuu7uuu7u7uuuuuuuuuuuuuuuuuuu8uuuu7uuuuuuu888888888uuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7u7uuuuuuuuuuuuuuuuuuuuuuuuu8u8uuuuu7777ddddddeeeeeuuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu999999999a77ddddddeeeeeeuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuuuuuuuuuuuuuuuuuu77uuauuub777deee8888999a77ddddddeeeeeeuuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7uuuuuuu7uuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7uu7aaaaabbb7777teee8888999a77ddddddeeeeeeeuuuuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu7uuu777d8aaaaabbb77777eee8888999a77ddddddeeeeeeeeduuuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuutabu7777777777doaaaaabbb77777uuu8888999a77tttttteeeeeeeedduuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuduuu7uuuuu77e9r77777777777t7aaaaabbb777778888888999a777eeeeeeeeeeeeedduuuuuuu
uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuduuuubudd77777777dup77777777777777aaaaabbb777778888888999a777eeeeeeeeeeeeeddduu7777
uuuuuuuuuuuuuuuuuuuuuuu77777777777777e7777d7eu7778877777777777t7777777777777777qqqqqbbb777778888888999a777uuuuuuuueeeeedddd77777
uuuuuuuuuuuuuuuu77777777777777777777b7e777777777ddddddddd7777777777777777777777bbbbbbbb77777ooooooo999a777eeeeeeeeeeeeudddduu777
uuuuuuuuu7uuu77777777777777777777788888888887777ddddddddd7777777777777777777777bbbbbbbb777777999999999a777uuuuuuuuuueueudduuuu7u
uuuuuuuuuu7u777777777777777777777ddddddddee87777ddddddddd7777777777777777777777rrrrrrrr777777pppppppppq7777777uuuuuuuuuddduuuuu7
uuuuuuuuu777777777777777777777777ddddddddee87777ddddddddd77777777777777777777777777777777777777777777777777777uooooooeuddd77uduu
uuuuuuuuu777777777777777777777777ddddddddee87777ddddddddd7777777777777777777777777777777777777777777777777777aa7uuuuuueddduuddd7
uuuuuuu7u777777777777777777777777ddddddddee87777ddddddddd777777777777777777777777777777777777777777777777777eeeeeeuuuuutdttddddu
uuuu7u77u777777777777777777777777ddddddddee87777ddddddddd77777777777777777777777777777777777777bb77777777777ddddddddttttttdddduu
uuuu7u77u777777777777777777777777ddddddddee87777ddddddddd7777777777777777777777777777777777777eeeeeeeee77777ddddddddttttttdduuuu
uuuuuu77u777777777777777777777777ddddddddee87777ddddddddd777777777777777777777777bbbbbb777777ddddddddee77777ddddddddutut7tuuuuuu
uuuuuu77u777777777777777777777777ddddddddee87777ttttttttt77777777777777777777777eeeeee8889777ddddddddee77777ddddddddduu7u7uuuuuu
uuuuuu77u777777777777777777777777ttttttttee877777777777777777777777777777777777deeeeee8889777ddddddddee77777ddddddddu7777uuuuuuu
uuuuu7u7u7777777777777777777777777uuuuuuuuuo777777777777777777777789999aaabbb77teeeeee8889777ddddddddee77777ddddddddu77uuuuu7u7u
uuuu77u77u777777777777777777777777777777777777777777777777777777deo9999aaabbb77eeeeeee8889777ddddddddee77777ddddddddutuuuuu7u7u7
u777u7u77u7777777777777777777777777777777777777777789bb777777777tu99999aaabbb77uuueeee8889777ddddddddee77777ddddddddtutu7777777u
777777u77u7777777777777777777777777777777777777777d8pbb7777777777799999aaabbb777eeeeee8889777ddddddddee77777ttttttttutu7u777777u
u7777uu77u7777777777777777777777777779a77777777777tobbb7777777777799999aaabbb777eeeeee8889777ddddddddee777777777uuuuuuu777777777
uu7777u77u77777777777777777777777777dddddd7777777777rrr77777777777pppppaaabbb777uuuuuu8889777ttttttttee777777777uuuuuu7777777777
u7u777u77u77777777777777777777777777dddddd777777777777777777777777aaaaaaaabbb77788888888897777uuuuuuuuu777777777uuuu777777777777
uuuu7u7u7u77777777777777777777777777dddddd777777777777777777777777aaaaaaaabbb777ooooooooo97777777777777777777777uuu7u77777777777
uuuuu77u77u7777777777777777777777777dddddd777777777777777777777777qqqqqqqqbbb777pppppppppp7777777777777777777778abbb777777777u77
uuuuuu7u77u7777777777777777777777777dddddd7777777777777777777777777rrrrrrrrrr777777777777777777777777777777777deqbbb77777u77u7u7
uuuuuu7u77u7777777777777777777777777dddddd77777777777777777777777777777777777777777777777777777788b77777777777tubbbbu77777u77u77
uuuu7uuu77u7777777777777777777777777dddddd77777777777777777777777777777777777777777777777777777dddddd77777777777rrrruu777uuu7777
uuu7777u77u7777777777777777777777777tttttt77777777777777777777777777777777777777779977777777777dddddd777777777777ubbu7u77uu7u777
uu777777u7u7777777777777777777777777777777777777777777777777777777777777777777777dddddddddd7777dddddd777777777777urrbu7u777u7777
uuu7u7u7u77u777777777777777777777777777777777777777777777777777777779999999997777dddddddddd7777dddddd7777777777777ubbuu777777777
uuuuuuu7u77u7777777777777777777777777777777777777777777777777777777ddeeee88888777dddddddddd7777dddddd7777777777777urbbu777777777
uuuuu7u7u77u777777777777777777777777777777777777777777aaaaaaaaaa777ddeeee88888777dddddddddd7777dddddd7777777777777urbub777777777
uuuuuuu7u77u7777777777777777777777777777777777777777ee88889999aa777ddeeee88888777dddddddddd7777tttttt7777777777777ubbb7bu7777777
uuuuuuuuu77u7777777777777777777777777777bbbbbb777777du88889999aa777tteeee88888777dddddddddd77777777777777777777777urbbb777777777
uuuuuuuuu77u77777777777777777777777777e8aabbbb777777t888889999aa777eeeeee88888777dddddddddd77777777777777777777777ubbb7777777777
uuuuuuuu7u7u77777777777777777777777777doaabbbb7777777888889999aa777eeeeee88888777dddddddddd77777777777777777777777urr77777777777
uuuu7uuu7u77u7777777777777777777777777t7qqbbbb7777777ooooo9999aa777eeeeee88888777dddddddddd777777777777777777777777ubb77777u7777
7u77u7uu7u77u777777777777777777777777777bbbbbb7777777799999999aa777uuuuuu88888777dddddddddd7777777777777777777777999999999aa7777
77uu7u7u7u77u777777777777777777777777777bbbbbb7777777799999999aa77788888888888777tttttttttt777777777777777777777de88889999aa7777
7777uuuuuu77u777777777777777777777777777bbbbbb7777777799999999aa777ooooooooo88777777777777777777777aaaabbbb77777tu88889999aa7777
77777uuuuu77u777777777777777777777777777rrrrrr77777777ppppppppaa7777oooooooooo77777777777777777777e8aaabbbb777777888889999aa7777
777uuu7uuu77u77777777777777777777777777777777777777777qqqqqqqqqq777777777777777777777a77777777777ddoaaabbbb777777888889999aa7777
77uuu7u7u7u7u7777777777777777777777777777777777777777777777777777777777777777777777ee977777777777ttaaaabbbb777777888889999aa7777
77uuuu7777u77u777777777777777777777777777777777777777777777777777777777b77777777777ddp7777777777777qqqqbbbb777777ooooo9999aa7777
uuuuuuuu77u77u777777777777777777777777777777777777777777777777777777788888777777777dd777777777777777bbbbbbb777777999999999aa7u77
uuuuuuuuu7u77u7777777777777777777777777777777777777777777777777777777ddddddddd77777tt777777777777777bbbbbbb777777999999999aau7u7
uuuuuuuuu7u77u7777777777777777777777777777777777777777788888888887777ddddddddd7777777777777777777777rrrrrrr777777pppppppppaa7u77
uuuuuuuu7uu77u7777777777777777777777777777777777777777dddddddeee87777ddddddddd777777777777777777777777777777777777qqqqqqqqqqp778
uuuuuuuuu77u7u7777777777777777777777777778888888899a77dddddddeee87777ddddddddd77777777777777777777777777777777777777uqqqqqqp7787
uuuuuuuuu77u7u77777777777777777777777777d8888888899a77dddddddeee87777ddddddddd77777777777777777777777777777777777777uqqqqqp77878
uuuuuuuu7u7u77u7777777777777777777777777t8888888899a77dddddddeee87777ddddddddd777777777777777777777777777777777777777upppp777888
uuuuuuuu7u7u77u777777777777777777777777778888888899a77dddddddeee87777ddddddddd77777777777777777777777777777777777777bupppp888888
uuuuuuu7u7uu77u777777777777777777777777778888888899a77dddddddeee87777ddddddddd7777777777777777777777777777777777777eeeeeeeeee888
uuuuuuuu7u7u77u77777777777777777777777777oooo888899a77ttttttteee87777ddddddddd777777777777777777777777777777777777dddddddeeeee88
uuuuuuuuu7uu77u777777777777777777777777778888888899a777eeeeeeeee87777ddddddddd7777777777777777777777eeeeee88899777dddddddeeeee88
uuuuuuuuuuu7u7u777777777777777777777777778888888899a777eeeeeeeee87777ttttttttt7777777777777777777777deeeee88899777dddddddeeeeo88
uuuuuuuu7uu7u77u7777777777777777777777777oooooooo99a777uuuuuuuuuo7777777777777777777778999aaaabbb777teeeee88899777dddddddeeeeoo8
uuuuuuu77777u77u77777777777777777777777779999999999a777777777777777777777777777777777de999aaaabbb777eeeeee88899777dddddddeeeeouo
uuuuuuuu77u7u77u7777777777777777777777777ppppppppppq777777777777777777779a77777777777tu999aaaabbb777eeeeee88899777dddddddeeeeuuu
uuuuuuuu7u77u77u7777777777777777777777777777777777777777777777777777777d8q7777777777777pppaaaabbb777eeeeee88899777dddddddeeeeuue
uuuuuuuuuuuuu77u7777777777777777777777777777777777777777779b77777777777to77777777777777aaaaaaabbb777uuuuuu88899777ttttttteeeeeoo
uuuuuuuuuuuuu77u7777777777777777777777777777777777777777dddddddd77777777777777777777777aaaaaaabbb77778888888899777eeeeeeeeeeeooo
u7uuuuuuuuuu7u7u7777777777777777777777777777a77777777777dddddddd77777777777777777777777aaaaaaabbb77778888888899777uuuuuuuuuuu8oo
7u77uuuuuuu77u77u7777777777777777777777777eeeeeeeeee7777dddddddd77777777777777777777777qqqqqqqbbb7777oooooooo9977777777uuuuuee8o
u7uuuuuuu7uu7u77u7777777777777777777777777ddddddddde7777dddddddd777777777777777777777777bbbbbbbbb7777pppppppppp77777777uuuuue8oo
uuuuu77u7uuu7u77u7777777777777777777777777ddddddddde7777dddddddd777777777777777777777777rrrrrrrrr7777777777777777777777uuuuuoooo
uuuuuu77uuuuuu77u7777777777777777777777777ddddddddde7777dddddddd7777777777777777777777777777777777777777777777777777789buuudooo7
uuuuuuuuuuuuuu77u7777777777777777777777777ddddddddde7777dddddddd7777777777777777777777777777777777777777777777777777dddddddodo7o
uuuuuuuuuuuuuu77u7777777777777777777777777ddddddddde7777dddddddd7777777777777777777777777777777777777779977777777777ddddddddooo7
uuuuuuuuuuuuu7u7u7777777777777777777777777ddddddddde7777tttttttt77777777777777777777777777777777777777ddddddddde7777ddddddddoooo
uuuuuuuuuuuuu7u77u777777777777777777777777ddddddddde7777777777777777777777777777777777777aaaaaaaa77777ddddddddde7777dddddddoddo7
uuuuuuuuuuuu77u77u777777777777777777777777ddddddddde77777777777777777777777777777777777deeeee888887777ddddddddde7777dddddddddodo
uu7uuuuuuuuuu7u77u777777777777777777777777ttttttttte77777777777777777777777aaaaaaaaab77deeeee888887777ddddddddde7777ddddddduddod
u7uu7uuuuuuuuuu77u777777777777777777777777uuuuuuuuuu777777777777777777777e8889999aaab77teeeee888887777ddddddddde7777ddddddddu7d7
7u777uuuuuuuuuu77u7777777777777777777777777777777777777777777bbbbb7777777do889999aaab777eeeee888887777ddddddddde7777tttttttu777d
777uu7uuuuuuuu7u7u7777777777777777777777777777777777777777788abbbb7777777t8889999aaab777eeeee888887777ddddddddde77777777utt7u7o7
u7uuuuuuuuuuu77u77u777777777777777777777777777bb77777777777doqbbbb77777777ooo9999aaab777uuuuu888887777ddddddddde777777777u7u777o
uuuuuuuuuuuu777u77u7777777777777777777777777789b77777777777t7bbbbb777777777999999aaab77788888888887777ddddddddde777777777u777777
uuuuuuuuuuuuu77u77u7777777777777777777777777ddddd777777777777bbbbb777777777999999aaab77788888888887777ddddddddde777777777u77777o
uuuuuuuuuuuuu77u77u7777777777777777777777777ddddd777777777777rrrrr777777777ppppppaaab777oooooooo887777tttttttttu777777777u777777
uuuuuuuuuuuuuuuu77u7777777777777777777777777ddddd77777777777777777777777777aaaaaaaaab77778888888887777777777777777777777aabbbb77
u7uuuuuuuuuuuuuu77u7777777777777777777777777ddddd77777777777777777777777777aaaaaaaaab7777ooooooooo777777777777777777777e8abbbb77
7uuuuuuuuu7uuuu7u7u7777777777777777777777777ddddd77777777777777777777777777qqqqqqqqqr777777777777777777777b77777777777duoqbbbb77
777uuuuuuuuuuuu7u77u777777777777777777777777ttttt7777777777777777777777777777777777777777777777777777777e8977777777777t77bbbbb77
7777uuuuuuuuuuu7u77u777777777777777777777777777777777777777777777777777777777777777777777777b77777777777dddd7777777777777bbbbb77
7o777uuuuuuuuuu7u77u777777777777777777777777777777777777777777777777777777777777777777777788888877777777dddd7777777777777bbbbb77
ee7uuuuuuuuuuuu7u77u7777777777777777777777777777777777777777777777777777777777777777777777ddddddddd77777dddd7777777777777rrrrr77
eeuuuu7uuuuuuuuuu77u7777777777777777777777777777777777777777777777777777777788888888887777ddddddddd77777dddd77777777777777u77777
eeeuu77uuuuuuuuuu77u7777777777777777777777777777777777777777777777777777777dddddeeee887777ddddddddd77777tttt77777777777777u77777
eeee77uuuuuuu77u7u7u777777777777777777777777777777777777777777999999999aa77dddddeeee887777ddddddddd77777777777777777777777u77777
eee77uuuuuuu7u7u7u77u7777777777777777777777777777777777777777d889999999aa77dddddeeee887777ddddddddd777777777777777777777777u7777
ee7777uuuuuuu77u7u77u7777777777777777777777777779aaaabbbb7777t889999999aa77dddddeeee887777ddddddddd777777777777777777uuuuuuu7777
7e77777u7uuuuu7u7u77u7777777777777777777777777de9aaaabbbb7777ooo9999999aa77dddddeeee887777ddddddddd77777777777uuuuuuu77777777777
e7e77777uuuuuuu7uu77u7777777777777777777777777tupaaaabbbb77777999999999aa77ttttteeee887777ddddddddd77777uuuuuu777777777777777777
7777u777uuuuuu7uuu77u777777777777777777777777777aaaaabbbb77777999999999aa77eeeeeeeee887777ddddddddduuuuu777777777777777777777777
uu7uuuuuuuuu77u7u7u7u777777777777777777777777777aaaaabbbb77777999999999aa77eeeeeeeee887777ddddddddd77777777777777777777777777777
u7uuuu7uuuu7u777u7u77u77777777777777777777777777qqqqqbbbb77777pppppp999aa77uuuuuuuuu88uuuuttttttttt77777777777777777777777777777
u77uuuu77u7777u7u7u77u777777777777777777777777777bbbbbbbb77777999999999aa777oooooooooo777777777777777777777777777777777777777777
7u77u7u777777u7777u77u777777777777777777777777777bbbbbbbb77777pppppppppaauuuu777777777777777777777777777777777777777777777777777
u7u77u77777777u77uu77u777777777777777777777777777rrrrrrrr777777qqqqqqqqqq7777777777777777777777777777777777777777777777777777777
uu7uu7777777777777u77u77777777777777777777777777777777777uuuuuu77777777777777777777777777777777777777777777777777777777777777777
uuuuu7777777777777u77u7777777777777777777777777777uuuuuuu77777777777777777777777777777777777777777777777777777777777777777777777
u7uu777777777777777u7u777777777777777777777uuuuuuu777777777777777777777777777777777777777777777777777777777777777777777777777777
7u777777777u7777777u77u7777777777777uuuuuuu7777777777777777777777777777777777777777777777777777777777777777777777777777777777777
u777777777777777777u77u7777777uuuuuu77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777777777777777777u77uuuuuuuu77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777u7u7777777777u77u777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
777u7uuu7u777777777uuu777777777777777777777777777777777o777777777777777777777777777777777777777777777777777777777777777777777777
77duuuuuuut7777777777777777777777777777789997777777o7777o77777777777777777777777777777777o7777777777u777777777777777777777777777
7uuu7uu7u7tt7777777777777777777777pp8889989777777777o7o77777777777a777rr7777777777777777o77o77777e7u7u77777777777777777777777777
uuu7u7777t7777777777777777777788ppp888989999779977777o7777777777777p7r7r777777777777777777o7777777u7u777777722277777777777777777
uuuu7777t777777777777777777778888p888889989777o9o77oo77777777o77777pp7rr7777777777777777777o7777777u7777777222227777777777777777
u2ttt7tt7t77777777777777778778888888888o8o97779oooooo777777777o777ppppr777777777qo777777777777777777u777777772277777777777777777
222ttt7tt7777777777777777778888787878888ooo97979oooooo7777o7o7oo7a7ppr777777777q7qo7777777777777777u7u77777777727777777777777777
2277t7t7t777777777777777788888877877288o7ooo979oooooo7o7777o7o7pa7app77777777777q7777777777777777777u777777772272777777777777777
27777t7t7t777777777777788888887777872222o7ooooooooo77o777777o72opapa777777777777777777777777777777777777777727722277777777777777
7772ttttt77777777777778888888787787822222o8o8o8oooo7o7o777o77oopopapp77777777777777777777777777777777777777777272227777777777777

