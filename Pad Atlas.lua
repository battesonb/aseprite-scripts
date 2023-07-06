--[[
Pad Atlas

Adds padding to an atlas with the provided dimensions by a given pixel count.

Author: Byron Batteson
Date: 2023-07-06
--]]

if not app.isUIAvailable then
    return
end

local dialog = Dialog("Atlas padding")
dialog:number { id="tile_x", label="Horizontal tile size", text="8", decimals=0 }
dialog:number { id="tile_y", label="Vertical tile size", text="8", decimals=0 }
dialog:slider { id="padding_x", label="Horizontal padding", value=1, min=0, max=20 }
dialog:slider { id="padding_y", label="Vertical padding", value=0, min=0, max=20 }
dialog:button { text="&Close" }

local info = function()
  print("Pad Atlas")
  print(" ")
  print("Adds padding to an atlas with the provided dimensions by a given pixel count.")
  print(" ")
  print("Author: Byron Batteson")
  print("Date: 2023-07-06")
end

local pad = function()
  app.transaction(function ()
    local tile_x = dialog.data.tile_x
    local tile_y = dialog.data.tile_y
    local padding_x = dialog.data.padding_x
    local padding_y = dialog.data.padding_y
    local sprite = app.sprite
    local tiles_in_x = sprite.width / tile_x
    local tiles_in_y = sprite.height / tile_y
    local new_width = sprite.width + (tiles_in_x-1) * padding_x
    local new_height = sprite.height + (tiles_in_y-1) * padding_y
    sprite.width = new_width
    sprite.height = new_height

    if padding_x > 0 then
      for i = tiles_in_x-1, 1, -1 do
        sprite.selection = Selection(Rectangle(i * tile_x, 0, tile_x, new_height))
        local quantity = i * padding_x
        app.command.MoveMask{
          target="content",
          wrap=false,
          direction="right",
          units="pixel",
          quantity=quantity
        }
        app.command.DeselectMask()
      end
    end

    if padding_y > 0 then
      for j = tiles_in_y-1, 1, -1 do
        sprite.selection = Selection(Rectangle(0, j * tile_y, new_width, tile_y))
        local quantity = j * padding_y
        app.command.MoveMask{
          target="content",
          wrap=false,
          direction="down",
          units="pixel",
          quantity=quantity
        }
        app.command.DeselectMask()
      end
    end
  end)

  app.refresh()
end

dialog:button { id="info", text="&Info", onclick=info }
dialog:button { id="info", text="&Run", focus=true, onclick=pad }

dialog:show { wait=false }
