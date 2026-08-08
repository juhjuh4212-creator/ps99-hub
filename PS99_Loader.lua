local _a1 = {}
local _a2  = game:GetService("ReplicatedStorage")
local _a3 = game:GetService("UserInputService")
local _a4 = game:GetService("RunService")
do
local _a5 = os.clock()
for _a6, _a7 in ipairs({ "Library", "Network" }) do
local _a8 = pcall(function() _a2:WaitForChild(_a7, 30) end)
if not _a8 or not _a2:FindFirstChild(_a7) then
_a1.libFail = (_a1.libFail and (_a1.libFail .. ", ") or "") .. _a7
end
end
local _a9 = os.clock() - _a5
if _a9 > 0.2 then _a1.libWait = _a9 end
end
local _a10 = game:GetService("Players")
local _a11 = _a10.LocalPlayer
if not _a11 then
local _a12 = os.clock()
repeat
task.wait(0.1)
_a11 = _a10.LocalPlayer
until _a11 or (os.clock() - _a12) > 30
_a1.lpWait = os.clock() - _a12
_a1.lpFail = (_a11 == nil)
end
if _G.__PS99_GARDEN then pcall(_G.__PS99_GARDEN) end
local _a13, _a14 = {}, 3000
local function _a15(_a16)
_a13[#_a13 + 1] = tostring(_a16)
if #_a13 > _a14 then table.remove(_a13, 1) end
_a1.dirty = true
end
local function _a17(_a18, _a19)
if type(_a18) ~= "number" then return tostring(_a18) end
if _a18 ~= _a18 then return "0" end
return string.format("%." .. (_a19 or 1) .. "f", _a18)
end
local function _a20(...)
local _a21 = _a2
for _a22, _a23 in ipairs({ ... }) do
if not _a21 then return nil end
local _a24 = _a21:FindFirstChild(_a23)
if not _a24 then
local _a25, _a26 = pcall(function() return _a21:WaitForChild(_a23, 2) end)
_a24 = _a25 and _a26 or nil
end
_a21 = _a24
end
if not _a21 then return nil end
local _a27, _a28 = pcall(require, _a21)
return _a27 and _a28 or nil
end
local _a29 = {
EntityPlacement = _a20("Library", "Client", "PvCombatCmds", "EntityPlacement"),
ClientTowerDefense = _a20("Library", "Client", "PvCombatCmds", "ClientTowerDefense"),
ClientPlot = _a20("Library", "Client", "PlotCmds", "ClientPlot"),
LaneUnlock = _a20("Library", "Client", "PvCombatCmds", "LaneUnlock"),
ClientTower = _a20("Library", "Client", "PvCombatCmds", "ClientTowerDefense", "EntityRegistry", "ClientTower"),
GardenLaneFacing = _a20("Library", "Util", "GardenLaneFacing"),
GardenDefenders = _a20("Library", "Util", "GardenDefenders"),
TowerItem = _a20("Library", "Items", "TowerItem"),
Save = _a20("Library", "Client", "Save"),
EventUpgradeCmds = _a20("Library", "Client", "EventUpgradeCmds"),
GardenPlots = _a20("Library", "Util", "GardenPlots"),
PvCropGrowth = _a20("Library", "PvCropGrowth"),
FFlagsM = _a20("Library", "Universal", "FFlags"),
}
local function _a30(_a31)
if type(_a29.FFlagsM) ~= "table" then return nil end
local _a32 = rawget(_a29.FFlagsM, "Keys")
local _a33 = _a32 and _a32[_a31]
if _a33 == nil then return nil end
local _a34, _a35 = pcall(_a29.FFlagsM.GetNumber, _a33)
return _a34 and tonumber(_a35) or nil
end
local _a36      = _a2:WaitForChild("Network")
local _a37 = {
R_ATTACH = _a36:FindFirstChild("WD_Attach"),
R_DETACH = _a36:FindFirstChild("OR_Detach"),
R_PROMO = _a36:FindFirstChild("EK_Promote"),
R_BUY = _a36:FindFirstChild("Merchant_RequestPurchase"),
R_EVUP = _a36:FindFirstChild("EventUpgrades: Purchase"),
R_WIDEN = _a36:FindFirstChild("PG_Widen"),
R_JC = _a36:FindFirstChild("JC_Manifest"),
R_WK = _a36:FindFirstChild("WK_Reclaim"),
R_EGG = _a36:FindFirstChild("Eggs_RequestPurchase"),
R_CEGG = _a36:FindFirstChild("CustomEggs_Hatch"),
R_LUCK = _a36:FindFirstChild("GardenChanceMachine_AddTime"),
}
if not (_a29.EntityPlacement and _a29.ClientTowerDefense and _a29.ClientPlot and _a29.GardenLaneFacing and _a29.TowerItem and _a37.R_ATTACH) then
warn("[PS99 Garden] 필수 모듈 로드 실패 — Garden 이벤트 안에서 실행해 주세요")
end
local _a38 = {
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
local _a39 = { Shiny = 1.5, Gold = 2, Rainbow = 4 }
local _a40 = {}
local _a41 = { place = false, merchant = false, upgrade = false, towerup = false,
crop = false, expand = false, rebirth = false, hatch = false, luck = false,
farm = false, zone = false, mhatch = false, rank = false, mreb = false,
quest = false, mapupg = false, items = false, slots = false,
auto = true, petspd = true, rewatch = true }
local _a42 = { slots = 0, filled = 0, empty = 0, placed = 0, swapped = 0, bought = 0,
upgraded = 0, sun = 0, replant = 0, hatched = 0, luck = 0,
farm = 0, zone = 0, mhatch = 0, rank = 0, mreb = 0,
quest = 0, potup = 0, potuse = 0, mapupg = 0, items = 0, mslot = 0 }
_a38.CropInterval = 20
_a38.CropMargin   = 1.5
_a38.SkipUnhatched = true
_a38.MinSunflowers  = 0
_a38.BuyUnknownCost = false
_a38.ExpandInterval  = 20
_a38.RebirthInterval = 30
_a38.HatchInterval = 5
_a38.HatchMax      = 100
_a38.HatchReserve  = 0
_a38.HatchEggNum   = 0
_a38.HatchUid      = ""
_a38.LuckInterval  = 3600
_a38.LuckReserve   = 0
_a38.LuckMinTopUp  = 600
_a38.LuckBoosts    = { Huge = true, Titanic = true, Gargantuan = true }
_a38.FarmInterval        = 10
_a38.ZoneInterval        = 10
_a38.MainHatchInterval   = 1
_a38.MainHatchMax        = 100
_a38.MainHatchReserve    = 0
_a38.MainEggId           = ""
_a38.RankInterval        = 30
_a38.MainRebirthInterval = 60
_a38.MainRebirthVerbose  = false
_a38.MaxBedScan     = 80
_a38.QuestInterval  = 10
_a38.QuestUpgrade   = true
_a38.QuestUsePotion = true
_a38.QuestDrive     = true
_a38.QuestUseMax    = 20
_a38.EggRange       = 40
_a38.QuestTp        = true
_a38.TpMode     = "instant"
_a38.TpSpeed    = 160
_a38.TpHeight   = 0
_a38.ArriveDist = 12
_a38.ZoneArriveDist = 90
_a38.QuestLock  = true
_a38.SpawnPerCycle = 1
_a38.EventStayDist = 45
_a38.AutoInterval = 5
_a38.HoldZoneForQuest = true
_a38.HatchBudget  = 25
_a38.ScreenTryMax   = 8
_a38.ScreenRealClick = true
_a38.PursueStallSec = 60
_a38.HatchMinAfford = 10
_a38.MoneyDwell     = 60
_a38.IdleHatch      = false
_a38.PetSpeedMult = 50
_a38.PetSpeedBase = 4
_a38.TpGameFallback = false
_a38.TpCooldown = 2.5
_a38.HatchAutoTp = true
_a38.AutoUnlockEgg = true
_a38.UseAutoHatch  = true
_a38.HatchClick    = true
_a38.HatchClickAfter = 0.6
_a38.TpToBreakables = true
_a38.UpgInterval  = 30
_a38.UpgReserve   = 0
_a38.UpgTp        = true
_a38.SlotInterval = 30
_a38.SlotReserve  = 0
_a38.SlotPet      = true
_a38.SlotEgg      = true
_a38.ItemInterval  = 20
_a38.BuffPotion    = true
_a38.BuffFruit     = true
_a38.BuffUltimate  = true
_a38.BuffConsumable = false
_a38.BuffHighTier  = true
_a38.ItemKeep      = 0
_a38.ItemAllow     = ""
_a38.ItemBlock     = "Rain, Sunlight"
_a38.ItemBestZone  = true
_a38.ItemTp        = false
_a38.BuffMaxPotion = 12
_a38.BuffMaxOther  = 2
_a1.RS, _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log = _a2, _a3, _a4, _a11, _a13, _a15
_a1.num, _a1.req, _a1.LB, _a1.ff, _a1.NET, _a1.RM = _a17, _a20, _a29, _a30, _a36, _a37
_a1.CFG, _a1.VARIANT, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT = _a38, _a39, _a40, _a41, _a42
local _a43   = "juhjuh4212-creator/ps99-hub"
local _a44 = "main"
local _a45    = ""
local _a46  = { "event", "main", "ui" }
local _a47 = (type(getgenv) == "function") and getgenv() or nil
local function _a48(_a49)
local _a50, _a51 = pcall(function() return (getfenv and getfenv() or _G)[_a49] end)
return _a50 and type(_a51) == "function"
end
if not _a48("loadstring") then
warn("[PS99] loadstring 이 없는 익스큐터입니다. 합본을 실행하세요.")
return
end
local _a52 = _a47 and _a47.PS99_BASE or nil
if not _a52 and _a48("readfile") then
for _a53, _a54 in ipairs({ "PS99/", "ps99/", "" }) do
if pcall(readfile, _a54 .. "event.lua") then _a52 = _a54 break end
end
end
local function _a55(_a56)
local _a57, _a58 = pcall(function() return game:HttpGet(_a56) end)
if _a57 and type(_a58) == "string" and #_a58 > 0 then return _a58 end
local _a59 = (syn and syn.request) or (http and http.request) or http_request or request
if type(_a59) == "function" then
local _a60, _a61 = pcall(_a59, { Url = _a56, Method = "GET" })
if _a60 and type(_a61) == "table" and type(_a61.Body) == "string" and #_a61.Body > 0 then
return _a61.Body
end
end
return nil
end
local _a62 = ("https://raw.githubusercontent.com/%s/%s/%s"):format(_a43, _a44, _a45)
local function _a63(_a64)
if _a52 then
local _a65, _a66 = pcall(readfile, _a52 .. _a64 .. ".lua")
if _a65 and type(_a66) == "string" and #_a66 > 0 then return _a66, "로컬" end
end
local _a67 = _a55(_a62 .. _a64 .. ".lua?t=" .. tostring(tick()):gsub("%D", ""))
if _a67 then return _a67, "깃허브" end
return nil
end
local _a68 = _a63("event")
if not _a68 then
warn("[PS99] 모듈을 못 받았습니다.")
warn("[PS99]   로컬: 익스큐터 작업 폴더에 PS99 폴더를 만들고 event/main/ui.lua 를 넣기")
warn("[PS99]   깃허브: " .. _a62)
warn("[PS99] 둘 다 안 되면 합본(PS99_GardenAuto.lua)을 실행하세요.")
return
end
for _a69, _a70 in ipairs(_a46) do
local _a71, _a72 = _a63(_a70)
if not _a71 then
warn("[PS99] " .. _a70 .. ".lua 를 못 받았습니다")
return
end
local _a73, _a74 = loadstring(_a71, "@" .. _a70 .. ".lua")
if not _a73 then
warn("[PS99] " .. _a70 .. ".lua 문법 오류: " .. tostring(_a74))
return
end
local _a75, _a76 = pcall(_a73)
if not (_a75 and type(_a76) == "function") then
warn("[PS99] " .. _a70 .. ".lua 가 함수를 반환하지 않음: " .. tostring(_a76))
return
end
local _a77, _a78 = pcall(_a76, _a1)
if not _a77 then
warn("[PS99] " .. _a70 .. ".lua 실행 오류: " .. tostring(_a78))
return
end
_a15("[로드] " .. _a70 .. ".lua  (" .. _a72 .. ")")
end
