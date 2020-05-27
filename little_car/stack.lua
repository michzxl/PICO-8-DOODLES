local rspr_clear_col=0
function rspr(sx,sy,x,y,a,w)
	local ca,sa=cos(a),sin(a)
	local srcx,srcy,addr,pixel_pair
	local ddx0,ddy0=ca,sa
	local mask=shl(0xfff8,(w-1))
	w=w*(4)
	ca=ca*(w-0.5)
	sa=sa*(w-0.5)
	local dx0,dy0=sa-ca+w,-ca-sa+w
	w=2*w-1
	for ix=0,w do
		srcx,srcy=dx0,dy0
		for iy=0,w do
			if band(bor(srcx,srcy),mask)==0 then
				local c=sget(sx+srcx,sy+srcy)
				sset(x+ix,y+iy,c)
			else
				sset(x+ix,y+iy,rspr_clear_col)
			end
			srcx=srcx-ddy0
			srcy=srcy+ddx0
		end
		dx0=dx0+ddx0
		dy0=dy0+ddy0
	end
end

bufx,bufy=8,64
function stackspr(sx,sy,w8,h,x,y,ang,mx,my,mh) 
 	ang=ang or 0
 	mx,my,mh=mx or 1,my or 1,mh or 1
 	for i = 1, h do
  		rspr(sx+(i-1)*w8*8,sy,bufx,bufy,ang,w8)
  		sspr(bufx, bufy, w8*8, w8*8, x, y - mh*i - mh*1,w8*8*mx,w8*8*my)
 	end
end