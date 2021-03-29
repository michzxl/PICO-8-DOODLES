ROLL = {
	time = 0,
	localtime = 0,

	stage = 1,
	stages = {}
}

function ROLL:init()
	ROLL.stages = {
		{
			time = frames(4),
			events = {
				{
					go = function()
						clip(0,0,hd-8,vd-8)
						for i=1,300 do
							local x,y = rnd(hd-8),rnd(vd-8)
							local c = x/16 + y/16 + t
								+ 0.5*sin(sin(x/128 - y/128)+x/16+sin(t/8))
							+ 0
							circ(x,y,1,c)
						end
						clip()
					end,
				},{
					go = function()
						clip(0,vd,hd-1,128)
						for i=1,150 do
							local x,y = rnd(hd-1),rnd(128-vd)+vd
							local c = -x/16 + y/16 + t
								+ sin(x/64)/sin((y+20)/100)
								+ 2*sin(t/16)*abs(flr(sin(x/32)))
								+ flr(x/64 - t/8) + flr(y/64 - t/4)
							circ(x,y,1,c)
						end
						clip()
					end,
				},{
					go = function()
						clip(hd,0,128,128)

						for i=1,500 do
							local x,y = rnd(128-hd)+hd,rnd(128)
							local c = (x*2+t*4)/(y+16)+t/4
								+ 0.5*flr(y/16)
								- x\32
								+ (sin(t/4)*0.5+0.5)*flr(sin(x/32) + cos(y/32))
								+ 2*flr(x/64 - t/8) + flr(y/64 - t/4)
							local fill = 0
							if c-flr(c)<0.25 then
								fill = 0b1111000011110000.1
							end
							fillp(fill)
							circ(x,y,1,c)
							fillp()
						end

						clip()
					end,
				}
			}
		},
	}
end

function ROLL:upd()
	printh(ROLL.stage)
	printh(#ROLL.stages)
	local stage = ROLL.stages[ROLL.stage]

	if ROLL.localtime >= stage.time then
		ROLL.stage = ROLL.stage%#ROLL.stages + 1
		ROLL.localtime -= stage.time
		stage = ROLL.stages[ROLL.stage]
	end

	for evt in all(stage.events) do
		if (not evt.when) or evt.when(self) then
			evt.go(self)
		end
	end

	ROLL.time += 1
	ROLL.localtime += 1
end

ROLL.when = {
	frame = function(t)
		return function(roll)
			return roll.localtime == t
		end
	end,

	-- inclusive, exclusive
	interval = function(a,b)
		return function(roll)
			return a <= roll.localtime and roll.localtime < b
		end
	end,

	-- exclusive
	before = function(t)
		return function(roll)
			return roll.localtime < t
		end
	end,

	-- inclusive
	after = function(t)
		return function(roll)
			return roll.localtime >= t
		end
	end,
}

function ROLL:update()
	ROLL.time += dt
	ROLL.localtime += dt

	-- FINISH THIS
end

function frames(sec)
	return 30 * sec
end
