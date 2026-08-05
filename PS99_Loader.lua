local _a1 = {}
local _a2  = game:GetService("ReplicatedStorage")
local _a3 = game:GetService("UserInputService")
local _a4 = game:GetService("RunService")
local _a5 = game:GetService("Players").LocalPlayer
if not _a5 then
local _a6 = os.clock()
repeat
task.wait(0.1)
_a5 = game:GetService("Players").LocalPlayer
until _a5 or (os.clock() - _a6) > 10
_a1.lpWait = os.clock() - _a6
_a1.lpFail = (_a5 == nil)
end
do
local _a7 = os.clock()
for _a8, _a9 in ipairs({ "Library", "Network" }) do
local _a10 = pcall(function() _a2:WaitForChild(_a9, 30) end)
if not _a10 or not _a2:FindFirstChild(_a9) then
_a1.libFail = (_a1.libFail and (_a1.libFail .. ", ") or "") .. _a9
end
end
local _a11 = os.clock() - _a7
if _a11 > 0.2 then _a1.libWait = _a11 end
end
if _G.__PS99_GARDEN then pcall(_G.__PS99_GARDEN) end
local _a12, _a13 = {}, 3000
local function _a14(_a15)
_a12[#_a12 + 1] = tostring(_a15)
if #_a12 > _a13 then table.remove(_a12, 1) end
_a1.dirty = true
end
local function _a16(_a17, _a18)
if type(_a17) ~= "number" then return tostring(_a17) end
if _a17 ~= _a17 then return "0" end
return string.format("%." .. (_a18 or 1) .. "f", _a17)
end
local function _a19(...)
local _a20 = _a2
for _a21, _a22 in ipairs({ ... }) do
if not _a20 then return nil end
local _a23 = _a20:FindFirstChild(_a22)
if not _a23 then
local _a24, _a25 = pcall(function() return _a20:WaitForChild(_a22, 2) end)
_a23 = _a24 and _a25 or nil
end
_a20 = _a23
end
if not _a20 then return nil end
local _a26, _a27 = pcall(require, _a20)
return _a26 and _a27 or nil
end
local _a28 = {
EntityPlacement = _a19("Library", "Client", "PvCombatCmds", "EntityPlacement"),
ClientTowerDefense = _a19("Library", "Client", "PvCombatCmds", "ClientTowerDefense"),
ClientPlot = _a19("Library", "Client", "PlotCmds", "ClientPlot"),
LaneUnlock = _a19("Library", "Client", "PvCombatCmds", "LaneUnlock"),
ClientTower = _a19("Library", "Client", "PvCombatCmds", "ClientTowerDefense", "EntityRegistry", "ClientTower"),
GardenLaneFacing = _a19("Library", "Util", "GardenLaneFacing"),
GardenDefenders = _a19("Library", "Util", "GardenDefenders"),
TowerItem = _a19("Library", "Items", "TowerItem"),
Save = _a19("Library", "Client", "Save"),
EventUpgradeCmds = _a19("Library", "Client", "EventUpgradeCmds"),
GardenPlots = _a19("Library", "Util", "GardenPlots"),
PvCropGrowth = _a19("Library", "PvCropGrowth"),
FFlagsM = _a19("Library", "Universal", "FFlags"),
}
local function _a29(_a30)
if type(_a28.FFlagsM) ~= "table" then return nil end
local _a31 = rawget(_a28.FFlagsM, "Keys")
local _a32 = _a31 and _a31[_a30]
if _a32 == nil then return nil end
local _a33, _a34 = pcall(_a28.FFlagsM.GetNumber, _a32)
return _a33 and tonumber(_a34) or nil
end
local _a35      = _a2:WaitForChild("Network")
local _a36 = {
R_ATTACH = _a35:FindFirstChild("WD_Attach"),
R_DETACH = _a35:FindFirstChild("OR_Detach"),
R_PROMO = _a35:FindFirstChild("EK_Promote"),
R_BUY = _a35:FindFirstChild("Merchant_RequestPurchase"),
R_EVUP = _a35:FindFirstChild("EventUpgrades: Purchase"),
R_WIDEN = _a35:FindFirstChild("PG_Widen"),
R_JC = _a35:FindFirstChild("JC_Manifest"),
R_WK = _a35:FindFirstChild("WK_Reclaim"),
R_EGG = _a35:FindFirstChild("Eggs_RequestPurchase"),
R_CEGG = _a35:FindFirstChild("CustomEggs_Hatch"),
R_LUCK = _a35:FindFirstChild("GardenChanceMachine_AddTime"),
}
if not (_a28.EntityPlacement and _a28.ClientTowerDefense and _a28.ClientPlot and _a28.GardenLaneFacing and _a28.TowerItem and _a36.R_ATTACH) then
warn("[PS99 Garden] 필수 모듈 로드 실패 — Garden 이벤트 안에서 실행해 주세요")
end
local _a37 = {
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
local _a38 = { Shiny = 1.5, Gold = 2, Rainbow = 4 }
local _a39 = {}
local _a40 = { place = false, merchant = false, upgrade = false, towerup = false,
crop = false, expand = false, rebirth = false, hatch = false, luck = false,
farm = false, zone = false, mhatch = false, rank = false, mreb = false,
quest = false, mapupg = false, items = false, slots = false,
auto = true, petspd = true, rewatch = true }
local _a41 = { slots = 0, filled = 0, empty = 0, placed = 0, swapped = 0, bought = 0,
upgraded = 0, sun = 0, replant = 0, hatched = 0, luck = 0,
farm = 0, zone = 0, mhatch = 0, rank = 0, mreb = 0,
quest = 0, potup = 0, potuse = 0, mapupg = 0, items = 0, mslot = 0 }
_a37.CropInterval = 20
_a37.CropMargin   = 1.5
_a37.SkipUnhatched = true
_a37.MinSunflowers  = 0
_a37.BuyUnknownCost = false
_a37.ExpandInterval  = 20
_a37.RebirthInterval = 30
_a37.HatchInterval = 5
_a37.HatchMax      = 100
_a37.HatchReserve  = 0
_a37.HatchEggNum   = 0
_a37.HatchUid      = ""
_a37.LuckInterval  = 3600
_a37.LuckReserve   = 0
_a37.LuckMinTopUp  = 600
_a37.LuckBoosts    = { Huge = true, Titanic = true, Gargantuan = true }
_a37.FarmInterval        = 10
_a37.ZoneInterval        = 10
_a37.MainHatchInterval   = 1
_a37.MainHatchMax        = 100
_a37.MainHatchReserve    = 0
_a37.MainEggId           = ""
_a37.RankInterval        = 30
_a37.MainRebirthInterval = 60
_a37.MainRebirthVerbose  = false
_a37.MaxBedScan     = 80
_a37.QuestInterval  = 10
_a37.QuestUpgrade   = true
_a37.QuestUsePotion = true
_a37.QuestDrive     = true
_a37.QuestUseMax    = 20
_a37.EggRange       = 40
_a37.QuestTp        = true
_a37.TpMode     = "instant"
_a37.TpSpeed    = 160
_a37.TpHeight   = 0
_a37.ArriveDist = 12
_a37.ZoneArriveDist = 90
_a37.QuestLock  = true
_a37.SpawnPerCycle = 1
_a37.EventStayDist = 45
_a37.AutoInterval = 5
_a37.HoldZoneForQuest = true
_a37.HatchBudget  = 25
_a37.ScreenTryMax   = 8
_a37.ScreenRealClick = true
_a37.PursueStallSec = 60
_a37.HatchMinAfford = 10
_a37.MoneyDwell     = 60
_a37.IdleHatch      = false
_a37.PetSpeedMult = 50
_a37.PetSpeedBase = 4
_a37.TpGameFallback = false
_a37.TpCooldown = 2.5
_a37.HatchAutoTp = true
_a37.AutoUnlockEgg = true
_a37.UseAutoHatch  = true
_a37.HatchClick    = true
_a37.HatchClickAfter = 0.6
_a37.TpToBreakables = true
_a37.UpgInterval  = 30
_a37.UpgReserve   = 0
_a37.UpgTp        = true
_a37.SlotInterval = 30
_a37.SlotReserve  = 0
_a37.SlotPet      = true
_a37.SlotEgg      = true
_a37.ItemInterval  = 20
_a37.BuffPotion    = true
_a37.BuffFruit     = true
_a37.BuffUltimate  = true
_a37.BuffConsumable = false
_a37.BuffHighTier  = true
_a37.ItemKeep      = 0
_a37.ItemAllow     = ""
_a37.ItemBlock     = "Rain, Sunlight"
_a37.ItemBestZone  = true
_a37.ItemTp        = false
_a37.BuffMaxPotion = 5
_a37.BuffMaxOther  = 2
_a1.RS, _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log = _a2, _a3, _a4, _a5, _a12, _a14
_a1.num, _a1.req, _a1.LB, _a1.ff, _a1.NET, _a1.RM = _a16, _a19, _a28, _a29, _a35, _a36
_a1.CFG, _a1.VARIANT, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT = _a37, _a38, _a39, _a40, _a41
local _a42   = "juhjuh4212-creator/ps99-hub"
local _a43 = "main"
local _a44    = ""
local _a45  = { "event", "main", "ui" }
local _a46 = (type(getgenv) == "function") and getgenv() or nil
local function _a47(_a48)
local _a49, _a50 = pcall(function() return (getfenv and getfenv() or _G)[_a48] end)
return _a49 and type(_a50) == "function"
end
if not _a47("loadstring") then
warn("[PS99] loadstring 이 없는 익스큐터입니다. 합본을 실행하세요.")
return
end
local _a51 = _a46 and _a46.PS99_BASE or nil
if not _a51 and _a47("readfile") then
for _a52, _a53 in ipairs({ "PS99/", "ps99/", "" }) do
if pcall(readfile, _a53 .. "event.lua") then _a51 = _a53 break end
end
end
local function _a54(_a55)
local _a56, _a57 = pcall(function() return game:HttpGet(_a55) end)
if _a56 and type(_a57) == "string" and #_a57 > 0 then return _a57 end
local _a58 = (syn and syn.request) or (http and http.request) or http_request or request
if type(_a58) == "function" then
local _a59, _a60 = pcall(_a58, { Url = _a55, Method = "GET" })
if _a59 and type(_a60) == "table" and type(_a60.Body) == "string" and #_a60.Body > 0 then
return _a60.Body
end
end
return nil
end
local _a61 = ("https://raw.githubusercontent.com/%s/%s/%s"):format(_a42, _a43, _a44)
local function _a62(_a63)
if _a51 then
local _a64, _a65 = pcall(readfile, _a51 .. _a63 .. ".lua")
if _a64 and type(_a65) == "string" and #_a65 > 0 then return _a65, "로컬" end
end
local _a66 = _a54(_a61 .. _a63 .. ".lua?t=" .. tostring(tick()):gsub("%D", ""))
if _a66 then return _a66, "깃허브" end
return nil
end
local _a67 = _a62("event")
if not _a67 then
warn("[PS99] 모듈을 못 받았습니다.")
warn("[PS99]   로컬: 익스큐터 작업 폴더에 PS99 폴더를 만들고 event/main/ui.lua 를 넣기")
warn("[PS99]   깃허브: " .. _a61)
warn("[PS99] 둘 다 안 되면 합본(PS99_GardenAuto.lua)을 실행하세요.")
return
end
for _a68, _a69 in ipairs(_a45) do
local _a70, _a71 = _a62(_a69)
if not _a70 then
warn("[PS99] " .. _a69 .. ".lua 를 못 받았습니다")
return
end
local _a72, _a73 = loadstring(_a70, "@" .. _a69 .. ".lua")
if not _a72 then
warn("[PS99] " .. _a69 .. ".lua 문법 오류: " .. tostring(_a73))
return
end
local _a74, _a75 = pcall(_a72)
if not (_a74 and type(_a75) == "function") then
warn("[PS99] " .. _a69 .. ".lua 가 함수를 반환하지 않음: " .. tostring(_a75))
return
end
local _a76, _a77 = pcall(_a75, _a1)
if not _a76 then
warn("[PS99] " .. _a69 .. ".lua 실행 오류: " .. tostring(_a77))
return
end
_a14("[로드] " .. _a69 .. ".lua  (" .. _a71 .. ")")
end
