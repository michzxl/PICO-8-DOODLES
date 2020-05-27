flora = {
	arr={},
	stalk = {
		flower_colors = {clr.red, clr.yellow, clr.orange, clr.blue, clr.pink, clr.white}
	}
}

function flora.stalk.new(x, y, seg_min, seg_max, h_min, h_max)
	local stalk = {}
	local h_goal = rand_int(h_min,h_max)
	local h = 0
	local curr_x = x

	local info = {
		type="stalk",
		info=true,
		x=x,
		y=y,
		h=0
	}
	add(stalk,info)

	while h < h_goal do
		local seg = flora.stalk.gen_segment(seg_min,seg_max,x,curr_x)

		h = h + seg.len
		curr_x = seg.x

		add(stalk,seg)
	end
	info.h = h

	local colors = flora.stalk.flower_colors
	local key = rand_int(1,#colors)
	local flower = {
		flower=true,
		clr = colors[key],
		dir = rand_int(d.left,d.right)
	}

	add(stalk,flower)
	flora.stalk.add_leaves(stalk)

	add(flora.arr,stalk)
	return stalk
end

function flora.stalk.gen_segment(min,max,origin_x,curr_x)
	local seg = {
		segment = true,
		len = rand_int(min,max),
		x = curr_x,
		leaf = nil
	}

	if chance(0.5) then 
		seg.x = curr_x+1 
	else 
		seg.x = curr_x-1 
	end

	return seg
end

function flora.stalk.add_leaves(stalk)
	for key,seg in pairs(stalk) do
		if chance(.75) then
			local next_seg = stalk[key+1]
			local prev_seg = stalk[key-1]

			if next_seg and not next_seg.flower then
				if (not prev_seg or not prev_seg.stalk or seg.len>2) then
					seg.leaf = ternary(sgn(seg.x-next_seg.x)==1,d.right,d.left)
				end
			end
		end
	end
end

function flora.stalk.drw(stalk)
	local y = stalk[1].y

	for seg in all(stalk) do
		if flora.stalk.is_segment(seg) then
			line(seg.x, y, seg.x, y-seg.len+1, clr.dark_green)
			y = y - seg.len
		end
	end

	flora.stalk.draw_leaves(stalk)
	flora.stalk.draw_flower(stalk)
end

function flora.stalk.is_segment(seg)
	return not seg.flower and not seg.info
end

function flora.stalk.draw_flower(stalk)
	local y = stalk[1].y + stalk[1].h
	local last_seg = stalk[#stalk-1]
	local flower = stalk[#stalk]
	local dir = flower.dir
	local mod = (dir==1) and 1 or -1 --1 if right. -1 if left.

	--this works. sorry
	rect(last_seg.x, y-mod, last_seg.x+mod, y, flower.clr)
	rect(last_seg.x+mod, y, last_seg.x+(mod*2), y+1, flower.clr)
end

function flora.stalk.draw_leaves(stalk)
	local y = stalk[1].y

	for seg in all(stalk) do
		if flora.stalk.is_segment(seg) then
			local leaf = seg.leaf
			if leaf then
				if leaf == d.right then
					sspr(0,0,3,3,seg.x + 1, y - seg.len - 2,3,3)
				else
					sspr(0,0,3,3,seg.x - 3, y - seg.len - 2,3,3,true)
				end
			end
			y = y - seg.len
		end
	end
end