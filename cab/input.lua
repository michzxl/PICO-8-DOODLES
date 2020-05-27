function input()
  local o = {
    walk=nil --direction of movement indicated by d-pad. nil if no input.
  }
  
  o.walk = process_input_walk()
  o.crouch = process_input_crouch()
  
  return o
end

function process_input_walk()
	local R=btn(d.right)
	local L=btn(d.left)
	
	if (L and R) or not (L or R) then return nil
	elseif L then return d.left
	else return d.right end
end

function process_input_crouch()
	return btn(d.down)
end