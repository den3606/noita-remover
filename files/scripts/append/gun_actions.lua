local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")

for i = #actions, 1, -1 do
  local spell = actions[i]

  local is_removed = ModSettingGet(VALUES.MOD_NAME .. spell.id) or false

  if is_removed then
    table.remove(actions, i)
  end
end

if #actions == 0 then
  table.insert(actions, {
    id = "DUMMY",
    name = "DUMMY",
    description = "DUMMY",
    sprite = "",
    sprite_unidentified = "",
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
