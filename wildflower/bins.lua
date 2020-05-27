--[[
bins data structure
see https://en.wikipedia.org/wiki/Bin_(computational_geometry)

allows for efficient region query
each time an item falls into a bin's bounds,
the frequency of that bins is increased by one.

it partitions 2D space into bins, arranged in a 2D array.
candidates for bins contain a 2D array as well.
the size of a candidate's 2D array is the number of bins it intersects.
(e.g. an element that lies in 2 bins wide and 3 bins tall, will have a 3x2 array)

each bin contains the head of a singly linked list.
if a candidate intersects with a bin,
it is chained to the bin's linked list.

each element in a candidate's array is a reference to the
link node in the corresponding bin's linked list.

---
implementation:

elements are added to bins, but not directly.
the element is wrapped in an "item" class,
which contains the element, and a "next". 

when an element is added to a bin, a new item object
is created from that element, so that each item is unique, 
even if in different bins, even if the element they wrap is identical!
this makes each "next" in all items unique, even if the elements they
wrap are identical yet lie in multiple bins.

each value in an element's bins array is
a reference to the corresponding item object
in that bin's linked list. the element's bins array's indexes
are identical to the indexes of the bins it corresponds to,
i.e. not 0,1,2,3 but 0,5,10,15,20 (depending on bin size)

--]]

bins={}
bin_size=10
bounds = {
	flower=flower_bounds,
	grass=flower_bounds
}

function init_bin(x,y)
	if bins[x] == nil then
		bins[x]={}
	end
	
	if bins[x][y] == nil then
		bins[x][y]={elem=nil,next=nil}
	end
end

function make_item(elem, mode, bounds)
	local item = {
		elem = elem,
		next = nil
	}
	return item
end

function init_elem_bin(elem,x,y)
	if elem.bins[x] == nil then
		elem.bins[x]={}
	end
	
	if elem.bins[x][y] == nil then
		elem.bins[x][y]={elem=nil,next=nil}
	end
end

function put_in_bins(elem)
	--get bounds of element
	local bounds = elem.bounds(elem)
	
	--loop through all bins the element intersects with.
	for x=bins_index(bounds.x1),bins_index(bounds.x2) do
		for y=bins_index(bounds.x1),bins_index(bounds.x2) do
			
			--make bin item from element
			local item = make_item(elem)

			--add item to bin's & element's bin array
			add_to_bin(item,x,y)
			add_to_elem_bin(item,elem,x,y)
		end
	end
end

function add_to_elem_bin(item,elem,x,y)
	init_elem_bin(elem,x,y)
	elem.bins[x][y]=item
end

function add_to_bin(item,x,y)
	--initialize bin, if not already.
	init_bin(x,y)
	
	--head of bin's list
	local ptr = bins[x][y]
	
	--if empty list...
	if ptr==nil or ptr.elem==nil then
		bins[x][y]=item
		item.next=nil
		return item
	end
	
	--loop until ptr is last element of list
	while ptr.next~=nil do
		ptr=ptr.next
	end
	
	--attach item to end of list
	ptr.next=item
	item.next=nil
	
	return item
end

function flower_bounds(fl)
	local x1=fl.x-proximity
	local y1=fl.y-proximity
	local x2=x1+2+proximity
	local y2=y1+3+proximity
	
	return {x1=x1,y1=y1,x2=x2,y2=y2}
end

function bins_index(n)
	return flr(n/bin_size)
end
