function draw_home()
    for idx,f in pairs(fs) do
		y0=(idx-1)*16
        w=ws[idx]
        
		spr(1,0,y0,2,2)
        aw=f(y0,w)

		spr(5,16+(aw or w),y0,4,2)
	end
end

-- /!\  \/ helper funcs \/  /!\

function streaks()
    for i=1,100 do
        x,y=rnd(128),rnd(128)
        c=x/32+y/32+t --stripes
        c=flr(c%2)*7 --black/white
        line(x+30,y-30,x-30,y+30,c)
    end
end

function draw_some_rects(w,h,num,col)
    for i=1,num do
        x,y=rnd(128),rnd(128)
        rectfill(x,y,x+w,y+h,col)
    end
end

function sludge()
    for i=1,800 do
        x,y=rnd(128),rnd(128)
        c=pget(x,y)
        x+=cos(atan2(y-64,x-64))
        y+=sin(atan2(y-64,x-64))
        circ(x,y,1,c)
    end
end

function reset_stage()
    stage=1
    cls()
    shuffle(fs)
    ws=gen_widths(#fs)
end