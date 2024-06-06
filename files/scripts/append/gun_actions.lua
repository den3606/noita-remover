local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")

-- NOTE:
-- 初回の読み込みはNoitaの構築前に実施されるので、
-- actionsのデータだけ先に吸い出す
local function add_spells()
  local Json = dofile_once("mods/noita-remover/files/scripts/lib/jsonlua/json.lua")
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


-- BANは削除処理を実施する
for i = #actions, 1, -1 do
  local spell = actions[i]
  local banned = ModSettingGet(VALUES.SPELL_BAN_PREFIX .. spell.id) or false
  if banned then
    table.remove(actions, i)
  end
end

if #actions == 0 then
  table.insert(actions, {
    id = "NOITA_REMOVER_DUMMY",
    name = "$noita_remover_spell_dummy",
    description = "$noita_remover_spell_dummy",
    sprite = "mods/noita-remover/files/ui_gfx/dummy_icon.png",
    sprite_unidentified = "mods/noita-remover/files/ui_gfx/dummy_icon.png",
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
if #actions > 1 then
  for index, action in ipairs(actions) do
    if action.id == "NOITA_REMOVER_DUMMY" then
      table.remove(actions, index)
    end
  end
end
