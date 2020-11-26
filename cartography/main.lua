

mx,my=0,0

cenx=0
ceny=0

world_plt={
    1,
    12+128,
    12,15,
    11+128,
    11+128,
    3,
    5,
    13,
    6,
    7
}

d={
    left=0,l=0,
    right=1,r=1,
    up=2,u=2,
    down=3,d=3,
    z=4,o=4,
    x=5
}

function _init()
    cls()
    palette(world_plt)
    gen_map(cenx,ceny)
end

function _update()
    if btnp(4) or btnp(5) then
        gen_map(cenx,ceny)
    end
end

function gen_map(cenx,ceny)
    os2d_noise(rnd(1))

    for oy=16,111 do
        for ox=8,119 do
            x=cenx+ox-64
            y=ceny+oy-64

            z=os2d_eval(x,y)/16
             +os2d_eval(x/2,y/2)/8
             +os2d_eval(x/4,y/4)/4
             +os2d_eval(x/8,y/8)/2
             +os2d_eval(x/32,y/32)*1.5

            z=(z+1)/2-0.25
            c=mid(0,z*11,10)

            pset(ox,oy,c)
        end
        if flr(oy%2)==0 then
            flip()
        end
    end
end

function palette(plt)
    if plt then
        for i=1,#plt do
            if plt[i]~='' then
                pal(i-1,plt[i],1)
            end
        end
    else
        pal()
    end
end