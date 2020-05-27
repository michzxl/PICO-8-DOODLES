math={}

-- round a DOWN to the nearest multiple of unit.
function round(a,unit)
 	return a-a%unit
end

function dist(x1,y1,x2,y2)
    return sqrt(sqr(x2-x1)+sqr(y2-y1))
end

-- faster than dist.
-- good for comparisons.
function distsqr(x1,y1,x2,y2)
    return sqr(x2-x1)+sqr(y2-y1)
end

function sqr(a)
    return a*a
end

function acos(x)
 return atan2(x,-sqrt(1-x*x))
end

function asin(y)
 return atan2(sqrt(1-y*y),-y)
end