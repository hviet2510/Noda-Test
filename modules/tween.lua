-- tween.lua
-- Module quản lý di chuyển mượt mà với TweenService
local TweenService = game:GetService("TweenService")

local TweenModule = {}

-- Tạo tween cho di chuyển
function TweenModule:MoveTo(targetPosition)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local humanoidRootPart = character.HumanoidRootPart
    local tweenInfo = TweenInfo.new(
        1, -- Thời gian di chuyển (1 giây, có thể điều chỉnh)
        Enum.EasingStyle.Linear, -- Phong cách di chuyển
        Enum.EasingDirection.Out, -- Hướng di chuyển
        0, -- Số lần lặp
        false, -- Không đảo ngược
        0 -- Độ trễ
    )

    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    tween.Completed:Wait() -- Chờ tween hoàn tất
end

-- Dừng tất cả tween hiện tại
function TweenModule:Stop()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    TweenService:CancelAll()
end

return TweenModule
