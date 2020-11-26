pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

pal(7,7,1)
pal(1,1+128,1)
pal(8,12+128,1)
pal(9,14+128,1)

--drawing function
function dr(x,y,p)
	circfill(x,y,1,p)
end

--init screen space
rectfill(0,0,128,128,1)
for i=1,4000 do
	--navy & white
	circfill(rnd(128),rnd(128),1,rnd(1)<0.5 and 1 or 7)
end
for i=1,1000 do
	--full palette
	circfill(rnd(128),rnd(128),1,rnd(2)+8)
end

tf=0
t=0
dt=1/60

::OKAY::
t+=dt
tf+=1

for i=1,1500 do
	x,y = rnd(128), rnd(128)

	if btn(4) then
		dr(x,y,1)
	elseif btn(5) then
		dr(x,y,7)
	else
		--edges may create navy/white
		if (flr(x<=1 or flr(y)>=126) and rnd(1)<0.01) then
			local c = rnd(1)<0.5 and 1 or 7
			pset(x,y,c)
		end

		--if nearby pixels are same,
		--maybe change color.
		--will break down large areas
		local p=pget(x,y)
		if pget(x+1,y)==p
					and pget(x,y-1)==p
					and rnd(1)<0.03 then
			local c = rnd(2) + 8
			dr(x,y,c)
		end

		--propel the color.
		if rnd(1)<0.75 then
			dr(x+1,y-1,p)
		else
			dr(x,y,p)
		end
	end
end

flip() goto OKAY
