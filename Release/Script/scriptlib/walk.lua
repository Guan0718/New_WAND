----------------
-- 2022 by Spike

local vk = require('virtualkey')
local global = require('global')
local module = 
{
    Mindis=12,
    Lastpx=0,
    Lastpy=0,
    NPCChatKey = vk.VK_SPACE,
    ExceptionMap={},
}

local function ManualPort(Player, portal)

    print("Use Manually Added Portal: ", portal.portalName)
    -- chat with NPC and go to regular Sauna
    if portal.portalName=="to_Sauna" then
        for i=1,3 do
            SendKey(module.NPCChatKey) Delay(300)
        end
        SendKey(vk.VK_RIGHT) Delay(300)
        SendKey(module.NPCChatKey)  Delay(2000)
        return 
    end

    -- if no special move, still use portal
    StopMove()
    SendKey(vk.VK_UP,4)
    Delay(2000)

end

function module.Walk(Player, mapID)


    portal = FindNextPortal(mapID)

    if(portal.portalName=="Not_Found") then
        print(string.format("Uable to find portal to map %d",mapID))
        print(string.format("Please check the maplist and consider add connections manually"))
        return 1
    end

    
    local ms=MoveTo(portal.x, portal.y ,1)
    --print("Moving to Portal: [",portal.x,", ",portal.y,"]")
    if ms==2 then
        print("module.Walk: Uable to find the path")
        StopMove()
    end
    if ms~=2 and global.Distance(Player.x, Player.y, portal.x, portal.y)<module.Mindis*2 then
        if portal.type=="game" then
            StopMove()
            SendKey(vk.VK_UP,4)
            Delay(2000)
        else
            StopMove()
            ManualPort(Player, portal)
        end
    end



    return 0
end

return module