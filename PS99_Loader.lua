local _a1 = {}
local _a2  = game:GetService("ReplicatedStorage")
local _a3 = game:GetService("UserInputService")
local _a4 = game:GetService("RunService")
local _a5  = game:GetService("Players").LocalPlayer
if _G.__PS99_GARDEN then pcall(_G.__PS99_GARDEN) end
local _a6, _a7 = {}, 3000
local function _a8(_a9)
_a6[#_a6 + 1] = tostring(_a9)
if #_a6 > _a7 then table.remove(_a6, 1) end
_a1.dirty = true
end
local function _a10(_a11, _a12)
if type(_a11) ~= "number" then return tostring(_a11) end
if _a11 ~= _a11 then return "0" end
return string.format("%." .. (_a12 or 1) .. "f", _a11)
end
local function _a13(...)
local _a14 = _a2
for _a15, _a16 in ipairs({ ... }) do
if not _a14 then return nil end
_a14 = _a14:FindFirstChild(_a16)
end
if not _a14 then return nil end
local _a17, _a18 = pcall(require, _a14)
return _a17 and _a18 or nil
end
local _a19 = {
EntityPlacement = _a13("Library", "Client", "PvCombatCmds", "EntityPlacement"),
ClientTowerDefense = _a13("Library", "Client", "PvCombatCmds", "ClientTowerDefense"),
ClientPlot = _a13("Library", "Client", "PlotCmds", "ClientPlot"),
LaneUnlock = _a13("Library", "Client", "PvCombatCmds", "LaneUnlock"),
ClientTower = _a13("Library", "Client", "PvCombatCmds", "ClientTowerDefense", "EntityRegistry", "ClientTower"),
GardenLaneFacing = _a13("Library", "Util", "GardenLaneFacing"),
GardenDefenders = _a13("Library", "Util", "GardenDefenders"),
TowerItem = _a13("Library", "Items", "TowerItem"),
Save = _a13("Library", "Client", "Save"),
EventUpgradeCmds = _a13("Library", "Client", "EventUpgradeCmds"),
GardenPlots = _a13("Library", "Util", "GardenPlots"),
PvCropGrowth = _a13("Library", "PvCropGrowth"),
FFlagsM = _a13("Library", "Universal", "FFlags"),
}
local function _a20(_a21)
if type(_a19.FFlagsM) ~= "table" then return nil end
local _a22 = rawget(_a19.FFlagsM, "Keys")
local _a23 = _a22 and _a22[_a21]
if _a23 == nil then return nil end
local _a24, _a25 = pcall(_a19.FFlagsM.GetNumber, _a23)
return _a24 and tonumber(_a25) or nil
end
local _a26      = _a2:WaitForChild("Network")
local _a27 = {
R_ATTACH = _a26:FindFirstChild("WD_Attach"),
R_DETACH = _a26:FindFirstChild("OR_Detach"),
R_PROMO = _a26:FindFirstChild("EK_Promote"),
R_BUY = _a26:FindFirstChild("Merchant_RequestPurchase"),
R_EVUP = _a26:FindFirstChild("EventUpgrades: Purchase"),
R_WIDEN = _a26:FindFirstChild("PG_Widen"),
R_JC = _a26:FindFirstChild("JC_Manifest"),
R_WK = _a26:FindFirstChild("WK_Reclaim"),
R_EGG = _a26:FindFirstChild("Eggs_RequestPurchase"),
R_CEGG = _a26:FindFirstChild("CustomEggs_Hatch"),
R_LUCK = _a26:FindFirstChild("GardenChanceMachine_AddTime"),
}
if not (_a19.EntityPlacement and _a19.ClientTowerDefense and _a19.ClientPlot and _a19.GardenLaneFacing and _a19.TowerItem and _a27.R_ATTACH) then
warn("[PS99 Garden] 필수 모듈 로드 실패 — Garden 이벤트 안에서 실행해 주세요")
end
local _a28 = {
PlaceInterval    = 15,
MerchantInterval = 20,
UpgradeInterval  = 15,
MerchantId       = "FarmingMerchant",
MerchantSlots    = 6,
SwapMargin       = 1.0,
ProtectUpgraded  = false,
DotFactor        = 1.0,
ActionGap        = 0.1,
}
local _a29 = { Shiny = 1.5, Gold = 2, Rainbow = 4 }
local _a30 = {}
local _a31 = { place = false, merchant = false, upgrade = false, towerup = false,
crop = false, expand = false, rebirth = false, hatch = false, luck = false,
farm = false, zone = false, mhatch = false, rank = false, mreb = false,
quest = false, mapupg = false, items = false, slots = false,
auto = true, petspd = true, rewatch = true }
local _a32 = { slots = 0, filled = 0, empty = 0, placed = 0, swapped = 0, bought = 0,
upgraded = 0, sun = 0, replant = 0, hatched = 0, luck = 0,
farm = 0, zone = 0, mhatch = 0, rank = 0, mreb = 0,
quest = 0, potup = 0, potuse = 0, mapupg = 0, items = 0, mslot = 0 }
_a28.CropInterval = 20
_a28.CropMargin   = 1.5
_a28.SkipUnhatched = true
_a28.MinSunflowers  = 0
_a28.BuyUnknownCost = false
_a28.ExpandInterval  = 20
_a28.RebirthInterval = 30
_a28.HatchInterval = 5
_a28.HatchMax      = 100
_a28.HatchReserve  = 0
_a28.HatchEggNum   = 0
_a28.HatchUid      = ""
_a28.LuckInterval  = 3600
_a28.LuckReserve   = 0
_a28.LuckMinTopUp  = 600
_a28.LuckBoosts    = { Huge = true, Titanic = true, Gargantuan = true }
_a28.FarmInterval        = 10
_a28.ZoneInterval        = 10
_a28.MainHatchInterval   = 1
_a28.MainHatchMax        = 100
_a28.MainHatchReserve    = 0
_a28.MainEggId           = ""
_a28.RankInterval        = 30
_a28.MainRebirthInterval = 60
_a28.MainRebirthVerbose  = false
_a28.MaxBedScan     = 80
_a28.QuestInterval  = 10
_a28.QuestUpgrade   = true
_a28.QuestUsePotion = true
_a28.QuestDrive     = true
_a28.QuestUseMax    = 20
_a28.EggRange       = 40
_a28.QuestTp        = true
_a28.TpMode     = "instant"
_a28.TpSpeed    = 160
_a28.TpHeight   = 0
_a28.ArriveDist = 12
_a28.ZoneArriveDist = 90
_a28.QuestLock  = true
_a28.SpawnPerCycle = 1
_a28.EventStayDist = 45
_a28.AutoInterval = 5
_a28.HoldZoneForQuest = true
_a28.HatchBudget  = 25
_a28.ScreenTryMax   = 8
_a28.ScreenRealClick = true
_a28.PursueStallSec = 60
_a28.HatchMinAfford = 10
_a28.MoneyDwell     = 60
_a28.IdleHatch      = false
_a28.PetSpeedMult = 50
_a28.PetSpeedBase = 4
_a28.TpGameFallback = false
_a28.TpCooldown = 2.5
_a28.HatchAutoTp = true
_a28.AutoUnlockEgg = true
_a28.UseAutoHatch  = true
_a28.HatchClick    = true
_a28.HatchClickAfter = 0.6
_a28.TpToBreakables = true
_a28.UpgInterval  = 30
_a28.UpgReserve   = 0
_a28.UpgTp        = true
_a28.SlotInterval = 30
_a28.SlotReserve  = 0
_a28.SlotPet      = true
_a28.SlotEgg      = true
_a28.ItemInterval  = 20
_a28.BuffPotion    = true
_a28.BuffFruit     = true
_a28.BuffUltimate  = true
_a28.BuffConsumable = false
_a28.BuffHighTier  = true
_a28.ItemKeep      = 0
_a28.ItemAllow     = ""
_a28.ItemBlock     = "Rain, Sunlight"
_a28.ItemBestZone  = true
_a28.ItemTp        = false
_a28.BuffMaxPotion = 5
_a28.BuffMaxOther  = 2
_a1.RS, _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log = _a2, _a3, _a4, _a5, _a6, _a8
_a1.num, _a1.req, _a1.LB, _a1.ff, _a1.NET, _a1.RM = _a10, _a13, _a19, _a20, _a26, _a27
_a1.CFG, _a1.VARIANT, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT = _a28, _a29, _a30, _a31, _a32
local _a33   = "juhjuh4212-creator/ps99-hub"
local _a34 = "main"
local _a35    = ""
local _a36  = { "event", "main", "ui" }
local _a37 = (type(getgenv) == "function") and getgenv() or nil
local function _a38(_a39)
local _a40, _a41 = pcall(function() return (getfenv and getfenv() or _G)[_a39] end)
return _a40 and type(_a41) == "function"
end
if not _a38("loadstring") then
warn("[PS99] loadstring 이 없는 익스큐터입니다. 합본을 실행하세요.")
return
end
local _a42 = _a37 and _a37.PS99_BASE or nil
if not _a42 and _a38("readfile") then
for _a43, _a44 in ipairs({ "PS99/", "ps99/", "" }) do
if pcall(readfile, _a44 .. "event.lua") then _a42 = _a44 break end
end
end
local function _a45(_a46)
local _a47, _a48 = pcall(function() return game:HttpGet(_a46, true) end)
if _a47 and type(_a48) == "string" and #_a48 > 0 then return _a48 end
local _a49 = (syn and syn.request) or (http and http.request) or http_request or request
if type(_a49) == "function" then
local _a50, _a51 = pcall(_a49, { Url = _a46, Method = "GET" })
if _a50 and type(_a51) == "table" and type(_a51.Body) == "string" and #_a51.Body > 0 then
return _a51.Body
end
end
return nil
end
local _a52 = ("https://raw.githubusercontent.com/%s/%s/%s"):format(_a33, _a34, _a35)
local function _a53(_a54)
if _a42 then
local _a55, _a56 = pcall(readfile, _a42 .. _a54 .. ".lua")
if _a55 and type(_a56) == "string" and #_a56 > 0 then return _a56, "로컬" end
end
local _a57 = _a45(_a52 .. _a54 .. ".lua?t=" .. tostring(tick()):gsub("%D", ""))
if _a57 then return _a57, "깃허브" end
return nil
end
local _a58 = _a53("event")
if not _a58 then
warn("[PS99] 모듈을 못 받았습니다.")
warn("[PS99]   로컬: 익스큐터 작업 폴더에 PS99 폴더를 만들고 event/main/ui.lua 를 넣기")
warn("[PS99]   깃허브: " .. _a52)
warn("[PS99] 둘 다 안 되면 합본(PS99_GardenAuto.lua)을 실행하세요.")
return
end
for _a59, _a60 in ipairs(_a36) do
local _a61, _a62 = _a53(_a60)
if not _a61 then
warn("[PS99] " .. _a60 .. ".lua 를 못 받았습니다")
return
end
local _a63, _a64 = loadstring(_a61, "@" .. _a60 .. ".lua")
if not _a63 then
warn("[PS99] " .. _a60 .. ".lua 문법 오류: " .. tostring(_a64))
return
end
local _a65, _a66 = pcall(_a63)
if not (_a65 and type(_a66) == "function") then
warn("[PS99] " .. _a60 .. ".lua 가 함수를 반환하지 않음: " .. tostring(_a66))
return
end
local _a67, _a68 = pcall(_a66, _a1)
if not _a67 then
warn("[PS99] " .. _a60 .. ".lua 실행 오류: " .. tostring(_a68))
return
end
_a8("[로드] " .. _a60 .. ".lua  (" .. _a62 .. ")")
end
