-- Gọi lib & modules
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/hviet2510/Noda-Test/refs/heads/main/modules/Orion.lua"))()
local Points = loadstring(game:HttpGet("https://raw.githubusercontent.com/hviet2510/Noda-Test/refs/heads/main/modules/Points.lua"))()
local Actions = loadstring(game:HttpGet("https://raw.githubusercontent.com/hviet2510/Noda-Test/refs/heads/main/modules/Actions.lua"))()

local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")

local LocalPlayer = Players.LocalPlayer
local RootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")

-- AutoFarm toggle
local AutoFarm = false
local MoveMethod = "Walk"

-- Hàm Pathfinding move
local function MoveTo(pos)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = 7,
        AgentMaxSlope = 45
    })

    path:ComputeAsync(RootPart.Position, pos)
    local waypoints = path:GetWaypoints()

    if path.Status == Enum.PathStatus.Complete then
        for _, waypoint in ipairs(waypoints) do
            Humanoid:MoveTo(waypoint.Position)
            Humanoid.MoveToFinished:Wait()
        end
    else
        warn("[MoveTo] Không tìm được đường đi")
    end
end

-- SmartMove (walk / teleport)
local function SmartMove(pos)
    if MoveMethod == "Walk" then
        MoveTo(pos)
    elseif MoveMethod == "Teleport" then
        RootPart.CFrame = CFrame.new(pos)
    end
end

-- AutoFarm logic
task.spawn(function()
    while task.wait(1) do
        if AutoFarm then
            local dig = Points:GetDigPoint()
            local pan = Points:GetPanPoint()
            if dig and pan then
                SmartMove(dig)
                Actions:Dig()

                SmartMove(pan)
                Actions:Pan()
            end
        end
    end
end)

-- UI
local Window = OrionLib:MakeWindow({Name = "Prospecting AutoFarm", HidePremium = false, SaveConfig = true})
local Tab = Window:MakeTab({Name = "Pan", Icon = "rbxassetid://4483345998", PremiumOnly = false})

Tab:AddDropdown({
    Name = "Movement Method",
    Default = "Walk",
    Options = {"Walk","Teleport"},
    Callback = function(Value)
        MoveMethod = Value
    end    
})

Tab:AddButton({
    Name = "Set Dig Point",
    Callback = function()
        Points:SetDigPoint(RootPart.Position)
    end
})

Tab:AddButton({
    Name = "Set Pan Point",
    Callback = function()
        Points:SetPanPoint(RootPart.Position)
    end
})

Tab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(Value)
        AutoFarm = Value
    end
})
