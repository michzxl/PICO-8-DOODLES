--util

function pprint(s,x,y,fg,bg)
	bg = bg or 12
	fg = fg or 4
	cursor(x,y)
	color(bg)
	print(s,x+1,y+1+1)print(s,x+1,y+2+1)
	print(s,x-1+1,y+2+1)
	print(s,x+1+1,y+2+1)
	print(s,x+1+1,y+1+1)
	print(s,x-1+1,y-1+1)
	print(s,x-1+1,y+1+1)
	print(s,x+1+1,y-1+1)
	print(s,x+1,y-1+1)
	print(s,x+1+1,y+1)
	print(s,x-1+1,y+1)
	color(fg)
	print(s,x+1,y+1)
end

function poke_palette_reset(set)
	poke(0x5f2e,set and 0 or 1)
end

function poke_devkit(set)
	poke(0x5f2d, set and 1 or 0)
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

-- qsort(a,c,l,r)
--
-- a
--    array to be sorted,
--    in-place
-- c
--    comparator function(a,b)
--    (default=return a<b)
-- l
--    first index to be sorted
--    (default=1)
-- r
--    last index to be sorted
--    (default=#a)
--
-- typical usage:
--   qsort(array)
--   -- custom descending sort
--   qsort(array,function(a,b) return a>b end)
--
function qsort(a,c,l,r)
	c,l,r=c or function(a,b) return a<b end,l or 1,r or #a
	if l<r then
		if c(a[r],a[l]) then
			a[l],a[r]=a[r],a[l]
		end
		local lp,k,rp,p,q=l+1,l+1,r-1,a[l],a[r]
		while k<=rp do
			local swaplp=c(a[k],p)
			-- "if a or b then else"
			-- saves a token versus
			-- "if not (a or b) then"
			if swaplp or c(a[k],q) then
			else
				while c(q,a[rp]) and k<rp do
					rp-=1
				end
				a[k],a[rp],swaplp=a[rp],a[k],c(a[rp],p)
				rp-=1
			end
			if swaplp then
				a[k],a[lp]=a[lp],a[k]
				lp+=1
			end
			k+=1
		end
		lp-=1
		rp+=1
		-- sometimes lp==rp, so 
		-- these two lines *must*
		-- occur in sequence;
		-- don't combine them to
		-- save a token!
		a[l],a[lp]=a[lp],a[l]
		a[r],a[rp]=a[rp],a[r]
		qsort(a,c,l,lp-1       )
		qsort(a,c,  lp+1,rp-1  )
		qsort(a,c,       rp+1,r)
	end
end
