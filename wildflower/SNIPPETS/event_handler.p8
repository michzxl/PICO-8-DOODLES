function pubsub() 
 local all = {}
 return {
 	on = function(t, h)
 	 if (nil == all[t]) all[t] = {}
 		add(all[t], h)
 	end,
 	off = function(t, h)
 	 del(all[t], h)
 	end,
 	emit = function(t, e)
 		foreach(
 			all[t], 
 			function(h)
 			 h(e)
 			end
 		)
 	end
 }
end