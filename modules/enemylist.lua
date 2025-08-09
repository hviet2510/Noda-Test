-- File: enemylist.lua
-- Cơ sở dữ liệu farm cho Blox Fruits

--[[
    Giải thích cấu trúc:
    - Name: Tên hiển thị trong menu dropdown.
    - Mob: Tên chính xác của model quái trong game.
    - MinLevel: Cấp độ tối thiểu để farm hiệu quả.
    - MaxLevel: Cấp độ tối đa nên farm ở đây.
    - QuestNPC: Tên NPC giao nhiệm vụ. Thường có dạng "Quest Giver" hoặc tên riêng.
    - QuestPos: Vị trí của NPC.
    - QuestName: Tên nhiệm vụ mà game sử dụng nội bộ (thường trùng với tên Mob).
    - QuestNumber: ID của nhiệm vụ. Trong Blox Fruits, thường là 1 cho quái và 2 cho boss.
]]

return {
    -- == Sea 1 ==
    {
        Name = "Pirate Starter (Lv. 1-10)",
        Mob = "Bandit",
        MinLevel = 1,
        MaxLevel = 10,
        QuestNPC = "Quest Giver", -- NPC ở đảo Khỉ
        QuestPos = Vector3.new(-1034, 17, 1502),
        QuestName = "Bandit",
        QuestNumber = 1 
    },
    {
        Name = "Jungle (Lv. 15-30)",
        Mob = "Monkey",
        MinLevel = 11,
        MaxLevel = 30,
        QuestNPC = "Quest Giver", -- NPC ở đảo Rừng
        QuestPos = Vector3.new(-1319, 34, -137),
        QuestName = "Monkey",
        QuestNumber = 1
    },
    {
        Name = "Desert (Lv. 60-90)",
        Mob = "Desert Bandit",
        MinLevel = 31,
        MaxLevel = 90,
        QuestNPC = "Quest Giver", -- NPC ở đảo Sa Mạc
        QuestPos = Vector3.new(943, 20, -1004),
        QuestName = "Desert Bandit",
        QuestNumber = 1
    },

    -- == Sea 2 ==
    {
        Name = "Kingdom of Rose (Lv. 700-775)",
        Mob = "Swan Pirate",
        MinLevel = 700,
        MaxLevel = 775,
        QuestNPC = "Quest Giver", -- NPC ở gần quán cà phê
        QuestPos = Vector3.new(-923, 116, 1265),
        QuestName = "Swan Pirate",
        QuestNumber = 1
    },
    {
        Name = "Green Zone (Lv. 800-850)",
        Mob = "Marine Captain",
        MinLevel = 776,
        MaxLevel = 850,
        QuestNPC = "Quest Giver", -- NPC ở Green Zone
        QuestPos = Vector3.new(2066, 179, 131),
        QuestName = "Marine Captain",
        QuestNumber = 1
    },

    -- == Sea 3 ==
    {
        Name = "Port Town (Lv. 1500-1550)",
        Mob = "Pistol Millionaire",
        MinLevel = 1500,
        MaxLevel = 1550,
        QuestNPC = "Quest Giver", -- NPC ở Port Town
        QuestPos = Vector3.new(1694, 237, -3518),
        QuestName = "Pistol Millionaire",
        QuestNumber = 1
    },
    {
        Name = "Floating Turtle (Lv. 1800-1975)",
        Mob = "Fishman Captain",
        MinLevel = 1800,
        MaxLevel = 1975,
        QuestNPC = "Quest Giver", -- NPC ở trên đảo Rùa
        QuestPos = Vector3.new(-3805, 484, -4933),
        QuestName = "Fishman Captain",
        QuestNumber = 1
    },

    -- Thêm các khu vực và boss khác vào đây...
}
