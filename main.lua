local Config = {
    Save = { File = "LuiSave.json", AutoPlayerInfo = true },
    Keybind = { ToggleUI = "RightShift" },
    Keysystem = { Enabled = true, Key = "prolokmn", Multiplier = 7 }
}
local Init = require(script.ui.init)
local Debug = require(script.ui.debug)

Debug:Log("Starting Lui Universal UI Lib")

local window = Init:Start() -- creates demo UI
Debug:Log("UI Loaded")
