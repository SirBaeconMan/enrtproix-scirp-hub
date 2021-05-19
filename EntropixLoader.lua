local LocalPlayer = game:GetService("Players").LocalPlayer
local PlacesSupported = {"2788229376", "6751371363"}
--[[
	Games supported:
	2788229376 - Da Hood
	6751371363 - Bubble Gum Simulator
]]
local Exploit = ""
if syn then
	Exploit = "Synapse"
else
	Exploit = "NotSynapse"
end

local PlaceId = tostring(game.PlaceId)
if table.find(PlacesSupported, PlaceId) == nil then
	LocalPlayer:Kick("Game not supported by AmogHub! Find a supported list in the discord: .gg/gSvqAMCw7s")
elseif PlaceId == "2788229376" then
	print("Game: Da Hood")
	
end