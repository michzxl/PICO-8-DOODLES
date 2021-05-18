-- ---@alias sprite_id integer

-- ---@param n sprite_id
-- ---@param x number
-- ---@param y number
-- ---@param w number
-- ---@param bx map_buffer_x
-- ---@param by map_buffer_y
-- function tspr(n, x, y, w, h, bx, by, ps)
-- 	-- allow variable widths?
-- 	-- 	x-widths < 8 already possible.
-- 	-- no rotation yet.

-- 	ps = ps or {}
-- 	local shx_0,shy_0,scx,scy =
-- 		ps.shx_0  or 0,
-- 		ps.shy_0  or 0,
-- 		ps.scx    or 1, ps.scy or 1

-- 	local w,h=8,8

-- 	mset(bx,by,n)
-- 	local mdx, ssy, ydir, nh = 0.125/scx, (ps.scale_shear and scy or 1), sgn(scy), scy*h
-- 	for dy=0,nh+ydir,ydir do
-- 		local xm = ((ps.shx_1 or 0)-shx_0)*(ps.scale_shear and scx or 1)*dy/nh + shx_0
-- 		tline(
-- 			x + xm,
-- 			y + dy + ydir*shy_0*ssy,
-- 			x + xm + scx*w-1,
-- 			y + dy + ydir*(ps.shy_1  or 0)*ssy,
-- 			bx,
-- 			by + dy/h/scy,
-- 			mdx * sgn(scx)
-- 		)
-- 	end
-- end

function tsprrect(x,y,sw_rot,mx,my,w,h)
	local dx, dy, r, cs, ss = 0, 0, max(w,h)/2, cos(sw_rot), -sin(sw_rot)
	if w>h then dy = (w-h)/2 else dx = (h-w)/2 end
	local ssx, ssy, cx, cy = mx - 0.3 -dx, my - 0.3 -dy, mx+r-dx, my+r-dy

	ssy -=cy
	ssx -=cx

	local delta_px = max(-ssx,-ssy)*8

	--this just draw a bounding box to show the exact draw area
	rect(x-delta_px,y-delta_px,x+delta_px,y+delta_px,5)

	local sx, sy =  cs * ssx + cx, -ss * ssx + cy

	for py = y-delta_px, y+delta_px do
		 tline(x-delta_px, py, x+delta_px, py, sx + ss * ssy, sy + cs * ssy, cs/8, -ss/8)
		 ssy+=1/8
	end
end

function tsprsqr(x,y,sw_rot,mx,my,r)    
	local cs, ss = cos(sw_rot), -sin(sw_rot)    
	local ssx, ssy, cx, cy = mx - 0.3, my - 0.3, mx+r/2, my+r/2

	ssy -=cy
	ssx -=cx

	local delta_px = -ssx*8

	--thst draw a bounding box to show the exact draw area
	rect(x-delta_px,y-delta_px,x+delta_px,y+delta_px,5)

	local sx, sy =  cs * ssx + cx, -ss * ssx + cy

	for py = y-delta_px, y+delta_px do
		 tline(x-delta_px, py, x+delta_px, py, sx + ss * ssy, sy + cs * ssy, cs/8, -ss/8)
		 ssy+=1/8
	end
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

function ttri(xa, ya, xb, yb, xc, yc, sxa, sya, sxb, syb, sxc, syc)
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
