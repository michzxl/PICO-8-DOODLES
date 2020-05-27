function init_player(x, y)
	return init_actor(x,y,d.left,anims.player,update_player,8,draw_player)
end

function init_actor(x,y,facing,anim,upd,upd_speed,drw)
	local actor = {
		--state
		x=x,
		y=y,
		state="still",
		anim_timer=1,
		facing=facing,

		--settings
		anim=anim,

		--methods
		upd=upd,
		drw=drw,

		--coroutine
		cor=nil
	}

	init_updater(upd,actor,upd_speed)

	add(actors,actor)
	return actor
end

function init_updater(upd, obj, speed)
  local tmp = cocreate(function()
    local func = upd
    local obj = obj
    local speed = speed
    
    while true do
      for i=1,speed-1 do
        yield()
      end
      
      func(obj)
      yield()
    end
  end)
  
  obj.cor = tmp
end