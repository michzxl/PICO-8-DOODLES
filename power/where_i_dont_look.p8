pico-8 cartridge // http://www.pico-8.com
version 30
__lua__

#include cube.lua
--#include tack.lua
--#include fills.lua
#include vec.lua
#include subpixel.lua
#include util_power.lua

water = 0
sqrt2 = sqrt(2)

function _init()
	t = -1
	POLY.tonum(cube)

	pal({
		1+128,
		1,
		12+128,
		13,
		13,
		13+128,
		2,
		2+128,
		1+128,
		1,
		12+128,
		13,
		13,
		13+128,
		2,
		2+128,
	}, 1)

	strs = {
		"where i dont look,",
		"i never left.",
		"a wall,    ",
		"its edges grind",
		"by concrete",
		"forward moving.",
		"a face consumed",
		"by solid mass.",
		"the view ",
		"from below ",
		"keeps me safe.",
		"what do you",
		"call it? ",
		"maybe...", 
		"there is",
		"something here",
		"worth loving.",
	}
	istr = 1
	cstr = strs[istr]
	strtimer = 0
	for i=1,#cstr do
			local char = sub(cstr,i,i)
			if char~=" " then
				local sid = ords(char) + (p_font_index or 0)
				if char=="a" then
					sid = 58
				end
				
				mset(i-1,0,sid)
			else
				mset(i-1,0,0)
			end
		end
	
	ofs1,ofs2 = rnd(1)<0.5 and 1 or -1, rnd(1)<0.5 and 1 or -1

	cls(0)

	ya1,yb1=rnd(128),rnd(128)
	ya2,yb2=ya1+16,yb1+16
end

function _update()
	t = t + 1/30
	if (t>8) strtimer += 1/30

	water = 8 + 8*sin(t/12)

	if strtimer>3 then
		strtimer -= 3
		istr += 1
		cstr = strs[istr]
		ofs1,ofs2 = rnd(1)<0.5 and 8 or 0, rnd(1)<0.5 and 8 or 0

		if cstr~=nil then
			for i=1,#cstr do
				local char = sub(cstr,i,i)
				if char~=" " then
					local sid = ords(char) + (p_font_index or 0)
					if char=="a" then
						sid = 58
					end
					
					mset(i-1,0,sid)
				else
					mset(i-1,0,0)
				end
			end
		end
	end

	

	ya1,yb1,ya2,yb2=ya1+rnd(1),yb1-rnd(1),ya2+rnd(2),yb2+rnd(2)
	ya1,yb1,ya2,yb2=ya1%128,yb1%128,ya2%128,yb2%128
end

function _draw()
	for i=1,250 do
		local a1,r1 = sqrt(rnd(128*128)),rnd(128*sqrt2)
		local x1,y1 = 64+r1*cos(a1),64+r1*sin(a1)

		local a2,r2 = a1,r1+1.5
		local x2,y2 = 64+r2*cos(a2),64+r2*sin(a2)

		circ(x2,y2,1,pget(x1,y1))
	end

	for i=1,200 do
		local x,y = rnd(128),rnd(128)
		circ(x,y,1,0.5+(boxblur(x,y,2)))
	end

	for i=1,800 do
		local x,y = rnd(128),rnd(128)\2*2
		pset(x,y,mid(0,15,pget(x,y)+1))
	end

	-- for _=1,100 do
	-- 	local n = 0
	-- 	local x,y = rnd(128),rnd(128)
	-- 	for i=0,120 do
	-- 		n += pget(x+(i%11)-5,y+(i\11)-5)
	-- 	end
	-- 	pset(x,y,pget(x,y)-sgn(n-7*24))
	-- end
	

	POLY.objdraw(cube,
		vec(64,64), 
		vec(t/7.3,t/16 + rnd(0.01) * ((1*sin(t/8))+1),0 - fflr(0.25*sin(t/32),1/16)),
		vec(16,8,32),
	true,7)

	local d = 12
	line(0,ya1,d,ya1,0)
	line(127-d,yb1,127,yb1,0)

	-- local s = sub(cstr,1,flr(t*4%#cstr+1))
	-- rprint(s,0,0,0,1,{
	-- 	col=function() return 7 end,
	-- 	trans=0,
	-- })

	if cstr~=nil and t>8 then
		rectfill(0,0,8,16-4,1)
		tquad(
			0,0-4,
			8*16-4,0-4,

			8*16+8-4-3*sin(t/8),24-4+ofs1,
			0+3*sin(t/8),24-4+ofs2,

			0,0,
			#cstr,min(1,(strtimer+2)/3)
		)
	end
end

function fflr(a,u)
	return a\u*u
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

POLY = {}

function POLY.triv(a,b,c,col)
	line2(a.x,a.y,b.x,b.y,col)
	line2(b.x,b.y,c.x,c.y,col)
	line2(c.x,c.y,a.x,a.y,col)
end

function POLY.quadv(a,b,c,d,col)
	line2(a.x,a.y,b.x,b.y,col)
	line2(b.x,b.y,c.x,c.y,col)
	line2(c.x,c.y,d.x,d.y,col)
	line2(d.x,d.y,a.x,a.y,col)
end

function drown_line(a,b)
	local water = water
	if a.z<water and b.z<water then
		return false,false
	elseif not (a.z<water) and not (b.z<water) then
		return a,b
	elseif a.z<water then
		local len = (b.z-water) / (abs(a.z-b.z)) * (a-b):magn()
		return b+(a-b):norm(len), b
	else
		local len = (a.z-water) / (abs(b.z-a.z)) * (b-a):magn()
		return a, a+(b-a):norm(len)
	end
end

function drown_tri(tri)
	local a,b,c = tri[1],tri[2],tri[3]

	if a.z<water and b.z<water and c.z<water then
		return false
	elseif a.z>=water and b.z>=water and c.z>=water then
		return tri
	end

	local a1,a2,b1,b2

	local below,above = {},{}
	for i,v in ipairs(tri) do
		if v.z<water then
			add(below, {v, i})
		else
			add(above, {v, i})
		end
	end

	if #below==1 then
		if above[1][2] > above[2][2] then
			return drown_tri_1_below(above[2][1],above[1][1],below[1][1])
		else
			return drown_tri_1_below(above[1][1],above[2][1],below[1][1])
		end
	else
		if below[1][2] > below[2][2] then
			return drown_tri_2_below(above[1][1],below[2][1],below[1][1])
		else
			return drown_tri_2_below(above[1][1],below[1][1],below[2][1])
		end
	end
end

function drown_tri_1_below(a1,a2,b)
	local _,d1 = drown_line(a1,b)
	local _,d2 = drown_line(a2,b)
	return {a1,a2,d2,d1}
end

function drown_tri_2_below(a,b1,b2)
	local _,d1 = drown_line(a,b1)
	local _,d2 = drown_line(a,b2)
	return {a,d2,d1}
end

function POLY.polyv(vecs,cen,col)
	local len = #vecs
	local cen = cen or vec()
	for i=1,len-1 do
		local p1,p2 = vecs[i] + cen, vecs[i+1] + cen
		line2(p1.x,p1.y,p2.x,p2.y,col)
	end
	local p1,p2 = vecs[1]+cen,vecs[len]+cen
	line2(p1.x,p1.y,p2.x,p2.y,col)
end

function POLY.path(vecs,cen,col)
	cen = cen or vec()
	for i=1,#vecs-1 do
		local p1 = vecs[i] + cen
		local p2 = vecs[i+1] + cen
		line2(p1.x,p1.y,p2.x,p2.y,col)
	end
end

function POLY.polyfill(points,cen,col)
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

function POLY.trifill(a,b,c,col)
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

function POLY.cen(poly)
	local v = vec()
	for point in all(poly) do
		v = v + point
	end
	return v / #poly
end

function POLY.normal(poly)
	local v1 = (poly[2] - poly[1]):norm()
	local v2 = (poly[3] - poly[2]):norm()
	return vec.cross(v1,v2)
end

function POLY.tquad(xa, ya, xb, yb, xc, yc, xd, yd, mx, my, w, h)
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

			tline2(xx2, yy, xx3, yy, sxx2, syy2, (sxx3-sxx2)/d, (syy3-syy2)/d)
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

		tline2(xx4, yy, xx5, yy, sxx4, syy4, (sxx5-sxx4)/d, (syy5-syy4)/d)
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

		tline2(xx4, yy, xx5, yy, sxx4, syy4, (sxx5-sxx4)/d, (syy5-syy4)/d)
	end
end

function POLY.ttri(xa, ya, xb, yb, xc, yc, sxa, sya, sxb, syb, sxc, syc)
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

			tline2(x0, y, x1, y, sx0, sy0, (sx1-sx0)/d, (sy1-sy0)/d)
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

			tline2(x0, y, x1, y, sx0, sy0, (sx1-sx0)/d, (sy1-sy0)/d)
		end
	end
end

function POLY.tonum(obj)
	for k,e in pairs(obj) do
		if type(e)=="table" then
			POLY.tonum(e)
		elseif type(e)=="string" then
			obj[k] = tonum(e)
		end
	end
	return obj
end

function POLY.objdraw(obj, trans, rot, scale, wire, col)
	local fs, buf = obj.f, obj.buf

	local us = rot:u_rot_yxz()

	local nfs = {}
	for f in all(fs) do
		local n = us:dot(vec.newp(unpack(buf[f[1]+1][2])))
		if n.z>=0 then
			local vs = {}
			for vi in all(f) do
				local vb = buf[vi+1][1]
				local v = us:dot(vec.newp(
					vb[1]*scale.x,
					vb[2]*scale.y,
					vb[3]*scale.z
				)) + trans
				v.y = v.y + 0.5*sin(v.x/16 + t/8)
				v.z = v.z + 2*sin(t/16 + v.z/32)
				add(vs, v)
			end
			if #vs==3 then
				vs = drown_tri(vs)
				if vs~=false then
					add(nfs, {vs=vs,n=n})
				end
			else
				local vs1,vs2 = drown_tri({vs[1],vs[2],vs[3]}),drown_tri({vs[1],vs[3],vs[2]})
				if (vs1~=false) add(nfs, {vs=vs1, n=n})
				if (vs2~=false) add(nfs, {vs=vs2, n=n})
			end
		end
	end

	qsort(nfs, function(a,b)
		local ac,bc = POLY.cen(a.vs), POLY.cen(b.vs)
		return ac.z < bc.z
	end)

	for f in all(nfs) do
		local vs,n = f.vs,f.n 
		local fcol = 7
		
		if #vs==3 then
			POLY.trifill(vs[1], vs[2], vs[3], 0)
		else
			POLY.trifill(vs[1], vs[2], vs[3], 0)
			POLY.trifill(vs[1], vs[3], vs[4], 0)
		end
	end
	for f in all(nfs) do
		local vs,n = f.vs,f.n 
		local fcol = 7

		
		
		if #vs==3 then
			POLY.triv(vs[1], vs[2], vs[3], fcol)
		else
			POLY.quadv(vs[1], vs[2], vs[3], vs[4], fcol)
		end
	end
end

function qsort(a,c,l,r)
	c,l,r=c or function(a,b) return a<b end,l or 1,r or #a
	if l<r then
		if c(a[r],a[l]) then
			a[l],a[r]=a[r],a[l]
		end
		local lp,k,rp,p,q=l+1,l+1,r-1,a[l],a[r]
		while k<=rp do
			local swaplp=c(a[k],p)
			-- "if a or b then else"
			-- saves a token versus
			-- "if not (a or b) then"
			if swaplp or c(a[k],q) then
			else
				while c(q,a[rp]) and k<rp do
					rp-=1
				end
				a[k],a[rp],swaplp=a[rp],a[k],c(a[rp],p)
				rp-=1
			end
			if swaplp then
				a[k],a[lp]=a[lp],a[k]
				lp+=1
			end
			k+=1
		end
		lp-=1
		rp+=1
		-- sometimes lp==rp, so 
		-- these two lines *must*
		-- occur in sequence;
		-- don't combine them to
		-- save a token!
		a[l],a[lp]=a[lp],a[l]
		a[r],a[rp]=a[rp],a[r]
		qsort(a,c,l,lp-1       )
		qsort(a,c,  lp+1,rp-1  )
		qsort(a,c,       rp+1,r)
	end
end
__gfx__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88877888877777888877778887777888877777788777777888777788877887788777777888888778877887788778888887788878877887788777777887777788
88777788877887788778877887787788877888888778888887788778877887788887788888888778877877888778888887778778877787788778877887788778
87788778877777888778888887788778877777888777778887788888877887788887788888888778877778888778888887777778877777788778877887788778
87788778877887788778888887788778877888888778888887787778877777788887788888888778877778888778888887787878877777788778877887777788
87777778877887788778877887787788877777788778888887788778877887788887788887788778877877888778888887788878877877788778877887788888
87788778877777888877778887777888877777788778888888777778877887788777777888777788877887788777777887788878877887788777777887788888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88777788877777888877777887777778877887788778877887788878877887788778877887777778887777888887788888777788887777888888778887777778
87788778877887788777888888877888877887788778877887788878877887788778877888887788877887788877788887788778878887788887778887788888
87788778877887788877778888877888877887788778877887788878888778888877778888877888877877788887788888887788888777888877778887777788
87787778877777888888877888877888877887788777777887787878888778888887788888778888877787788887788888877888888887788770778888888778
87777788877877788888877888877888877887788877778887777778877887788887788887788888877887788887788888778888877887788777777887788778
88778778877887788777778888877888887777888887788887778778877887788887788887777778887777888877778887777778887777888888778888777788
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88777788877777788877778888777788888888888888888888787888888778888878878888888888888888888888888888888888887777888887788888877888
87788888888887788778877887788778888888888888888888787888888778888777777888888888888888888888888888878888877887788887788888877888
87777788888877888877778888777778888888888888888888888888888778888878878888888888888888888877778888878888888877888888888888888888
87788778888778888778877888888778888888888888888888888888888778888878878887777778888888888888888887777788888778888888888888888888
87788778888778888778877888887788888778888887788888888888888888888777777888888888888888888877778888878888888888888887788888877888
88777788888778888877778888777888888778888887788888888888888778888878878888888888877777788888888888878888888778888887788888877888
88888888888888888888888888888888888888888877888888888888888888888888888888888888888888888888888888888888888888888888888888778888
88888888888888888877888888887788887777888887777888887788887788888a8a8a8a88888888888888888888888888888888888888888888888888888888
8888887887888888877888888888877888778888888887788887788888877888a077770887777778888778888888888888888888888888888888888888888888
88888788887888888778888888888778887788888888877888778888888877881770077a87777778887777888888888888888888888888888888888888888888
8888788888878888877888888888877888778888888887788778888888888778a000770887777778877887788888888888888888888888888888888888888888
88878888888878888778888888888778877888888888778887788888888887781007700a87777778877887788888888888888888888888888888888888888888
8878888888888788877888888888877887788888888877888877888888887788a000000887777778877777788888888888888888888888888888888888888888
87888888888888788778888888888778877888888888778888877888888778881007700a87777778877887788888888888888888888888888888888888888888
8888888888888888887788888888778887777888887777888888778888778888a8a8a8a888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
__map__
0f0e160411243b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
