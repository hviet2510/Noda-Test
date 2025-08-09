-- tween.lua
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local TweenModule = {}
TweenModule.CurrentTween = nil

-- MoveTo di chuyển mượt đến targetPosition (Vector3)
-- duration: số giây, mặc định 1
-- onComplete: hàm callback khi tween hoàn thành (tùy chọn)
function TweenModule:MoveTo(targetPosition, duration, onComplete)
    local player = Players.LocalPlayer
    if not player then return nil end

    local character = player.Character or player.CharacterAdded:Wait()
    if not character then return nil end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    -- Hủy tween cũ nếu còn chạy
    if self.CurrentTween then
        self.CurrentTween:Cancel()
        self.CurrentTween = nil
    end

    duration = duration or 1
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPosition)}

    local tween = TweenService:Create(hrp, tweenInfo, goal)
    self.CurrentTween = tween

    if onComplete and type(onComplete) == "function" then
        tween.Completed:Connect(function(status)
            -- chỉ gọi khi tween hoàn tất tự nhiên, không gọi nếu bị cancel
            if status == Enum.PlaybackState.Completed then
                onComplete()
            end
        end)
    end

    tween:Play()
    return tween
end

-- Dừng tween hiện tại nếu có
function TweenModule:Stop()
    if self.CurrentTween then
        self.CurrentTween:Cancel()
        self.CurrentTween = nil
    end
end

return TweenModule
