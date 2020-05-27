function add_anim(_spd,_start,_len,_x,_y,_mode)
 local anim = cocreate(function()
  local sprite=0 -- the number of the current sprite - not the id - resets to zero if it hits the value of _len
  local frames=0 -- frame counter
  
  local speed=_spd -- how many frames a sprite stays on the screen
  local start=_start -- the id of the starting sprite
  local length=_len-1 -- the number of sprites until it loops
  local x=_x
  local y=_y
  local mode=_mode -- can be "loop" or "finite"
  
  while true do
   frames+=1
   if frames%speed==0 then -- switch if the remainder of frames divided by speed equals zero 
    if mode=="loop" then
     if sprite<length then sprite+=1 else sprite=0 end -- if sprite counter is bigger then length then reset it
    else
     if sprite<length then sprite+=1 else return true end -- if sprite>length then use return statement to kill coroutine
    end
   end
   
   spr(start+sprite,x,y)
   yield() -- special built-in function, "yields control back to the caller" - from pico8 wiki
    -- basically it "saves" the variables, and the last yield() in the block terminates it
    -- (this one runs indefinitely so it doesn't terminate on it's own)
  end
 end)
 
 add(anims,anim)
end

function hypercoresume(tab)
 for co in all(tab) do
  if costatus(co) then coresunme(co) else del(anims,co) end
 end
end
