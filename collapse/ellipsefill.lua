-->8
-- ellipse fill function
-- usage:
-- x0/y0: ellipse center
-- h/w: height/width
-- angle
-- c: color
function ellipsefill(x0,y0,w,h,angle,c)
	local asq,bsq=w*w,h*h
  
	-- max. extent
	local ab=max(w,h)
	  
	local cc,ss=cos(angle),sin(angle)
	local csq,ssq=cc*cc,ss*ss
	local rb0=shl(cc*ss*(1/asq-1/bsq),1)
	local rc0=ssq/asq+csq/bsq
	local ra=shl(csq/asq+ssq/bsq,1)
	  
	color(c)
	for y=max(y0-ab,0),min(y0+ab,127) do
		-- roots
		local yy=y-y0+0.5
		local rb,rc=rb0*yy,yy*yy*rc0-1
		
		local r=rb*rb-shl(ra*rc,1)
		if r==0 then
			pset(x0-rb/ra,y)
		elseif r>0 then
			r=r^0.5
			rectfill(x0+(-rb+r)/ra,y,x0+(-rb-r)/ra,y)
		end
	end
end