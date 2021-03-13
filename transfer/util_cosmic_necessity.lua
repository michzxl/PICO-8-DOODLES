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
		if (stat(1)>0.98) then return end
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

			
			pal(7,1,0)
			rspr(sx,sy,xf,yf+1,af,w,p_trans)
			rspr(sx,sy,xf,yf-1,af,w,p_trans)
			rspr(sx,sy,xf+1,yf,af,w,p_trans)
			rspr(sx,sy,xf-1,yf,af,w,p_trans)
			rectfill(xf,yf,xf+7,yf+5,1)

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