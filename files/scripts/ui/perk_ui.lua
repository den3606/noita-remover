dofile_once("mods/noita-remover/files/scripts/ui/gui_utils.lua")
dofile_once("data/scripts/perks/perk_list.lua")
local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")

local scroll_container_id = NewID()
local remove_all_perk_button_id = NewID()
local add_all_perk_button_id = NewID()

local perk_gui_rows = {}
local perk_row = {}

for i = 1, #perk_list do
  table.insert(perk_row, {
    key = VALUES.MOD_NAME .. perk_list[i].id,
    image_id = NewID(),
    button_id = NewID(),
    icon_path = perk_list[i].perk_icon,
    state_name = VALUES.MOD_NAME .. perk_list[i].perk_icon,
    active_fn = function()
      ModSettingSet(VALUES.MOD_NAME .. perk_list[i].id, true)
    end,
    deactive_fn = function()
      ModSettingSet(VALUES.MOD_NAME .. perk_list[i].id, false)
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
      GuiToggleImageButton(gui, perk.image_id, perk.button_id, perk.icon_path, perk.state_name,
        perk.active_fn, perk.deactive_fn)
    end

    GuiLayoutEnd(gui)
  end
end

local function start(gui)
  GuiLayoutBeginLayer(gui)
  GuiBeginScrollContainer(gui, scroll_container_id, 2, 42, 125, 278)
  GuiLayoutBeginVertical(gui, 0, 0)

  -- In Box rendering
  GuiText(gui, 0, 0, "Perk Ban List")
  GuiText(gui, 0, 0, "=========================")
  if GuiButton(gui, remove_all_perk_button_id, 0, 0, "Ban All Perks") then
    for _, row in ipairs(perk_gui_rows) do
      for _, perk in ipairs(row) do
        ModSettingSet(perk.state_name, true)
        ModSettingSet(perk.key, true)
      end
    end
  end
  if GuiButton(gui, add_all_perk_button_id, 0, 0, "Unban All Perks") then
    for _, row in ipairs(perk_gui_rows) do
      for _, perk in ipairs(row) do
        ModSettingSet(perk.state_name, false)
        ModSettingSet(perk.key, false)
      end
    end
  end
  perk_icon(gui)

  GuiLayoutEnd(gui)
  GuiEndScrollContainer(gui)
  GuiLayoutEndLayer(gui)
end

return {
  start = start
}
