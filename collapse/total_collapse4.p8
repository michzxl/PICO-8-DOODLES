pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

_const_a = 1007/1024
_const_b = 441/1024
_const_c = 5/128

pal(2,1+128,1)

function sqr(a) return a*a end

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

polly = {
	path = function(vecs,cen,col)
		cen = cen or vec()
		local sides = #vecs
		for i=1,sides-1 do
			local p1 = vecs[i] + cen
			local p2 = vecs[i+1] + cen
			line(p1.x,p1.y,p2.x,p2.y,col)
		end
	end,

	draw = function(vecs,cen,col)
		cen = cen or vec()
		local sides = #vecs
		for i=1,sides do
			local p1 = vecs[i] + cen
			local p2 = vecs[i%sides+1] + cen
			line(p1.x,p1.y,p2.x,p2.y,col)
		end
	end,

	fill = function(points,cen,col)
		local xl,xr,ymin,ymax={},{},129,0xffff
		for k,v in ipairs(points) do
			local p1 = v + cen
			local p2=points[k%#points+1] + cen
			local x1,y1,x2,y2,x_array=p1.x,flr(p1.y),p2.x,flr(p2.y),xr
			if y1==y2 then
				xl[y1],xr[y1]=min(xl[y1] or 32767,min(x1,x2)),max(xr[y1] or 0x8001,max(x1,x2))
			else
				if y1>y2 then
					x_array,y1,y2,x1,x2=xl,y2,y1,x2,x1
				end    
				for y=y1,y2 do
					x_array[y]=flr(x1+(x2-x1)*(y-y1)/(y2-y1))
				end
			end
			ymin,ymax=min(y1,ymin),max(y2,ymax)
		end
		for y=ymin,ymax do
			rectfill(xl[y],y,xr[y],y,col)
		end
	end,

	normal = function(poly)
		local v1 = (poly[2] - poly[1]):norm()
		local v2 = (poly[3] - poly[2]):norm()
		return vec.cross(v1,v2)
	end,

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
	cube = function(s)
		local s2 = s/2
		local ps = {
			vec(s2,s2,s2),
			vec(s2,-s2,s2),
			vec(-s2,-s2,s2),
			vec(-s2,s2,s2),
			vec(s2,s2,-s2),
			vec(-s2,s2,-s2),
			vec(-s2,-s2,-s2),
			vec(s2,-s2,-s2),
		}
		local polys = {
			{ ps[1],ps[2],ps[3],ps[4] },
			{ ps[5],ps[6],ps[7],ps[8] },
			{ ps[1],ps[4],ps[6],ps[5] },
			{ ps[1],ps[5],ps[8],ps[2] },
			{ ps[2],ps[8],ps[7],ps[3] },
			{ ps[3],ps[7],ps[6],ps[4] },
		}
		for poly in all(polys) do
			poly.cen = polly.center(poly)
		end
		return polys, ps	
	end,

	center = function(poly)
		local v = vec()
		for point in all(poly) do
			v = v + point
		end
		return v / #poly
	end,
}

polyp = polly.path
polyv = polly.draw
polyf = polly.fill


function ff(x)
    x = x%6
    if 0<=x and x<2 then
        return -abs(x-1)+1
    elseif 2<=x and x<5 then
        return -abs(x-3.5)+1.5
    elseif 5<=x and x<6 then
        return -2*abs(x-5.5)+1
    end
end

-->8
dt=1/30
t=0
tf=0

cls()
::♥::
t+=dt tf+=1

local st4 = sin(t/4)

for i=1,1000 do
    x,y=rnd(128),rnd(128)
    local ox = abs((x+abs(y-64))-64)+8*sin(t/8)+64+t
    local oy = ff(x/(4+0.5*sin(t/6)) + y/8+t*4)*64-t
    local c = ox/(3+2*sin(t/8))<oy and 1 or 0
    local diff = c-flr(c)
    circ(x,y,1,c)
end

do 
    local polys,points = polly.cube(32)
    local angs = vec(t/16, t/9, t/8)

    local ux,uy,uz = angs:u_rot_yxz()
    foreach(points, function(p) 
        p:set( ux*p.x + uy*p.y + uz*p.z )
    end)

    for key,pol in ipairs(polys) do
        local normal = polly.normal(pol)
        if normal.z<1 then
            local light = -normal.y

            -- polyf(pol, vec(64,64), 0)
            polyv(pol, vec(64,64), 13)
        end
    end
end

local points = {}
local num = 5+2*sin(t/12)
for i=1,5 do
    local ic = i - num/2 - 1
    local x = ic*16 + 64
    local y = (t*16 + (16+32*cos(t/9))*sin(x/128+t))%128

    if rnd(1)<0.01 + abs(0.05*sin(t/24)) then
        x,y=rnd(128),rnd(128)
    end
    add(points, vec(x,y))
end

local circle = {}
local sides = 5 + mid(-1,1,1.3*sin(t/10))
local r = 24
for i=0,1,1/sides do
    local ang = i + t/8
    local r = r
        + i*sides%2*((st4*2+2)%4)
    if rnd(1)<0.01 then r = r+32 end
    if rnd(1)<0.01 then ang = ang + 0.25 end

    add(circle, vec.frompolar(ang,r))
end

local chn = rnd(1)
if chn<0.1 then
    for point in all(points) do
        circ(point.x,point.y,3,7)
    end
elseif chn<0.2 then
    for point in all(points) do
        local x,y = point:xy()
        local p = 7
        line(x-4,y-4,x+4,y+4,p)
        line(x-4,y-3,x+3,y+4,p)
        line(x-3,y-4,x+4,y+3,p)
        line(x-4,y+4,x+4,y-4,p)
        line(x-4,y+3,x+3,y-4,p)
        line(x-3,y+4,x+4,y-3,p)
    end
else
    polyp(points, vec(0,0), 7)
end

polyv(circle,vec(64,64),12)

flip() goto ♥
