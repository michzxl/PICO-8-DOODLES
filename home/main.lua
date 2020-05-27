function _init()
    t = 0
    ti = 0
    dt = 1 / 30

    spl = 1000 / (128 * 128)

    q = {}
    fs = {
        funcs.circle_o,
        funcs.stripes,
        funcs.rain,
        funcs.checkers,
        funcs.fill,
        funcs.circuit,
        funcs.wave,
        funcs.circle_o,
        funcs.noise,
        funcs.spr_o
    }
    ws = gen_widths(#fs)
    runs = 0

    cls()
end

function _update()
    progstage = prog[stage]
    if not progstage.runs then progstage.runs=0 end

    t = t + dt
    ti = ti + 1
    if ti >= progstage.loop then
        progstage.runs = progstage.runs + 1
        runs = runs + 1
    end
    ti = ti % progstage.loop

    if progstage.time_2_exit() then
        progstage.runs=0
        if progstage.leave then 
            progstage.leave()
        else
            stage = stage + 1
        end
        if stage>#prog then stage=1 end
        ti = 0
        prog[stage].runs = 0
        runs = 0
    end

    draw_home()

    events = progstage.events
    for event in all(events) do
        if event.trigger() then
            event.go()
        end
    end


    if debug then
        sprint(stat(1),0,0,10)
        sprint(stat(0),0,6,10)
        sprint(stage,0,12,10)
        sprint(t,0,18,10)
    end
end

function sprint(str, x, y, col)
    str = tostr(str)
    w = #str * 4 + 1
    h = 5
    rectfill(x, y - 1, x + w - 1, y + h, 0)
    print(str, x, y, col)
end
