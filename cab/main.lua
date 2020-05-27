actors = {}

function _init()
  cls()
  pl = init_player(64, 96)
end

function _update60()
  for actor in all(actors) do
    local cor = actor.cor
    if costatus(cor) then 
      coresume(cor) 
    else 
      actor.cor = nil 
    end
  end
end

function _draw()
  cls()

  draw_player()
  
  --ground
  for x=0,127 do
    rectfill(x,96,x,128,x%7+7)
  end
end