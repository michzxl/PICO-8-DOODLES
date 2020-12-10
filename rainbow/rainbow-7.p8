pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

for i=0,7 do
    pal(i,i+8+128,1)
end

-->8
dt=1/30
t=0
tf=0

bk=8
hx=1
hy=1

cls()
::♥::
t+=dt tf+=1

local r=30+sin(t/16)*12
for i=1,r do
    ox=rnd(128+bk)-8
	oy=rnd(128+bk)-8
    for y=oy,oy+bk-1,hy do
        for x=ox,ox+bk-1,hx do
            local c = sin((x+sin(t/256)*128)/sin((y+16)/350)/64)
             +(y/(64+16*sin(t/16)))
             +t
            c = c%8+8
            diff = c-flr(c)
            if rnd(1)<diff*3-1 then
                c+=8
            end
            circ(x,y,1,c)
        end
    end
end

flip() goto ♥
