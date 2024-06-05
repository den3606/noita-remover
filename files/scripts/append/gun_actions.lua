local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")

local want_to_refresh = ModSettingGet(VALUES.WANT_TO_RELOAD_KEY) or false
if not want_to_refresh then
  -- リフレッシュを希望していない場合は削除処理を実施する
  for i = #actions, 1, -1 do
    local spell = actions[i]
    local banned = ModSettingGet(VALUES.SPELL_BAN_PREFIX .. spell.id) or false
    if banned then
      table.remove(actions, i)
    end
  end

  -- index指定挿入
  local mt = {
    __newindex = function(t, key, value)
      local banned = ModSettingGet(VALUES.SPELL_BAN_PREFIX .. value.id) or false
      if not banned then
        rawset(t, key, value)
      end
    end
  }
  setmetatable(actions, mt)

  -- table.insertはmetadataに反応しないため再実装する
  table.insert = function(t, pos, value)
    if value == nil then
      value = pos
      pos = #t + 1
    end

    if pos > #t then
      t[pos] = value
    else
      for i = #t, pos, -1 do
        t[i + 1] = t[i]
      end
      t[pos] = value
    end
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
