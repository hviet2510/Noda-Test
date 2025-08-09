-- enemylist.lua
-- Danh sách quái và khu vực farm cho Sea 1 (First Sea) trong Blox Fruits
local EnemyList = {}

EnemyList = {
    -- Khu vực 1: Middle Town (Level 1-10)
    {
        MinLevel = 1,
        MaxLevel = 10,
        Mob = "Bandit",
        QuestName = "Bandit Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(1057, 15, 1554) -- Tọa độ NPC Bandit Quest
    },
    
    -- Khu vực 2: Jungle (Level 15-30)
    {
        MinLevel = 15,
        MaxLevel = 30,
        Mob = "Monkey",
        QuestName = "Jungle Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(-1320, 15, 350) -- Tọa độ NPC Jungle Quest
    },
    {
        MinLevel = 15,
        MaxLevel = 30,
        Mob = "Gorilla",
        QuestName = "Jungle Quest",
        QuestNumber = 2,
        QuestPos = CFrame.new(-1320, 15, 350) -- Tọa độ NPC Jungle Quest
    },
    
    -- Khu vực 3: Pirate Village (Level 30-60)
    {
        MinLevel = 30,
        MaxLevel = 60,
        Mob = "Pirate",
        QuestName = "Pirate Village Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(-1122, 15, 4397) -- Tọa độ NPC Pirate Village Quest
    },
    
    -- Khu vực 4: Desert (Level 60-90)
    {
        MinLevel = 60,
        MaxLevel = 75,
        Mob = "Desert Bandit",
        QuestName = "Desert Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(2394, 15, 2116) -- Tọa độ NPC Desert Quest
    },
    {
        MinLevel = 75,
        MaxLevel = 90,
        Mob = "Desert Officer",
        QuestName = "Desert Quest",
        QuestNumber = 2,
        QuestPos = CFrame.new(2394, 15, 2116) -- Tọa độ NPC Desert Quest
    },
    
    -- Khu vực 5: Marine Fortress (Level 90-120)
    {
        MinLevel = 90,
        MaxLevel = 120,
        Mob = "Marine Captain",
        QuestName = "Marine Fortress Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(-5094, 15, 4313) -- Tọa độ NPC Marine Fortress Quest
    },
    
    -- Khu vực 6: Middle Town 2 (Level 120-150)
    {
        MinLevel = 120,
        MaxLevel = 150,
        Mob = "Brute",
        QuestName = "Brute Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(1057, 15, 1554) -- Tọa độ NPC Brute Quest
    },
    
    -- Khu vực 7: Pirate Ship (Level 150-200)
    {
        MinLevel = 150,
        MaxLevel = 200,
        Mob = "Pirate Lieutenant",
        QuestName = "Pirate Ship Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(1341, 15, 150) -- Tọa độ NPC Pirate Ship Quest
    },
    
    -- Khu vực 8: Frozen Village (Level 200-300)
    {
        MinLevel = 200,
        MaxLevel = 250,
        Mob = "Snow Trooper",
        QuestName = "Snow Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(1341, 15, 150) -- Tọa độ NPC Snow Quest (cần kiểm tra lại)
    },
    {
        MinLevel = 250,
        MaxLevel = 300,
        Mob = "Winter Warrior",
        QuestName = "Snow Quest",
        QuestNumber = 2,
        QuestPos = CFrame.new(1341, 15, 150) -- Tọa độ NPC Snow Quest
    },
    
    -- Khu vực 9: Underwater City (Level 300-375)
    {
        MinLevel = 300,
        MaxLevel = 375,
        Mob = "Shark Soldier",
        QuestName = "Underwater Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(-10254, 15, -10349) -- Tọa độ NPC Underwater Quest
    },
    
    -- Khu vực 10: Marine HQ (Level 375-450)
    {
        MinLevel = 375,
        MaxLevel = 450,
        Mob = "Marine Commodore",
        QuestName = "Marine HQ Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(-2571, 15, 2381) -- Tọa độ NPC Marine HQ Quest
    },
    
    -- Khu vực 11: Prison (Level 450-550)
    {
        MinLevel = 450,
        MaxLevel = 550,
        Mob = "Prisoner",
        QuestName = "Prison Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(5360, 15, 60) -- Tọa độ NPC Prison Quest
    },
    
    -- Khu vực 12: Pirate Raid (Level 550-625)
    {
        MinLevel = 550,
        MaxLevel = 625,
        Mob = "Pirate Millionaire",
        QuestName = "Pirate Raid Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(-1214, 15, 3332) -- Tọa độ NPC Pirate Raid Quest
    },
    
    -- Khu vực 13: Dark Arena (Level 625-700)
    {
        MinLevel = 625,
        MaxLevel = 700,
        Mob = "Dark Master",
        QuestName = "Dark Arena Quest",
        QuestNumber = 1,
        QuestPos = CFrame.new(-1214, 15, 3332) -- Tọa độ NPC Dark Arena Quest (cần kiểm tra lại)
    }
}

return EnemyList
