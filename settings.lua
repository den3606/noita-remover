dofile("data/scripts/lib/mod_settings.lua")
dofile_once("data/scripts/perks/perk_list.lua")
dofile_once("data/scripts/gun/gun_actions.lua")



---------------------------------------------------------
-- VALUES
local VALUES = {
  MOD_NAME = 'noita-remover',
  GLOBAL_GUI_ID_KEY = 'noita-remover.global-gui-id-key',
  DANGER_ANNOUNCE = 'noita-remover.do-not-edit-in-game.',
  PERK_BAN_PREFIX = 'noita-remover.perk-ban.',
  PERK_BAN_POOL_PREFIX = 'noita-remover.perk-ban-pool.',
  SPELL_BAN_PREFIX = 'noita-remover.spell-ban.',
  SPELL_BAN_POOL_PREFIX = 'noita-remover.spell-ban-pool.',
  PERK_GUI = {
    BAN_SELECT = 'perk_ban',
    BAN_POOL = 'perk_ban_pool',
  },
  SPELL_GUI = {
    BAN_SELECT = 'spell_ban',
    BAN_POOL = 'spell_ban_pool',
  }
}
---------------------------------------------------------



---------------------------------------------------------
-- Localise
local function language()
  local current_language = GameTextGet("$current_language")
  if current_language == "English" then
    return 'en'
  end
  if current_language == "русский" then
    return 'ru'
  end
  if current_language == "Português (Brasil)" then
    return 'pt-br'
  end
  if current_language == "Español" then
    return 'es-es'
  end
  if current_language == "Deutsch" then
    return 'de'
  end
  if current_language == "Français" then
    return 'fr-fr'
  end
  if current_language == "Italiano" then
    return 'it'
  end
  if current_language == "Polska" then
    return 'pl'
  end
  if current_language == "简体中文" then
    return 'zh-cn'
  end
  if current_language == "日本語" then
    return 'ja'
  end
  if current_language == "한국어" then
    return 'ko'
  end

  return 'en'
end

local function is_multi_byte_language()
  if language() == 'ja' then
    return true
  end
  if language() == 'ko' then
    return true
  end
  if language() == 'zh-cn' then
    return true
  end

  return false
end

local function description()
  local noita_remover_description_en = "DON'T FORGET TO PRESS THE ADAPT BUTTON UNDER SETTINGS!\n \n" ..
      "==Important==" .. "\n" ..
      "In some cases, \nwhen settings are changed during the game, spells suddenly become unavailable.\n" ..
      "Excluding all perks/spells is not expected on Noita's part.\n" ..
      "Please note that unforeseen events may occur.\n \n" ..
      "==How to use==" .. "\n" ..
      "You can ban from left and right window.\n" ..
      "Left is perks, rihgt is spells.\n" ..
      "Ban perks/spells are enabled when Noita initialized (start new game).\n" ..
      "Banned items will be darkened. Unbanned items will be brighter.\n \n" ..
      "==Random BAN==" .. "\n" ..
      "By default, a random draw is made among all Perk/Spells.\n" ..
      "You can select Spell/Perk for the Random BAN \nby changing the GUI from the Selected GUI in the main window.\n" ..
      "(\"Perk Ban Pool List\" window).\n" ..
      "In this window, Perks targeted for BAN are brightly displayed.\n"

  local noita_remover_description_ja = "==はじめに==\n下にある「適応して戻る」ボタンを押すのを忘れないでください\n \n" ..
      "== 重要事項 ==" .. "\n" ..
      "ゲーム中に設定を変更すると、スペルが突然使えなくなるケースがあります。\n" ..
      "全てのパーク、スペルを除外されることを Noita 側は想定していません。\n" ..
      "想定外の事象が発生する可能性があることにご留意ください。\n \n" ..
      "== 大まかな使い方 ==" .. "\n" ..
      "左右にある枠より設定が可能です。\n" ..
      "左にはパーク、右には呪文の設定があります。\n" ..
      "BAN したパーク、スペルは Noita を始めたときに適応されます\n（新規ゲームを始めたとき）\n" ..
      "利用できるものは明るく、\n利用できないもの（BANされているもの）は暗くなります\n \n" ..
      "== ランダム BAN について ==" .. "\n" ..
      "デフォルトでは、全 Perk/Spell の中からランダムで抽選が行われます。\n" ..
      "メイン項目の Selected GUI から、GUIを変更することで\nRnadom BAN の対象 Spell/Perk を選択できます。\n" ..
      "（Perk Ban Pool List画面）\n" ..
      "この画面では、BAN 対象となる Perk が明るく表示されます。\n"

  if language() == "en" then
    return noita_remover_description_en
  end
  if language() == "ja" then
    return noita_remover_description_ja
  end
  return noita_remover_description_en
end
---------------------------------------------------------



---------------------------------------------------------
-- Current GUI ID

local perk_gui_id = ModSettingGet('noita-remover.current_perk_gui') or VALUES.PERK_GUI.BAN_SELECT
print(perk_gui_id)
local function switch_perk_gui_callback(mod_id, gui, in_main_menu, setting, old_value, new_value)
  perk_gui_id = new_value
  ModSettingSet('noita-remover.current_perk_gui', new_value)
end
local spell_gui_id = ModSettingGet('noita-remover.current_spell_gui') or VALUES.SPELL_GUI.BAN_SELECT
local function switch_spell_gui_callback(mod_id, gui, in_main_menu, setting, old_value, new_value)
  spell_gui_id = new_value
  ModSettingSet('noita-remover.current_spell_gui', new_value)
end
---------------------------------------------------------


local mod_id = "noita-remover" -- This should match the name of your mod's folder.
mod_settings_version = 1       -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
  {
    category_id = "group_of_perk_settings",
    ui_name = "Perk GUI Settings",
    settings = {
      {
        id = "current_perk_gui",
        ui_name = ">Selected GUI",
        ui_description = "The selected GUI is displayed on the left.",
        value_default = VALUES.PERK_GUI.BAN_SELECT,
        values = { { VALUES.PERK_GUI.BAN_SELECT, "[1]Perk Ban List" },
          { VALUES.PERK_GUI.BAN_POOL,   "[2]Perk Ban Pool List" } },
        scope = MOD_SETTING_SCOPE_RUNTIME,
        change_fn = switch_perk_gui_callback,
      },
    },
  },
  {
    category_id = "group_of_spell_settings",
    ui_name = "Spell GUI Settings",
    settings = {
      {
        id = "current_spell_gui",
        ui_name = ">Selected GUI",
        ui_description = "The selected GUI is displayed on the right.",
        value_default = VALUES.SPELL_GUI.BAN_SELECT,
        values = { { VALUES.SPELL_GUI.BAN_SELECT, "[1]Spell Ban List" },
          { VALUES.SPELL_GUI.BAN_POOL,   "[2]Spell Ban Pool List" } },
        scope = MOD_SETTING_SCOPE_RUNTIME,
        change_fn = switch_spell_gui_callback,
      },
    },
  },
  {
    category_id = "group_of_description",
    ui_name = "Noita Remover Description",
    foldable = true,
    _folded = true,
    settings = {
      {
        id = "noita-remover-description",
        ui_name = description(),
        not_setting = true,
      },
    },
  },
}

function ModSettingsUpdate(init_scope)
  local old_version = mod_settings_get_version(mod_id)
  mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
  return mod_settings_gui_count(mod_id, mod_settings)
end

---------------------------------------------------------
---------------------------------------------------------
--------------------- NOITA REMOVER ---------------------
---------------------------------------------------------
---------------------------------------------------------
-- Settingsで表示するUIは全てsettings.lua内に記述する必要があります
-- settings.lua からファイル参照を行った場合、SteamのWorkshopで名前解決ができず参照できないためです。



---------------------------------------------------------
-- RandomCount
-- randomが被らないようにするためのもの
local year, month, day, hour, minute, second = GameGetDateAndTimeUTC()
local date = tonumber(tostring(year) ..
  tostring(month) .. tostring(day) .. tostring(hour) .. tostring(minute) .. tostring(second))
math.randomseed(date)
---------------------------------------------------------



---------------------------------------------------------
-- BannedCount
-- element: perk or spell

local perk_ban_count = 0
local spell_ban_count = 0

local function ban_count()
  local function perk_ban_counter()
    local count = 0
    for i = #perk_list, 1, -1 do
      local perk = perk_list[i]

      if ModSettingGet(VALUES.PERK_BAN_PREFIX .. perk.id) or false then
        count = count + 1
      end
    end
    return count
  end

  local function spell_ban_counter()
    local count = 0
    for i = #actions, 1, -1 do
      local spell = actions[i]

      if ModSettingGet(VALUES.SPELL_BAN_PREFIX .. spell.id) or false then
        count = count + 1
      end
    end
    return count
  end

  perk_ban_count = perk_ban_counter()
  spell_ban_count = spell_ban_counter()
end
ban_count()
---------------------------------------------------------



---------------------------------------------------------
-- Last Selected Ban Perk/Spell
local last_selected_perk_path = 'data/ui_gfx/gun_actions/baab_empty.png'
local last_selected_spell_path = 'data/ui_gfx/gun_actions/baab_empty.png'

local is_empty_last_perk = function()
  return last_selected_perk_path == 'data/ui_gfx/gun_actions/baab_empty.png'
end

local is_empty_last_spell = function()
  return last_selected_spell_path == 'data/ui_gfx/gun_actions/baab_empty.png'
end
---------------------------------------------------------


---------------------------------------------------------
-- gui_utils.lua
function StringToNumber(str)
  local num = 0
  for i = 1, #str do
    local char = string.sub(str, i, i)
    num = num + string.byte(char)
  end
  return num
end

function NewID()
  local global_gui_id = tonumber(ModSettingGet(VALUES.GLOBAL_GUI_ID_KEY)) or 0
  if global_gui_id == 0 then
    global_gui_id = StringToNumber(VALUES.MOD_NAME)
  end

  global_gui_id = global_gui_id + 1
  ModSettingSet(VALUES.GLOBAL_GUI_ID_KEY, tostring(global_gui_id))
  return global_gui_id
end

-- HACK: 画像とボタンテキストを重ねて設置している
-- 各言語によってスペースの扱い勝ちが言うので、調整が必要
-- 暗い状態が選択中、明るい状態が未選択
function GuiToggleImageDisableButton(
  gui, image_id, button_id, icon_path, state_name, enabled_fn, disabled_fn)
  local w, h = GuiGetImageDimensions(gui, icon_path, 1)

  local blank = ''

  if is_multi_byte_language() then
    for i = 0, math.floor(w / 2) do
      blank = blank .. ' '
    end
  else
    for i = 0, math.floor(w / 4) do
      blank = blank .. ' '
    end
  end

  local disabled = ModSettingGet(state_name)

  if disabled == nil then
    disabled = false
  end

  if GuiButton(gui, button_id, 0, h / 4, blank) then
    disabled = not disabled

    -- graphic処理以外はButtonが押されたときのみ動作させる
    ModSettingSet(state_name, disabled)
    if disabled then
      disabled_fn()
    else
      enabled_fn()
    end
  end

  if disabled then
    GuiImage(gui, image_id, -w, 0, icon_path, 0.3, 1)
  else
    GuiImage(gui, image_id, -w, 0, icon_path, 1, 1)
  end
end

-- HACK: 画像とボタンテキストを重ねて設置している
-- 各言語によってスペースの扱い勝ちが言うので、調整が必要
-- 明るい状態が選択中、暗い状態が未選択
function GuiToggleImageEnableButton(
  gui, image_id, button_id, icon_path, state_name, enabled_fn, disabled_fn)
  local w, h = GuiGetImageDimensions(gui, icon_path, 1)

  local blank = ''

  if is_multi_byte_language() then
    for i = 0, math.floor(w / 2) do
      blank = blank .. ' '
    end
  else
    for i = 0, math.floor(w / 4) do
      blank = blank .. ' '
    end
  end

  local enabled = ModSettingGet(state_name)
  if enabled == nil then
    enabled = true
  end

  if GuiButton(gui, button_id, 0, h / 4, blank) then
    enabled = not enabled
    -- graphic処理以外はButtonが押されたときのみ動作させる
    ModSettingSet(state_name, enabled)
    if enabled then
      enabled_fn()
    else
      disabled_fn()
    end
  end
  if enabled then
    GuiImage(gui, image_id, -w, 0, icon_path, 1, 1)
  else
    GuiImage(gui, image_id, -w, 0, icon_path, 0.3, 1)
  end
end

---------------------------------------------------------



---------------------------------------------------------
-- dummy_ui
local dummy_ui_id = NewID()
---------------------------------------------------------



---------------------------------------------------------
-- perk_ui.lua

local perk_scroll_container_id = NewID()
local remove_all_perk_button_id = NewID()
local add_all_perk_button_id = NewID()
local swap_perk_button_id = NewID()
local remove_random_perk_button_id = NewID()

local perk_gui_rows = {}
local perk_row = {}

for i = 1, #perk_list do
  table.insert(perk_row, {
    icon_path = perk_list[i].perk_icon,
    ban_image_id = NewID(),
    ban_button_id = NewID(),
    ban_key = VALUES.PERK_BAN_PREFIX .. perk_list[i].id,
    ban_state_name = VALUES.PERK_BAN_PREFIX .. perk_list[i].perk_icon,
    banned_fn = function()
      ModSettingSet(VALUES.PERK_BAN_PREFIX .. perk_list[i].id, true)
      ban_count()
      last_selected_perk_path = perk_list[i].perk_icon
    end,
    unbanned_fn = function()
      ModSettingSet(VALUES.PERK_BAN_PREFIX .. perk_list[i].id, false)
      ban_count()
    end,
    ban_pool_image_id = NewID(),
    ban_pool_button_id = NewID(),
    ban_pool_key = VALUES.PERK_BAN_POOL_PREFIX .. perk_list[i].id,
    ban_pool_state_name =
        VALUES.PERK_BAN_PREFIX .. VALUES.PERK_BAN_POOL_PREFIX .. perk_list[i].perk_icon,
    include_from_ban_pool_fn = function()
      ModSettingSet(VALUES.PERK_BAN_POOL_PREFIX .. perk_list[i].id, true)
    end,
    exclude_from_ban_pool_fn = function()
      ModSettingSet(VALUES.PERK_BAN_POOL_PREFIX .. perk_list[i].id, false)
    end,
  })
  if i % 6 == 0 then
    table.insert(perk_gui_rows, perk_row)
    perk_row = {}
  end
end
-- 最後に割り切れなかったperksを挿入する
table.insert(perk_gui_rows, perk_row)


local function perk_icon(gui)
  for _, row in ipairs(perk_gui_rows) do
    GuiLayoutBeginHorizontal(gui, 0, 0, false, 3);

    for _, perk in ipairs(row) do
      GuiToggleImageDisableButton(gui, perk.ban_image_id, perk.ban_button_id, perk.icon_path, perk
        .ban_state_name,
        perk.unbanned_fn, perk.banned_fn)
    end

    GuiLayoutEnd(gui)
  end
end

local function perk_pool_icon(gui)
  for _, row in ipairs(perk_gui_rows) do
    GuiLayoutBeginHorizontal(gui, 0, 0, false, 3);

    for _, perk in ipairs(row) do
      GuiToggleImageEnableButton(
        gui, perk.ban_pool_image_id, perk.ban_pool_button_id, perk.icon_path,
        perk.ban_pool_state_name,
        perk.include_from_ban_pool_fn, perk.exclude_from_ban_pool_fn)
    end

    GuiLayoutEnd(gui)
  end
end
---------------------------------------------------------



---------------------------------------------------------
-- spell_ui.lua

local spell_scroll_container_id = NewID()
local remove_all_spell_button_id = NewID()
local add_all_spell_button_id = NewID()
local swap_spell_button_id = NewID()
local remove_random_spell_button_id = NewID()

local spell_gui_rows = {}
local spell_row = {}

for i = 1, #actions do
  table.insert(spell_row, {
    ban_key = VALUES.SPELL_BAN_PREFIX .. actions[i].id,
    ban_image_id = NewID(),
    ban_button_id = NewID(),
    icon_path = actions[i].sprite,
    ban_state_name = VALUES.SPELL_BAN_PREFIX .. actions[i].sprite,
    banned_fn = function()
      ModSettingSet(VALUES.SPELL_BAN_PREFIX .. actions[i].id, true)
      ban_count()
      last_selected_spell_path = actions[i].sprite
    end,
    unbanned_fn = function()
      ModSettingSet(VALUES.SPELL_BAN_PREFIX .. actions[i].id, false)
      ban_count()
    end,
    ban_pool_image_id = NewID(),
    ban_pool_button_id = NewID(),
    ban_pool_key = VALUES.SPELL_BAN_POOL_PREFIX .. actions[i].id,
    ban_pool_state_name =
        VALUES.SPELL_BAN_PREFIX .. VALUES.SPELL_BAN_POOL_PREFIX .. actions[i].sprite,
    include_from_ban_pool_fn = function()
      ModSettingSet(VALUES.SPELL_BAN_POOL_PREFIX .. actions[i].id, true)
    end,
    exclude_from_ban_pool_fn = function()
      ModSettingSet(VALUES.SPELL_BAN_POOL_PREFIX .. actions[i].id, false)
    end,
  })
  if i % 6 == 0 then
    table.insert(spell_gui_rows, spell_row)
    spell_row = {}
  end
end
-- 最後に割り切れなかったspellsを挿入する
table.insert(spell_gui_rows, spell_row)


local function spell_icon(gui)
  for _, row in ipairs(spell_gui_rows) do
    GuiLayoutBeginHorizontal(gui, 0, 0, false, 3);

    for _, spell in ipairs(row) do
      GuiToggleImageDisableButton(gui, spell.ban_image_id, spell.ban_button_id, spell.icon_path,
        spell.ban_state_name,
        spell.unbanned_fn, spell.banned_fn)
    end

    GuiLayoutEnd(gui)
  end
end

local function spell_pool_icon(gui)
  for _, row in ipairs(spell_gui_rows) do
    GuiLayoutBeginHorizontal(gui, 0, 0, false, 3);

    for _, spell in ipairs(row) do
      GuiToggleImageEnableButton(
        gui, spell.ban_pool_image_id, spell.ban_pool_button_id, spell.icon_path,
        spell.ban_pool_state_name,
        spell.include_from_ban_pool_fn, spell.exclude_from_ban_pool_fn)
    end

    GuiLayoutEnd(gui)
  end
end
---------------------------------------------------------



---------------------------------------------------------
-- Park Ban List
local function draw_perk_ban_box(gui, main_menu_widget_info)
  local screen_width, screen_height = GuiGetScreenDimensions(gui)

  GuiLayoutBeginLayer(gui)
  local perk_width = (screen_width / 5) - (screen_width / 150)
  local perk_x = main_menu_widget_info.x - perk_width - 16
  GuiBeginScrollContainer(
    gui, perk_scroll_container_id, perk_x, main_menu_widget_info.y, perk_width, 277)
  GuiLayoutBeginVertical(gui, 0, 0)

  -- In Box rendering
  GuiText(gui, 0, 0, "[1]Perk Ban List")
  GuiText(gui, 0, 0, "Banned Perks: " .. perk_ban_count)
  GuiLayoutBeginHorizontal(gui, 0, 0, false, 3);
  GuiText(gui, 0, 3, "Last Banned Perk:")
  if is_empty_last_perk() then
    GuiImage(gui, 321321, 0, 0, last_selected_perk_path, 0, 1)
  else
    GuiImage(gui, 321322, 0, 0, last_selected_perk_path, 1, 1)
  end
  GuiLayoutEnd(gui)
  GuiText(gui, 0, 0, "=========================")

  if GuiButton(gui, remove_random_perk_button_id, 0, 0, ">Ban Random Perk") then
    local unremoved_perks = {}
    for _, row in ipairs(perk_gui_rows) do
      for _, perk in ipairs(row) do
        local include_ban_pool = ModSettingGet(perk.ban_pool_key)
        if include_ban_pool == nil then
          include_ban_pool = true
        end
        local is_not_banned = not ModSettingGet(perk.ban_key)
        if is_not_banned == nil then
          is_not_banned = false
        end
        if include_ban_pool and is_not_banned then
          table.insert(unremoved_perks, perk)
        end
      end
    end

    local ban_perk_number = math.random(#unremoved_perks)
    for index, perk in ipairs(unremoved_perks) do
      if index == ban_perk_number then
        ModSettingSet(perk.ban_state_name, true)
        ModSettingSet(perk.ban_key, true)
        last_selected_perk_path = perk.icon_path
      end
    end
    ban_count()
  end

  GuiText(gui, 0, 0, "-------------------------")

  if GuiButton(gui, remove_all_perk_button_id, 0, 0, ">Ban All Perks") then
    for _, row in ipairs(perk_gui_rows) do
      for _, perk in ipairs(row) do
        ModSettingSet(perk.ban_state_name, true)
        ModSettingSet(perk.ban_key, true)
      end
    end
    ban_count()
  end
  if GuiButton(gui, add_all_perk_button_id, 0, 0, ">Unban All Perks") then
    for _, row in ipairs(perk_gui_rows) do
      for _, perk in ipairs(row) do
        ModSettingSet(perk.ban_state_name, false)
        ModSettingSet(perk.ban_key, false)
      end
    end
    ban_count()
  end

  if GuiButton(gui, swap_perk_button_id, 0, 0, ">Swap Banned/Unbanned Perks") then
    for _, row in ipairs(perk_gui_rows) do
      for _, perk in ipairs(row) do
        local ban_state = ModSettingGet(perk.ban_state_name)
        if ban_state == nil then
          ban_state = false
        end
        ModSettingSet(perk.ban_state_name, not ban_state)

        local ban_key = ModSettingGet(perk.ban_key)
        if ban_key == nil then
          ban_key = false
        end
        ModSettingSet(perk.ban_key, not ban_key)
      end
    end
    ban_count()
  end

  perk_icon(gui)

  GuiLayoutEnd(gui)
  GuiEndScrollContainer(gui)
  GuiLayoutEndLayer(gui)
end
---------------------------------------------------------



---------------------------------------------------------
-- Park Ban Pool List
local function draw_perk_ban_pool_box(gui, main_menu_widget_info)
  local screen_width, screen_height = GuiGetScreenDimensions(gui)

  GuiLayoutBeginLayer(gui)
  local perk_width = (screen_width / 5) - (screen_width / 150)
  local perk_x = main_menu_widget_info.x - perk_width - 16
  GuiBeginScrollContainer(
    gui, perk_scroll_container_id, perk_x, main_menu_widget_info.y, perk_width, 277)
  GuiLayoutBeginVertical(gui, 0, 0)

  -- In Box rendering
  GuiText(gui, 0, 0, "[2]Perk Ban Pool List")
  GuiText(gui, 0, 0, "=========================")
  if GuiButton(gui, add_all_perk_button_id, 0, 0, ">Include All Perks") then
    for _, row in ipairs(perk_gui_rows) do
      for _, perk in ipairs(row) do
        ModSettingSet(perk.ban_pool_key, true)
        ModSettingSet(perk.ban_pool_state_name, true)
      end
    end
  end

  if GuiButton(gui, remove_all_perk_button_id, 0, 0, ">Exclude All Perks") then
    for _, row in ipairs(perk_gui_rows) do
      for _, perk in ipairs(row) do
        ModSettingSet(perk.ban_pool_key, false)
        ModSettingSet(perk.ban_pool_state_name, false)
      end
    end
  end

  perk_pool_icon(gui)

  GuiLayoutEnd(gui)
  GuiEndScrollContainer(gui)
  GuiLayoutEndLayer(gui)
end
---------------------------------------------------------



---------------------------------------------------------
-- Spell Pool List
local function draw_spell_ban_box(gui, main_menu_widget_info)
  local screen_width, screen_height = GuiGetScreenDimensions(gui)

  GuiLayoutBeginLayer(gui)
  local spell_width = (screen_width / 5) - (screen_width / 160)
  local spell_x = main_menu_widget_info.x + main_menu_widget_info.w + 4
  GuiBeginScrollContainer(gui, spell_scroll_container_id, spell_x, main_menu_widget_info.y,
    spell_width, 277)
  GuiLayoutBeginVertical(gui, 0, 0)

  -- In Box rendering
  GuiText(gui, 0, 0, "[1]Spell Ban List")
  GuiText(gui, 0, 0, "Banned Spells: " .. spell_ban_count)
  GuiLayoutBeginHorizontal(gui, 0, 0, false, 3);
  GuiText(gui, 0, 3, "Last Banned Spell:")
  if is_empty_last_spell() then
    GuiImage(gui, 321321, 0, 0, last_selected_spell_path, 0, 1)
  else
    GuiImage(gui, 321322, 0, 0, last_selected_spell_path, 1, 1)
  end
  GuiLayoutEnd(gui)
  GuiText(gui, 0, 0, "=========================")

  if GuiButton(gui, remove_random_spell_button_id, 0, 0, ">Ban Random Spells") then
    local unremoved_spells = {}
    for _, row in ipairs(spell_gui_rows) do
      for _, spell in ipairs(row) do
        local include_ban_pool = ModSettingGet(spell.ban_pool_key)
        if include_ban_pool == nil then
          include_ban_pool = true
        end
        local is_not_banned = not ModSettingGet(spell.ban_key)
        if is_not_banned == nil then
          is_not_banned = false
        end
        if include_ban_pool and is_not_banned then
          table.insert(unremoved_spells, spell)
        end
      end
    end

    local ban_spell_number = math.random(#unremoved_spells)
    for index, spell in ipairs(unremoved_spells) do
      if index == ban_spell_number then
        ModSettingSet(spell.ban_state_name, true)
        ModSettingSet(spell.ban_key, true)
        last_selected_spell_path = spell.icon_path
      end
    end
    ban_count()
  end

  GuiText(gui, 0, 0, "-------------------------")

  if GuiButton(gui, remove_all_spell_button_id, 0, 0, ">Ban All Spells") then
    for _, row in ipairs(spell_gui_rows) do
      for _, spell in ipairs(row) do
        ModSettingSet(spell.ban_state_name, true)
        ModSettingSet(spell.ban_key, true)
      end
    end
    ban_count()
  end
  if GuiButton(gui, add_all_spell_button_id, 0, 0, ">Unban All Spells") then
    for _, row in ipairs(spell_gui_rows) do
      for _, spell in ipairs(row) do
        ModSettingSet(spell.ban_state_name, false)
        ModSettingSet(spell.ban_key, false)
      end
    end
    ban_count()
  end

  if GuiButton(gui, swap_spell_button_id, 0, 0, ">Swap Banned/Unbanned Spells") then
    for _, row in ipairs(spell_gui_rows) do
      for _, spell in ipairs(row) do
        local ban_state = ModSettingGet(spell.ban_state_name)
        if ban_state == nil then
          ban_state = false
        end
        ModSettingSet(spell.ban_state_name, not ban_state)

        local ban_key = ModSettingGet(spell.ban_key)
        if ban_key == nil then
          ban_key = false
        end
        ModSettingSet(spell.ban_key, not ban_key)
      end
    end
    ban_count()
  end


  spell_icon(gui)

  GuiLayoutEnd(gui)
  GuiEndScrollContainer(gui)
  GuiLayoutEndLayer(gui)
end
---------------------------------------------------------



---------------------------------------------------------
-- Spell Ban Pool List
local function draw_spell_ban_pool_box(gui, main_menu_widget_info)
  local screen_width, screen_height = GuiGetScreenDimensions(gui)

  GuiLayoutBeginLayer(gui)
  local spell_width = (screen_width / 5) - (screen_width / 160)
  local spell_x = main_menu_widget_info.x + main_menu_widget_info.w + 4
  GuiBeginScrollContainer(gui, spell_scroll_container_id, spell_x, main_menu_widget_info.y,
    spell_width, 277)
  GuiLayoutBeginVertical(gui, 0, 0)

  -- In Box rendering
  GuiText(gui, 0, 0, "[2]Spell Ban Pool List")
  GuiText(gui, 0, 0, "=========================")
  if GuiButton(gui, add_all_spell_button_id, 0, 0, ">Include All Spells") then
    for _, row in ipairs(spell_gui_rows) do
      for _, spell in ipairs(row) do
        ModSettingSet(spell.ban_pool_key, true)
        ModSettingSet(spell.ban_pool_state_name, true)
      end
    end
  end

  if GuiButton(gui, remove_all_spell_button_id, 0, 0, ">Exclude All Spells") then
    for _, row in ipairs(spell_gui_rows) do
      for _, spell in ipairs(row) do
        ModSettingSet(spell.ban_pool_key, false)
        ModSettingSet(spell.ban_pool_state_name, false)
      end
    end
  end

  spell_pool_icon(gui)

  GuiLayoutEnd(gui)
  GuiEndScrollContainer(gui)
  GuiLayoutEndLayer(gui)
end
---------------------------------------------------------



---------------------------------------------------------
-- Danger Announce
local announced = ModSettingGet(VALUES.DANGER_ANNOUNCE)
if announced == nil then
  announced = false
end
local function draw_danger_announce(gui)
  if GameGetFrameNum() ~= 0 and (not announced) then
    local line_1 = ''
    local line_2 = ''
    local yes = ''

    local screen_width, screen_height = GuiGetScreenDimensions(gui)
    if language() == "ja" then
      line_1 = 'ゲームプレイ中で既に Noita 世界に生成されているスペル/パークをBANすると、'
      line_2 = '生成されているスペル/パークが使用できなくなる可能性があります'
      yes = '>理解しました'
    else
      line_1 = 'If you ban an already generated perk or spell during gameplay,'
      line_2 = 'perk or spell may no longer be available.'
      yes = '>OK'
    end

    GuiZSetForNextWidget(gui, 150)
    GuiText(gui, 0, 0, yes)
    local _, _, _, _, _, text_width = GuiGetPreviousWidgetInfo(gui)
    GuiLayoutBeginLayer(gui)
    GuiBeginAutoBox(gui)
    GuiLayoutBeginVertical(gui, 0, 0)
    GuiZSetForNextWidget(gui, -150)
    GuiTextCentered(gui, (screen_width / 2), (screen_height / 2) - 20, line_1)
    GuiZSetForNextWidget(gui, -150)
    GuiTextCentered(gui, (screen_width / 2), 0, line_2)
    GuiZSetForNextWidget(gui, -150)
    if GuiButton(gui, 13132313213324, (screen_width / 2) - (text_width / 2), 0, yes) then
      announced = true
      ModSettingSet(VALUES.DANGER_ANNOUNCE, announced)
    end
    GuiLayoutEnd(gui)
    GuiEndAutoBoxNinePiece(gui)
    GuiLayoutEndLayer(gui)
    GuiZSet(gui, 0)
  end
end
---------------------------------------------------------



---------------------------------------------------------
-- executer
-- this variables set when initialized
local main_menu_widget_info = {
  x = 0,
  y = 0,
  w = 0,
  h = 0,
}
function ModSettingsGui(gui, in_main_menu)
  mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)

  -- HACK: 一時的にMainウィンドウと同じサイズの画像ウィンドウを生成して、メインウィンドウの大きさを取得する
  local screen_width, screen_height = GuiGetScreenDimensions(gui)
  local main_menu_x = (screen_width / 2) - (354 / 2) - 2
  local main_menu_y = (screen_height / 2) / 4.2
  GuiZSet(gui, 100)
  GuiLayoutBeginLayer(gui)
  GuiImageNinePiece(gui, dummy_ui_id, main_menu_x, main_menu_y, 354, 283, 0)
  _, _, _,
  main_menu_widget_info.x,
  main_menu_widget_info.y,
  main_menu_widget_info.w,
  main_menu_widget_info.h
  = GuiGetPreviousWidgetInfo(gui)
  GuiLayoutEndLayer(gui)
  GuiZSet(gui, 0)

  draw_danger_announce(gui)

  if perk_gui_id == VALUES.PERK_GUI.BAN_SELECT then
    draw_perk_ban_box(gui, main_menu_widget_info)
  elseif perk_gui_id == VALUES.PERK_GUI.BAN_POOL then
    draw_perk_ban_pool_box(gui, main_menu_widget_info)
  end

  if spell_gui_id == VALUES.SPELL_GUI.BAN_SELECT then
    draw_spell_ban_box(gui, main_menu_widget_info)
  elseif spell_gui_id == VALUES.SPELL_GUI.BAN_POOL then
    draw_spell_ban_pool_box(gui, main_menu_widget_info)
  end
end
