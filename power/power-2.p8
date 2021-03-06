pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include fills.lua
#include vec.lua
#include subpixel.lua
#include torus_lo.lua

function _init()
	cls()
	t = 0
	ITS_TIME = 8
	pal({
		[0]=2+128,
		2+128,
		2,
		8+128,
		8,
		9+128,
		9,
	}, 1)
	prts = {}
end

function _update()
	cls()
	t = t + 1/30

	-- local r = 150
	-- line(0,-t*r%128,127,-t*r%128,0)
	-- line(0,-t*r%128+1,127,-t*r%128+1,0)
	-- line(0,-t*r%128+2,127,-t*r%128+2,0)

	--fillp(0b0111101011011110.1)
	local a = 12.5+2.5*sin(t/16)
	local w = 100+16*sin(t/8)
	local b = 1.9+0.5*sin(t/4)
	local p = 16+1*cos(t/5)
	local max = mid(0,150,t/ITS_TIME*128-16-2)
	for y=0,max,1 do
		local x = g(y,a,w,b,p)
		x = x
		if (max-y<4) then
			fillp(0b0101101001011010.1)
		end
		line(2,y,x+2,y,3)
		line(125,128-y,125-x,128-y,3)
		fillp()
	end
	--fillp()

	if t>ITS_TIME+1 then
		particle_garbage()
	end

	draw_frame()

	POLY.objdraw(torus,
		vec(64 + 8*cos(t/8) + 3*sin(t/16),64 + 8*sin(t/8) + 3*cos(t/16)), 
		vec(1/12+t/15,1/8+t/9,1/8-t/32),
		vec.ones()*24,
	true,7)
end

function g(x,a,w,b,p)
	return 
		  b
		* -sin(x/256 )
		* -sin(x/p - t)
		* f(x,a,w)/8

		+ f(x,a,w)
end

function f(x, a, w)
	local res = 0
	if x > 64-w/2 and x < 64 + w/2 then
		res = 
			a/2 * (
				-sin((x - (64-w/4)%w) / w)
				+ 1
			)
	else
		res = 0
	end
	return res
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

function draw_frame()
	local rat = mid(0,150,t/ITS_TIME*128)
	local col = 3
	local col2 = 2
	local mod = 16

	line(1,1,1,126,0)
	line(1,1,126,1,0)
	line(1,126,126,126,0)
	line(126,126,126,1,0)

	line(0,3,rat-mod,3,col2)
	
	line(0,0,rat,0,col)
	line(0,2,rat-mod,2,col)

	line(0,0,0,rat,col)
	line(2,0,2,rat-mod,col)

	pset(1,2,0)
	pset(1,3,0)

	line(127,127,127-rat,127,col)
	line(127,125,127-rat+mod,125,col)

	pset(126,125,0)

	line(127,127,127,127-rat,col)
	line(125,127,125,127-rat+mod,col)

	pset(125,1,0)
	pset(2,126,0)

	
end

function particle_garbage()
	local locations = {
		vec(0,0),
		vec(127,0),
		vec(0,127),
		vec(127,127),
	}
	for i=1,1 do
		local spwn = locations[flr(rnd(#locations)+1)]
		local spd = 2+rnd(2)-1
		
		local delta = vec(64,64)-spwn
		dir = atan2(delta.x,delta.y)

		local vel = vec.frompolar(dir+rnd(1/4)-1/8, spd)
		local dmp = 0.92+rnd(0.1)-0.05
		add(prts, {
			vel = vel,
			pos = spwn,
			dmp = dmp,
		})
	end
	while #prts>35 do
		deli(prts,1)
	end
	for prt in all(prts) do
		prt.pos = prt.pos + prt.vel
		prt.vel = prt.vel * prt.dmp

		local x,y = prt.pos:xy()
		local vx,vy = prt.vel:xy()
		line2(x,y,x+vx*4,y+vy*4,4)

		if prt.vel:magn()<0.2 then 
			del(prts,prt)
		end
	end
end


POLY = {}

function POLY.triv(a,b,c,col)
	line(a.x,a.y,b.x,b.y,col)
	line(b.x,b.y,c.x,c.y,col)
	line(c.x,c.y,a.x,a.y,col)
end

function POLY.quadv(a,b,c,d,col)
	line(a.x,a.y,b.x,b.y,col)
	line(b.x,b.y,c.x,c.y,col)
	line(c.x,c.y,d.x,d.y,col)
	line(d.x,d.y,a.x,a.y,col)
end

function POLY.polyv(vecs,cen,col)
	local len = #vecs
	local cen = cen or vec()
	for i=1,len-1 do
		local p1,p2 = vecs[i] + cen, vecs[i+1] + cen
		line(p1.x,p1.y,p2.x,p2.y,col)
	end
	local p1,p2 = vecs[1]+cen,vecs[len]+cen
	line(p1.x,p1.y,p2.x,p2.y,col)
end

function POLY.path(vecs,cen,col)
	cen = cen or vec()
	for i=1,#vecs-1 do
		local p1 = vecs[i] + cen
		local p2 = vecs[i+1] + cen
		line(p1.x,p1.y,p2.x,p2.y,col)
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
		if n.z>0 then
			local vs = {}
			for vi in all(f) do
				local vb = buf[vi+1][1]
				local ov = vec(unpack(vb))
				local v = us:dot(vec.newp(
					vb[1]*scale.x,
					vb[2]*scale.y,
					vb[3]*scale.z
				)) + trans

				local mod = 32*sgn(v.x-trans.x)
				local y = (v.y + t*64)
				if t>ITS_TIME and y%164<16 then
					v.x += mod
					v.y += mod/4
				end

				add(vs, v)
			end
			add(nfs, {vs=vs, n=n})
		end
	end

	qsort(nfs, function(a,b)
		local ac,bc = POLY.cen(a.vs), POLY.cen(b.vs)
		return ac.z <= bc.z
	end)

	for f in all(nfs) do
		local vs,n = f.vs,f.n 
		local ramp = #reds

		local light = (-(n.y + n.z*0.5 + n.x*1 + 0.25*sin(t/8+vs[1].x/64))+2.5/2)/3
		local col = light*(ramp)+0
		local fcol = flr(col)
		local fill = FILLS[flr((col-fcol)*lenFILLS+1)]
		local fcol = mid(0.0,ramp,fcol)
			+ 16*mid(0.0,ramp,fcol+1)
		
		if #vs==3 then
			fillp(fill)
			
			POLY.trifill(vs[1], vs[2], vs[3], fcol)

			if wire then
				fillp(0b0101000010100000.1)
				local a,b,c = vs[1], vs[2], vs[3]
				-- local x,y,z,t = vec(2,1),vec(-1,2),vec(-2,-1),vec(1,-2)
				local x,y,z,t = vec(1,1),vec(-1,1),vec(-1,-1),vec(1,-1)
				POLY.triv(a+x,b+x,c+x, fcol)
				POLY.triv(a+y,b+y,c+y, fcol)
				POLY.triv(a+z,b+z,c+z, fcol)
				POLY.triv(a+t,b+t,c+t, fcol)
			end
			fillp()
		else
			fillp(fill)
			POLY.trifill(vs[1], vs[2], vs[3], fcol)
			POLY.trifill(vs[1], vs[3], vs[4], fcol)

			if wire then
				fillp(0b0101000010100000.1)
				local a,b,c,d = vs[1], vs[2], vs[3], vs[4]
				-- local x,y,z,t = vec(2,1),vec(-1,2),vec(-2,-1),vec(1,-2)
				local x,y,z,t = vec(1,1),vec(-1,1),vec(-1,-1),vec(1,-1)
				POLY.quadv(a+x,b+x,c+x,d+x, fcol)
				POLY.quadv(a+y,b+y,c+y,d+y, fcol)
				POLY.quadv(a+z,b+z,c+z,d+z, fcol)
				POLY.quadv(a+t,b+t,c+t,d+t, fcol)
			end
			fillp()
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
