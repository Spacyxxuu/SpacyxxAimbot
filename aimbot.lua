local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

function createESPBox(part)
	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = part
	box.AlwaysOnTop = true
	box.ZIndex = 5
	box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
	box.Transparency = 0.5
	box.Color3 = Color3.fromRGB(255, 0, 0)
	box.Name = "ESPBox"
	box.Parent = part
end

function applyESPToCharacter(char)
	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") and not part:FindFirstChild("ESPBox") then
			createESPBox(part)
		end
	end
end

function handlePlayer(player)
	if player == localPlayer then return end
	player.CharacterAdded:Connect(function(char)
		wait(1) -- attendre le chargement
		applyESPToCharacter(char)
	end)
	if player.Character then
		applyESPToCharacter(player.Character)
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	handlePlayer(player)
end

Players.PlayerAdded:Connect(handlePlayer)
