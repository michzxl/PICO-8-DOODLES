--maths

function sqr(a)
	return a * a
end

function fflr(a, unit)
	return a\unit*unit
end

function dist(x1, y1, x2, y2)
	return sqrt((x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1))
end

function sqrdist(x1, y1, x2, y2)
	return (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1)
end

function lerp(a,b,t)
	return a + t * (b - a)
end

function approach(a,b,t)
	if a<=b then
		 return min(a+t,b)
	elseif a>b then
		 return max(a-t,b)
	end
end

function lerp_ang(a,b,t,p)
  a=a%p
  b=b%p
  if b-a>p/2 then
	  b=b-p
  elseif a-b>p/2 then
	  a=a-p
  end
  return a + t*(b - a)
end

-- "normalized" sin/cos
-- period 1, range [0,1]
function nsin(a)
	return (sin(a) + 1) / 2
end
function ncos(a)
	return (cos(a) + 1) / 2
end

-- "range" sin/cos
-- period 1, range [r1,r2]
function rsin(a, r1, r2)
	return nsin(a) * (r2-r1) + r1
end
function rcos(a, r1, r2)
	return ncos(a) * (r2-r1) + r1
end

-- tangent. 
-- at its asymptotes, 
-- this function returns the max value 
-- allowed by a pico8 number.
function tan(a)
	return sin(a) / cos(a)
end