-- ==========================
-- Dịch vụ Roblox
-- ==========================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")

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

-- Biến lưu Webhook
local WebhookURL = ""
local EmbedColor = 0x00ffcc
local OwnedItems = {}

-- ==========================
-- Hàm gửi Embed
-- ==========================
local function SendDiscordEmbed(itemName)
    if WebhookURL == "" then
        warn("Chưa nhập Webhook URL!")
        OrionLib:MakeNotification({
            Name = "Lỗi",
            Content = "Bạn chưa nhập Webhook URL!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
        return
    end

    local data = {
        username = "Blox Fruits Tracker",
        embeds = {{
            title = "📦 Vật phẩm mới nhận!",
            color = EmbedColor,
            fields = {
                { name = "Người chơi", value = Player.Name, inline = true },
                { name = "Vật phẩm", value = itemName, inline = true },
                { name = "Thời gian", value = os.date("%H:%M:%S"), inline = true }
            },
            footer = { text = "Farm Tracker • " .. os.date("%d/%m/%Y") }
        }}
    }

    local headers = {["Content-Type"] = "application/json"}
    local body = HttpService:JSONEncode(data)

    if syn and syn.request then
        syn.request({Url = WebhookURL, Method = "POST", Headers = headers, Body = body})
    elseif http_request then
        http_request({Url = WebhookURL, Method = "POST", Headers = headers, Body = body})
    elseif request then
        request({Url = WebhookURL, Method = "POST", Headers = headers, Body = body})
    else
        warn("Executor của bạn không hỗ trợ HTTP requests!")
    end
end

-- ==========================
-- Hàm kiểm tra item mới
-- ==========================
local function CheckNewItem(item)
    if not OwnedItems[item.Name] then
        OwnedItems[item.Name] = true
        SendDiscordEmbed(item.Name)
    end
end

-- Quét item ban đầu
for _, item in ipairs(Backpack:GetChildren()) do
    OwnedItems[item.Name] = true
end

-- Theo dõi Backpack + Character
Backpack.ChildAdded:Connect(CheckNewItem)
Player.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(CheckNewItem)
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

MainTab:AddButton({
    Name = "Test Webhook",
    Callback = function()
        SendDiscordEmbed("Vật phẩm test (Kiểm tra webhook)")
        OrionLib:MakeNotification({
            Name = "Đang gửi test...",
            Content = "Kiểm tra Discord của bạn!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

MainTab:AddLabel("Script sẽ tự gửi thông báo khi nhận vật phẩm mới.")

OrionLib:Init()
