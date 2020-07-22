vec = {
	frompolar = function(ang,r)
		return vec(r*cos(ang), r*sin(ang))
	end,


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
	norm=function(self, len)
		if len==nil then len=1 end
		if self:nonzero() then
			return self/#self * len
		else
			return vec()
		end
	end,
	perp = function(self)
		return vec(-self.y, self.x)
	end,
	-- cross = function(A, B)
	-- 	return vec(
	-- 		A.y*B.z - A.z*B.y,
	-- 		A.z*B.x - A.x*B.z,
	-- 		A.x*B.y - A.y*B.x
	-- 	)
	-- end,
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
	yz = function(self)
		return self.y,self.z
	end,
	xz = function(self)
		return self.x,self.z
	end,
	xyz=function(self)
		return self.x,self.y,self.z
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
			fflr(a, unit)
		end)
	end,
	fflrz = function(self, unit)
		local signs = self:distr(sgn)
		local fv = self:distr(abs):fflr(unit)
		return fv:cmult(signs)
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
		return "<"..flr(self.x)..","..flr(self.y)..","..flr(self.z)..">"
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

function fflr(a, unit)
	return flr(a/unit)*unit
end

function sqr(a)
	return a
end