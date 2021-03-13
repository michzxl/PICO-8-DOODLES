pico-8 cartridge // http://www.pico-8.com
version 30
__lua__
level=64
box={
	x1=64,y1=0,
	x2=64+9,y2=9,
	w=10,h=10,
	vy=0
}

pal(1,1,1)
pal(2,1+128,1)
pal(7,6+128,1)

ppp = {
	1+128,
	2+128,
	4+128,
	4,
	4+128,
	2+128
}
for i=1,#ppp,1 do
	pal(i+8-1,ppp[i],1)
end

--fillp(0b1100110000110011)

function level(t)
	return function(x)
		x=x-64
		return 64-sin(x/128-t*0.3)*(16*sin(t*0.7))
			+cos(x/32-t*0.5)*sin(t/8)*3
	end
end

t=0

function _init()
end

function _update60()
	t+=1/60

	w=level(t)
	
	wg=0.5*(w(box.x1)+w(box.x2))
	
	if box.y2>wg then
		depth=box.y2-wg
		if abs(box.y2-wg)<.5 then
		else
			box.vy-=.2
			box.vy*=.9
		end
	end
	
	box.vy+=0.08
	box.y1+=box.vy
	box.y2+=box.vy
end

function _draw()
	--cls()
	--fillp()
	--cls(12)

	for i=1,800 do
		local x,y=rnd(128),rnd(128)
		local c = flr(x/64 + y/32 + t)
		c += (8*(x/2)/(y*2+40) - t)
			+  ((y/2)/(x+16))/4
		c = c%6+8

		local fill = 0
		if c - flr(c) > 0.5 then
			fill = 0b1111000011110000.1
		end

		fillp(fill)
		circ(x,y,1,flr(c%16) + 16*flr(mid(c%16-2,13,7)))
		fillp()
	end
	
	bb=4+sin(t/8)*1.2
	for i=0-128,128,bb do
		--line(i,w(i),i+bb,w(i+bb))

		rectfill(
			i,
			w(i)+sin(t)*2
				- (sin(t/4)+1)*.5*16 
				+ 8*sin(t/4+i/128) + 8,
			i+bb-1,
			128,
			1
		)
	end

	for i=0-128,128,bb do
		--line(i,w(i),i+bb,w(i+bb))

		tline(
			i,
			w(i)+sin(t)*2,
			i+128+(sin(t/16))*20+sin(i/64-t*0.7)*20,
			128+64,
			0,
			0,
			1/8+1/16*sin(t/4+i/128),
			0
		)
	end
	
	--rectfill(box.x1,box.y1,box.x2,box.y2,1)
end

function line2(x1,y1,x2,y2,c)
	local num_steps=max(
	 abs(flr(x2)-flr(x1)),
	 abs(flr(y2)-flr(y1)))
	local dx=(x2-x1)/num_steps
	local dy=(y2-y1)/num_steps
	for i=0,num_steps do
	 pset(x1,y1,c)
	 x1+=dx
	 y1+=dy
	end
  end

function pset2(x,y,c)
	pset(x+0.5,y+0.5,c)
end

__gfx__
77777777777777777700007770077077770770770707077700000007770700070007000700070007000700070707070707070707070707070707070707070707
__label__
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscccccscccccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscccccscccccscccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccscc7cc7cc7ccscccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscscc7ccc7cc7cc7ccccscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccccc7cc7ccc7cc77cccccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccsc7ccc7ccc7cc7cc7c7cscccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccsccccc7ccc7ccc7cc7cc7c77ccscccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccscccccscccccscccccsccccc7cc7cccc7ccc7cc7cc7c77ccccscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccccscccccscc7ccs7777777777cc7cccc7cc7ccc7cc77c77cccccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccsccccc7ccc7cc7c77777777777ccc7ccc7ccc7cc7ccc77c77cscccccscccccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccsccccc7ccc7ccc7cc7c77777777777ccc7ccc7ccc7cc7cc7c7c777ccscccccscccccscccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccsccc7ccc7ccc7c7c7777777777c7cc7cccc7ccc7cc7cc7c7c777c7ccscc7ccscccccscccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscc7cccc7ccc7ccc7c77777777777cc7cc7ccc7ccc7ccc7cc7c77c77c7cc7cc7cc7c7cccccscccccscc
scccccscccccscccccscccccscccccscccccscccccscccccc7cccc7ccc7cc7cc7777777777cc7ccc7ccc7ccc7cc7ccc7c77c77c7cc7cc7cc7c7c7cccccsccccc
cccscccccscccccscccccscccccscccccscccccscccccscccc7cccc7ccc7cc7c7777777777ccc7cc7cccc7ccc7cc7ccc7c77c77c7cc7cc7cc7c7c7cscccccscc
scccccscccccscccccscccccscccccscccccscccccscc7ccccc7cccc7ccc7cc777777777777ccc7cc7cccc7ccc7cc7cc7c7c7c77c7cc7cc7cc7c7c77ccsccccc
cccscccccscccccscccccscccccscccccscccccscccccc7ccccc7cccc7cc7ccc7777777777c7cc7ccc7ccc7ccc7ccc7cc7c7c7c77c7cc7cc7cc7c7c77ccccscc
scccccscccccscccccscccccscccccscccccscccccscccc7ccccc7cccc7cc7cc7777777777cc7cc7ccc7ccc7ccc7cc7ccc7c7c7c77c7cc7cc7cc7c7c777ccccc
cccscccccscccccscccccscccccscccccscccccscc7ccccc7ccccc7cccc7cc7ccc7c7c7cc7cc7ccc7cc7cccc7ccc7cc7ccc7c7c7c77c7cc7cc7cc7c7c777cscc
scccccscccccscccccscccccscccccscccccscccccc7ccccc7ccccc7cccc7cc7ccc7c7c7cc7cc7ccc7cc7ccc7ccc7ccc7ccc7c7c7c77c7cc7cc7cc7c7c777ccc
cccscccccscccccscccccscccccscccccscccccscccc7ccccc7ccccc7cccc7cc7ccc7c7c7c7ccc7cc7ccc7ccc7ccc7ccc7cc7cc7c7c77c7cc7cc7cc7c7c777cc
scccccscccccsccccc7ccc7c7cc7ccscccccsccc7cccc7ccccc7ccccc7cccc7cc7cc7cc7c7c7ccc7cc7cc7cccc7ccc7cc7ccc7cc7c7c77c7cc7cc7cc7c7c777c
7ccscccccsccccc7ccc7ccc7c7cc7c7ccscc7cccc7cccc7ccccc7ccccc7cccc7cc7cc7cc77cc7cc7ccc7cc7cccc7ccc7cc7ccc7c7c7c7c7c7cc77c7cc7c7c777
c7c7ccsccccc7ccc7ccc7ccc7c7cc7c7cc7cc7cccc7cccc77cccc77cccc7cccc7cc7cc7c7c7cc7cc7cc7ccc7ccc7ccc7ccc7ccc7c7c7c7c7c7ccc7c7cc7c7c77
777c7c7cc7ccc7ccc7ccc7ccc7c7cc7c7cc7cc7cccc77cccc7ccccc7cccc7cccc7cc7cc7c7c7c7ccc7cc7ccc7ccc7ccc7ccc7ccc7c7c7c7c7c7ccc7c77c7c7c7
c777c7c7cc7ccc7cc7ccc7ccc7cc7cc7c7cc7cc7ccccc7cccc7ccccc7cccc7cccc7cc7cc7c7c7c7cc7ccc7cc7cccc7ccc7cc7ccc7cc7c7c7c7c7ccc7cc7c7c7c
cc77cc7c7cc7cc7ccc7ccc7ccc7cc7cc7c7cc7cc7ccccc7cccc7ccccc7cccc7cccc7cc7cc7c77cc7cc7ccc7cc7ccc7cccc7cc7ccc7cc7c7c7c7c7ccc7cc7c7c7
7cc77c7c7cc7ccc7ccc7ccc7ccc7cc7cc7c7cc7cc77cccc7cccc7ccccc7cccc7ccc7ccc7cc7c77cc7cc7cc7ccc7ccc7ccc7ccc7ccc7cc7c7c7c7c7ccc7cc7c7c
c7cc77c7c7cc7ccc7ccc7ccc7ccc7cc7cc7c7cc77cc7cccc7cccc7ccccc7cccc7ccc7cc7ccc7c77c7ccc7cc7cc7cccc7ccc7ccc7ccc7cc7c7c7c7c77cc7cc7c7
7c7c777c7c7cc7ccc7ccc7ccc7ccc7cc7cc7c7ccc7cc7cccc7cccc7ccccc7cccc7ccc7cc7cc7c7c7c7cc7ccc7cc7cccc7ccc7ccc7ccc7c7cc7c7c7cc7cc7cc7c
c7c7c777c7c7cc7ccc7ccc7ccc7ccc7c7ccc7c7ccc7cc7cccc7cccc7ccccc7cccc7ccc7cc7cc7c7c7c7cc7cc7ccc7ccc7cccc7cc7ccc7cc7cc7c7c7cc7cc7cc7
7c7c7c777c7c7cc7ccc7cc7cccc7ccc7c7ccc7c7ccc7cc7cccc7cccc7ccccc7cccc7ccc7cc7cc7c77cc7cc7cc7ccc7ccc7ccc7ccc7ccc7cc7cc7c7c7cc7cc7cc
c7c7c7c777c7c7cc7cc7ccc7ccc7cccc7c7ccc7c7ccc7cc7cccc7cccc7ccccc7cccc7ccc7cc7cc7c77cc7cc7cc7cc7cccc7ccc7ccc7ccc7cc7cc7c7c7cc7cc7c
cc7c777c7777c7cc7ccc7ccc7ccc7cccc7c7ccc7c7ccc7cc7cccc77ccc7ccccc7cccc7ccc7cc7cc7c77c7cc7ccc7cc7ccc7cccc7ccc7ccc7cc7c7cc7c7cc7cc7
7cc7cc77c77c7c7cc7ccc7ccc7ccc7ccc7cc7ccc7c77cc7cc7ccccc7ccc77cccc7cccc7ccc7cc7cc7c77c7cc7cc7ccc7ccc7ccc7ccc7cccc7cc7c7cc7c7cc7cc
c7cc7cc77c77c7c7cc7ccc7ccc7ccc7ccc7cc7ccc7cc7cc7cc7ccccc7cccc7cccc7cccc7ccc7cc7cc77c7c7cc7cc7cc7cccc7ccc7ccc7ccc7ccc7c7cc7c7cc7c
cc7cc7cc77c77c7c7cc7ccc7ccc7ccc7ccc7cc7ccc7cc7cc7cc77cccc7cccc7cccc7cccc7ccc7cc7cc777cc7cc7cc7cc7cccc7ccc7ccc7ccc7cc7cc7cc7c7cc7
7cc7cc7cc77c77c7c7cc7cc7ccc7cccc7ccc7cc7ccc7cc7cc7ccc7cccc7cccc7cccc7cccc7ccc7cc7c7c77c7cc7cc7ccc7ccc7cccc7ccc7ccc7cc7cc7cc7c7cc
c7cc7cc7cc77c77c7c7c7ccc7ccc7cccc7ccc7cc7ccc7cc7cc7ccc7cccc7cccc7cccc7cccc7ccc7cc7c7c77c7cc7cc7ccc7ccc7ccc7ccc7cccc7cc7cc7cc7c7c
cc7cc7cc7cc77c777c7cc7ccc7ccc7ccc7cccc7cc7ccc7cc7cc7ccc7cccc7cccc7cccc77ccc7ccc7cc7c7c77c7cc7cc7cc7cccc7ccc7ccc7cccc7cc7cc7cc7c7
7cc7cc7cc7cc77c777c7cc7ccc7ccc7ccc7cccc7cc7ccc7cc7cc77cc7cccc7cccc7ccccc7ccc7ccc7c7cc7c77c7cc7cc7cc7cccc7ccc7ccc7cccc7cc7cc7cc7c
c7cc7cc7cc7cc77c777c7cc7ccc7ccc7ccc7cccc7cc7ccc7cc7ccc7cc7cccc7cccc7ccccc7ccc7ccc7c7cc777c7cc7cc7ccc7ccc7cccc7ccc7ccc7ccc7cc7cc7
cc7cc7cc7cc7cc77c7c7c7cc7ccc7ccc7ccc7cccc7cc7ccc7cc7ccc7cc7cccc77ccc7ccccc7ccc7ccc7c7cc777c7cc7cc7cc7cccc7ccc7ccc7cccc7ccc7cc7cc
7cc7cc7cc7cc7cc77c7c7c7cc7cc7ccc7cccc7ccc7ccc7ccc7cc7ccc7cc7ccccc7ccc7ccccc7ccc7ccc7c7cc777c7cc7cc7cc7cccc7ccc7ccc7cccc7cc7ccc7c
c7cc7cc7cc7cc7cc77c7c77cc7ccc7ccc7cccc7ccc7ccc7ccc7cc7ccc7cc7ccccc7ccc77cccc7ccc7ccc7c7cc777c7c7cc7ccc7ccc7cccc7ccc7cccc7cc7cc7c
7c7cc7cc7cc7cc7cc77c7c77cc7ccc7ccc7ccc7cccc7ccc7ccc7cc7ccc7cc77cccc7cccc7cccc7ccc77cc7c7c7c777cc7cc7cc7cccc7ccc7cccc7cccc7cc7cc7
c7c7cc7cc7cc7cc7cc77777c7cc7ccc7ccc7ccc7cccc7ccc7ccc7cc7ccc7ccc7cccc7cccc7cccc7cccc7cc7c7c7c7c7cc7cc7cc7cccc7ccc7ccc7cccc7ccc7cc
c7cc7cc7cc7cc7cc7cc77777c7cc7ccc7ccc7ccc7cccc7ccc7ccc7cc7ccc7ccc7cccc7cccc7cccc7cccc7cc7c7c777c7cc7cc7cc7cccc7ccc7ccc7cccc7ccc7c
cc7cc7cc7cc7cc7cc7cc77777c7cc7cc7cccc7ccc7cccc7cc7cccc7cc7ccc7ccc7cccc7cccc7cccc7cccc7cc7c7c777c7c7cc7ccc7ccc7cccc7ccc7cccc7ccc7
7cc7cc7cc7cc7cc7cc7cc77777c7c7ccc7ccc7cccc7cccc7cc7cccc7cc7ccc7ccc7cccc7cccc7cccc7cccc7cc7c7c777c7c7cc7cc7cccc7ccc7cccc7cccc7ccc
c7cc7cc7cc7cc7cc7cc7cc777777cc7ccc7ccc7cccc7cccc7cc7cccc7cc7ccc7ccc7cccc7cccc7cccc7cccc7cc7c7c77c7cc7cc7cc7cccc7ccc7cccc7cccc7cc
cc7cc7cc7cc7cc7cc77c77c777777cc7ccc7ccc7cccc7ccc7ccc7cccc7cc7ccc7ccc7cccc77ccc7cccc7cccc7cc7c7c77c7cc7c7ccc7ccc7cccc7ccc7cccc7cc
cc7ccc7cc7cc7cc7ccc7cc7c7777c7cc7ccc7ccc7ccc7cccc7ccc7ccc7ccc7ccc77cc7ccccc7ccc7cccc7cccc7cc77cc77c7c7cc7cc7cccc7cccc7ccc7cccc7c
ccc7ccc7cc7cc7cc7ccc7cc7c7777c7cc7ccc7ccc7ccc7cccc7ccc7ccc7ccc7cccc7cc7ccccc7ccc7cccc7cccc7cc77c777c7c7cc7cc7cccc7ccc7cccc7cccc7
cccc7ccc7cc7cc7cc7ccc7cc7c7777c7c7ccc7ccc7cccc7cccc7ccc7ccc7ccc7cccc7cc7ccccc7ccc7cccc7cccc7cc77c7777cc7cc7cc7cccc7ccc7cccc7cccc
7cccc7ccc7cc7cc7cc7ccc7cc7c7777c7c7ccc7ccc7cccc7cccc7ccc7ccc7ccc7cccc7cc77cccc7ccc77ccc77ccc7cc77c77c7cc7c7ccc7ccc7cccc7ccc7cccc
c7cccc7cc7ccc7cc7cc7ccc7cc7c77777cc7ccc7ccc7cccc7cccc7ccc7ccc7ccc7cccc7ccc7cccc7cccc7cccc7ccc7cc77c77c7c7cc7cc7cccc7cccc7ccc7ccc
cc7cccc7cc7ccc7cc7cc7ccc7cc7c77777cc7ccc7ccc7cccc7cccc7ccc7ccc7ccc7cccc7ccc7cccc7cccc7cccc7ccc7cc77c77c7c7cc7cc7cccc7ccc7cccc7cc
ccc7ccc7ccc7ccc7cc7cc7ccc7cc7c77777cc7ccc7ccc7cccc7cccc7ccc7ccc7ccc7cccc7ccc7cccc7cccc7cccc7ccc7cc77c777cc7c7ccc7ccc7cccc7cccc7c
ccc7cccc7ccc7ccc7cc7cc7ccc7cc7c77777cc7cc7cccc7ccc7ccccc7ccc7ccc7ccc77ccc7ccc7cccc7cccc7cccc7ccc7cc77c777c7cc7cc7cccc7cccc7ccc7c
cccc7cccc7ccc7ccc7cc7cc7ccc7cc7c77777c7ccc7ccc7cccc7cccc7cccc7ccc7cccc7ccc7ccc7cccc77ccc7cccc7ccc7cc77c7c7c7cc7cc7cccc7ccc7cccc7
ccccc7cccc7ccc7ccc7cc7cc77cc7cc7c77777c7ccc7ccc7cccc7cccc7cccc7ccc7cccc7ccc7ccc7ccccc7ccc7cccc7ccc7c7c777c7c7cc7cc7cccc7ccc7cccc
7ccccc7cccc7ccc7ccc7cc7ccc7cc7cc7c7777cc7ccc7ccc7cccc7cccc7cccc7ccc7cccc7ccc7ccc7ccccc7ccc7cccc7ccc7c7c7777cc7c7ccc7ccc7cccc7ccc
c7ccccc7cccc7ccc7ccc7cc7ccc7cc7cc7c7777cc7ccc7ccc7cccc7cccc7cccc7ccc7cccc7ccc7ccc7ccccc7ccc7cccc7ccc7c7c7777c7cc7cc7cccc7cccc7cc
cc7cccc7cccc7cccc7ccc7cc7ccc7cc7cc7c7777cc7ccc7ccc7cccc7cccc7cccc7ccc7cccc7ccc7ccc77cccc7ccc7cccc7ccc7c7c7777c7cc7cc7cccc7ccc7cc
cc7ccccc7cccc7cccc7cc7ccc7ccc7cc7cc7c7777c7ccc7cccc7cccc7cccc7ccc7cccc7cccc7ccc77ccc7cccc7ccc77ccc7ccc7c77c7c7c7c7ccc7ccc7cccc7c
ccc7ccccc7cccc7ccc7ccc7ccc7ccc7cc7cc7c7777c7ccc7ccc7cccc7ccccc7ccc7cccc7cccc7cccc7ccc7cccc7cccc7ccc7ccc7c77c77cc7c7cc7cccc7cccc7
cccc7ccccc7cccc7ccc7ccc7ccc7ccc7cc7cc7c777cc7ccc7ccc7cccc7ccccc7ccc7cccc7cccc7cccc7ccc7cccc7cccc7ccc7ccc7c77c77c7cc7cc7cccc7cccc
7cccc7ccccc7cccc7ccc7ccc7ccc7ccc7cc7cc7c777cc7ccc7ccc7cccc7ccccc7ccc7cccc7cccc7cccc7ccc7cccc7cccc7ccc7ccc7c77c77c7cc7cc7cccc7ccc
c7ccc7ccccc7ccccc7ccc7ccc7ccc7ccc7cc7cc7c777cc7ccc7ccc7cccc7cccc7cccc7cccc7cccc7cccc7ccc7cccc77ccc7ccc7ccc7c77777c7c7ccc7ccc7ccc
c7cccc7ccccc7ccccc7ccc7ccc7ccc7ccc7cc7cc7c777cc7cc7cccc7cccc7cccc7cccc7cccc7cccc7cccc7ccc7ccccc7ccc7ccc7ccc7c77777c7c7cc7cccc7cc
cc7cccc7ccccc7cccc7cccc7ccc7ccc7ccc7cc7cc7c777c7ccc7cccc7cccc7cccc7cccc7cccc7cccc7cccc7ccc7ccccc7ccc7ccc77cc7c7777c7cc7cc7cccc7c
ccc7cccc7ccccc7cccc7cccc7ccc7ccc7ccc7cc7cc77777c7ccc7ccc7ccccc7cccc7cccc7cccc7cccc7cccc7ccc7ccccc7ccc7cccc7cc7c7777c7c7ccc7ccc7c
ccc7cccc7ccccc7ccccc7cccc7ccc7ccc7ccc7cc7cc77777c7ccc7ccc7cccc7ccccc7cccc7cccc7cccc7cccc7ccc7ccccc7ccc7cccc7cc7c7777c7c7cc7cccc7
cccc7cccc7ccccc7ccccc7cccc7ccc7ccc7ccc7cc7cc77777c7ccc7ccc7cccc7ccccc7cccc7cccc7cccc7cccc7ccc77cccc7ccc7cccc7cc7c7777c7c7cc7cccc
7cccc7cccc7ccccc7ccccc7ccc7cccc7ccc7ccc7cc7cc77777c7ccc7ccc7cccc7ccccc7cccc7cccc7cccc7cccc7cccc7cccc7ccc7cccc7cc7c777c7cc7cc7ccc
7ccccc7cccc7ccccc7ccccc7ccc7cccc7ccc7ccc7cc7cc777777ccc7cccc7cccc7ccccc7cccc7cccc7cccc7cccc7cccc7cccc7ccc77ccc7cc7c777c7c7ccc7cc
c7cccc7ccccc7ccccc7cccc7cccc7cccc7ccc7ccc7cc77c777777ccc7cccc7cccc7ccccc7cccc7cccc7cccc7cccc77ccc7cccc7cccc7ccc7cc7c777c7c7cc7cc
cc7cccc7cccc7ccccc7ccccc7cccc7cccc7ccc7ccc7ccc7cc77777ccc7ccc7ccccc7cccc7ccccc7cccc7cccc7ccccc7ccc7cccc77ccc7ccc7cc7c7777cc7cc7c
ccc7cccc7cccc7ccccc7ccccc7cccc7cccc7ccc7ccc7ccc7cc77777ccc7ccc7ccccc7cccc7ccccc7cccc7cccc7ccccc7ccc7ccccc7ccc7ccc7cc7c77c7cc7cc7

__map__
010102030405060708090a0b0c0d0e0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000