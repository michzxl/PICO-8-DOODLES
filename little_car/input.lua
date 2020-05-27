function input_turn()
    if btn(0) then
        ang=ang-0.01
    end
    if btn(1) then
        ang=ang+0.01
    end
end	

function input_forward()
    if btn(2) then
  		x=x+spd*cos(nang)
  		y=y-spd*sin(nang)
 	elseif btn(3) then
  		x=x-spd*cos(nang)
  		y=y+spd*sin(nang)
 	end
end