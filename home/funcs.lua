funcs={}

function funcs.circle_o(y0,w)
    w=16
    for i=1,spl*w*4 do
        ang,r=rnd(1),rnd(6)
        x,y=7+r*cos(ang),7+r*sin(ang)
        c=rnd(1)<0.9 and 7 or 0
        circ(x+17,y+1+y0,1,c)
    end
    return w
end

function funcs.stripes(y0,w)
    for i=1,spl*w*16 do
        x,y=rnd(w-2),rnd(10)
        c=x/16+(y-t*5)/(8)
        c=flr(c%2)*7
        circ(x+17,y+3+y0,1,c)
    end
end

function funcs.rain(y0,w)
    for i=1,spl*w*16*3 do
        x,y=rnd(w),rnd(11)
        p=pget(x-1+17,y+2+y0)

        if p~=0 or rnd(1)<0.02 then
            pset(x+16,y+3+y0,7)
        end

        if rnd(1)<0.025 then
            line(x+16,y0+3,x+17,y0+3+16,0)
        end
    end
end

function funcs.checkers(y0,w)
    for i=1,spl*w*16 do
        x,y=rnd(w-2),rnd(10)
        c=flr(x/10)+flr(y/16+t+sin(t/16))
        c=flr(c%2)*7
        c=c+(x/64+y/64+t/2)
        c=flr(c%2)*7
        circ(x+17,y+3+y0,1,c)
    end
end

function funcs.fill(y0,w)
    if not q.fill then q.fill = 32000 end
    clip(16,y0+2,w,12)
    rectfill(0,0,128,128,0)
    if ti%flr(20+rnd(8)-4)==0 then
        q.fill = q.fill + 2^rnd(8)
    end
    fillp(q.fill)
    rectfill(0,0,128,128,7)
    fillp()
    clip()
end

function funcs.circuit(y0,w)
    if rnd(1)<0.05 then
        rectfill(16,y0,16+w-1,y0+16,0)
    end
    if not q.p then
        q.p={}
        for i=1,8*(w/16) do
            add(q.p,{x=rnd(w-1),y=rnd(11)})
        end
    else
        for p in all(q.p) do
            p.x=mid(0,w-1,p.x+2*(flr(rnd(3))-1))
            p.y=mid(0,11,p.y+2*(flr(rnd(3))-1))

            p.x=mid(0,p.x,w)
            p.y=mid(0,p.y,16)
        end
    end
    
    for p in all(q.p) do
        pset(p.x+16,p.y+2+y0,7)
    end
end

function funcs.wave(y0,w)
    for i=1,spl*w*16 do
        x,y=rnd(w-2),rnd(10)
        c=y < sin(x/16-t)*3+6 and 0 or 7
        circ(x+17,y+3+y0,1,c)
    end
end

function funcs.noise(y0,w)
    for i=1,spl*w*4 do
        x,y=rnd(w-2),rnd(10)
        c=rnd(1)<0.5 and 7 or 0
        circ(x+17,y+3+y0,1,c)
    end
end

function funcs.spr_o(y0,w)
    spr(3,16,y0,2,2)
end