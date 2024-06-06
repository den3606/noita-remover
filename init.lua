local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")
local Json = dofile_once("mods/noita-remover/files/scripts/lib/jsonlua/json.lua")

ModLuaFileAppend("data/scripts/perks/perk_list.lua",
  "mods/noita-remover/files/scripts/append/perk_list.lua")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua",
  "mods/noita-remover/files/scripts/append/gun_actions.lua")

print("noita-remover load")



function OnModPreInit()
  -- Reset Ban List
  local want_to_refresh = ModSettingGet(VALUES.WANT_TO_RELOAD_KEY) or true
  if not want_to_refresh then
    ModSettingSet(VALUES.SPELL_BAN_LIST_KEY, "{}")
    ModSettingSet(VALUES.PERK_BAN_LIST_KEY, "{}")
  end
end

function OnModInit()
  -- print("Mod - OnModInit()") -- After that this is called for all mods
end

function OnModPostInit()
end

function OnPlayerSpawned(player_entity) -- This runs when player entity has been created
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
  local want_to_refresh = ModSettingGet(VALUES.WANT_TO_RELOAD_KEY) or true
  if want_to_refresh then
    -- Extract Modding Spells from source
    local function add_spells()
      dofile("data/scripts/gun/gun_actions.lua")
      local noita_remover_spells = Json.decode(ModSettingGet(VALUES.SPELL_BAN_LIST_KEY) or "{}")
      local is_updated = false
      for _, action in ipairs(actions) do
        local is_newer = true
        for _, noita_remover_spell in ipairs(noita_remover_spells) do
          if action.id == noita_remover_spell.id then
            is_newer = false
            break
          end
        end
        if is_newer then
          is_updated = true
          table.insert(noita_remover_spells, { id = action.id, sprite = action.sprite })
        end
      end

      if is_updated then
        local serialized_noita_remover_spells = Json.encode(noita_remover_spells)
        ModSettingSet(VALUES.SPELL_BAN_LIST_KEY, serialized_noita_remover_spells)
      end
    end
    add_spells()

    -- Extract Modding perks from source
    local function add_perks()
      dofile("data/scripts/perks/perk_list.lua")
      local noita_remover_perks = Json.decode(ModSettingGet(VALUES.PERK_BAN_LIST_KEY) or "{}")
      local is_updated = false
      for _, perk in ipairs(perk_list) do
        local is_newer = true
        for _, noita_remover_perk in ipairs(noita_remover_perks) do
          if perk.id == noita_remover_perk.id then
            is_newer = false
            break
          end
        end
        if is_newer then
          is_updated = true
          table.insert(noita_remover_perks, { id = perk.id, perk_icon = perk.perk_icon })
        end
      end

      if is_updated then
        local serialized_noita_remover_perks = Json.encode(noita_remover_perks)
        ModSettingSet(VALUES.PERK_BAN_LIST_KEY, serialized_noita_remover_perks)
      end
    end
    add_perks()
  end
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
