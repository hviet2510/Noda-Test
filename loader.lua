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
-- Orion UI Loader
-- ==========================
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/hviet2510/Noda-Test/main/modules/Orion.lua"))()
local Window = OrionLib:MakeWindow({
    Name = "Blox Fruits - Item Tracker",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "BF_ItemTracker"
})

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
        OrionLib:MakeNotification({
            Name = "Lỗi",
            Content = "Bạn chưa nhập Webhook URL!",
            Image = "rbxassetid://4483345998",
            Time = 3
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

-- Quét item ban đầu
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
    while task.wait(5) do -- Kiểm tra mỗi 5 giây
        if tick() - LastAutoUpdate >= (UpdateInterval * 60) then
            SendDiscordEmbed("auto")
            LastAutoUpdate = tick()
        end
    end
end)

-- ==========================
-- UI Orion
-- ==========================
local MainTab = Window:MakeTab({
    Name = "Cài đặt Webhook",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddTextbox({
    Name = "Discord Webhook URL",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        WebhookURL = Value
        OrionLib:MakeNotification({
            Name = "Webhook đã lưu",
            Content = "Link Webhook: " .. Value,
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- Dropdown chọn thời gian (5-10-20-30-60 phút)
MainTab:AddDropdown({
    Name = "Thời gian cập nhật tự động",
    Default = "5",
    Options = {"5", "10", "20", "30", "60"},
    Callback = function(Value)
        UpdateInterval = tonumber(Value)
        OrionLib:MakeNotification({
            Name = "Cập nhật thành công",
            Content = "Thời gian tự động: " .. Value .. " phút",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

MainTab:AddButton({
    Name = "Test Webhook",
    Callback = function()
        SendDiscordEmbed("item", "Vật phẩm test (Kiểm tra webhook)")
        OrionLib:MakeNotification({
            Name = "Đang gửi test...",
            Content = "Kiểm tra Discord của bạn!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

MainTab:AddLabel("• Cập nhật tự động theo phút đã chọn")
MainTab:AddLabel("• Nếu có vật phẩm mới, vẫn gửi ngay lập tức")

OrionLib:Init()
