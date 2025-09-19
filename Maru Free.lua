if not game:IsLoaded() then repeat game.Loaded:Wait() until game:IsLoaded() end
getgenv().Script_Mode = "Kaitun_Script"
_G.Settings = {
    PlantSettings = {
        Limit = 200,
        Plant = {
            ["Carrot"] = 50,
            ["Cauliflower"] = 1,
            ["Watermelon"] = 1,
            ["Rafflesia"] = 1,
            ["Green Apple"] = 1,
            ["Avocado"] = 1,
            ["Banana"] = 1,
            ["Pineapple"] = 1,
            ["Kiwi"] = 1,
            ["Bell Pepper"] = 1,
            ["Prickly Pear"] = 1,
            ["Loquat"] = 1,
            ["Feijoa"] = 1,
            ["Sugar Apple"] = 1,
        },
        Destroy = {
            WhenMoney = 50000,
            Plant = {
                "Strawberry"
            }
        }
    },
    SeedsSetting = {
        "Carrot", "Cauliflower", "Watermelon", "Rafflesia", "Green Apple", "Avocado", "Banana",
        "Pineapple", "Kiwi", "Bell Pepper", "Prickly Pear", "Loquat", "Feijoa", "Sugar Apple",
    },
    EggSettings = {
        StartBuyEggWhen = 150000,
        SelectEggs = {
            "Common Summer Egg"
        },
        PlaceEggs = {
            "Zen Egg",    
            "Common Summer Egg"
        },
        HatchEggs = {
            "Zen Egg",
            "Common Summer Egg"
        }
    },
    Webhook = "",
    UpgradeEggSlots = 8,
    UpgradePetSlots = 8,
    PetSettings = {
        Sell = {
            "Shiba Inu",
        },
        UpgradeSlots = {
            "Kodama", "Starfish"
        },
        Equip = {
            "Corrupted Kodama", "Kodama", "Ostrich", "Tanchozuru"
        },
        Lock = {
            Name = {
                "Corrupted Kitsune"
            },
            Weight = 5,
            Enabled = true
        }
    },
    CraftSettings = {
        Enabled = true,
        Workbench = "Anti Bee Egg",
        SeedEventWorkbench = ""
    },
    ZenEvents = {
        TakeAllTranquilPlants = true,
        TradeChi = {
            Enabled = true,
            MaxChi =  10000
        },
        SubmitMonk = true,
        SubmitFox = true
    },
    StockBuy = {
        GearStocksBuy = {""},
        ZenItems = {"Zen Egg"}
    },
    SprinklerSettings = {
        PlaceManage = {
            ["Basic Sprinkler"] = 1
        }
    },
    UseSeedPack = true,
    CropSettings = {
        ['DelayTime'] = 10,
        ['TimeCrop'] = 10
    },
    WhiteScreen = false
}
getgenv().Key = "MARU-YVZTN-2LNF-O0VP-ZYK5X-S1WWO"
getgenv().id = "1026609368315211906"
loadstring(game:HttpGet("https://raw.githubusercontent.com/xshiba/MaruBitkub/main/Mobile.lua"))()