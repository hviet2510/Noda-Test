-- Script Webhook Notify Blox Fruits
-- Yêu cầu Orion UI (link custom)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Load Orion từ link custom
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/hviet2510/Noda-Test/main/modules/Orion.lua')))()
local Window = OrionLib:MakeWindow({Name = "Webhook Notify", HidePremium = false, SaveConfig = true, ConfigFolder = "BFWebhook"})

local MainTab = Window:MakeTab({Name = "Cài đặt", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- Cấu hình
local WebhookURL = ""
local UpdateInterval = 5 -- phút
local LastItems = {}
local LastBeli = 0
local LastFrags = 0
local LastLevel = 0

-- Hàm gửi webhook
local function SendWebhook(title, desc)
    if WebhookURL == "" then return end
    local data = {
        embeds = {{
            title = "+ " .. title,
            description = desc,
            color = 0x00ff00,
            footer = {text = os.date("%Y-%m-%d %H:%M:%S")}
        }}
    }
    local body = HttpService:JSONEncode(data)
    request({
        Url = WebhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = body
    })
end

-- Theo dõi item mới
local function CheckItems()
    local backpack = LocalPlayer.Backpack:GetChildren()
    local char = LocalPlayer.Character and LocalPlayer.Character:GetChildren() or {}
    local all = {}
    for _, v in pairs(backpack) do table.insert(all, v.Name) end
    for _, v in pairs(char) do
        if v:IsA("Tool") then table.insert(all, v.Name) end
    end
    for _, item in pairs(all) do
        if not table.find(LastItems, item) then
            SendWebhook("Vật phẩm mới!", "+ " .. item)
        end
    end
    LastItems = all
end

-- Theo dõi Beli, Frags, Level
local function CheckStats()
    local leaderstats = LocalPlayer:FindFirstChild("Data")
    if leaderstats then
        local beli = leaderstats:FindFirstChild("Beli") and leaderstats.Beli.Value or 0
        local frags = leaderstats:FindFirstChild("Fragments") and leaderstats.Fragments.Value or 0
        local lvl = leaderstats:FindFirstChild("Level") and leaderstats.Level.Value or 0

        if beli ~= LastBeli then
            SendWebhook("Beli thay đổi", "+ " .. tostring(beli))
            LastBeli = beli
        end
        if frags ~= LastFrags then
            SendWebhook("Fragments thay đổi", "+ " .. tostring(frags))
            LastFrags = frags
        end
        if lvl ~= LastLevel then
            SendWebhook("Level thay đổi", "+ " .. tostring(lvl))
            LastLevel = lvl
        end
    end
end

-- Cập nhật định kỳ
local function AutoUpdate()
    while wait(UpdateInterval * 60) do
        CheckItems()
        CheckStats()
    end
end

-- UI
MainTab:AddTextbox({
    Name = "Webhook URL",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        WebhookURL = Value
    end
})

MainTab:AddDropdown({
    Name = "Thời gian cập nhật",
    Default = "5 phút",
    Options = {"5 phút", "10 phút", "20 phút", "30 phút", "60 phút"},
    Callback = function(Value)
        local num = tonumber(Value:match("%d+"))
        if num then
            UpdateInterval = num
            OrionLib:MakeNotification({
                Name = "Cập nhật",
                Content = "Tự động: " .. num .. " phút",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

MainTab:AddButton({
    Name = "Test gửi Webhook",
    Callback = function()
        SendWebhook("Test Webhook", "+ Đây là thông báo test")
    end
})

-- Khởi động
task.spawn(AutoUpdate)
CheckItems()
CheckStats()
