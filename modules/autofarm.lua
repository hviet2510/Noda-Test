-- File: autofarm.lua
-- Phiên bản hoàn chỉnh: Tích hợp Tween.lua cho chuyển động mượt mà

return function(Window)
    -- ==================== KHỞI TẠO & LẤY DỊCH VỤ ====================
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    
    -- CẬP NHẬT: Lấy module tween đã được loader tải
    local tween = _G.modules.tween
    if not tween then
        warn("autofarm.lua: Không thể tìm thấy tween.lua! Nhân vật sẽ không di chuyển.")
        -- Tạo một hàm giả để script không bị lỗi
        tween = { MoveTo = function() end, Stop = function() end }
    end

    local FarmAreas = _G.modules.enemylist
    if not FarmAreas then
        warn("autofarm.lua: Không thể tìm thấy dữ liệu từ enemylist.lua!")
        return
    end

    -- Các biến trạng thái của script
    local Player = Players.LocalPlayer
    local Character, Humanoid, HRP
    local farming = false
    local selectedFarmMode = "Tự động"
    local attackKey = "Z"

    -- Hàm cập nhật thông tin nhân vật
    local function UpdateCharacter()
        Character = Player.Character
        Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        HRP = Character and Character:FindFirstChild("HumanoidRootPart")
    end
    Player.CharacterAdded:Connect(UpdateCharacter)
    UpdateCharacter()

    -- Kiểm tra RemoteFunction 'Comm'
    local success, Comm = pcall(function() return ReplicatedStorage.Remotes:WaitForChild("Comm", 5) end)
    if not success or not Comm then
        warn("autofarm.lua: Không tìm thấy RemoteFunction 'Comm'.")
    end

    -- ==================== CÁC HÀM LOGIC FARM ====================
    local function EquipMelee(StatusLabel)
        if Character and Character:FindFirstChildOfClass("Tool") then return true end
        StatusLabel:Set("Đang tìm vũ khí Melee...")
        local Backpack = Player:WaitForChild("Backpack")
        for _, v in ipairs(Backpack:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") and v.ToolTip == "Melee" then
                Humanoid:EquipTool(v); task.wait(0.2); return true
            end
        end
        return false
    end

    local function GetBestFarmArea(currentLevel)
        for _, data in ipairs(FarmAreas) do if currentLevel >= data.MinLevel and currentLevel <= data.MaxLevel then return data end end
    end

    local function GetSpecificFarmArea(mobName)
        for _, data in ipairs(FarmAreas) do if data.Mob == mobName then return data end end
    end
    
    local function GetQuest(farmData, StatusLabel)
        local questNPC = Workspace.NPCs:FindFirstChild(farmData.QuestName)
        if questNPC and questNPC:FindFirstChild("ClickDetector") then
            StatusLabel:Set("Đang nhận nhiệm vụ: " .. farmData.Mob)
            tween:MoveTo(farmData.QuestPos); task.wait(0.6) -- Chờ tween di chuyển xong
            pcall(fireclickdetector, questNPC.ClickDetector); task.wait(1)
            if Comm then pcall(Comm.InvokeServer, Comm, "StartQuest", farmData.QuestName, farmData.QuestNumber) end
        end
    end

    local function AttackMob(enemyData, StatusLabel)
        local targetMob; local minDistance = math.huge
        for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
            local mobHRP = mob:FindFirstChild("HumanoidRootPart")
            if mobHRP and mob.Name == enemyData.Mob and mob.Humanoid.Health > 0 then
                local distance = (HRP.Position - mobHRP.Position).Magnitude
                if distance < minDistance then minDistance = distance; targetMob = mob end
            end
        end

        if targetMob then
            -- CẬP NHẬT: Dùng tween:MoveTo để di chuyển mượt mà
            tween:MoveTo(targetMob.HumanoidRootPart.Position + Vector3.new(0, -1, 3)); task.wait(0.6)
            repeat
                StatusLabel:Set("Đang tấn công " .. targetMob.Name)
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, attackKey, false, game)
                    VirtualInputManager:SendKeyEvent(false, attackKey, false, game)
                end)
                task.wait(0.3)
            until not farming or not targetMob.Parent or targetMob.Humanoid.Health <= 0
        else
            StatusLabel:Set("Đang chờ quái xuất hiện..."); task.wait(3)
        end
    end

    -- ==================== TẠO GIAO DIỆN (TAB) ====================
    local FarmTab = Window:MakeTab({ Name = "Auto Farm", Icon = "rbxassetid://1522332854" })
    FarmTab:AddSection("Điều Khiển")
    local StatusLabel = FarmTab:AddLabel("Trạng thái: Chờ lệnh")
    
    FarmTab:AddToggle({
        Name = "Bật/Tắt Auto Farm", Default = false,
        Callback = function(state)
            farming = state
            if farming then
                StatusLabel:Set("Bắt đầu farm...")
                task.spawn(function()
                    while farming do
                        task.wait(0.5)
                        if not Humanoid or Humanoid.Health <= 0 then
                            StatusLabel:Set("Nhân vật đã chết, đang chờ...")
                            Player.CharacterAdded:Wait(); task.wait(3); UpdateCharacter(); continue
                        end
                        if not EquipMelee(StatusLabel) then
                            StatusLabel:Set("Lỗi: Không tìm thấy vũ khí Melee!"); farming = false; break
                        end
                        
                        local enemy
                        if selectedFarmMode == "Tự động" then
                            StatusLabel:Set("Tìm khu vực theo cấp độ...")
                            local level = Player.Data.Level.Value; enemy = GetBestFarmArea(level)
                        else
                            StatusLabel:Set("Tìm khu vực: " .. selectedFarmMode); enemy = GetSpecificFarmArea(selectedFarmMode)
                        end

                        if enemy then
                            local hasQuest = false
                            local questGui = Player.PlayerGui:FindFirstChild("Main") and Player.PlayerGui.Main:FindFirstChild("Quest")
                            if questGui and questGui.Visible and string.find(questGui.Container.QuestTitle.Title.Text, enemy.Mob) then hasQuest = true end
                            if not hasQuest then GetQuest(enemy, StatusLabel); else AttackMob(enemy, StatusLabel) end
                        else
                            StatusLabel:Set("Không tìm thấy khu vực phù hợp."); task.wait(5)
                        end
                    end
                    StatusLabel:Set("Trạng thái: Đã tắt farm")
                end)
            else
                -- CẬP NHẬT: Dừng di chuyển ngay khi tắt farm
                tween:Stop()
                StatusLabel:Set("Trạng thái: Đã dừng")
            end
        end
    })
    
    FarmTab:AddSection("Cài Đặt")
    local farmOptions = {"Tự động"}
    for _, area in ipairs(FarmAreas) do table.insert(farmOptions, area.Mob) end

    FarmTab:AddDropdown({
        Name = "Chọn khu vực farm", Options = farmOptions, Default = "Tự động",
        Callback = function(choice) selectedFarmMode = choice; StatusLabel:Set("Chế độ farm: " .. choice) end
    })

    FarmTab:AddTextbox({
        Name = "Phím tấn công", Default = "Z", TextDisappear = false,
        Callback = function(text) attackKey = text:upper() end
    })
end
