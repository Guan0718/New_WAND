----------------
-- 2022 by Spike

function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*[/\\])")
end
print("Starting Script")
package.path = script_path().."?.lua;"..script_path().."scriptlib\\".."?.lua"
print("include package path: ", package.path)
math.randomseed(tostring(os.time()):reverse():sub(1, 7))
-- load modules
local store  = require('store')
local vk     = require('virtualkey')
local global = require('global')
local hunt   = require('hunt')
local loot   = require('loot')
local maple  = require('maple')
local walk   = require('walk')
local PetFeedTick = os.clock()

local fixedCoordinates = {x = 131 , y = -1186} -- 替换为你想要的坐标
hunt.setFixedCoordinates(fixedCoordinates)

-----------------------Start from here-----------------------------------------------
-----------------------Start from here-----------------------------------------------
-----------------------Start from here-----------------------------------------------
-----------------------Start from here-----------------------------------------------


-- define your parameters
--------------------------------------------------------------------------------------
 -- game
 --------------------------------------------------------------------------------------
maple.MaxRunTime = 3000   --max run time in minute 
maple.HuntMapList =     -- append hunt map ID, and SafeSpot here
    {
        {ID=211040200,SafeSpot={108, -2076}},
        
    } 
maple.CCAtSafeSpot = {On = true, RandomCC = false, SwitchMapAfterCC=false}  --CC at SafeSpot
maple.SwitchMapAfterMin = 600 -- switch hunt map after x min, if you have more than one map in HuntMapList
maple.TotalChannel = 20      -- total channel 

maple.AlertTimeSec = 1        -- when someone stay in map for more than x sec, go to safespot
maple.PlayerWhiteList = {"EsoChen", "Kevincurry", "SMRT63ss"}       -- player white list, you can put your partner's ign  here
maple.AlertWhenMobAppears = {1234567}       -- alert when some strange mob ID appears 
--
maple.IfMapRushToHunt=false         --use maprush to hunt map
maple.IfMapRushToStore=false        --use maprush to store
maple.MapRushMethod = 0             --maprush method: 0 = spawn control; 1 = packet based; 2 = Use VIP rock 
maple.IfUseScrollToTown=true       -- use return scroll back to town 
ReturnScrollID = 2030000            -- return scroll item ID
------
maple.StopAtLevel = 200              -- stop at level = x
maple.AutoAp = {str=0, dex=0, int =5, luk = 0}  --auto ap

maple.PetFeed = true -- Enable pet feeding
maple.petfoodkey = vk.VK_= -- Pet food key
maple.MinFullness = 30 -- Minimum pet fullness level
maple.PetFeedDelay = 1 -- Pet feed delay in seconds
------
maple.Movement=
    {   MaxJump = 80,
        Stepsize = 6,       
        JumpKey = vk.VK_ALT,
        TeleportKey = vk.VK_SHIFT,
        MagicTeleport = true,
        MagicTeleportDistance = 200,
        UsInMapPortal = false,           --if use in_map portal
        TeleportWhenPathFail = true,    -- use teleport hack when path to one point cannot be found
        JumpDownTile= true,             -- jump down tile movement 
    }
------
maple.Buffs =
    {
        IfAutoBuff=true,     
        CanBuffOnRope=true,             -- if you can buff on rope
        ReBuffAdvanceSec = 5,           --rebuff x sec before buff dies
        Buff=
        {
            {ID=2301003, key =vk.VK_HOME},
            {ID=2001002, key =vk.VK_T},
            {ID=2321000, key =vk.VK_D},
            {ID=2311003, key =vk.VK_N},
        }
    }
maple.Filter=
    {
        IfMobFilter=false,
        IfItemFilter=false,
        MobFilter ={1111111,2222222},-- ID of mobs for MobFilter
        ItemFilter={2387002,2387003},-- ID of items for ItemFilter
    }
------
maple.MissGodModeRate = -1  -- rate : x out of 10 will miss, -1 = disable 


--------------------------------------------------------------------------------------
 -- store
 --------------------------------------------------------------------------------------
store.IfStore = false                         -- if go to store
store.CheckInventoryInterval = 1         -- check the equip inventory every 5 min; if the equip is full, go to the store
store.StoreMap=211040200              
store.NPCLocation = {289, -2080}          --stand close the npc, make sure you can open the NPC chat by key-pressing
store.NPCChatKey = vk.VK_J            
store.SellWhenEquipsMoreThan= 8         
store.CCAfterSell= {On = false, RandomCC = false}     
store.Potion =
   {
      IfBuyPots=true,      
      IfAutoPot=true,        
      HpOnKey = vk.VK_DELETE,    -- only support QuickSlot (8 keys in total)
      MpOnKey = vk.VK_END,       -- only support QuickSlot (8 keys in total)
      FeedDelay=2.5,             -- Auto pot delay in sec
      AutoHpThreshold=900,      
      AutoMpThreshold=5000,          
      BuyPotionList=
      {
         HP={ID=2022003,BuyNum=10, LowerLimit = 10},  
         MP={ID=2020015,BuyNum=20, LowerLimit = 10}, -- go the store if pot is below the LowerLimit
      }
   }
store.EquipWhiteList=  -- you need add nonsalable item ID here, because it cannot be sold by packets
   { 
      {ID=1812001,},
      {ID=1812000,},

   }
store.UseEtcWhiteList=  -- you need add nonsalable item ID here, because it cannot be sold by packets
   {
      {ID=4000049,},
      {ID=2260000},
      {ID=2020015},
      {ID=2022003},
      {ID=2210003},
      {ID=2120000},
      {ID=2050004},
      {ID=2043801},
      {ID=2040025},
      {ID=2040012},
      {ID=2030005},
      {ID=2030004},
      {ID=2030002},
      {ID=2030000},
      {ID=2022179},
      {ID=2002025},
      {ID=4039031},
      {ID=4032006},
      {ID=4031942},
      {ID=4031346},
      {ID=4031203},
      {ID=4031172},
      {ID=4031099},
      {ID=4031061},
      {ID=4031012},
      {ID=4010004},
      {ID=4010002},
      {ID=4010001},
      {ID=4006001},
      {ID=4006000},
      {ID=4004004},
      {ID=4004001},
      {ID=4004000},
      {ID=4001198},
      {ID=4001105},
      {ID=4001184},
      {ID=4001017},
      {ID=4001005},
      {ID=4000524},
      {ID=4000340},
      {ID=4000244},
      {ID=4000050},
   }

--------------------------------------------------------------------------------------
 -- hunt
 --------------------------------------------------------------------------------------
hunt.Keepaway = 
   {
        Front = 0,
        Back = 0,
        Top = 0,
        Bottom = 0,
    }
hunt.Attack =
    {
        HasOrient = false,   
        Key =  vk.VK_X, --single attack
        Key2 = vk.VK_X, --group attack  
        MobAttack = 0,        -- attack when mobs near you >= x
        MobFind = 1,          -- find mobs in a group of x
        Range = {
            IsFan = false,
            FanMinDistance = 100,
            Front = 50,      -- attack range in front: for spear, probably 120
            Back = 50,        -- attack range: back
            Top = 50,        -- attack range: top
            Bottom = 50,
        },
        count=0
    }
 hunt.YDisReScale = 1       -- rescale the vertical direction in distance calculator , if YDisReScale>1, the bot is prone to transverse movement 

--------------------------------------------------------------------------------------
 -- loot
 --------------------------------------------------------------------------------------
loot.Enable= false  -- enable auto loot function
loot.LootKey=vk.VK_Z    
loot.CasualLoot = true -- loot when you pass by a drop
loot.LootStyle = 2    -- 1 = loot MustPick item immediately, and ignore mobs on the way; 2 = loot MustPick item, but can hunt on the way.
loot.MustPickType =  -- you can put "Mesos", "Equip", "Use", "Setup" "Etc", "Cash", 
    {
        "",
    }
loot.MustPickID =  --  append to this list; must loot this item;
    {
        999999999,
    }
    LootAttempts=10  -- if it takes x attempts to loot one item, give up, and add that location to Exception

-- end of parameters
----------------------------------------------------
--Run the script
maple.Run()
---------------------------------------------------
