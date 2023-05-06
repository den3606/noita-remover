local function start(gui)
  dofile_once("mods/noita-remover/files/scripts/ui/gui_utils.lua")
  dofile_once("data/scripts/perks/perk_list.lua")

  local screen_width, screen_height = GuiGetScreenDimensions(gui)
  local im_id = 1344314343324224231

  GuiLayoutBeginLayer(gui)
  -- GuiBeginAutoBox(gui)
  -- GuiZSet(gui, 10)
  -- GuiZSetForNextWidget(gui, 11)
  -- GuiText(gui, 50, 50, "Gui*AutoBox*")
  -- GuiImage(gui, im_id, 60, 60, "data/ui_gfx/game_over_menu/game_over.png", 1, 1, 0)
  -- GuiZSetForNextWidget(gui, 13)
  -- GuiImage(gui, im_id, 60, 150, "data/ui_gfx/game_over_menu/game_over.png", 1, 1, 0, math.pi)
  -- GuiZSetForNextWidget(gui, 12)
  -- GuiEndAutoBoxNinePiece(gui)

  -- GuiZSetForNextWidget(gui, 11)
  -- GuiImageNinePiece(gui, 12368912341, 10, 10, 80, 20)
  -- GuiText(gui, 15, 15, "GuiImageNinePiece")

  --[[
      right
    ]]
  GuiBeginScrollContainer(gui, 34511, 500, 42, 125, 278)
  GuiLayoutBeginVertical(gui, 0, 0)
  GuiText(gui, 0, 0, "Spell Ban List")
  GuiLayoutBeginHorizontal(gui, 0, 0, false, 3);

  if GuiButton(gui, im_id + 123222, 0, 3, '        ') then
    remove3 = not remove3
  end
  if remove3 then
    GuiImage(gui, im_id + 1321312332, -16, 0, perk_list[1].perk_icon, 1, 1)
  else
    GuiImage(gui, im_id + 1321312332, -16, 0, perk_list[1].perk_icon, 0.3, 1)
  end



  local w, h = GuiGetImageDimensions(gui, perk_list[1].perk_icon, 1)

  local blank = ''
  for i = 0, math.floor(w / 2) do
    blank = blank .. ' '
  end

  local button_id = 213
  local image_id = 3213
  if GuiButton(gui, button_id, 0, h / 4, blank) then
    remove4 = not remove4
  end
  if remove4 then
    GuiImage(gui, image_id, -16, 0, perk_list[1].perk_icon, 1, 1)
  else
    GuiImage(gui, image_id, -16, 0, perk_list[1].perk_icon, 0.3, 1)
  end


  GuiLayoutEnd(gui)
  GuiImage(gui, im_id, 60, 150, "data/ui_gfx/game_over_menu/game_over.png", 1, 1, 0, math.pi)
  GuiImage(gui, im_id, 60, 150, "data/ui_gfx/game_over_menu/game_over.png", 1, 1, 0, math.pi)
  GuiEndScrollContainer(gui)
  GuiLayoutEndLayer(gui)
end

return {
  start = start
}
