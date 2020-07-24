pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

-->8
dt=1/30
t=0
tf=0

cls()
::♥::
t+=dt tf+=1

bk=8
hx=1.8
hy=1
for i=1,100 do
    ox=rnd(128+bk)-8
    oy=rnd(128+bk)-8
    for y=oy,oy+bk-1,hy do
        for x=ox,ox+bk-1,hx do
            c=5/4*flr(x/16+y/16+t)
            c=c + flr(x/64+y/86+t/2)
            c=flr(c%2)*7
            pset(x,y,c)
        end
    end
end

flip() goto ♥
