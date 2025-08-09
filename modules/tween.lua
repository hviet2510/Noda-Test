-- File: tween.lua
-- Module cơ bản để quản lý chuyển động mượt mà của nhân vật

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local tweenModule = {}

local currentTween = nil -- Biến để lưu trữ tween đang chạy

-- Hàm chính để di chuyển nhân vật
function tweenModule:MoveTo(targetPosition)
    -- Nếu đang có một chuyển động cũ, hủy nó đi
    if currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing then
        currentTween:Cancel()
    end

    local player = Players.LocalPlayer
    local character = player and player.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Cấu hình cho chuyển động (0.5 giây, kiểu Quad cho tự nhiên)
    local tweenInfo = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    -- Đích đến mong muốn
    local goal = {
        CFrame = CFrame.new(targetPosition)
    }

    -- Tạo và chạy tween mới
    currentTween = TweenService:Create(hrp, tweenInfo, goal)
    currentTween:Play()
end

-- Hàm để dừng chuyển động ngay lập tức
function tweenModule:Stop()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
end

return tweenModule
