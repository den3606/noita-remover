local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")

for i = #perk_list, 1, -1 do
  local perk = perk_list[i]

  local is_removed = ModSettingGet(VALUES.MOD_NAME .. perk.id) or false

  if is_removed then
    table.remove(perk_list, i)
  end
end

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
