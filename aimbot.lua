-- Aimbot activé avec clic droit
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

local radius = 100

function getClosestPlayer()
	local closest = nil
	local shortestDistance = radius
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local pos, onScreen = camera:WorldToViewportPoint(head.Position)
			local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
			if onScreen and dist < shortestDistance then
				shortestDistance = dist
				closest = player
			end
		end
	end
	return closest
end

RunService.RenderStepped:Connect(function()
	if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local target = getClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)
