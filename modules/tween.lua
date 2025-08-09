-- tween.lua
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local TweenModule = {}
local currentTween

function TweenModule:MoveTo(targetPosition, duration, callback)
    local player = Players.LocalPlayer
    if not player then return end

    local character = player.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    duration = duration or 1

    -- Nếu có tween đang chạy thì hủy
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end

    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )

    currentTween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    currentTween:Play()

    if callback then
        currentTween.Completed:Connect(function()
            callback()
            currentTween = nil
        end)
    else
        currentTween.Completed:Connect(function()
            currentTween = nil
        end)
    end
end

function TweenModule:Stop()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
end

return TweenModule
