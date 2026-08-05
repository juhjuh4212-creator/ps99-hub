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
if _G.__PS99_GARDEN then pcall(_G.__PS99_GARDEN) end
local _a7, _a8 = {}, 3000
local function _a9(_a10)
_a7[#_a7 + 1] = tostring(_a10)
if #_a7 > _a8 then table.remove(_a7, 1) end
_a1.dirty = true
end
local function _a11(_a12, _a13)
if type(_a12) ~= "number" then return tostring(_a12) end
if _a12 ~= _a12 then return "0" end
return string.format("%." .. (_a13 or 1) .. "f", _a12)
end
local function _a14(...)
local _a15 = _a2
for _a16, _a17 in ipairs({ ... }) do
if not _a15 then return nil end
_a15 = _a15:FindFirstChild(_a17)
end
if not _a15 then return nil end
local _a18, _a19 = pcall(require, _a15)
return _a18 and _a19 or nil
end
local _a20 = {
EntityPlacement = _a14("Library", "Client", "PvCombatCmds", "EntityPlacement"),
ClientTowerDefense = _a14("Library", "Client", "PvCombatCmds", "ClientTowerDefense"),
ClientPlot = _a14("Library", "Client", "PlotCmds", "ClientPlot"),
LaneUnlock = _a14("Library", "Client", "PvCombatCmds", "LaneUnlock"),
ClientTower = _a14("Library", "Client", "PvCombatCmds", "ClientTowerDefense", "EntityRegistry", "ClientTower"),
GardenLaneFacing = _a14("Library", "Util", "GardenLaneFacing"),
GardenDefenders = _a14("Library", "Util", "GardenDefenders"),
TowerItem = _a14("Library", "Items", "TowerItem"),
Save = _a14("Library", "Client", "Save"),
EventUpgradeCmds = _a14("Library", "Client", "EventUpgradeCmds"),
GardenPlots = _a14("Library", "Util", "GardenPlots"),
PvCropGrowth = _a14("Library", "PvCropGrowth"),
FFlagsM = _a14("Library", "Universal", "FFlags"),
}
local function _a21(_a22)
if type(_a20.FFlagsM) ~= "table" then return nil end
local _a23 = rawget(_a20.FFlagsM, "Keys")
local _a24 = _a23 and _a23[_a22]
if _a24 == nil then return nil end
local _a25, _a26 = pcall(_a20.FFlagsM.GetNumber, _a24)
return _a25 and tonumber(_a26) or nil
end
local _a27      = _a2:WaitForChild("Network")
local _a28 = {
R_ATTACH = _a27:FindFirstChild("WD_Attach"),
R_DETACH = _a27:FindFirstChild("OR_Detach"),
R_PROMO = _a27:FindFirstChild("EK_Promote"),
R_BUY = _a27:FindFirstChild("Merchant_RequestPurchase"),
R_EVUP = _a27:FindFirstChild("EventUpgrades: Purchase"),
R_WIDEN = _a27:FindFirstChild("PG_Widen"),
R_JC = _a27:FindFirstChild("JC_Manifest"),
R_WK = _a27:FindFirstChild("WK_Reclaim"),
R_EGG = _a27:FindFirstChild("Eggs_RequestPurchase"),
R_CEGG = _a27:FindFirstChild("CustomEggs_Hatch"),
R_LUCK = _a27:FindFirstChild("GardenChanceMachine_AddTime"),
}
if not (_a20.EntityPlacement and _a20.ClientTowerDefense and _a20.ClientPlot and _a20.GardenLaneFacing and _a20.TowerItem and _a28.R_ATTACH) then
warn("[PS99 Garden] 필수 모듈 로드 실패 — Garden 이벤트 안에서 실행해 주세요")
end
local _a29 = {
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
local _a30 = { Shiny = 1.5, Gold = 2, Rainbow = 4 }
local _a31 = {}
local _a32 = { place = false, merchant = false, upgrade = false, towerup = false,
crop = false, expand = false, rebirth = false, hatch = false, luck = false,
farm = false, zone = false, mhatch = false, rank = false, mreb = false,
quest = false, mapupg = false, items = false, slots = false,
auto = true, petspd = true, rewatch = true }
local _a33 = { slots = 0, filled = 0, empty = 0, placed = 0, swapped = 0, bought = 0,
upgraded = 0, sun = 0, replant = 0, hatched = 0, luck = 0,
farm = 0, zone = 0, mhatch = 0, rank = 0, mreb = 0,
quest = 0, potup = 0, potuse = 0, mapupg = 0, items = 0, mslot = 0 }
_a29.CropInterval = 20
_a29.CropMargin   = 1.5
_a29.SkipUnhatched = true
_a29.MinSunflowers  = 0
_a29.BuyUnknownCost = false
_a29.ExpandInterval  = 20
_a29.RebirthInterval = 30
_a29.HatchInterval = 5
_a29.HatchMax      = 100
_a29.HatchReserve  = 0
_a29.HatchEggNum   = 0
_a29.HatchUid      = ""
_a29.LuckInterval  = 3600
_a29.LuckReserve   = 0
_a29.LuckMinTopUp  = 600
_a29.LuckBoosts    = { Huge = true, Titanic = true, Gargantuan = true }
_a29.FarmInterval        = 10
_a29.ZoneInterval        = 10
_a29.MainHatchInterval   = 1
_a29.MainHatchMax        = 100
_a29.MainHatchReserve    = 0
_a29.MainEggId           = ""
_a29.RankInterval        = 30
_a29.MainRebirthInterval = 60
_a29.MainRebirthVerbose  = false
_a29.MaxBedScan     = 80
_a29.QuestInterval  = 10
_a29.QuestUpgrade   = true
_a29.QuestUsePotion = true
_a29.QuestDrive     = true
_a29.QuestUseMax    = 20
_a29.EggRange       = 40
_a29.QuestTp        = true
_a29.TpMode     = "instant"
_a29.TpSpeed    = 160
_a29.TpHeight   = 0
_a29.ArriveDist = 12
_a29.ZoneArriveDist = 90
_a29.QuestLock  = true
_a29.SpawnPerCycle = 1
_a29.EventStayDist = 45
_a29.AutoInterval = 5
_a29.HoldZoneForQuest = true
_a29.HatchBudget  = 25
_a29.ScreenTryMax   = 8
_a29.ScreenRealClick = true
_a29.PursueStallSec = 60
_a29.HatchMinAfford = 10
_a29.MoneyDwell     = 60
_a29.IdleHatch      = false
_a29.PetSpeedMult = 50
_a29.PetSpeedBase = 4
_a29.TpGameFallback = false
_a29.TpCooldown = 2.5
_a29.HatchAutoTp = true
_a29.AutoUnlockEgg = true
_a29.UseAutoHatch  = true
_a29.HatchClick    = true
_a29.HatchClickAfter = 0.6
_a29.TpToBreakables = true
_a29.UpgInterval  = 30
_a29.UpgReserve   = 0
_a29.UpgTp        = true
_a29.SlotInterval = 30
_a29.SlotReserve  = 0
_a29.SlotPet      = true
_a29.SlotEgg      = true
_a29.ItemInterval  = 20
_a29.BuffPotion    = true
_a29.BuffFruit     = true
_a29.BuffUltimate  = true
_a29.BuffConsumable = false
_a29.BuffHighTier  = true
_a29.ItemKeep      = 0
_a29.ItemAllow     = ""
_a29.ItemBlock     = "Rain, Sunlight"
_a29.ItemBestZone  = true
_a29.ItemTp        = false
_a29.BuffMaxPotion = 5
_a29.BuffMaxOther  = 2
_a1.RS, _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log = _a2, _a3, _a4, _a5, _a7, _a9
_a1.num, _a1.req, _a1.LB, _a1.ff, _a1.NET, _a1.RM = _a11, _a14, _a20, _a21, _a27, _a28
_a1.CFG, _a1.VARIANT, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT = _a29, _a30, _a31, _a32, _a33
local _a34   = "juhjuh4212-creator/ps99-hub"
local _a35 = "main"
local _a36    = ""
local _a37  = { "event", "main", "ui" }
local _a38 = (type(getgenv) == "function") and getgenv() or nil
local function _a39(_a40)
local _a41, _a42 = pcall(function() return (getfenv and getfenv() or _G)[_a40] end)
return _a41 and type(_a42) == "function"
end
if not _a39("loadstring") then
warn("[PS99] loadstring 이 없는 익스큐터입니다. 합본을 실행하세요.")
return
end
local _a43 = _a38 and _a38.PS99_BASE or nil
if not _a43 and _a39("readfile") then
for _a44, _a45 in ipairs({ "PS99/", "ps99/", "" }) do
if pcall(readfile, _a45 .. "event.lua") then _a43 = _a45 break end
end
end
local function _a46(_a47)
local _a48, _a49 = pcall(function() return game:HttpGet(_a47) end)
if _a48 and type(_a49) == "string" and #_a49 > 0 then return _a49 end
local _a50 = (syn and syn.request) or (http and http.request) or http_request or request
if type(_a50) == "function" then
local _a51, _a52 = pcall(_a50, { Url = _a47, Method = "GET" })
if _a51 and type(_a52) == "table" and type(_a52.Body) == "string" and #_a52.Body > 0 then
return _a52.Body
end
end
return nil
end
local _a53 = ("https://raw.githubusercontent.com/%s/%s/%s"):format(_a34, _a35, _a36)
local function _a54(_a55)
if _a43 then
local _a56, _a57 = pcall(readfile, _a43 .. _a55 .. ".lua")
if _a56 and type(_a57) == "string" and #_a57 > 0 then return _a57, "로컬" end
end
local _a58 = _a46(_a53 .. _a55 .. ".lua?t=" .. tostring(tick()):gsub("%D", ""))
if _a58 then return _a58, "깃허브" end
return nil
end
local _a59 = _a54("event")
if not _a59 then
warn("[PS99] 모듈을 못 받았습니다.")
warn("[PS99]   로컬: 익스큐터 작업 폴더에 PS99 폴더를 만들고 event/main/ui.lua 를 넣기")
warn("[PS99]   깃허브: " .. _a53)
warn("[PS99] 둘 다 안 되면 합본(PS99_GardenAuto.lua)을 실행하세요.")
return
end
for _a60, _a61 in ipairs(_a37) do
local _a62, _a63 = _a54(_a61)
if not _a62 then
warn("[PS99] " .. _a61 .. ".lua 를 못 받았습니다")
return
end
local _a64, _a65 = loadstring(_a62, "@" .. _a61 .. ".lua")
if not _a64 then
warn("[PS99] " .. _a61 .. ".lua 문법 오류: " .. tostring(_a65))
return
end
local _a66, _a67 = pcall(_a64)
if not (_a66 and type(_a67) == "function") then
warn("[PS99] " .. _a61 .. ".lua 가 함수를 반환하지 않음: " .. tostring(_a67))
return
end
local _a68, _a69 = pcall(_a67, _a1)
if not _a68 then
warn("[PS99] " .. _a61 .. ".lua 실행 오류: " .. tostring(_a69))
return
end
_a9("[로드] " .. _a61 .. ".lua  (" .. _a63 .. ")")
end
