dofile("data/scripts/lib/mod_settings.lua")

local function description()
  local noita_remover_description_en = "DON'T FORGET TO PRESS THE ADAPT BUTTON UNDER SETTINGS!\n \n" ..
      "==How to use==" .. "\n" ..
      "You can ban from left and right window.\n" ..
      "left is perks, rihgt is spells.\n" ..
      "Ban perks/spells are enabled when Noita initialized (start new game).\n \n" ..
      "==Important==" .. "\n" ..
      "Excluding all perks/spells is not expected on Noita's part.\n" ..
      "For example, if you exclude all perks, \nthe progress display will be incorrect and an internal error will occur \n(Noita will not crash).\n" ..
      "Please note that unforeseen events may occur.\n"

  local noita_remover_description_ja = "！下にある「適応して戻る」ボタンを押すのを忘れないでください！\n \n" ..
      "== 使い方 ==" .. "\n" ..
      "左右にある枠より設定が可能です。\n" ..
      "左にはパーク、右にはパークの設定があります。\n" ..
      "BAN したパーク、スペルは Noita を再起動したときに適応されます\n（新規ゲームを始めたとき）\n \n" ..
      "== 重要事項 ==" .. "\n" ..
      "全てのパーク、スペルを除外されることを Noita 側は想定していません。\n" ..
      "例えば、全てのパークを除外すると、メニューを開いたときや進行を確認したときに\n裏でエラーがでます（Noita 自体は落ちないのでそこは大丈夫です）。\n" ..
      "想定外の事象が発生する可能性があることにご留意ください。\n"

  if GameTextGet("$current_language") == "English" then
    return noita_remover_description_en
  end
  if GameTextGet("$current_language") == "日本語" then
    return noita_remover_description_ja
  end
  return noita_remover_description_en
end

local mod_id = "noita-remover" -- This should match the name of your mod's folder.
mod_settings_version = 1       -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
  {
    id = "noita-remover-description",
    ui_name = description(),
    not_setting = true,
  },
}

function ModSettingsUpdate(init_scope)
  local old_version = mod_settings_get_version(mod_id)
  mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
  return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui(gui, in_main_menu)
  mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)

  local perk_ui = dofile_once("mods/noita-remover/files/scripts/ui/perk_ui.lua")
  perk_ui.start(gui)

  local spell_ui = dofile_once("mods/noita-remover/files/scripts/ui/spell_ui.lua")
  spell_ui.start(gui)
end
