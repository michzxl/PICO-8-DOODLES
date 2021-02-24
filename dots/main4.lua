function _init()
	cls()

	pal({
		[0]=0,
		0,
		1+128,
		1,
		2+128,
		2,
		8+128,
		8,
		14+128,
		14+128,
		15+128,
		15+128,
		15,
		15,
		7,
		7,
	},1)

	t = 0
	maxs = 0
	mins = 2
	ssum = 0
	ti = 0

	fr = 200
	ep = thrower(
		vec(64,64),
		3,
		200,
		false,
		0,
		0.90
	)
	ep.factory.life = 30*6
	ep.factory.killspd = 0.01
	ep.factory.postupd = function(self)
		local ct16 = ct16
		local st16 = st16
		local ct12 = ct12
		local x,y = self.pos.x,self.pos.y
		local d = vec.frompolar(
			fflr(
				fflr(y/16,0.0625) 
				+ sgn((x-64))
					* sgn(y-64 + 8*st16)
					* fflr(x/16, 1/32) 
				+ t/64
			,0.5) 
			+ ct16,
			1
		)
		self.grav = d:norm(0.1 / d:sqrmagn())
	end
	ep:set_area(true,16,16)
	ep.factory.drwoverride = function(self)
		--fillp(0b1111000011110000.1)
		
		local x,y=self.pos.x,self.pos.y
		local p = mid(0,15,pget(x,y)+1)
		-- circ(x,y,1,p)
		rectfill(x,y,x+1,y+1,p)
		
		--fillp()
	end

	strs = {
  [0]="an absence\nof meaning.",
		"the face of\na stranger ..",
		"the end of\nthe street ..",
		"takes a small\nstep towards me",
		"pacing. circles\nand circles ..",
		"they meet in\na lonely cafe.",
		"under the table,\nlies something",
		"eyes cannot see.\nan empty space.",
		"a kind of hatred\nthat speaks.",
		"what else\nis there?",
		"another way\nto cry.",
		"a presence\n..",
		"in a perfect row\nof trees.",
		"an absence\nof desire.",
		" [////////////] \n [\\\\\\\\\\\\\\\\\\\\\\\\] "

	---"jgjgjgjgjgjgjgjg\njgjgjgjgjgjgjgjg",
	}
	istr = 0
	cstr = strs[istr]
	target = strs[istr]
end

function _update()
	ct16 = cos(t/16)
	ct12 = cos(t/12)
	st16 = sin(t/16)
	st12 = sin(t/12)



	water = 0

	t+=1/30
	ti += 1

	if t>1 and t%4<=1/30 then
		istr = (istr+1)%(#strs+1)
		cstr = strs[istr]
	end

	local aaf = mid(0.4,0.7,(st16+1)/2*0.7+0.2)
	aaf = 0.7

	ep.pos = vec(64+48*cos(t/8),64)

	
	for e in all(DOTS.throwers) do 
		e:upd()
	end

	for i=1,1000 do
		local x,y = rnd(128),rnd(128)
		circ(x,y,1,mid(0,15,pget(
				x+ct16,
				y+st16
			) 
			+ (rnd(1)<0.7 and -1 or 0)
		))
	end

	for e in all(DOTS.throwers) do
		e:drw()
	end

	local cc = {}
	local num = 32
	local rr = 64
	for i=0,num-1 do
		local ang = i / num
		local a = ang
		local r = rr + sin(ang)*8 
			+ ssin2(t+sin(t/8)+cos(t/16+ang)+ang*4,4,0.1,-8+8*sin(t/8)) 
			+ ssin(t+ang*8,8,2,-4)
		local v = vec.frompolar(a,r)
		v.z = sin(v.y/32 + t/8) 
			+ sin(v.x/32 + t/4)
			- 0.2
		add(cc, v)
	end
	
	POLY.polyv(cc,vec(64,64),6)

	clip(0,111,128,128)
	if t%4<3 then
		for i=1,10 do
			local x=rnd(128)
			local y=rnd(24)+104
			rectfill(x,y,x+7,y+7,0)
		end
	end
	clip()

	if rnd(1)<0.02 then cstr = replace_char(cstr,"-",flr(rnd(#cstr))+1) end

	local s = cstr
	rprint(s,0,112,0,1,{
		ang=fang,
		pos=fpos,
		trans=0,
	})
end

fang=function(char,i,x,y)
	return 0
end
fpos=function(char,i,x,y,a,w,dx,dy)
	if t%4>3.5 then
		return rnd(8)-4,rnd(8)-4
	end
	return sin(x/16+t*8)*(0.5), sin(x/16+t*8)*(0.5)
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
	local f_col=p.col or function() return 7 end
	local p_trans=p.trans
	local p_font_index = p.font_index or 0
	local p_cen=p.cen

	local a=a or 0
	local w=w or 1

	x,y=dx,dy
	if (p_cen) x=leftmargin_fromcenter(s,1,dx)

	for i=1,#s do
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

			local col = f_col(char,i,x,y,a,w,dx,dy,line)
			pal(7,col,0)

			rspr(sx,sy,xf,yf,af,w,p_trans)

			x+=w*8
		end
	end
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