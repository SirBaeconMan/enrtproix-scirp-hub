warn("Entropix for Bubble Gum Simulator Loading...")
local Flux = loadstring(game:HttpGet("https://entropix.000webhostapp.com/ui-lib.lua"))()
local LocalPlayer = game:GetService("Players").LocalPlayer
local LocalChar = LocalPlayer.Character
local LocalHRP = LocalChar.HumanoidRootPart

local function Autofarm()
	LocalHRP.CFrame = CFrame.new(-150, 46, -160)
	while not LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("BubbleFull") do
		game:GetService("ReplicatedStorage").NetworkRemoteEvent:FireServer("BlowBubble")
		wait(1)
	end
	wait(1)
	LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("BubbleFull").Visible = false
	LocalHRP.CFrame = CFrame.new(-154, 46, -151)
end
print("Loaded! Enjoy. (made by amogus gaming#7548)")

local Window = Flux:Window("Entropix", "Game: Bubble Gum Simulator", Color3.fromRGB(255, 110, 48), Enum.KeyCode.RightShift)
local LoadedNotif = Flux:Notification("Welcome to Entropix! Detected game: Bubble Gum Simulator", "OK")

local AutofarmTab = Window:Tab("Autofarm", "rbxassetid://0")

AutofarmTab:Button("Autofarm", "Get Rich Quick With One Click", function()
	while true do
		Autofarm()
		wait(2)
	end
end)

AutofarmTab:Button("Stop Autofarm", "Stop Becoming Very Rich With Lots Of Money", function()
	LocalChar.Humanoid.Health = 0
end)

local PetsTab = Window:Tab("Pets", "rbxassetid://0")

PetsTab:Label("Pets tab coming soon, expect things like autobuy and dupe ;)")