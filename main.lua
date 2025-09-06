-- ==========================
-- Dịch vụ Roblox
-- ==========================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")
local DataFolder = Player:WaitForChild("Data")
local BeliStat = DataFolder:WaitForChild("Beli")
local FragStat = DataFolder:WaitForChild("Fragments")
local LevelStat = DataFolder:WaitForChild("Level")

-- ==========================
-- Load Turtle UI Lib
-- ==========================
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/hviet2510/Noda-Test/main/modules/ui_lib.lua"))()
local win = lib:Window("Blox Fruits - Item Tracker")

-- ==========================
-- Biến toàn cục
-- ==========================
local WebhookURL = ""
local EmbedColor = 0x00ffcc
local OwnedItems = {}
local UpdateInterval = 5 -- phút
local LastAutoUpdate = tick()

-- ==========================
-- Hàm gửi Webhook
-- ==========================
local function SendDiscordEmbed(reason, itemName)
    if WebhookURL == "" then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Bạn chưa nhập Webhook URL!",
            Duration = 3
        })
        return
    end

    local beli = tostring(BeliStat.Value)
    local frags = tostring(FragStat.Value)
    local level = tostring(LevelStat.Value)

    local data = {
        username = "Blox Fruits Tracker",
        embeds = {{
            title = (reason == "item" and "+ Vật phẩm mới nhận!" or "+ Cập nhật định kỳ"),
            color = EmbedColor,
            fields = {
                { name = "Người chơi", value = Player.Name, inline = true },
                { name = "Level hiện tại", value = level, inline = true },
                { name = "Beli", value = beli, inline = true },
                { name = "Fragments", value = frags, inline = true },
                { name = "Thời gian", value = os.date("%H:%M:%S"), inline = true }
            },
            footer = { text = "Farm Tracker • " .. os.date("%d/%m/%Y") }
        }}
    }

    if reason == "item" and itemName then
        table.insert(data.embeds[1].fields, 2, { name = "Vật phẩm", value = itemName, inline = true })
    end

    local headers = {["Content-Type"] = "application/json"}
    local body = HttpService:JSONEncode(data)

    if syn and syn.request then
        syn.request({Url = WebhookURL, Method = "POST", Headers = headers, Body = body})
    elseif http_request then
        http_request({Url = WebhookURL, Method = "POST", Headers = headers, Body = body})
    elseif request then
        request({Url = WebhookURL, Method = "POST", Headers = headers, Body = body})
    else
        warn("Executor không hỗ trợ HTTP requests!")
    end
end

-- ==========================
-- Kiểm tra item mới
-- ==========================
local function CheckNewItem(item)
    if not OwnedItems[item.Name] then
        OwnedItems[item.Name] = true
        SendDiscordEmbed("item", item.Name)
    end
end

for _, item in ipairs(Backpack:GetChildren()) do
    OwnedItems[item.Name] = true
end
Backpack.ChildAdded:Connect(CheckNewItem)
Player.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(CheckNewItem)
end)

-- ==========================
-- Cập nhật định kỳ
-- ==========================
task.spawn(function()
    while task.wait(5) do
        if tick() - LastAutoUpdate >= (UpdateInterval * 60) then
            SendDiscordEmbed("auto")
            LastAutoUpdate = tick()
        end
    end
end)

-- ==========================
-- UI Turtle Lib
-- ==========================
win:Box("Discord Webhook URL", function(value, focusLost)
    if focusLost then
        WebhookURL = value
        game.StarterGui:SetCore("SendNotification", {
            Title = "Webhook đã lưu",
            Text = "Link Webhook: " .. value,
            Duration = 3
        })
    end
end)

win:Dropdown("Thời gian cập nhật tự động", {"5", "10", "20", "30", "60"}, function(value)
    UpdateInterval = tonumber(value)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Cập nhật thành công",
        Text = "Tự động: " .. value .. " phút",
        Duration = 3
    })
end)

win:Button("Test Webhook", function()
    SendDiscordEmbed("item", "Vật phẩm test (Kiểm tra webhook)")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Đang gửi test...",
        Text = "Kiểm tra Discord của bạn!",
        Duration = 3
    })
end)

win:Label("• Gửi định kỳ theo phút đã chọn")
win:Label("• Nếu có vật phẩm mới, sẽ gửi ngay")

-- ==========================
-- Nút Toggle bật/tắt UI
-- ==========================
local toggleGui = Instance.new("ScreenGui", game.CoreGui)
toggleGui.Name = "ToggleUI"

local toggleBtn = Instance.new("TextButton", toggleGui)
toggleBtn.Size = UDim2.new(0, 80, 0, 40)
toggleBtn.Position = UDim2.new(0.9, 0, 0.05, 0)
toggleBtn.Text = "📂 UI"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18

toggleBtn.MouseButton1Click:Connect(function()
    lib:Hide() -- dùng hàm có sẵn trong ui_lib.lua
end)
