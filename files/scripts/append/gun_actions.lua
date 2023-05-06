local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")

for i = #actions, 1, -1 do
  local spell = actions[i]

  local is_removed = ModSettingGet(VALUES.MOD_NAME .. spell.id) or false

  if is_removed then
    table.remove(actions, i)
  end
end


-- for i = #actions, 1, -1 do
--   if i ~= 1 then
--     table.remove(actions, i)
--   end
-- end
