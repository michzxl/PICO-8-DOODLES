_chain={
    set_anchor = function(self,link,anchor)
        self[link].anchor=anchor
    end
}

_mtt_chain={
    __index=_chain,
}

function chain(links,seg)
    local ch = zeros(links)
    ch.seg=seg
    setmetatable(ch,_mtt_chain)
    return ch
end

function chainv(links,seg,copy)
    local ch = links
    if copy then
        ch={}
        for lk in all(links) do
            add(ch,lk:copy())
        end
    end
    ch.seg=seg
    setmetatable(ch,_mtt_chain)
    return ch
end

function chainp(length,seg)
    return chain(length/seg,seg)
end

function zeros(len)
    local vs={}
    for i=1,len do
        add(vs,vec(0,0,0))
    end
    return vs
end

function set_anchor(chain,link,anchorfunc)
    chain[link].anchor=anchorfunc
end