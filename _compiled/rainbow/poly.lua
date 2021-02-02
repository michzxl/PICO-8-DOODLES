--poly

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

------------------------------

-- triangle wave, period 1, range [0,0.5]
function triwave(x)
    return abs((x + .5) % 1 - .5)
end

-- "complex" triangle wave, range [center - amplitude/2, center + amplitude/2]
-- to visualize -> https://www.desmos.com/calculator/lbicgo2khe
function ctriwave(x, center, amplitude, period)
    local a, b, p = amplitude or 1, center or 0, period or 1
    local core = abs((x / p - 0.25) % 1 - 0.5)
    return 2 * a * core - a / 2 + b
end

-- "range" triangle wave, range [y1,y2]
function rtriwave(x, y1, y2, period)
    local amplitude = (y2 - y1)
    local center = (y1 + y2) / 2
    return ctriwave(x, amplitude, center, period)
end

-- n-gon, n sides and maximum radius 1
-- visualize it -> https://www.desmos.com/calculator/njxxfrv23z
function ngon(ang, n)
    local top = rmax * cos(0.5 / n)
    local bot = cos(triwave(n * ang - 0.5) / 2 / n)
    return top / bot
end

-- ngon, n sides and minimum radius 1
function ngon_min(ang,n)
    local top = 1
    local bot = cos(triwave(n * ang - 0.5) / 2 / n)
    return top / bot
end

-- returns a func that represents an n-gon with max radius 1
-- if use_min is true, 1 will instead be the min radius of the n-gon
function ngon_maker(n, use_min)
    local tmp=use_min_radius and 1 or cos(0.5/n)
    return function(ang)
        local top = tmp
        local bot = cos(triwave(n*ang-0.5)/2/n)
        return top / bot
    end
end