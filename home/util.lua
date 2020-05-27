function shuffle(tbl)
	for i = #tbl, 2, -1 do
		local j = flr(rnd(i))+1
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

function gen_widths(num)
	min=16
	max=75
	tab={}
	for i=1,num do
		add(tab, rnd(max-min) + min)
	end
	return tab
end

function frames(secs)
	return secs * 30
end