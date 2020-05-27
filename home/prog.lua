stage=1
prog={
    { -- do nothing for a bit ->
        loop=frames(5),
        runs=0,

        time_2_exit=function() return prog[stage].runs>0 end,

        events={}
    },{ -- start glitching ->
        loop=frames(2),
        runs=0,

        time_2_exit=function() return prog[stage].runs>0 end,

        events={
            {   
                trigger=function() return ti==4 end,
                go=function() 
                    shuffle(fs) 
                    streaks()
                end
            },{
                trigger=function() return 2<ti and ti<10 end,
                go=function()
                    for i=1,100 do
                        x=rnd(128)
                        y=128-rnd(-x+64)
                        rect(x,y,x+4,y+4,7)
                    end
                end
            },{
                trigger=function() return ti==10 end,
                go=function()
                    shuffle(fs)
                    ws=gen_widths(#fs)
                end
            },{
                trigger=function() return 20<ti and ti<60 end,
                go=function()
                    local a=ti-21
                    y=128-a*4
                    line(0,y,128,y,7)
                end
            },{
                trigger=function() return ti==40 end,
                go=function()
                    cls()
                    shuffle(fs)
                end
            },
        }
    },{ -- arrow ->
        loop=frames(3.5),
        runs=0,

        time_2_exit=function() return prog[stage].runs>=3 end,

        events={
            {
                trigger=function() return ti==0 end,
                go=function() cls() shuffle(fs) ws=gen_widths(#fs) end
            },{
                trigger=function() return ti>frames(2) end,
                go=function()
                    for i=1,500 do
                        x,y=rnd(128),rnd(128)
                        c=abs(x-64)/64+y/64+t
                        c=flr(c%2)*7
                        if c~=0 then
                            circ(x,y,1,c)
                        end
                    end
                end
            }
        }
    },{ -- blend 
        loop=frames(5),
        runs=0,

        time_2_exit=function()
            return prog[stage].runs>=2
        end,
        events={
            {   
                trigger=function() return ti==0 end,
                go=function() 
                    shuffle(fs) 
                    streaks()
                end
            },{
                trigger=function() return 5<ti and ti<13 end,
                go=function()
                    for i=1,500 do
                        x=rnd(128)
                        y=128-rnd(-x+64)
                        rect(x,y,x+4,y+4,7)
                    end
                end
            },{
                trigger=function() return ti==6 end,
                go=function()
                    draw_some_rects(128,16,3,7)
                    draw_some_rects(128,16,3,0)
                end   
            },{
                trigger=function() return ti==9 end,
                go=function()
                    fillp(0b1010010110100101)
                    draw_some_rects(128,16,3,7)
                    fillp()
                end
            },{
                trigger=function() return ti==10 end,
                go=function()
                    shuffle(fs)
                    ws=gen_widths(#fs)
                end
            },{
                trigger=function() return 15<ti and ti<150 end,
                go=function()
                    sludge()
                end
            },{
                trigger=function() return ti==30 end,
                go=function()
                    cls()
                    shuffle(fs)
                    ws=gen_widths(#fs)
                end
            },{
                trigger=function() return ti==40 end,
                go=function()
                    cls()
                    shuffle(fs)
                end
            },{
                trigger=function() return ti==65 end,
                go=function()
                    cls()
                    shuffle(fs)
                end
            },{
                trigger=function() return ti==65 end,
                go=function()
                    cls()
                    shuffle(fs)
                end
            },{
                trigger=function() return ti==145 end,
                go=function()
                    cls()
                    shuffle(fs)
                    ws=gen_widths(#fs)
                end
            },{
                trigger=function() return 140<ti and ti<145 end,
                go=function()
                    fillp(0b1010010110100101.1)
                    rectfill(0,0,128,128,7)
                    fillp()
                end
            }
        }
    },{ -- squares
        loop=frames(1),
        runs=0,

        time_2_exit=function() return prog[stage].runs>=4 end,

        events={
            {
                trigger=function() return true end,
                go=function()
                    local a = ti*4
                    local r = prog[stage].runs
                    for i=1,1+r^3 do
                        local y0=128-4*i
                        rectfill(a,y0,a+2,y0+2,7)
                    end
                end
            },
            {
                trigger=function() return ti==frames(1)-1 end,
                go=function()
                    --cls()
                    --shuffle(fs)
                    --ws=gen_widths(#fs)
                end
            }
        }
    },{ -- swirl
        loop=frames(2.5),
        runs=0,
        time_2_exit=function() return runs>=3 end,

        events={
            {
                trigger=function() return ti==1 end,
                go=function()
                    shuffle(fs)
                    rectfill(0,16,128-16,128-16,0)
                end
            },{
                trigger=function() return ti>30 end,
                go=function()
                    local r = runs
                    if r%2~=0 then
                        for i=1,500 do
                            local ang,r=rnd(1),rnd(64)
                            local x,y=64+r*cos(ang),64+r*sin(ang)
                            ang,r=ang+0.01,r-2
                            local nx,ny=64+r*cos(ang),64+r*sin(ang)
                            local p=pget(x,y)
                            circ(nx,ny,1,p)
                        end
                    end
                end
            }
        }
    },{ -- AGAIN. HOME.
        loop=frames(1.5),
        runs=0,
        time_2_exit=function() return runs>2 end,
        leave=function()
            stage = stage + 1
            cls()
        end,

        events={
            {
                trigger=function() return true end,
                go=function()
                    if ti%2==1 then return end
                    local y=ti*6%128
                    local x=0
                    while x<128 do
                        if ti/2%2==0 then
                            print("AGAIN.",x,y,7)
                        else
                            print(". HOME",x,y,7)
                        end
                        x=x+5*5
                    end
                end
            },
            {
                trigger=function() return ti==20 end,
                go=function()
                    cls()
                    shuffle(fs)
                    ws=gen_widths(#fs)
                end
            }
        }
    }
}
