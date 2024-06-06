local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")
local Json = dofile_once("mods/noita-remover/files/scripts/lib/jsonlua/json.lua")
-- NOTE:
-- 初回の読み込みはNoitaの構築前に実施されるので、
-- actionsのデータだけ先に吸い出す
-- Useless Perk等、PostMOD以降で読み込ませているものは読めない
local function add_perks()
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


-- BANは削除処理を実施する
for i = #perk_list, 1, -1 do
  local perk = perk_list[i]
  local banned = ModSettingGet(VALUES.PERK_BAN_PREFIX .. perk.id) or false
  if banned then
    table.remove(perk_list, i)
  end
end

if #perk_list == 0 then
  table.insert(perk_list, {
    id = "NOITA_REMOVER_DUMMY",
    ui_name = "$noita_remover_perk_dummy",
    ui_description = "$noita_remover_perk_dummy",
    ui_icon = "mods/noita-remover/files/ui_gfx/dummy_icon.png",
    perk_icon = "mods/noita-remover/files/ui_gfx/dummy_icon.png",
    game_effect = "",
    particle_effect = "",
    stackable = STACKABLE_NO,
    usable_by_enemies = false,
  })
  AddFlagPersistent("perk_picked_noita_remover_dummy")
end
if #perk_list > 1 then
  for index, perk in ipairs(perk_list) do
    if perk.id == "NOITA_REMOVER_DUMMY" then
      table.remove(perk_list, index)
    end
  end
end

-- MOD初期化以降に追加されるパーク対応
local mt = {
  __newindex = function(t, key, value)
    -- noita-removerのPerk一覧に追加する
    local noita_remover_perks = Json.decode(ModSettingGet(VALUES.PERK_BAN_LIST_KEY) or "{}")
    local is_updated = false
    local is_newer = true
    for _, noita_remover_perk in ipairs(noita_remover_perks) do
      if value.id == noita_remover_perk.id then
        is_newer = false
        break
      end
    end
    if is_newer then
      is_updated = true
      table.insert(noita_remover_perks, { id = value.id, perk_icon = value.perk_icon })
    end

    if is_updated then
      local serialized_noita_remover_perks = Json.encode(noita_remover_perks)
      ModSettingSet(VALUES.PERK_BAN_LIST_KEY, serialized_noita_remover_perks)
    end


    -- BANされている場合はperk_listからの削除（追加回避）
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
