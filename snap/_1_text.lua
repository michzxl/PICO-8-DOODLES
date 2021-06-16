function draw_text(str,x,y,sw,sh,ang,col)
	local col = col or 7

	local R1 = vec.frompolar(ang,1)
	local R2 = R1:perp()

	local pos = vec(x,y)

	local startx = (8*sin(t/8))
	local starty = 0

	local ln = 0
	local cl = 0
	for i=1,#str do
		if i%2==0 and stat(1)>0.93 then return end
		local char = sub(str,i,i)
		if char=="\n" then
			ln,cl = adv_line(ln,cl,sw,sh,pos,R1)
		else
			local sid = get_sid(char)
			mset(0,0,sid)

			local ox = (1+0.02*sin(t/8+i/8))
			local oy = (1+0.02*sin(t/8+i/8))
			local ax1 = rnd(1)<0.05 and rnd(8) or 0
			local ax2 = 0

			local rect = {
				vec(cl*8, ln*8),
				vec(cl*8 + 8*sw*ox+ax1, ln*8),
				vec(cl*8 + 8*sw*oy+ax2, ln*8 + 8*sh),
				vec(cl*8, ln*8 + 8*sh),
			}

			if t%8<7.5 then
				for _,v in pairs(rect) do
					v:set(R1*v.x + R2*v.y + R1*startx + R2*starty)
				end

				for _,v in pairs(rect) do
					v:set(v + pos)
				end
			else
				for _,v in pairs(rect) do
					v:set(R1*v.x + R2*v.y + R1*startx + R2*starty
						+ vec(
							4*cos(t/2+i/3),
							8*sin(t/2+i/2)
						)
					)
				end

				for _,v in pairs(rect) do
					v:set(v + pos)
				end
			end

			--polyfill(rect,vec(0,0),0)
			poke(0x5f5e,0b11111111)
			local a,b,c,d = unpack(rect)
			rectfill(a.x-1,a.y+4,a.x+16,a.y+14,0)
			pal(7,0,0)
			tquad(
				a.x+2,a.y+2,
				b.x+2,b.y+2,
				c.x+2,c.y+2,
				d.x+2,d.y+2,
				0,0,
				1,1
			)
			pal(7,col,0)
			tquad(
				a.x,a.y,
				b.x,b.y,
				c.x,c.y,
				d.x,d.y,
				0,0,
				1,1
			)

			if rect[2].x>120 or rect[3].x>120 then
				ln,cl = adv_line(ln,cl,sw,sh,pos,R1)
				cl -= sw
			end
			cl = cl + 1*sw
		end
	end

	pal(7,7,0)
end

function adv_line(ln,cl,sw,sh,pos,R1)
	local ln = ln + sh
	local cl = 0
	while (pos+R1*cl).x>20 do
		cl = cl - sw
	end
	cl = sw*cos(t/8)
	if (pos+R1*cl).x<0 then cl += 1 end
	-- if (pos+R1*cl).x<0 then
	-- 	cl = cl + sw
	-- end
	return ln,cl
end

function calc_wh(str)
	local w = #str
	local h = 1
	return w,h
end

function polyv(vecs,cen,col)
	if cen then camera(-cen.x,-cen.y) end
	local len = #vecs
	for i=1,len-1 do
		local p1,p2 = vecs[i], vecs[i+1]
		line(p1.x,p1.y,p2.x,p2.y,col)
	end
	local p1,p2 = vecs[1],vecs[len]
	line(p1.x,p1.y,p2.x,p2.y,col)
	camera()
end

function write_to_map(str,w,h)
	for i=0,w-1 do
		mset(i,0,0)
	end

	for i=1,#str do
		local char = sub(str,i,i)
		local sid = get_sid(char)
		mset(i-1,0,sid)
	end
end

function get_sid(char)
	if char~=" " then
		local sid = ords(char)
		if char=="a" then
			sid = 58
		end
		return sid
	else
		return 59
	end
end

function replace_char(s,c,p)
	if sub(s,p,p)=="\n" or sub(s,p,p)==" " then return s end
	return sub(s,1,p-1) .. c .. sub(s,p+1,#s)
end
