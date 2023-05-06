dofile_once("mods/noita-remover/files/scripts/ui/gui_utils.lua")
dofile("data/scripts/gun/gun_actions.lua")
local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")

local scroll_container_id = NewID()
local remove_all_spell_button_id = NewID()
local add_all_spell_button_id = NewID()

local spell_gui_rows = {}
local spell_row = {}

for i = 1, #actions do
  table.insert(spell_row, {
    key = VALUES.MOD_NAME .. actions[i].id,
    image_id = NewID(),
    button_id = NewID(),
    icon_path = actions[i].sprite,
    state_name = VALUES.MOD_NAME .. actions[i].sprite,
    active_fn = function()
      ModSettingSet(VALUES.MOD_NAME .. actions[i].id, true)
    end,
    deactive_fn = function()
      ModSettingSet(VALUES.MOD_NAME .. actions[i].id, false)
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
      GuiToggleImageButton(gui, spell.image_id, spell.button_id, spell.icon_path, spell.state_name,
        spell.active_fn, spell.deactive_fn)
    end

    GuiLayoutEnd(gui)
  end
end

local function start(gui)
  GuiLayoutBeginLayer(gui)
  GuiBeginScrollContainer(gui, scroll_container_id, 500, 42, 125, 278)
  GuiLayoutBeginVertical(gui, 0, 0)

  -- In Box rendering
  GuiText(gui, 0, 0, "Spell Ban List")
  GuiText(gui, 0, 0, "=========================")
  if GuiButton(gui, remove_all_spell_button_id, 0, 0, "Ban All spells") then
    for _, row in ipairs(spell_gui_rows) do
      for _, spell in ipairs(row) do
        ModSettingSet(spell.state_name, true)
        ModSettingSet(spell.key, true)
      end
    end
  end
  if GuiButton(gui, add_all_spell_button_id, 0, 0, "Unban All spells") then
    for _, row in ipairs(spell_gui_rows) do
      for _, spell in ipairs(row) do
        ModSettingSet(spell.state_name, false)
        ModSettingSet(spell.key, false)
      end
    end
  end
  spell_icon(gui)

  GuiLayoutEnd(gui)
  GuiEndScrollContainer(gui)
  GuiLayoutEndLayer(gui)
end

return {
  start = start
}
