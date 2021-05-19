-- i will never work on this again (i hate prison life)

local Flux = loadstring(game:HttpGet("https://entropix.000webhostapp.com/ui-lib.lua"))()
print("Loaded UI lib")

local OpenLib = loadstring(game:HttpGet("https://entropix.000webhostapp.com/OpenLib.lua"))
print("OpenLib loaded")

local Window = Flux:Window("Entropix", "Prison Life GUI", Color3.fromRGB(255, 110, 48), Enum.KeyCode.RightShift)
print("Loaded window")

local Player = game:GetService("Players").LocalPlayer
print("Defined player")
local Character = Player.Character
print("Defined character")

Flux:Notification("Welcome to Entropix V2!", "OK")
print("just sent the notification")

---------------
-- FUNCTIONS --
---------------

function Kill(plr)-- tiem to reverse code "made" by vapin
	local m_char = workspace:FindFirstChild(Player.Name)-- The current character you have
	local old_team = game.Players.LocalPlayer.TeamColor.Name-- The current team you're on
	local change_team = old_team == plr.TeamColor.Name-- Will you need to change team?

	game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)-- if you die then make a new character
		m_char = newChar 
		backpack = game.Players.LocalPlayer.Backpack 
	end)

	if change_team then-- if you need to change team then:
		local previous_position = m_char:WaitForChild("HumanoidRootPart",0.4).CFrame -- save your previous position before death
		workspace.Remote.loadchar:InvokeServer(nil, BrickColor.random().Name) -- invoke the loadchar remote, killing you
		m_char.HumanoidRootPart.CFrame = previous_position -- go to your previous position
		workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP) -- get a remington so you can commit mass genocide
	end

	local args = { -- the data for each bullet
			[1] = {
			["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
			["Distance"] = 0, 
			["Cframe"] = CFrame.new(), 
			["Hit"] = workspace[plr.Name].Head
		}, [2] = {
			["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
			["Distance"] = 0, 
			["Cframe"] = CFrame.new(), 
			["Hit"] = workspace[plr.Name].Head
		}, [3] = {
			["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
			["Distance"] = 0, 
			["Cframe"] = CFrame.new(), 
			["Hit"] = workspace[plr.Name].Head
		}, [4] = {
			["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
			["Distance"] = 0, 
			["Cframe"] = CFrame.new(), 
			["Hit"] = workspace[plr.Name].Head
		}, [5] = {
			["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
			["Distance"] = 0, 
			["Cframe"] = CFrame.new(), 
			["Hit"] = workspace[plr.Name].Head
		}, [6] = {
			["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
			["Distance"] = 0, 
			["Cframe"] = CFrame.new(), 
			["Hit"] = workspace[plr.Name].Head
		}, [7] = {
			["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
			["Distance"] = 0, 
			["Cframe"] = CFrame.new(), 
			["Hit"] = workspace[plr.Name].Head
		}, [8] = {
			["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
			["Distance"] = 0, 
			["Cframe"] = CFrame.new(), 
			["Hit"] = workspace[plr.Name].Head
		}
	}

	game:GetService("ReplicatedStorage").ShootEvent:FireServer(args, game.Players.LocalPlayer.Backpack["Remington 870"])-- fire the gun using the data for the bullets using the remington
end-- and that it

----------------------
-- LOCAL PLAYER TAB --
----------------------

local LocalPlayerTab = Window:Tab("Local Player", "rbxassetid://0")

LocalPlayerTab:Label("Rejoining")

LocalPlayerTab:Button("Rejoin", "Rejoins the server.", function()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

LocalPlayerTab:Button("Copy Join Script", "Copies a script that lets others join your game.", function()
	setclipboard([[game:GetService("TeleportService"):TeleportToPlaceInstance(]]..game.PlaceId..", "..game.JobId..")")
	Flux:Notification("Script copied successfully!", "OK")
end)

LocalPlayerTab:Label("Camera Options")

LocalPlayerTab:Slider("FOV", "Changes your field of view", 1, 120, 70, function(SliderValue)
	game.Workspace.CurrentCamera.FieldOfView = SliderValue
end)

LocalPlayerTab:Button("Reset FOV", "Resets your FOV to 70 (default)", function()
	game.Workspace.CurrentCamera.FieldOfView = 70
end)

LocalPlayerTab:Toggle("Fullbright", "Makes everything bright, like a night vision potion.", function(ToggleValue)
	if ToggleValue == true then
		game:GetService("RunService"):BindToRenderStep("Fullbright", function()
			game.Lighting.Brightness = 2
		end)
	else
		game:GetService("RunService"):UnbindFromRenderStep("Fullbright")
	end
end)

LocalPlayerTab:Toggle("Night Vision V", "When fullbright isn't enough.", function(ToggleValue)
	if ToggleValue == true then
		game:GetService("RunService"):BindToRenderStep("DiscordLightTheme", function()
			game.Lighting.Brightness = 10
			game.Lighting.ExposureCompensation = 5
			game.Lighting.Ambient = Color3.new(1,1,1)
			game.Lighting.OutdoorAmbient = Color3.new(1,1,1)
		end)
	else
		game:GetService("RunService"):UnbindFromRenderStep("DiscordLightTheme")
	end
end)

LocalPlayerTab:Label("Exploits")

LocalPlayerTab:Toggle("Anti TP", "Prevents people from bringing you and such. Useful against spam arresters and Trolls.", function(bool)
	OpenLib._AntiTP.Toggle(bool)
end)

LocalPlayerTab:Toggle("Rubberbanding", "Blame your shit aim on lag, or just switch on aimbot.", function(bool)
	OpenLib._Rubberbanding.Toggle(bool)
end)

---------------
-- TOOLS TAB --
---------------

local ToolsTab = Window:Tab("Tools", "rbxassetid://0")

ToolsTab:Label("Givers")

ToolsTab:Button("Give All Guns", "Gives you every gun.", function()
	game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["Remington 870"].ITEMPICKUP)
	game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["AK-47"].ITEMPICKUP)
	game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["M9"].ITEMPICKUP)
end)

ToolsTab:Dropdown("Give Gun", {"Remington 870", "AK-47", "M9"}, function(Choice)
	if Choice == "Remington 870" then
		game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["Remington 870"].ITEMPICKUP)
	elseif Choice == "AK-47" then
		game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["AK-47"].ITEMPICKUP)
	else
		game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["M9"].ITEMPICKUP)
	end
end)

ToolsTab:Label("Mods")

ToolsTab:Button("Infinite Ammo", "Gives you infinite ammo. Note: Does not remove cooldown! Made by GFX#8791.", function()
	for i = 1, math.huge, 1 do wait(.1) pcall(function()
		local j = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		game.ReplicatedStorage.ReloadEvent:FireServer(j)
		wait(.1) for i, v in next, debug.getregistry() do if type(v) == "table"
		then if v.Bullets then v.CurrentAmmo = 69 v.MaxAmmo = 420 end end end end) end
end)

-----------------
-- PLAYERS TAB --
-----------------

local PlayersTab = Window:Tab("Rage", "rbxassetid://0")

PlayersTab:Label("Death")

local LegitMode = false
PlayersTab:Toggle("Legit Mode", "Does the same thing to you as all other players. Makes you less sus.", function(State)
	LegitMode = not LegitMode
end)

PlayersTab:Button("Kill All", "Kills all players.", function()
	local OldTeam = Player.TeamColor.Name
	local OldCFrame = Character.HumanoidRootPart.CFrame
	workspace.Remote.loadchar:FireServer("Amogus Sex Fart Poop Funny Compilation (Halal) 2021 May Working Free Legit 360 Noscope Headshot", "Medium stone grey")
	Character.HumanoidRootPart.CFrame = OldCFrame
	function getPacketFromPlayer(tget)
		return {
			["RayObject"] = Ray.new(Vector3.new(0,0,0), Vector3.new(0,0,0)),
			["Distance"] = 0,
			["Cframe"] = CFrame.new(0,0,0,0,0,0,0,0,0,0,0,0),
			["Hit"] = tget.Character.Head
		}
	end
	local arg1 = {}
	for i,v in pairs(game.Players:GetPlayers()) do
		for i2=1,7 do
			table.insert(arg1,getPacketFromPlayer(v))
		end
	end
	game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["Remington 870"].ITEMPICKUP)
	local gun = game.Players.LocalPlayer.Backpack['Remington 870']
	game:GetService('ReplicatedStorage').ShootEvent:FireServer(arg1,gun)

	Player.TeamColor = OldTeam

	if LegitMode == true then
		Character.Humanoid.Health = 0
	end
end)

PlayersTab:Button("Kill Inmates", "Kills all inmates.", function()
	local OldTeam = Player.TeamColor.Name
	local OldCFrame = Character.HumanoidRootPart.CFrame
	workspace.Remote.loadchar:FireServer("Chug Jug", "Medium stone grey")
	Character.HumanoidRootPart.CFrame = OldCFrame
	function getPacketFromPlayer(tget)
		return {
			["RayObject"] = Ray.new(Vector3.new(0,0,0), Vector3.new(0,0,0)),
			["Distance"] = 0,
			["Cframe"] = CFrame.new(0,0,0,0,0,0,0,0,0,0,0,0),
			["Hit"] = tget.Character.Head
		}
	end
	local arg1 = {}
	for i,v in pairs(game.Players:GetPlayers()) do
		if v.TeamColor.Name == "Bright orange" then
			for i2=1,7 do
				table.insert(arg1,getPacketFromPlayer(v))
			end
		end
	end
	game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["Remington 870"].ITEMPICKUP)
	local gun = game.Players.LocalPlayer.Backpack['Remington 870']
	game:GetService('ReplicatedStorage').ShootEvent:FireServer(arg1,gun)

	Player.TeamColor = OldTeam

	if LegitMode == true and Player.TeamColor.Name == "Bright orange" then
		Character.Humanoid.Health = 0
	end
end)

PlayersTab:Button("Kill Guards", "Kills all guards.", function()
	local OldTeam = Player.TeamColor.Name
	local OldCFrame = Character.HumanoidRootPart.CFrame
	workspace.Remote.loadchar:FireServer("Chug Jug", "Medium stone grey")
	Character.HumanoidRootPart.CFrame = OldCFrame
	function getPacketFromPlayer(tget)
		return {
			["RayObject"] = Ray.new(Vector3.new(0,0,0), Vector3.new(0,0,0)),
			["Distance"] = 0,
			["Cframe"] = CFrame.new(0,0,0,0,0,0,0,0,0,0,0,0),
			["Hit"] = tget.Character.Head
		}
	end
	local arg1 = {}
	for i,v in pairs(game.Players:GetPlayers()) do
		if v.TeamColor.Name == "Bright blue" then
			for i2=1,7 do
				table.insert(arg1,getPacketFromPlayer(v))
			end
		end
	end
	game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["Remington 870"].ITEMPICKUP)
	local gun = game.Players.LocalPlayer.Backpack['Remington 870']
	game:GetService('ReplicatedStorage').ShootEvent:FireServer(arg1,gun)

	if LegitMode == true and Player.TeamColor.Name == "Bright orange" then
		Character.Humanoid.Health = 0
	end
end)

PlayersTab:Button("Kill Neutrals", "Kills all neutrals.", function()
	function getPacketFromPlayer(tget)
		return {
			["RayObject"] = Ray.new(Vector3.new(0,0,0), Vector3.new(0,0,0)),
			["Distance"] = 0,
			["Cframe"] = CFrame.new(0,0,0,0,0,0,0,0,0,0,0,0),
			["Hit"] = tget.Character.Head
		}
	end
	local arg1 = {}
	for i,v in pairs(game.Players:GetPlayers()) do
		if v.TeamColor.Name == "Medium stone gray" then
			for i2=1,7 do
				table.insert(arg1,getPacketFromPlayer(v))
			end
		end
	end
	game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["Remington 870"].ITEMPICKUP)
	local gun = game.Players.LocalPlayer.Backpack['Remington 870']
	game:GetService('ReplicatedStorage').ShootEvent:FireServer(arg1,gun)

	if LegitMode == true then
		Character.Humanoid.Health = 0
	end
end)

PlayersTab:Button("Kill Criminals", "Kills all criminals.", function()
	function getPacketFromPlayer(tget)
		return {
			["RayObject"] = Ray.new(Vector3.new(0,0,0), Vector3.new(0,0,0)),
			["Distance"] = 0,
			["Cframe"] = CFrame.new(0,0,0,0,0,0,0,0,0,0,0,0),
			["Hit"] = tget.Character.Head
		}
	end
	local arg1 = {}
	for i,v in pairs(game.Players:GetPlayers()) do
		if v.TeamColor == "Bright red" then
			for i2=1,7 do
				table.insert(arg1,getPacketFromPlayer(v))
			end
		end
	end
	game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace")["Prison_ITEMS"].giver["Remington 870"].ITEMPICKUP)
	local gun = game.Players.LocalPlayer.Backpack['Remington 870']
	game:GetService('ReplicatedStorage').ShootEvent:FireServer(arg1,gun)

	if LegitMode == true and Player.TeamColor == "Bright red" then
		Character.Humanoid.Health = 0
	end
end)

----------------------
-- MOVEMENT SECTION --
----------------------

local MovementTab = Window:Tab("Movement", "rbxassetid://0")

MovementTab:Label("Settings")

MovementTab:Slider("Walk Speed", "Changes your walk speed.", 0, 500, 16, function(Value)
	Character.Humanoid.WalkSpeed = Value
end)

MovementTab:Button("Reset Walk Speed", "Resets your walk speed.", function()
	Character.Humanoid.WalkSpeed = 16
end)

MovementTab:Slider("Jump Power", "Changes your jump power.", 0, 500, 50, function(Value)
	Character.Humanoid.JumpPower = Value
end)

MovementTab:Button("Reset Jump Power", "Resets your jump power.", function()
	Character.Humanoid.JumpPower = 50
end)

MovementTab:Label("Movement Cheats")

MovementTab:Toggle("Fly", "clearly you've never seen an airplane", function(bool)
	OpenLib._Flight.FlightStart(bool)
end)

MovementTab:Toggle("Noclip", "how can you be this retarded", function(bool)
	OpenLib._Noclip.Toggle(bool)
end)

MovementTab:Toggle("Infinite Stamina", "Gives you infinite stamina.", function(bool)
	if bool then
		local InfJumpConnection = UIS.InputBegan:Connect(function(Input)
			if Input == Enum.UserInputType.JumpRequest then
				Character.Humanoid.ChangeState("Jumping")
			end
		end)
	else
		InfJumpConnection:Disconnect()
	end
end)

--------------------
-- PLAYER SECTION --
--------------------

local PlayerTab = Window:Tab("Player", "rbxassetid://0")
PlayerTab:Textbox("Enter Player Name")
---------------------
-- CREDITS SECTION --
---------------------

local CreditsTab = Window:Tab("Credits", "rbxassetid://0")

CreditsTab:Label("medic gaming#7548 - Creator, main developer, and a retard.")
CreditsTab:Label("Boazer#7727 - #1 Hackerbro, kind words and a LOT of help.")
CreditsTab:Label("GFX#8791 - Created the infinite ammo mod.")
CreditsTab:Label("dawid#7205 - Created the sex UI library")
CreditsTab:Button("Copy UI library link", "Copies the UI library link.", function()
	setclipboard("https://v3rmillion.net/showthread.php?tid=1101621")
end)
CreditsTab:Label("Celesmos GUI by Boazer - Inspired me to create Entropix. Better than Entropix in every aspect, apart from speed.")
CreditsTab:Button("Advertise Script", "Advertise the script in chat.", function()
	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Player.Name .. " is using Entropix, the worst Prison Life GUI! Want to try it? Don't.")
end)