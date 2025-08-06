-- loader.lua

local baseUrl = "https://raw.githubusercontent.com/hviet2510/Noda-Test/main/modules/"
local modules = {
    "Rayfield.lua",
    "enemylist.lua",
    "autofarm.lua"
}

local loadedModules = {}
local Rayfield = nil

-- Hàm tạm để notify trước khi có Rayfield
local function TempNotify(title, content)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = content,
        Duration = 3
    })
end

TempNotify("Loader", "Đang tải Rayfield...", 3)

-- Bước 1: Load Rayfield đầu tiên
local success, result = pcall(function()
    return loadstring(game:HttpGet(baseUrl .. "Rayfield.lua"))()
end)

if success then
    Rayfield = result
    loadedModules["Rayfield"] = Rayfield
else
    TempNotify("Lỗi", "Không thể tải Rayfield!", 5)
    return
end

-- Hàm Notify dùng Rayfield
local function Notify(title, content, duration)
    Rayfield.Notify({
        Title = title,
        Content = content,
        Duration = duration or 4
    })
end

Notify("Loader", "Rayfield đã được tải thành công!", 3)
task.wait(0.5)

-- Bước 2: Load các module còn lại
for _, moduleName in ipairs(modules) do
    if moduleName ~= "Rayfield.lua" then
        Notify("Loader", "Đang tải module: " .. moduleName, 2)
        local success, result = pcall(function()
            return loadstring(game:HttpGet(baseUrl .. moduleName))()
        end)

        if success then
            local moduleKey = moduleName:gsub("%.lua$", "")
            loadedModules[moduleKey] = result
            Notify("Thành công", moduleKey .. " đã được load!", 2)
        else
            Notify("Lỗi", "Không thể load " .. moduleName, 4)
        end
        task.wait(0.8) -- delay nhỏ để người dùng dễ theo dõi
    end
end

-- Bước 3: Tự động chạy autofarm nếu có
if loadedModules.autofarm and loadedModules.autofarm.Start then
    Notify("AutoFarm", "Đang khởi động AutoFarm...", 2)
    task.wait(0.5)
    loadedModules.autofarm.Start()
    Notify("AutoFarm", "Đã khởi động thành công!", 3)
else
    Notify("AutoFarm", "Không tìm thấy hoặc lỗi khi chạy autofarm", 4)
end
