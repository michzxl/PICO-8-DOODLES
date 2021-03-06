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

function sqr(a) return a*a end