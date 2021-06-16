local gen = (function()
	local i=0
	return function()
		i=i+1
		if i%3==0 then
			return 0b11110001
		elseif i%3==1 then
			return 0b11110010
		else
			return 0b11110100
		end
	end
end)

function gcos(x,h1,h2,p)
	return (h2-h1)/2 * cos(x / p) + (h1+h2)/2
end

function gsin(x,h1,h2,p)
	return (h2-h1)/2 * sin(x / p) + (h1+h2)/2
end

function ttonum(obj)
	for k,e in pairs(obj) do
		if type(e)=="table" then
			ttonum(e)
		elseif type(e)=="string" then
			obj[k] = tonum(e)
		end
	end
	return obj
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

function makeset(tbl)
	local set={}
	for key,elem in pairs(tbl) do
		set[elem]=key
	end
	return set
end

-- SPRITESHEET TO TEXT


local ords = (function()
	local punctset = (function(tbl)
		local set={}
		for key,elem in pairs(tbl) do
			set[elem]=key
		end
		return set
	end)({
		'.', ',', '\"', "!", "#",
		"-", "_", "=", "+", "?",
		":", ";", "/", "\\", "(", ")",
		"[", "]", "<", ">", "`", "|"
	})
	return function(c)
		local o=ord(c)
		if ord('a')<=o and o<=ord('z') then
			return o - ord('a') -- A-Z : 0-25
		elseif ord('0')<= o and o<=ord("9") then
			return o - ord('0') + 26 -- 0-9 : 26-35
		elseif punctset[c] then
			return 36 + punctset[c] - 1 -- punct : 36-whatever
		else
			return 56 -- `NOT FOUND` ~ i.e. a ? in a box
		end
	end
end)()

function circinv(cx,cy,r,sx,sy,c)
	for y=0,127,sy do
		local h = abs(cy-y)
		if h<r then
			local d = sqrt(r*r - h*h)
			local x1 = (sx>1 and ((cx-d)\sx*sx) or (cx-d))
			local x2 = (sx>1 and ((cx+d)\sx*sx) or (cx+d))
			rectfill(-1,y,x1,y+sy-1,7)
			rectfill(x2,y,128,y+sy-1,7)
		else
			rectfill(-1,y,128,y+sy-1,7)
		end
	end
end