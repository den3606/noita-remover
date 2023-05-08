dofile("data/scripts/lib/mod_settings.lua")
dofile_once("data/scripts/perks/perk_list.lua")
dofile_once("data/scripts/gun/gun_actions.lua")



---------------------------------------------------------
-- VALUES
local VALUES = {
  MOD_NAME = 'noita-remover',
  GLOBAL_GUI_ID_KEY = 'noita-remover.global-gui-id-key',
  PERK_BAN_PREFIX = 'noita-remover.perk-ban.',
  PERK_BAN_POOL_PREFIX = 'noita-remover.perk-ban-pool.',
  SPELL_BAN_PREFIX = 'noita-remover.spell-ban.',
  PERK_GUI = {
    BAN_SELECT = 'perk_ban',
    BAN_POOL = 'perk_ban_pool',
  }
}
---------------------------------------------------------



---------------------------------------------------------
-- Localise
local function description()
  local noita_remover_description_en = "DON'T FORGET TO PRESS THE ADAPT BUTTON UNDER SETTINGS!\n \n" ..
      "==Important==" .. "\n" ..
      "Excluding all perks/spells is not expected on Noita's part.\n" ..
      "For example, if you exclude all perks, \nthe progress display will be incorrect and an internal error will occur \n(Noita will not crash).\n" ..
      "Please note that unforeseen events may occur.\n" ..
      "==How to use==" .. "\n" ..
      "You can ban from left and right window.\n" ..
      "Left is perks, rihgt is spells.\n" ..
      "Ban perks/spells are enabled when Noita initialized (start new game).\n" ..
      "Banned items will be darkened. Unbanned items will be brighter.\n \n" ..
      "==Random BAN==" .. "\n" ..
      "By default, a random draw is made among all Perk/Spells.\n" ..
      "You can select Spell/Perk for the Random BAN \nby changing the GUI from the Selected GUI in the main window.\n" ..
      "(\"Perk Ban Pool List\" window).\n" ..
      "In this window, Perks targeted for BAN are brightly displayed.\n \n"

  local noita_remover_description_ja = "==はじめに==\n下にある「適応して戻る」ボタンを押すのを忘れないでください\n \n" ..
      "== 重要事項 ==" .. "\n" ..
      "全てのパーク、スペルを除外されることを Noita 側は想定していません。\n" ..
      "例えば、全てのパークを除外すると、\nメニューを開いたときや進行を確認したときに裏でエラーがでます\n（Noita 自体は落ちないのでそこは大丈夫です）。\n" ..
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

  if GameTextGet("$current_language") == "English" then
    return noita_remover_description_en
  end
  if GameTextGet("$current_language") == "日本語" then
    return noita_remover_description_ja
  end
  return noita_remover_description_en
end
---------------------------------------------------------



---------------------------------------------------------
-- Current GUI ID

local perk_gui_id = VALUES.PERK_GUI.BAN_SELECT
local function switch_gui_callback(mod_id, gui, in_main_menu, setting, old_value, new_value)
  perk_gui_id = new_value
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
        id = "current_gui",
        ui_name = ">Selected GUI",
        ui_description = "The selected GUI is displayed on the left.",
        value_default = VALUES.PERK_GUI.BAN_SELECT,
        values = { { VALUES.PERK_GUI.BAN_SELECT, "Perk Ban List" },
          { VALUES.PERK_GUI.BAN_POOL,   "Perk Ban Pool List" } },
        scope = MOD_SETTING_SCOPE_RUNTIME,
        change_fn = switch_gui_callback, -- Called when the user interact with the settings widget.
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

  if GameTextGet("$current_language") == "English" then
    for i = 0, math.floor(w / 4) do
      blank = blank .. ' '
    end
  end
  if GameTextGet("$current_language") == "日本語" then
    for i = 0, math.floor(w / 2) do
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

  if GameTextGet("$current_language") == "English" then
    for i = 0, math.floor(w / 4) do
      blank = blank .. ' '
    end
  end
  if GameTextGet("$current_language") == "日本語" then
    for i = 0, math.floor(w / 2) do
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
-- perk_ui.lua

local perk_scroll_container_id = NewID()
local remove_all_perk_button_id = NewID()
local add_all_perk_button_id = NewID()
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
local remove_random_spell_button_id = NewID()

local spell_gui_rows = {}
local spell_row = {}

for i = 1, #actions do
  table.insert(spell_row, {
    key = VALUES.SPELL_BAN_PREFIX .. actions[i].id,
    image_id = NewID(),
    button_id = NewID(),
    icon_path = actions[i].sprite,
    state_name = VALUES.SPELL_BAN_PREFIX .. actions[i].sprite,
    banned_fn = function()
      ModSettingSet(VALUES.SPELL_BAN_PREFIX .. actions[i].id, true)
      ban_count()
      last_selected_spell_path = actions[i].sprite
    end,
    unbanned_fn = function()
      ModSettingSet(VALUES.SPELL_BAN_PREFIX .. actions[i].id, false)
      ban_count()
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
      GuiToggleImageDisableButton(gui, spell.image_id, spell.button_id, spell.icon_path,
        spell.state_name,
        spell.unbanned_fn, spell.banned_fn)
    end

    GuiLayoutEnd(gui)
  end
end
---------------------------------------------------------



---------------------------------------------------------
-- perk_ui.lua MAIN PROCESS
local function draw_perk_ban_box(gui)
  local screen_width, screen_height = GuiGetScreenDimensions(gui)
  local main_menu_x = (screen_width / 2) / 2.27
  local main_menu_y = (screen_height / 2) / 4.2

  GuiLayoutBeginLayer(gui)
  local perk_width = (screen_width / 5) - (screen_width / 150)
  local perk_x = main_menu_x - (perk_width + perk_width / 8)
  GuiBeginScrollContainer(gui, perk_scroll_container_id, perk_x, main_menu_y, perk_width, 277)
  GuiLayoutBeginVertical(gui, 0, 0)

  -- In Box rendering
  GuiText(gui, 0, 0, "Perk Ban List")
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
  perk_icon(gui)

  GuiLayoutEnd(gui)
  GuiEndScrollContainer(gui)
  GuiLayoutEndLayer(gui)
end
---------------------------------------------------------



local function draw_perk_ban_pool_box(gui)
  local screen_width, screen_height = GuiGetScreenDimensions(gui)
  local main_menu_x = (screen_width / 2) / 2.27
  local main_menu_y = (screen_height / 2) / 4.2

  GuiLayoutBeginLayer(gui)
  local perk_width = (screen_width / 5) - (screen_width / 150)
  local perk_x = main_menu_x - (perk_width + perk_width / 8)
  GuiBeginScrollContainer(gui, perk_scroll_container_id, perk_x, main_menu_y, perk_width, 277)
  GuiLayoutBeginVertical(gui, 0, 0)

  -- In Box rendering
  GuiText(gui, 0, 0, "Perk Ban Pool List")
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
-- spell_ui.lua MAIN PROCESS
local function draw_spell_ban_box(gui)
  local screen_width, screen_height = GuiGetScreenDimensions(gui)
  local main_menu_x = (screen_width / 2) / 2.27
  local main_menu_y = (screen_height / 2) / 4.2

  GuiLayoutBeginLayer(gui)
  local spell_width = (screen_width / 5) - (screen_width / 160)
  local spell_x = main_menu_x + (spell_width * 3 - spell_width / 9)
  GuiBeginScrollContainer(gui, spell_scroll_container_id, spell_x, main_menu_y, spell_width, 276)
  GuiLayoutBeginVertical(gui, 0, 0)

  -- In Box rendering
  GuiText(gui, 0, 0, "Spell Ban List")
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
        if (not ModSettingGet(spell.key)) or false then
          table.insert(unremoved_spells, spell)
        end
      end
    end

    local ban_spell_number = math.random(#unremoved_spells)
    for index, spell in ipairs(unremoved_spells) do
      if index == ban_spell_number then
        ModSettingSet(spell.state_name, true)
        ModSettingSet(spell.key, true)
        last_selected_spell_path = spell.icon_path
      end
    end
    ban_count()
  end

  GuiText(gui, 0, 0, "-------------------------")

  if GuiButton(gui, remove_all_spell_button_id, 0, 0, ">Ban All Spells") then
    for _, row in ipairs(spell_gui_rows) do
      for _, spell in ipairs(row) do
        ModSettingSet(spell.state_name, true)
        ModSettingSet(spell.key, true)
      end
    end
    ban_count()
  end
  if GuiButton(gui, add_all_spell_button_id, 0, 0, ">Unban All Spells") then
    for _, row in ipairs(spell_gui_rows) do
      for _, spell in ipairs(row) do
        ModSettingSet(spell.state_name, false)
        ModSettingSet(spell.key, false)
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



function ModSettingsGui(gui, in_main_menu)
  mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)

  if perk_gui_id == VALUES.PERK_GUI.BAN_SELECT then
    draw_perk_ban_box(gui)
  elseif perk_gui_id == VALUES.PERK_GUI.BAN_POOL then
    draw_perk_ban_pool_box(gui)
  end

  draw_spell_ban_box(gui)
end
