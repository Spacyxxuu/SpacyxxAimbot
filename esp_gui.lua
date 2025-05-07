local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local gui = script.Parent
local espBtn = gui:WaitForChild("ESPButton")
local nameBtn = gui:WaitForChild("NameButton")

local ESP_ACTIVE = false
local NAME_ACTIVE = false

function createESP(part)
	local box = Instance.new("BoxHandleAdornment")
	box.Name = "ESP_BOX"
	box.Adornee = part
	box.AlwaysOnTop = true
	box.ZIndex = 5
	box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
	box.Transparency = 0.5
	box.Color3 = Color3.fromRGB(255, 0, 0)
	box.Parent = part
end

function createNameBillboard(char, playerName)
	local head = char:FindFirstChild("Head")
	if head and not head:FindFirstChild("ESP_NAME") then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "ESP_NAME"
		billboard.Size = UDim2.new(0, 100, 0, 40)
		billboard.AlwaysOnTop = true
		billboard.Adornee = head
		billboard.StudsOffset = Vector3.new(0, 2, 0)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = playerName
		label.TextColor3 = Color3.new(1, 0, 0)
		label.TextStrokeTransparency = 0.5
		label.Font = Enum.Font.GothamBold
		label.TextScaled = true
		label.Parent = billboard

		billboard.Parent = head
	end
end

function applyESP(char, playerName)
	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") and part.Name == "HumanoidRootPart" then
			if ESP_ACTIVE and not part:FindFirstChild("ESP_BOX") then
				createESP(part)
			elseif not ESP_ACTIVE and part:FindFirstChild("ESP_BOX") then
				part.ESP_BOX:Destroy()
			end
		end
	end

	if NAME_ACTIVE then
		createNameBillboard(char, playerName)
	elseif char:FindFirstChild("Head") and char.Head:FindFirstChild("ESP_NAME") then
		char.Head.ESP_NAME:Destroy()
	end
end

function handlePlayer(player)
	if player == localPlayer then return end
	player.CharacterAdded:Connect(function(char)
		wait(1)
		applyESP(char, player.Name)
	end)
	if player.Character then
		applyESP(player.Character, player.Name)
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	handlePlayer(player)
end

Players.PlayerAdded:Connect(handlePlayer)

espBtn.MouseButton1Click:Connect(function()
	ESP_ACTIVE = not ESP_ACTIVE
	espBtn.Text = "ESP: " .. (ESP_ACTIVE and "ON" or "OFF")

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			applyESP(player.Character, player.Name)
		end
	end
end)

nameBtn.MouseButton1Click:Connect(function()
	NAME_ACTIVE = not NAME_ACTIVE
	nameBtn.Text = "Noms: " .. (NAME_ACTIVE and "ON" or "OFF")

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			applyESP(player.Character, player.Name)
		end
	end
end)
