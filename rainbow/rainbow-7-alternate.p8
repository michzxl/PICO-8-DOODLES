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
hx=1.5
hy=1.5

cls()
::♥::
t+=dt tf+=1

local st256 = sin(t/256)
local st16 = sin(t/16)

local r=40
for i=1,r do
    ox=rnd(128+bk)-8
	oy=rnd(128+bk)-8
    for y=oy,oy+bk-1,hy do
        for x=ox,ox+bk-1,hx do
            local c = sin((x+st256*256)/sin((y+32)/500)/64)
             +(y/(64+16*st16))
             +t
            c = c%8+8
            diff = c-flr(c)
            if diff<0.33 then
                c+=8
            end
            circ(x,y,1,c)
        end
    end
end

flip() goto ♥
