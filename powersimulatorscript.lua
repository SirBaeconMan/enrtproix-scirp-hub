local IARemote = game:GetService("ReplicatedStorage").IncreaseAbilities
local ERemote = game:GetService("ReplicatedStorage").EquipAbility
local abilities = {"PunchPower", "Endurance", "Psychic Force"}

while true do
	for _, v in pairs(abilities) do
		ERemote:FireServer(v)
		IARemote:FireServer(v)
	end
	wait(.25)
end