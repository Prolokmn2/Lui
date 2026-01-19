local Config = require(script.config.config)
local Init = require(script.ui.init)
local Debug = require(script.ui.debug)

Debug:Log("Starting Lui Universal UI Lib")

local window = Init:Start() -- creates demo UI
Debug:Log("UI Loaded")
