-- =================================================================
--                       NODA HUB - PRELOAD EDITION
--         Tải trước toàn bộ giao diện, hiển thị ngay lập tức
-- =================================================================

-- ==================== Cấu hình Trung tâm ====================
local Config = {
    HUB_NAME = "Noda Hub",
    GITHUB_BASE_URL = "https://raw.githubusercontent.com/hviet2510/Noda-Test/main/", -- URL repo của bạn
    UI_LIB_FILE = "modules/Orion.lua", -- Đường dẫn tới Orion.lua trong repo
    MODULES_TO_LOAD = {
        "tween.lua",
        "enemylist.lua",
        "autofarm.lua"
    }
}

-- ==================== Hàm tiện ích và UI Loader ====================
local LoaderUI, Status, ProgressBar

local function CreateLoaderUI()
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "LoaderUI"; ScreenGui.ResetOnSpawn = false
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 280, 0, 100) -- Kích thước tối ưu cho mobile
    Frame.Position = UDim2.new(0.5, -140, 0.5, -50)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18; Title.Text = Config.HUB_NAME .. " Loader"
    Status = Instance.new("TextLabel", Frame)
    Status.Name = "Status"; Status.Size = UDim2.new(1, -20, 0, 25); Status.Position = UDim2.new(0, 10, 0, 40)
    Status.BackgroundTransparency = 1; Status.TextColor3 = Color3.fromRGB(200, 200, 200)
    Status.Font = Enum.Font.Gotham; Status.TextSize = 14; Status.Text = "Đang chuẩn bị..."
    Status.TextXAlignment = Enum.TextXAlignment.Left; Status.TextWrapped = true
    local ProgressBarBG = Instance.new("Frame", Frame)
    ProgressBarBG.Size = UDim2.new(1, -40, 0, 10); ProgressBarBG.Position = UDim2.new(0, 20, 0, 70)
    ProgressBarBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ProgressBar = Instance.new("Frame", ProgressBarBG)
    ProgressBar.Name = "ProgressBar"; ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    Instance.new("UICorner", ProgressBarBG).CornerRadius = UDim.new(0, 6)
    LoaderUI = ScreenGui
end

local function HttpGetWithRetry(url)
    for i = 1, 3 do
        local success, content = pcall(game.HttpGet, game, url)
        if success then return content end
        Status.Text = string.format("Thử lại %s... (Lần %d)", url:match("([^/]+)$"), i)
        task.wait(1) -- Tăng wait cho mobile
    end
    Status.Text = "Lỗi tải " .. url:match("([^/]+)$") .. "! Kiểm tra kết nối."
    return nil
end

local function UpdateProgress(fraction, text)
    if Status then Status.Text = text end
    if ProgressBar then ProgressBar:TweenSize(UDim2.new(fraction, 0, 1, 0), "Out", "Quad", 0.5) end -- Tăng thời gian tween
end

-- ==================== Logic chính ====================
CreateLoaderUI()
_G.modules = {}

-- Bước 1: Tải song song UI Library và tất cả các module
UpdateProgress(0.1, "Bắt đầu tải tài nguyên...")
local filesToLoad = table.clone(Config.MODULES_TO_LOAD)
table.insert(filesToLoad, 1, Config.UI_LIB_FILE) -- Thêm UI Lib vào đầu danh sách

local loadedContents = {}
local completedCount = 0

for _, filePath in ipairs(filesToLoad) do
    task.spawn(function()
        local content = HttpGetWithRetry(Config.GITHUB_BASE_URL .. filePath)
        loadedContents[filePath] = content -- Lưu nội dung đã tải
        completedCount = completedCount + 1
    end)
end

-- Chờ cho tất cả các file tải xong
while completedCount < #filesToLoad do
    local progress = 0.1 + 0.6 * (completedCount / #filesToLoad)
    UpdateProgress(progress, string.format("Đang tải tài nguyên... (%d/%d)", completedCount, #filesToLoad))
    task.wait(0.2) -- Tăng wait cho mobile
end

-- Bước 2: Xử lý và chuẩn bị các module
UpdateProgress(0.7, "Đang xử lý thư viện UI...")

-- Xử lý Orion trước
local orionContent = loadedContents[Config.UI_LIB_FILE]
if not orionContent then
    UpdateProgress(0.7, "Lỗi nghiêm trọng: Không thể tải Orion.lua!")
    task.wait(5); if LoaderUI then LoaderUI:Destroy() end
    return
end

local OrionLib = loadstring(orionContent)()
local Window = OrionLib:MakeWindow({
    Name = Config.HUB_NAME, HidePremium = true, SaveConfig = true,
    ConfigFolder = "NodaPreloadConfig"
})

-- Xử lý các module chức năng
for i, fileName in ipairs(Config.MODULES_TO_LOAD) do
    local progress = 0.8 + 0.2 * (i / #Config.MODULES_TO_LOAD)
    UpdateProgress(progress, "Đang chuẩn bị: " .. fileName)
    
    local moduleContent = loadedContents[fileName]
    if moduleContent then
        local funcOrTable = loadstring(moduleContent)()
        if type(funcOrTable) == "function" then
            task.defer(funcOrTable, Window) -- "Vẽ" các tab vào cửa sổ
        elseif type(funcOrTable) == "table" then
            _G.modules[fileName:gsub("%.lua$", "")] = funcOrTable -- Lưu bảng (như tween, enemylist)
        end
    else
        warn("Không thể tải module: " .. fileName)
    end
end

-- Bước 3: Hoàn tất
UpdateProgress(1, "Hoàn tất! Chuẩn bị hiển thị...")
task.wait(1)
if LoaderUI then LoaderUI:Destroy() end

OrionLib:MakeNotification({
    Name = "Noda Hub", Content = "Tải và chuẩn bị thành công!",
    Image = "rbxassetid://4483345998", Time = 5
})
