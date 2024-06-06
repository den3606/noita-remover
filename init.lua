local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")
local Json = dofile_once("mods/noita-remover/files/scripts/lib/jsonlua/json.lua")

ModLuaFileAppend("data/scripts/perks/perk_list.lua",
  "mods/noita-remover/files/scripts/append/perk_list.lua")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua",
  "mods/noita-remover/files/scripts/append/gun_actions.lua")

print("noita-remover load")


function OnModPreInit()
  ModSettingSet(VALUES.PERK_BAN_LIST_KEY, "{}")
  ModSettingSet(VALUES.SPELL_BAN_LIST_KEY, "{}")
  ModSettingSet(VALUES.IS_LOAD_BAN_LIST_AT_LEAST_ONE, false)
end

function OnModInit()
end

function OnModPostInit()
end

function OnPlayerSpawned(player_entity) -- This runs when player entity has been created
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
  GameAddFlagRun(VALUES.IS_GAME_START)
end

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the worl
  -- GamePrint("Pre-update hook " .. tostring(GameGetFrameNum()))
end

function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
  -- GamePrint("Post-update hook " .. tostring(GameGetFrameNum()))
end

function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
  -- print("===================================== random " .. tostring(x))
end

local content = ModTextFileGetContent("data/translations/common.csv")
local noita_remover_content = ModTextFileGetContent(
  "mods/noita-remover/files/translations/common.csv")
ModTextFileSetContent("data/translations/common.csv", content .. noita_remover_content)

print("noita-remover loaded")
