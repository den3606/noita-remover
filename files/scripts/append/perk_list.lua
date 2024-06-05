local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")
local Json = dofile_once("mods/noita-remover/files/scripts/lib/jsonlua/json.lua")

local want_to_refresh = ModSettingGet(VALUES.WANT_TO_RELOAD_KEY) or false
if not want_to_refresh then
  -- リフレッシュを希望していない場合は削除処理を実施する
  for i = #perk_list, 1, -1 do
    local perk = perk_list[i]
    local banned = ModSettingGet(VALUES.PERK_BAN_PREFIX .. perk.id) or false
    if banned then
      table.remove(perk_list, i)
    end
  end

  -- MODのitemは追加時を検知して、テーブルに入れないようにする
  local mt = {
    __newindex = function(t, key, value)
      local banned = ModSettingGet(VALUES.PERK_BAN_PREFIX .. value.id) or false
      if not banned then
        rawset(t, key, value)
      end
    end
  }
  setmetatable(perk_list, mt)

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

if #perk_list == 0 then
  table.insert(perk_list, {
    id = "DUMMY",
    ui_name = "$noita_remover_perk_dummy",
    ui_description = "$noita_remover_perk_dummy",
    sprite = "mods/noita-remover/files/ui_gfx/dummy_icon.png",
    perk_icon = "mods/noita-remover/files/ui_gfx/dummy_icon.png",
    game_effect = "",
    particle_effect = "",
    stackable = STACKABLE_NO,
    usable_by_enemies = false,
  })
end
if #perk_list > 1 then
  for index, perk in ipairs(perk_list) do
    if perk.id == "DUMMY" then
      table.remove(perk_list, index)
    end
  end
end
