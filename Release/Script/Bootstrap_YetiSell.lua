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

-----------------------Start from here-----------------------------------------------

-- define your parameters
--------------------------------------------------------------------------------------
 -- store
--------------------------------------------------------------------------------------
store.IfStore = true                         -- if go to store
store.CheckInventoryInterval = 4         -- check the equip inventory every 5 min; if the equip is full, go to the store
store.StoreMap=100000102                    
store.NPCLocation = {-351, 224}          --stand close the npc, make sure you can open the NPC chat by key-pressing
store.NPCChatKey = vk.VK_J            
store.SellWhenEquipsMoreThan=55         
store.CCAfterSell= {On = true, RandomCC = false}     
store.Potion =
   {
      IfAutoPot=false,  
      IfBuyPots=true,      
      HpOnKey = vk.VK_DELETE,    -- only support QuickSlot (8 keys in total)
      MpOnKey = vk.VK_END,       -- only support QuickSlot (8 keys in total)
      FeedDelay=0.2,             -- Auto pot delay in sec
      AutoHpThreshold=300,      
      AutoMpThreshold=50,          
      BuyPotionList=
      {
         HP={ID=2000001,BuyNum=600, LowerLimit = 20},  -- go the store if pot is below the LowerLimit
         MP={ID=2000003,BuyNum=500, LowerLimit = 20},
      }
   }
store.EquipWhiteList=  -- you need add nonsalable item ID here, because it cannot be sold by packets
   {
      {ID=1302056,Stats={"Watk",103} },   -- 
      {ID=1122077,Stats={}},
      {ID=1222222,Stats={"Str", 1,"Dex", 2} },
   }
store.UseEtcWhiteList=  -- you need add nonsalable item ID here, because it cannot be sold by packets
   {
      {ID=2030004},
      {ID=2030000},
   }

----------------------------------------------------
--Run the store script
store.Check()
---------------------------------------------------