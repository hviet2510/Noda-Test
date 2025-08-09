-- File: autofarm.lua
-- Phiên bản hoàn chỉnh: Tích hợp tween.lua module, callback, tối ưu cho mobile & Sea 1

return function(Window)
    -- ==================== KHỞI TẠO & LẤY DỊCH VỤ ====================
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local Player = Players.LocalPlayer
    local Character, Humanoid, HRP
    local farming = false
    local selectedFarmMode = "Tự động"
    local attackKey = "Z"

    -- Lấy module tween và enemylist
    local tween = _G.modules.tween
    if not tween or not tween.MoveTo or not tween.Stop then
        Window:MakeNotification({
            Name = "AutoFarm",
            Content = "Lỗi: Module tween không hợp lệ hoặc không tồn tại! Dùng di chuyển cơ bản.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        tween = {
            MoveTo = function(pos, dur, cb)
                local char = Player and Player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(pos) end
                if cb then cb() end
            end,
            Stop = function() end
        }
    end

    local FarmAreas = _G.modules.enemylist
    if not FarmAreas or type(FarmAreas) ~= "table" then
        Window:MakeNotification({
            Name = "AutoFarm",
            Content = "Lỗi: Dữ liệu enemylist.lua không hợp lệ!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        return
    end

    -- ==================== HÀM HỖ TRỢ ====================
    local function UpdateCharacter()
        Character = Player.Character
        if Character then
            Humanoid = Character:FindFirstChildOfClass("Humanoid")
            HRP = Character:FindFirstChild("HumanoidRootPart")
        end
    end
    Player.CharacterAdded:Connect(UpdateCharacter)
    UpdateCharacter()

    local function getPlayerLevel()
        local success, level = pcall(function() return Player.Data.Level.Value end)
        return success and level or 1
    end

    -- Kiểm tra RemoteFunction 'Comm'
    local Comm
    do
        local success, err = pcall(function()
            Comm = ReplicatedStorage.Remotes:WaitForChild("Comm", 5)
        end)
        if not success or not Comm then
            Window:MakeNotification({
                Name = "AutoFarm",
                Content = "Không tìm thấy RemoteFunction 'Comm'. Quest có thể không hoạt động.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end

    -- ==================== CÁC HÀM LOGIC ====================
    local function EquipMelee(StatusLabel)
        if not Character or Character:FindFirstChildOfClass("Tool") then return true end
        StatusLabel:Set("Đang tìm vũ khí Melee...")
        local Backpack = Player:WaitForChild("Backpack")
        for _, v in ipairs(Backpack:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") and v.ToolTip == "Melee" then
                Humanoid:EquipTool(v)
                task.wait(0.5)
                return true
            end
        end
        return false
    end

    local function GetBestFarmArea(currentLevel)
        for _, data in ipairs(FarmAreas) do
            if currentLevel >= data.MinLevel and currentLevel <= data.MaxLevel then
                return data
            end
        end
    end

    local function GetSpecificFarmArea(mobName)
        for _, data in ipairs(FarmAreas) do
            if data.Mob == mobName then return data end
        end
    end

    local function GetQuest(farmData, StatusLabel, callback)
        if not farmData.QuestPos or not farmData.QuestName then
            if callback then callback() end
            return
        end

        local questNPC = Workspace.NPCs:FindFirstChild(farmData.QuestName)
        if questNPC and questNPC:FindFirstChild("ClickDetector") then
            StatusLabel:Set("Đang nhận nhiệm vụ: " .. farmData.Mob)
            tween:MoveTo(farmData.QuestPos.Position, 1, function()
                local clickDetector = questNPC:FindFirstChild("ClickDetector")
                if clickDetector then pcall(function() fireclickdetector(clickDetector) end) end
                task.wait(1)
                if Comm then pcall(function() Comm:InvokeServer("StartQuest", farmData.QuestName, farmData.QuestNumber) end) end
                if callback then callback() end
            end)
        else
            if callback then callback() end
        end
    end

    local function AttackMob(enemyData, StatusLabel, callback)
        local targetMob = nil
        local minDistance = 50
        for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
            local mobHRP = mob:FindFirstChild("HumanoidRootPart")
            if mobHRP and mob.Name == enemyData.Mob and mob.Humanoid.Health > 0 then
                local distance = (HRP.Position - mobHRP.Position).Magnitude
                if distance < minDistance then
                    minDistance = distance
                    targetMob = mob
                end
            end
        end

        if targetMob then
            local destination = targetMob.HumanoidRootPart.Position + Vector3.new(0, -1, 3)
            tween:MoveTo(destination, 1, function()
                task.spawn(function()
                    while farming and targetMob.Parent and targetMob.Humanoid.Health > 0 do
                        StatusLabel:Set("Đang tấn công " .. targetMob.Name)
                        pcall(function()
                            VirtualInputManager:SendKeyEvent(true, attackKey, false, game)
                            task.wait(0.1)
                            VirtualInputManager:SendKeyEvent(false, attackKey, false, game)
                        end)
                        task.wait(0.5)
                    end
                    if callback then callback() end
                end)
            end)
        else
            StatusLabel:Set("Đang chờ quái xuất hiện...")
            task.delay(3, function()
                if callback then callback() end
            end)
        end
    end

    local function StartFarming(StatusLabel)
        if not farming then
            StatusLabel:Set("Trạng thái: Đã tắt farm")
            return
        end

        task.spawn(function()
            while farming do
                task.wait(1)

                if not Humanoid or Humanoid.Health <= 0 then
                    StatusLabel:Set("Nhân vật đã chết, đang chờ...")
                    tween:Stop()
                    Player.CharacterAdded:Wait()
                    task.wait(5)
                    UpdateCharacter()
                else
                    if not EquipMelee(StatusLabel) then
                        StatusLabel:Set("Lỗi: Không tìm thấy vũ khí Melee!")
                        farming = false
                        break
                    end

                    local enemy
                    if selectedFarmMode == "Tự động" then
                        StatusLabel:Set("Tìm khu vực theo cấp độ...")
                        local level = getPlayerLevel()
                        enemy = GetBestFarmArea(level)
                    else
                        StatusLabel:Set("Tìm khu vực: " .. selectedFarmMode)
                        enemy = GetSpecificFarmArea(selectedFarmMode)
                    end

                    if enemy then
                        local hasQuest = false
                        local questGui = Player.PlayerGui:FindFirstChild("Main") and Player.PlayerGui.Main:FindFirstChild("Quest")
                        if questGui and questGui.Visible and string.find(questGui.Container.QuestTitle.Title.Text, enemy.Mob) then
                            hasQuest = true
                        end
                        if not hasQuest then
                            GetQuest(enemy, StatusLabel, function()
                                if farming then
                                    -- Tiếp tục vòng farm sau khi nhận quest xong
                                end
                            end)
                        else
                            AttackMob(enemy, StatusLabel, function()
                                if farming then
                                    -- Tiếp tục vòng farm sau khi tấn công xong
                                end
                            end)
                        end
                    else
                        StatusLabel:Set("Không tìm thấy khu vực phù hợp.")
                        task.wait(5)
                    end
                end
            end
            tween:Stop()
            StatusLabel:Set("Trạng thái: Đã tắt farm")
        end)
    end

    -- ==================== TẠO GIAO DIỆN ====================
    local FarmTab = Window:MakeTab({ Name = "Auto Farm", Icon = "rbxassetid://1522332854" })
    FarmTab:AddSection("Điều Khiển")
    local StatusLabel = FarmTab:AddLabel("Trạng thái: Chờ lệnh")

    FarmTab:AddToggle({
        Name = "Bật/Tắt Auto Farm", Default = false,
        Callback = function(state)
            farming = state
            if farming then
                StatusLabel:Set("Bắt đầu farm...")
                StartFarming(StatusLabel)
            else
                tween:Stop()
                StatusLabel:Set("Trạng thái: Đã dừng")
            end
        end
    })

    FarmTab:AddSection("Cài Đặt")
    local farmOptions = {"Tự động"}
    for _, area in ipairs(FarmAreas) do
        table.insert(farmOptions, area.Mob)
    end

    FarmTab:AddDropdown({
        Name = "Chọn khu vực farm", Options = farmOptions, Default = "Tự động",
        Callback = function(choice)
            selectedFarmMode = choice
            StatusLabel:Set("Chế độ farm: " .. choice)
        end
    })

    FarmTab:AddTextbox({
        Name = "Phím tấn công", Default = "Z", TextDisappear = false,
        Callback = function(text)
            attackKey = text:upper()
        end
    })
end
