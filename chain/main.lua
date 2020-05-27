function _init()
    poke(0x5f2d, 1)--enable mouse
    mx,my=0,0
    mv=vec(0,0,0)

    ch=chainp(50,4)
    ch:set_anchor(1,mv)
    ch:set_anchor(#ch,vec(64,64,0))
end

function _update()
    mx,my=stat(32),stat(33)
    mv:set(mx,my,0)
    
    for v in all(ch) do
        if not v.yv then
            v.yv=0
        end
        v.yv=v.yv+0.1
        v.oy=v.y
        v.y+=1
        v.my=v.y
    end
    for i=1,#ch do
        local v = ch[i]
        if ch[i].anchor then
            v:setv(v.anchor)

            for j=i,1+1,-1 do
                local anchor=ch[j]
                local vt=ch[j-1]

                --if not vt.anchor then
                vt:setv(vt:constrain_max(anchor,ch.seg),5)
            end
            for j=i,#ch-1,1 do
                local anchor=ch[j]
                local vt=ch[j+1]

                --if not vt.anchor then
                vt:setv(vt:constrain_max(anchor,ch.seg),5)
            end
        end
        
        --v.yv=v.my-v.oy --+ max(0,0.1*(v.y-v.my))
    end
end

function _draw()
    cls()

    circ(mx,my,dist,5)
    
    for i=1,#ch-1 do
        local v1=ch[i]
        local v2=ch[i+1]
        line(v1.x,v1.y,v2.x,v2.y,7)
    end

    circfill(mx,my,1,10)

    print(stat(1),0,0,10)
    print(stat(0),0,6,12)
end

function sqr(a) return a*a end