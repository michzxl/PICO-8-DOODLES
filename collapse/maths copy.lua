--maths

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

function sqr(a) return a*a end