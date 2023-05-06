dofile("data/scripts/lib/mod_settings.lua")

local noita_remover_description = "DON'T FORGET TO PRESS THE ADAPT BUTTON UNDER SETTINGS!\n \n" ..
    "==How to use==" .. "\n" ..
    "You can ban from left and right window.\n" ..
    "left is perks, rihgt is spells.\n \n" ..

    "==Important==" .. "\n" ..
    "Excluding all perks/all spells is not expected on Noita's part.\n" ..
    "For example, if you exclude all perks, \nthe progress display will be incorrect and an internal error will occur \n(Noita will not crash).\n" ..
    "Please note that unforeseen events may occur.\n"

local mod_id = "noita-remover" -- This should match the name of your mod's folder.
mod_settings_version = 1       -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
  {
    id = "noita-remover-description",
    ui_name = noita_remover_description,
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
