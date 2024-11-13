-- 2022 by Spike

local vk = require('virtualkey')
local global = require('global')


local module = 
{
    YDisReScale = 1,
    Keepaway = {
        Front = 0,
        Back = 0,
        Top = 0,
        Bottom = 0,
    },  
    Attack =
    {
        HasOrient = true,   
        Key = vk.VK_CONTROL,   --single attack
        Key2 = vk.VK_CONTROL, --group attack  
        MobAttack = 1,  
        MobFind = 1,        
        Range = {
            IsFan = false,
            FanMinDistance = 60,
            Front = 80,     -- attack range in front: for spear, probably 120
            Back = 0,       -- attack range: back
            Top = 30,       -- attack range: top
            Bottom = 10,
        },
        count = 0
    },
    --helper parameters
    Mindis = 12
}

-- Enable or disable functions
local enableDefaultDistanceCaculator = true
local enableItemInsideMap = true
local enableCheckKeepwayRange = true
local enableCheckAttackRange = true
local enableCountAttackableMob = true
local enableFindNextPos = true
local enableTryAttack = true

--helper functions
local function DefaultDistanceCaculator(x1, y1, x2, y2, YDisReScale)
    if not enableDefaultDistanceCaculator then return end
    return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) * YDisReScale * YDisReScale)
end

local function ItemInsideMap(pos, left, top, right, bottom)
    if not enableItemInsideMap then return end
    return pos.x > left + module.Mindis and pos.x < right - module.Mindis 
       and pos.y > top + module.Mindis and pos.y <= bottom
end

local function CheckKeepwayRange(pos, mob, orient)
    if not enableCheckKeepwayRange then return end
    if orient == 0 then 
        -- player facing left
        return (mob.x <= pos.x - module.Keepaway.Front or mob.x >= pos.x + module.Keepaway.Back)
           and (mob.y <= pos.y - module.Keepaway.Top or mob.y >= pos.y + module.Keepaway.Bottom)
    else 
        -- player facing right
        return (mob.x <= pos.x - module.Keepaway.Back or mob.x >= pos.x + module.Keepaway.Front)
           and (mob.y <= pos.y - module.Keepaway.Top or mob.y >= pos.y + module.Keepaway.Bottom)
    end
end

local function CheckAttackRange(pos, mob, orient)
    if not enableCheckAttackRange then return end
    if module.Attack.Range.IsFan then
        local dx = math.abs(mob.x - pos.x)
        local dy = pos.y - mob.y
        if (dy >= 60 or dy <= -30) and dx <= module.Attack.Range.FanMinDistance then
            return false
        end
    end

    if orient == 0 then 
        -- player facing left
        return mob.x >= pos.x - module.Attack.Range.Front 
           and mob.x <= pos.x + module.Attack.Range.Back 
           and mob.y >= pos.y - module.Attack.Range.Top 
           and mob.y <= pos.y + module.Attack.Range.Bottom 
    else 
        -- player facing right
        return mob.x >= pos.x - module.Attack.Range.Back 
           and mob.x <= pos.x + module.Attack.Range.Front 
           and mob.y >= pos.y - module.Attack.Range.Top 
           and mob.y <= pos.y + module.Attack.Range.Bottom 
    end
end

local function CountAttackableMob(pos, moblist, orient)
    if not enableCountAttackableMob then return end
    local attack_count = 0
    for idx, mob in pairs(moblist) do
        if CheckAttackRange(pos, mob, orient) and CheckKeepwayRange(pos, mob, orient) then
            attack_count = attack_count + 1
        end
    end
    return attack_count
end

local function FindNextPos(moblist)
    if not enableFindNextPos then return end
    local target = nil
    local dst = 9999999999
    local Player = GetPlayer()
    local mapBound = GetMapDimension()

    for k, mob in pairs(moblist) do
        local attack_count = CountAttackableMob(mob, moblist, 0)

        if attack_count < module.Attack.MobFind and module.Attack.HasOrient then
            attack_count = CountAttackableMob(mob, moblist, 1)
        end

        if attack_count >= module.Attack.MobFind then
            if module.MobDistanceCaculator == nil then
                module.MobDistanceCaculator = DefaultDistanceCaculator
            end
            local d = module.MobDistanceCaculator(Player.x, Player.y, mob.x, mob.y, module.YDisReScale)
            local inside = ItemInsideMap(mob, mapBound.left, mapBound.top, mapBound.right, mapBound.bottom)
            if d < dst and inside then
                target = mob
                dst = d
            end
        end
    end
    return target
end

local function TryAttack(moblist)
    if not enableTryAttack then return end
    local Player = GetPlayer()

    if Player.OnRope == true or Player.InAir == true then
        return false
    end

    local need_reverse = false
    local orient = Player.Orientation
    local attack_count = CountAttackableMob(Player, moblist, orient)

    if attack_count < module.Attack.MobAttack and module.Attack.HasOrient then
        need_reverse = true
        if orient == 1 then
            attack_count = CountAttackableMob(Player, moblist, 0)
        else
            attack_count = CountAttackableMob(Player, moblist, 1)
        end
    end

    if attack_count >= module.Attack.MobAttack then
        if need_reverse then
            StopMove()
            if orient == 1 then
                HoldKey(vk.VK_RIGHT, 0)
                SendKey(vk.VK_LEFT)
                SendKey(vk.VK_LEFT)
                HoldKey(vk.VK_LEFT, 1)
            else
                HoldKey(vk.VK_LEFT, 0)
                SendKey(vk.VK_RIGHT)
                SendKey(vk.VK_RIGHT)
                HoldKey(vk.VK_RIGHT, 1)
            end
            Delay(100)
        end

        if module.StopMoveWhenAttack then
            StopMove()
        end
        HoldKey(vk.VK_DOWN, 0)
        if attack_count > module.Attack.MobAttack then
            SendKey(module.Attack.Key2)
            Delay(50)
        else
            SendKey(module.Attack.Key)
            Delay(50)
        end
        module.Attack.count = module.Attack.count + 1

        return true
    end

    return false
end

local FailCount = 0
local fixedCoordinates = {x = -486, y = -25} -- 替换为你想要的坐标

function module.setFixedCoordinates(newCoordinates)
    fixedCoordinates = newCoordinates
end

function module.Run()
    local Player = GetPlayer()
    local c = 1
    local moblist = {}
    local Mobs = GetAllMobs()

    if Mobs == nil then
        print("No Mob in the Map!")
        StopMove()
        return 0
    end

    for k, mob in pairs(Mobs) do
        if not mob.invisible then
            moblist[c] = {x = mob.x, y = mob.y}
            c = c + 1
        end
    end

    while true do
        local attackable = TryAttack(moblist)

        if attackable and module.Attack.StopMoveWhenAttack then
            StopMove()
            return 0
        end

        if global.IngorePathingToMob then
            return 0
        end

        local ms = MoveTo(fixedCoordinates.x, fixedCoordinates.y)

        if ms == 2 then
            FailCount = FailCount + 1
            if FailCount > 5 then
                print("Unable to find the path, trying random mob")
                local idx = math.random(global.length(moblist))
                MoveTo(moblist[idx].x, moblist[idx].y)
            end
        else
            FailCount = 0
        end
        
        -- Ensure player attacks monsters at fixed coordinates
        if Player.x == fixedCoordinates.x and Player.y == fixedCoordinates.y then
            local attack_count = CountAttackableMob(Player, moblist, Player.Orientation)
            if attack_count > 0 then
                TryAttack(moblist)
            end
        end
    end
end

return module
