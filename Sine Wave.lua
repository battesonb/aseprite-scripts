--[[
Sine Wave

Creates a configurable sine wave. Select the pencil tool if your pencil is configured with a large brush size.

Author: Byron Batteson
Date: 2024-06-05
--]]

if not app.isUIAvailable then
    return
end

local dialog = Dialog("Sine wave")
dialog:slider { id="amplitude", label="Amplitude", value=5, min=1, max=100 }
dialog:number { id="period", label="Period", text="30", decimals=0 }
dialog:number { id="repetitions", label="Repetitions", text="2", decimals=0 }
dialog:button { text="&Close" }

local info = function()
  print("Sine Wave")
  print(" ")
  print("Creates a configurable sine wave. Select the pencil tool if your pencil is configured with a large brush size.")
  print(" ")
  print("Author: Byron Batteson")
  print("Date: 2024-06-05")
end

local run = function()
  local spr = app.activeSprite
  if not spr then return app.alert "There is no active sprite" end

  app.transaction(function ()
    local amplitude = dialog.data.amplitude
    local period = dialog.data.period
    local repetitions = dialog.data.repetitions
    local new_layer = spr:newLayer()
    new_layer.name = "Wave"

    local points = {}
    for i=1,period*repetitions do
      local y = amplitude * math.sin(2 * math.pi * ((i-1) / period)) + amplitude + app.brush.size // 2
      points[i] = Point(i-1, y)
    end

    app.useTool{
      tool="pencil",
      points=points,
      layer=new_layer,
    }
  end)

  app.refresh()
end

dialog:button { id="info", text="&Info", onclick=info }
dialog:button { id="run", text="&Run", focus=true, onclick=run }

dialog:show { wait=false }
