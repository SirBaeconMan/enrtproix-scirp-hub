warn("Entropix for Prison Life loading...")
------------
-- things --
------------
local game = game
local function GetService(Service)
	game:GetService(Service)
end
local Players = GetService("Players")
local RunService = GetService("RunService")
local CFrameNew = CFrame.new
local Region3New = Region3.new
local GetAsset = getsynasset or getcustomasset or nil
local Vector3New = Vector3.new
local Randint = math.random
local MathFloor = math.floor
local str, num = tostring, tonumber
local CoroutineResume, CoroutineCreate = coroutine.resume, coroutine.create
local wait = wait
local HttpGet = game.HttpGet
local Request = syn.request or request
local loadstring = loadstring
local WriteFile = writefile
local ReadFile = readfile
local UDim2New = UDim2.new
local InstanceNew = Instance.new
local setclipboard = setclipboard
local stringsub = string.sub
local stringbyte = string.byte
local stringchar = string.char
local stringlower = string.lower
local stringformat = string.format
local tableinsert = table.insert
local tableremove = table.remove
local tablefind = table.find
local isfolder = isfolder
local isfile = isfile
local DelFile = delfile
local MakeFolder = makefolder
local pcall = pcall
local GetPlayers = Players.GetPlayers
local workspace = GetService("Workspace")
local HttpService = GetService("HttpService")
local BindToRenderStep = RunService.BindToRenderStep
local UnbindFromRenderStep = RunService.UnbindFromRenderStep
local JSONDecode = HttpService.JSONDecode
local JSONEncode = HttpService.JSONEncode
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PlayerHRP = Character:WaitForChild("HumanoidRootPart")
local PlayerHumanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera
local StarterGui = GetService("StarterGui")
local ReplicatedStorage = GetService("ReplicatedStorage")
local UIS = GetService("UserInputService")
local Marketplace = GetService("MarketplaceService")
local Teams = GetService("Teams")
local loadchar = workspace.Remote.loadchar
local ItemHandler = workspace.Remote.ItemHandler
local TeamEvent = workspace.Remote.TeamEvent
local ShootEvent = ReplicatedStorage.ShootEvent
local ReloadEvent = ReplicatedStorage.ReloadEvent
local Arrest = workspace.Remote.arrest
local function LoadFile(file)
    loadstring(ReadFile(file))
end
local haspass
local suc,err = pcall(function()
    haspass = mps:UserOwnsGamePassAsync(Player.UserId,96651)
end)
if not suc then
	warn("Marketplace is unreachable, SWAT info inaccurate!")
end
local eventF = ReplicatedStorage.meleeEvent


------------------------------------
-- file loading (hopefully works) --
------------------------------------
print("Loading directories... (if you get errors during this stage, run the file fixer and try again)")
local MainFolder
local LibsFolder
local PrisonLifeSubfolder
MainFolder = isfolder("EntropixHubV1")
if MainFolder then 
	PrisonLifeSubfolder = isfolder("EntropixHubV1\\PrisonLife") 
else
	MakeFolder("EntropixHubV1")
	wait()
	MakeFolder("EntropixHubV1\\Libraries")
	wait()
	MakeFolder("EntropixHubV1\\PrisonLife")
    wait()
end
if PrisonLifeSubfolder then 
	ConfigFile = isfile("EntropixHubV1\\PrisonLife\\config.json") 
else
	MakeFolder("EntropixHubV1\\PrisonLife")
    wait()
end
LibsFolder = isfolder("EntropixHubV1\\Libraries")
if not LibsFolder then
	MakeFolder("EntropixHubV1\\Libraries")
	wait()
	WriteFile("EntropixHubV1\\Libraries\\FluxLib.lua", HttpGet("https://raw.githubusercontent.com/SirBaeconMan/enrtproix-scirp-hub/main/uilib.lua"))
	wait()
	WriteFile("EntropixHubV1\\Libraries\\DrawingLib.lua", HttpGet("https://raw.githubusercontent.com/Jonathann-0/Drawing-Wrapper/main/main.lua"))
    wait()
end 


local Flux
Flux = isfile("EntropixHubV1\\Libraries\\FluxLib.lua")
if Flux then
    Flux = LoadFile("EntropixHubV1\\Libraries\\FluxLib.lua")
else
    warn("UI library doesn't exist, downloading...")
    WriteFile("EntropixHubV1\\Libraries\\FluxLib.lua", HttpGet("https://raw.githubusercontent.com/SirBaeconMan/enrtproix-scirp-hub/main/uilib.lua"))
    wait()
    print("Downloaded!")
    Flux = LoadFile("EntropixHubV1\\Libraries\\FluxLib.lua")
end

local DrawingLib
DrawingLib = isfile("EntropixHubV1\\Libraries\\DrawingLib.lua")
if DrawingLib then
    DrawingLib = LoadFile("EntropixHubV1\\Libraries\\DrawingLib.lua")
else
    warn("Drawing library doesn't exist, downloading...")
    WriteFile("EntropixHubV1\\Libraries\\DrawingLib.lua")
    wait()
    DrawingLib = LoadFile("EntropixHubV1\\Libraries\\DrawingLib.lua")
end

---------------
-- functions --
---------------

local function Notify(text)
	StarterGui:SetCore("SendNotification", {
		Title = "Entropix V1",
		Text = text
	})
end

local function ChatMessage(text)
	ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
end

local counterUpvalue = 1

local function killPlayerFromStringWithPunch(string)
    PlayerHumanoid.ChangeState(PlayerHumanoid,Enum.HumanoidStateType.Jumping)
    PlayerCFrame = PlayerHRP.CFrame
    CharToKill = workspace:FindFirstChild(string)
    PlayerHRP.CFrame = chartokill.HumanoidRootPart.CFrame
    local function punch()
        PlayerHRP.CFrame = chartokill.HumanoidRootPart.CFrame
        for i=0, 20 do
            eventF.FireServer(eventF,Players.FindFirstChild(Players,string))
        end
    end
    BindToRenderStep('kill', 1000, punch)
    repeat wait() until chartokill.Humanoid.Health == 0
    UnbindFromRenderStep('kill')
    PlayerHumanoid.ChangeState(PlayerHumanoid,Enum.HumanoidStateType.Jumping)
    PlayerHRP.CFrame = PlayerCFrame
end

local function killPlayer(playerInstance)-- skidded fresh from celesmos
    local haspass = false
    pcall(function()
        local distance = 0
        if counterUpvalue <= 4 then
            if counterUpvalue == 1 then
                local gun = Player.Backpack.FindFirstChild(Player.Backpack,'Remington 870') or Character.FindFirstChild(Character,'Remington 870') or nil
                if not gun then
                    ItemHandler.InvokeServer(ItemHandler,workspace.Prison_ITEMS.giver['Remington 870'].ITEMPICKUP)
                    gun = Player.Backpack.WaitForChild(Player.Backpack,'Remington 870')
                end
                counterUpvalue = counterUpvalue + 1
                ShootEvent.FireServer(ShootEvent,
                {
                    {
                        ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                        ["Distance"] = distance,
                        ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                        ["Hit"] = playerInstance.Character.Head
                    },
                    {
                        ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                        ["Distance"] = distance,
                        ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                        ["Hit"] = playerInstance.Character.Head
                    },
                    {
                        ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                        ["Distance"] = distance,
                        ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                        ["Hit"] = playerInstance.Character.Head
                    },
                    {
                        ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                        ["Distance"] = distance,
                        ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                        ["Hit"] = playerInstance.Character.Head
                    },
                    {
                        ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                        ["Distance"] = distance,
                        ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                        ["Hit"] = playerInstance.Character.Head
                    }
                },
                gun
                )
                if playerInstance.Character.Humanoid.Health ~= 0 and playerInstance.Character:FindFirstChild('vest') then
                    killPlayerFromStringWithPunch(playerInstance.Name)
                end
                ReloadEvent.FireServer(ReloadEvent,gun)
            elseif counterUpvalue == 2 then
                local gun = Player.Backpack.FindFirstChild(Player.Backpack,'M9') or Character.FindFirstChild(Character,'M9') or nil
                if not gun then
                    ItemHandler.InvokeServer(ItemHandler,workspace.Prison_ITEMS.giver['M9'].ITEMPICKUP)
                    gun = Player.Backpack.WaitForChild(Player.Backpack,'M9')
                end
                for i=1,15 do
                    wait()
                    ShootEvent.FireServer(ShootEvent,
                    {
                        {
                            ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                            ["Distance"] = distance,
                            ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                            ["Hit"] = playerInstance.Character.Head
                        }
                    },
                    gun
                    )
                end
                counterUpvalue = counterUpvalue + 1
                ReloadEvent.FireServer(ReloadEvent,gun)
            elseif counterUpvalue == 3 or counterUpvalue == 4 then
                local gun = game.Players.LocalPlayer.Backpack:FindFirstChild('AK-47') or game.Players.LocalPlayer.Character:FindFirstChild('AK-47') or nil
                if not gun then
                    workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver['AK-47'].ITEMPICKUP)
                    gun = game.Players.LocalPlayer.Backpack:WaitForChild('AK-47')
                end
                counterUpvalue = counterUpvalue + 1
                for i=1,15 do
                    wait()
                    ReplicatedStorage.ShootEvent:FireServer(
                    {
                        {
                            ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                            ["Distance"] = distance,
                            ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                            ["Hit"] = playerInstance.Character.Head
                        }
                    },
                    gun
                    )
                end
                if counterUpvalue == 4 then
                    ReplicatedStorage.ReloadEvent:FireServer(gun)
                end
            end
        else
            if haspass then
                if counterUpvalue == 5 or counterUpvalue == 6 or counterUpvalue == 7 then
                    local gun = game.Players.LocalPlayer.Backpack:FindFirstChild('M4A1') or game.Players.LocalPlayer.Character:FindFirstChild('M4A1')
                    if not gun then
                        workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver['M4A1'].ITEMPICKUP)
                        gun = game.Players.LocalPlayer.Backpack:WaitForChild('M4A1')
                    end
                    counterUpvalue = counterUpvalue + 1
                    for i=1,10 do
                        wait()
                        ShootEvent:FireServer(
                        {
                            {
                                ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                                ["Distance"] = distance,
                                ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                                ["Hit"] = playerInstance.Character.Head
                            }
                        },
                        gun
                        )
                    end
                    if counterUpvalue == 7 then
                        ReloadEvent:FireServer(gun)
                        counterUpvalue = 1
                    end
                end
            else
                counterUpvalue = 2
                local gun = Player.Backpack.FindFirstChild(Player.Backpack,'Remington 870') or Character.FindFirstChild(Character,'Remington 870') or nil
                if not gun then
                    ItemHandler.InvokeServer(ItemHandler,workspace.Prison_ITEMS.giver['Remington 870'].ITEMPICKUP)
                    gun = Player.Backpack.WaitForChild(Player.Backpack,'Remington 870')
                end
                ShootEvent.FireServer(ShootEvent,
                {
                    {
                        ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                        ["Distance"] = distance,
                        ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                        ["Hit"] = playerInstance.Character.Head
                    },
                    {
                        ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                        ["Distance"] = distance,
                        ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                        ["Hit"] = playerInstance.Character.Head
                    },
                    {
                        ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                        ["Distance"] = distance,
                        ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                        ["Hit"] = playerInstance.Character.Head
                    },
                    {
                        ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                        ["Distance"] = distance,
                        ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                        ["Hit"] = playerInstance.Character.Head
                    },
                    {
                        ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
                        ["Distance"] = distance,
                        ["Cframe"] = CFrameNew(0,0,0,0,0,0,0,0,0,0,0,0),
                        ["Hit"] = playerInstance.Character.Head
                    }
                },
                gun
                )
                if playerInstance.Character.Humanoid.Health ~= 0 and playerInstance.Character.FindFirstChild(playerInstance.Character,'vest') then
                    killPlayerFromStringWithPunch(playerInstance.Name)
                end
                ReloadEvent.FireServer(ReloadEvent,gun)
            end
        end
    end)
end

local function Bring(target, place)
    place = place or nil
    wait()
    if target ~= nil then
        if target.Character.Humanoid.Sit then return end

        local NormPos = PlayerHRP.CFrame
        loadchar.InvokeServer(loadchar)
        ItemHandler.InvokeServer(ItemHandler,workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP)
        repeat wait() until Character and PlayerHRP
        wait(0.1)

        tchar = target.Character
        hum = Character.FindFirstChildOfClass(Character,"Humanoid")
        hrp = Character.HumanoidRootPart
        hrp2 = target.Character.HumanoidRootPart
        hum.Name = "clone"
        newHum = hum.Clone(hum)
        newHum.Parent = Character
        newHum.Name = "Humanoid"
        wait()
        hum.Destroy(hum)
        Camera.CameraSubject = Character
        newHum.DisplayDistanceType = "None"
        
        tool = Player.Backpack.FindFirstChild(Player.Backpack,"AK-47") or Character.FindFirstChild(Character,"AK-47")
        tool.Parent = Character
        hrp.CFrame = hrp2.CFrame * CFrameNew(0, 0, 0) * CFrameNew(math.random(-100, 100)/200,math.random(-100, 100)/200,math.random(-100, 100)/200)
        n = 0
        repeat
            wait()
            n = n + 1
            hrp.CFrame = hrp2.CFrame
        until (tchar.Humanoid.Health == 0 or tool.Parent ~= Character or not PlayerHRP or not hrp2 or not PlayerHRP.Parent or not hrp2.Parent or n > 250) and n > 2
        for i = 1,10 do
            wait()
            if not place then
                hrp.CFrame = NormPos
            else
                hrp.CFrame = place
            end
        end
        loadchar.InvokeServer(loadchar)
        wait()
        loadchar.InvokeServer(loadchar)
        wait()
        for i=1,10 do wait() PlayerHRP.CFrame = NormPos end
    end
end

local function GetPlayerFromString(string)
	for i,v in pairs(GetPlayers()) do
        if stringsub(stringlower(v.Name),1,#string) == stringlower(string) then
            return v
        end
    end
    return nil
end

local function SwitchToGuards()
	if #game.Teams.Guards.GetPlayers(game.Teams.Guards) == 8 then
        local cpos = PlayerHRP.CFrame
        loadchar.InvokeServer(loadchar,'nothing', 'Bright blue')
        repeat wait() until tostring(Player.TeamColor) == 'Bright blue' and Character.FindFirstChild(Character,'HumanoidRootPart')
        PlayerHRP.CFrame = cpos
    else
        TeamEvent.FireServer(TeamEvent,'Bright blue')
    end
end

--------------
-- entropix --
--------------

-- Create the main window (fun fact: this is the same ui lib as paa's)
local Window = Flux:Window("Entropix V1", "Prison Life GUI", Color3.fromRGB(255, 110, 48), Enum.KeyCode.LeftControl)

local PlayersTab = Window:Tab("Player", "rbxassetid://0")
local MassTab = Window:Tab("Mass", "rbxassetid://0")
local ToolsTab = Window:Tab("Tools", "rbxassetid://0")
local MapTab = Window:Tab("Map", "rbxassetid://0")
local LocalPlayerTab = Window:Tab("Local Player", "rbxassetid://0")
local TeamsTab = Window:Tab("Teams", "rbxassetid://0")
local ESPTab = Window:Tab("ESP", "rbxassetid://0")
local MovementTab = Window:Tab("Movement", "rbxassetid://0")
local SettingsTab = Window:Tab("Settings", "rbxassetid://0")
local CreditsTab = Window:Tab("Credits", "rbxassetid://0")

local PlayerSelected = ""
PlayersTab:TextBox("Search for player", function(text)
	if GetPlayerFromString(text) then
		PlayerSelected = GetPlayerFromString(text)
		Notify(stringformat("Selected user: %s", PlayerSelected))
	else
		Notify("Invalid player!")
	end
end)

local FindPlayer = PlayersTab:Dropdown("Find Player", function(option)
    PlayerSelected = option.Name
end)

PlayersTab:Button("Refresh List", "Refreshes the find player list. Use this if you cant find the player you're looking for.", function()
    FindPlayer:Clear()
    for i, v in pairs(GetPlayers()) do
        FindPlayer:Add(v.Name)
    end
    Notify("Refreshed find list!")
end)

PlayersTab:Button("Kill Player", "Kills the selected player.", killPlayer(PlayerSelected))

PlayersTab:Button("Go To Player", "Teleport to the player.", function()
    PlayerHRP.CFrame = workspace[PlayerSelected].Character.HumanoidRootPart.CFrame
end)

PlayersTab:Button("Bring Player", "Teleport the selected player to you. Made by Boazer#7477.", Bring(workspace[PlayerSelected]))

PlayersTab:Button("Void Player", "Put the selected player in the void. Also made by Boazer#7477.", Bring(workspace[PlayerSelected], CFrameNew(1000000, 1000000, 1000000)))

PlayersTab:Button("Taze Player", "Tazes the selected player.", function()
    if Player.TeamColor ~= "Bright blue" then
        SwitchToGuards()
    end
    Tool = Player.Backpack.FindFirstChild(Player.Backpack,'Taser') or Character.FindFirstChild(Character,'Taser')
    ShootEvent:FireServer(ShootEvent, {
        {
            ["RayObject"] = Ray.new(Vector3New(0,0,0), Vector3New(0,0,0)),
            ["Distance"] = 0,
            ["Cframe"] = CFrameNew(0,0,0),
            ["Hit"] = PlayerSelected.Character.Head
        },
        Tool
    })
end)

ToolsTab:Button("Infinite Ammo", "Gives you infinite ammo. Note: Does not remove cooldown! Made by GFX#8791.", function()
	for i = 1, math.huge, 1 do wait(.1) pcall(function()
		local j = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		game.ReplicatedStorage.ReloadEvent:FireServer(j)
		wait(.1) for i, v in next, debug.getregistry() do if type(v) == "table"
		then if v.Bullets then v.CurrentAmmo = 69 v.MaxAmmo = 420 end end end end) end
end)

--զգուշացեք մթից և լուսադեմից այն գազանին, որը կրկին բարձրանում է խորքերից ՝ բոլոր մարդկանց հոգիները վերադարձնելու համար, թող հավերժ փառաբանենք նրան, մինչ մահը չկոտրի մեր շղթաները, հավիտենական ողորմության համար գազանից հետմահու կյանքում

CreditsTab:Label("Entropix by Strixial")
CreditsTab:Label("UI library - dawid")
CreditsTab:Label("Boazer - Inspired me to create Entropix")
CreditsTab:Label("Boazer - Reminds me I'm a retard every day")
CreditsTab:Label("Boazer - don't tell him i took like 90% of entropix pl from the celesmos v3 leak")
CreditsTab:Label("Boazer - #1 hackerbro")
CreditsTab:Label("joe - joe (not femboy joe, thats the wrong one)")
CreditsTab:Label("GFX - infinite ammo scirp")
CreditsTab:Label("Dustin - haha just kidding get fucked you swiss cunt")
CreditsTab:Label("ShowerHeadFD - fluxsex (best free exploit no cap)")
CreditsTab:Label("anal wanker - i mean alan walker (why did i put this i dont even listen to his music wtf)")
CreditsTab:Label("Cloudy with a chance of meatballs (spanish audio) - entonces es asi? eehhhh.")
CreditsTab:Label([[the one person that searched up "judy hopps no clothes" on school computer]])
CreditsTab:Label("jjsploit - nah just kidding really shit exploit")
CreditsTab:Label("hanime.tv - best anime site (unblocked in most schools as well)")
CreditsTab:Label("thepiratebay.org - i forgot but its pretty cool")
CreditsTab:Label("Demonic_Kitty#0003 - #2 hackerbro")
CreditsTab:Button("Advertise Entropix", "Sends a message in the chat advertising Entropix.", ChatMessage("Interested in the script I'm using? Check out Entropix at .gg/GMagUhBuJU!"))