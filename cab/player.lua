function update_player(pl)
  local input = input()

  --cache up some stuff
  local anim = pl.anim[pl.state][pl.anim_timer]
  local walk_input_exists = input.walk ~= nil
  
  if pl.state == "still" then
    if walk_input_exists then start_moving(pl, input.walk) 
    elseif input.crouch then start_crouching(pl) end
  elseif pl.state == "moving" then
    --move player
    if     pl.facing == d.left  then pl.x = pl.x - anim.mov
    elseif pl.facing == d.right then pl.x = pl.x + anim.mov end
    
    if walk_input_exists then 
      if input.walk == pl.facing then --same direction
        keep_moving(pl, 1, 9)
      elseif good_turning_frame(pl) then
        change_direction(pl, input.walk)
      else
        keep_moving(pl, 1, 9)
      end

    else --if no walk input
      if good_stopping_frame(pl) then
        stop_moving(pl)
      else
        keep_moving(pl, 1, 9)
      end
    end
  elseif pl.state == "crouch" then
    if input.crouch then
      if pl.anim_timer < 3 then
        pl.anim_timer = pl.anim_timer + 1
      end
    else
      if pl.anim_timer > 1 then
        pl.anim_timer = pl.anim_timer - 1
      else
        stop_moving(pl)
      end
    end
  end
end

function draw_player()
  local t = anims.player[pl.state][pl.anim_timer]
  sspr(t.sx, t.sy, t.sw, t.sh, pl.x - t.ofs, pl.y - 19, t.sw, t.sh, pl.facing ~= d.right)
end

function good_stopping_frame(actor)
  local tmp = actor.anim[actor.state][actor.anim_timer].stop
  return tmp ~= nil and tmp
end

function good_turning_frame(actor)
  local tmp = actor.anim[actor.state][actor.anim_timer].turn
  return tmp ~= nil and tmp
end

function change_direction(actor, dir)
  actor.facing = dir
end

function start_moving(actor, dir)
  actor.state = "moving"
  actor.facing = dir
  actor.anim_timer = 1
end

function stop_moving(actor)
  actor.state = "still"
  actor.anim_timer = 1
end

function keep_moving(actor, start_timer, end_timer)
  local tmp = actor.anim_timer
  tmp = tmp + 1
  if tmp == end_timer then tmp = start_timer end
  actor.anim_timer = tmp
end

function start_crouching(actor)
  actor.state = "crouch"
  actor.anim_timer = 1
end

function player_still(pl)
  local input = input()

  --cache up some stuff
  local anim = pl.anim[pl.state][pl.anim_timer]
  local walk_input_exists = input.walk ~= nil

  if walk_input_exists then start_moving(pl, input.walk) 
  elseif input.crouch then start_crouching(pl) end
end

function player_moving(pl)
  local input = input()

  --cache up some stuff
  local anim = pl.anim[pl.state][pl.anim_timer]
  local walk_input_exists = input.walk ~= nil

  --move player
    if     pl.facing == d.left  then pl.x = pl.x - anim.mov
    elseif pl.facing == d.right then pl.x = pl.x + anim.mov end
    
    if walk_input_exists then 
      if input.walk == pl.facing then --same direction
        keep_moving(pl, 1, 9)
      elseif good_turning_frame(pl) then
        change_direction(pl, input.walk)
      else
        keep_moving(pl, 1, 9)
      end

    else --if no walk input
      if good_stopping_frame(pl) then
        stop_moving(pl)
      else
        keep_moving(pl, 1, 9)
      end
    end
end

function player_crouch(pl)
  local input = input()

  --cache up some stuff
  local anim = pl.anim[pl.state][pl.anim_timer]
  local walk_input_exists = input.walk ~= nil

  if input.crouch then
      if pl.anim_timer < 3 then
        pl.anim_timer = pl.anim_timer + 1
      end
  else
    if pl.anim_timer > 1 then
      pl.anim_timer = pl.anim_timer - 1
    else
      stop_moving(pl)
    end
  end
end
