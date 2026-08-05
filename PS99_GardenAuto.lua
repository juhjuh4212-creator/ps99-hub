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
;(function(_a34)
local _a35, _a36, _a37, _a38, _a39, _a40 = _a34.RS, _a34.LP, _a34.log, _a34.num, _a34.req, _a34.LB
local _a41, _a42, _a43, _a44, _a45, _a46 = _a34.ff, _a34.RM, _a34.CFG, _a34.VARIANT, _a34.EGG_COST_CACHE, _a34.RUN
local _a47 = _a34.STAT
local _a48
local _a49 = {
"GardenMoreDamage", "GardenFasterAttacks", "GardenMoreCoins",
"GardenBetterEggs", "GardenBetterLuck", "GardenBiggerHarvest",
"GardenFasterCrops", "GardenMoreSeeds",
}
local _a50
local function _a51()
if _a50 then return _a50 end
_a50 = {}
local _a52 = _a35:FindFirstChild("__DIRECTORY")
_a52 = _a52 and _a52:FindFirstChild("TowerDefenseTowers")
if _a52 then
for _a53, _a54 in ipairs(_a52:GetDescendants()) do
if _a54:IsA("ModuleScript") then
local _a55, _a56 = pcall(require, _a54)
if _a55 and type(_a56) == "table" then _a50[rawget(_a56, "_id") or _a54.Name] = _a56 end
end
end
end
return _a50
end
local function _a57(_a58, _a59, _a60)
local _a61 = _a51()[_a58]
if type(_a61) ~= "table" then return 0 end
local _a62 = tonumber(rawget(_a61, "AttackDamage")) or 0
local _a63 = tonumber(rawget(_a61, "AttackSpeed")) or 0
local _a64, _a65 = _a62 * _a63, 0
local _a66 = rawget(_a61, "Projectile")
if type(_a66) == "table" then
local _a67 = rawget(_a66, "ApplyDots")
if type(_a67) == "table" then
for _a68, _a69 in pairs(_a67) do
if type(_a69) == "table" then
local _a70  = tonumber(rawget(_a69, "Duration")) or 0
local _a71 = tonumber(rawget(_a69, "TickDelta")) or 0
local _a72  = tonumber(rawget(_a69, "DamageMult")) or 1
local _a73   = tonumber(rawget(_a69, "Probability")) or 1
if _a71 > 0 and _a70 > 0 and _a63 > 0 then
_a65 += (_a62 * _a72 * _a73 / _a71) * math.min(1, _a70 * _a63) * _a43.DotFactor
end
end
end
end
local _a74 = tonumber(rawget(_a66, "LingerDuration")) or 0
if _a74 > 0 and _a63 > 0 then _a65 += _a64 * math.min(1, _a74 * _a63) * 0.5 * _a43.DotFactor end
end
local _a75 = (_a64 + _a65) * (_a44[_a59 or ""] or 1)
return (_a75 ~= _a75) and 0 or _a75
end
local function _a76(_a77, _a78)
if type(_a77) ~= "string" then return nil end
return string.match(_a77, '"' .. _a78 .. '"%s*:%s*"([^"]*)"')
end
local function _a79(_a80)
if type(_a80) ~= "table" and typeof(_a80) ~= "userdata" then return nil, nil end
local _a81, _a82
pcall(function() _a81 = rawget(_a80, "_stackKey") end)
pcall(function() _a82 = rawget(_a80, "_exactStackKey") end)
if not _a81 then pcall(function() _a81 = _a80._stackKey end) end
if not _a82 then pcall(function() _a82 = _a80._exactStackKey end) end
local _a83 = _a76(_a81, "id") or _a76(_a82, "id")
local _a84 = _a76(_a81, "vr") or _a76(_a82, "vr")
return _a83, _a84
end
local function _a85(_a86)
local _a87
if _a40.GardenDefenders and _a40.GardenDefenders.UnitKey then
pcall(function() _a87 = _a40.GardenDefenders.UnitKey(_a86) end)
end
if _a87 ~= nil then return tostring(_a87) end
local _a88, _a89 = _a79(_a86)
return tostring(_a88) .. "|" .. tostring(_a89 or "")
end
local function _a90()
local _a91 = {}
if not _a40.Save then return _a91 end
local _a92, _a93 = pcall(_a40.Save.Get)
if not _a92 or type(_a93) ~= "table" then return _a91 end
local _a94 = _a93.Inventory and _a93.Inventory.Tower
if type(_a94) ~= "table" then return _a91 end
for _a95, _a96 in pairs(_a94) do
if type(_a96) == "table" then _a91[_a95] = { id = _a96.id, vr = _a96.vr } end
end
return _a91
end
local function _a97()
local _a98, _a99
pcall(function()
_a98 = _a40.ClientTowerDefense and _a40.ClientTowerDefense.GetLocal and _a40.ClientTowerDefense.GetLocal()
end)
pcall(function()
_a99 = _a40.ClientPlot and _a40.ClientPlot.GetLocal and _a40.ClientPlot.GetLocal()
end)
local _a100
if _a99 then pcall(function() _a100 = _a99:GetModel() end) end
local _a101 = 0
if _a40.LaneUnlock and _a99 then
local _a102, _a103 = pcall(_a40.LaneUnlock.UnlockedFor, _a99)
if _a102 then _a101 = tonumber(_a103) or 0 end
end
return _a98, _a99, _a100, _a101
end
local function _a104(_a105, _a106)
local _a107 = {}
local _a108 = _a105 and _a105:FindFirstChild("Lanes")
if not _a108 then return _a107 end
for _a109, _a110 in ipairs(_a108:GetChildren()) do
local _a111 = tonumber(_a110.Name)
if _a111 and _a111 <= _a106 then
local _a112 = _a110:FindFirstChild("Slots")
if _a112 then
for _a113, _a114 in ipairs(_a112:GetChildren()) do
if _a114:IsA("BasePart") then
_a107[#_a107 + 1] = {
part = _a114, lane = _a111,
pos = _a114.Position + Vector3.new(0, _a114.Size.Y / 2, 0),
}
end
end
end
end
end
return _a107
end
local function _a115(_a116)
local _a117
pcall(function() _a117 = _a116:GetUpgrade() end)
if type(_a117) == "number" then return _a117 end
pcall(function()
local _a118 = rawget(_a116, "State")
local _a119 = _a118 and rawget(_a118, "Upgrade")
_a117 = _a119 and rawget(_a119, "Value")
end)
return tonumber(_a117) or 0
end
local function _a120(_a121)
local _a122
pcall(function() _a122 = _a121:GetId() end)
if type(_a122) == "number" then return _a122 end
pcall(function() _a122 = rawget(_a121, "Id") end)
return tonumber(_a122)
end
local function _a123(_a124)
local _a125 = {}
if not (_a124 and _a40.ClientTower) then return _a125 end
local _a126
pcall(function() _a126 = _a40.ClientTower.All(_a124) end)
if type(_a126) ~= "table" then return _a125 end
local _a127 = _a90()
for _a128, _a129 in ipairs(_a126) do
local _a130, _a131, _a132
pcall(function() _a130 = _a129:GetItem() end)
pcall(function() _a131 = _a129:GetCFrame() end)
if _a130 then pcall(function() _a132 = _a130:GetOptionalUID() end) end
local _a133, _a134 = _a79(_a130)
if not _a133 then
local _a135 = _a127[_a132 or ""] or {}
_a133, _a134 = _a135.id, _a135.vr
end
local _a136 = _a115(_a129)
_a125[#_a125 + 1] = {
tower = _a129, item = _a130, uid = _a132, cf = _a131,
id = _a120(_a129), kind = _a133, vr = _a134, up = _a136,
dps = _a57(_a133, _a134, _a136),
}
end
return _a125
end
local function _a137()
local _a138 = {}
if not (_a40.TowerItem and _a40.EntityPlacement) then return _a138 end
local _a139
if not pcall(function() _a139 = _a40.TowerItem:All() end) or type(_a139) ~= "table" then return _a138 end
local _a140 = _a90()
local _a141 = {}
for _a142, _a143 in pairs(_a139) do
local _a144
pcall(function() _a144 = _a143:GetOptionalUID() end)
if _a144 then
local _a145 = _a85(_a143)
if not _a141[_a145] then
local _a146 = 0
pcall(function() _a146 = _a40.EntityPlacement.AvailableCopies(_a143) or 0 end)
if _a146 > 0 then
local _a147, _a148 = _a79(_a143)
if not _a147 then
local _a149 = _a140[_a144] or {}
_a147, _a148 = _a149.id, _a149.vr
end
_a141[_a145] = {
item = _a143, uid = _a144, key = _a145, id = _a147, vr = _a148,
copies = _a146, dps = _a57(_a147, _a148, 0),
}
else
_a141[_a145] = false
end
end
end
end
for _a150, _a151 in pairs(_a141) do
if _a151 then _a138[#_a138 + 1] = _a151 end
end
table.sort(_a138, function(_a152, _a153)
if (_a152.dps or 0) == (_a153.dps or 0) then return tostring(_a152.key) < tostring(_a153.key) end
return (_a152.dps or 0) > (_a153.dps or 0)
end)
return _a138
end
local function _a154(_a155)
local _a156
pcall(function() _a156 = _a40.GardenLaneFacing.ForSlot(_a155.pos, _a155.part) end)
return _a156
end
local function _a157(_a158, _a159)
local _a160 = _a154(_a158)
if not _a160 then return false end
local _a161 = false
pcall(function() _a161 = _a40.EntityPlacement.Validate(_a159, _a160) end)
return _a161 and true or false, _a160
end
local function _a162(_a163, _a164, _a165)
local _a166 = _a154(_a164)
if not _a166 then return false, "facing 실패" end
local _a167, _a168 = _a163.item, _a163.uid
if _a40.EntityPlacement and type(rawget(_a40.EntityPlacement, "FirstFreeCopy")) == "function" then
local _a169, _a170 = pcall(_a40.EntityPlacement.FirstFreeCopy, _a163.item)
if _a169 and _a170 then
_a167 = _a170
pcall(function() _a168 = _a170:GetUID() end)
end
end
if not _a168 then return false, "쓸 수 있는 스택 없음" end
local _a171 = _a165.CFrame:ToObjectSpace(_a166)
local _a172, _a173, _a174
if not pcall(function() _a172, _a173, _a174 = _a42.R_ATTACH:InvokeServer(_a168, _a171) end) then
return false, "호출 실패"
end
return _a172 and true or false, _a173, _a174
end
local function _a175(_a176)
if not (_a42.R_DETACH and _a176) then return false end
local _a177
pcall(function() _a177 = _a42.R_DETACH:InvokeServer(_a176) end)
return _a177 and true or false
end
local function _a178()
local _a179, _a180, _a181, _a182 = _a97()
if not (_a179 and _a181) then
_a37("[배치] 밭/월드 준비 안 됨 — Garden 안에 있는지 확인")
return
end
local _a183 = _a104(_a181, _a182)
_a47.slots = #_a183
if #_a183 == 0 then _a37("[배치] 슬롯 없음 (잠금해제 레인 " .. _a182 .. ")") return end
local _a184 = _a123(_a179)
local _a185 = _a137()
if #_a185 == 0 then
_a37("[배치] 배치 가능한 타워 없음 (종류별 최대치 도달)")
end
local _a186 = _a184
local _a187, _a188, _a189, _a190 = 0, 0, 0, 0
local _a191 = {}
local _a192 = {}
local function _a193(_a194)
return tostring(_a194 and _a194.key or (tostring(_a194 and _a194.id) .. "|" .. tostring(_a194 and _a194.vr or "")))
end
for _a195 = #_a185, 1, -1 do
if _a192[_a193(_a185[_a195])] then table.remove(_a185, _a195) end
end
local function _a196(_a197)
for _a198, _a199 in ipairs(_a186) do
if _a199.cf then
local _a200 = Vector2.new(_a199.cf.X - _a197.pos.X, _a199.cf.Z - _a197.pos.Z).Magnitude
if _a200 < 2 then return _a199 end
end
end
return nil
end
for _a201, _a202 in ipairs(_a183) do
if not _a46.place then break end
local _a203 = _a196(_a202)
if _a203 then _a187 += 1 else _a188 += 1 end
local _a204 = _a185[1]
if not _a204 then break end
if not _a203 then
local _a205, _a206, _a207 = _a162(_a204, _a202, _a179)
if _a205 then
_a189 += 1
_a47.placed += 1
_a37(("  ▸ 배치  레인%s  %s %s  DPS %s"):format(
_a202.lane, tostring(_a204.id), tostring(_a204.vr or "-"), _a38(_a204.dps)))
_a186 = _a123(_a179)
_a185 = _a137()
for _a208 = #_a185, 1, -1 do
if _a192[_a193(_a185[_a208])] then table.remove(_a185, _a208) end
end
else
_a191[tostring(_a206)] = (_a191[tostring(_a206)] or 0) + 1
if tostring(_a206):find("copies") then _a192[_a193(_a204)] = true end
table.remove(_a185, 1)
end
task.wait(_a43.ActionGap)
elseif (_a204.dps or 0) > (_a203.dps or 0) * _a43.SwapMargin then
if _a43.ProtectUpgraded and (_a203.up or 0) > 0 then
else
if _a175(_a203.id) then
task.wait(0.5)
local _a209 = _a137()
local _a210, _a211 = false, nil
for _a212 = 1, math.min(10, #_a209) do
local _a213 = _a209[_a212]
if not _a192[_a193(_a213)] then
local _a214, _a215 = _a162(_a213, _a202, _a179)
if _a214 then
_a210, _a211 = true, _a213
break
end
_a191[tostring(_a215)] = (_a191[tostring(_a215)] or 0) + 1
if tostring(_a215):find("copies") then _a192[_a193(_a213)] = true end
task.wait(0.15)
end
end
if _a210 and _a211 then
if _a211.id == _a203.kind and (_a211.vr or "") == (_a203.vr or "") then
_a37("  · 레인" .. _a202.lane .. " 같은 종류로 되돌림 (더 나은 게 없음)")
else
_a190 += 1
_a47.swapped += 1
_a37(("  ⇄ 교체  레인%s   %s%s(Lv%s) DPS %s  →  %s %s DPS %s"):format(
_a202.lane,
tostring(_a203.kind), _a203.vr and (" " .. _a203.vr) or "",
tostring(_a203.up), _a38(_a203.dps),
tostring(_a211.id), tostring(_a211.vr or "-"), _a38(_a211.dps)))
end
else
_a37("  ! 레인" .. _a202.lane .. " 아무것도 못 놓음 — 칸이 비었습니다")
end
_a186 = _a123(_a179)
_a185 = _a137()
for _a216 = #_a185, 1, -1 do
if _a192[_a193(_a185[_a216])] then table.remove(_a185, _a216) end
end
task.wait(_a43.ActionGap)
end
end
end
end
_a47.filled, _a47.empty = _a187, _a188
local _a217 = ("[배치] 슬롯 %d (찬칸 %d / 빈칸 %d)  이번에 배치 %d, 교체 %d")
:format(#_a183, _a187, _a188, _a189, _a190)
_a37(_a217)
if next(_a191) then
for _a218, _a219 in pairs(_a191) do _a37("    실패 " .. _a219 .. "회: " .. _a218) end
end
end
local function _a220()
if not _a42.R_BUY then _a37("[구매] 리모트 없음") return end
local _a221, _a222 = 0, 0
for _a223 = 1, _a43.MerchantSlots do
if not _a46.merchant then break end
local _a224
pcall(function() _a224 = _a42.R_BUY:InvokeServer(_a43.MerchantId, _a223) end)
if _a224 ~= nil and _a224 ~= false then _a221 += 1 else _a222 += 1 end
task.wait(0.3)
end
_a47.bought += _a221
_a37(("[구매] %s  성공 %d / 실패 %d"):format(_a43.MerchantId, _a221, _a222))
end
local function _a225()
if not _a40.Save then return 0 end
local _a226, _a227 = pcall(_a40.Save.Get)
if not _a226 or type(_a227) ~= "table" then return 0 end
local _a228 = _a227.Inventory and _a227.Inventory.Currency
if type(_a228) ~= "table" then return 0 end
for _a229, _a230 in pairs(_a228) do
if type(_a230) == "table" and rawget(_a230, "id") == "Sunflowers" then
return tonumber(rawget(_a230, "_am")) or 0
end
end
return 0
end
local function _a231()
local _a232 = {}
if not _a40.Save then return _a232 end
local _a233, _a234 = pcall(_a40.Save.Get)
if not _a233 or type(_a234) ~= "table" then return _a232 end
local _a235 = rawget(_a234, "EventUpgrades")
if type(_a235) == "table" then
for _a236, _a237 in pairs(_a235) do _a232[_a236] = tonumber(_a237) or 0 end
end
return _a232
end
local _a238
local function _a239()
if _a238 then return _a238 end
_a238 = {}
local _a240 = _a35:FindFirstChild("__DIRECTORY")
_a240 = _a240 and _a240:FindFirstChild("EventUpgrades")
if _a240 then
for _a241, _a242 in ipairs(_a240:GetDescendants()) do
if _a242:IsA("ModuleScript") then
local _a243, _a244 = pcall(require, _a242)
if _a243 and type(_a244) == "table" then
_a238[rawget(_a244, "_id") or _a242.Name] = _a244
end
end
end
end
return _a238
end
local _a245, _a246
local function _a247()
if _a245 ~= nil then return _a245 end
_a245 = false
local _a248 = {
_a39("Library", "Util", "GardenUpgradeCurve"),
_a39("Library", "Util", "GardenUpgradeBoosts"),
_a40.EventUpgradeCmds,
}
for _a249, _a250 in ipairs(_a248) do
if type(_a250) == "table" then
for _a251, _a252 in pairs(_a250) do
local _a253 = tostring(_a251):lower()
if type(_a252) == "function" and (_a253:find("cost") or _a253:find("price")) then
for _a254, _a255 in ipairs({
{ "GardenMoreDamage", 1 }, { "GardenMoreDamage", 2 },
{ 1 }, { 2 }, { "GardenMoreDamage" },
}) do
local _a256, _a257 = pcall(_a252, table.unpack(_a255))
if _a256 and type(_a257) == "number" and _a257 > 0 then
_a245 = _a252
_a246 = (#_a255 == 2) and "id_tier" or
(type(_a255[1]) == "number" and "tier" or "id")
return _a245
end
end
end
end
end
end
return _a245
end
local function _a258(_a259)
if _a259 == nil then return nil end
if type(_a259) == "number" then return _a259 end
if type(_a259) == "table" then
local _a260 = rawget(_a259, "_data")
if type(_a260) == "table" then
return tonumber(rawget(_a260, "_am")) or 1
end
end
local _a261, _a262 = pcall(function() return _a259:GetAmount() end)
if _a261 and type(_a262) == "number" then return _a262 end
return nil
end
local function _a263(_a264, _a265)
local _a266 = _a239()[_a264]
if type(_a266) == "table" then
for _a267, _a268 in ipairs({ "TierCosts", "Costs", "Prices", "TierPrices" }) do
local _a269 = rawget(_a266, _a268)
if type(_a269) == "table" then
local _a270 = _a258(_a269[(tonumber(_a265) or 0) + 1])
if _a270 then return _a270 end
end
end
end
local _a271 = _a247()
if _a271 then
local _a272 = (tonumber(_a265) or 0) + 1
local _a273
if _a246 == "id_tier" then _a273 = { { _a264, _a272 }, { _a264, _a265 } }
elseif _a246 == "tier" then _a273 = { { _a272 }, { _a265 } }
else _a273 = { { _a264 } } end
for _a274, _a275 in ipairs(_a273) do
local _a276, _a277 = pcall(_a271, table.unpack(_a275))
if _a276 and type(_a277) == "number" and _a277 > 0 then return _a277 end
end
end
return nil
end
local function _a278(_a279)
if _a40.EventUpgradeCmds and type(rawget(_a40.EventUpgradeCmds, "Purchase")) == "function" then
local _a280, _a281 = pcall(_a40.EventUpgradeCmds.Purchase, _a279)
if _a280 and _a281 ~= nil and _a281 ~= false then return true, _a281 end
if _a280 then return false, _a281 end
end
if _a42.R_EVUP then
local _a282
local _a283 = pcall(function() _a282 = _a42.R_EVUP:InvokeServer(_a279) end)
if _a283 then return (_a282 ~= nil and _a282 ~= false), _a282 end
end
return false, "호출 실패"
end
local function _a284()
if not (_a42.R_EVUP or _a40.EventUpgradeCmds) then _a37("[머신업글] API 없음") return end
local _a285, _a286 = 0, 0
while _a46.upgrade and _a285 < 40 do
_a285 += 1
local _a287 = _a225()
_a47.sun = _a287
local _a288 = _a231()
local _a289 = {}
for _a290, _a291 in ipairs(_a49) do
local _a292 = _a288[_a291] or 0
local _a293 = _a263(_a291, _a292)
_a289[#_a289 + 1] = { id = _a291, tier = _a292, cost = _a293 }
end
table.sort(_a289, function(_a294, _a295)
local _a296 = _a294.cost or math.huge
local _a297 = _a295.cost or math.huge
if _a296 == _a297 then return _a294.id < _a295.id end
return _a296 < _a297
end)
local _a298 = false
for _a299, _a300 in ipairs(_a289) do
if not _a46.upgrade then break end
local _a301 = _a300.cost and (_a287 - _a300.cost >= _a43.MinSunflowers)
if _a300.cost == nil then _a301 = _a43.BuyUnknownCost end
if _a301 then
local _a302 = _a287
local _a303, _a304 = _a278(_a300.id)
if _a303 then
_a286 += 1
_a47.upgraded += 1
_a298 = true
task.wait(0.4)
local _a305 = _a225()
_a37(("  ▲ %s  Lv%s → Lv%s   비용 %s   잔액 %s"):format(
_a300.id, tostring(_a300.tier), tostring(_a300.tier + 1),
_a38(_a302 - _a305, 0), _a38(_a305, 0)))
break
end
end
end
if not _a298 then break end
end
local _a306 = _a225()
_a47.sun = _a306
local _a307 = _a231()
if _a286 > 0 then
_a37(("[머신업글] %d건 구매 / 잔액 %s"):format(_a286, _a38(_a306, 0)))
else
local _a308, _a309 = math.huge, nil
for _a310, _a311 in ipairs(_a49) do
local _a312 = _a263(_a311, _a307[_a311] or 0)
if _a312 and _a312 < _a308 then _a308, _a309 = _a312, _a311 end
end
if _a309 then
_a37(("[머신업글] 살 수 있는 게 없음 — 잔액 %s / 최저 %s (%s)")
:format(_a38(_a306, 0), _a38(_a308, 0), _a309))
else
_a37("[머신업글] 구매 실패 (비용표를 못 읽음)")
end
end
end
local _a313, _a314
local function _a315()
if _a313 then return _a313 end
_a313 = {}
local _a316 = _a35:FindFirstChild("__DIRECTORY")
_a316 = _a316 and _a316:FindFirstChild("CropSeeds")
if _a316 then
for _a317, _a318 in ipairs(_a316:GetDescendants()) do
if _a318:IsA("ModuleScript") then
local _a319, _a320 = pcall(require, _a318)
if _a319 and type(_a320) == "table" then _a313[rawget(_a320, "_id") or _a318.Name] = _a320 end
end
end
end
return _a313
end
local function _a321()
if _a314 then return _a314 end
_a314 = {}
local _a322 = _a35:FindFirstChild("__DIRECTORY")
_a322 = _a322 and _a322:FindFirstChild("GardenCrops")
if _a322 then
for _a323, _a324 in ipairs(_a322:GetDescendants()) do
if _a324:IsA("ModuleScript") then
local _a325, _a326 = pcall(require, _a324)
if _a325 and type(_a326) == "table" then _a314[rawget(_a326, "_id") or _a324.Name] = _a326 end
end
end
end
return _a314
end
local function _a327(_a328)
local _a329 = _a321()[_a328]
return _a329 and tonumber(rawget(_a329, "CoinsPerSec")) or 0
end
local _a330 = {}
local function _a331(_a332)
if _a330[_a332] then return _a330[_a332] end
local _a333 = _a315()[_a332]
local _a334 = _a333 and rawget(_a333, "SpeciesWeights")
local _a335, _a336 = 0, 0
if type(_a334) == "table" then
for _a337, _a338 in pairs(_a334) do
local _a339 = tonumber(_a338) or 0
_a335 += _a339
_a336 += _a339 * _a327(_a337)
end
end
local _a340 = (_a335 > 0) and (_a336 / _a335) or 0
_a330[_a332] = _a340
return _a340
end
local function _a341()
local _a342 = {}
if not _a40.Save then return _a342 end
local _a343, _a344 = pcall(_a40.Save.Get)
if not _a343 or type(_a344) ~= "table" then return _a342 end
local _a345 = _a344.Inventory and _a344.Inventory.CropSeed
if type(_a345) ~= "table" then return _a342 end
for _a346, _a347 in pairs(_a345) do
if type(_a347) == "table" then
local _a348 = tonumber(rawget(_a347, "_am")) or 1
if _a348 > 0 then
_a342[#_a342 + 1] = {
uid = _a346, id = rawget(_a347, "id"), vr = rawget(_a347, "vr"),
am = _a348, exp = _a331(rawget(_a347, "id")),
}
end
end
end
table.sort(_a342, function(_a349, _a350)
if (_a349.exp or 0) == (_a350.exp or 0) then return (_a349.am or 0) > (_a350.am or 0) end
return (_a349.exp or 0) > (_a350.exp or 0)
end)
return _a342
end
local function _a351(_a352)
if not _a352 then return {} end
local _a353
pcall(function() _a353 = _a352:Save("PvC_Beds") end)
return type(_a353) == "table" and _a353 or {}
end
local function _a354(_a355, _a356)
if not (_a40.GardenPlots and _a355) then return true end
local _a357, _a358 = pcall(_a40.GardenPlots.IsBedUnlocked, _a355, _a356)
if _a357 then return _a358 and true or false end
return true
end
local function _a359(_a360)
if not (_a40.PvCropGrowth and type(_a360) == "table") then return false end
local _a361, _a362 = pcall(_a40.PvCropGrowth.IsUnhatched, _a360)
return _a361 and _a362 and true or false
end
local function _a363(_a364)
if type(_a364) ~= "table" then return nil end
local _a365 = tonumber(rawget(_a364, "cps"))
if _a365 then return _a365 end
local _a366 = rawget(_a364, "sp")
if _a366 then return _a327(_a366) end
return nil
end
local function _a367()
local _a368, _a369 = _a97()
if not _a369 then _a37("[씨앗] 밭 없음") return end
local _a370 = _a351(_a369)
local _a371 = _a341()
if #_a371 == 0 then _a37("[씨앗] 인벤에 씨앗 없음") return end
local _a372, _a373 = {}, {}
for _a374 in pairs(_a370) do
if not _a373[tostring(_a374)] then _a373[tostring(_a374)] = true _a372[#_a372 + 1] = _a374 end
end
for _a375 = 1, 80 do
local _a376 = tostring(_a375)
if not _a373[_a376] and _a354(_a369, _a376) then _a373[_a376] = true _a372[#_a372 + 1] = _a376 end
end
local _a377, _a378, _a379, _a380 = 0, 0, 0, 0
local _a381 = 1
for _a382, _a383 in ipairs(_a372) do
if not _a46.crop then break end
local _a384 = _a371[_a381]
while _a384 and _a384.am <= 0 do
_a381 += 1
_a384 = _a371[_a381]
end
if not _a384 then break end
local _a385 = _a370[_a383]
local _a386 = _a363(_a385)
if _a385 == nil then
local _a387
pcall(function() _a387 = _a369:Invoke("SD_Insert", _a383, _a384.uid) end)
if _a387 ~= false then
_a378 += 1
_a47.replant += 1
_a384.am -= 1
_a37(("  ▸ 심기  칸%s  %s 씨앗 (기대 %s/s)"):format(tostring(_a383), tostring(_a384.id), _a38(_a384.exp)))
task.wait(_a43.ActionGap)
end
elseif _a43.SkipUnhatched and _a359(_a385) then
_a380 += 1
elseif _a386 and (_a384.exp or 0) > _a386 * _a43.CropMargin then
local _a388
pcall(function() _a388 = _a369:Invoke("SD_Purge", _a383) end)
if _a388 ~= false then
task.wait(0.4)
local _a389
pcall(function() _a389 = _a369:Invoke("SD_Insert", _a383, _a384.uid) end)
if _a389 ~= false then
_a377 += 1
_a47.replant += 1
_a384.am -= 1
_a37(("  ⇄ 갈아엎기  칸%s  %s(%s/s) → %s 씨앗(기대 %s/s)"):format(
tostring(_a383), tostring(rawget(_a385, "sp") or "?"), _a38(_a386),
tostring(_a384.id), _a38(_a384.exp)))
else
_a37("  ! 칸" .. tostring(_a383) .. " 파냈는데 심기 실패")
end
task.wait(_a43.ActionGap)
end
else
_a379 += 1
end
end
_a37(("[씨앗] 심기 %d / 갈아엎기 %d / 유지 %d / 성장중 %d")
:format(_a378, _a377, _a379, _a380))
end
local function _a390(_a391)
if _a48 and not _a391 then return _a48 end
if _a42.R_JC then
local _a392, _a393 = pcall(function() return _a42.R_JC:InvokeServer() end)
if _a392 and type(_a393) == "table" then _a48 = _a393 end
end
return _a48 or {}
end
local function _a394(_a395)
if not (_a40.GardenPlots and rawget(_a40.GardenPlots, "PlotCost")) then return nil end
local _a396, _a397 = pcall(_a40.GardenPlots.PlotCost, tonumber(_a395))
return (_a396 and type(_a397) == "number") and _a397 or nil
end
local function _a398(_a399)
local _a400 = {}
if not _a399 then return _a400 end
for _a401 = 1, _a43.MaxBedScan do
local _a402 = tostring(_a401)
if not _a354(_a399, _a402) then
_a400[#_a400 + 1] = { id = _a402, n = _a401, cost = _a394(_a401) }
end
end
table.sort(_a400, function(_a403, _a404)
return (_a403.cost or math.huge) < (_a404.cost or math.huge)
end)
return _a400
end
local function _a405()
local _a406, _a407, _a408, _a409 = _a97()
if not _a407 then _a37("[확장] 밭 없음") return end
local _a410, _a411 = 0, 0
local _a412 = _a225()
local _a413 = _a390(true)
local _a414 = 0
while _a46.expand and _a414 < 12 do
_a414 += 1
local _a415 = (tonumber(_a409) or 0) + 1
local _a416 = tonumber(_a413[_a415]) or tonumber(_a413[tostring(_a415)])
if _a416 and (_a412 - _a416) < _a43.MinSunflowers then
_a37(("[확장] 레인%d 비용 %s / 잔액 %s — 부족"):format(_a415, _a38(_a416, 0), _a38(_a412, 0)))
break
end
if not _a416 and not _a43.BuyUnknownCost then
_a37("[확장] 레인" .. _a415 .. " 비용을 못 읽음 — 건너뜀")
break
end
if not _a42.R_WIDEN then break end
local _a417 = _a412
local _a418, _a419, _a420
pcall(function() _a418, _a419, _a420 = _a42.R_WIDEN:InvokeServer() end)
task.wait(0.5)
_a412 = _a225()
if _a418 then
_a410 += 1
_a411 += (_a417 - _a412)
_a409 = tonumber(_a420) or (_a409 + 1)
_a37(("  ▣ 레인 오픈 → %s개   비용 %s   잔액 %s"):format(
tostring(_a409), _a38(_a417 - _a412, 0), _a38(_a412, 0)))
task.wait(_a43.ActionGap)
else
if _a419 then _a37("[확장] 레인 실패: " .. tostring(_a419)) end
break
end
end
local _a421 = _a398(_a407)
for _a422, _a423 in ipairs(_a421) do
if not _a46.expand then break end
if _a423.cost and (_a412 - _a423.cost) < _a43.MinSunflowers then break end
if not _a423.cost and not _a43.BuyUnknownCost then break end
local _a424 = _a412
local _a425
pcall(function() _a425 = _a407:Invoke("BD_Acquire", _a423.id) end)
task.wait(0.4)
_a412 = _a225()
if _a425 ~= false and _a412 < _a424 then
_a410 += 1
_a411 += (_a424 - _a412)
_a37(("  ▣ 밭칸 %s 오픈   비용 %s   잔액 %s"):format(
_a423.id, _a38(_a424 - _a412, 0), _a38(_a412, 0)))
task.wait(_a43.ActionGap)
else
break
end
end
_a47.sun = _a412
if _a410 > 0 then
_a37(("[확장] %d개 오픈 / 총 %s 소비"):format(_a410, _a38(_a411, 0)))
else
local _a426 = (tonumber(_a409) or 0) + 1
local _a427 = _a413[_a426] or _a413[tostring(_a426)]
local _a428 = _a421[1]
_a37(("[확장] 오픈할 것 없음 — 잔액 %s / 다음 레인%d %s / 다음 밭칸 %s"):format(
_a38(_a412, 0), _a426, _a427 and _a38(_a427, 0) or "?",
_a428 and (_a428.id .. " " .. (_a428.cost and _a38(_a428.cost, 0) or "?")) or "없음"))
end
end
local function _a429()
local _a430, _a431 = _a97()
if not _a431 then return nil end
local function _a432(_a433)
local _a434
pcall(function() _a434 = _a431:Save(_a433) end)
return _a434
end
local _a435 = tonumber(_a432("PvC_Regrows")) or 0
local _a436   = tonumber(_a432("PvC_UnlockedLanes")) or 1
local _a437   = tonumber(_a432("PvC_RunBossKills")) or 0
local _a438     = _a41("PvC_RegrowCap") or math.huge
local _a439    = _a41("PvC_RegrowBossBase") or 1
local _a440    = _a41("PvC_RegrowBossStep") or 1
local _a441  = math.min(_a435, _a438)
local _a442    = math.ceil(_a439 * (_a440 ^ _a441))
local _a443   = (_a438 <= _a441)
return {
regrows = _a435, lanes = _a436, kills = _a437, need = _a442,
cap = _a438, maxed = _a443,
ready = (not _a443) and _a436 >= 7 and _a437 >= _a442,
reason = _a443 and "최대 리버스 도달"
or (_a436 < 7 and ("레인 %d/7"):format(_a436))
or (_a437 < _a442 and ("코인보스 %d/%d"):format(_a437, _a442))
or nil,
}
end
local function _a444()
if not _a42.R_WK then _a37("[리버스] WK_Reclaim 리모트 없음") return end
local _a445 = _a429()
if not _a445 then _a37("[리버스] 밭 없음") return end
if not _a445.ready then
_a37(("[리버스] 대기 — %s   (리버스 %d회)"):format(tostring(_a445.reason), _a445.regrows))
return
end
_a37(("[리버스] 조건 충족 (레인 %d, 보스 %d/%d) — 실행"):format(_a445.lanes, _a445.kills, _a445.need))
local _a446, _a447, _a448
pcall(function() _a446, _a447, _a448 = _a42.R_WK:InvokeServer() end)
task.wait(1.5)
if _a446 then
_a47.sun = _a225()
_a48 = nil
_a37(("  ★ 리버스 성공 → %s회   (레인/밭칸/작물 초기화됨)"):format(tostring(_a448 or (_a445.regrows + 1))))
_a37("  자동 확장이 켜져 있으면 레인/밭칸을 다시 엽니다")
else
_a37("  ✗ 리버스 실패: " .. tostring(_a447))
end
end
local _a449 = _a39("Library", "Util", "GardenEggs")
local _a450    = _a39("Library", "Directory", "Eggs")
local _a451= _a39("Library", "Balancing", "CalcEggPricePlayer")
local _a452  = _a39("Library", "Balancing", "CalcEggPrice")
local function _a453()
if _a43.HatchEggNum and _a43.HatchEggNum >= 1 then
return math.floor(_a43.HatchEggNum)
end
local _a454, _a455 = _a97()
if _a449 and rawget(_a449, "CurrentEggNum") then
local _a456, _a457 = pcall(_a449.CurrentEggNum, _a455)
if _a456 and tonumber(_a457) then return math.floor(tonumber(_a457)) end
end
if _a40.EventUpgradeCmds and rawget(_a40.EventUpgradeCmds, "GetPower") then
local _a458, _a459 = pcall(_a40.EventUpgradeCmds.GetPower, "GardenBetterEggs")
if _a458 and tonumber(_a459) then return math.clamp(1 + math.floor(tonumber(_a459)), 1, 12) end
end
return 1
end
local function _a460(_a461)
return ("Garden Egg %d"):format(_a461 or _a453())
end
local function _a462(_a463)
if type(_a450) == "table" then
local _a464 = rawget(_a450, _a463)
if _a464 then return _a464 end
end
local _a465 = _a35:FindFirstChild("__DIRECTORY")
_a465 = _a465 and _a465:FindFirstChild("Eggs")
if _a465 then
for _a466, _a467 in ipairs(_a465:GetDescendants()) do
if _a467:IsA("ModuleScript") then
local _a468, _a469 = pcall(require, _a467)
if _a468 and type(_a469) == "table" and rawget(_a469, "_id") == _a463 then return _a469 end
end
end
end
return nil
end
table.clear(_a45)
local function _a470(_a471)
if _a45[_a471] then return _a45[_a471] end
local _a472 = _a462(_a471)
if not _a472 then return nil end
for _a473, _a474 in ipairs({ _a451, _a452 }) do
if type(_a474) == "function" then
local _a475, _a476 = pcall(_a474, _a472)
if _a475 and tonumber(_a476) and tonumber(_a476) > 0 then
_a45[_a471] = tonumber(_a476)
return _a45[_a471]
end
end
end
local _a477 = tonumber(rawget(_a472, "overrideCost"))
if _a477 then
local _a478 = _a41("PvC_EggCostMult")
if not _a478 or _a478 <= 0 then _a478 = 1 end
local _a479 = math.max(1, math.round(_a477 * _a478))
_a45[_a471] = _a479
return _a479
end
return nil
end
local _a480 = _a39("Library", "Client", "CustomEggsCmds")
local function _a481()
local _a482 = {}
local _a483 = workspace:FindFirstChild("__THINGS")
_a483 = _a483 and _a483:FindFirstChild("CustomEggs")
if not _a483 then return _a482 end
local _a484 = _a36.Character and _a36.Character:FindFirstChild("HumanoidRootPart")
for _a485, _a486 in ipairs(_a483:GetChildren()) do
local _a487
pcall(function()
if _a486:IsA("Model") then _a487 = _a486:GetPivot().Position
elseif _a486:IsA("BasePart") then _a487 = _a486.Position end
end)
_a482[#_a482 + 1] = {
uid = _a486.Name, inst = _a486,
dist = (_a487 and _a484) and (_a487 - _a484.Position).Magnitude or math.huge,
}
end
table.sort(_a482, function(_a488, _a489) return _a488.dist < _a489.dist end)
return _a482
end
local function _a490()
if _a43.HatchUid and _a43.HatchUid ~= "" then return _a43.HatchUid end
local _a491 = _a481()
return _a491[1] and _a491[1].uid or nil
end
local function _a492()
if type(_a480) == "table" then
local _a493 = rawget(_a480, "GetMaxEggCount")
if type(_a493) == "function" then
local _a494, _a495 = pcall(_a493)
if _a494 and tonumber(_a495) and tonumber(_a495) >= 1 then return math.floor(tonumber(_a495)) end
end
end
return _a43.HatchMax
end
local function _a496()
local _a497 = _a453()
local _a498 = _a460(_a497)
local _a499 = _a470(_a498)
local _a500 = _a225()
local _a501 = math.max(0, _a500 - (_a43.HatchReserve or 0))
local _a502 = _a481()
return {
num = _a497, id = _a498, cost = _a499, sun = _a500,
uid = _a490(), eggCount = #_a502, eggs = _a502,
canBuy = (_a499 and _a499 > 0) and math.floor(_a501 / _a499) or 0,
}
end
local function _a503()
if not _a42.R_CEGG then _a37("[뽑기] CustomEggs_Hatch 리모트 없음") return end
local _a504 = _a496()
_a47.sun = _a504.sun
if not _a504.uid then
_a37("[뽑기] 알을 못 찾음 — 알 근처로 가주세요 (workspace.__THINGS.CustomEggs 비어있음)")
return
end
if not _a504.cost then
_a37("[뽑기] " .. _a504.id .. " 비용을 못 읽음")
return
end
if _a504.canBuy < 1 then
return
end
local _a505 = math.min(_a43.HatchMax, _a492())
local _a506, _a507 = 0, 0
local _a508 = math.min(_a504.canBuy, _a505)
while _a46.hatch and _a508 >= 1 and _a507 < 20 do
_a507 += 1
local _a509, _a510
pcall(function() _a509, _a510 = _a42.R_CEGG:InvokeServer(_a504.uid, _a508) end)
if _a509 then
_a506 += _a508
_a47.hatched += _a508
task.wait(0.4)
local _a511 = _a225()
_a47.sun = _a511
local _a512 = math.max(0, _a511 - (_a43.HatchReserve or 0))
local _a513 = math.floor(_a512 / _a504.cost)
if _a513 < 1 then break end
_a508 = math.min(_a513, _a505)
else
local _a514 = tostring(_a510)
if _a514:find("quickly") then
task.wait(2.5)
elseif _a508 > 1 then
_a508 = math.floor(_a508 / 2)
else
if _a510 then _a37("[뽑기] 실패: " .. _a514) end
break
end
end
end
if _a506 > 0 then
_a37(("[뽑기] %s × %d   (개당 %s)   잔액 %s"):format(
_a504.id, _a506, _a38(_a504.cost, 0), _a38(_a225(), 0)))
end
end
local _a515 = _a39("Library", "Client", "GardenChanceMachineCmds")
local _a516 = _a39("Library", "Types", "GardenChanceMachine")
local _a517 = { "Huge", "Titanic", "Gargantuan" }
local function _a518()
if _a515 and rawget(_a515, "GetMaxBoostSeconds") then
local _a519, _a520 = pcall(_a515.GetMaxBoostSeconds)
if _a519 and tonumber(_a520) then return tonumber(_a520) end
end
return (_a516 and tonumber(rawget(_a516, "MaxSecondsDefault"))) or 21600
end
local function _a521(_a522)
if _a515 and rawget(_a515, "GetPerTokenSecondsForBoost") then
local _a523, _a524 = pcall(_a515.GetPerTokenSecondsForBoost, _a522)
if _a523 and tonumber(_a524) and tonumber(_a524) > 0 then return tonumber(_a524) end
end
local _a525 = (_a516 and _a516.TokensToMaxDefault
and tonumber(_a516.TokensToMaxDefault[_a522])) or 5000
return _a518() / _a525
end
local function _a526(_a527)
if _a515 and rawget(_a515, "GetBoostTime") then
local _a528, _a529 = pcall(_a515.GetBoostTime, _a527)
if _a528 and tonumber(_a529) then return tonumber(_a529) end
end
return 0
end
local function _a530()
if _a515 and rawget(_a515, "IsEnabled") then
local _a531, _a532 = pcall(_a515.IsEnabled)
if _a531 then return _a532 and true or false end
end
return true
end
local function _a533()
local _a534 = _a518()
local _a535 = {}
for _a536, _a537 in ipairs(_a517) do
local _a538 = _a526(_a537)
local _a539 = _a521(_a537)
local _a540 = math.max(0, _a534 - _a538)
_a535[#_a535 + 1] = {
rarity = _a537, left = _a538, per = _a539, deficit = _a540,
need = (_a539 > 0) and math.ceil(_a540 / _a539) or 0,
on = _a43.LuckBoosts[_a537] and true or false,
}
end
return { maxSec = _a534, rows = _a535, enabled = _a530(), sun = _a225() }
end
local function _a541(_a542)
_a542 = math.max(0, math.floor(tonumber(_a542) or 0))
local _a543 = math.floor(_a542 / 3600)
local _a544 = math.floor((_a542 % 3600) / 60)
return ("%d시간 %d분"):format(_a543, _a544)
end
local function _a545()
if not _a42.R_LUCK then _a37("[럭] GardenChanceMachine_AddTime 리모트 없음") return end
if not _a530() then _a37("[럭] 이 서버에서 비활성") return end
local _a546 = _a533()
_a47.sun = _a546.sun
local _a547 = _a546.sun
local _a548 = 0
for _a549, _a550 in ipairs(_a546.rows) do
if not _a46.luck then break end
if _a550.on and _a550.deficit >= _a43.LuckMinTopUp and _a550.need >= 1 then
local _a551 = math.max(0, _a547 - _a43.LuckReserve)
local _a552 = math.min(_a550.need, math.floor(_a551))
if _a552 >= 1 then
local _a553 = _a547
local _a554, _a555
pcall(function()
_a554, _a555 = _a42.R_LUCK:InvokeServer(_a550.rarity, "Slot1", _a552)
end)
task.wait(0.4)
_a547 = _a225()
_a47.sun = _a547
if _a554 then
_a548 += 1
_a47.luck += 1
_a37(("  ✦ 럭 %s  +%s  (%s → %s)  비용 %s"):format(
_a550.rarity, _a541(_a552 * _a550.per),
_a541(_a550.left), _a541(math.min(_a546.maxSec, _a550.left + _a552 * _a550.per)),
_a38(_a553 - _a547, 0)))
else
_a37(("  ✗ 럭 %s 실패: %s"):format(_a550.rarity, tostring(_a555)))
end
task.wait(_a43.ActionGap)
end
end
end
if _a548 == 0 then
local _a556 = {}
for _a557, _a558 in ipairs(_a546.rows) do
if _a558.on then
_a556[#_a556 + 1] = ("%s %s"):format(_a558.rarity, _a541(_a558.left))
end
end
if #_a556 > 0 then
_a37("[럭] 유지 중 — " .. table.concat(_a556, " / "))
end
end
end
_a34.EVENT_UPGRADES, _a34.ctx, _a34.collectSlots, _a34.placedTowers, _a34.availableItems, _a34.cyclePlace = _a49, _a97, _a104, _a123, _a137, _a178
_a34.cycleMerchant, _a34.sunflowers, _a34.eventTiers, _a34.nextCost, _a34.cycleUpgrade, _a34.seedInv = _a220, _a225, _a231, _a263, _a284, _a341
_a34.bedsOf, _a34.isUnhatched, _a34.bedCps, _a34.cycleCrop, _a34.laneCosts, _a34.lockedBeds = _a351, _a359, _a363, _a367, _a390, _a398
_a34.cycleExpand, _a34.rebirthStatus, _a34.cycleRebirth, _a34.hatchStatus, _a34.cycleHatch = _a405, _a429, _a444, _a496, _a503
_a34.LUCK_ORDER, _a34.luckStatus, _a34.fmtDur, _a34.cycleLuck = _a517, _a533, _a541, _a545
end)(_a1)
;(function(_a559)
local _a560, _a561, _a562, _a563, _a564, _a565 = _a559.UIS, _a559.RunService, _a559.LP, _a559.log, _a559.num, _a559.req
local _a566, _a567, _a568, _a569, _a570, _a571 = _a559.LB, _a559.NET, _a559.RM, _a559.CFG, _a559.RUN, _a559.STAT
local _a572, _a573 = _a559.ctx, _a559.placedTowers
local _a574 = {
AutoFarm = _a565("Library", "Client", "AutoFarmCmds"),
Zone     = _a565("Library", "Client", "ZoneCmds"),
Currency = _a565("Library", "Client", "CurrencyCmds"),
Bal      = _a565("Library", "Balancing"),
Egg      = _a565("Library", "Client", "EggCmds"),
Rebirth  = _a565("Library", "Client", "RebirthCmds"),
RanksU   = _a565("Library", "Util", "RanksUtil"),
DirRanks = _a565("Library", "Directory", "Ranks"),
DirEggs  = _a565("Library", "Directory", "Eggs"),
CalcEgg  = _a565("Library", "Balancing", "CalcEggPricePlayer"),
R_Farm   = _a567:FindFirstChild("AutoFarm_Enable"),
R_FarmOff = _a567:FindFirstChild("AutoFarm_Disable"),
R_Zone   = _a567:FindFirstChild("Zones_RequestPurchase"),
R_Reb    = _a567:FindFirstChild("Rebirth_Request"),
R_Rank   = _a567:FindFirstChild("Ranks_ClaimReward"),
Quest    = _a565("Library", "Client", "QuestCmds"),
EggsU    = _a565("Library", "Util", "EggsUtil"),
Map      = _a565("Library", "Client", "MapCmds"),
Inst     = _a565("Library", "Client", "InstancingCmds"),
DirZones = _a565("Library", "Directory", "Zones"),
ZonesU   = _a565("Library", "Util", "ZonesUtil"),
Upg      = _a565("Library", "Client", "UpgradeCmds"),
DirUpg   = _a565("Library", "Directory", "Upgrades"),
R_Upg    = _a567:FindFirstChild("Upgrades_Purchase"),
R_EggUn  = _a567:FindFirstChild("Eggs_RequestUnlock"),
Rand     = _a565("Library", "Client", "RandomEventCmds"),
R_Events = _a567:FindFirstChild("RandomEvents_Get"),
Ult      = _a565("Library", "Client", "UltimateCmds"),
R_Fruit  = _a567:FindFirstChild("Fruits: Consume"),
R_Cons   = _a567:FindFirstChild("Consumables_Consume"),
R_Ult    = _a567:FindFirstChild("Ultimates: Activate"),
R_Gold   = _a567:FindFirstChild("GoldMachine_Activate"),
R_Rain   = _a567:FindFirstChild("RainbowMachine_Activate"),
R_Flag   = _a567:FindFirstChild("FlexibleFlags_Consume"),
DirPets  = _a565("Library", "Directory", "Pets"),
CalcEggB = _a565("Library", "Balancing", "CalcEggPrice"),
PlayerPet = _a565("Library", "Client", "PlayerPet"),
Machine  = _a565("Library", "Client", "MachineCmds"),
Vars     = _a565("Library", "Variables"),
Hatch    = _a565("Library", "Client", "HatchingCmds"),
R_AHTog  = _a567:FindFirstChild("AutoHatch_Toggle"),
R_AHOn   = _a567:FindFirstChild("AutoHatch_Enable"),
R_AHOff  = _a567:FindFirstChild("AutoHatch_Disable"),
RankC    = _a565("Library", "Client", "RankCmds"),
CalcPetS = _a565("Library", "Balancing", "CalcPetSlotPrice"),
CalcEggS = _a565("Library", "Balancing", "CalcEggSlotPrice"),
R_PetSlot = _a567:FindFirstChild("EquipSlotsMachine_RequestPurchase"),
R_EggSlot = _a567:FindFirstChild("EggHatchSlotsMachine_RequestPurchase"),
R_Tp     = _a567:FindFirstChild("Teleports_RequestTeleport"),
R_TpI    = _a567:FindFirstChild("Teleports_RequestInstanceTeleport"),
R_PotUp  = _a567:FindFirstChild("UpgradePotionsMachine_ActivateBulk"),
R_EncUp  = _a567:FindFirstChild("UpgradeEnchantsMachine_ActivateBulk"),
R_PotUse = _a567:FindFirstChild("Potions: Consume"),
}
local _a575 = {
[1]="farm", [9]="farm", [21]="farm", [7]="farm", [99]="farm", [8]="farm",
[30]="farm", [31]="farm", [32]="farm", [37]="farm", [38]="farm", [39]="farm",
[43]="farm", [44]="farm", [66]="farm", [67]="farm", [75]="farm", [76]="farm",
[14]="farm", [15]="farm", [64]="farm", [65]="farm", [63]="farm",
[2]="hatch", [3]="hatch", [20]="hatch", [42]="hatch", [47]="hatch",
[6]="zone", [81]="zone",
[34]="potuse",
[35]="fruituse", [33]="flaguse",
}
local _a576 = {}
_a576.ctl, _a576.move, _a576.egg = {}, {}, {}
_a576.screen, _a576.quest, _a576.ev = {}, {}, {}
_a576.item, _a576.mach, _a576.auto = {}, {}, {}
_a576.quest.IGNORE = {
[4]  = "골드 펫 만들기 (합성 필요)",
[5]  = "레인보우 펫 만들기 (합성 필요)",
[40] = "best egg 골드 펫 (뽑기+합성 필요)",
[41] = "best egg 레인보우 펫 (뽑기+2단 합성 필요)",
[12] = "포션 업글 (업글 머신으로 이동 필요)",
[13] = "인챈트 업글 (업글 머신으로 이동 필요)",
}
_a576.ctl.abort = false
function _a576.ctl.stopped() return _a576.ctl.abort == true end
function _a576.ctl.stopAll()
_a576.ctl.abort = true
for _a577 in pairs(_a570) do
if _a577 ~= "petspd" and _a577 ~= "rewatch" then _a570[_a577] = false end
end
_a576.ctl.lockGoal = nil
_a576.ctl.moving = nil
_a576.ctl.now.step = "정지"
_a576.ctl.setAct("정지됨")
end
_a576.ctl.now = { step = "-", act = "-", detail = "", goal = "-", prog = "" }
function _a576.ctl.setAct(_a578, _a579)
_a576.ctl.now.act = _a578 or "-"
_a576.ctl.now.detail = _a579 and tostring(_a579) or ""
_a576.ctl.now.at = os.clock()
end
function _a576.ctl.setGoal(_a580, _a581)
_a576.ctl.now.goal = _a580 and tostring(_a580) or "-"
_a576.ctl.now.prog = _a581 and tostring(_a581) or ""
end
function _a576.egg.eggStands()
local _a582 = os.clock()
if _a576.egg._standsAt and (_a582 - _a576.egg._standsAt) < 2 and _a576.egg._stands then
local _a583 = _a562.Character
local _a584 = _a583 and _a583:FindFirstChild("HumanoidRootPart")
if _a584 then
for _a585, _a586 in ipairs(_a576.egg._stands) do
_a586.dist = (_a586.pos - _a584.Position).Magnitude
end
table.sort(_a576.egg._stands, function(_a587, _a588) return _a587.dist < _a588.dist end)
end
return _a576.egg._stands
end
local _a589 = {}
local _a590 = workspace:FindFirstChild("__THINGS")
local _a591 = _a590 and _a590:FindFirstChild("Eggs")
if not _a591 then return _a589 end
local _a592 = _a562.Character
local _a593 = _a592 and _a592:FindFirstChild("HumanoidRootPart")
for _a594, _a595 in ipairs(_a591:GetDescendants()) do
if _a595:IsA("Model") and _a595.PrimaryPart then
local _a596 = tonumber(tostring(_a595.Name):match("%d+"))
if _a596 then
local _a597
if _a574.EggsU and rawget(_a574.EggsU, "GetByNumber") then
local _a598, _a599 = pcall(_a574.EggsU.GetByNumber, _a596)
if _a598 then _a597 = _a599 end
end
local _a600 = _a597 and (rawget(_a597, "_id") or rawget(_a597, "name"))
if _a600 then
_a589[#_a589 + 1] = {
id = _a600, def = _a597, num = _a596,
pos = _a595.PrimaryPart.Position,
dist = _a593 and (_a595.PrimaryPart.Position - _a593.Position).Magnitude or 9e9,
unlocked = _a595:GetAttribute("Unlocked") and true or false,
}
end
end
end
end
table.sort(_a589, function(_a601, _a602) return _a601.dist < _a602.dist end)
_a576.egg._stands, _a576.egg._standsAt = _a589, os.clock()
return _a589
end
local function _a603()
if not _a566.Save then return nil end
local _a604, _a605 = pcall(_a566.Save.Get)
return (_a604 and type(_a605) == "table") and _a605 or nil
end
local function _a606(_a607, _a608)
if _a574.Currency and rawget(_a574.Currency, "CanAfford") then
local _a609, _a610 = pcall(_a574.Currency.CanAfford, _a607, _a608)
if _a609 then return _a610 and true or false end
end
return false
end
local function _a611(_a612)
if _a574.Currency and rawget(_a574.Currency, "Get") then
local _a613, _a614 = pcall(_a574.Currency.Get, _a612)
if _a613 and tonumber(_a614) then return tonumber(_a614) end
end
return 0
end
local function _a615()
if _a574.AutoFarm and rawget(_a574.AutoFarm, "IsEnabled") then
local _a616, _a617 = pcall(_a574.AutoFarm.IsEnabled)
if _a616 then return _a617 and true or false end
end
return false
end
local function _a618()
if _a574.AutoFarm and rawget(_a574.AutoFarm, "GetTargetParentId") then
local _a619, _a620 = pcall(_a574.AutoFarm.GetTargetParentId)
if _a619 then return _a620 end
end
return nil
end
local function _a621()
if not _a574.R_Farm then _a563("[파밍] AutoFarm_Enable 리모트 없음") return end
local _a622 = _a615()
_a576.auto.farmZone, _a576.auto.hereZone = _a618(), _a576.move.curZone()
if _a622 then
local _a623, _a624 = _a618(), _a576.move.curZone()
if _a623 and _a624 and _a623 ~= _a624 then
_a563(("[파밍] 대상이 %s 인데 지금은 %s — 다시 켬"):format(
tostring(_a623), tostring(_a624)))
if _a574.R_FarmOff then pcall(function() _a574.R_FarmOff:InvokeServer() end) end
if _a574.AutoFarm and rawget(_a574.AutoFarm, "ForceDisable") then
pcall(_a574.AutoFarm.ForceDisable)
end
task.wait(0.3)
_a622 = false
end
end
if _a622 then return end
local _a625, _a626
pcall(function() _a625, _a626 = _a574.R_Farm:InvokeServer() end)
if _a625 then
_a571.farm += 1
_a576.auto.farmSaid = nil
_a563("[파밍] 자동 파밍 ON  (대상 " .. tostring(_a618() or _a576.move.curZone()) .. ")")
elseif _a626 and _a576.auto.farmSaid ~= tostring(_a626) then
_a576.auto.farmSaid = tostring(_a626)
_a563("[파밍] 실패: " .. tostring(_a626))
end
end
local function _a627()
if not (_a574.Zone and rawget(_a574.Zone, "GetNextZone")) then return nil end
local _a628, _a629, _a630 = pcall(_a574.Zone.GetNextZone)
if not _a628 then return nil end
return _a630 or _a629
end
local function _a631(_a632)
if not (_a574.Bal and rawget(_a574.Bal, "CalcGatePrice")) then return nil end
local _a633, _a634 = pcall(_a574.Bal.CalcGatePrice, _a632)
return (_a633 and tonumber(_a634)) or nil
end
local function _a635()
local _a636 = _a627()
if not _a636 then return nil end
local _a637 = _a631(_a636)
local _a638 = rawget(_a636, "Currency")
return {
zone = _a636, id = rawget(_a636, "_id"), price = _a637, currency = _a638,
have = _a638 and _a611(_a638) or 0,
ok = (_a637 and _a638) and _a606(_a638, _a637) or false,
}
end
local function _a639()
if not _a574.R_Zone then _a563("[존] Zones_RequestPurchase 리모트 없음") return end
local _a640 = 0
while _a570.zone and not _a576.ctl.stopped() and _a640 < 20 do
_a640 += 1
local _a641 = _a635()
if not _a641 then
_a576.auto.zoneNote = "다음 존을 못 구함 (GetNextZone 실패 / 존 퀘스트 미완료?)"
if _a576.auto.zoneSaid ~= _a576.auto.zoneNote then
_a576.auto.zoneSaid = _a576.auto.zoneNote
_a563("[존] " .. _a576.auto.zoneNote)
end
return
end
if not _a641.ok then
_a576.auto.zoneNote = ("%s  %s %s / 보유 %s — 부족"):format(
tostring(_a641.id), _a564(_a641.price or 0, 0), tostring(_a641.currency), _a564(_a641.have, 0))
if _a576.auto.zoneSaid ~= _a576.auto.zoneNote then
_a576.auto.zoneSaid = _a576.auto.zoneNote
_a563("[존] " .. _a576.auto.zoneNote)
end
return
end
_a576.auto.zoneSaid = nil
local _a642, _a643
pcall(function() _a642, _a643 = _a574.R_Zone:InvokeServer(_a641.id) end)
task.wait(0.5)
if _a642 then
_a571.zone += 1
_a563(("  ▶ 존 해금  %s   (%s %s)"):format(
tostring(_a641.id), _a564(_a641.price or 0, 0), tostring(_a641.currency)))
else
if _a643 then _a563("[존] 실패: " .. tostring(_a643)) end
return
end
task.wait(_a569.ActionGap)
end
end
local function _a644()
local _a645 = _a576.egg.eggStands()
local _a646 = (_a569.MainEggId and _a569.MainEggId ~= "") and _a569.MainEggId or nil
if _a646 then
for _a647, _a648 in ipairs(_a645) do
if _a648.id == _a646 then return _a648.id, _a648.def, _a648.dist end
end
local _a649 = _a574.DirEggs and rawget(_a574.DirEggs, _a646)
if _a649 then return _a646, _a649, nil, (_a645[1] and _a645[1].dist) end
return nil
end
if not _a574.DirEggs then return nil end
local _a650, _a651, _a652 = nil, nil, -1
for _a653, _a654 in pairs(_a574.DirEggs) do
if type(_a654) == "table" and not rawget(_a654, "isCustomEgg") then
local _a655 = tonumber(rawget(_a654, "eggNumber"))
if _a655 and _a655 > _a652 and _a576.egg.eggUnlocked(_a655) then
_a650, _a651, _a652 = _a653, _a654, _a655
end
end
end
if not _a650 then return nil end
local _a656, _a657
for _a658, _a659 in ipairs(_a645) do
if not _a657 then _a657 = _a659.dist end
if _a659.id == _a650 then _a656 = _a659.dist break end
end
if _a656 and _a656 <= _a569.EggRange then
return _a650, _a651, _a656
end
return _a650, _a651, nil, _a656 or _a657
end
local function _a660(_a661)
if type(_a574.CalcEgg) == "function" then
local _a662, _a663 = pcall(_a574.CalcEgg, _a661)
if _a662 and tonumber(_a663) then return tonumber(_a663) end
if not _a662 and not _a576.egg.priceWarned then
_a576.egg.priceWarned = true
_a563("[부화] CalcEggPricePlayer 막힘 → 기본가로 계산: " .. tostring(_a663))
end
end
if type(_a574.CalcEggB) == "function" then
local _a664, _a665 = pcall(_a574.CalcEggB, _a661)
if _a664 and tonumber(_a665) then return tonumber(_a665) end
end
for _a666, _a667 in ipairs({ "price", "Price", "cost", "Cost" }) do
local _a668 = tonumber(rawget(_a661, _a667))
if _a668 then return _a668 end
end
return nil
end
local function _a669()
local _a670, _a671, _a672, _a673 = _a644()
if not _a670 then return nil end
local _a674 = _a660(_a671)
local _a675 = rawget(_a671, "currency") or "Coins"
local _a676 = 1
if _a574.Egg and rawget(_a574.Egg, "GetMaxHatch") then
local _a677, _a678 = pcall(_a574.Egg.GetMaxHatch, _a671)
if _a677 and tonumber(_a678) then _a676 = math.max(1, math.floor(tonumber(_a678))) end
end
local _a679 = _a611(_a675)
return {
id = _a670, def = _a671, price = _a674, currency = _a675, maxN = _a676, have = _a679,
dist = _a672, nearest = _a673, inRange = _a672 ~= nil,
canBuy = (_a674 and _a674 > 0) and math.floor(math.max(0, _a679 - _a569.MainHatchReserve) / _a674) or 0,
}
end
local function _a680()
if not _a568.R_EGG then _a563("[부화] Eggs_RequestPurchase 리모트 없음") return end
if _a569.AutoUnlockEgg then
local _a681, _a682, _a683 = _a576.egg.lockedEggs()
if _a682 > _a683 then
local _a684 = _a576.egg.unlockEggs()
if _a684 > 0 then _a563(("[부화] 알 %d개 해금 (해금가능 #%d)"):format(_a684, _a682)) end
end
end
local _a685 = _a669()
if not _a685 then _a563("[부화] 알을 못 찾음") return end
if not _a685.inRange then
if _a569.HatchAutoTp then
local _a686, _a687 = _a576.egg.tpEgg(_a685.id)
if not _a686 then
if not _a576.egg.hatchWarned then
_a576.egg.hatchWarned = true
_a563("[부화] 알로 이동 실패: " .. tostring(_a687))
end
return
end
_a563("[부화] " .. _a685.id .. " 로 이동")
_a685 = _a669()
if not (_a685 and _a685.inRange) then return end
else
if not _a576.egg.hatchWarned then
_a576.egg.hatchWarned = true
_a563(("[부화] 알 근처로 가주세요 (가장 가까운 알까지 %s스터드, 인식 %d)"):format(
_a685.nearest and ("%.0f"):format(_a685.nearest) or "?", _a569.EggRange))
end
return
end
end
_a576.egg.hatchWarned = false
local _a688 = math.min(_a685.maxN, _a569.MainHatchMax)
local _a689 = _a685.price and math.min(_a685.canBuy, _a688) or _a688
if _a689 < 1 then return end
local _a690, _a691 = 0, 0
local function _a692()
return tonumber(_a574.Vars and rawget(_a574.Vars, "OpeningEgg")) or 0
end
local _a693 = _a574.Vars and rawget(_a574.Vars, "OpeningEgg") ~= nil
local _a694 = 2.5
if _a574.Egg and rawget(_a574.Egg, "ComputeDebounce") then
local _a695, _a696 = pcall(_a574.Egg.ComputeDebounce)
if _a695 and tonumber(_a696) then _a694 = tonumber(_a696) end
end
_a576.egg.autoHatchOn(_a685.id, _a689)
local _a697 = false
local _a698 = _a576.ctl.lockGoal and _a576.ctl.lockGoal.q
local _a699 = _a698 and (_a698.how == "hatch" or _a698.where == "bestegg") or false
local _a700 = _a699 and math.huge
or (os.clock() + math.max(3, _a569.HatchBudget or 25))
local _a701 = _a699 and 100000 or 400
while _a570.mhatch and not _a576.ctl.stopped() and _a689 >= 1 and _a691 < _a701 and os.clock() < _a700 do
if _a699 and (_a691 % 5 == 0) then
local _a702 = _a576.quest.findQuest(_a698.uid)
if not _a702 or _a702.progress >= _a702.amount then break end
end
_a691 += 1
if _a693 then
local _a703 = os.clock()
local _a704 = _a569.HatchClickAfter
local _a705 = false
while _a692() > 0 and _a570.mhatch and not _a576.ctl.stopped()
and (os.clock() - _a703) < 20 do
if _a569.HatchClick and (os.clock() - _a703) > _a704 then
_a576.egg.clickOnce()
_a704 += 0.3
if (os.clock() - _a703) > 3 and not _a705 then
_a705 = true
_a576.egg._ahEgg = nil
_a576.egg.autoHatchOn(_a685.id, _a689)
_a563("[부화] 화면이 안 넘어가서 오토해치 재설정")
end
end
task.wait(0.03)
end
if _a692() > 0 then
if _a576.egg.hatchStuck ~= _a685.id then
_a576.egg.hatchStuck = _a685.id
_a563("[부화] " .. tostring(_a685.id) .. " 까는 화면에서 멈춤 — 이번 회차 중단")
end
_a697 = true
break
end
_a576.egg.hatchStuck = nil
else
local _a706 = os.clock() - (_a576.egg.lastHatch or 0)
if _a706 < _a694 then task.wait(_a694 - _a706) end
end
_a576.egg.lastHatch = os.clock()
_a576.ctl.setAct("알 까는 중", ("%s x%d  (총 %d)"):format(_a685.id, _a689, _a690))
local _a707, _a708
local _a709 = pcall(function() _a707, _a708 = _a568.R_EGG:InvokeServer(_a685.id, _a689) end)
if _a707 then
_a690 += _a689
_a571.mhatch += _a689
_a576.egg.hatchErr = nil
if _a685.price then
local _a710 = _a611(_a685.currency)
local _a711 = math.floor(math.max(0, _a710 - _a569.MainHatchReserve) / _a685.price)
if _a711 < 1 then break end
_a689 = math.min(_a711, _a688)
end
else
local _a712 = _a709 and tostring(_a708) or "호출 자체 실패"
if _a712:find("quickly") or _a712:find("fast") then
task.wait(0.25)
elseif _a712:find("far away") then
if _a569.HatchAutoTp then _a576.egg.tpEgg(_a685.id) task.wait(0.2)
else _a563("[부화] 알에서 너무 멈") break end
elseif _a689 > 1 then
_a689 = math.floor(_a689 / 2)
else
if _a576.egg.hatchErr ~= _a712 then
_a576.egg.hatchErr = _a712
_a563("[부화] 실패: " .. _a712 .. "   (알 " .. tostring(_a685.id)
.. " / 개수 " .. _a689 .. " / 거리 "
.. (_a685.dist and ("%.0f"):format(_a685.dist) or "?") .. ")")
end
break
end
end
end
if _a693 and _a690 > 0 and not _a697 then
local _a713 = os.clock()
while _a692() == 0 and not _a576.ctl.stopped() and (os.clock() - _a713) < 2.5 do
task.wait(0.05)
end
local _a714 = os.clock()
local _a715 = _a569.HatchClickAfter
while _a692() > 0 and not _a576.ctl.stopped() and (os.clock() - _a714) < 20 do
_a576.ctl.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a685.id, _a689))
if _a569.HatchClick and (os.clock() - _a714) > _a715 then
_a576.egg.clickOnce()
_a715 += 0.3
if (os.clock() - _a714) > 3 and not _a576.egg._finRe then
_a576.egg._finRe = true
_a576.egg._ahEgg = nil
_a576.egg.autoHatchOn(_a685.id, _a689)
end
end
task.wait(0.03)
end
_a576.egg._finRe = nil
if _a692() > 0 then
_a563("[부화] 마지막 알이 20초 넘게 안 끝남 — 그대로 두고 진행합니다")
end
end
_a576.egg.autoHatchOff()
if _a690 > 0 then
_a576.egg.hatchErr = nil
_a563(("[부화] %s × %d%s  (개당 %s %s)"):format(
_a685.id, _a690, _a699 and " (목표까지)" or "",
_a685.price and _a564(_a685.price, 0) or "?", tostring(_a685.currency)))
end
end
local function _a716()
local _a717 = _a603()
if not _a717 then return nil end
local _a718 = tonumber(rawget(_a717, "Rank")) or 1
local _a719 = tonumber(rawget(_a717, "RankStars")) or 0
local _a720 = rawget(_a717, "RedeemedRankRewards") or {}
local _a721
if _a574.RanksU and rawget(_a574.RanksU, "RankIDFromNumber") then
local _a722, _a723 = pcall(_a574.RanksU.RankIDFromNumber, _a718)
if _a722 then _a721 = _a723 end
end
local _a724 = _a721 and _a574.DirRanks and rawget(_a574.DirRanks, _a721)
if type(_a724) ~= "table" then
return { rankNum = _a718, stars = _a719, rankId = _a721, rewards = {} }
end
local _a725, _a726 = {}, 0
for _a727, _a728 in ipairs(rawget(_a724, "Rewards") or {}) do
_a726 += (tonumber(rawget(_a728, "StarsRequired")) or 0)
local _a729 = _a726 <= _a719
local _a730 = _a720[tostring(_a727)] ~= nil
_a725[#_a725 + 1] = {
index = _a727, need = _a726, earned = _a729, redeemed = _a730,
claimable = _a729 and not _a730,
}
end
return { rankNum = _a718, stars = _a719, rankId = _a721, rewards = _a725 }
end
local function _a731()
if not _a574.R_Rank then _a563("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a732 = _a716()
if not _a732 then return end
local _a733 = 0
for _a734, _a735 in ipairs(_a732.rewards) do
if not _a570.rank then break end
if _a735.claimable then
pcall(function() _a574.R_Rank:FireServer(_a735.index) end)
_a733 += 1
_a571.rank += 1
task.wait(0.1)
end
end
if _a733 > 0 then
_a563(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a733, _a732.rankNum, _a732.stars))
end
end
function _a576.move.hrp()
local _a736 = _a562.Character
return _a736 and _a736:FindFirstChild("HumanoidRootPart"),
_a736 and _a736:FindFirstChildOfClass("Humanoid")
end
function _a576.egg.autoHatchOn(_a737, _a738)
if not _a569.UseAutoHatch then return end
if _a576.egg._ahEgg == _a737 and _a576.egg._ahAt and (os.clock() - _a576.egg._ahAt) < 15 then return end
_a576.egg._ahEgg, _a576.egg._ahAt = _a737, os.clock()
local _a739 = _a574.DirEggs and rawget(_a574.DirEggs, _a737)
if _a574.Hatch and _a739 and rawget(_a574.Hatch, "SetupEgg") then
local _a740, _a741 = pcall(_a574.Hatch.SetupEgg, _a739, _a738 or 1)
if not _a740 and not _a576.egg._ahWarn then
_a576.egg._ahWarn = true
_a563("[부화] SetupEgg 실패: " .. tostring(_a741) .. "  → 클릭 대체 사용")
end
end
if _a574.R_AHTog then pcall(function() _a574.R_AHTog:FireServer(true) end) end
if _a574.R_AHOn then pcall(function() _a574.R_AHOn:FireServer(_a737, _a738 or 1) end) end
if _a574.Hatch and rawget(_a574.Hatch, "IsHatching") then
local _a742, _a743 = pcall(_a574.Hatch.IsHatching)
_a576.egg._ahLive = _a742 and _a743 and true or false
end
end
function _a576.egg.autoHatchOff()
_a576.egg._ahEgg, _a576.egg._ahAt, _a576.egg._ahLive = nil, nil, nil
if _a574.Hatch and rawget(_a574.Hatch, "StopHatching") then pcall(_a574.Hatch.StopHatching) end
if _a574.R_AHOff then pcall(function() _a574.R_AHOff:FireServer() end) end
end
function _a576.egg.clickOnce()
if _a576.ctl.moving then return false end
local _a744 = _a576.screen.signal("egg")
if not _a744 then _a744 = _a576.screen.pressInGame({ "Egg Opening" }) end
if not _a744 and not _a576.egg._eggSigWarn then
_a576.egg._eggSigWarn = true
_a563("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a744
end
function _a576.egg.watchStuck()
local _a745 = _a574.Vars
if not _a745 then return end
local _a746 = tonumber(rawget(_a745, "OpeningEgg")) or 0
if _a746 <= 0 then
_a576.egg.stuckSince, _a576.egg.stuckSaid = nil, nil
return
end
_a576.egg.stuckSince = _a576.egg.stuckSince or os.clock()
local _a747 = os.clock() - _a576.egg.stuckSince
if _a747 < 3 then return end
if not _a569.HatchClick then return end
if _a576.ctl.moving then _a576.screen.signal("egg") else _a576.egg.clickOnce() end
if _a747 > 6 and not _a576.egg.stuckSaid then
_a576.egg.stuckSaid = true
_a563("[부화] 까는 화면에서 멈춰 있어 계속 넘기는 중")
end
end
function _a576.item.applyPetSpeed()
local _a748 = _a574.PlayerPet
if not (_a748 and rawget(_a748, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a749, _a750 = pcall(_a748.GetByPlayer, _a562)
if not (_a749 and type(_a750) == "table") then return 0, "펫 목록 못 읽음" end
local _a751 = math.max(1, tonumber(_a569.PetSpeedMult) or 50)
local _a752 = math.max(0.05, tonumber(_a569.PetSpeedBase) or 4)
local _a753 = 0
for _a754, _a755 in pairs(_a750) do
if type(_a755) == "table" then
local _a756 = rawget(_a755, "cpet")
if _a756 then
_a755.speedMult = _a751
pcall(function() _a756:Broadcast("petSpeedMult", _a751) end)
pcall(function() _a756:Broadcast("petSpeed", _a752) end)
_a753 += 1
end
end
end
return _a753
end
_a576.screen.SIGNAL = {
reward  = { pats = { "Rebirth", "Rank Up" }, sigs = {
{ np = 2, t = "table,boolean,boolean,number,table,boolean",
set = { {4,0}, {2,true}, {3,true}, {6,true} } },
{ np = 0, t = "boolean,boolean,number,table,boolean",
set = { {3,0}, {1,true}, {2,true}, {5,true} } },
} },
egg     = { pats = { "Egg Opening" },            minBools = 1 },
mastery = { pats = { "Mastery Perk" },           minBools = 1 },
card    = { pats = { "Card Flashing", "Card" },  minBools = 1 },
}
_a576.screen.BLOCKERS = {
{ "Rebirth",     "리버스",   "reward" },
{ "RankUp",      "랭크업",   "reward" },
{ "MasteryPerk", "마스터리", "mastery" },
{ "Card",        "카드",     "card" },
}
function _a576.screen.findSignalFns(_a757)
local _a758 = _a576.screen.SIGNAL[_a757]
if not _a758 then return {} end
_a576.screen._sig = _a576.screen._sig or {}
local _a759 = _a576.screen._sig[_a757]
if _a759 and (os.clock() - _a759.at) < (#_a759.fns > 0 and 20 or 3) then return _a759.fns end
local _a760 = {}
_a576.screen._sig[_a757] = { at = os.clock(), fns = _a760 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a760
end
local _a761 = {}
for _a762, _a763 in ipairs({ true, false }) do
local _a764, _a765 = pcall(getgc, _a763)
if _a764 and type(_a765) == "table" then
for _a766, _a767 in ipairs(_a765) do _a761[#_a761 + 1] = _a767 end
end
end
if #_a761 == 0 then return _a760 end
for _a768, _a769 in ipairs(_a761) do
if type(_a769) == "function" then
local _a770, _a771 = pcall(debug.info, _a769, "s")
if _a770 and type(_a771) == "string" then
local _a772 = false
for _a773, _a774 in ipairs(_a758.pats) do
if _a771:find(_a774, 1, true) then _a772 = true break end
end
if _a772 then
local _a775, _a776 = pcall(debug.info, _a769, "a")
if _a775 then
local _a777, _a778 = {}, 0
for _a779 = 1, 16 do
local _a780, _a781 = pcall(debug.getupvalue, _a769, _a779)
if not _a780 then break end
_a778 = _a779
_a777[_a779] = type(_a781)
end
local _a782 = table.concat(_a777, ",")
local _a783 = false
for _a784, _a785 in ipairs(_a758.sigs or {}) do
if _a776 == _a785.np and _a782 == _a785.t then
_a760[#_a760 + 1] = { fn = _a769, sig = _a782, n = _a778, np = _a776,
src = _a771, set = _a785.set }
_a783 = true
break
end
end
if not _a783 and _a758.sigs then
local _a786 = {}
for _a787, _a788 in ipairs(_a777) do
if _a788 == "boolean" then _a786[#_a786 + 1] = _a787 end
end
if #_a786 > 0 then
_a760[#_a760 + 1] = { fn = _a769, idx = _a786, sig = _a782, n = _a778,
np = _a776, src = _a771, loose = true }
end
end
if not _a783 and not _a758.sigs and _a776 == 0 then
local _a789 = 0
for _a790, _a791 in ipairs(_a777) do if _a791 == "boolean" then _a789 += 1 end end
if _a789 >= (_a758.minBools or 1) then
local _a792 = {}
for _a793, _a794 in ipairs(_a777) do
if _a794 == "boolean" then _a792[#_a792 + 1] = _a793 end
end
_a760[#_a760 + 1] = { fn = _a769, idx = _a792, sig = _a782, n = _a778, src = _a771 }
end
end
end
end
end
end
end
return _a760
end
function _a576.screen.signal(_a795)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a796 = _a576.screen.findSignalFns(_a795)
local _a797 = 0
for _a798, _a799 in ipairs(_a796) do
if _a799.set then
for _a800, _a801 in ipairs(_a799.set) do
if pcall(debug.setupvalue, _a799.fn, _a801[1], _a801[2]) then _a797 += 1 end
end
elseif not _a799.loose then
for _a802, _a803 in ipairs(_a799.idx or {}) do
if pcall(debug.setupvalue, _a799.fn, _a803, true) then _a797 += 1 end
end
end
end
if _a797 == 0 then
for _a804, _a805 in ipairs(_a796) do
if _a805.loose then
for _a806, _a807 in ipairs(_a805.idx or {}) do
if pcall(debug.setupvalue, _a805.fn, _a807, true) then _a797 += 1 end
end
end
end
end
return _a797 > 0, _a797
end
function _a576.screen.pressInGame(_a808)
local _a809, _a810 = pcall(function() return game:GetService("UserInputService") end)
if not (_a809 and _a810) then return false end
local _a811 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a812 = 0
if type(getconnections) == "function" then
local _a813, _a814 = pcall(getconnections, _a810.InputBegan)
if _a813 and type(_a814) == "table" then
for _a815, _a816 in ipairs(_a814) do
local _a817 = ""
local _a818 = _a816.Function
if _a818 and type(debug) == "table" and type(debug.info) == "function" then
local _a819, _a820 = pcall(debug.info, _a818, "s")
if _a819 and _a820 then _a817 = tostring(_a820) end
end
local _a821 = false
for _a822, _a823 in ipairs(_a808) do
if _a817 ~= "" and _a817:find(_a823, 1, true) then _a821 = true break end
end
if _a821 then
if _a818 and pcall(_a818, _a811, false) then _a812 += 1
elseif _a816.Fire and pcall(function() _a816:Fire(_a811, false) end) then _a812 += 1
elseif _a816.Defer and pcall(function() _a816:Defer(_a811, false) end) then _a812 += 1 end
end
end
end
end
if _a812 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a810.InputBegan, _a811, false) then _a812 += 1 end
end
return _a812 > 0
end
function _a576.screen.realClick(_a824)
if not _a569.ScreenRealClick then return false end
local _a825 = workspace.CurrentCamera
local _a826 = (_a825 and _a825.ViewportSize) or Vector2.new(1280, 720)
local _a827, _a828 = _a826.X * 0.5, _a826.Y * 0.45
local _a829 = {}
local function _a830(_a831, _a832)
local _a833 = pcall(_a832)
_a829[#_a829 + 1] = _a831 .. (_a833 and "=OK" or "=X")
return _a833
end
local _a834 = false
if not _a834 and type(mouse1click) == "function" then
_a834 = _a830("mouse1click", function() mouse1click() end)
end
if not _a834 and type(mouse1press) == "function" then
_a834 = _a830("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a834 then
_a834 = _a830("VirtualUser", function()
local _a835 = game:GetService("VirtualUser")
_a835:Button1Down(Vector2.new(_a827, _a828), _a825 and _a825.CFrame or CFrame.new())
task.wait(0.05)
_a835:Button1Up(Vector2.new(_a827, _a828), _a825 and _a825.CFrame or CFrame.new())
end)
end
if not _a834 then
_a834 = _a830("VirtualInputManager", function()
local _a836 = game:GetService("VirtualInputManager")
_a836:SendMouseButtonEvent(_a827, _a828, 0, true, game, 1)
task.wait(0.05)
_a836:SendMouseButtonEvent(_a827, _a828, 0, false, game, 1)
end)
end
if _a824 then _a563("    " .. table.concat(_a829, " / ")) end
return _a834
end
function _a576.screen.rewardScreenUp()
if not _a562 then
if not _a576.screen.noLP then
_a576.screen.noLP = true
_a563("[화면] LocalPlayer 를 못 잡았습니다 — 화면 감시를 건너뜁니다")
end
return false
end
local _a837 = _a562:FindFirstChildOfClass("PlayerGui")
if _a837 then
for _a838, _a839 in ipairs(_a576.screen.BLOCKERS) do
local _a840 = _a837:FindFirstChild(_a839[1])
if _a840 and _a840:IsA("ScreenGui") and _a840.Enabled then return true, _a839[2], _a839[3] end
end
end
local _a841 = _a574.Vars
if _a841 then
if rawget(_a841, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a841, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a576.screen.dismissRewardScreens(_a842)
if _a576.screen.dismissBusy then return end
_a576.screen.dismissBusy = true
local _a843, _a844 = pcall(_a576.screen.dismissInner, _a842)
_a576.screen.dismissBusy = false
if not _a843 then _a563("[화면] 오류: " .. tostring(_a844)) end
end
function _a576.screen.dismissInner(_a845)
local _a846 = _a574.Vars
if not _a846 then return end
local _a847 = os.clock()
local _a848, _a849 = false, nil
local _a850 = 0
local _a851 = math.max(3, _a569.ScreenTryMax or 8)
while os.clock() - _a847 < (_a845 or 120) do
local _a852, _a853, _a854 = _a576.screen.rewardScreenUp()
if not _a852 then break end
_a848, _a849 = true, _a853
_a850 += 1
_a576.ctl.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a853), _a850,
_a850 <= 6 and " · 첫 화면 대기" or ""))
local _a855 = _a576.screen.SIGNAL[_a854 or "reward"]
local _a856 = (_a855 and _a855.pats) or { "Rebirth", "Rank Up" }
local _a857 = _a576.screen.signal(_a854 or "reward")
if not _a857 then
for _a858 in pairs(_a576.screen.SIGNAL) do
if _a576.screen.signal(_a858) then _a857 = true end
end
end
local _a859 = false
if not _a857 or _a850 >= 2 then
_a859 = _a576.screen.pressInGame(_a856)
end
if _a850 >= 3 then
if _a576.screen.realClick() then
_a859 = true
if not _a576.screen._realSaid then
_a576.screen._realSaid = true
_a563("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a857 or _a859) and not _a576.screen._sigSaid then
_a576.screen._sigSaid = true
_a563("[화면] " .. (_a857 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a850 >= _a851 and (os.clock() - _a847) >= 12 then
if _a576.screen.giveUpSaid ~= _a853 then
_a576.screen.giveUpSaid = _a853
_a563(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a853)))
_a563("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a576.screen.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a848 then
if not _a576.screen.rewardScreenUp() then
_a576.screen.lastBlocker = nil
_a576.screen.screenGaveUp = nil
_a563(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a849), _a850))
end
end
end
function _a576.egg.eggUnlocked(_a860)
_a860 = tonumber(_a860)
if not _a860 then return false end
local _a861 = _a603()
local _a862 = _a861 and rawget(_a861, "UnlockedEggs")
if type(_a862) == "table" then
for _a863, _a864 in pairs(_a862) do
if tonumber(_a864) == _a860 then return true end
end
return false
end
return _a860 <= 1
end
function _a576.egg.lockedEggs()
local _a865 = {}
if not _a574.DirEggs then return _a865, 0, 0 end
local _a866 = _a603()
local _a867 = tonumber(_a866 and rawget(_a866, "MaximumAvailableEgg")) or 1
local _a868 = 0
local _a869 = _a866 and rawget(_a866, "UnlockedEggs")
if type(_a869) == "table" then
for _a870, _a871 in pairs(_a869) do
local _a872 = tonumber(_a871)
if _a872 and _a872 > _a868 then _a868 = _a872 end
end
end
for _a873, _a874 in pairs(_a574.DirEggs) do
if type(_a874) == "table" and not rawget(_a874, "isCustomEgg") then
local _a875 = tonumber(rawget(_a874, "eggNumber"))
if _a875 and _a875 <= _a867 and not _a576.egg.eggUnlocked(_a875) then
_a865[#_a865 + 1] = { id = _a873, num = _a875 }
end
end
end
table.sort(_a865, function(_a876, _a877) return _a876.num < _a877.num end)
return _a865, _a867, _a868
end
function _a576.egg.unlockEggs(_a878)
if not _a574.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a879 = _a576.egg.lockedEggs()
if #_a879 == 0 then return 0 end
local _a880, _a881 = 0, nil
for _a882, _a883 in ipairs(_a879) do
if not _a576.egg.eggUnlocked(_a883.num) then
local _a884, _a885
pcall(function() _a884, _a885 = _a574.R_EggUn:InvokeServer(_a883.id) end)
if not _a884 and _a569.HatchAutoTp then
local _a886 = _a576.egg.tpEgg(_a883.id)
if _a886 then
task.wait(0.3)
pcall(function() _a884, _a885 = _a574.R_EggUn:InvokeServer(_a883.id) end)
end
end
if _a884 then
_a880 += 1
_a576.ctl.setAct("알 해금", ("#%d %s"):format(_a883.num, _a883.id))
_a563(("  🔓 알 해금  #%d %s"):format(_a883.num, _a883.id))
task.wait(0.15)
else
_a881 = _a885
if _a878 then
_a563(("[해금] #%d %s 실패: %s"):format(_a883.num, _a883.id, tostring(_a885)))
end
end
end
end
return _a880, _a881
end
function _a576.move.curZone()
if _a574.Map and rawget(_a574.Map, "GetCurrentZone") then
local _a887, _a888 = pcall(_a574.Map.GetCurrentZone)
if _a887 then return _a888 end
end
return nil
end
function _a576.move.zone1()
if not _a574.DirZones then return nil end
local _a889, _a890 = nil, math.huge
for _a891, _a892 in pairs(_a574.DirZones) do
if type(_a892) == "table" and _a576.move.ownsZone(_a891) then
local _a893 = tonumber(rawget(_a892, "ZoneNumber")) or math.huge
if _a893 < _a890 then _a889, _a890 = _a891, _a893 end
end
end
return _a889
end
function _a576.move.realZone(_a894) return _a894 end
function _a576.move.resolvableZone(_a895)
if _a895 then
local _a896 = _a576.move.zonePos(_a895)
if _a896 then return _a895, _a896 end
end
if not _a574.DirZones then return nil end
local _a897 = {}
for _a898, _a899 in pairs(_a574.DirZones) do
if type(_a899) == "table" and _a576.move.ownsZone(_a898) then
_a897[#_a897 + 1] = { id = _a898, n = tonumber(rawget(_a899, "ZoneNumber")) or 0 }
end
end
table.sort(_a897, function(_a900, _a901) return _a900.n > _a901.n end)
for _a902, _a903 in ipairs(_a897) do
if _a903.id ~= _a895 then
local _a904 = _a576.move.zonePos(_a903.id)
if _a904 then
if _a576.move.fallZone ~= _a903.id then
_a576.move.fallZone = _a903.id
_a563(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a895), tostring(_a903.id)))
end
return _a903.id, _a904
end
end
end
return nil
end
function _a576.move.bestZone()
if _a574.Zone and rawget(_a574.Zone, "GetMaxOwnedZone") then
local _a905, _a906, _a907 = pcall(_a574.Zone.GetMaxOwnedZone)
if _a905 and _a906 then return _a906, _a907 end
end
return _a576.move.zone1()
end
function _a576.move.ownsZone(_a908)
local _a909 = _a603()
local _a910 = _a909 and rawget(_a909, "UnlockedZones")
return (type(_a910) == "table" and _a910[_a908] ~= nil) or false
end
function _a576.move.zoneByNumber(_a911)
if not (_a574.DirZones and _a911) then return nil end
for _a912, _a913 in pairs(_a574.DirZones) do
if type(_a913) == "table" and tonumber(rawget(_a913, "ZoneNumber")) == tonumber(_a911) then
return _a912, _a913
end
end
return nil
end
local function _a914(_a915, _a916)
local _a917 = rawget(_a915, "Breakables")
local _a918 = type(_a917) == "table" and rawget(_a917, "Main") or nil
local _a919 = type(_a918) == "table" and rawget(_a918, "Data") or nil
if type(_a919) ~= "table" then return false end
for _a920, _a921 in pairs(_a919) do
local _a922 = type(_a921) == "table" and rawget(_a921, "Type") or nil
if _a922 and tostring(_a922):lower():find(_a916, 1, true) then return true end
end
return false
end
function _a576.move.zoneForBreakable(_a923)
if not (_a574.DirZones and _a923) then return nil end
local _a924 = tostring(_a923):lower()
local _a925 = _a576.move.bestZone()
if _a925 then
local _a926 = rawget(_a574.DirZones, _a925)
if type(_a926) == "table" and _a914(_a926, _a924) then return _a925 end
end
local _a927, _a928 = nil, -1
for _a929, _a930 in pairs(_a574.DirZones) do
if type(_a930) == "table" and _a929 ~= "Spawn" and _a576.move.ownsZone(_a929) then
local _a931 = rawget(_a930, "Breakables")
local _a932 = type(_a931) == "table" and rawget(_a931, "Main") or nil
local _a933 = type(_a932) == "table" and rawget(_a932, "Data") or nil
if type(_a933) == "table" then
for _a934, _a935 in pairs(_a933) do
local _a936 = type(_a935) == "table" and rawget(_a935, "Type") or nil
if _a936 and tostring(_a936):lower():find(_a924, 1, true) then
local _a937 = tonumber(rawget(_a930, "ZoneNumber")) or 0
if _a937 > _a928 then _a927, _a928 = _a929, _a937 end
break
end
end
end
end
end
return _a927
end
function _a576.move.tpZone(_a938)
if not _a938 then return false, "존 id 없음" end
if _a576.move.curZone() == _a938 then return true end
if not _a569.TpGameFallback then
_a563("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a938) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a939 = _a574.R_Tp
if _a574.Inst and rawget(_a574.Inst, "IsInInstance") then
local _a940, _a941 = pcall(_a574.Inst.IsInInstance)
if _a940 and _a941 and _a574.R_TpI then _a939 = _a574.R_TpI end
end
if not _a939 then return false, "텔레포트 리모트 없음" end
local _a942 = os.clock() - (_a576.move.lastTp or 0)
if _a942 < _a569.TpCooldown then task.wait(_a569.TpCooldown - _a942) end
_a576.move.lastTp = os.clock()
local _a943, _a944
pcall(function() _a943, _a944 = _a939:InvokeServer(_a938) end)
if not _a943 then return false, _a944 end
local _a945 = os.clock()
while os.clock() - _a945 < 5 do
if _a576.move.curZone() == _a938 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a576.move.glideTo(_a946)
if _a576.ctl.stopped() then return false, "정지됨" end
if _a576.ctl.moving and (os.clock() - _a576.ctl.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a576.ctl.moving = os.clock()
local _a947, _a948, _a949 = pcall(_a576.move.glideRaw, _a946)
_a576.ctl.moving = nil
if not _a947 then return false, tostring(_a948) end
return _a948, _a949
end
function _a576.move.glideRaw(_a950)
local _a951, _a952 = _a576.move.hrp()
if not _a951 then return false, "캐릭터 없음" end
if _a569.TpMode == "instant" then
local _a953 = _a950 + Vector3.new(0, 4, 0)
for _a954 = 1, 3 do
local _a955 = _a562.Character
local _a956, _a957 = _a576.move.hrp()
if not (_a955 and _a956) then return false, "캐릭터 없음" end
local _a958 = _a956.CFrame - _a956.CFrame.Position
pcall(function() _a955:PivotTo(CFrame.new(_a953) * _a958) end)
_a956.AssemblyLinearVelocity = Vector3.zero
for _a959 = 1, 6 do _a561.Heartbeat:Wait() end
if _a957 then
pcall(function()
_a957:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a957:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a956 = _a576.move.hrp()
if _a956 and (_a956.Position - _a953).Magnitude <= 30 then
local _a960 = os.clock()
while os.clock() - _a960 < 1.5 do
if _a576.move.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a954 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a569.TpMode == "walk" then
if not _a952 then return false, "Humanoid 없음" end
local _a961 = os.clock()
while os.clock() - _a961 < 45 do
local _a962 = _a951.Position
if (Vector3.new(_a962.X, 0, _a962.Z) - Vector3.new(_a950.X, 0, _a950.Z)).Magnitude < 8 then
return true
end
_a952:MoveTo(_a950)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a951.Position - _a950).Magnitude <= (_a569.ArriveDist or 12) then return true end
local _a963 = math.max(16, tonumber(_a569.TpSpeed) or 90)
local _a964 = math.max(0, tonumber(_a569.TpHeight) or 0)
local function _a965(_a966, _a967)
local _a968 = 0
while _a968 < 2000 do
if _a576.ctl.stopped() then return false end
_a968 += 1
local _a969 = _a576.move.hrp()
if not _a969 then return false end
local _a970 = _a969.Position
local _a971 = _a966 - _a970
local _a972 = _a971.Magnitude
if _a972 < 2.5 then return true end
local _a973 = _a561.Heartbeat:Wait()
local _a974 = math.min(_a972, _a963 * math.min(_a973, 0.1))
local _a975 = _a967 and (Vector3.new(_a966.X, _a970.Y, _a966.Z)) or nil
if _a975 and (_a975 - _a970).Magnitude > 1 then
_a969.CFrame = CFrame.lookAt(_a970 + _a971.Unit * _a974, _a975)
else
_a969.CFrame = CFrame.new(_a970 + _a971.Unit * _a974) * (_a969.CFrame - _a969.Position)
end
_a969.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a964 > 0 then
local _a976 = _a951.Position
local _a977 = math.max(_a976.Y, _a950.Y) + _a964
_a965(Vector3.new(_a976.X, _a977, _a976.Z), false)
_a965(Vector3.new(_a950.X, _a977, _a950.Z), true)
end
_a965(_a950 + Vector3.new(0, 3, 0), true)
local _a978 = _a576.move.hrp()
if _a978 then _a978.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a979(_a980)
local _a981 = #_a980
if _a981 == 0 then return nil, 0 end
local _a982, _a983 = math.huge, -math.huge
local _a984, _a985 = math.huge, -math.huge
local _a986 = 0
for _a987, _a988 in ipairs(_a980) do
if _a988.X < _a982 then _a982 = _a988.X end
if _a988.X > _a983 then _a983 = _a988.X end
if _a988.Z < _a984 then _a984 = _a988.Z end
if _a988.Z > _a985 then _a985 = _a988.Z end
_a986 += _a988.Y
end
return Vector3.new((_a982 + _a983) / 2, _a986 / _a981, (_a984 + _a985) / 2), _a981
end
function _a576.move.breakCenter(_a989)
local _a990 = _a576.move.hrp()
if not _a990 then return nil, 0 end
local _a991 = workspace:FindFirstChild("__THINGS")
if not _a991 then return nil, 0 end
local _a992 = _a990.Position
local _a993 = {}
for _a994, _a995 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a996 = _a991:FindFirstChild(_a995)
if _a996 then
for _a997, _a998 in ipairs(_a996:GetChildren()) do
local _a999
if _a998:IsA("BasePart") then _a999 = _a998.Position
elseif _a998:IsA("Model") then
local _a1000, _a1001 = pcall(function() return _a998:GetPivot() end)
if _a1000 and typeof(_a1001) == "CFrame" then _a999 = _a1001.Position end
end
if _a999 and (_a999 - _a992).Magnitude <= (_a989 or 400) then
_a993[#_a993 + 1] = _a999
end
end
end
end
return _a979(_a993)
end
function _a576.move.groundY(_a1002, _a1003, _a1004)
_a1004 = tonumber(_a1004) or 0
local _a1005 = RaycastParams.new()
_a1005.FilterType = Enum.RaycastFilterType.Exclude
local _a1006 = {}
if _a562.Character then _a1006[#_a1006 + 1] = _a562.Character end
local _a1007 = workspace:FindFirstChild("__THINGS")
if _a1007 then _a1006[#_a1006 + 1] = _a1007 end
_a1005.FilterDescendantsInstances = _a1006
local _a1008 = Vector3.new(_a1002, _a1004 + 12, _a1003)
local _a1009, _a1010 = pcall(function()
return workspace:Raycast(_a1008, Vector3.new(0, -160, 0), _a1005)
end)
if _a1009 and _a1010 then
local _a1011 = _a1010.Position.Y
if math.abs(_a1011 - _a1004) <= 80 then return _a1011 + 4 end
end
return nil
end
function _a576.move.zonePos(_a1012, _a1013)
if not _a1012 then return nil, "존 id 없음" end
_a1012 = _a576.move.realZone(_a1012)
local _a1014 = _a574.DirZones and rawget(_a574.DirZones, _a1012)
local _a1015 = _a1014 and rawget(_a1014, "ZoneFolder")
local _a1016 = {}
do
local _a1017 = workspace:FindFirstChild("__THINGS")
for _a1018, _a1019 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1020 = _a1017 and _a1017:FindFirstChild(_a1019)
if _a1020 then
for _a1021, _a1022 in ipairs(_a1020:GetChildren()) do
local _a1023
if _a1022:IsA("BasePart") then _a1023 = _a1022.Position
elseif _a1022:IsA("Model") then
local _a1024, _a1025 = pcall(function() return _a1022:GetPivot() end)
if _a1024 and typeof(_a1025) == "CFrame" then _a1023 = _a1025.Position end
end
if _a1023 then _a1016[#_a1016 + 1] = _a1023 end
end
end
end
end
local _a1026 = {}
local function _a1027(_a1028, _a1029)
if not _a1028 then return end
local _a1030, _a1031 = pcall(function() return _a1028:GetDescendants() end)
if _a1028:IsA("BasePart") then _a1026[#_a1026 + 1] = { p = _a1028.Position, why = _a1029 } end
if _a1030 then
for _a1032, _a1033 in ipairs(_a1031) do
if _a1033:IsA("BasePart") then
_a1026[#_a1026 + 1] = { p = _a1033.Position, why = _a1029 .. "/" .. _a1033.Name }
end
end
end
end
if _a574.ZonesU then
for _a1034, _a1035 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a1036 = rawget(_a574.ZonesU, _a1035)
if type(_a1036) == "function" then
local _a1037, _a1038 = pcall(_a1036, _a1012)
if _a1037 and _a1038 then _a1027(_a1038, _a1035) end
end
end
end
if _a1015 then
for _a1039, _a1040 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a1041, _a1042 = pcall(function() return _a1015:FindFirstChild(_a1040, true) end)
if _a1041 and _a1042 then _a1027(_a1042, "ZoneFolder/" .. _a1040) end
end
end
local _a1043, _a1044, _a1045
for _a1046, _a1047 in ipairs(_a1026) do
local _a1048 = 0
for _a1049, _a1050 in ipairs(_a1016) do
if (_a1050 - _a1047.p).Magnitude <= 150 then _a1048 += 1 end
end
if not _a1044 or _a1048 > _a1044 then _a1043, _a1044, _a1045 = _a1047.p, _a1048, _a1047.why end
end
local _a1051, _a1052
if _a1043 and (_a1044 or 0) >= 1 then
_a1051, _a1052 = _a1043, ("%s (브레이커블 %d개)"):format(tostring(_a1045), _a1044)
end
if not _a1051 and _a1043 then
_a1051, _a1052 = _a1043, tostring(_a1045) .. " (브레이커블 없음)"
end
if not _a1051 and _a574.ZonesU and rawget(_a574.ZonesU, "GetTeleportPartLocation") then
local _a1053, _a1054 = pcall(_a574.ZonesU.GetTeleportPartLocation, _a1012)
if _a1053 and typeof(_a1054) == "CFrame" then
_a1051, _a1052 = _a1054.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a1051 then return nil, "브레이커블 위치를 못 찾음" end
local _a1055 = _a576.move.groundY(_a1051.X, _a1051.Z, _a1051.Y)
if _a1055 then
_a1051 = Vector3.new(_a1051.X, _a1055, _a1051.Z)
_a1052 = _a1052 .. " +지면"
else
_a1051 = Vector3.new(_a1051.X, _a1051.Y + 5, _a1051.Z)
end
return _a1051, _a1052
end
function _a576.move.goToZone(_a1056, _a1057, _a1058, _a1059)
_a1056 = _a576.move.realZone(_a1056)
if not _a1056 then return false, "존 id 없음" end
local _a1060, _a1061 = _a576.move.zonePos(_a1056)
if not _a1060 then
if _a569.TpGameFallback and _a576.move.curZone() ~= _a1056 then
local _a1062, _a1063 = _a576.move.tpZone(_a1056)
if not _a1062 then return false, _a1063 end
task.wait(0.3)
_a1060, _a1061 = _a576.move.zonePos(_a1056)
end
if not _a1060 then
local _a1064, _a1065 = _a576.move.resolvableZone(_a1056)
if _a1064 and _a1065 then
if _a1059 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a1056))
end
_a1056, _a1060, _a1061 = _a1064, _a1065, "대체 존 " .. tostring(_a1064)
else
if _a576.move.zoneFailSaid ~= _a1056 then
_a576.move.zoneFailSaid = _a1056
_a563(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a1056), tostring(_a1061)))
end
return false, _a1061
end
end
end
local _a1066 = _a576.move.hrp()
if not _a1058 and _a1066 and _a576.move.curZone() == _a1056 then
local _a1067 = _a576.move.inDottedBox()
local _a1068
if _a1067 ~= nil then
_a1068 = _a1067
else
_a1068 = (_a1066.Position - _a1060).Magnitude <= (_a569.ZoneArriveDist or 90)
end
if _a1068 then
if _a1057 then _a563("[TP] 이미 " .. _a1056 .. " 사냥터 안에 있음") end
return true
end
end
if _a1057 then
_a563(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a1056, tostring(_a1061), _a1060.X, _a1060.Y, _a1060.Z))
end
local _a1069, _a1070 = _a576.move.glideTo(_a1060)
local _a1071 = _a576.move.hrp()
if _a1071 and (_a1071.Position - _a1060).Magnitude > math.max(40, _a569.ArriveDist or 12) then
task.wait(0.2)
_a576.ctl.moving = nil
_a576.move.glideTo(_a1060)
local _a1072 = _a576.move.hrp()
local _a1073 = _a1072 and (_a1072.Position - _a1060).Magnitude or -1
if _a1073 > math.max(40, _a569.ArriveDist or 12) then
local _a1074 = _a569.TpMode
_a569.TpMode = "glide"
_a576.ctl.moving = nil
_a576.move.glideTo(_a1060)
_a569.TpMode = _a1074
local _a1075 = _a576.move.hrp()
_a1073 = _a1075 and (_a1075.Position - _a1060).Magnitude or -1
if _a1073 > math.max(40, _a569.ArriveDist or 12) then
_a563(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a1056), _a1073))
return false, "이동이 되돌려짐"
end
_a563("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a1056))
end
end
do
local _a1076 = _a576.move.hrp()
if _a1076 and (_a1076.Position.Y - _a1060.Y) > 25 then
_a563(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a1076.Position.Y - _a1060.Y))
_a576.ctl.moving = nil
_a576.move.glideTo(Vector3.new(_a1060.X, _a1060.Y, _a1060.Z))
end
end
if tostring(_a1061):find("스트리밍", 1, true) then
task.wait(1.2)
local _a1077, _a1078 = _a576.move.zonePos(_a1056)
if _a1077 and not tostring(_a1078):find("스트리밍", 1, true) then
if _a1057 then
_a563("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a1078) .. ")")
end
_a576.ctl.moving = nil
_a576.move.glideTo(_a1077)
_a1060, _a1061 = _a1077, _a1078
end
end
if _a576.move.inDottedBox() == false then
task.wait(0.2)
local _a1079, _a1080 = _a576.move.breakCenter(400)
if _a1079 and _a1080 >= 3 then
if _a1057 then
_a563(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a1080))
end
_a576.ctl.moving = nil
_a576.move.glideTo(_a1079)
_a1060 = _a1079
end
if _a576.move.inDottedBox() == false then
local _a1081 = _a576.move.zonePos(_a1056)
if _a1081 and (_a1081 - _a1060).Magnitude > 5 then
if _a1057 then _a563("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a576.ctl.moving = nil
_a576.move.glideTo(_a1081)
_a1060 = _a1081
end
end
if _a576.move.inDottedBox() == false and _a1057 then
_a563(("[TP] %s 네모 안으로 못 들어감 (좌표 %s)"):format(_a1056, tostring(_a1061)))
end
end
local function _a1082()
if _a576.move.inDottedBox() == true then return false end
local _a1083, _a1084 = _a576.move.breakCenter(400)
if (_a1084 or 0) >= 1 then return false end
task.wait(0.6)
if _a576.move.inDottedBox() == true then return false end
local _a1085, _a1086 = _a576.move.breakCenter(400)
return (_a1086 or 0) < 1
end
if _a1082() and (os.clock() - (_a576.move.lastRecover or -999)) > 30 then
_a576.move.lastRecover = os.clock()
_a563(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a1056), tostring(_a1061)))
end
_a576.move.zoneFailSaid = nil
_a576.move.arrivedZone = _a1056
do
local _a1087 = _a576.move.hrp()
local _a1088 = _a1087 and (_a1087.Position - _a1060).Magnitude or 0
if _a1088 > math.max(60, _a569.ArriveDist or 12) then
_a563(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a1056), _a1088))
return false, "이동이 되돌려짐"
end
end
local _a1089 = _a576.move.hrp()
if _a1057 and _a1089 then
_a563(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a1089.Position - _a1060).Magnitude, tostring(_a576.move.curZone()), tostring(_a576.move.inDottedBox())))
end
return true
end
function _a576.egg.tpEgg(_a1090)
if not _a1090 then return false, "알 id 없음" end
for _a1091, _a1092 in ipairs(_a576.egg.eggStands()) do
if _a1092.id == _a1090 then
if _a1092.dist <= _a569.EggRange then return true, _a1090 end
local _a1093, _a1094 = _a576.move.glideTo(_a1092.pos)
return _a1093, _a1093 and _a1090 or _a1094
end
end
if _a569.TpGameFallback then
local _a1095 = _a574.DirEggs and rawget(_a574.DirEggs, _a1090)
local _a1096 = _a1095 and select(1, _a576.move.zoneByNumber(rawget(_a1095, "zoneNumber")))
if _a1096 and _a576.move.curZone() ~= _a1096 then
local _a1097, _a1098 = _a576.move.tpZone(_a1096)
if not _a1097 then return false, _a1098 end
task.wait(0.5)
_a576.egg._standsAt = nil
for _a1099, _a1100 in ipairs(_a576.egg.eggStands()) do
if _a1100.id == _a1090 then return _a576.move.glideTo(_a1100.pos), _a1090 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a1090) .. ")"
end
function _a576.item.stacks(_a1101)
local _a1102 = _a603()
local _a1103 = _a1102 and rawget(_a1102, "Inventory")
local _a1104 = _a1103 and rawget(_a1103, _a1101)
if type(_a1104) ~= "table" then return {} end
local _a1105 = {}
for _a1106, _a1107 in pairs(_a1104) do
if type(_a1107) == "table" then
_a1105[#_a1105 + 1] = {
uid = _a1106,
id = tostring(rawget(_a1107, "id")),
tier = tonumber(rawget(_a1107, "tn")) or 1,
am = tonumber(rawget(_a1107, "_am")) or 1,
}
end
end
return _a1105
end
_a576.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a576.item.perTier(_a1108, _a1109)
_a1109 = tonumber(_a1109)
local _a1110 = _a574.Bal and rawget(_a574.Bal,
_a1108 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a1110) == "function" then
local _a1111, _a1112 = pcall(_a1110, _a1109)
_a1112 = _a1111 and tonumber(_a1112) or nil
if _a1112 and _a1112 > 0 then return _a1112 end
if not _a1111 and not _a576.item.perTierWarned then
_a576.item.perTierWarned = true
_a563("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a1112) .. ")")
end
end
local _a1113 = _a576.item.PERTIER[_a1108]
local _a1114 = _a1113 and _a1109 and _a1113[_a1109]
return (_a1114 and _a1114 > 0) and _a1114 or nil
end
function _a576.item.upgradeTo(_a1115, _a1116)
local _a1117 = (_a1115 == "Potion") and _a574.R_PotUp or _a574.R_EncUp
if not _a1117 then return 0, (_a1115 .. " 업글 리모트 없음") end
local _a1118 = math.max(1, (tonumber(_a1116) or 2) - 1)
local _a1119 = _a576.item.perTier(_a1115, _a1118)
if not _a1119 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a1118) end
local _a1120, _a1121 = {}, 0
for _a1122, _a1123 in ipairs(_a576.item.stacks(_a1115)) do
if _a1123.tier == _a1118 then
local _a1124 = math.floor(_a1123.am / _a1119)
if _a1124 > 0 then _a1120[_a1123.uid] = _a1124 _a1121 += _a1124 end
end
end
if _a1121 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a1118, _a1118, _a1119) end
local _a1125, _a1126
pcall(function() _a1125, _a1126 = _a1117:InvokeServer(_a1120) end)
if not _a1125 then return 0, tostring(_a1126) end
return _a1121
end
function _a576.item.usePotion(_a1127, _a1128)
if not _a574.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a1127 = tonumber(_a1127) or 1
local _a1129 = {}
for _a1130, _a1131 in ipairs(_a576.item.stacks("Potion")) do
if _a1131.tier >= _a1127 and _a1131.am >= 1 then _a1129[#_a1129 + 1] = _a1131 end
end
if #_a1129 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a1127) end
table.sort(_a1129, function(_a1132, _a1133) return _a1132.tier < _a1133.tier end)
local _a1134, _a1135 = _a1128, 0
for _a1136, _a1137 in ipairs(_a1129) do
for _a1138 = 1, math.min(_a1134, _a1137.am) do
if _a1134 < 1 or not _a570.quest then break end
pcall(function() _a574.R_PotUse:FireServer(_a1137.uid, 1) end)
_a1135 += 1
_a1134 -= 1
task.wait(0.12)
end
if _a1134 < 1 then break end
end
return _a1135
end
_a576.ev.EVENTKIND = {
[31]="CoinJar",    [37]="CoinJar",    [68]="CoinJar",
[32]="Comet",      [38]="Comet",      [69]="Comet",
[66]="Pinata",     [43]="Pinata",     [70]="Pinata",
[67]="LuckyBlock", [44]="LuckyBlock", [71]="LuckyBlock",
}
_a576.ev.BESTONLY = { [37]=true, [38]=true, [43]=true, [44]=true, [39]=true, [76]=true }
_a576.ev.CHESTKIND = { [8]="MiniChests", [39]="MiniChests", [72]="MiniChests",
[75]="SuperiorMiniChests", [76]="SuperiorMiniChests", [77]="SuperiorMiniChests" }
local function _a1139(_a1140)
if typeof(_a1140) == "Vector3" then return _a1140 end
if typeof(_a1140) == "CFrame" then return _a1140.Position end
if type(_a1140) == "table" then
local _a1141, _a1142, _a1143 = tonumber(_a1140.X or _a1140.x or _a1140[1]), tonumber(_a1140.Y or _a1140.y or _a1140[2]), tonumber(_a1140.Z or _a1140.z or _a1140[3])
if _a1141 and _a1142 and _a1143 then return Vector3.new(_a1141, _a1142, _a1143) end
end
return nil
end
function _a576.ev.events()
local _a1144
if _a574.Rand and rawget(_a574.Rand, "GetActive") then
local _a1145, _a1146 = pcall(_a574.Rand.GetActive)
if _a1145 and type(_a1146) == "table" and next(_a1146) then _a1144 = _a1146 end
end
if not _a1144 and _a574.R_Events then
local _a1147, _a1148 = pcall(function() return _a574.R_Events:InvokeServer() end)
if _a1147 and type(_a1148) == "table" then _a1144 = _a1148 end
end
if type(_a1144) ~= "table" then return {} end
local _a1149 = workspace:GetServerTimeNow()
local _a1150 = {}
for _a1151, _a1152 in pairs(_a1144) do
if type(_a1152) == "table" then
local _a1153 = tostring(rawget(_a1152, "id") or "")
local _a1154 = _a1153:match("|%s*(%S+)%s*$") or _a1153
local _a1155 = tonumber(rawget(_a1152, "started")) or 0
local _a1156 = tonumber(rawget(_a1152, "duration")) or 0
_a1150[#_a1150 + 1] = {
uid = rawget(_a1152, "uid"),
id = _a1153,
kind = _a1154,
name = rawget(_a1152, "name") or _a1154,
zone = rawget(_a1152, "parentID"),
pos = _a1139(rawget(_a1152, "origin")),
left = math.max(0, _a1156 - (_a1149 - _a1155)),
}
end
end
table.sort(_a1150, function(_a1157, _a1158) return _a1157.left > _a1158.left end)
return _a1150
end
_a576.ev.SPAWN = {
CoinJar    = { rem = "CoinJar_Spawn",           key = "coin jar",
order = { "basic", "giant", "magic" } },
Comet      = { rem = "Comet_Spawn",             key = "comet" },
Pinata     = { rem = "MiniPinata_Consume",      key = "pinata" },
LuckyBlock = { rem = "MiniLuckyBlock_Consume",  key = "lucky block" },
}
function _a576.move.inDottedBox()
if _a574.Map and rawget(_a574.Map, "IsInDottedBox") then
local _a1159, _a1160 = pcall(_a574.Map.IsInDottedBox)
if _a1159 then return _a1160 and true or false end
end
return nil
end
function _a576.ev.spawnItems(_a1161)
local _a1162 = _a576.ev.SPAWN[_a1161]
if not _a1162 then return {} end
local _a1163 = {}
for _a1164, _a1165 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a1166, _a1167 in ipairs(_a576.item.stacks(_a1165)) do
local _a1168 = _a1167.id:lower()
if _a1168:find(_a1162.key, 1, true) then
local _a1169 = 99
if _a1162.order then
for _a1170, _a1171 in ipairs(_a1162.order) do
if _a1168:find(_a1171, 1, true) then _a1169 = _a1170 break end
end
end
_a1167.rank = _a1169
_a1163[#_a1163 + 1] = _a1167
end
end
end
table.sort(_a1163, function(_a1172, _a1173)
if _a1172.rank ~= _a1173.rank then return _a1172.rank < _a1173.rank end
return _a1172.tier < _a1173.tier
end)
return _a1163
end
function _a576.ev.spawnEvent(_a1174)
local _a1175 = _a576.ev.SPAWN[_a1174]
if not _a1175 then return 0, "소환 불가 종류" end
local _a1176 = _a567:FindFirstChild(_a1175.rem)
if not _a1176 then return 0, _a1175.rem .. " 리모트 없음" end
local _a1177 = _a576.ev.spawnItems(_a1174)
if #_a1177 == 0 then return 0, _a1174 .. " 아이템 없음" end
local _a1178 = _a576.move.inDottedBox()
if _a1178 == false then return 0, "점선 네모 안이 아님" end
local _a1179, _a1180 = 0, nil
for _a1181, _a1182 in ipairs(_a1177) do
if _a1179 >= (_a569.SpawnPerCycle or 1) or not _a570.quest then break end
local _a1183, _a1184
pcall(function() _a1183, _a1184 = _a1176:InvokeServer(_a1182.uid) end)
if _a1183 then
_a1179 += 1
_a576.ctl.setAct("소환", _a1174 .. " · " .. _a1182.id)
_a563(("  🎁 %s 소환  (%s)"):format(_a1174, _a1182.id))
task.wait(0.4)
else
_a1180 = _a1184
break
end
end
return _a1179, _a1180
end
function _a576.ev.findEvent(_a1185, _a1186)
local _a1187 = _a1186 and _a576.move.bestZone() or nil
local _a1188
for _a1189, _a1190 in ipairs(_a576.ev.events()) do
if _a1190.kind == _a1185 and _a1190.left > 15 then
if not _a1186 or _a1190.zone == _a1187 then
if not _a1188 or (_a1190.zone == _a576.move.curZone() and _a1188.zone ~= _a576.move.curZone()) then
_a1188 = _a1190
end
end
end
end
return _a1188
end
function _a576.ev.findChest(_a1191, _a1192)
local _a1193 = workspace:FindFirstChild("__THINGS")
if not _a1193 then return nil end
local _a1194 = tostring(_a1191):lower():find("superior") ~= nil
local _a1195 = _a576.move.hrp()
local _a1196 = _a1195 and _a1195.Position
local _a1197, _a1198, _a1199, _a1200
for _a1201, _a1202 in ipairs(_a1193:GetChildren()) do
if tostring(_a1202.Name):lower():find("chest", 1, true) then
for _a1203, _a1204 in ipairs(_a1202:GetChildren()) do
local _a1205
if _a1204:IsA("BasePart") then _a1205 = _a1204.Position
elseif _a1204:IsA("Model") then
local _a1206, _a1207 = pcall(function() return _a1204:GetPivot() end)
if _a1206 and typeof(_a1207) == "CFrame" then _a1205 = _a1207.Position end
end
if _a1205 then
local _a1208 = _a1196 and (_a1205 - _a1196).Magnitude or 0
local _a1209 = (tostring(_a1204.Name) .. tostring(_a1202.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a1200 or _a1208 < _a1200 then _a1199, _a1200 = _a1205, _a1208 end
if _a1209 == _a1194 and (not _a1198 or _a1208 < _a1198) then
_a1197, _a1198 = _a1205, _a1208
end
end
end
end
end
if _a1197 then return _a1197, _a1198 end
return _a1199, _a1200
end
_a576.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a576.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a576.item.petStacks()
local _a1210 = _a603()
local _a1211 = _a1210 and rawget(_a1210, "Inventory")
local _a1212 = _a1211 and rawget(_a1211, "Pet")
local _a1213 = {}
if type(_a1212) ~= "table" then return _a1213 end
for _a1214, _a1215 in pairs(_a1212) do
if type(_a1215) == "table" then
_a1213[#_a1213 + 1] = {
uid = _a1214,
id = tostring(rawget(_a1215, "id")),
pt = tonumber(rawget(_a1215, "pt")) or 0,
am = tonumber(rawget(_a1215, "_am")) or 1,
}
end
end
return _a1213
end
function _a576.item.bestEggPets()
local _a1216 = _a644()
local _a1217 = _a1216 and _a574.DirEggs and rawget(_a574.DirEggs, _a1216)
local _a1218 = _a1217 and rawget(_a1217, "pets")
local _a1219 = {}
if type(_a1218) == "table" then
for _a1220, _a1221 in pairs(_a1218) do
local _a1222 = type(_a1221) == "table" and _a1221[1] or _a1221
if _a1222 then _a1219[tostring(_a1222)] = true end
end
end
return _a1219, _a1216
end
function _a576.item.makeVariant(_a1223, _a1224)
local _a1225 = (_a1223 == "gold") and _a574.R_Gold or _a574.R_Rain
if not _a1225 then return 0, (_a1223 .. " 머신 리모트 없음") end
local _a1226 = (_a1223 == "gold") and 0 or 1
local _a1227
if _a1224 then
local _a1228, _a1229 = _a576.item.bestEggPets()
if not next(_a1228) then return 0, "최고 알(" .. tostring(_a1229) .. ") 펫 목록을 못 읽음" end
_a1227 = _a1228
end
local _a1230, _a1231 = 0, nil
for _a1232, _a1233 in ipairs(_a576.item.petStacks()) do
if not _a570.quest then break end
if _a1233.pt == _a1226 and _a1233.am >= 10 and (not _a1227 or _a1227[_a1233.id]) then
local _a1234 = math.floor(_a1233.am / 10)
if _a1234 > 0 then
local _a1235, _a1236
pcall(function() _a1235, _a1236 = _a1225:InvokeServer(_a1233.uid, _a1234) end)
if _a1235 then
_a1230 += _a1234
_a563(("  ✨ %s 제작  %s x%d"):format(
_a1223 == "gold" and "골드" or "레인보우", _a1233.id, _a1234))
task.wait(0.4)
else
_a1231 = _a1236
end
end
end
end
return _a1230, _a1231
end
function _a576.item.useFlag(_a1237)
if not _a574.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a1238, _a1239 = 0, nil
for _a1240, _a1241 in ipairs(_a576.item.stacks("Misc")) do
if _a1238 >= (_a1237 or 1) then break end
if _a1241.id:lower():find("flag", 1, true) and _a1241.am >= 1 and _a576.item.itemAllowed(_a1241.id) then
local _a1242, _a1243
pcall(function() _a1242, _a1243 = _a574.R_Flag:InvokeServer(_a1241.id, _a1241.uid, 1) end)
if _a1242 then _a1238 += 1 task.wait(0.4) else _a1239 = _a1243 end
end
end
return _a1238, _a1239
end
function _a576.item.useFruit(_a1244)
if not _a574.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a1245 = _a576.item.activeBuffs("Fruits")
local _a1246 = 0
for _a1247, _a1248 in ipairs(_a576.item.stacks("Fruit")) do
if _a1246 >= (_a1244 or 1) then break end
if _a1248.am >= 1 and _a576.item.itemAllowed(_a1248.id) and not _a1245[_a1248.id] then
pcall(function() _a574.R_Fruit:FireServer(_a1248.uid, 1) end)
_a1246 += 1
task.wait(0.4)
end
end
return _a1246
end
function _a576.quest.status()
local _a1249 = _a603()
if not _a1249 then return nil end
local _a1250 = rawget(_a1249, "Goals")
if type(_a1250) ~= "table" then return { list = {} } end
local _a1251 = {}
for _a1252, _a1253 in pairs(_a1250) do
if type(_a1253) == "table" then
local _a1254 = tonumber(rawget(_a1253, "Type")) or -1
local _a1255
if _a574.Quest and rawget(_a574.Quest, "MakeTitle") then
local _a1256, _a1257 = pcall(_a574.Quest.MakeTitle, _a1253)
if _a1256 then _a1255 = _a1257 end
end
_a1251[#_a1251 + 1] = {
slot = _a1252,
uid = tostring(rawget(_a1253, "UID")),
type = _a1254,
how = _a575[_a1254],
title = _a1255 or ("Type " .. _a1254),
amount = tonumber(rawget(_a1253, "Amount")) or 0,
progress = tonumber(rawget(_a1253, "Progress")) or 0,
stars = tonumber(rawget(_a1253, "Stars")) or 0,
potionTier = tonumber(rawget(_a1253, "PotionTier")),
enchantTier = tonumber(rawget(_a1253, "EnchantTier")),
breakable = rawget(_a1253, "BreakableType") or rawget(_a1253, "BreakableDirID"),
zoneId = rawget(_a1253, "ZoneID"),
where = _a576.quest.WHERE[_a1254] or (_a575[_a1254] == "farm" and "bestzone" or nil),
event = _a576.ev.EVENTKIND[_a1254],
chest = _a576.ev.CHESTKIND[_a1254],
bestOnly = _a576.ev.BESTONLY[_a1254] or false,
ignored = _a576.quest.IGNORE[_a1254],
}
end
end
table.sort(_a1251, function(_a1258, _a1259) return _a1258.stars > _a1259.stars end)
return { list = _a1251, rank = tonumber(rawget(_a1249, "Rank")) or 1,
rankStars = tonumber(rawget(_a1249, "RankStars")) or 0 }
end
_a576.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a576.quest.bestDepActive()
local _a1260 = _a576.ctl.lockGoal and _a576.ctl.lockGoal.q
if not _a1260 then return false end
if _a576.quest.IGNORE[_a1260.type] then return false end
if not _a576.quest.BESTDEP[_a1260.type] then return false end
local _a1261 = _a576.quest.findQuest(_a1260.uid)
if not _a1261 or _a1261.progress >= _a1261.amount then return false end
return true, _a1261
end
function _a576.quest.canDo(_a1262, _a1263)
if _a1262.how == "hatch" or _a1262.where == "bestegg" then
local _a1264 = _a669()
if not _a1264 then return false, "알 정보를 못 읽음" end
if not _a1264.price then return true end
if not _a1263 then
if _a1264.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a1264.id), _a564(_a1264.price, 0), tostring(_a1264.currency), _a564(_a1264.have, 0))
end
return true
end
local _a1265 = math.max(1, (_a1262.amount or 1) - (_a1262.progress or 0))
local _a1266 = _a1265
if _a1262.type == 2 or _a1262.type == 42 or _a1262.type == 47 then
_a1266 = math.max(_a1265, _a569.HatchMinAfford or 10)
end
if _a1264.canBuy < _a1266 then
_a576.quest.moneyUntil = os.clock() + math.max(0, _a569.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a1266, _a1264.canBuy, _a564(_a1264.price, 0), tostring(_a1264.currency))
end
if _a576.quest.moneyUntil and os.clock() < _a576.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a576.quest.moneyUntil - os.clock())
end
_a576.quest.moneyUntil = nil
end
return true
end
function _a576.quest.findQuest(_a1267)
local _a1268 = _a576.quest.status()
for _a1269, _a1270 in ipairs(_a1268 and _a1268.list or {}) do
if _a1270.uid == _a1267 then return _a1270 end
end
return nil
end
function _a576.quest.pursue(_a1271)
local _a1272, _a1273
if _a1271.how == "hatch" then _a1272, _a1273 = _a680, "mhatch"
elseif _a1271.how == "zone" then _a1272, _a1273 = _a639, "zone"
elseif _a1271.how == "gold" or _a1271.how == "rainbow" then
local _a1274 = (_a1271.type == 40 or _a1271.type == 41)
_a1273 = "quest"
_a1272 = function()
local _a1275 = _a576.item.makeVariant("gold", _a1274) or 0
if _a1271.how == "rainbow" then
_a1275 += (_a576.item.makeVariant("rainbow", _a1274) or 0)
end
if _a1275 > 0 then
_a576.ctl.setAct(_a1271.how == "gold" and "골드 합성" or "레인보우 합성", _a1275 .. "마리")
return
end
_a576.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a1276 = _a570.mhatch
_a570.mhatch = true
pcall(_a680)
_a570.mhatch = _a1276
end
end
local _a1277 = _a1271.progress
local _a1278 = os.clock()
_a576.ctl.setGoal(_a1271.title, ("%d/%d"):format(_a1271.progress, _a1271.amount))
local function _a1279()
if not _a1271.event then return end
local _a1280 = _a576.ev.findEvent(_a1271.event, _a1271.bestOnly)
if _a1280 then
_a576.ctl.setAct(_a1271.event .. " 진행 중", ("%d초 남음"):format(_a1280.left))
if _a1280.pos then
local _a1281 = _a576.move.hrp()
if _a1281 and (_a1281.Position - _a1280.pos).Magnitude > (_a569.EventStayDist or 45) then
_a576.move.glideTo(_a1280.pos)
end
end
return
end
local _a1282, _a1283 = _a576.ev.spawnEvent(_a1271.event)
if _a1282 > 0 then
_a576.ctl.setAct("소환", _a1271.event)
task.wait(0.5)
elseif _a1283 and _a576.ev.spawnErr ~= tostring(_a1283) then
_a576.ev.spawnErr = tostring(_a1283)
_a563("[퀘스트] " .. _a1271.event .. " 소환 실패: " .. tostring(_a1283))
end
end
local _a1284, _a1285 = pcall(function()
while _a570.quest and not _a576.ctl.stopped() do
local _a1286, _a1287 = _a576.quest.canDo(_a1271, false)
if not _a1286 then
_a563(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a1271.title), tostring(_a1287)))
return
end
_a1279()
if _a1272 then
local _a1288 = _a570[_a1273]
_a570[_a1273] = true
local _a1289, _a1290 = pcall(_a1272)
_a570[_a1273] = _a1288
if not _a1289 then error(_a1290, 0) end
elseif _a1271.event then
task.wait(0.4)
else
task.wait(2)
end
local _a1291 = _a576.quest.findQuest(_a1271.uid)
if not _a1291 then
_a563("[퀘스트] 완료 — " .. tostring(_a1271.title))
return
end
_a576.ctl.setGoal(_a1291.title, ("%d/%d"):format(_a1291.progress, _a1291.amount))
if _a1291.progress >= _a1291.amount then
_a563(("[퀘스트] 달성 %d/%d — %s"):format(_a1291.progress, _a1291.amount, tostring(_a1291.title)))
return
end
if _a1291.progress > _a1277 then
_a1278 = os.clock()
_a563(("[퀘스트] %d/%d  %s"):format(_a1291.progress, _a1291.amount, tostring(_a1291.title)))
end
_a1277 = _a1291.progress
local _a1292 = os.clock() - _a1278
if _a1292 >= math.max(10, _a569.PursueStallSec or 60) then
_a563(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a1292, _a1291.progress, _a1291.amount, tostring(_a1291.title)))
return
end
task.wait(0.2)
end
end)
if not _a1284 then _a563("[퀘스트] " .. tostring(_a1271.how) .. " 오류: " .. tostring(_a1285)) end
_a576.ctl.lockGoal = nil
_a576.ctl.setGoal(nil)
end
function _a576.quest.cycle()
do
local _a1293 = _a570.rank
_a570.rank = true
pcall(_a731)
_a570.rank = _a1293
end
local _a1294 = _a576.quest.status()
if not _a1294 then return end
local _a1295, _a1296, _a1297 = false, false, false
local _a1298 = {}
local _a1299 = nil
for _a1300, _a1301 in ipairs(_a1294.list) do
if not _a570.quest then break end
local _a1302, _a1303 = true, nil
if not _a1301.ignored and _a1301.progress < _a1301.amount then
_a1302, _a1303 = _a576.quest.canDo(_a1301, true)
end
if _a1301.ignored then
if _a1301.progress < _a1301.amount then
_a1298[#_a1298 + 1] = tostring(_a1301.title) .. "  — " .. _a1301.ignored
end
elseif not _a1302 then
local _a1304 = tostring(_a1301.uid) .. tostring(_a1303)
if _a576.item.skipSaid ~= _a1304 then
_a576.item.skipSaid = _a1304
_a563(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a1301.title), tostring(_a1303)))
end
elseif _a1301.progress < _a1301.amount then
local _a1305 = _a1301.where
if _a1301.event then
if not _a1299 or _a1299.rank > 0 then _a1299 = { rank = 0, kind = "event", q = _a1301 } end
elseif _a1301.chest then
if not _a1299 or _a1299.rank > 1 then _a1299 = { rank = 1, kind = "chest", q = _a1301 } end
elseif _a1305 == "bestegg" then
if not _a1299 or _a1299.rank > 1 then _a1299 = { rank = 1, kind = "egg", q = _a1301 } end
elseif _a1305 == "breakable" and _a1301.breakable then
if not _a1299 or _a1299.rank > 2 then _a1299 = { rank = 2, kind = "breakable", q = _a1301 } end
elseif _a1305 == "zoneid" and _a1301.zoneId then
if not _a1299 or _a1299.rank > 2 then _a1299 = { rank = 2, kind = "zoneid", q = _a1301 } end
elseif _a1305 == "bestzone" or _a1305 == "breakable" then
if not _a1299 then _a1299 = { rank = 3, kind = "bestzone", q = _a1301 } end
end
if _a1301.how == "farm" then
_a1295 = true
elseif _a1301.how == "hatch" then
_a1296 = true
elseif _a1301.how == "zone" then
_a1297 = true
elseif _a1301.how == "potup" and _a569.QuestUpgrade then
local _a1306, _a1307 = _a576.item.upgradeTo("Potion", _a1301.potionTier or 2)
if _a1306 > 0 then
_a571.potup += _a1306
_a571.quest += 1
_a563(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a1301.potionTier or 2, _a1306, _a1301.title))
elseif _a1307 and not tostring(_a1307):find("부족") then
if _a576.item.potUpSaid ~= tostring(_a1307) then
_a576.item.potUpSaid = tostring(_a1307)
_a563("[퀘스트] 포션 업글 실패: " .. tostring(_a1307))
end
end
elseif _a1301.how == "encup" and _a569.QuestUpgrade then
local _a1308, _a1309 = _a576.item.upgradeTo("Enchant", _a1301.enchantTier or 2)
if _a1308 > 0 then
_a571.potup += _a1308
_a571.quest += 1
_a563(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a1301.enchantTier or 2, _a1308, _a1301.title))
elseif _a1309 and not tostring(_a1309):find("부족") then
if _a576.item.encUpSaid ~= tostring(_a1309) then
_a576.item.encUpSaid = tostring(_a1309)
_a563("[퀘스트] 인챈트 업글 실패: " .. tostring(_a1309))
end
end
elseif _a1301.how == "potuse" and _a569.QuestUsePotion then
_a576.item.lastUse = _a576.item.lastUse or {}
local _a1310 = _a576.item.lastUse[_a1301.uid]
if _a1310 and _a1310.used > 0 and _a1301.progress <= _a1310.progress then
if not _a1310.gaveUp then
_a1310.gaveUp = true
_a563("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a1301.title))
end
else
local _a1311 = math.min(_a569.QuestUseMax, math.max(1, _a1301.amount - _a1301.progress))
local _a1312, _a1313 = _a576.item.usePotion(_a1301.potionTier or 1, _a1311)
_a576.item.lastUse[_a1301.uid] = { used = _a1312, progress = _a1301.progress }
if _a1312 > 0 then
_a571.potuse += _a1312
_a571.quest += 1
_a563(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a1312, _a1301.title))
elseif _a1313 and not tostring(_a1313):find("없음") then
_a563("[퀘스트] 포션 사용 실패: " .. tostring(_a1313))
end
end
elseif _a1301.how == "gold" or _a1301.how == "rainbow" then
local _a1314, _a1315 = _a576.item.makeVariant(_a1301.how, _a1301.type == 40 or _a1301.type == 41)
if _a1314 > 0 then
_a571.quest += 1
_a563(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a1301.how == "gold" and "골드" or "레인보우", _a1314, _a1301.title))
elseif _a1315 then
_a563("[퀘스트] " .. _a1301.how .. " 실패: " .. tostring(_a1315))
end
elseif _a1301.how == "fruituse" then
local _a1316 = _a576.item.useFruit(math.max(1, _a1301.amount - _a1301.progress))
if _a1316 > 0 then
_a571.quest += 1
_a563(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a1316, _a1301.title))
end
elseif _a1301.how == "flaguse" then
local _a1317, _a1318 = _a576.item.useFlag(math.max(1, _a1301.amount - _a1301.progress))
if _a1317 > 0 then
_a571.quest += 1
_a563(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a1317, _a1301.title))
elseif _a1318 then
_a563("[퀘스트] 깃발 실패: " .. tostring(_a1318))
end
elseif not _a1301.how then
_a1298[#_a1298 + 1] = _a1301.title
end
end
end
if _a569.QuestLock and _a576.ctl.lockGoal then
local _a1319
for _a1320, _a1321 in ipairs(_a1294.list) do
if _a1321.uid == _a576.ctl.lockGoal.q.uid and _a1321.progress < _a1321.amount then _a1319 = _a1321 break end
end
if _a1319 then
_a576.ctl.lockGoal.q = _a1319
_a1299 = _a576.ctl.lockGoal
else
if _a576.ctl.lockGoal.q then
_a563("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a576.ctl.lockGoal.q.title))
end
_a576.ctl.lockGoal = nil
end
end
if _a569.QuestLock and _a1299 then _a576.ctl.lockGoal = _a1299 end
if _a569.QuestTp and _a1299 and _a570.quest then
local _a1322, _a1323, _a1324
if _a1299.kind == "event" then
local _a1325 = _a576.ev.findEvent(_a1299.q.event, _a1299.q.bestOnly)
if _a1325 then
_a1324 = ("%s @%s (%d초 남음)"):format(_a1325.name, tostring(_a1325.zone), _a1325.left)
if _a1325.pos then _a1322, _a1323 = _a576.move.glideTo(_a1325.pos)
else _a1322, _a1323 = _a576.move.goToZone(_a1325.zone) end
else
local _a1326 = _a1299.q.bestOnly and _a576.move.bestZone() or (_a576.move.curZone() or _a576.move.bestZone())
_a1324 = _a1299.q.event .. " 소환용 " .. tostring(_a1326)
local _a1327 = _a576.move.inDottedBox()
_a1322, _a1323 = _a576.move.goToZone(_a1326, false, _a1327 == false, _a1299.q.bestOnly)
if _a1322 then
local _a1328, _a1329 = _a576.ev.spawnEvent(_a1299.q.event)
if _a1328 < 1 and tostring(_a1329):find("점선") then
_a576.move.goToZone(_a1326, false, true)
task.wait(0.2)
_a1328, _a1329 = _a576.ev.spawnEvent(_a1299.q.event)
end
if _a1328 > 0 then
_a1324 = ("%s %d개 소환 @%s"):format(_a1299.q.event, _a1328, tostring(_a1326))
else
_a1323 = _a1329
_a1322 = false
end
end
end
elseif _a1299.kind == "chest" then
local _a1330 = _a1299.q.bestOnly and _a576.move.bestZone() or _a576.move.curZone()
local _a1331, _a1332 = _a576.ev.findChest(_a1299.q.chest, _a1330)
_a1324 = _a1299.q.chest .. " @" .. tostring(_a1330)
if _a1331 then
if not _a1332 or _a1332 > 20 then _a576.move.glideTo(_a1331) end
_a1322 = true
else
_a1322, _a1323 = _a576.move.goToZone(_a1330)
_a1324 = _a1324 .. " (상자 없음 → 존 가운데)"
end
elseif _a1299.kind == "egg" then
local _a1333 = _a644()
_a1324 = "최고 알 " .. tostring(_a1333)
if _a1333 then _a1322, _a1323 = _a576.egg.tpEgg(_a1333) else _a1323 = "최고 알을 못 찾음" end
elseif _a1299.kind == "breakable" then
local _a1334 = _a576.move.zoneForBreakable(_a1299.q.breakable)
_a1324 = tostring(_a1299.q.breakable) .. " 나오는 존 " .. tostring(_a1334)
if _a1334 then _a1322, _a1323 = _a576.move.goToZone(_a1334, true) else _a1323 = "그 브레이커블이 나오는 존이 없음" end
elseif _a1299.kind == "zoneid" then
_a1324 = "존 " .. tostring(_a1299.q.zoneId)
_a1322, _a1323 = _a576.move.goToZone(_a1299.q.zoneId)
else
local _a1335 = _a576.move.bestZone()
local _a1336 = _a1299.q.bestOnly or _a576.quest.BESTDEP[_a1299.q.type] or false
if _a1335 then _a1322, _a1323 = _a576.move.goToZone(_a1335, true, false, _a1336)
else _a1323 = "최고 존을 못 찾음" end
_a1324 = "최고 존 " .. tostring(_a576.move.arrivedZone or _a1335)
if not _a1322 then _a1323 = _a1335 end
end
if _a1322 then
if _a576.quest.lastGoal ~= _a1324 then
_a576.quest.lastGoal = _a1324
_a563("[퀘스트] " .. _a1324 .. " 으로 이동  (" .. tostring(_a1299.q.title) .. ")")
end
_a576.quest.pursue(_a1299.q)
else
local _a1337 = _a1323 and tostring(_a1323) or "이유 불명"
if _a576.quest.lastFail ~= _a1337 then
_a576.quest.lastFail = _a1337
_a563(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a1337, tostring(_a1299.kind), tostring(_a1299.q.title)))
_a563(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a576.move.curZone()), tostring(_a576.move.bestZone()), tostring(_a576.move.inDottedBox())))
end
end
end
if _a569.QuestDrive and _a576.auto.turnOn then
if _a1295  then _a576.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a1297  then _a576.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a1296 then _a576.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a1298 > 0 and not _a576.quest.manualWarned then
_a576.quest.manualWarned = true
_a563("[퀘스트] 수동으로 해야 하는 것:")
for _a1338, _a1339 in ipairs(_a1298) do _a563("    · " .. tostring(_a1339)) end
elseif #_a1298 == 0 then
_a576.quest.manualWarned = false
end
return _a1299 ~= nil
end
local function _a1340(_a1341)
local _a1342 = {}
for _a1343 in tostring(_a1341 or ""):gmatch("[^,]+") do
_a1343 = _a1343:match("^%s*(.-)%s*$")
if _a1343 ~= "" then _a1342[#_a1342 + 1] = _a1343:lower() end
end
return _a1342
end
function _a576.item.itemAllowed(_a1344)
local _a1345 = tostring(_a1344):lower()
for _a1346, _a1347 in ipairs(_a1340(_a569.ItemBlock)) do
if _a1345:find(_a1347, 1, true) then return false end
end
local _a1348 = _a1340(_a569.ItemAllow)
if #_a1348 == 0 then return true end
for _a1349, _a1350 in ipairs(_a1348) do
if _a1345:find(_a1350, 1, true) then return true end
end
return false
end
function _a576.item.activeBuffs(_a1351)
local _a1352 = _a603()
local _a1353 = _a1352 and rawget(_a1352, _a1351)
local _a1354 = {}
if type(_a1353) == "table" then
for _a1355, _a1356 in pairs(_a1353) do
if type(_a1356) == "table" and next(_a1356) then _a1354[_a1355] = true
elseif _a1356 then _a1354[_a1355] = true end
end
end
return _a1354
end
local function _a1357(_a1358, _a1359, _a1360, _a1361)
local _a1362 = _a576.item.activeBuffs(_a1359)
local _a1363 = {}
local _a1364 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a1365, _a1366 in ipairs(_a576.item.stacks(_a1358)) do
_a1364.total += 1
if _a1362[_a1366.id] then _a1364.act += 1
elseif not _a576.item.itemAllowed(_a1366.id) then _a1364.blocked += 1
elseif _a1366.am <= _a569.ItemKeep then _a1364.few += 1
else
_a1364.ok += 1
local _a1367 = _a1363[_a1366.id]
local _a1368
if not _a1367 then _a1368 = true
elseif _a569.BuffHighTier then _a1368 = _a1366.tier > _a1367.tier
else _a1368 = _a1366.tier < _a1367.tier end
if _a1368 then _a1363[_a1366.id] = _a1366 end
end
end
if _a1364.ok == 0 and _a1364.total > 0 then
local _a1369 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a1358, _a1364.total, _a1364.act, _a1364.blocked, _a1364.few)
if _a576.item.buffSaid ~= _a1369 then
_a576.item.buffSaid = _a1369
_a563("[아이템] " .. _a1369)
end
elseif _a1364.ok > 0 then
_a576.item.buffSaid = nil
end
local _a1370 = {}
for _a1371, _a1372 in pairs(_a1363) do _a1370[#_a1370 + 1] = _a1372 end
table.sort(_a1370, function(_a1373, _a1374)
if _a1373.tier ~= _a1374.tier then return _a1373.tier > _a1374.tier end
return _a1373.am > _a1374.am
end)
local _a1375 = {}
for _a1376, _a1377 in ipairs(_a1370) do
if not _a570.items then break end
if _a1361 and _a1361.left <= 0 then break end
local _a1378 = pcall(function() _a1360(_a1377.uid, 1) end)
if _a1378 then
_a1375[#_a1375 + 1] = ("%s T%d"):format(_a1377.id, _a1377.tier)
_a571.items += 1
if _a1361 then _a1361.left -= 1 end
task.wait(0.12)
end
end
return _a1375
end
function _a576.item.cycleItems()
local function _a1379()
local _a1380 = {}
if _a569.BuffPotion then _a1380[#_a1380 + 1] = { "Potion", "Potions" } end
if _a569.BuffFruit then _a1380[#_a1380 + 1] = { "Fruit", "Fruits" } end
if _a569.BuffConsumable then _a1380[#_a1380 + 1] = { "Consumable", "Consumables" } end
for _a1381, _a1382 in ipairs(_a1380) do
local _a1383 = _a576.item.activeBuffs(_a1382[2])
for _a1384, _a1385 in ipairs(_a576.item.stacks(_a1382[1])) do
if _a1385.am > _a569.ItemKeep and _a576.item.itemAllowed(_a1385.id) and not _a1383[_a1385.id] then
return true
end
end
end
if _a569.BuffUltimate and _a574.R_Ult then
local _a1386 = _a603()
local _a1387 = _a1386 and rawget(_a1386, "Ultimates")
if type(_a1387) == "table" then
for _a1388 in pairs(_a1387) do
if _a576.item.itemAllowed(_a1388) then
if not (_a574.Ult and rawget(_a574.Ult, "IsCharged")) then return true end
local _a1389, _a1390 = pcall(_a574.Ult.IsCharged, _a1388)
if _a1389 and _a1390 then return true end
end
end
end
end
return false
end
if not _a1379() then return end
if _a569.ItemBestZone then
local _a1391 = _a576.move.bestZone()
if _a1391 and _a576.move.curZone() ~= _a1391 then
if not _a569.ItemTp then
if not _a576.item.itemZoneWarned then
_a576.item.itemZoneWarned = true
_a563(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a1391), tostring(_a576.move.curZone())))
end
return
end
local _a1392, _a1393 = _a576.move.goToZone(_a1391)
if not _a1392 then
_a563("[아이템] 최고 존 이동 실패: " .. tostring(_a1393))
return
end
_a563("[아이템] 최고 존 " .. tostring(_a1391) .. " 에서 사용")
end
_a576.item.itemZoneWarned = false
end
local _a1394 = {}
local _a1395  = { left = math.max(1, _a569.BuffMaxPotion or 5) }
local _a1396 = { left = math.max(1, _a569.BuffMaxOther or 2) }
if _a569.BuffPotion and _a574.R_PotUse then
local _a1397 = _a1357("Potion", "Potions", function(_a1398, _a1399)
_a574.R_PotUse:FireServer(_a1398, _a1399)
end, _a1395)
for _a1400, _a1401 in ipairs(_a1397) do _a1394[#_a1394 + 1] = "포션 " .. _a1401 end
end
if _a569.BuffFruit and _a574.R_Fruit then
local _a1402 = _a1357("Fruit", "Fruits", function(_a1403, _a1404)
_a574.R_Fruit:FireServer(_a1403, _a1404)
end, _a1396)
for _a1405, _a1406 in ipairs(_a1402) do _a1394[#_a1394 + 1] = "과일 " .. _a1406 end
end
if _a569.BuffConsumable and _a574.R_Cons then
local _a1407 = _a1357("Consumable", "Consumables", function(_a1408, _a1409)
_a574.R_Cons:InvokeServer(_a1408, _a1409)
end, _a1396)
for _a1410, _a1411 in ipairs(_a1407) do _a1394[#_a1394 + 1] = "소모품 " .. _a1411 end
end
if _a569.BuffUltimate and _a574.R_Ult then
local _a1412 = _a603()
local _a1413 = _a1412 and rawget(_a1412, "Ultimates")
if type(_a1413) == "table" then
for _a1414 in pairs(_a1413) do
if not _a570.items then break end
if _a576.item.itemAllowed(_a1414) then
local _a1415 = true
if _a574.Ult and rawget(_a574.Ult, "IsCharged") then
local _a1416, _a1417 = pcall(_a574.Ult.IsCharged, _a1414)
_a1415 = _a1416 and _a1417 and true or false
end
if _a1415 then
local _a1418
pcall(function() _a1418 = _a574.R_Ult:InvokeServer(_a1414) end)
if _a1418 then
_a1394[#_a1394 + 1] = "얼티밋 " .. tostring(_a1414)
_a571.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a1394 > 0 then
_a576.ctl.setAct("버프 사용", table.concat(_a1394, ", "))
_a563("[아이템] " .. table.concat(_a1394, ", ") .. " 사용")
end
end
function _a576.mach.slotStatus()
local _a1419 = _a603()
if not _a1419 then return nil end
local _a1420 = tonumber(rawget(_a1419, "PetSlotsPurchased")) or 0
local _a1421 = tonumber(rawget(_a1419, "EggSlotsPurchased")) or 0
local _a1422, _a1423 = 0, 0
if _a574.RankC then
if rawget(_a574.RankC, "GetMaxPurchasableEquipSlots") then
local _a1424, _a1425 = pcall(_a574.RankC.GetMaxPurchasableEquipSlots)
if _a1424 and tonumber(_a1425) then _a1422 = tonumber(_a1425) end
end
if rawget(_a574.RankC, "GetMaxPurchasableEggSlots") then
local _a1426, _a1427 = pcall(_a574.RankC.GetMaxPurchasableEggSlots)
if _a1426 and tonumber(_a1427) then _a1423 = tonumber(_a1427) end
end
end
local _a1428, _a1429
if _a1420 < _a1422 then
_a1428 = _a1420 + 1
if type(_a574.CalcPetS) == "function" then
local _a1430, _a1431 = pcall(_a574.CalcPetS, _a1428)
if _a1430 then _a1429 = tonumber(_a1431) end
end
end
local _a1432, _a1433, _a1434
if _a1421 < _a1423 and _a574.RankC and rawget(_a574.RankC, "GetEggBundle") then
local _a1435, _a1436, _a1437 = pcall(_a574.RankC.GetEggBundle, _a1421 + 1)
if _a1435 and tonumber(_a1436) then
_a1432, _a1433 = tonumber(_a1436), tonumber(_a1437) or 1
if type(_a574.CalcEggS) == "function" then
local _a1438, _a1439 = 0, false
for _a1440 = _a1432 - _a1433 + 1, _a1432 do
local _a1441, _a1442 = pcall(_a574.CalcEggS, _a1440)
if _a1441 and tonumber(_a1442) then _a1438 += tonumber(_a1442) else _a1439 = true end
end
if not _a1439 then _a1434 = _a1438 end
end
end
end
local _a1443
if _a574.Egg and rawget(_a574.Egg, "GetMaxHatch") then
local _a1444, _a1445 = pcall(_a574.Egg.GetMaxHatch)
if _a1444 then _a1443 = tonumber(_a1445) end
end
return {
dia = _a611("Diamonds"),
petOwned = _a1420, petMax = _a1422, petNext = _a1428, petCost = _a1429,
eggOwned = _a1421, eggMax = _a1423, eggEnd = _a1432, eggSize = _a1433, eggCost = _a1434,
maxEquip = tonumber(rawget(_a1419, "MaxPetsEquipped")), maxHatch = _a1443,
}
end
function _a576.move.machinePos(_a1446)
local _a1447
if _a574.Machine and rawget(_a574.Machine, "GetModels") then
local _a1448, _a1449 = pcall(_a574.Machine.GetModels, _a1446)
if _a1448 and type(_a1449) == "table" then
for _a1450, _a1451 in pairs(_a1449) do
if typeof(_a1451) == "Instance" then _a1447 = _a1451 break end
end
end
end
if not _a1447 then
local _a1452, _a1453 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a1452 then
for _a1454, _a1455 in ipairs(_a1453) do
if _a1455.Name == _a1446 then _a1447 = _a1455 break end
end
end
end
if not _a1447 then return nil end
if _a1447:IsA("BasePart") then return _a1447.Position end
local _a1456, _a1457 = pcall(function() return _a1447:GetPivot() end)
return (_a1456 and typeof(_a1457) == "CFrame") and _a1457.Position or nil
end
function _a576.mach.cycleSlots()
local _a1458 = 0
local _a1459 = 0
while _a570.slots and not _a576.ctl.stopped() and _a1459 < 40 do
_a1459 += 1
local _a1460 = _a576.mach.slotStatus()
if not _a1460 then return end
local _a1461 = _a569.SlotPet and _a1460.petNext and _a1460.petCost
and (_a1460.dia - _a569.SlotReserve) >= _a1460.petCost
local _a1462 = _a569.SlotEgg and _a1460.eggEnd and _a1460.eggCost
and (_a1460.dia - _a569.SlotReserve) >= _a1460.eggCost
if _a1461 and _a1462 then
if _a1460.eggCost < _a1460.petCost then _a1461 = false else _a1462 = false end
end
if not (_a1461 or _a1462) then break end
local _a1463, _a1464, _a1465, _a1466
local function _a1467()
if _a1461 then
pcall(function() _a1463, _a1464 = _a574.R_PetSlot:InvokeServer(_a1460.petNext) end)
else
pcall(function() _a1463, _a1464 = _a574.R_EggSlot:InvokeServer(_a1460.eggEnd) end)
end
end
if _a1461 then
_a1465 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a1460.petNext, _a564(_a1460.petCost, 0))
_a1466 = "EquipSlotsMachine"
else
_a1465 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a1460.eggSize, _a1460.eggEnd, _a564(_a1460.eggCost, 0))
_a1466 = "EggSlotsMachine"
end
_a1467()
if not _a1463 and tostring(_a1464):find("far away") then
local _a1468 = _a576.move.machinePos(_a1466)
if _a1468 then
_a576.ctl.setAct("슬롯 머신으로 이동", _a1466)
_a576.move.glideTo(_a1468)
task.wait(0.25)
_a1463, _a1464 = nil, nil
_a1467()
else
_a1464 = "머신 위치를 못 찾음 (" .. _a1466 .. ")"
end
end
if _a1463 then
_a1458 += 1
_a571.mslot += 1
_a576.mach.slotSaid = nil
_a576.ctl.setAct("슬롯 구매", _a1465)
_a563("  ⬆ " .. _a1465)
task.wait(0.35)
else
local _a1469 = _a1465 .. " 실패: " .. tostring(_a1464)
if _a576.mach.slotSaid ~= _a1469 then
_a576.mach.slotSaid = _a1469
_a563("[슬롯] " .. _a1469)
end
break
end
end
if _a1458 > 0 then
local _a1470 = _a576.mach.slotStatus()
_a563(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a1458, tostring(_a1470 and _a1470.maxEquip), tostring(_a1470 and _a1470.maxHatch),
_a564(_a611("Diamonds"), 0)))
end
end
function _a576.mach.upgList()
local _a1471 = {}
if not _a574.Upg then return _a1471 end
local _a1472, _a1473 = pcall(_a574.Upg.All)
if not (_a1472 and type(_a1473) == "table") then return _a1471 end
for _a1474, _a1475 in ipairs(_a1473) do
local _a1476, _a1477, _a1478 = rawget(_a1475, "UpgradeID"), rawget(_a1475, "ZoneID"), rawget(_a1475, "UpgradeTier")
if _a1476 and _a1477 and _a1478 then
local _a1479 = false
if rawget(_a574.Upg, "Owns") then
local _a1480, _a1481 = pcall(_a574.Upg.Owns, _a1476, _a1477)
_a1479 = _a1480 and _a1481 and true or false
end
local _a1482 = _a576.move.ownsZone(_a1477)
local _a1483 = _a574.DirUpg and rawget(_a574.DirUpg, _a1476)
local _a1484 = _a1483 and rawget(_a1483, "TierCosts")
local _a1485 = _a1484 and tonumber(_a1484[_a1478])
local _a1486 = "Diamonds"
local _a1487 = _a1483 and rawget(_a1483, "TierCurrencies")
local _a1488 = _a1487 and _a1487[_a1478]
if type(_a1488) == "table" and rawget(_a1488, "_id") then _a1486 = rawget(_a1488, "_id") end
local _a1489 = rawget(_a1475, "Model")
local _a1490
if typeof(_a1489) == "Instance" then
if _a1489:IsA("BasePart") then _a1490 = _a1489.Position
else
local _a1491, _a1492 = pcall(function() return _a1489:GetPivot() end)
if _a1491 and _a1492 then _a1490 = _a1492.Position end
end
end
_a1471[#_a1471 + 1] = {
id = _a1476, zone = _a1477, tier = _a1478, cost = _a1485, cur = _a1486,
bought = _a1479, zoneOwned = _a1482,
buyable = _a1482 and not _a1479,
pos = _a1490, model = _a1489,
}
end
end
table.sort(_a1471, function(_a1493, _a1494) return (_a1493.cost or math.huge) < (_a1494.cost or math.huge) end)
return _a1471
end
function _a576.mach.cycleUpg()
if not _a574.R_Upg then _a563("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a1495 = _a576.mach.upgList()
if #_a1495 == 0 then return end
local _a1496 = 0
for _a1497, _a1498 in ipairs(_a1495) do
if not _a570.mapupg then break end
if _a1498.buyable and _a1498.cost then
local _a1499 = _a611(_a1498.cur or "Diamonds")
if _a1499 - _a569.UpgReserve < _a1498.cost then break end
if _a569.UpgTp and _a1498.pos and _a1498.zone == _a576.move.curZone() then
_a576.move.glideTo(_a1498.pos)
end
local _a1500, _a1501
pcall(function() _a1500, _a1501 = _a574.R_Upg:InvokeServer(_a1498.id, _a1498.zone) end)
if _a1500 then
_a1496 += 1
_a571.mapupg += 1
_a576.ctl.setAct("맵 업글", _a1498.id .. " T" .. _a1498.tier)
_a563(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a1498.id, _a1498.tier, _a1498.zone, _a564(_a1498.cost, 0)))
elseif _a1501 then
_a563(("[맵업글] %s T%d @%s 실패: %s"):format(
_a1498.id, _a1498.tier, _a1498.zone, tostring(_a1501)))
end
task.wait(_a569.ActionGap)
end
end
if _a1496 > 0 then
_a563(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a1496, _a564(_a611("Diamonds"), 0)))
end
end
local function _a1502()
local _a1503 = _a603()
if not _a1503 then return nil end
local _a1504 = tonumber(rawget(_a1503, "Rebirths")) or 0
local _a1505 = _a1504 + 1
local _a1506
if _a574.Rebirth and rawget(_a574.Rebirth, "GetNextRebirth") then
local _a1507, _a1508 = pcall(_a574.Rebirth.GetNextRebirth, _a1503)
if _a1507 then _a1506 = _a1508 end
end
return { current = _a1504, nextN = _a1505, def = _a1506 }
end
local function _a1509()
if not _a574.R_Reb then _a563("[리버스] Rebirth_Request 리모트 없음") return end
local _a1510 = _a1502()
if not _a1510 then
_a576.auto.rebNote = "세이브를 못 읽음"
return
end
local _a1511, _a1512
pcall(function() _a1511, _a1512 = _a574.R_Reb:InvokeServer(_a1510.nextN) end)
if _a1511 then
_a571.mreb += 1
_a576.auto.rebNote, _a576.auto.rebSaid = nil, nil
_a563(("  ★ 리버스 %d → %d"):format(_a1510.current, _a1510.nextN))
task.wait(0.5)
_a576.screen.dismissRewardScreens(25)
else
_a576.auto.rebNote = ("%d → %d : %s"):format(_a1510.current, _a1510.nextN,
_a1512 and tostring(_a1512) or "조건 미달 (리버스 킬/존 요구치)")
if _a576.auto.rebSaid ~= _a576.auto.rebNote then
_a576.auto.rebSaid = _a576.auto.rebNote
_a563("[리버스] " .. _a576.auto.rebNote)
end
end
end
_a576.auto.SIDE = {
{ key = "unlock", label = "알 해금",   run = "mhatch", fn = function() _a576.egg.unlockEggs() end },
{ key = "slots",  label = "슬롯 머신", run = "slots",  fn = function() _a576.mach.cycleSlots() end },
{ key = "mapupg", label = "맵 업그레이드", run = "mapupg", fn = function() _a576.mach.cycleUpg() end },
{ key = "items",  label = "버프 유지",     run = "items",  fn = function() _a576.item.cycleItems() end },
}
_a576.auto.STEPS = {
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a1509() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a639() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a1513 = _a570.farm
_a570.farm = true
pcall(_a621)
_a570.farm = _a1513
local _a1514 = _a576.quest.cycle()
if not _a1514 then
local _a1515 = _a576.move.bestZone()
if _a1515 then
local _a1516, _a1517 = _a576.move.goToZone(_a1515)
if not _a1516 then
if _a1517 and _a576.auto.idleMoveSaid ~= tostring(_a1517) then
_a576.auto.idleMoveSaid = tostring(_a1517)
_a563("[자동] 최고 존 이동 실패: " .. tostring(_a1517))
end
else
_a576.auto.idleMoveSaid = nil
end
end
if not _a569.IdleHatch then
_a576.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a576.move.curZone())))
return
end
local _a1518 = _a669()
local _a1519 = math.max(1, _a569.HatchMinAfford or 10)
if _a1518 and _a1518.price and _a1518.canBuy < _a1519 then
_a576.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a576.move.curZone()), _a1518.canBuy, _a1519,
_a564(_a1518.price, 0), tostring(_a1518.currency)))
else
_a576.ctl.setAct("대기 중 부화")
local _a1520 = _a570.mhatch
_a570.mhatch = true
pcall(_a680)
_a570.mhatch = _a1520
end
end
end },
}
_a569.StepOn = {}
for _a1521, _a1522 in ipairs(_a576.auto.SIDE) do _a569.StepOn[_a1522.key] = true end
for _a1523, _a1524 in ipairs(_a576.auto.STEPS) do _a569.StepOn[_a1524.key] = true end
local function _a1525(_a1526, _a1527, _a1528, _a1529)
if not _a569.StepOn[_a1526.key] then
_a1529[#_a1529 + 1] = ("%-14s 꺼져있음"):format(_a1526.label)
return
end
if _a1526.hold and _a1527 then
_a1529[#_a1529 + 1] = ("%-14s 보류 (%s)"):format(
_a1526.label, _a1528 and tostring(_a1528.title) or "?")
if _a576.auto.heldMsg ~= _a1526.key then
_a576.auto.heldMsg = _a1526.key
_a563(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a1526.label, _a1528 and tostring(_a1528.title) or "?"))
end
return
end
if _a1526.hold then _a576.auto.heldMsg = nil end
_a576.auto.step = _a1526.label
_a576.ctl.now.step = _a1526.label
_a576.ctl.setAct("시작", _a1526.label)
local _a1530 = os.clock()
local _a1531 = _a570[_a1526.run]
_a570[_a1526.run] = true
local _a1532, _a1533 = pcall(_a1526.fn)
_a570[_a1526.run] = _a1531
local _a1534 = os.clock() - _a1530
if not _a1532 then
_a1529[#_a1529 + 1] = ("%-14s 오류: %s"):format(_a1526.label, tostring(_a1533))
_a563("[자동] " .. _a1526.label .. " 오류: " .. tostring(_a1533))
else
local _a1535 = (_a1526.key == "zone" and _a576.auto.zoneNote)
or (_a1526.key == "mreb" and _a576.auto.rebNote) or nil
_a1529[#_a1529 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a1526.label, _a1534, _a1535 and ("  → " .. _a1535) or "")
end
end
function _a576.auto.master()
local _a1536 = {}
_a576.auto.lastTrace = _a1536
_a576.auto.lastPassAt = os.clock()
if _a576.screen.rewardScreenUp() then
_a1536[#_a1536 + 1] = "보상 화면 넘기는 중"
_a576.screen.dismissRewardScreens(15)
end
for _a1537, _a1538 in ipairs(_a576.auto.SIDE) do
if not _a570.auto or _a576.ctl.stopped() then return end
_a1525(_a1538, false, nil, _a1536)
end
local _a1539, _a1540 = false, nil
if _a569.HoldZoneForQuest then _a1539, _a1540 = _a576.quest.bestDepActive() end
for _a1541, _a1542 in ipairs(_a576.auto.STEPS) do
if not _a570.auto or _a576.ctl.stopped() then break end
_a1525(_a1542, _a1539, _a1540, _a1536)
end
_a576.auto.step = nil
if not _a576.ctl.lockGoal then
_a576.ctl.now.step = "대기"
_a576.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a569.AutoInterval or 5))
end
local _a1543 = {}
for _a1544, _a1545 in ipairs(_a1536) do _a1543[#_a1543 + 1] = (_a1545:gsub("[%d%.]+초", "")) end
_a1543 = table.concat(_a1543, " | ")
if _a1543 ~= _a576.auto.lastSig then
_a576.auto.lastSig = _a1543
_a563("[자동] 바퀴 " .. (_a576.auto.passN or 0))
for _a1546, _a1547 in ipairs(_a1536) do _a563("    " .. _a1547) end
end
_a576.auto.passN = (_a576.auto.passN or 0) + 1
end
local function _a1548()
if not _a568.R_PROMO then _a563("[타워업글] 리모트 없음") return end
local _a1549 = _a572()
if not _a1549 then return end
local _a1550 = _a573(_a1549)
table.sort(_a1550, function(_a1551, _a1552) return (_a1551.dps or 0) > (_a1552.dps or 0) end)
local _a1553, _a1554 = 0, 0
for _a1555, _a1556 in ipairs(_a1550) do
if not _a570.towerup then break end
if _a1556.id then
local _a1557
pcall(function() _a1557 = _a568.R_PROMO:InvokeServer(_a1556.id) end)
if _a1557 ~= nil and _a1557 ~= false then
_a1553 += 1
_a563(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1556.kind), tostring(_a1556.up), tostring((_a1556.up or 0) + 1)))
_a1554 = 0
task.wait(_a569.ActionGap)
else
_a1554 += 1
if _a1554 >= 5 then break end
end
end
end
_a563("[타워업글] " .. _a1553 .. "건")
end
local _a1558 = {}
local _a1559 = {}
local function _a1560(_a1561, _a1562)
local _a1563 = tostring(_a1562)
local _a1564 = _a1559[_a1561]
if _a1564 and _a1564.msg == _a1563 then
_a1564.n += 1
if _a1564.n % 20 == 0 then
_a563(("[%s 오류] %s   (%d회 반복)"):format(_a1561, _a1563, _a1564.n))
end
return
end
_a1559[_a1561] = { msg = _a1563, n = 1 }
_a563("[" .. _a1561 .. " 오류] " .. _a1563)
end
local function _a1565(_a1566, _a1567, _a1568, _a1569)
_a1558[_a1566] = (_a1558[_a1566] or 0) + 1
local _a1570 = _a1558[_a1566]
task.spawn(function()
while _a570[_a1566] and _a1558[_a1566] == _a1570 do
local _a1571, _a1572 = pcall(_a1568)
if not _a1571 then _a1560(_a1569, _a1572) else _a1559[_a1569] = nil end
local _a1573, _a1574 = _a1567(), 0
while _a1574 < _a1573 and _a570[_a1566] and _a1558[_a1566] == _a1570 do task.wait(0.1) _a1574 += 0.1 end
end
if _a1558[_a1566] == _a1570 then _a563("[" .. _a1569 .. "] 중지") end
end)
end
do
local _a1575 = {
farm   = { function() return _a569.FarmInterval end,      function() _a621() end,      "파밍" },
zone   = { function() return _a569.ZoneInterval end,      function() _a639() end,      "존" },
mhatch = { function() return _a569.MainHatchInterval end, function() _a680() end, "부화" },
}
function _a576.auto.turnOn(_a1576, _a1577)
if _a570.auto then return end
if _a570[_a1576] then return end
local _a1578 = _a1575[_a1576]
if not _a1578 then return end
_a570[_a1576] = true
_a1565(_a1576, _a1578[1], _a1578[2], _a1578[3])
if _a576.auto.refresh then _a576.auto.refresh() end
_a563("[퀘스트] " .. tostring(_a1577) .. " ON")
end
end
_a559.MG, _a559.QS, _a559.saveGet, _a559.currencyAmount, _a559.cycleFarm, _a559.zoneStatus = _a574, _a576, _a603, _a611, _a621, _a635
_a559.cycleZone, _a559.bestMainEgg, _a559.mainHatchStatus, _a559.cycleMainHatch, _a559.mainRebirthStatus, _a559.cycleMainRebirth = _a639, _a644, _a669, _a680, _a1502, _a1509
_a559.cycleTowerUp, _a559.startLoop = _a1548, _a1565
end)(_a1)
;(function(_a1579)
local _a1580, _a1581, _a1582, _a1583, _a1584, _a1585 = _a1579.UIS, _a1579.RunService, _a1579.LP, _a1579.LOG, _a1579.log, _a1579.num
local _a1586, _a1587, _a1588, _a1589, _a1590, _a1591 = _a1579.RM, _a1579.CFG, _a1579.EGG_COST_CACHE, _a1579.RUN, _a1579.STAT, _a1579.EVENT_UPGRADES
local _a1592, _a1593, _a1594, _a1595, _a1596, _a1597 = _a1579.ctx, _a1579.collectSlots, _a1579.placedTowers, _a1579.availableItems, _a1579.cyclePlace, _a1579.cycleMerchant
local _a1598, _a1599, _a1600, _a1601, _a1602, _a1603 = _a1579.sunflowers, _a1579.eventTiers, _a1579.nextCost, _a1579.cycleUpgrade, _a1579.seedInv, _a1579.bedsOf
local _a1604, _a1605, _a1606, _a1607, _a1608, _a1609 = _a1579.isUnhatched, _a1579.bedCps, _a1579.cycleCrop, _a1579.laneCosts, _a1579.lockedBeds, _a1579.cycleExpand
local _a1610, _a1611, _a1612, _a1613, _a1614 = _a1579.rebirthStatus, _a1579.cycleRebirth, _a1579.hatchStatus, _a1579.cycleHatch, _a1579.LUCK_ORDER
local _a1615, _a1616, _a1617, _a1618, _a1619, _a1620 = _a1579.luckStatus, _a1579.fmtDur, _a1579.cycleLuck, _a1579.MG, _a1579.QS, _a1579.saveGet
local _a1621, _a1622, _a1623, _a1624, _a1625, _a1626 = _a1579.currencyAmount, _a1579.cycleFarm, _a1579.zoneStatus, _a1579.cycleZone, _a1579.bestMainEgg, _a1579.mainHatchStatus
local _a1627, _a1628, _a1629, _a1630, _a1631 = _a1579.cycleMainHatch, _a1579.mainRebirthStatus, _a1579.cycleMainRebirth, _a1579.cycleTowerUp, _a1579.startLoop
local _a1632 = {
bg      = Color3.fromRGB(18, 19, 24),
panel   = Color3.fromRGB(26, 28, 35),
card    = Color3.fromRGB(32, 35, 43),
cardHi  = Color3.fromRGB(38, 42, 52),
line    = Color3.fromRGB(52, 57, 70),
text    = Color3.fromRGB(232, 236, 243),
dim     = Color3.fromRGB(138, 146, 163),
accent  = Color3.fromRGB(94, 156, 255),
good    = Color3.fromRGB(72, 199, 132),
warn    = Color3.fromRGB(240, 176, 64),
bad     = Color3.fromRGB(238, 92, 92),
sun     = Color3.fromRGB(255, 205, 84),
}
local function _a1633(_a1634, _a1635, _a1636)
local _a1637 = Instance.new(_a1634)
for _a1638, _a1639 in pairs(_a1635) do _a1637[_a1638] = _a1639 end
if _a1636 then _a1637.Parent = _a1636 end
return _a1637
end
local function _a1640(_a1641, _a1642) _a1633("UICorner", { CornerRadius = UDim.new(0, _a1642 or 8) }, _a1641) end
local function _a1643(_a1644, _a1645, _a1646)
_a1633("UIStroke", { Color = _a1645 or _a1632.line, Thickness = _a1646 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _a1644)
end
local function _a1647(_a1648, _a1649)
_a1633("UIPadding", {
PaddingTop = UDim.new(0, _a1649), PaddingBottom = UDim.new(0, _a1649),
PaddingLeft = UDim.new(0, _a1649), PaddingRight = UDim.new(0, _a1649),
}, _a1648)
end
local _a1650 = _a1633("ScreenGui", {
Name = "PS99GardenAuto", ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset = true, DisplayOrder = 9999,
})
local _a1651 = false
if type(gethui) == "function" then _a1651 = pcall(function() _a1650.Parent = gethui() end) end
if not _a1651 then _a1651 = pcall(function() _a1650.Parent = game:GetService("CoreGui") end) end
if not _a1651 then _a1650.Parent = _a1582:WaitForChild("PlayerGui") end
local _a1652, _a1653 = 780, 520
local _a1654 = _a1633("Frame", {
Size = UDim2.fromOffset(_a1652, _a1653), Position = UDim2.new(0.5, -_a1652 / 2, 0.5, -_a1653 / 2),
BackgroundColor3 = _a1632.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, _a1650)
_a1640(_a1654, 12)
_a1643(_a1654, Color3.fromRGB(60, 66, 82), 1)
local _a1655 = _a1633("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = _a1632.panel, BorderSizePixel = 0,
}, _a1654)
_a1640(_a1655, 12)
_a1633("Frame", {
Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
BackgroundColor3 = _a1632.panel, BorderSizePixel = 0,
}, _a1655)
_a1633("Frame", {
Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(14, 15),
BackgroundColor3 = _a1632.good, BorderSizePixel = 0,
}, _a1655).Name = "Dot"
_a1640(_a1655:FindFirstChild("Dot"), 5)
_a1633("TextLabel", {
Size = UDim2.new(0, 320, 1, 0), Position = UDim2.fromOffset(32, 0),
BackgroundTransparency = 1, Text = "Garden Defenders  AutoPlay",
TextColor3 = _a1632.text, TextSize = 14, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1655)
local function _a1656(_a1657, _a1658, _a1659, _a1660)
local _a1661 = _a1633("TextButton", {
Size = UDim2.new(0, _a1660, 0, 24), Position = UDim2.new(1, _a1659, 0, 8),
BackgroundColor3 = _a1658, BorderSizePixel = 0, Text = _a1657,
TextColor3 = _a1632.text, TextSize = 12, Font = Enum.Font.GothamMedium,
AutoButtonColor = true,
}, _a1655)
_a1640(_a1661, 6)
return _a1661
end
local _a1662 = _a1656("✕", _a1632.bad, -38, 28)
local _a1663   = _a1656("—", _a1632.card, -70, 28)
local _a1664 = _a1656("지우기", _a1632.card, -132, 58)
local _a1665  = _a1656("복사", _a1632.accent, -190, 54)
local _a1666  = _a1656("정지", _a1632.bad, -252, 58)
_a1666.MouseButton1Click:Connect(function()
_a1619.ctl.stopAll()
if _a1619.auto.refresh then pcall(_a1619.auto.refresh) end
_a1584("[정지] 모든 동작을 멈췄습니다")
end)
local _a1667 = _a1633("ScrollingFrame", {
Size = UDim2.new(0, 152, 1, -92), Position = UDim2.fromOffset(10, 48),
BackgroundColor3 = _a1632.panel, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = _a1632.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1654)
_a1640(_a1667, 8)
_a1633("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, _a1667)
_a1633("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, _a1667)
local _a1668 = _a1633("Frame", {
Size = UDim2.new(1, -182, 1, -92), Position = UDim2.fromOffset(172, 48),
BackgroundTransparency = 1,
}, _a1654)
local _a1669, _a1670 = {}, nil
local _a1671, _a1672 = {}, {}
local _a1673 = {}
local function _a1674(_a1675)
_a1670 = _a1675
for _a1676, _a1677 in pairs(_a1669) do _a1677.Visible = (_a1676 == _a1675) end
for _a1678, _a1679 in pairs(_a1671) do
local _a1680 = (_a1678 == _a1675)
_a1679.BackgroundColor3 = _a1680 and _a1632.accent or _a1632.panel
_a1679.TextColor3 = _a1680 and Color3.fromRGB(255, 255, 255) or _a1632.dim
end
local _a1681 = _a1672[_a1675]
if _a1681 and _a1673[_a1681] and not _a1673[_a1681].open then _a1673[_a1681].toggle() end
end
local function _a1682(_a1683, _a1684, _a1685)
local _a1686 = { open = true, kids = {} }
local _a1687 = _a1633("TextButton", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = _a1632.bg, BorderSizePixel = 0,
Text = "", TextColor3 = _a1632.dim, TextSize = 11,
Font = Enum.Font.GothamBold, LayoutOrder = _a1685, AutoButtonColor = false,
}, _a1667)
_a1640(_a1687, 5)
local _a1688 = _a1633("TextLabel", {
Size = UDim2.fromOffset(14, 26), Position = UDim2.fromOffset(6, 0),
BackgroundTransparency = 1, Text = "▾", TextColor3 = _a1632.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1687)
_a1633("TextLabel", {
Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(20, 0),
BackgroundTransparency = 1, Text = _a1684, TextColor3 = _a1632.dim,
TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1687)
function _a1686.toggle()
_a1686.open = not _a1686.open
_a1688.Text = _a1686.open and "▾" or "▸"
for _a1689, _a1690 in ipairs(_a1686.kids) do _a1690.Visible = _a1686.open end
end
_a1687.MouseButton1Click:Connect(_a1686.toggle)
_a1673[_a1683] = _a1686
return _a1686
end
local function _a1691(_a1692, _a1693, _a1694, _a1695)
local _a1696 = _a1695 and 14 or 6
local _a1697 = _a1633("TextButton", {
Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = _a1632.panel, BorderSizePixel = 0,
Text = "", TextColor3 = _a1632.dim, TextSize = 12,
Font = Enum.Font.GothamMedium, LayoutOrder = _a1694, AutoButtonColor = false,
}, _a1667)
_a1640(_a1697, 5)
local _a1698 = _a1633("TextLabel", {
Size = UDim2.new(1, -_a1696 - 4, 1, 0), Position = UDim2.fromOffset(_a1696, 0),
BackgroundTransparency = 1, Text = _a1693, TextColor3 = _a1632.dim,
TextSize = 12, Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1697)
_a1671[_a1692] = _a1697
if _a1695 then
_a1672[_a1692] = _a1695
local _a1699 = _a1673[_a1695]
if _a1699 then
table.insert(_a1699.kids, _a1697)
_a1697.Visible = _a1699.open
end
end
local _a1700 = _a1633("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false,
BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1632.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1668)
_a1633("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1700)
_a1633("UIPadding", { PaddingRight = UDim.new(0, 8) }, _a1700)
_a1669[_a1692] = _a1700
_a1697.MouseButton1Click:Connect(function() _a1674(_a1692) end)
_a1697.MouseEnter:Connect(function()
if _a1670 ~= _a1692 then _a1697.BackgroundColor3 = _a1632.card end
end)
_a1697.MouseLeave:Connect(function()
if _a1670 ~= _a1692 then _a1697.BackgroundColor3 = _a1632.panel end
end)
_a1697:GetPropertyChangedSignal("TextColor3"):Connect(function()
_a1698.TextColor3 = _a1697.TextColor3
end)
return _a1700
end
local _a1701 = 0
local function _a1702()
_a1701 += 1
return _a1701
end
local function _a1703(_a1704, _a1705)
local _a1706 = _a1633("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = _a1702(),
}, _a1704)
_a1633("Frame", {
Size = UDim2.fromOffset(3, 14), Position = UDim2.fromOffset(0, 7),
BackgroundColor3 = _a1632.accent, BorderSizePixel = 0,
}, _a1706)
_a1633("TextLabel", {
Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1, Text = _a1705, TextColor3 = _a1632.text,
TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1706)
return _a1706
end
local function _a1707(_a1708, _a1709, _a1710)
local _a1711 = _a1633("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = _a1632.card, BorderSizePixel = 0, LayoutOrder = _a1702(),
}, _a1708)
_a1640(_a1711, 8)
_a1643(_a1711, _a1632.line, 1)
_a1647(_a1711, 12)
_a1633("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1711)
if _a1709 then
local _a1712 = _a1633("Frame", {
Size = UDim2.new(1, 0, 0, _a1710 and 32 or 22), BackgroundTransparency = 1,
LayoutOrder = 0,
}, _a1711)
_a1633("TextLabel", {
Size = UDim2.new(1, -70, 0, 16), BackgroundTransparency = 1, Text = _a1709,
TextColor3 = _a1632.text, TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1712)
if _a1710 then
_a1633("TextLabel", {
Size = UDim2.new(1, -70, 0, 13), Position = UDim2.fromOffset(0, 17),
BackgroundTransparency = 1, Text = _a1710, TextColor3 = _a1632.dim,
TextSize = 11, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, _a1712)
end
_a1711:SetAttribute("HeadHeight", _a1710 and 32 or 18)
return _a1711, _a1712
end
return _a1711
end
local _a1713 = {}
local function _a1714()
for _a1715, _a1716 in pairs(_a1713) do pcall(_a1716) end
end
_a1619.auto.refresh = _a1714
local function _a1717(_a1718, _a1719, _a1720)
local _a1721 = _a1633("TextButton", {
Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -46, 0, 0),
BackgroundColor3 = _a1632.cardHi, BorderSizePixel = 0, Text = "",
AutoButtonColor = false,
}, _a1718)
_a1640(_a1721, 12)
local _a1722 = _a1633("Frame", {
Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
BackgroundColor3 = _a1632.dim, BorderSizePixel = 0,
}, _a1721)
_a1640(_a1722, 9)
local _a1723 = _a1633("TextLabel", {
Size = UDim2.fromOffset(46, 12), Position = UDim2.fromOffset(0, 26),
BackgroundTransparency = 1, Text = "OFF", TextColor3 = _a1632.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1721)
local function _a1724()
local _a1725 = _a1589[_a1719]
_a1721.BackgroundColor3 = _a1725 and _a1632.good or _a1632.cardHi
_a1722:TweenPosition(UDim2.fromOffset(_a1725 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a1722.BackgroundColor3 = _a1725 and Color3.fromRGB(255, 255, 255) or _a1632.dim
_a1723.Text = _a1725 and "ON" or "OFF"
_a1723.TextColor3 = _a1725 and _a1632.good or _a1632.dim
end
_a1721.MouseButton1Click:Connect(function()
_a1589[_a1719] = not _a1589[_a1719]
if _a1589[_a1719] then
if _a1719 == "auto" then _a1619.ctl.abort = false end
_a1724()
_a1584("[" .. _a1719 .. "] 시작")
local _a1726, _a1727 = pcall(_a1720)
if not _a1726 then _a1584("[에러] " .. tostring(_a1727)) end
else
if _a1719 == "auto" then
_a1619.ctl.stopAll()
_a1584("[정지] 모든 동작을 멈췄습니다")
end
_a1724()
end
end)
_a1724()
_a1713[_a1719] = _a1724
return _a1721, _a1724
end
local function _a1728(_a1729, _a1730)
local _a1731 = _a1633("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = _a1702(),
}, _a1729)
local _a1732 = #_a1730
for _a1733, _a1734 in ipairs(_a1730) do
local _a1735 = _a1633("Frame", {
Size = UDim2.new(1 / _a1732, -6, 1, 0), Position = UDim2.new((_a1733 - 1) / _a1732, 3, 0, 0),
BackgroundTransparency = 1,
}, _a1731)
_a1633("TextLabel", {
Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = _a1734.label,
TextColor3 = _a1632.dim, TextSize = 10, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1735)
local _a1736 = _a1633("TextBox", {
Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 15),
BackgroundColor3 = _a1632.bg, BorderSizePixel = 0, Text = tostring(_a1734.value),
TextColor3 = _a1632.text, TextSize = 12, Font = Enum.Font.Code,
ClearTextOnFocus = false,
}, _a1735)
_a1640(_a1736, 5)
_a1643(_a1736, _a1632.line, 1)
_a1736.FocusLost:Connect(function() _a1734.onChange(_a1736.Text, _a1736) end)
end
return _a1731
end
local function _a1737(_a1738, _a1739)
local _a1740 = _a1633("Frame", {
Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = _a1702(),
}, _a1738)
local _a1741 = #_a1739
for _a1742, _a1743 in ipairs(_a1739) do
local _a1744 = _a1633("TextButton", {
Size = UDim2.new(1 / _a1741, -5, 1, 0), Position = UDim2.new((_a1742 - 1) / _a1741, 2.5, 0, 0),
BackgroundColor3 = _a1743.col or _a1632.cardHi, BorderSizePixel = 0, Text = _a1743.label,
TextColor3 = _a1632.text, TextSize = 12, Font = Enum.Font.GothamMedium,
}, _a1740)
_a1640(_a1744, 6)
_a1744.MouseButton1Click:Connect(function()
local _a1745, _a1746 = pcall(_a1743.fn, _a1744)
if not _a1745 then _a1584("[에러] " .. tostring(_a1743.label) .. " → " .. tostring(_a1746)) end
end)
end
return _a1740
end
local function _a1747(_a1748, _a1749, _a1750, _a1751)
local _a1752 = _a1633("TextButton", {
Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = _a1632.cardHi, BorderSizePixel = 0,
Text = "", TextColor3 = _a1632.text, TextSize = 12, Font = Enum.Font.GothamMedium,
LayoutOrder = _a1702(),
}, _a1748)
_a1640(_a1752, 6)
local function _a1753()
local _a1754 = _a1750()
_a1752.Text = _a1749 .. "   " .. (_a1754 and "ON" or "OFF")
_a1752.BackgroundColor3 = _a1754 and Color3.fromRGB(40, 78, 58) or _a1632.cardHi
_a1752.TextColor3 = _a1754 and _a1632.good or _a1632.dim
end
_a1752.MouseButton1Click:Connect(function()
_a1751(not _a1750())
_a1753()
end)
_a1753()
return _a1752
end
local _a1755 = _a1691("log", "로그", 90)
local _a1756
do
local _a1757 = _a1633("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a1702(),
}, _a1755)
_a1640(_a1757, 8)
_a1643(_a1757, _a1632.line, 1)
local _a1758 = _a1633("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -10), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1632.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1757)
_a1756 = _a1633("TextLabel", {
Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(196, 208, 196),
TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
TextWrapped = true,
}, _a1758)
_a1755.AutomaticCanvasSize = Enum.AutomaticSize.None
_a1755.CanvasSize = UDim2.new()
end
do
local _a1759, _a1760, _a1761, _a1762
_a1655.InputBegan:Connect(function(_a1763)
if _a1763.UserInputType == Enum.UserInputType.MouseButton1
or _a1763.UserInputType == Enum.UserInputType.Touch then
_a1759, _a1760, _a1761 = true, _a1763.Position, _a1654.Position
_a1763.Changed:Connect(function()
if _a1763.UserInputState == Enum.UserInputState.End then _a1759 = false end
end)
end
end)
_a1655.InputChanged:Connect(function(_a1764)
if _a1764.UserInputType == Enum.UserInputType.MouseMovement
or _a1764.UserInputType == Enum.UserInputType.Touch then _a1762 = _a1764 end
end)
_a1580.InputChanged:Connect(function(_a1765)
if _a1759 and _a1765 == _a1762 then
local _a1766 = _a1765.Position - _a1760
_a1654.Position = UDim2.new(_a1761.X.Scale, _a1761.X.Offset + _a1766.X,
_a1761.Y.Scale, _a1761.Y.Offset + _a1766.Y)
end
end)
local _a1767 = false
_a1663.MouseButton1Click:Connect(function()
_a1767 = not _a1767
_a1654:TweenSize(_a1767 and UDim2.fromOffset(_a1652, 40) or UDim2.fromOffset(_a1652, _a1653),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a1663.Text = _a1767 and "▢" or "—"
end)
end
local _a1768 = _a1581.Heartbeat:Connect(function()
if not _a1579.dirty then return end
_a1579.dirty = false
local _a1769 = #_a1583
_a1756.Text = table.concat(table.move(_a1583, math.max(1, _a1769 - 300), _a1769, 1, {}), "\n")
end)
local _a1770 = _a1691("dash", "대시보드", 10)
local _a1771 = _a1691("event", "이벤트", 20)
do
local _a1772 = _a1707(_a1770, "전체 제어", nil)
_a1737(_a1772, {
{ label = "권장 전부 ON", col = _a1632.good, fn = function()
for _a1773, _a1774 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a1589[_a1774] then
_a1589[_a1774] = true
if _a1774 == "place"    then _a1631(_a1774, function() return _a1587.PlaceInterval end, _a1596, "배치") end
if _a1774 == "merchant" then _a1631(_a1774, function() return _a1587.MerchantInterval end, _a1597, "구매") end
if _a1774 == "crop"     then _a1631(_a1774, function() return _a1587.CropInterval end, _a1606, "씨앗") end
if _a1774 == "expand"   then _a1631(_a1774, function() return _a1587.ExpandInterval end, _a1609, "확장") end
if _a1774 == "hatch"    then _a1631(_a1774, function() return _a1587.HatchInterval end, _a1613, "뽑기") end
end
end
_a1714()
_a1584("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a1632.bad, fn = function()
_a1589.place, _a1589.merchant, _a1589.upgrade = false, false, false
_a1589.towerup, _a1589.crop, _a1589.expand, _a1589.rebirth, _a1589.hatch, _a1589.luck = false, false, false, false, false, false
_a1589.farm, _a1589.zone, _a1589.mhatch, _a1589.rank, _a1589.mreb = false, false, false, false, false
_a1714()
_a1584("[전체] 정지")
end },
})
local _a1775 = _a1707(_a1770, "현황", nil)
_a1737(_a1775, {
{ label = "밭 / 타워", col = _a1632.accent, fn = function()
local _a1776, _a1777, _a1778, _a1779 = _a1592()
_a1584("")
_a1584("──── 현재 상태 ────")
_a1584("레인 " .. tostring(_a1779) .. " / plot " .. (_a1778 and "O" or "X")
.. " / world " .. (_a1776 and "O" or "X"))
local _a1780 = _a1593(_a1778, _a1779)
local _a1781 = _a1594(_a1776)
_a1584("슬롯 " .. #_a1780 .. " / 배치 " .. #_a1781)
local _a1782, _a1783 = 0, {}
for _a1784, _a1785 in ipairs(_a1781) do
_a1782 += (_a1785.dps or 0)
_a1783[tostring(_a1785.kind)] = (_a1783[tostring(_a1785.kind)] or 0) + 1
end
_a1584("총 DPS " .. _a1585(_a1782))
for _a1786, _a1787 in pairs(_a1783) do _a1584("  " .. _a1786 .. " × " .. _a1787) end
local _a1788 = _a1595()
_a1584("")
_a1584("배치 가능 " .. #_a1788 .. "종")
for _a1789 = 1, math.min(10, #_a1788) do
local _a1790 = _a1788[_a1789]
_a1584(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a1790.id), tostring(_a1790.vr or "-"), tostring(_a1790.copies), _a1585(_a1790.dps)))
end
_a1674("log")
end },
{ label = "로그 보기", col = _a1632.cardHi, fn = function() _a1674("log") end },
})
end
do
local _a1791, _a1792 = _a1707(_a1771, "자동 배치 / 교체", nil)
_a1717(_a1792, "place", function()
_a1631("place", function() return _a1587.PlaceInterval end, _a1596, "배치")
end)
_a1728(_a1791, {
{ label = "주기", value = _a1587.PlaceInterval, onChange = function(_a1793)
local _a1794 = tonumber(_a1793) if _a1794 and _a1794 >= 3 then _a1587.PlaceInterval = _a1794 end
end },
{ label = "교체 배수", value = _a1587.SwapMargin, onChange = function(_a1795)
local _a1796 = tonumber(_a1795) if _a1796 and _a1796 >= 1 then _a1587.SwapMargin = _a1796 _a1584("[설정] 교체 배수 " .. _a1796) end
end },
{ label = "DoT 반영", value = _a1587.DotFactor, onChange = function(_a1797)
local _a1798 = tonumber(_a1797) if _a1798 and _a1798 >= 0 and _a1798 <= 1 then _a1587.DotFactor = _a1798 end
end },
})
_a1747(_a1791, "업글 타워 보호",
function() return _a1587.ProtectUpgraded end,
function(_a1799) _a1587.ProtectUpgraded = _a1799
_a1584("[설정] 업글 보호 " .. (_a1799 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a1737(_a1791, {
{ label = "지금 1회 실행", col = _a1632.accent, fn = function()
task.spawn(function() _a1589.place = true _a1596() _a1589.place = false _a1674("log") end)
end },
})
end
do
local _a1800, _a1801 = _a1707(_a1771, "머천트 자동 구매", nil)
_a1717(_a1801, "merchant", function()
_a1631("merchant", function() return _a1587.MerchantInterval end, _a1597, "구매")
end)
_a1728(_a1800, {
{ label = "머천트 ID", value = _a1587.MerchantId, onChange = function(_a1802)
if _a1802 ~= "" then _a1587.MerchantId = _a1802 _a1584("[설정] 머천트 " .. _a1802) end
end },
{ label = "주기", value = _a1587.MerchantInterval, onChange = function(_a1803)
local _a1804 = tonumber(_a1803) if _a1804 and _a1804 >= 5 then _a1587.MerchantInterval = _a1804 end
end },
})
_a1737(_a1800, {
{ label = "지금 1회 구매", col = _a1632.accent, fn = function()
task.spawn(function() _a1589.merchant = true _a1597() _a1589.merchant = false _a1674("log") end)
end },
})
end
do
local _a1805, _a1806 = _a1707(_a1771, "업그레이드 머신", nil)
_a1717(_a1806, "upgrade", function()
_a1631("upgrade", function() return _a1587.UpgradeInterval end, _a1601, "머신업글")
end)
_a1728(_a1805, {
{ label = "주기", value = _a1587.UpgradeInterval, onChange = function(_a1807)
local _a1808 = tonumber(_a1807) if _a1808 and _a1808 >= 5 then _a1587.UpgradeInterval = _a1808 end
end },
{ label = "최소 잔액", value = _a1587.MinSunflowers, onChange = function(_a1809)
local _a1810 = tonumber(_a1809) if _a1810 and _a1810 >= 0 then _a1587.MinSunflowers = _a1810
_a1584("[설정] 최소 잔액 " .. _a1585(_a1810, 0)) end
end },
})
_a1747(_a1805, "가격 미상 구매",
function() return _a1587.BuyUnknownCost end,
function(_a1811) _a1587.BuyUnknownCost = _a1811 end)
_a1737(_a1805, {
{ label = "업글 현황 보기", col = _a1632.accent, fn = function()
local _a1812 = _a1598()
local _a1813 = _a1599()
_a1590.sun = _a1812
_a1584("")
_a1584("──── 업그레이드 머신 ────")
_a1584("Sunflowers = " .. _a1585(_a1812, 0))
local _a1814 = {}
for _a1815, _a1816 in ipairs(_a1591) do
local _a1817 = _a1813[_a1816] or 0
_a1814[#_a1814 + 1] = { id = _a1816, tier = _a1817, cost = _a1600(_a1816, _a1817) }
end
table.sort(_a1814, function(_a1818, _a1819)
return (_a1818.cost or math.huge) < (_a1819.cost or math.huge)
end)
for _a1820, _a1821 in ipairs(_a1814) do
_a1584(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a1821.id, tostring(_a1821.tier), _a1821.cost and _a1585(_a1821.cost, 0) or "?",
(_a1821.cost and _a1821.cost <= _a1812) and "← 구매가능" or ""))
end
_a1674("log")
end },
{ label = "지금 1회 업글", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.upgrade = true _a1601() _a1589.upgrade = false _a1674("log") end)
end },
})
local _a1822, _a1823 = _a1707(_a1771, "타워 개별 업글", nil)
_a1717(_a1823, "towerup", function()
_a1631("towerup", function() return _a1587.UpgradeInterval end, _a1630, "타워업글")
end)
end
do
local _a1824, _a1825 = _a1707(_a1771, "자동 뽑기", nil)
_a1717(_a1825, "hatch", function()
_a1631("hatch", function() return _a1587.HatchInterval end, _a1613, "뽑기")
end)
_a1728(_a1824, {
{ label = "주기", value = _a1587.HatchInterval, onChange = function(_a1826)
local _a1827 = tonumber(_a1826) if _a1827 and _a1827 >= 1 then _a1587.HatchInterval = _a1827 end
end },
{ label = "한 번에 최대", value = _a1587.HatchMax, onChange = function(_a1828)
local _a1829 = tonumber(_a1828) if _a1829 and _a1829 >= 1 then _a1587.HatchMax = math.floor(_a1829) end
end },
})
_a1728(_a1824, {
{ label = "예비금", value = _a1587.HatchReserve, onChange = function(_a1830)
local _a1831 = tonumber(_a1830) if _a1831 and _a1831 >= 0 then _a1587.HatchReserve = _a1831
_a1584("[설정] 뽑기 예비금 " .. _a1585(_a1831, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a1587.HatchEggNum, onChange = function(_a1832)
local _a1833 = tonumber(_a1832) if _a1833 and _a1833 >= 0 and _a1833 <= 12 then
_a1587.HatchEggNum = math.floor(_a1833)
table.clear(_a1588)
_a1584("[설정] 알 번호 " .. (_a1833 == 0 and "자동" or _a1833)) end
end },
})
_a1737(_a1824, {
{ label = "뽑기 현황 보기", col = _a1632.accent, fn = function()
local _a1834 = _a1612()
_a1590.sun = _a1834.sun
_a1584("")
_a1584("──── 뽑기 현황 ────")
_a1584("  알 등급     " .. _a1834.id)
_a1584("  알 uid      " .. tostring(_a1834.uid))
_a1584("  개당 비용   " .. (_a1834.cost and _a1585(_a1834.cost, 0) or "?"))
_a1584("  Sunflowers  " .. _a1585(_a1834.sun, 0))
_a1584("  예비금      " .. _a1585(_a1587.HatchReserve, 0))
_a1584("  지금 가능   " .. _a1834.canBuy .. "회")
_a1584("")
_a1584("  월드의 알 " .. _a1834.eggCount .. "개")
for _a1835, _a1836 in ipairs(_a1834.eggs) do
if _a1835 > 5 then break end
_a1584(("    %s  거리 %s"):format(_a1836.uid, _a1585(_a1836.dist)))
end
_a1584("")
_a1584("  누적 뽑기   " .. _a1590.hatched .. "회")
_a1674("log")
end },
{ label = "지금 1회 실행", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.hatch = true _a1613() _a1589.hatch = false _a1674("log") end)
end },
})
end
do
local _a1837, _a1838 = _a1707(_a1771, "럭 상시 최대 유지", nil)
_a1717(_a1838, "luck", function()
_a1631("luck", function() return _a1587.LuckInterval end, _a1617, "럭")
end)
_a1728(_a1837, {
{ label = "주기", value = _a1587.LuckInterval, onChange = function(_a1839)
local _a1840 = tonumber(_a1839) if _a1840 and _a1840 >= 60 then _a1587.LuckInterval = _a1840 end
end },
{ label = "예비금", value = _a1587.LuckReserve, onChange = function(_a1841)
local _a1842 = tonumber(_a1841) if _a1842 and _a1842 >= 0 then _a1587.LuckReserve = _a1842 end
end },
})
_a1728(_a1837, {
{ label = "최소 부족분", value = _a1587.LuckMinTopUp, onChange = function(_a1843)
local _a1844 = tonumber(_a1843) if _a1844 and _a1844 >= 0 then _a1587.LuckMinTopUp = _a1844 end
end },
})
for _a1845, _a1846 in ipairs(_a1614) do
_a1747(_a1837, _a1846,
function() return _a1587.LuckBoosts[_a1846] end,
function(_a1847) _a1587.LuckBoosts[_a1846] = _a1847 end)
end
_a1737(_a1837, {
{ label = "럭 현황 보기", col = _a1632.accent, fn = function()
local _a1848 = _a1615()
_a1590.sun = _a1848.sun
_a1584("")
_a1584("──── 이벤트 럭 ────")
_a1584("  머신 활성   " .. (_a1848.enabled and "O" or "X"))
_a1584("  최대 시간   " .. _a1616(_a1848.maxSec))
_a1584("  Sunflowers  " .. _a1585(_a1848.sun, 0))
_a1584("")
for _a1849, _a1850 in ipairs(_a1848.rows) do
_a1584(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a1850.rarity, _a1616(_a1850.left), _a1616(_a1850.deficit), _a1585(_a1850.need, 0),
_a1850.on and "" or "   (꺼짐)"))
end
_a1584("")
_a1584("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a1674("log")
end },
{ label = "지금 1회 충전", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.luck = true _a1617() _a1589.luck = false _a1674("log") end)
end },
})
end
do
local _a1851, _a1852 = _a1707(_a1771, "자동 씨앗 교체", nil)
_a1717(_a1852, "crop", function()
_a1631("crop", function() return _a1587.CropInterval end, _a1606, "씨앗")
end)
_a1728(_a1851, {
{ label = "주기", value = _a1587.CropInterval, onChange = function(_a1853)
local _a1854 = tonumber(_a1853) if _a1854 and _a1854 >= 5 then _a1587.CropInterval = _a1854 end
end },
{ label = "갈아엎기 배수", value = _a1587.CropMargin, onChange = function(_a1855)
local _a1856 = tonumber(_a1855) if _a1856 and _a1856 >= 1 then _a1587.CropMargin = _a1856 _a1584("[설정] 작물 배수 " .. _a1856) end
end },
})
_a1747(_a1851, "성장중 건너뛰기",
function() return _a1587.SkipUnhatched end,
function(_a1857) _a1587.SkipUnhatched = _a1857 end)
_a1737(_a1851, {
{ label = "밭 현황 보기", col = _a1632.accent, fn = function()
local _a1858, _a1859 = _a1592()
if not _a1859 then _a1584("[씨앗] 밭 없음") _a1674("log") return end
local _a1860, _a1861 = _a1603(_a1859), _a1602()
_a1584("")
_a1584("──── 밭 현황 ────")
_a1584("보유 씨앗 (기대 초당수익 순)")
for _a1862, _a1863 in ipairs(_a1861) do
_a1584(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a1863.id), tostring(_a1863.vr or "-"), tostring(_a1863.am), _a1585(_a1863.exp)))
end
local _a1864, _a1865, _a1866, _a1867, _a1868 = 0, 0, 0, 0, 0
local _a1869 = _a1861[1]
local _a1870 = _a1869 and _a1869.exp or 0
_a1584("")
_a1584("심어진 작물")
local _a1871 = 0
for _a1872, _a1873 in pairs(_a1860) do
_a1864 += 1
local _a1874 = _a1605(_a1873) or 0
_a1865 += _a1874
if _a1604(_a1873) then _a1867 += 1
elseif _a1870 > _a1874 * _a1587.CropMargin then _a1866 += 1
else _a1868 += 1 end
_a1871 += 1
if _a1871 <= 20 then
_a1584(("  칸%-4s %-20s %s/s%s"):format(tostring(_a1872),
tostring(rawget(_a1873, "sp") or "?"), _a1585(_a1874),
_a1604(_a1873) and "  (자라는 중)" or ""))
end
end
if _a1864 > 20 then _a1584("  ... (" .. (_a1864 - 20) .. "칸 더)") end
_a1584("")
_a1584(("총 %d칸 / 합계 %s per sec"):format(_a1864, _a1585(_a1865)))
_a1584(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a1866, _a1868, _a1867))
_a1674("log")
end },
{ label = "지금 1회 실행", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.crop = true _a1606() _a1589.crop = false _a1674("log") end)
end },
})
end
do
local _a1875, _a1876 = _a1707(_a1771, "자동 확장", nil)
_a1717(_a1876, "expand", function()
_a1631("expand", function() return _a1587.ExpandInterval end, _a1609, "확장")
end)
_a1728(_a1875, {
{ label = "주기", value = _a1587.ExpandInterval, onChange = function(_a1877)
local _a1878 = tonumber(_a1877) if _a1878 and _a1878 >= 5 then _a1587.ExpandInterval = _a1878 end
end },
{ label = "밭칸 스캔", value = _a1587.MaxBedScan, onChange = function(_a1879)
local _a1880 = tonumber(_a1879) if _a1880 and _a1880 >= 1 then _a1587.MaxBedScan = math.floor(_a1880) end
end },
})
_a1737(_a1875, {
{ label = "확장 현황 보기", col = _a1632.accent, fn = function()
local _a1881, _a1882, _a1883, _a1884 = _a1592()
if not _a1882 then _a1584("[확장] 밭 없음") _a1674("log") return end
local _a1885 = _a1598()
_a1590.sun = _a1885
local _a1886 = _a1607(true)
_a1584("")
_a1584("──── 확장 현황 ────")
_a1584("Sunflowers = " .. _a1585(_a1885, 0))
_a1584("")
_a1584("레인 " .. tostring(_a1884) .. "개 열림")
local _a1887 = {}
for _a1888 in pairs(_a1886) do _a1887[#_a1887 + 1] = tonumber(_a1888) or _a1888 end
table.sort(_a1887, function(_a1889, _a1890) return tostring(_a1889) < tostring(_a1890) end)
for _a1891, _a1892 in ipairs(_a1887) do
local _a1893 = _a1886[_a1892] or _a1886[tostring(_a1892)]
local _a1894 = tonumber(_a1892) or 0
local _a1895 = (_a1894 == (tonumber(_a1884) or 0) + 1)
and ((tonumber(_a1893) or math.huge) <= _a1885 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a1894 <= (tonumber(_a1884) or 0) and "  (열림)" or "")
_a1584(("  레인 %-3s %s%s"):format(tostring(_a1892), _a1585(tonumber(_a1893) or 0, 0), _a1895))
end
local _a1896 = _a1608(_a1882)
_a1584("")
_a1584("잠긴 밭칸 " .. #_a1896 .. "개 (싼 순 8개)")
for _a1897 = 1, math.min(8, #_a1896) do
local _a1898 = _a1896[_a1897]
_a1584(("  칸 %-4s %s%s"):format(_a1898.id, _a1898.cost and _a1585(_a1898.cost, 0) or "?",
(_a1898.cost and _a1898.cost <= _a1885) and "  ← 오픈 가능" or ""))
end
if #_a1896 == 0 then _a1584("  (전부 열려 있음)") end
_a1674("log")
end },
{ label = "지금 1회 실행", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.expand = true _a1609() _a1589.expand = false _a1674("log") end)
end },
})
end
do
local _a1899, _a1900 = _a1707(_a1771, "자동 리버스", nil)
_a1717(_a1900, "rebirth", function()
_a1631("rebirth", function() return _a1587.RebirthInterval end, _a1611, "리버스")
end)
_a1728(_a1899, {
{ label = "주기", value = _a1587.RebirthInterval, onChange = function(_a1901)
local _a1902 = tonumber(_a1901) if _a1902 and _a1902 >= 10 then _a1587.RebirthInterval = _a1902 end
end },
})
_a1737(_a1899, {
{ label = "리버스 현황 보기", col = _a1632.accent, fn = function()
local _a1903 = _a1610()
_a1584("")
_a1584("──── 리버스 현황 ────")
if not _a1903 then _a1584("  밭 없음") _a1674("log") return end
_a1584(("  현재 리버스   %d회  (최대 %s)"):format(_a1903.regrows, tostring(_a1903.cap)))
_a1584(("  레인          %d / 7 %s"):format(_a1903.lanes, _a1903.lanes >= 7 and "OK" or "부족"))
_a1584(("  코인보스      %d / %d %s"):format(_a1903.kills, _a1903.need,
_a1903.kills >= _a1903.need and "OK" or "부족"))
_a1584("")
_a1584(_a1903.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a1903.reason)))
_a1674("log")
end },
{ label = "지금 1회 리버스", col = _a1632.bad, fn = function()
task.spawn(function() _a1589.rebirth = true _a1611() _a1589.rebirth = false _a1674("log") end)
end },
})
end
local _a1904 = _a1691("main", "메인 게임", 30)
do
local _a1905, _a1906 = _a1707(_a1904, "올 자동", nil)
local _a1907 = _a1633("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a1632.cardHi,
BorderSizePixel = 0, LayoutOrder = _a1702(),
}, _a1905)
_a1640(_a1907, 6)
_a1647(_a1907, 8)
local _a1908 = _a1633("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a1632.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a1907)
task.spawn(function()
while _a1650 and _a1650.Parent do
local _a1909 = _a1619.ctl.now
local _a1910 = _a1589.auto and "🟢" or "⚪"
local _a1911 = _a1909.act or "-"
if _a1909.detail and _a1909.detail ~= "" then _a1911 = _a1911 .. "  " .. _a1909.detail end
_a1908.Text = table.concat({
_a1910 .. " " .. (_a1589.auto and (_a1909.step or "-") or "정지"),
"▸ " .. _a1911,
"목표 " .. (_a1909.goal or "-") .. (_a1909.prog ~= "" and ("   " .. _a1909.prog) or ""),
"1.리버스 " .. (_a1619.auto.rebNote or "-"),
"2.존해금 " .. (_a1619.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a1619.auto.farmZone or "-") .. "   현재 " .. tostring(_a1619.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a1619.auto.start()
for _a1912, _a1913 in ipairs(_a1619.auto.STEPS) do _a1589[_a1913.run] = false end
for _a1914, _a1915 in ipairs(_a1619.auto.SIDE) do _a1589[_a1915.run] = false end
_a1589.petspd = true
_a1589.rewatch = true
_a1714()
_a1631("auto", function() return _a1587.AutoInterval end, _a1619.auto.master, "자동")
end
_a1717(_a1906, "auto", _a1619.auto.start)
_a1728(_a1905, {
{ label = "주기", value = _a1587.AutoInterval, onChange = function(_a1916)
local _a1917 = tonumber(_a1916) if _a1917 and _a1917 >= 1 then _a1587.AutoInterval = _a1917 end
end },
{ label = "정체 판정(초)", value = _a1587.PursueStallSec, onChange = function(_a1918)
local _a1919 = tonumber(_a1918) if _a1919 and _a1919 >= 10 then _a1587.PursueStallSec = _a1919 end
end },
})
_a1728(_a1905, {
{ label = "운 퀘 최소 알 개수", value = _a1587.HatchMinAfford, onChange = function(_a1920)
local _a1921 = tonumber(_a1920) if _a1921 and _a1921 >= 1 then _a1587.HatchMinAfford = math.floor(_a1921) end
end },
{ label = "더 버는 시간(초)", value = _a1587.MoneyDwell, onChange = function(_a1922)
local _a1923 = tonumber(_a1922) if _a1923 and _a1923 >= 0 then _a1587.MoneyDwell = _a1923 end
end },
})
_a1728(_a1905, {
{ label = "부화 한 번에(초)", value = _a1587.HatchBudget, onChange = function(_a1924)
local _a1925 = tonumber(_a1924) if _a1925 and _a1925 >= 3 then _a1587.HatchBudget = _a1925 end
end },
})
_a1728(_a1905, {
{ label = "이동 방식", value = _a1587.TpMode, onChange = function(_a1926)
_a1926 = tostring(_a1926 or ""):lower()
if _a1926 == "instant" or _a1926 == "glide" or _a1926 == "walk" then _a1587.TpMode = _a1926 end
end },
{ label = "glide 속도", value = _a1587.TpSpeed, onChange = function(_a1927)
local _a1928 = tonumber(_a1927) if _a1928 and _a1928 >= 16 then _a1587.TpSpeed = _a1928 end
end },
})
_a1747(_a1905, "차단 화면에 실제 클릭까지 시도",
function() return _a1587.ScreenRealClick end,
function(_a1929) _a1587.ScreenRealClick = _a1929 end)
_a1747(_a1905, "퀘스트 없을 때도 알 까기",
function() return _a1587.IdleHatch end,
function(_a1930) _a1587.IdleHatch = _a1930 end)
_a1747(_a1905, "존 해금·리버스는 퀘스트 끝나고",
function() return _a1587.HoldZoneForQuest end,
function(_a1931) _a1587.HoldZoneForQuest = _a1931 end)
for _a1932, _a1933 in ipairs(_a1619.auto.STEPS) do
local _a1934 = _a1933.key
_a1747(_a1905, "  " .. _a1932 .. ". " .. _a1933.label,
function() return _a1587.StepOn[_a1934] end,
function(_a1935) _a1587.StepOn[_a1934] = _a1935 end)
end
for _a1936, _a1937 in ipairs(_a1619.auto.SIDE) do
local _a1938 = _a1937.key
_a1747(_a1905, "  · " .. _a1937.label .. " (순위 밖)",
function() return _a1587.StepOn[_a1938] end,
function(_a1939) _a1587.StepOn[_a1938] = _a1939 end)
end
_a1737(_a1905, {
{ label = "지금 상태", col = _a1632.accent, fn = function()
_a1584("")
_a1584("──── 올 자동 ────")
_a1584("  " .. (_a1589.auto and "돌아가는 중" or "정지") ..
(_a1619.auto.step and ("   지금: " .. _a1619.auto.step) or ""))
local _a1940, _a1941 = _a1619.quest.bestDepActive()
_a1584("  현재 존 " .. tostring(_a1619.move.curZone()) .. " / 최고 존 " .. tostring(_a1619.move.bestZone()))
if _a1940 then
_a1584("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a1941 and _a1941.title))
else
_a1584("  존해금·리버스 진행 가능")
end
_a1584("")
_a1584("  먼저 (순위 밖):")
for _a1942, _a1943 in ipairs(_a1619.auto.SIDE) do
_a1584(("      %-16s %s"):format(_a1943.label, _a1587.StepOn[_a1943.key] and "ON" or "off"))
end
_a1584("  우선순위:")
for _a1944, _a1945 in ipairs(_a1619.auto.STEPS) do
_a1584(("    %d. %-16s %s%s"):format(_a1944, _a1945.label,
_a1587.StepOn[_a1945.key] and "ON" or "off",
_a1945.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a1584("")
_a1584("  마지막 바퀴 (" .. tostring(_a1619.auto.passN or 0) .. "번째)")
if _a1619.auto.lastPassAt then
_a1584(("    %.0f초 전"):format(os.clock() - _a1619.auto.lastPassAt))
else
_a1584("    아직 한 바퀴도 안 돎 — 루프가 안 돌고 있습니다")
end
for _a1946, _a1947 in ipairs(_a1619.auto.lastTrace or {}) do _a1584("    " .. _a1947) end
_a1674("log")
end },
{ label = "화면 넘기기 진단", col = _a1632.warn, fn = function()
task.spawn(function()
_a1584("")
_a1584("──── 보상 화면 ────")
local _a1948 = _a1618.Vars
_a1584("  Library.Variables : " .. (_a1948 and "로드됨" or "없음"))
if _a1948 then
_a1584("    IsRebirthing = " .. tostring(rawget(_a1948, "IsRebirthing")))
_a1584("    IsRankingUp  = " .. tostring(rawget(_a1948, "IsRankingUp")))
_a1584("    OpeningEgg   = " .. tostring(rawget(_a1948, "OpeningEgg")))
end
_a1584("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a1584("  getgc          : " .. tostring(type(getgc) == "function"))
_a1584("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a1949 = _a1582:FindFirstChildOfClass("PlayerGui")
if _a1949 then
_a1584("  떠 있는 차단 화면:")
local _a1950 = false
for _a1951, _a1952 in ipairs(_a1619.screen.BLOCKERS) do
local _a1953 = _a1949:FindFirstChild(_a1952[1])
_a1584(("    %-14s %s"):format(_a1952[1],
_a1953 and (_a1953.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a1953 and _a1953.Enabled then _a1950 = true end
end
if not _a1950 then _a1584("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a1584("")
_a1584("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a1954, _a1955 = {}, 0
for _a1956, _a1957 in ipairs({ true, false }) do
local _a1958, _a1959 = pcall(getgc, _a1957)
if _a1958 then
for _a1960, _a1961 in ipairs(_a1959) do
if type(_a1961) == "function" and _a1955 < 25 then
local _a1962, _a1963 = pcall(debug.info, _a1961, "s")
if _a1962 and type(_a1963) == "string"
and (_a1963:find("Rebirth", 1, true) or _a1963:find("Rank Up", 1, true)) then
local _a1964, _a1965 = pcall(debug.info, _a1961, "a")
if _a1964 then
local _a1966 = {}
for _a1967 = 1, 16 do
local _a1968, _a1969 = pcall(debug.getupvalue, _a1961, _a1967)
if not _a1968 then break end
_a1966[_a1967] = type(_a1969)
end
local _a1970 = ("인자%d | %s"):format(_a1965 or -1,
#_a1966 > 0 and table.concat(_a1966, ",") or "(없음)")
if not _a1954[_a1970] then
_a1954[_a1970] = true
_a1955 += 1
_a1584("    " .. _a1970)
end
end
end
end
end
end
end
if _a1955 == 0 then _a1584("    (하나도 못 찾음)") end
end
for _a1971, _a1972 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a1619.screen._sig = nil
local _a1973 = _a1619.screen.findSignalFns(_a1972)
_a1584("")
_a1584(("  [%s] 찾은 함수 %d개"):format(_a1972, #_a1973))
for _a1974, _a1975 in ipairs(_a1973) do
_a1584(("    %s%s"):format(_a1975.exact and "★정확일치 " or "", tostring(_a1975.src)))
_a1584(("       upvalue %d개 : %s"):format(_a1975.n or 0, tostring(_a1975.sig)))
end
if #_a1973 == 0 then
_a1584("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a1976, _a1977 = _a1619.screen.signal(_a1972)
_a1584(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a1976), tostring(_a1977)))
local _a1978 = _a1619.screen.SIGNAL[_a1972]
_a1584(("    게임내 입력발동 : %s"):format(
tostring(_a1619.screen.pressInGame(_a1978 and _a1978.pats or {}))))
end
_a1584("")
_a1584("  감시 루프 RUN.rewatch = " .. tostring(_a1589.rewatch))
_a1674("log")
end)
end },
{ label = "한 바퀴만", col = _a1632.cardHi, fn = function()
task.spawn(function()
_a1589.auto = true _a1619.auto.master() _a1589.auto = false _a1674("log")
end)
end },
{ label = "자동 점검", col = _a1632.warn, fn = function()
task.spawn(function()
_a1584("")
_a1584("════ 올 자동 점검 ════")
_a1584("  RUN.auto = " .. tostring(_a1589.auto))
local _a1979 = {}
for _a1980, _a1981 in ipairs(_a1619.auto.SIDE) do
_a1979[#_a1979 + 1] = _a1981.key .. "=" .. tostring(_a1587.StepOn[_a1981.key])
end
for _a1982, _a1983 in ipairs(_a1619.auto.STEPS) do
_a1979[#_a1979 + 1] = _a1983.key .. "=" .. tostring(_a1587.StepOn[_a1983.key])
end
_a1584("  단계 ON/OFF : " .. table.concat(_a1979, "  "))
_a1584("  lockGoal    : " .. (_a1619.ctl.lockGoal and tostring(_a1619.ctl.lockGoal.q.title) or "없음"))
local _a1984, _a1985 = _a1619.quest.bestDepActive()
_a1584("  보류중?     : " .. tostring(_a1984) .. (_a1985 and ("  ← " .. tostring(_a1985.title)) or ""))
_a1584("  리모트      : 존 " .. (_a1618.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a1618.R_Reb and "O" or "X"))
_a1584("")
_a1584("  ── 존 해금 판정 ──")
local _a1986 = _a1623()
if not _a1986 then
_a1584("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a1987 = _a1618.Zone and rawget(_a1618.Zone, "GetNextZone")
if _a1987 then
local _a1988, _a1989, _a1990 = pcall(_a1618.Zone.GetNextZone)
_a1584("    GetNextZone → ok=" .. tostring(_a1988)
.. " / " .. tostring(_a1989) .. " / " .. tostring(_a1990))
end
if _a1618.Zone and rawget(_a1618.Zone, "HasCompletedNextZoneQuests") then
local _a1991, _a1992 = pcall(_a1618.Zone.HasCompletedNextZoneQuests)
_a1584("    존 퀘스트 완료? " .. (_a1991 and tostring(_a1992) or ("에러 " .. tostring(_a1992))))
end
else
_a1584("    다음 존 : " .. tostring(_a1986.id))
_a1584(("    가격 %s %s / 보유 %s → %s"):format(
_a1585(_a1986.price or 0, 0), tostring(_a1986.currency), _a1585(_a1986.have, 0),
_a1986.ok and "지금 살 수 있음" or "부족"))
end
_a1584("")
_a1584("  ── 리버스 판정 ──")
local _a1993 = _a1628()
if not _a1993 then _a1584("    세이브 못 읽음")
else
_a1584(("    현재 %d → 다음 %d"):format(_a1993.current, _a1993.nextN))
_a1584("    최근 사유 : " .. tostring(_a1619.auto.rebNote or "-"))
end
_a1584("")
_a1584("  ── 직전 바퀴 기록 ──")
if _a1619.auto.lastTrace and #_a1619.auto.lastTrace > 0 then
for _a1994, _a1995 in ipairs(_a1619.auto.lastTrace) do _a1584("    " .. _a1995) end
_a1584(("    (%.0f초 전)"):format(os.clock() - (_a1619.auto.lastPassAt or os.clock())))
else
_a1584("    아직 한 바퀴도 안 돌았음")
end
_a1674("log")
end)
end },
})
local _a1996, _a1997 = _a1707(_a1904, "펫 이동속도", nil)
_a1717(_a1997, "petspd", function()
_a1631("petspd", function() return 0.4 end, _a1619.item.applyPetSpeed, "펫속도")
end)
_a1728(_a1996, {
{ label = "배수", value = _a1587.PetSpeedMult, onChange = function(_a1998)
local _a1999 = tonumber(_a1998) if _a1999 and _a1999 >= 1 then _a1587.PetSpeedMult = _a1999 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a1587.PetSpeedBase, onChange = function(_a2000)
local _a2001 = tonumber(_a2000) if _a2001 and _a2001 > 0 then _a1587.PetSpeedBase = _a2001 end
end },
})
_a1737(_a1996, {
{ label = "지금 적용 / 확인", col = _a1632.accent, fn = function()
local _a2002, _a2003 = _a1619.item.applyPetSpeed()
_a1584("")
_a1584("──── 펫 이동속도 ────")
_a1584("  PlayerPet 모듈 : " .. (_a1618.PlayerPet and "로드됨" or "없음"))
_a1584(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a2002, tostring(_a1587.PetSpeedMult), tostring(_a1587.PetSpeedBase)))
if _a2003 then _a1584("  " .. tostring(_a2003)) end
if _a2002 == 0 then _a1584("  펫을 장착하고 다시 눌러보세요") end
_a1674("log")
end },
})
_a1631("petspd", function() return 0.4 end, _a1619.item.applyPetSpeed, "펫속도")
_a1631("rewatch", function() return 1 end, function()
_a1619.screen.watchTick = (_a1619.screen.watchTick or 0) + 1
_a1619.egg.watchStuck()
if _a1619.screen.dismissBusy then return end
local _a2004, _a2005 = _a1619.screen.rewardScreenUp()
if _a2004 and _a1619.screen.screenGaveUp and (os.clock() - _a1619.screen.screenGaveUp) < 30 then
return
end
if _a2004 then
if _a1619.screen.lastBlocker ~= _a2005 then
_a1619.screen.lastBlocker = _a2005
_a1584("[화면] " .. tostring(_a2005) .. " 화면 감지 — 넘기는 중")
end
_a1619.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a2006, _a2007 = _a1707(_a1904, "자동 파밍 유지", nil)
_a1717(_a2007, "farm", function()
_a1631("farm", function() return _a1587.FarmInterval end, _a1622, "파밍")
end)
_a1728(_a2006, {
{ label = "주기", value = _a1587.FarmInterval, onChange = function(_a2008)
local _a2009 = tonumber(_a2008) if _a2009 and _a2009 >= 3 then _a1587.FarmInterval = _a2009 end
end },
})
local _a2010, _a2011 = _a1707(_a1904, "자동 존 해금", nil)
_a1717(_a2011, "zone", function()
_a1631("zone", function() return _a1587.ZoneInterval end, _a1624, "존")
end)
_a1728(_a2010, {
{ label = "주기", value = _a1587.ZoneInterval, onChange = function(_a2012)
local _a2013 = tonumber(_a2012) if _a2013 and _a2013 >= 3 then _a1587.ZoneInterval = _a2013 end
end },
})
_a1737(_a2010, {
{ label = "다음 존 보기", col = _a1632.accent, fn = function()
local _a2014 = _a1623()
_a1584("")
if not _a2014 then _a1584("[존] 다음 존 없음 (최대 도달?)")
else
_a1584("──── 다음 존 ────")
_a1584("  " .. tostring(_a2014.id))
_a1584("  가격 " .. _a1585(_a2014.price or 0, 0) .. " " .. tostring(_a2014.currency))
_a1584("  보유 " .. _a1585(_a2014.have, 0))
_a1584("  " .. (_a2014.ok and "지금 해금 가능" or "부족"))
end
_a1674("log")
end },
{ label = "지금 1회", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.zone = true _a1624() _a1589.zone = false _a1674("log") end)
end },
})
local _a2015, _a2016 = _a1707(_a1904, "자동 부화", nil)
_a1717(_a2016, "mhatch", function()
_a1631("mhatch", function() return _a1587.MainHatchInterval end, _a1627, "부화")
end)
_a1728(_a2015, {
{ label = "주기", value = _a1587.MainHatchInterval, onChange = function(_a2017)
local _a2018 = tonumber(_a2017) if _a2018 and _a2018 >= 1 then _a1587.MainHatchInterval = _a2018 end
end },
{ label = "한 번에 최대", value = _a1587.MainHatchMax, onChange = function(_a2019)
local _a2020 = tonumber(_a2019) if _a2020 and _a2020 >= 1 then _a1587.MainHatchMax = math.floor(_a2020) end
end },
})
_a1728(_a2015, {
{ label = "예비금", value = _a1587.MainHatchReserve, onChange = function(_a2021)
local _a2022 = tonumber(_a2021) if _a2022 and _a2022 >= 0 then _a1587.MainHatchReserve = _a2022 end
end },
{ label = "알 ID (비우면 자동)", value = _a1587.MainEggId, onChange = function(_a2023)
_a1587.MainEggId = _a2023 or ""
end },
})
_a1728(_a2015, {
{ label = "알 인식 거리", value = _a1587.EggRange, onChange = function(_a2024)
local _a2025 = tonumber(_a2024) if _a2025 and _a2025 >= 5 then _a1587.EggRange = _a2025 end
end },
})
_a1747(_a2015, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a1587.AutoUnlockEgg end,
function(_a2026) _a1587.AutoUnlockEgg = _a2026 end)
_a1747(_a2015, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a1587.UseAutoHatch end,
function(_a2027) _a1587.UseAutoHatch = _a2027 if not _a2027 then _a1619.egg.autoHatchOff() end end)
_a1747(_a2015, "까는 화면 자동으로 넘기기 (신호)",
function() return _a1587.HatchClick end,
function(_a2028) _a1587.HatchClick = _a2028 end)
_a1737(_a2015, {
{ label = "잠긴 알 보기", col = _a1632.accent, fn = function()
local _a2029, _a2030, _a2031 = _a1619.egg.lockedEggs()
_a1584("")
_a1584("──── 알 해금 현황 ────")
_a1584(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a2030, _a2031))
_a1584("  해금 리모트 : " .. (_a1618.R_EggUn and "있음" or "없음"))
if #_a2029 == 0 then
_a1584("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a1584("  아직 안 푼 알 " .. #_a2029 .. "개:")
for _a2032, _a2033 in ipairs(_a2029) do
_a1584(("    #%-3d %s"):format(_a2033.num, _a2033.id))
if _a2032 >= 20 then _a1584("    ...") break end
end
end
_a1674("log")
end },
{ label = "부화 진단", col = _a1632.warn, fn = function()
task.spawn(function()
_a1584("")
_a1584("──── 부화 진단 ────")
local _a2034, _a2035, _a2036, _a2037 = _a1625()
_a1584("  대상 알   : " .. tostring(_a2034))
if not _a2034 then _a1584("  (오픈한 알이 없음)") _a1674("log") return end
local _a2038 = _a2035 and tonumber(rawget(_a2035, "eggNumber"))
_a1584("  알 번호   : " .. tostring(_a2038) .. "   오픈함? " .. tostring(_a1619.egg.eggUnlocked(_a2038)))
_a1584("  거리      : " .. (_a2036 and ("%.0f (사거리 안)"):format(_a2036)
or ((_a2037 and ("%.0f (사거리 %d 밖)"):format(_a2037, _a1587.EggRange)) or "받침대 못 찾음")))
local _a2039 = _a2035 and rawget(_a2035, "currency") or "?"
_a1584("  통화      : " .. tostring(_a2039) .. "   보유 " .. _a1585(_a1621(_a2039), 0))
if type(_a1618.CalcEgg) == "function" then
local _a2040, _a2041 = pcall(_a1618.CalcEgg, _a2035)
_a1584("  CalcEggPricePlayer : " .. (_a2040 and tostring(_a2041) or ("에러 " .. tostring(_a2041))))
end
if type(_a1618.CalcEggB) == "function" then
local _a2042, _a2043 = pcall(_a1618.CalcEggB, _a2035)
_a1584("  CalcEggPrice       : " .. (_a2042 and tostring(_a2043) or ("에러 " .. tostring(_a2043))))
end
if _a1618.Egg then
for _a2044, _a2045 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a1618.Egg, _a2045) then
local _a2046, _a2047 = pcall(_a1618.Egg[_a2045], _a2035)
_a1584(("  %-28s : %s"):format(_a2045, _a2046 and tostring(_a2047) or ("에러 " .. tostring(_a2047))))
end
end
end
_a1584("  OpeningEgg      : " .. tostring(_a1618.Vars and rawget(_a1618.Vars, "OpeningEgg")))
if _a1618.Hatch then
for _a2048, _a2049 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a1618.Hatch, _a2049) then
local _a2050, _a2051 = pcall(_a1618.Hatch[_a2049])
_a1584(("  %-15s : %s"):format(_a2049, _a2050 and tostring(_a2051) or ("에러 " .. tostring(_a2051))))
end
end
if rawget(_a1618.Hatch, "GetEggDirectory") then
local _a2052, _a2053 = pcall(_a1618.Hatch.GetEggDirectory)
_a1584("  세팅된 알       : " .. (_a2052 and _a2053 and tostring(rawget(_a2053, "_id")) or "없음"))
end
end
_a1584("  ▶ SetupEgg 시도")
_a1619.egg._ahEgg = nil
_a1619.egg.autoHatchOn(_a2034, 1)
if _a1618.Hatch and rawget(_a1618.Hatch, "IsHatching") then
local _a2054, _a2055 = pcall(_a1618.Hatch.IsHatching)
_a1584("    IsHatching 이후 : " .. (_a2054 and tostring(_a2055) or ("에러 " .. tostring(_a2055))))
_a1584("    " .. ((_a2054 and _a2055) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a1584("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a1584("")
_a1584("  ▶ 1개로 실제 호출")
local _a2056, _a2057
local _a2058 = pcall(function() _a2056, _a2057 = _a1586.R_EGG:InvokeServer(_a2034, 1) end)
_a1584("    호출성공 : " .. tostring(_a2058))
_a1584("    반환1    : " .. tostring(_a2056))
_a1584("    반환2    : " .. tostring(_a2057))
_a1674("log")
end)
end },
{ label = "지금 전부 해금", col = _a1632.good, fn = function()
task.spawn(function()
_a1584("")
local _a2059, _a2060 = _a1619.egg.unlockEggs(true)
_a1584(_a2059 > 0 and ("[해금] %d개 완료"):format(_a2059)
or ("[해금] 0개" .. (_a2060 and (" — " .. tostring(_a2060)) or "")))
_a1674("log")
end)
end },
})
_a1737(_a2015, {
{ label = "알 현황 보기", col = _a1632.accent, fn = function()
local _a2061 = _a1626()
_a1584("")
if not _a2061 then _a1584("[부화] 알을 못 찾음")
else
_a1584("──── 메인 알 ────")
_a1584("  " .. tostring(_a2061.id))
_a1584("  가격 " .. (_a2061.price and _a1585(_a2061.price, 0) or "?") .. " " .. tostring(_a2061.currency))
_a1584("  보유 " .. _a1585(_a2061.have, 0))
_a1584("  한 번에 " .. _a2061.maxN .. "개까지")
_a1584("  지금 가능 " .. _a2061.canBuy .. "회")
if _a2061.inRange then
_a1584(("  거리 %.0f 스터드 — 부화 가능"):format(_a2061.dist))
else
_a1584(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a1587.EggRange, _a2061.nearest and ("%.0f"):format(_a2061.nearest) or "?"))
_a1584("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a1584("")
_a1584("──── 주변 알 (가까운 순 10개) ────")
local _a2062 = _a1619.egg.eggStands()
for _a2063 = 1, math.min(10, #_a2062) do
local _a2064 = _a2062[_a2063]
_a1584(("  %6.0f  #%-3d %-24s %s"):format(
_a2064.dist, _a2064.num, _a2064.id, _a1619.egg.eggUnlocked(_a2064.num) and "오픈함" or "잠김"))
end
if #_a2062 == 0 then _a1584("  (못 찾음)") end
_a1674("log")
end },
{ label = "지금 1회", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.mhatch = true _a1627() _a1589.mhatch = false _a1674("log") end)
end },
})
local _a2065, _a2066 = _a1707(_a1904, "랭크 퀘스트 자동", nil)
_a1717(_a2066, "quest", function()
_a1631("quest", function() return _a1587.QuestInterval end, _a1619.quest.cycle, "퀘스트")
end)
_a1728(_a2065, {
{ label = "주기", value = _a1587.QuestInterval, onChange = function(_a2067)
local _a2068 = tonumber(_a2067) if _a2068 and _a2068 >= 5 then _a1587.QuestInterval = _a2068 end
end },
{ label = "포션 한 번에", value = _a1587.QuestUseMax, onChange = function(_a2069)
local _a2070 = tonumber(_a2069) if _a2070 and _a2070 >= 1 then _a1587.QuestUseMax = math.floor(_a2070) end
end },
})
_a1747(_a2065, "필요한 자동화 자동 ON",
function() return _a1587.QuestDrive end,
function(_a2071) _a1587.QuestDrive = _a2071 end)
_a1747(_a2065, "포션/인챈트 업글 퀘스트",
function() return _a1587.QuestUpgrade end,
function(_a2072) _a1587.QuestUpgrade = _a2072 end)
_a1747(_a2065, "포션 사용 퀘스트",
function() return _a1587.QuestUsePotion end,
function(_a2073) _a1587.QuestUsePotion = _a2073 end)
_a1737(_a2065, {
{ label = "퀘스트 현황 보기", col = _a1632.accent, fn = function()
local _a2074 = _a1619.quest.status()
_a1584("")
if not _a2074 then _a1584("[퀘스트] 세이브 못 읽음")
else
_a1584("──── 랭크 퀘스트 ────")
_a1584(("  Rank %d   ★%d"):format(_a2074.rank, _a2074.rankStars))
if #_a2074.list == 0 then _a1584("  퀘스트 없음") end
for _a2075, _a2076 in ipairs(_a2074.list) do
local _a2077 = _a2076.how
local _a2078 =
(_a2077 == "farm" and "자동 파밍") or
(_a2077 == "hatch" and "자동 부화") or
(_a2077 == "zone" and "자동 존") or
(_a2077 == "potup" and "포션 업글") or
(_a2077 == "encup" and "인챈트 업글") or
(_a2077 == "potuse" and "포션 사용") or
(_a2077 == "fruituse" and "과일 사용") or
(_a2077 == "flaguse" and "깃발 사용") or
(_a2077 == "gold" and "골드 머신") or
(_a2077 == "rainbow" and "레인보우 머신") or
"수동"
local _a2079 = ""
if _a2076.ignored then
_a2078 = "무시"
_a2079 = "   → " .. _a2076.ignored
elseif _a2076.event then
local _a2080 = _a1619.ev.findEvent(_a2076.event, _a2076.bestOnly)
_a2079 = _a2080 and ("   → %s @%s %d초"):format(_a2080.name, tostring(_a2080.zone), _a2080.left)
or ("   → " .. _a2076.event .. " 대기중")
elseif _a2076.chest then
_a2079 = "   → " .. _a2076.chest
elseif _a2076.where then
_a2079 = "   → " .. _a2076.where
end
_a1584(("  [%d] %s"):format(_a2076.stars, tostring(_a2076.title)))
_a1584(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a2076.progress, _a2076.amount, _a2078, _a2076.type, _a2079))
end
end
_a1674("log")
end },
{ label = "활성 이벤트 보기", col = _a1632.accent, fn = function()
local _a2081 = _a1619.ev.events()
local _a2082 = _a1619.move.bestZone()
_a1584("")
_a1584("──── 지금 떠 있는 랜덤 이벤트 ────")
_a1584("  최고 존 : " .. tostring(_a2082) .. "   현재 존 : " .. tostring(_a1619.move.curZone()))
if #_a2081 == 0 then _a1584("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a2083, _a2084 in ipairs(_a2081) do
_a1584(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a2084.kind, tostring(_a2084.zone), _a2084.left,
_a2084.pos and ("(%.0f, %.0f, %.0f)"):format(_a2084.pos.X, _a2084.pos.Y, _a2084.pos.Z) or "좌표없음",
_a2084.zone == _a2082 and "  ★최고존" or ""))
end
_a1584("")
_a1584("  내 소환 아이템 :")
for _a2085 in pairs(_a1619.ev.SPAWN) do
local _a2086 = _a1619.ev.spawnItems(_a2085)
local _a2087 = 0
for _a2088, _a2089 in ipairs(_a2086) do _a2087 += _a2089.am end
_a1584(("    %-12s %d종 %d개"):format(_a2085, #_a2086, _a2087))
for _a2090, _a2091 in ipairs(_a2086) do
_a1584(("        %d. %-24s x%d%s"):format(
_a2090, _a2091.id, _a2091.am, _a2090 == 1 and "   ← 먼저 씀" or ""))
if _a2090 >= 6 then break end
end
end
_a1584("  점선 네모 안? " .. tostring(_a1619.move.inDottedBox()))
for _a2092, _a2093 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a2094, _a2095 = _a1619.ev.findChest(_a2093)
_a1584(("  %-20s %s"):format(_a2093,
_a2094 and ("가장 가까운 것 %.0f스터드"):format(_a2095 or 0) or "없음"))
end
_a1674("log")
end },
{ label = "포션 재고 보기", col = _a1632.accent, fn = function()
_a1584("")
_a1584("──── 포션 / 인챈트 재고 ────")
for _a2096, _a2097 in ipairs({ "Potion", "Enchant" }) do
local _a2098 = _a1619.item.stacks(_a2097)
table.sort(_a2098, function(_a2099, _a2100)
if _a2099.id ~= _a2100.id then return _a2099.id < _a2100.id end
return _a2099.tier < _a2100.tier
end)
_a1584("")
_a1584(_a2097 .. "  (" .. #_a2098 .. "종)")
for _a2101, _a2102 in ipairs(_a2098) do
local _a2103 = _a1619.item.perTier(_a2097, _a2102.tier)
local _a2104 = _a2103 and math.floor(_a2102.am / _a2103) or 0
_a1584(("   %-20s T%-2d x%-6d %s"):format(
_a2102.id, _a2102.tier, _a2102.am,
_a2104 > 0 and ("→ T" .. (_a2102.tier + 1) .. " " .. _a2104 .. "개 제작가능") or ""))
if _a2101 >= 40 then _a1584("   ...") break end
end
if #_a2098 == 0 then _a1584("   (없음)") end
end
_a1674("log")
end },
{ label = "지금 1회", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.quest = true _a1619.quest.cycle() _a1589.quest = false _a1674("log") end)
end },
})
local _a2105, _a2106 = _a1707(_a1904, "슬롯 머신 자동 (다이아)", nil)
_a1717(_a2106, "slots", function()
_a1631("slots", function() return _a1587.SlotInterval end, _a1619.mach.cycleSlots, "슬롯")
end)
_a1728(_a2105, {
{ label = "주기", value = _a1587.SlotInterval, onChange = function(_a2107)
local _a2108 = tonumber(_a2107) if _a2108 and _a2108 >= 5 then _a1587.SlotInterval = _a2108 end
end },
{ label = "남길 다이아", value = _a1587.SlotReserve, onChange = function(_a2109)
local _a2110 = tonumber(_a2109) if _a2110 and _a2110 >= 0 then _a1587.SlotReserve = _a2110 end
end },
})
_a1747(_a2105, "펫 장착 슬롯 (Pet Equip)",
function() return _a1587.SlotPet end, function(_a2111) _a1587.SlotPet = _a2111 end)
_a1747(_a2105, "알 부화 슬롯 (Egg Machine)",
function() return _a1587.SlotEgg end, function(_a2112) _a1587.SlotEgg = _a2112 end)
_a1737(_a2105, {
{ label = "슬롯 현황 보기", col = _a1632.accent, fn = function()
local _a2113 = _a1619.mach.slotStatus()
_a1584("")
_a1584("──── 슬롯 머신 ────")
if not _a2113 then _a1584("  세이브 못 읽음") _a1674("log") return end
_a1584("  다이아 " .. _a1585(_a2113.dia, 0))
_a1584("")
_a1584(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a2113.petOwned, _a2113.petMax, tostring(_a2113.maxEquip)))
if _a2113.petNext then
_a1584(("     다음 #%d  %s 다이아  %s"):format(
_a2113.petNext, _a2113.petCost and _a1585(_a2113.petCost, 0) or "?",
(_a2113.petCost and _a2113.petCost <= _a2113.dia - _a1587.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1584("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a1584("")
_a1584(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a2113.eggOwned, _a2113.eggMax, tostring(_a2113.maxHatch)))
if _a2113.eggEnd then
_a1584(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a2113.eggSize, _a2113.eggEnd, _a2113.eggCost and _a1585(_a2113.eggCost, 0) or "?",
(_a2113.eggCost and _a2113.eggCost <= _a2113.dia - _a1587.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1584("     랭크 상한까지 다 삼")
end
_a1584("")
_a1584("  리모트 : 펫 " .. (_a1618.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a1618.R_EggSlot and "O" or "X"))
_a1674("log")
end },
{ label = "지금 1회", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.slots = true _a1619.mach.cycleSlots() _a1589.slots = false _a1674("log") end)
end },
})
local _a2114, _a2115 = _a1707(_a1904, "아이템 자동 사용 (버프 유지)", nil)
_a1717(_a2115, "items", function()
_a1631("items", function() return _a1587.ItemInterval end, _a1619.item.cycleItems, "아이템")
end)
_a1728(_a2114, {
{ label = "주기", value = _a1587.ItemInterval, onChange = function(_a2116)
local _a2117 = tonumber(_a2116) if _a2117 and _a2117 >= 5 then _a1587.ItemInterval = _a2117 end
end },
{ label = "포션 한 바퀴 최대", value = _a1587.BuffMaxPotion, onChange = function(_a2118)
local _a2119 = tonumber(_a2118) if _a2119 and _a2119 >= 1 then _a1587.BuffMaxPotion = math.floor(_a2119) end
end },
})
_a1728(_a2114, {
{ label = "남길 개수", value = _a1587.ItemKeep, onChange = function(_a2120)
local _a2121 = tonumber(_a2120) if _a2121 and _a2121 >= 0 then _a1587.ItemKeep = math.floor(_a2121) end
end },
{ label = "과일/소모품 최대", value = _a1587.BuffMaxOther, onChange = function(_a2122)
local _a2123 = tonumber(_a2122) if _a2123 and _a2123 >= 1 then _a1587.BuffMaxOther = math.floor(_a2123) end
end },
})
_a1728(_a2114, {
{ label = "쓸 것 (비우면 전부)", value = _a1587.ItemAllow, onChange = function(_a2124)
_a1587.ItemAllow = _a2124 or ""
end },
{ label = "제외", value = _a1587.ItemBlock, onChange = function(_a2125)
_a1587.ItemBlock = _a2125 or ""
end },
})
_a1747(_a2114, "포션", function() return _a1587.BuffPotion end,
function(_a2126) _a1587.BuffPotion = _a2126 end)
_a1747(_a2114, "과일", function() return _a1587.BuffFruit end,
function(_a2127) _a1587.BuffFruit = _a2127 end)
_a1747(_a2114, "얼티밋 (충전되면 발동, 무료)", function() return _a1587.BuffUltimate end,
function(_a2128) _a1587.BuffUltimate = _a2128 end)
_a1747(_a2114, "소모품 (Rain/Sunlight 주의)", function() return _a1587.BuffConsumable end,
function(_a2129) _a1587.BuffConsumable = _a2129 end)
_a1747(_a2114, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a1587.BuffHighTier end,
function(_a2130) _a1587.BuffHighTier = _a2130 end)
_a1747(_a2114, "최고 존에서만 사용", function() return _a1587.ItemBestZone end,
function(_a2131) _a1587.ItemBestZone = _a2131 end)
_a1747(_a2114, "최고 존이 아니면 이동 후 사용", function() return _a1587.ItemTp end,
function(_a2132) _a1587.ItemTp = _a2132 end)
_a1737(_a2114, {
{ label = "버프 현황 보기", col = _a1632.accent, fn = function()
_a1584("")
_a1584("──── 버프 / 아이템 ────")
_a1584(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a1619.move.curZone()), tostring(_a1619.move.bestZone()),
_a1587.ItemBestZone and (_a1619.move.curZone() == _a1619.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a2133, _a2134 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a2135 = _a1619.item.activeBuffs(_a2133)
local _a2136 = {}
for _a2137 in pairs(_a2135) do _a2136[#_a2136 + 1] = _a2137 end
table.sort(_a2136)
_a1584(("  지금 걸린 %s : %s"):format(_a2133,
#_a2136 > 0 and table.concat(_a2136, ", ") or "없음"))
end
local _a2138 = _a1620()
local _a2139 = _a2138 and rawget(_a2138, "Ultimates")
if type(_a2139) == "table" then
local _a2140 = {}
for _a2141 in pairs(_a2139) do
local _a2142 = "?"
if _a1618.Ult and rawget(_a1618.Ult, "IsCharged") then
local _a2143, _a2144 = pcall(_a1618.Ult.IsCharged, _a2141)
_a2142 = _a2143 and (_a2144 and "충전됨" or "충전중") or "?"
end
_a2140[#_a2140 + 1] = _a2141 .. "(" .. _a2142 .. ")"
end
_a1584("  얼티밋 : " .. (#_a2140 > 0 and table.concat(_a2140, ", ") or "없음"))
end
_a1584("")
for _a2145, _a2146 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a2147 = _a1619.item.stacks(_a2146)
local _a2148, _a2149 = 0, 0
for _a2150, _a2151 in ipairs(_a2147) do
if _a1619.item.itemAllowed(_a2151.id) then _a2148 += 1 else _a2149 += 1 end
end
_a1584(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a2146, #_a2147, _a2148, _a2149))
for _a2152, _a2153 in ipairs(_a2147) do
_a1584(("      %-20s T%-2d x%-6d %s"):format(
_a2153.id, _a2153.tier, _a2153.am, _a1619.item.itemAllowed(_a2153.id) and "" or "제외됨"))
if _a2152 >= 12 then _a1584("      ...") break end
end
end
_a1584("")
_a1584("  리모트 : 포션 " .. (_a1618.R_PotUse and "O" or "X")
.. " / 과일 " .. (_a1618.R_Fruit and "O" or "X")
.. " / 소모품 " .. (_a1618.R_Cons and "O" or "X")
.. " / 얼티밋 " .. (_a1618.R_Ult and "O" or "X"))
_a1674("log")
end },
{ label = "지금 1회", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.items = true _a1619.item.cycleItems() _a1589.items = false _a1674("log") end)
end },
})
local _a2154, _a2155 = _a1707(_a1904, "맵 업그레이드 자동 (다이아)", nil)
_a1717(_a2155, "mapupg", function()
_a1631("mapupg", function() return _a1587.UpgInterval end, _a1619.mach.cycleUpg, "맵업글")
end)
_a1728(_a2154, {
{ label = "주기", value = _a1587.UpgInterval, onChange = function(_a2156)
local _a2157 = tonumber(_a2156) if _a2157 and _a2157 >= 5 then _a1587.UpgInterval = _a2157 end
end },
{ label = "남길 다이아", value = _a1587.UpgReserve, onChange = function(_a2158)
local _a2159 = tonumber(_a2158) if _a2159 and _a2159 >= 0 then _a1587.UpgReserve = _a2159 end
end },
})
_a1747(_a2154, "구매 전 그 앞으로 이동",
function() return _a1587.UpgTp end,
function(_a2160) _a1587.UpgTp = _a2160 end)
_a1737(_a2154, {
{ label = "업그레이드 목록", col = _a1632.accent, fn = function()
local _a2161 = _a1619.mach.upgList()
local _a2162 = _a1621("Diamonds")
_a1584("")
_a1584("──── 맵 업그레이드 ────")
_a1584("보유 다이아 " .. _a1585(_a2162, 0))
if #_a2161 == 0 then
_a1584("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a2163, _a2164, _a2165 = 0, 0, 0
for _a2166, _a2167 in ipairs(_a2161) do
if _a2167.bought then _a2164 += 1
elseif not _a2167.zoneOwned then _a2165 += 1
else _a2163 += 1 end
end
_a1584(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a2163, _a2164, _a2165))
_a1584("")
local _a2168 = 0
for _a2169, _a2170 in ipairs(_a2161) do
if _a2170.buyable then
_a2168 += 1
_a1584(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a2170.id, _a2170.tier, _a2170.zone, _a2170.cost and _a1585(_a2170.cost, 0) or "?",
tostring(_a2170.cur),
(_a2170.cost and _a2170.cost <= _a1621(_a2170.cur or "Diamonds") - _a1587.UpgReserve)
and "← 지금 가능" or ""))
if _a2168 >= 25 then _a1584("  ...") break end
end
end
_a1674("log")
end },
{ label = "업글 진단", col = _a1632.warn, fn = function()
task.spawn(function()
_a1584("")
_a1584("──── 맵 업그레이드 진단 ────")
_a1584("  리모트 : " .. (_a1618.R_Upg and _a1618.R_Upg:GetFullName() or "없음"))
local _a2171 = _a1619.mach.upgList()
_a1584("  로드된 기둥 " .. #_a2171 .. "개")
local _a2172
for _a2173, _a2174 in ipairs(_a2171) do
if _a2174.buyable and _a2174.cost then _a2172 = _a2174 break end
end
if not _a2172 then
_a1584("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a2175, _a2176 in ipairs(_a2171) do
_a1584(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a2176.id, _a2176.tier, tostring(_a2176.zone), tostring(_a2176.bought), tostring(_a2176.zoneOwned)))
if _a2175 >= 8 then _a1584("   ...") break end
end
_a1674("log") return
end
local _a2177 = _a1621(_a2172.cur or "Diamonds")
local _a2178 = _a1619.move.hrp()
local _a2179 = (_a2178 and _a2172.pos) and (_a2178.Position - _a2172.pos).Magnitude or nil
_a1584(("  대상 : %s T%d @%s"):format(_a2172.id, _a2172.tier, tostring(_a2172.zone)))
_a1584(("  가격 : %s %s / 보유 %s"):format(
_a1585(_a2172.cost, 0), tostring(_a2172.cur), _a1585(_a2177, 0)))
_a1584("  거리 : " .. (_a2179 and ("%.0f 스터드"):format(_a2179) or "좌표 없음"))
_a1584("")
_a1584("  ▶ 제자리에서 호출")
local _a2180, _a2181
local _a2182 = pcall(function() _a2180, _a2181 = _a1618.R_Upg:InvokeServer(_a2172.id, _a2172.zone) end)
_a1584("    호출성공 " .. tostring(_a2182) .. " / 반환1 " .. tostring(_a2180)
.. " / 반환2 " .. tostring(_a2181))
if not _a2180 and _a2172.pos then
_a1584("")
_a1584("  ▶ 기둥 앞으로 이동해서 재시도")
_a1619.move.glideTo(_a2172.pos)
task.wait(0.3)
local _a2183 = _a1619.move.hrp()
_a1584("    이동후 거리 " .. (_a2183 and ("%.0f"):format((_a2183.Position - _a2172.pos).Magnitude) or "?"))
local _a2184, _a2185
local _a2186 = pcall(function() _a2184, _a2185 = _a1618.R_Upg:InvokeServer(_a2172.id, _a2172.zone) end)
_a1584("    호출성공 " .. tostring(_a2186) .. " / 반환1 " .. tostring(_a2184)
.. " / 반환2 " .. tostring(_a2185))
_a1584("")
_a1584(_a2184 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a1584("")
_a1584(_a2180 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a1674("log")
end)
end },
{ label = "지금 1회", col = _a1632.cardHi, fn = function()
task.spawn(function() _a1589.mapupg = true _a1619.mach.cycleUpg() _a1589.mapupg = false _a1674("log") end)
end },
})
local _a2187, _a2188 = _a1707(_a1904, "자동 리버스", nil)
_a1717(_a2188, "mreb", function()
_a1631("mreb", function() return _a1587.MainRebirthInterval end, _a1629, "리버스")
end)
_a1728(_a2187, {
{ label = "주기", value = _a1587.MainRebirthInterval, onChange = function(_a2189)
local _a2190 = tonumber(_a2189) if _a2190 and _a2190 >= 10 then _a1587.MainRebirthInterval = _a2190 end
end },
})
_a1747(_a2187, "실패 이유 로그",
function() return _a1587.MainRebirthVerbose end,
function(_a2191) _a1587.MainRebirthVerbose = _a2191 end)
_a1737(_a2187, {
{ label = "리버스 현황 보기", col = _a1632.accent, fn = function()
local _a2192 = _a1628()
_a1584("")
if not _a2192 then _a1584("[리버스] 세이브 못 읽음")
else
_a1584("──── 메인 리버스 ────")
_a1584("  현재 " .. _a2192.current .. "회 → 다음 " .. _a2192.nextN)
if type(_a2192.def) == "table" then
for _a2193, _a2194 in pairs(_a2192.def) do
if type(_a2194) ~= "table" and type(_a2194) ~= "function" then
_a1584("    " .. tostring(_a2193) .. " = " .. tostring(_a2194))
end
end
end
end
_a1674("log")
end },
{ label = "지금 1회", col = _a1632.bad, fn = function()
task.spawn(function() _a1589.mreb = true _a1629() _a1589.mreb = false _a1674("log") end)
end },
})
local _a2195 = _a1707(_a1904, "전체 제어", nil)
_a1737(_a2195, {
{ label = "메인 전부 ON", col = _a1632.good, fn = function()
local _a2196 = {
{ "farm",   function() return _a1587.FarmInterval end,       _a1622,       "파밍" },
{ "zone",   function() return _a1587.ZoneInterval end,       _a1624,       "존" },
{ "mhatch", function() return _a1587.MainHatchInterval end,  _a1627,  "부화" },
{ "quest",  function() return _a1587.QuestInterval end,      _a1619.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a1587.UpgInterval end,        _a1619.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a1587.ItemInterval end,       _a1619.item.cycleItems,   "아이템" },
{ "slots",  function() return _a1587.SlotInterval end,       _a1619.mach.cycleSlots,   "슬롯" },
}
for _a2197, _a2198 in ipairs(_a2196) do
if not _a1589[_a2198[1]] then
_a1589[_a2198[1]] = true
_a1631(_a2198[1], _a2198[2], _a2198[3], _a2198[4])
end
end
_a1714()
_a1584("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a1632.bad, fn = function()
_a1619.ctl.stopAll()
_a1714()
_a1584("[메인] 정지")
end },
})
end
_a1665.MouseButton1Click:Connect(function()
local _a2199 = table.concat(_a1583, "\n")
if #_a2199 > 900000 then _a2199 = _a2199:sub(#_a2199 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a2199)
_a1665.Text = "완료"
task.delay(1.5, function() if _a1665 then _a1665.Text = "복사" end end)
end
end)
_a1664.MouseButton1Click:Connect(function()
table.clear(_a1583)
_a1579.dirty = true
end)
local function _a2200()
_a1589.place, _a1589.merchant, _a1589.upgrade = false, false, false
_a1589.towerup, _a1589.crop, _a1589.expand, _a1589.rebirth, _a1589.hatch, _a1589.luck = false, false, false, false, false, false
_a1589.farm, _a1589.zone, _a1589.mhatch, _a1589.rank, _a1589.mreb = false, false, false, false, false
if _a1768 then _a1768:Disconnect() end
if _a1650 then _a1650:Destroy() end
_G.__PS99_GARDEN = nil
end
_a1662.MouseButton1Click:Connect(_a2200)
_G.__PS99_GARDEN = _a2200
_a1674("dash")
_a1584("PS99 자동")
if _a1579.lpWait then
_a1584(("[진단] LocalPlayer 가 늦게 잡혔습니다 — %.1f초 대기, 결과 %s")
:format(_a1579.lpWait, _a1579.lpFail and "실패 (기능 대부분 못 씀)" or "성공"))
end
if _a1589.auto then
if _a1619.auto.start then
_a1584("[자동] 올 자동 켜짐 — 1초 뒤 시작합니다")
task.spawn(function()
task.wait(1)
_a1619.ctl.abort = false
local _a2201, _a2202 = pcall(_a1619.auto.start)
if _a2201 then
_a1584("[자동] 시작됨")
else
_a1589.auto = false
_a1584("[자동] 시작 실패: " .. tostring(_a2202))
if _a1619.auto.refresh then pcall(_a1619.auto.refresh) end
end
end)
else
_a1589.auto = false
_a1584("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a2203, _a2204, _a2205, _a2206 = _a1592()
if _a2203 and _a2205 then
local _a2207 = _a1593(_a2205, _a2206)
_a1590.slots = #_a2207
_a1584("레인 " .. _a2206 .. " / 슬롯 " .. #_a2207)
else
_a1584("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a1590.sun = _a1598()
_a1584("Sunflowers " .. _a1585(_a1590.sun, 0))
end)
end)(_a1)
