local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")

for i = #perk_list, 1, -1 do
  local perk = perk_list[i]

  local is_removed = ModSettingGet(VALUES.MOD_NAME .. perk.id) or false

  if is_removed then
    table.remove(perk_list, i)
  end
end
