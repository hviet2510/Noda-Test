local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player, char = Players.LocalPlayer, Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local Config = require(script.Parent.Config)
local Enemies = require(script.Parent.EnemyList)

local Toggle = false
Config.Toggle("Auto Farm", false, function(v) Toggle = v end)

local function Notify(msg)
	pcall(function()
		game.StarterGui:SetCore("SendNotification", {Title = "AutoFarm", Text = msg, Duration = 3})
	end)
end

local function SafeTween(pos)
	local tween = TweenService:Create(root, TweenInfo.new((root.Position - pos).Magnitude / 150, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
	tween:Play()
	tween.Completed:Wait()
end

local function AutoEquip()
	for _, tool in ipairs(player.Backpack:GetChildren()) do
		if tool:IsA("Tool") and string.find(tool.Name:lower(), "combat") then
			tool.Parent = char
			break
		end
	end
end

local function StartQuest(questName)
	local args = {[1] = questName, [2] = 1}
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", unpack(args))
end

local function QuestDone()
	local questGui = player.PlayerGui:FindFirstChild("QuestGUI")
	local container = questGui and questGui:FindFirstChild("Container")
	local title = container and container:FindFirstChild("QuestTitle")
	if title and title:IsA("TextLabel") then
		return not string.find(title.Text:lower(), Config.CurrentMob:lower())
	end
	return true
end

local function AttackMob()
	for _, mob in ipairs(workspace.Enemies:GetChildren()) do
		if mob.Name == Config.CurrentMob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
			repeat task.wait()
				if (root.Position - mob.HumanoidRootPart.Position).Magnitude > 30 then
					SafeTween(mob.HumanoidRootPart.Position + Vector3.new(0, 30, 0))
				end
				AutoEquip()
				pcall(function()
					for _, v in ipairs(char:GetChildren()) do
						if v:IsA("Tool") then v:Activate() end
					end
				end)
			until not Toggle or mob.Humanoid.Health <= 0 or not mob.Parent
		end
	end
end

while task.wait() do
	if Toggle then
		Config:UpdateMob()
		if QuestDone() then
			StartQuest(Config.QuestName)
			Notify("🧭 Nhận nhiệm vụ " .. Config.QuestName)
			task.wait(0.5)
		end
		AttackMob()
	end
end
