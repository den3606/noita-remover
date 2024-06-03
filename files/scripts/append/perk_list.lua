local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")
local Json = dofile_once("mods/noita-remover/files/scripts/lib/jsonlua/json.lua")

local noita_remover_perks = Json.decode(ModSettingGet(VALUES.PERK_BAN_LIST_KEY) or "{}")

-- Add Modding Spells
local is_updated = false
for _, perk in ipairs(perk_list) do
  local is_newer = true
  for _, noita_remover_spell in ipairs(noita_remover_perks) do
    if perk.id == noita_remover_spell.id then
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

-- for i = #perk_list, 1, -1 do
--   local perk = perk_list[i]

--   local banned = ModSettingGet(VALUES.PERK_BAN_PREFIX .. perk.id) or false

--   if banned then
--     table.remove(perk_list, i)
--   end
-- end

if #perk_list == 0 then
  table.insert(perk_list, {
    id = "DUMMY",
    ui_name = "$noita_remover_perk_dummy",
    ui_description = "$noita_remover_perk_dummy",
    ui_icon = "data/ui_gfx/inventory/item_bg_purchase_2.png",
    perk_icon = "data/ui_gfx/inventory/item_bg_purchase_2.png",
    game_effect = "",
    particle_effect = "",
    stackable = STACKABLE_NO,
    usable_by_enemies = false,
  })
end
