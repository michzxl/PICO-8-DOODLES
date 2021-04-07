fang=function(char,i,x,y)
	return 0
end
fpos=function(char,i,x,y,a,w,dx,dy)
	if t%interval>interval-0.1 then
		return sin(x/64+t*2)*(0.501)+0.5, -32
	end
	if rnd(1)<0.025 then
		return 120-x-x,8
	end
	return sin(x/64+t*2)*(0.501)+0.5, 0
end

function ssin(x,p,w,a)
	local x = x%p
	if x<=2*w then
		return a/2 - a/2 * cos(x / (2*w))
	else
		return 0
	end
end

function ssin2(x,p,w,a)
	local x = x%p
	if x<=2*w then
		return a
	else
		return 0
	end
end

function rprint(s,dx,dy,a,w,p)
	local f_ang=p.ang or function() return 0 end
	local f_pos=p.pos or function() return 0,0 end
	local f_col=p.col or function() return 15 end
	local p_trans=p.trans
	local p_font_index = p.font_index or 0
	local p_cen=p.cen

	local a=a or 0
	local w=w or 1

	x,y=dx,dy
	if (p_cen) x=leftmargin_fromcenter(s,1,dx)

	for i=1,#s do
		--if (stat(1)>0.98) then return end
		local char = sub(s,i,i)

		if char=='\n' then
			x=dx
			y+=w*8
			if (p_cen) x=leftmargin_fromcenter(s,i+1,dx)
		elseif char==' ' then
			x+=w*8
		else
			local sid = ords(char) + (p_font_index or 0)
			local sx,sy = flr(sid%16)*8, sid\16*8
			
			local af = a + (f_ang and f_ang(char,i,x,y,a,w,dx,dy) or 0)

			local ofsx,ofsy
			if f_pos then
				ofsx,ofsy = f_pos(char,i,x,y,a,w,dx,dy)
			else
				ofsx,ofsy = 0,0
			end
			local xf,yf=x+ofsx,y+ofsy

			if i==#s or sub(s,i+1,i+1)=="\n" then
				pal(7,7,0)
				pal(6,8,0)
				
				mset(0,0,sid)
				tquad(
					xf,yf,
					xf+16,yf,
					xf+32,yf+32,
					xf+16,yf+32,
					0,0,
					1,1
				)

				pal(7,7,0)
				pal(6,6,0)
			else
				rectfill(xf,yf,xf+7,yf+8,1)

				pal(7,7,0)
				pal(6,8,0)
				rspr(sx,sy,xf,yf,af,w,p_trans)

				pal(7,7,0)
				pal(6,6,0)
			end
			x+=w*8
		end
	end
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

function append(t1, t2)
	for elem in all(t2) do
		add(t1, elem)
	end
	return t1
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

function leftmargin_fromcenter(str,starti,dx)
	local line = get_line(sub(str,starti))
	return dx - #line*8/2
end

function get_line(str)
	nl = find_str(str,"\n")
	if not nl then return str end
	return sub(str,1,nl-1)
end

function split(str, delim)
	delim = delim or '\n'
	ss={}
	i1,i2=1,1
	while i2<=#str do
		if sub(str,i2,i2)==delim then
			add(ss, sub(str,i1,i2-1))
			i2+=1
			i1=i2
		elseif i2==#str then
			add(ss, sub(str,i1,i2))
			i2+=1
		else
			i2+=1
		end
	end
	return ss
end

function find_str(str,look)
	for i=1,#str-#look+1 do
		test=sub(str,i,i+#look-1)
		if look==test then return i end
	end
	return false
end

function rspr(sx,sy,x,y,a,w,trans)
	local na=a%1
	local ww=w*8
	if na<0.02 or na>(1-0.02) then 
		sspr(sx,sy,ww,ww,x,y)
	elseif abs(na-0.5)<0.02 then
		sspr(sx,sy,ww,ww,x,y,ww,ww,true,true)
	else
		local ca,sa=cos(a),sin(a)
		local srcx,srcy
		local ddx0,ddy0=ca,sa
		local mask = 0xfff8<<(w-1)
		w*=4
		ca*=w-0.5
		sa*=w-0.5
		local dx0,dy0=sa-ca+w,-ca-sa+w
		w=2*w-1
		for ix=0,w do
			srcx,srcy=dx0,dy0
			for iy=0,w do
				if (srcx|srcy)&mask==0 then
					local c=sget(sx+srcx,sy+srcy)
					if c~=trans then
						pset(x+ix,y+iy,c)
					end
				end
				srcx-=ddy0
				srcy+=ddx0
			end
			dx0+=ddx0
			dy0+=ddy0
		end
	end
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
	"[", "]", "<", ">", "`", "|", "%", "\'"
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
	return sub(s,1,p-1) .. c .. sub(s,p+1,#s)
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
