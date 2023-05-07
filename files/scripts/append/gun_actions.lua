local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")

for i = #actions, 1, -1 do
  local spell = actions[i]

  local banned = ModSettingGet(VALUES.SPELL_PREFIX .. spell.id) or false

  if banned then
    table.remove(actions, i)
  end
end

if #actions == 0 then
  table.insert(actions, {
    id = "DUMMY",
    name = "$noita_remover_spell_dummy",
    description = "$noita_remover_spell_dummy",
    sprite = "data/ui_gfx/inventory/item_bg_purchase_2.png",
    sprite_unidentified = "data/ui_gfx/inventory/item_bg_purchase_2.png",
    type = ACTION_TYPE_PROJECTILE,
    spawn_level = "",
    spawn_probability = "",
    price = 0,
    mana = 0,
    max_uses = 0,
    action = function()
    end,
  })
end
