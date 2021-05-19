local _ESP = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	local Screen = Instance.new("ScreenGui")
	  local Viewport = Instance.new("ViewportFrame", Screen)
	
	local module = {}
	local characters = {}
	local clones = {}
	local parts = {}
	
	module.Options = {
		Enabled = false,
		Parent = script.Parent or game.CoreGui,
		Color = Color3.new(1, 1, 1),
		ShowDescendants = false,
		TeamColor = false,
		ShowSelf = false,
		ShowTeam = false,
		Mode = "Shader",
		Opacity = 1,
		Arrow = false,
		MaxDistance = 500,
	}
	
	--// Edits
	Viewport.Size = UDim2.new(1, 0, 1, 0)
	Viewport.BackgroundTransparency = 1
	Viewport.CurrentCamera = workspace.CurrentCamera
	Screen.IgnoreGuiInset = true
	
	--// Functions
	local function getParts(Model)
		local parts = {}
		local descendants = Model:GetDescendants()
		local descendantsn = #descendants
		for i = 1, descendantsn do
			local desc = descendants[i]
			if desc:IsA("BasePart") then
				table.insert(parts, desc)
			end
		end
		return parts
	end
	
	local function getPart(Model)
		return Model.PrimaryPart or Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChildWhichIsA("Part")
	end
	
	function module:Clone(Object)
		local isArchivable = Object.Archivable
		local Clone
		
		Object.Archivable = true
		Clone = Object:Clone()
		Object.Archivable = isArchivable
		
		for _, child in pairs(Clone:GetDescendants()) do
			if child:IsA("Clothing") or child:IsA("Decal") or child:IsA("Script") or child:IsA("LocalScript") or child:IsA("Sound") then
				child:Destroy()
			elseif child:IsA("BasePart") then
				child.Color = Color3.new(1, 1, 1)
				child.Material = "ForceField"
			elseif child:IsA("Humanoid") then
				child.DisplayDistanceType = "None"
			elseif child:IsA("SpecialMesh") then
				child.TextureId = "rbxassetid://55054494"
			elseif child:IsA("MeshPart") then
				child.TextureID = "rbxassetid://55054494"
			end
		end
		
		return Clone
	end
	
	function module:Enable()
		module.Options.Enabled = true
		Screen.Parent = module.Options.Parent
		
		module:ReloadCharacters()
	end
	
	function module:Disable()
		module.Options.Enabled = false
		Screen.Parent = nil
	end
	
	function module:ReloadCharacters()
		Viewport:ClearAllChildren()
		if module.Options.Mode ~= "Shader" then
			return
		end
		for player, character in pairs(characters) do
			local clone = module:Clone(character)
			clone.Name = player.Name
			clone.Parent = Viewport
			clones[player] = clone
		end
	end
	
	local function newPlayer(player)
		if player.Character then
			characters[player] = player.Character
			
			local clone = module:Clone(player.Character)
			clone.Name = player.Name
			clone.Parent = Viewport
			clones[player] = clone
		end
		player.CharacterAdded:Connect(function(char)
			if clones[player] then
				clones[player]:Destroy()
				clones[player] = nil
			end;if characters[player] then
				characters[player]:Destroy()
				characters[player] = nil
			end
			
			characters[player] = char
			
			local clone = module:Clone(char)
			clone.Name = player.Name
			clone.Parent = Viewport
			clones[player] = clone
		end)
	end
	
	Players.PlayerAdded:Connect(newPlayer)
	Players.PlayerRemoving:Connect(function(player)
		if clones[player] then
			clones[player]:Destroy()
			clones[player] = nil
		end;if characters[player] then
			characters[player]:Destroy()
			characters[player] = nil
		end
	end)
	for _, player in pairs(Players:GetPlayers()) do
		newPlayer(player)
	end
	
	RunService.RenderStepped:Connect(function()
		if module.Options.Enabled and module.Options.Mode == "Shader" then
			for player, character in pairs(characters) do
				local clone = clones[player]
				local target = getPart(clone)
				if target then
					if ((player.Team == Player.Team and module.Options.ShowTeam) or player.Team ~= Player.Team) and (target.Position - workspace.CurrentCamera.CFrame.p).Magnitude <= module.Options.MaxDistance then
						if (player == Player and module.Options.ShowSelf) or player ~= Player then
							local parts = getParts(clone)
							for i = 1, #parts do
								local obj = parts[i]
								local cor = character:FindFirstChild(obj.Name, true)
								if character:FindFirstChild(obj.Parent.Name) then
									cor = character:FindFirstChild(obj.Parent.Name):FindFirstChild(obj.Name)
								end
								
								if cor and obj then
									if module.Options.TeamColor then
										obj.Color = player.TeamColor.Color
									else
										obj.Color = Color3.new(1, 1, 1)
									end
									if module.Options.ShowDescendants then
										obj.CFrame = cor.CFrame
									elseif obj.Parent == clone then
										obj.CFrame = cor.CFrame
									else
										obj.CFrame = CFrame.new(10000, 10000, 10000)
									end
								end
							end
							if clone.Parent == nil then
								clone.Parent = Viewport
							end
						else
							clone.Parent = nil
						end
					else
						clone.Parent = nil
					end
				else
					clone.Parent = nil
				end
			end
			Viewport.ImageColor3 = module.Options.Color
			Viewport.ImageTransparency = 1 - module.Options.Opacity
		end
	end)
	
	return module
	
end)()
local _ESP2D = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	
	local module = {}
	local characters = {}
	local esp = {}
	
	module.Options = {
		Enabled = false,
		Parent = script.Parent or game.CoreGui,
		Color = Color3.new(1, 1, 1),
		TeamColor = false,
		ShowSelf = false,
		ShowTeam = false,
		ShowDescendants = false,
		Opacity = 1,
		Mode = "Box",
		Arrow = false,
		MaxDistance = 500,
	}
	
	--// Functions
	local function getParts(Model)
		local parts = {}
		local descendants = (module.Options.ShowDescendants and Model:GetDescendants()) or Model:GetChildren()
		local descendantsn = #descendants
		for i = 1, descendantsn do
			local desc = descendants[i]
			if desc:IsA("BasePart") then
				table.insert(parts, desc)
			end
		end
		return parts
	end
	
	local function getPart(Model)
		return Model.PrimaryPart or Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChildWhichIsA("Part")
	end
	
	function module:Enable()
		module.Options.Enabled = true
		module:ReloadCharacters()
	end
	
	function module:Disable()
		module.Options.Enabled = false
	end
	
	function module:LoadCharacter(player, char)
		local boxes = {}
		if module.Options.Mode == "Default" then
			local parts = getParts(char)
			for i = 1, #parts do
				local part = parts[i]
				local adornment = Instance.new("BoxHandleAdornment", module.Options.Parent)
				adornment.Adornee = part
				adornment.AlwaysOnTop = true
				adornment.Color3 = module.Options.Color
				adornment.Size = part.Size
				adornment.ZIndex = 1
				adornment.Transparency = 1 - module.Options.Opacity
				if module.Options.TeamColor then
					adornment.Color3 = player.TeamColor.Color
				end
				
				table.insert(boxes, adornment)
			end
			
			local part = getPart(char)
			if module.Options.Arrow then
				local arrow = Instance.new("Handles", module.Options.Parent)
				arrow.Adornee = part
				arrow.Faces = Faces.new(Enum.NormalId.Front)
				arrow.Style = Enum.HandlesStyle.Movement
				arrow.Color3 = module.Options.Color
				if module.Options.TeamColor then
					arrow.Color3 = player.TeamColor.Color
				end
				table.insert(boxes, arrow)
			end
		elseif module.Options.Mode == "Box" then
			local part = getPart(char)
			local adornment = Instance.new("BoxHandleAdornment", module.Options.Parent)
			adornment.Adornee = part
			adornment.AlwaysOnTop = true
			adornment.Color3 = module.Options.Color
			adornment.Size = char:GetExtentsSize()
			adornment.ZIndex = 1
			adornment.Transparency = 1 - module.Options.Opacity
			if module.Options.TeamColor then
				adornment.Color3 = player.TeamColor.Color
			end
			
			if module.Options.Arrow then
				local arrow = Instance.new("Handles", module.Options.Parent)
				arrow.Adornee = part
				arrow.Faces = Faces.new(Enum.NormalId.Front)
				arrow.Style = Enum.HandlesStyle.Movement
				arrow.Color3 = module.Options.Color
				if module.Options.TeamColor then
					arrow.Color3 = player.TeamColor.Color
				end
				table.insert(boxes, arrow)
			end
			
			table.insert(boxes, adornment)
		elseif module.Options.Mode == "Square" then
			local part = getPart(char)
			local billboard = (function()
		local partsWithId = {}
		local awaitRef = {}
		
		local root = {
			ID = 0;
			Type = "BillboardGui";
			Properties = {
				ClipsDescendants = true;
				LightInfluence = 1;
				Name = "B";
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
				StudsOffset = Vector3.new(0,-0.5,0);
				Active = true;
				AlwaysOnTop = true;
				Size = UDim2.new(5,0,6,0);
			};
			Children = {
				{
					ID = 1;
					Type = "Frame";
					Properties = {
						AnchorPoint = Vector2.new(0.5,0.5);
						BackgroundTransparency = 0.5;
						Position = UDim2.new(0.5,0,0.5,0);
						BorderColor3 = Color3.new(4/51,4/51,4/51);
						Size = UDim2.new(1,-4,1,-4);
						BorderSizePixel = 2;
						BackgroundColor3 = Color3.new(1,1,1);
					};
					Children = {};
				};
			};
		};
		
		local function Scan(item, parent)
			local obj = Instance.new(item.Type)
			if (item.ID) then
				local awaiting = awaitRef[item.ID]
				if (awaiting) then
					awaiting[1][awaiting[2]] = obj
					awaitRef[item.ID] = nil
				else
					partsWithId[item.ID] = obj
				end
			end
			for p,v in pairs(item.Properties) do
				if (type(v) == "string") then
					local id = tonumber(v:match("^_R:(%w+)_$"))
					if (id) then
						if (partsWithId[id]) then
							v = partsWithId[id]
						else
							awaitRef[id] = {obj, p}
							v = nil
						end
					end
				end
				obj[p] = v
			end
			for _,c in pairs(item.Children) do
				Scan(c, obj)
			end
			obj.Parent = parent
			return obj
		end
		
		return function() return Scan(root, nil) end
	end)()()
			billboard.Parent = module.Options.Parent
			billboard.Adornee = part
			billboard.Frame.BackgroundColor3 = module.Options.Color
			billboard.Frame.Transparency = 1 - module.Options.Opacity
			if module.Options.TeamColor then
				billboard.Frame.Color3 = player.TeamColor.Color
			end
			
			if module.Options.Arrow then
				local arrow = Instance.new("Handles", module.Options.Parent)
				arrow.Adornee = part
				arrow.Faces = Faces.new(Enum.NormalId.Front)
				arrow.Style = Enum.HandlesStyle.Movement
				arrow.Color3 = module.Options.Color
				if module.Options.TeamColor then
					arrow.Color3 = player.TeamColor.Color
				end
				table.insert(boxes, arrow)
			end
			
			table.insert(boxes, billboard)
		end
		esp[player] = boxes
	end
	
	function module:ReloadCharacters()
		for plr, tbl in pairs(esp) do
			for i, v in pairs(tbl) do
				v:Destroy()
			end
			esp[plr] = {}
		end
		if module.Options.Enabled then
			for player, character in pairs(characters) do
				local target = getPart(character)
				if target then
					if ((player.Team == Player.Team and module.Options.ShowTeam) or player.Team ~= Player.Team) and target and (target.Position - workspace.CurrentCamera.CFrame.p).Magnitude <= module.Options.MaxDistance then
						if (player == Player and module.Options.ShowSelf) or player ~= Player then
							module:LoadCharacter(player, character)
						end
					end
				end
			end
		end
	end
	
	local function newPlayer(player)
		if player.Character then
			characters[player] = player.Character
			module:LoadCharacter(player, player.Character)
		end
		player.CharacterAdded:Connect(function(char)
			if esp[player] then
				for i, v in pairs(esp[player]) do
					v:Destroy()
				end
				esp[player] = {}
			end
			
			characters[player] = char
			module:LoadCharacter(player, player.Character)
		end)
	end
	
	Players.PlayerAdded:Connect(newPlayer)
	Players.PlayerRemoving:Connect(function(player)
		if esp[player] then
			for i, v in pairs(esp[player]) do
				v:Destroy()
			end
			esp[player] = {}
			characters[player] = nil
		end
	end)
	for _, player in pairs(Players:GetPlayers()) do
		newPlayer(player)
	end
	
	spawn(function()
		while wait(2) do
			module:ReloadCharacters()
		end
	end)
	
	return module
	
end)()
local _Chams = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	local Screen = Instance.new("ScreenGui")
	  local Viewport = Instance.new("ViewportFrame", Screen)
	
	local module = {}
	local characters = {}
	local clones = {}
	local parts = {}
	
	module.Options = {
		Enabled = false,
		Parent = script.Parent or game.CoreGui,
		Color = Color3.new(1, 1, 1),
		ShowDescendants = false,
		TeamColor = false,
		ShowSelf = false,
		ShowTeam = false,
		Mode = "Shader",
		Opacity = 1,
		MaxDistance = 500,
	}
	
	--// Edits
	Viewport.Size = UDim2.new(1, 0, 1, 0)
	Viewport.BackgroundTransparency = 1
	Viewport.CurrentCamera = workspace.CurrentCamera
	Screen.IgnoreGuiInset = true
	
	--// Functions
	local function getParts(Model)
		local parts = {}
		local descendants = Model:GetDescendants()
		local descendantsn = #descendants
		for i = 1, descendantsn do
			local desc = descendants[i]
			if desc:IsA("BasePart") then
				table.insert(parts, desc)
			end
		end
		return parts
	end
	
	local function getPart(Model)
		return Model.PrimaryPart or Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChildWhichIsA("Part")
	end
	
	function module:Clone(Object)
		local isArchivable = Object.Archivable
		local Clone
		
		Object.Archivable = true
		Clone = Object:Clone()
		Object.Archivable = isArchivable
		
		if module.Options.Mode == "Shader" then
			Viewport.Ambient = Color3.fromRGB(200, 200, 200)
		else
			Viewport.Ambient = Color3.fromRGB(255, 255, 255)
		end
		
		for _, child in pairs(Clone:GetDescendants()) do
			if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("Sound") then
				child:Destroy()
			elseif child:IsA("Humanoid") then
				child.DisplayDistanceType = "None"
			elseif module.Options.Mode ~= "Shader" then
				if child:IsA("SpecialMesh") then
					child.TextureId = ""
				elseif child:IsA("MeshPart") then
					child.TextureID = ""
				elseif child:IsA("BasePart") then
					child.Color = Color3.new(1, 1, 1)
					child.Material = "Neon"
				elseif child:IsA("Clothing") or child:IsA("Decal") then
					child:Destroy()
				end
			end
		end
		
		return Clone
	end
	
	function module:Enable()
		module.Options.Enabled = true
		Screen.Parent = module.Options.Parent
		
		module:ReloadCharacters()
	end
	
	function module:Disable()
		module.Options.Enabled = false
		Screen.Parent = nil
	end
	
	function module:ReloadCharacters()
		Viewport:ClearAllChildren()
		for player, character in pairs(characters) do
			local clone = module:Clone(character)
			clone.Name = player.Name
			clone.Parent = Viewport
			clones[player] = clone
		end
	end
	
	local function newPlayer(player)
		if player.Character then
			characters[player] = player.Character
			
			local clone = module:Clone(player.Character)
			clone.Name = player.Name
			clone.Parent = Viewport
			clones[player] = clone
		end
		player.CharacterAdded:Connect(function(char)
			if clones[player] then
				clones[player]:Destroy()
				clones[player] = nil
			end;if characters[player] then
				characters[player]:Destroy()
				characters[player] = nil
			end
			
			characters[player] = char
			
			local clone = module:Clone(char)
			clone.Name = player.Name
			clone.Parent = Viewport
			clones[player] = clone
		end)
	end
	
	Players.PlayerAdded:Connect(newPlayer)
	Players.PlayerRemoving:Connect(function(player)
		if clones[player] then
			clones[player]:Destroy()
			clones[player] = nil
		end;if characters[player] then
			characters[player]:Destroy()
			characters[player] = nil
		end
	end)
	for _, player in pairs(Players:GetPlayers()) do
		newPlayer(player)
	end
	
	RunService.RenderStepped:Connect(function()
		if module.Options.Enabled then
			for player, character in pairs(characters) do
				local clone = clones[player]
				local target = getPart(clone)
				
				if target then
					if ((player.Team == Player.Team and module.Options.ShowTeam) or player.Team ~= Player.Team) and target and (target.Position - workspace.CurrentCamera.CFrame.p).Magnitude <= module.Options.MaxDistance then
						if (player == Player and module.Options.ShowSelf) or player ~= Player then
							local parts = getParts(clone)
							for i = 1, #parts do
								local obj = parts[i]
								local cor = character:FindFirstChild(obj.Name, true)
								if character:FindFirstChild(obj.Parent.Name) then
									cor = character:FindFirstChild(obj.Parent.Name):FindFirstChild(obj.Name)
								end
								
								if cor and obj then
									if module.Options.TeamColor then
										obj.Color = player.TeamColor.Color
									elseif module.Options.Mode ~= "Shader" then
										obj.Color = Color3.new(1, 1, 1)
									end
									if module.Options.ShowDescendants then
										obj.CFrame = cor.CFrame
									elseif obj.Parent == clone then
										obj.CFrame = cor.CFrame
									else
										obj.CFrame = CFrame.new(10000, 10000, 10000)
									end
								end
							end
							if clone.Parent == nil then
								clone.Parent = Viewport
							end
						else
							clone.Parent = nil
						end
					else
						clone.Parent = nil
					end
				else
					clone.Parent = nil
				end
			end
			Viewport.ImageColor3 = module.Options.Color
			Viewport.ImageTransparency = 1 - module.Options.Opacity
		end
	end)
	
	return module
	
end)()
local _Tracers = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	local Screen = Instance.new("ScreenGui")
	local Camera = workspace.CurrentCamera
	
	local module = {}
	local characters = {}
	local tracers = {}
	
	module.Options = {
		Enabled = false,
		Parent = script.Parent or game.CoreGui,
		Color = Color3.new(1, 1, 1),
		TeamColor = false,
		ShowSelf = false,
		ShowTeam = false,
		Opacity = 1,
		Radius = 1,
		MaxDistance = 500,
	}
	
	Screen.Parent = module.Options.Parent
	Screen.IgnoreGuiInset = true
	
	--// Functions
	local function getParts(Model)
		local parts = {}
		local descendants = Model:GetDescendants()
		local descendantsn = #descendants
		for i = 1, descendantsn do
			local desc = descendants[i]
			if desc:IsA("BasePart") then
				table.insert(parts, desc)
			end
		end
		return parts
	end
	
	local function getPart(Model)
		return Model.PrimaryPart or Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChildWhichIsA("Part")
	end
	
	function module:Enable()
		module.Options.Enabled = true
		module:ReloadCharacters()
	end
	
	function module:Disable()
		module.Options.Enabled = false
		for plr, line in pairs(tracers) do
			if line then
				line[1]:Destroy()
			end
			tracers[plr] = nil
		end
	end
	
	function module:LoadCharacter(player, char)
		local tracer = {}
		local target = getPart(char)
		if target then
			local line = Instance.new("Part", Screen)
			line.Transparency = 1
			line.Anchored = true
			line.CanCollide = false
			
			local adornment = Instance.new("LineHandleAdornment", line)
			adornment.Name = "A"
			adornment.AlwaysOnTop = true
			adornment.ZIndex = 1
			adornment.Adornee = line
			
			tracer[1] = line
			tracer[2] = target
			tracer[3] = player
		else
			return
		end
		
		tracers[player] = tracer
	end
	
	function module:ReloadCharacters()
		for plr, line in pairs(tracers) do
			if line then
				line[1]:Destroy()
			end
			tracers[plr] = nil
		end
		if module.Options.Enabled then
			for player, character in pairs(characters) do
				if (player.Team == Player.Team and module.Options.ShowTeam) or player.Team ~= Player.Team then
					if (player == Player and module.Options.ShowSelf) or player ~= Player then
						module:LoadCharacter(player, character)
					end
				end
			end
		end
	end
	
	local function newPlayer(player)
		if player.Character then
			characters[player] = player.Character
			module:LoadCharacter(player, player.Character)
		end
		player.CharacterAdded:Connect(function(char)
			if tracers[player] then
				tracers[player][1]:Destroy()
				tracers[player] = nil
			end
			char:WaitForChild("Humanoid")
			characters[player] = char
			module:LoadCharacter(player, player.Character)
		end)
	end
	
	Players.PlayerAdded:Connect(newPlayer)
	Players.PlayerRemoving:Connect(function(player)
		if tracers[player] then
			if tracers[player] then
				tracers[player][1]:Destroy()
				tracers[player] = nil
			end
			characters[player] = nil
		end
	end)
	for _, player in pairs(Players:GetPlayers()) do
		newPlayer(player)
	end
	
	local function divideUDim(udim, factor)
		return UDim2.new(udim.X.Scale / factor, udim.X.Offset / factor, udim.Y.Scale / factor, udim.Y.Offset / factor)
	end
	
	RunService.RenderStepped:Connect(function()
		if module.Options.Enabled then
			for player, data in pairs(tracers) do
				local line, target = unpack(data)
				if (target and (player.Team == Player.Team and module.Options.ShowTeam) or player.Team ~= Player.Team) and (target.Position - Camera.CFrame.p).Magnitude <= module.Options.MaxDistance then
					if (player == Player and module.Options.ShowSelf) or player ~= Player then
						if line.Parent ~= Screen then
							line.Parent = Screen
						end
						
						local point1 = (Camera.CFrame * CFrame.new(0, 0, -0.5) - Vector3.new(0, 3, 0)).p
						local point2 = target.Position - Vector3.new(0, 3, 0)
						
						local distance = point1 - point2
						local magnitude = distance.Magnitude
						
						local c = module.Options.Color
						
						line.CFrame = CFrame.new(point1, point2)
						
						line.A.Thickness = module.Options.Radius
						line.A.Length = magnitude
						line.A.Color3 = Color3.new(c.r*5,c.g*5,c.b*5)
						line.A.Transparency = 1 - module.Options.Opacity
					else
						line.Parent = nil
					end
				else
					line.Parent = nil
				end
			end
		end
	end)
	
	spawn(function()
		while wait(2) do
			if module.Options.Enabled then
				module:ReloadCharacters()
			end
		end
	end)
	
	return module
	
end)()
local _Aimbot = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	    local Mouse = Player:GetMouse()
	local Camera = workspace.CurrentCamera
	
	local nearestCharacters = {}
	local module = {}
	
	module.Options = {
		Easing = 2,
		Enabled = false,
		ShowTeams = false,
		MaxDistance = 500,
		Legit = false,
		AimPart = "Head",
		Onscreen = false,
		Visible = true,
		Mode = "Nearest",
		Radius = 250,
	}
	
	--// Functions
	local function findPart(Model)
		return Model:FindFirstChild(module.Options.AimPart) or Model:FindFirstChild("HumanoidRootPart") or Model.PrimaryPart or Model:FindFirstChildWhichIsA("Part", true)
	end
	
	local mousemoverel = (mousemoverel or (Input and Input.MouseMove)) or function() end
	
	local function mouseMove(x, y, depth)
		local v1, v2 = Vector2.new(x, y), Vector2.new(Mouse.X, Mouse.Y)
		local viewCenter = Vector2.new(Mouse.ViewSizeX/2, Mouse.ViewSizeY/2)
		
		if depth < 0 then
			local n = 1
			if (v1 - v2).X < 0 then
				n = -1
			end
			if math.abs(v1.X - v2.X) < Mouse.ViewSizeX * 1.5 then
				n = n / 2
			end
			v1 = v1 + Vector2.new(Mouse.ViewSizeX * n, 0)
		end
		
		local diff = (v1 - v2) / module.Options.Easing
		
		if module.Options.Legit then
			diff = diff.Unit * diff.Magnitude
		end
		
		mousemoverel(diff.X, diff.Y)
	end
	
	local function updateMouse(target)
		if not target then return end
		local posVector3 = Camera:WorldToScreenPoint(target.Position)
		local posVector2, distance = Vector2.new(posVector3.X, posVector3.Y), posVector3.Z
		mouseMove(posVector2.X, posVector2.Y, posVector3.Z)
	end
	
	local function updateNearest()
		nearestCharacters = {}
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= Player then
				if (player.Team == Player.Team and module.Options.ShowTeams) or player.Team ~= Player.Team then
					if player.Character then
						local part = findPart(player.Character)
						if part then --too many ifs
							local distance = (part.Position - Camera.CFrame.p).Magnitude
							
							local a, onScreen = Camera:WorldToScreenPoint(part.Position)
							local obstructed = #Camera:GetPartsObscuringTarget({part.Position}, {player.Character, Player.Character}) > 0
							
							if distance <= module.Options.MaxDistance then
								if (module.Options.Onscreen and onScreen) or not module.Options.Onscreen then
									if (module.Options.Visible and not obstructed) or not module.Options.Visible then
										table.insert(nearestCharacters, {tostring(distance), part, a.Z})
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	local windowFocused = true
	RunService.RenderStepped:Connect(function()
		if module.Options.Enabled == false or not windowFocused then return end
		updateNearest()
		
		local dist, nearestPart = 2048
		
		table.sort(nearestCharacters, function(a, b)
			local D1, NP1 = unpack(a)
			local D2, NP2 = unpack(b)
			return tonumber(D1) < tonumber(D2)
		end)
		
		if module.Options.Mode == "Nearest" then
			if nearestCharacters[1] then
				local D, NP = unpack(nearestCharacters[1])
				nearestPart = NP
			end
		else
			for i, v in pairs(nearestCharacters) do
				local D, NP, Depth = unpack(v)
				
				local pV3 = Camera:WorldToScreenPoint(NP.Position)
				local v1, v2 = Vector2.new(pV3.X, pV3.Y), Vector2.new(Mouse.X, Mouse.Y)
				
				if (v1 - v2).Magnitude <= module.Options.Radius and Depth >= 0 then
					nearestPart = NP
					break
				end
			end
		end
		
		if nearestPart then
			updateMouse(nearestPart)
		end
	end)
	
	UserInputService.WindowFocused:Connect(function()
		windowFocused = true
	end)
	UserInputService.WindowFocusReleased:Connect(function()
		windowFocused = false
	end)
	
	return module
	
end)()
local _Flight = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	    local character = Player.Character
	local camera = workspace.CurrentCamera
	
	local module = {}
	module.Options = {
		Speed = 5,
		Smoothness = 0.2,
	}
	
	local lib, connections = {}, {}
	lib.connect = function(name, connection)
		connections[name .. tostring(math.random(1000000, 9999999))] = connection
		return connection
	end
	lib.disconnect = function(name)
		for title, connection in pairs(connections) do
			if title:find(name) == 1 then
				connection:Disconnect()
			end
		end
	end
	
	--// Functions
	local flyPart
	
	local function flyEnd()
		lib.disconnect("fly")
		if flyPart then
			--flyPart:Destroy()
		end
		character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
		if character and character.Parent and flyPart then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Velocity = Vector3.new()
				end
			end
		end
	end
	
	module.flyStart = function(enabled)
		if not enabled then flyEnd() return end
		local dir = {w = false, a = false, s = false, d = false}
		local cf = Instance.new("CFrameValue")
		
		flyPart = flyPart or Instance.new("Part")
		flyPart.Anchored = true
		pcall(function()
			flyPart.CFrame = character.HumanoidRootPart.CFrame
		end)
		
		lib.connect("fly", RunService.Heartbeat:Connect(function()
			if not character or not character.Parent or not character:FindFirstChild("HumanoidRootPart") then return end
	
			local primaryPart = character.HumanoidRootPart
			local humanoid = character:FindFirstChildWhichIsA("Humanoid")
			local speed = module.Options.Speed
			
			local x, y, z = 0, 0, 0
			if dir.w then z = -1 * speed end
			if dir.a then x = -1 * speed end
			if dir.s then z = 1 * speed end
			if dir.d then x = 1 * speed end
			if dir.q then y = 1 * speed end
			if dir.e then y = -1 * speed end
			
			flyPart.CFrame = CFrame.new(
				flyPart.CFrame.p,
				(camera.CFrame * CFrame.new(0, 0, -2048)).p
			)
			
			for _, part in pairs(character:GetChildren()) do
				if part:IsA("BasePart") then
					part.Velocity = Vector3.new()
				end
			end
			
			local moveDir = CFrame.new(x,y,z)
			cf.Value = cf.Value:lerp(moveDir, module.Options.Smoothness)
			flyPart.CFrame = flyPart.CFrame:lerp(flyPart.CFrame * cf.Value, module.Options.Smoothness)
			primaryPart.CFrame = flyPart.CFrame
			humanoid.PlatformStand = true
		end))
		lib.connect("fly", UserInputService.InputBegan:Connect(function(input, event)
			if event then return end
			local code, codes = input.KeyCode, Enum.KeyCode
			if code == codes.W then
				dir.w = true
			elseif code == codes.A then
				dir.a = true
			elseif code == codes.S then
				dir.s = true
			elseif code == codes.D then
				dir.d = true
			elseif code == codes.Q then
				dir.q = true
			elseif code == codes.E then
				dir.e = true
			elseif code == codes.Space then
				dir.q = true
			end
		end))
		lib.connect("fly", UserInputService.InputEnded:Connect(function(input, event)
			if event then return end
			local code, codes = input.KeyCode, Enum.KeyCode
			if code == codes.W then
				dir.w = false
			elseif code == codes.A then
				dir.a = false
			elseif code == codes.S then
				dir.s = false
			elseif code == codes.D then
				dir.d = false
			elseif code == codes.Q then
				dir.q = false
			elseif code == codes.E then
				dir.e = false
			elseif code == codes.Space then
				dir.q = false
			end
		end))
	end
	
	--// Events
	Player.CharacterAdded:Connect(function(char)
		character = char
	end)
	
	return module
end)()
local _Freecam = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	    local character = Player.Character
	local camera = workspace.CurrentCamera
	
	local module = {}
	module.Options = {
		Speed = 5,
		Smoothness = 0.2,
	}
	
	local lib, connections = {}, {}
	lib.connect = function(name, connection)
		connections[name .. tostring(math.random(1000000, 9999999))] = connection
		return connection
	end
	lib.disconnect = function(name)
		for title, connection in pairs(connections) do
			if title:find(name) == 1 then
				connection:Disconnect()
			end
		end
	end
	
	--// Functions
	local flyPart
	
	local function flyEnd()
		lib.disconnect("freecam")
		camera.CameraSubject = character
		pcall(function()
			character.PrimaryPart.Anchored = false
		end)
	end
	
	module.flyStart = function(enabled)
		if not enabled then flyEnd() return end
		local dir = {w = false, a = false, s = false, d = false}
		local cf = Instance.new("CFrameValue")
		local camPart = Instance.new("Part")
		camPart.Transparency = 1
		camPart.Anchored = true
		camPart.CFrame = camera.CFrame
		pcall(function()
			character.PrimaryPart.Anchored = true
		end)
		
		lib.connect("freecam", RunService.RenderStepped:Connect(function()
			local primaryPart = camPart
			camera.CameraSubject = primaryPart
			
			local speed = module.Options.Speed
			
			local x, y, z = 0, 0, 0
			if dir.w then z = -1 * speed end
			if dir.a then x = -1 * speed end
			if dir.s then z = 1 * speed end
			if dir.d then x = 1 * speed end
			if dir.q then y = 1 * speed end
			if dir.e then y = -1 * speed end
			
			primaryPart.CFrame = CFrame.new(
				primaryPart.CFrame.p,
				(camera.CFrame * CFrame.new(0, 0, -100)).p
			)
			
			local moveDir = CFrame.new(x,y,z)
			cf.Value = cf.Value:lerp(moveDir, module.Options.Smoothness)
			primaryPart.CFrame = primaryPart.CFrame:lerp(primaryPart.CFrame * cf.Value, module.Options.Smoothness)
		end))
		lib.connect("freecam", UserInputService.InputBegan:Connect(function(input, event)
			if event then return end
			local code, codes = input.KeyCode, Enum.KeyCode
			if code == codes.W then
				dir.w = true
			elseif code == codes.A then
				dir.a = true
			elseif code == codes.S then
				dir.s = true
			elseif code == codes.D then
				dir.d = true
			elseif code == codes.Q then
				dir.q = true
			elseif code == codes.E then
				dir.e = true
			elseif code == codes.Space then
				dir.q = true
			end
		end))
		lib.connect("freecam", UserInputService.InputEnded:Connect(function(input, event)
			if event then return end
			local code, codes = input.KeyCode, Enum.KeyCode
			if code == codes.W then
				dir.w = false
			elseif code == codes.A then
				dir.a = false
			elseif code == codes.S then
				dir.s = false
			elseif code == codes.D then
				dir.d = false
			elseif code == codes.Q then
				dir.q = false
			elseif code == codes.E then
				dir.e = false
			elseif code == codes.Space then
				dir.q = false
			end
		end))
	end
	
	--// Events
	Player.CharacterAdded:Connect(function(char)
		character = char
	end)
	
	return module
end)()
local _Rubberbanding = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	    local Character = Player.Character
	
	local module = {}
	module.Options = {
		Enabled = false,
		Threshold = 150,
		UpdateSpeed = 100,
	}
	
	local connections = {}
	
	--// Functions
	local function getPart(Model)
		return Model.PrimaryPart or Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChildWhichIsA("Part")
	end
	
	local function connectPart(Part)
		local lastPosition = CFrame.new()
		local lastVelocity = Vector3.new()
		local lastRender = tick()
		
		connections[#connections+1] = RunService.RenderStepped:Connect(function()
			if not module.Options.Enabled then return end
			
			if Part and (tick() - lastRender >= module.Options.UpdateSpeed / 1000) then
				if (lastVelocity - Part.Velocity).Magnitude > module.Options.Threshold and Part.Velocity.Magnitude > lastVelocity.Magnitude then
					Part.Velocity = lastVelocity
					Part.CFrame = lastPosition
				end
				
				lastPosition = Part.CFrame
				lastVelocity = Part.Velocity
				lastRender = tick()
			end
		end)
	end
	
	local function onCharacter(char)
		Character = char
		for i, v in pairs(connections) do
			v:Disconnect()
			connections[i] = nil
		end
		for _, part in pairs(char:GetChildren()) do
			if part.Name == "HumanoidRootPart" then
				connectPart(part)
			end
		end
		connections[#connections+1] = Character.ChildAdded:Connect(function(child)
			if child.Name == "HumanoidRootPart" then
				connectPart(child)
			end
		end)
	end
	
	
	module.Toggle = function(enabled)
		module.Options.Enabled = enabled
		for i, v in pairs(connections) do
			v:Disconnect()
			connections[i] = nil
		end
		if enabled and Character then
			onCharacter(Character)
		end
	end
	
	--// Events
	Player.CharacterAdded:Connect(function(char)
		onCharacter(char)
	end)
	
	if Character then
		onCharacter(Character)
	end
	
	return module
	
end)()
local _AntiTP = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	    local Character = Player.Character
	
	local module = {}
	module.Options = {
		Enabled = false,
		Threshold = 150,
		UpdateSpeed = 100,
	}
	
	local connections = {}
	
	--// Functions
	local function getPart(Model)
		return Model.PrimaryPart or Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChildWhichIsA("Part")
	end
	
	local function connectPart(Part)
		local lastPosition = Part.CFrame
		local lastRender = tick()
		
		connections[#connections+1] = RunService.RenderStepped:Connect(function()
			if not module.Options.Enabled then return end
			
			if Part and (tick() - lastRender >= module.Options.UpdateSpeed / 1000) then
				if (lastPosition.p - Part.Position).Magnitude > module.Options.Threshold then
					Part.CFrame = lastPosition
					Part.Velocity = Vector3.new(0, 0, 0)
				end
				
				lastPosition = Part.CFrame
				lastRender = tick()
			end
		end)
	end
	
	local function onCharacter(char)
		Character = char
		for i, v in pairs(connections) do
			v:Disconnect()
			connections[i] = nil
		end
		for _, part in pairs(char:GetChildren()) do
			if part.Name == "HumanoidRootPart" then
				connectPart(part)
			end
		end
		connections[#connections+1] = Character.ChildAdded:Connect(function(child)
			if child.Name == "HumanoidRootPart" then
				connectPart(child)
			end
		end)
	end
	
	module.Toggle = function(enabled)
		module.Options.Enabled = enabled
		for i, v in pairs(connections) do
			v:Disconnect()
			connections[i] = nil
		end
		if enabled and Character then
			onCharacter(Character)
		end
	end
	
	--// Events
	Player.CharacterAdded:Connect(function(char)
		onCharacter(char)
	end)
	
	if Character then
		onCharacter(Character)
	end
	
	return module
	
end)()
local _Noclip = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	    local Character = Player.Character
	
	local module = {}
	module.Options = {
		Enabled = false,
	}
	
	local connections = {}
	
	--// Functions
	local function getPart(Model)
		return Model.PrimaryPart or Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChildWhichIsA("Part")
	end
	
	local function connectModel(Model)
		connections[#connections+1] = RunService.Stepped:Connect(function()
			if not module.Options.Enabled then return end
			for _, part in pairs(Model:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end)
	end
	
	module.Toggle = function(enabled)
		module.Options.Enabled = enabled
		for i, v in pairs(connections) do
			v:Disconnect()
			connections[i] = nil
		end
		if enabled and Character then
			onCharacter(Character)
		end
	end
	
	function onCharacter(char)
		for i, v in pairs(connections) do
			v:Disconnect()
			connections[i] = nil
		end
		Character = char
		connectModel(char)
	end
	
	--// Events
	Player.CharacterAdded:Connect(function(char)
		onCharacter(char)
	end)
	
	if Character then
		onCharacter(Character)
	end
	
	return module
	
end)()