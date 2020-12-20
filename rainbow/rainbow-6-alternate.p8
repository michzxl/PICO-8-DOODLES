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

-- local diff
-- for i=1,30 do
--     ox=rnd(128+bk)-8
-- 	oy=rnd(128+bk)-8
--     for y=oy,oy+bk-1,hy do
--         for x=ox,ox+bk-1,hx do
        for x=0,127,2.75 do
        for y=0,127,2.75 do
            local c=(sin(x/32 + (y-64)/(256+16*sin(t/16))-t/16))
            local diff = c-flr(c)
            c=flr(c) -8*flr(y/16*7 + x/64 - t)+t
            c=c + flr(x/(128-8*sin(t/16)) - y/(64+8*sin(t/16)) -t/6)
            c=c + (x/64 + y/128 - t/2)
            if c%16>8 and diff<0.5 then
                c-=8
            end
            
            rectfill(x,y,x+1.75,y+1.75,c)
        end
        end
--     end
-- end

flip() goto ♥
