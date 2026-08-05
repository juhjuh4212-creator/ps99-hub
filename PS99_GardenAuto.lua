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
local _a604 = _a566.Save
if not _a604 then return nil end
local _a605, _a606 = pcall(_a604.Get)
if _a605 and type(_a606) == "table" then return _a606 end
if _a562 then
_a605, _a606 = pcall(_a604.Get, _a562)
if _a605 and type(_a606) == "table" then return _a606 end
end
if rawget(_a604, "GetSaves") then
local _a607, _a608 = pcall(_a604.GetSaves)
if _a607 and type(_a608) == "table" then
local _a609, _a610 = nil, 0
for _a611, _a612 in pairs(_a608) do _a610 += 1 _a609 = _a612 end
if _a610 == 1 and type(_a609) == "table" then
if not _a576.ctl.saveAlt then
_a576.ctl.saveAlt = true
_a563("[세이브] LocalPlayer 키가 안 맞아 유일한 항목으로 대체했습니다")
end
return _a609
end
end
end
return nil
end
local function _a613(_a614, _a615)
if _a574.Currency and rawget(_a574.Currency, "CanAfford") then
local _a616, _a617 = pcall(_a574.Currency.CanAfford, _a614, _a615)
if _a616 then return _a617 and true or false end
end
return false
end
local function _a618(_a619)
if _a574.Currency and rawget(_a574.Currency, "Get") then
local _a620, _a621 = pcall(_a574.Currency.Get, _a619)
if _a620 and tonumber(_a621) then return tonumber(_a621) end
end
return 0
end
local function _a622()
if _a574.AutoFarm and rawget(_a574.AutoFarm, "IsEnabled") then
local _a623, _a624 = pcall(_a574.AutoFarm.IsEnabled)
if _a623 then return _a624 and true or false end
end
return false
end
local function _a625()
if _a574.AutoFarm and rawget(_a574.AutoFarm, "GetTargetParentId") then
local _a626, _a627 = pcall(_a574.AutoFarm.GetTargetParentId)
if _a626 then return _a627 end
end
return nil
end
local function _a628()
if not _a574.R_Farm then _a563("[파밍] AutoFarm_Enable 리모트 없음") return end
local _a629 = _a622()
_a576.auto.farmZone, _a576.auto.hereZone = _a625(), _a576.move.curZone()
if _a629 then
local _a630, _a631 = _a625(), _a576.move.curZone()
if _a630 and _a631 and _a630 ~= _a631 then
_a563(("[파밍] 대상이 %s 인데 지금은 %s — 다시 켬"):format(
tostring(_a630), tostring(_a631)))
if _a574.R_FarmOff then pcall(function() _a574.R_FarmOff:InvokeServer() end) end
if _a574.AutoFarm and rawget(_a574.AutoFarm, "ForceDisable") then
pcall(_a574.AutoFarm.ForceDisable)
end
task.wait(0.3)
_a629 = false
end
end
if _a629 then return end
local _a632, _a633
pcall(function() _a632, _a633 = _a574.R_Farm:InvokeServer() end)
if _a632 then
_a571.farm += 1
_a576.auto.farmSaid = nil
_a563("[파밍] 자동 파밍 ON  (대상 " .. tostring(_a625() or _a576.move.curZone()) .. ")")
elseif _a633 and _a576.auto.farmSaid ~= tostring(_a633) then
_a576.auto.farmSaid = tostring(_a633)
_a563("[파밍] 실패: " .. tostring(_a633))
end
end
local function _a634()
if not (_a574.Zone and rawget(_a574.Zone, "GetNextZone")) then return nil end
local _a635, _a636, _a637 = pcall(_a574.Zone.GetNextZone)
if not _a635 then return nil end
return _a637 or _a636
end
local function _a638(_a639)
if not (_a574.Bal and rawget(_a574.Bal, "CalcGatePrice")) then return nil end
local _a640, _a641 = pcall(_a574.Bal.CalcGatePrice, _a639)
return (_a640 and tonumber(_a641)) or nil
end
local function _a642()
local _a643 = _a634()
if not _a643 then return nil end
local _a644 = _a638(_a643)
local _a645 = rawget(_a643, "Currency")
return {
zone = _a643, id = rawget(_a643, "_id"), price = _a644, currency = _a645,
have = _a645 and _a618(_a645) or 0,
ok = (_a644 and _a645) and _a613(_a645, _a644) or false,
}
end
local function _a646()
if not _a574.R_Zone then _a563("[존] Zones_RequestPurchase 리모트 없음") return end
local _a647 = 0
while _a570.zone and not _a576.ctl.stopped() and _a647 < 20 do
_a647 += 1
local _a648 = _a642()
if not _a648 then
_a576.auto.zoneNote = "다음 존을 못 구함 (GetNextZone 실패 / 존 퀘스트 미완료?)"
if _a576.auto.zoneSaid ~= _a576.auto.zoneNote then
_a576.auto.zoneSaid = _a576.auto.zoneNote
_a563("[존] " .. _a576.auto.zoneNote)
end
return
end
if not _a648.ok then
_a576.auto.zoneNote = ("%s  %s %s / 보유 %s — 부족"):format(
tostring(_a648.id), _a564(_a648.price or 0, 0), tostring(_a648.currency), _a564(_a648.have, 0))
if _a576.auto.zoneSaid ~= _a576.auto.zoneNote then
_a576.auto.zoneSaid = _a576.auto.zoneNote
_a563("[존] " .. _a576.auto.zoneNote)
end
return
end
_a576.auto.zoneSaid = nil
local _a649, _a650
pcall(function() _a649, _a650 = _a574.R_Zone:InvokeServer(_a648.id) end)
task.wait(0.5)
if _a649 then
_a571.zone += 1
_a563(("  ▶ 존 해금  %s   (%s %s)"):format(
tostring(_a648.id), _a564(_a648.price or 0, 0), tostring(_a648.currency)))
else
if _a650 then _a563("[존] 실패: " .. tostring(_a650)) end
return
end
task.wait(_a569.ActionGap)
end
end
local function _a651()
local _a652 = _a576.egg.eggStands()
local _a653 = (_a569.MainEggId and _a569.MainEggId ~= "") and _a569.MainEggId or nil
if _a653 then
for _a654, _a655 in ipairs(_a652) do
if _a655.id == _a653 then return _a655.id, _a655.def, _a655.dist end
end
local _a656 = _a574.DirEggs and rawget(_a574.DirEggs, _a653)
if _a656 then return _a653, _a656, nil, (_a652[1] and _a652[1].dist) end
return nil
end
if not _a574.DirEggs then return nil end
local _a657, _a658, _a659 = nil, nil, -1
for _a660, _a661 in pairs(_a574.DirEggs) do
if type(_a661) == "table" and not rawget(_a661, "isCustomEgg") then
local _a662 = tonumber(rawget(_a661, "eggNumber"))
if _a662 and _a662 > _a659 and _a576.egg.eggUnlocked(_a662) then
_a657, _a658, _a659 = _a660, _a661, _a662
end
end
end
if not _a657 then return nil end
local _a663, _a664
for _a665, _a666 in ipairs(_a652) do
if not _a664 then _a664 = _a666.dist end
if _a666.id == _a657 then _a663 = _a666.dist break end
end
if _a663 and _a663 <= _a569.EggRange then
return _a657, _a658, _a663
end
return _a657, _a658, nil, _a663 or _a664
end
local function _a667(_a668)
if type(_a574.CalcEgg) == "function" then
local _a669, _a670 = pcall(_a574.CalcEgg, _a668)
if _a669 and tonumber(_a670) then return tonumber(_a670) end
if not _a669 and not _a576.egg.priceWarned then
_a576.egg.priceWarned = true
_a563("[부화] CalcEggPricePlayer 막힘 → 기본가로 계산: " .. tostring(_a670))
end
end
if type(_a574.CalcEggB) == "function" then
local _a671, _a672 = pcall(_a574.CalcEggB, _a668)
if _a671 and tonumber(_a672) then return tonumber(_a672) end
end
for _a673, _a674 in ipairs({ "price", "Price", "cost", "Cost" }) do
local _a675 = tonumber(rawget(_a668, _a674))
if _a675 then return _a675 end
end
return nil
end
local function _a676()
local _a677, _a678, _a679, _a680 = _a651()
if not _a677 then return nil end
local _a681 = _a667(_a678)
local _a682 = rawget(_a678, "currency") or "Coins"
local _a683 = 1
if _a574.Egg and rawget(_a574.Egg, "GetMaxHatch") then
local _a684, _a685 = pcall(_a574.Egg.GetMaxHatch, _a678)
if _a684 and tonumber(_a685) then _a683 = math.max(1, math.floor(tonumber(_a685))) end
end
local _a686 = _a618(_a682)
return {
id = _a677, def = _a678, price = _a681, currency = _a682, maxN = _a683, have = _a686,
dist = _a679, nearest = _a680, inRange = _a679 ~= nil,
canBuy = (_a681 and _a681 > 0) and math.floor(math.max(0, _a686 - _a569.MainHatchReserve) / _a681) or 0,
}
end
local function _a687()
if not _a568.R_EGG then _a563("[부화] Eggs_RequestPurchase 리모트 없음") return end
if _a569.AutoUnlockEgg then
local _a688, _a689, _a690 = _a576.egg.lockedEggs()
if _a689 > _a690 then
local _a691 = _a576.egg.unlockEggs()
if _a691 > 0 then _a563(("[부화] 알 %d개 해금 (해금가능 #%d)"):format(_a691, _a689)) end
end
end
local _a692 = _a676()
if not _a692 then _a563("[부화] 알을 못 찾음") return end
if not _a692.inRange then
if _a569.HatchAutoTp then
local _a693, _a694 = _a576.egg.tpEgg(_a692.id)
if not _a693 then
if not _a576.egg.hatchWarned then
_a576.egg.hatchWarned = true
_a563("[부화] 알로 이동 실패: " .. tostring(_a694))
end
return
end
_a563("[부화] " .. _a692.id .. " 로 이동")
_a692 = _a676()
if not (_a692 and _a692.inRange) then return end
else
if not _a576.egg.hatchWarned then
_a576.egg.hatchWarned = true
_a563(("[부화] 알 근처로 가주세요 (가장 가까운 알까지 %s스터드, 인식 %d)"):format(
_a692.nearest and ("%.0f"):format(_a692.nearest) or "?", _a569.EggRange))
end
return
end
end
_a576.egg.hatchWarned = false
local _a695 = math.min(_a692.maxN, _a569.MainHatchMax)
local _a696 = _a692.price and math.min(_a692.canBuy, _a695) or _a695
if _a696 < 1 then return end
local _a697, _a698 = 0, 0
local function _a699()
return tonumber(_a574.Vars and rawget(_a574.Vars, "OpeningEgg")) or 0
end
local _a700 = _a574.Vars and rawget(_a574.Vars, "OpeningEgg") ~= nil
local _a701 = 2.5
if _a574.Egg and rawget(_a574.Egg, "ComputeDebounce") then
local _a702, _a703 = pcall(_a574.Egg.ComputeDebounce)
if _a702 and tonumber(_a703) then _a701 = tonumber(_a703) end
end
_a576.egg.autoHatchOn(_a692.id, _a696)
local _a704 = false
local _a705 = _a576.ctl.lockGoal and _a576.ctl.lockGoal.q
local _a706 = _a705 and (_a705.how == "hatch" or _a705.where == "bestegg") or false
local _a707 = _a706 and math.huge
or (os.clock() + math.max(3, _a569.HatchBudget or 25))
local _a708 = _a706 and 100000 or 400
while _a570.mhatch and not _a576.ctl.stopped() and _a696 >= 1 and _a698 < _a708 and os.clock() < _a707 do
if _a706 and (_a698 % 5 == 0) then
local _a709 = _a576.quest.findQuest(_a705.uid)
if not _a709 or _a709.progress >= _a709.amount then break end
end
_a698 += 1
if _a700 then
local _a710 = os.clock()
local _a711 = _a569.HatchClickAfter
local _a712 = false
while _a699() > 0 and _a570.mhatch and not _a576.ctl.stopped()
and (os.clock() - _a710) < 20 do
if _a569.HatchClick and (os.clock() - _a710) > _a711 then
_a576.egg.clickOnce()
_a711 += 0.3
if (os.clock() - _a710) > 3 and not _a712 then
_a712 = true
_a576.egg._ahEgg = nil
_a576.egg.autoHatchOn(_a692.id, _a696)
_a563("[부화] 화면이 안 넘어가서 오토해치 재설정")
end
end
task.wait(0.03)
end
if _a699() > 0 then
if _a576.egg.hatchStuck ~= _a692.id then
_a576.egg.hatchStuck = _a692.id
_a563("[부화] " .. tostring(_a692.id) .. " 까는 화면에서 멈춤 — 이번 회차 중단")
end
_a704 = true
break
end
_a576.egg.hatchStuck = nil
else
local _a713 = os.clock() - (_a576.egg.lastHatch or 0)
if _a713 < _a701 then task.wait(_a701 - _a713) end
end
_a576.egg.lastHatch = os.clock()
_a576.ctl.setAct("알 까는 중", ("%s x%d  (총 %d)"):format(_a692.id, _a696, _a697))
local _a714, _a715
local _a716 = pcall(function() _a714, _a715 = _a568.R_EGG:InvokeServer(_a692.id, _a696) end)
if _a714 then
_a697 += _a696
_a571.mhatch += _a696
_a576.egg.hatchErr = nil
if _a692.price then
local _a717 = _a618(_a692.currency)
local _a718 = math.floor(math.max(0, _a717 - _a569.MainHatchReserve) / _a692.price)
if _a718 < 1 then break end
_a696 = math.min(_a718, _a695)
end
else
local _a719 = _a716 and tostring(_a715) or "호출 자체 실패"
if _a719:find("quickly") or _a719:find("fast") then
task.wait(0.25)
elseif _a719:find("far away") then
if _a569.HatchAutoTp then _a576.egg.tpEgg(_a692.id) task.wait(0.2)
else _a563("[부화] 알에서 너무 멈") break end
elseif _a696 > 1 then
_a696 = math.floor(_a696 / 2)
else
if _a576.egg.hatchErr ~= _a719 then
_a576.egg.hatchErr = _a719
_a563("[부화] 실패: " .. _a719 .. "   (알 " .. tostring(_a692.id)
.. " / 개수 " .. _a696 .. " / 거리 "
.. (_a692.dist and ("%.0f"):format(_a692.dist) or "?") .. ")")
end
break
end
end
end
if _a700 and _a697 > 0 and not _a704 then
local _a720 = os.clock()
while _a699() == 0 and not _a576.ctl.stopped() and (os.clock() - _a720) < 2.5 do
task.wait(0.05)
end
local _a721 = os.clock()
local _a722 = _a569.HatchClickAfter
while _a699() > 0 and not _a576.ctl.stopped() and (os.clock() - _a721) < 20 do
_a576.ctl.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a692.id, _a696))
if _a569.HatchClick and (os.clock() - _a721) > _a722 then
_a576.egg.clickOnce()
_a722 += 0.3
if (os.clock() - _a721) > 3 and not _a576.egg._finRe then
_a576.egg._finRe = true
_a576.egg._ahEgg = nil
_a576.egg.autoHatchOn(_a692.id, _a696)
end
end
task.wait(0.03)
end
_a576.egg._finRe = nil
if _a699() > 0 then
_a563("[부화] 마지막 알이 20초 넘게 안 끝남 — 그대로 두고 진행합니다")
end
end
_a576.egg.autoHatchOff()
if _a697 > 0 then
_a576.egg.hatchErr = nil
_a563(("[부화] %s × %d%s  (개당 %s %s)"):format(
_a692.id, _a697, _a706 and " (목표까지)" or "",
_a692.price and _a564(_a692.price, 0) or "?", tostring(_a692.currency)))
end
end
local function _a723()
local _a724 = _a603()
if not _a724 then return nil end
local _a725 = tonumber(rawget(_a724, "Rank")) or 1
local _a726 = tonumber(rawget(_a724, "RankStars")) or 0
local _a727 = rawget(_a724, "RedeemedRankRewards") or {}
local _a728
if _a574.RanksU and rawget(_a574.RanksU, "RankIDFromNumber") then
local _a729, _a730 = pcall(_a574.RanksU.RankIDFromNumber, _a725)
if _a729 then _a728 = _a730 end
end
local _a731 = _a728 and _a574.DirRanks and rawget(_a574.DirRanks, _a728)
if type(_a731) ~= "table" then
return { rankNum = _a725, stars = _a726, rankId = _a728, rewards = {} }
end
local _a732, _a733 = {}, 0
for _a734, _a735 in ipairs(rawget(_a731, "Rewards") or {}) do
_a733 += (tonumber(rawget(_a735, "StarsRequired")) or 0)
local _a736 = _a733 <= _a726
local _a737 = _a727[tostring(_a734)] ~= nil
_a732[#_a732 + 1] = {
index = _a734, need = _a733, earned = _a736, redeemed = _a737,
claimable = _a736 and not _a737,
}
end
return { rankNum = _a725, stars = _a726, rankId = _a728, rewards = _a732 }
end
local function _a738()
if not _a574.R_Rank then _a563("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a739 = _a723()
if not _a739 then return end
local _a740 = 0
for _a741, _a742 in ipairs(_a739.rewards) do
if not _a570.rank then break end
if _a742.claimable then
pcall(function() _a574.R_Rank:FireServer(_a742.index) end)
_a740 += 1
_a571.rank += 1
task.wait(0.1)
end
end
if _a740 > 0 then
_a563(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a740, _a739.rankNum, _a739.stars))
end
end
function _a576.move.hrp()
local _a743 = _a562.Character
return _a743 and _a743:FindFirstChild("HumanoidRootPart"),
_a743 and _a743:FindFirstChildOfClass("Humanoid")
end
function _a576.egg.autoHatchOn(_a744, _a745)
if not _a569.UseAutoHatch then return end
if _a576.egg._ahEgg == _a744 and _a576.egg._ahAt and (os.clock() - _a576.egg._ahAt) < 15 then return end
_a576.egg._ahEgg, _a576.egg._ahAt = _a744, os.clock()
local _a746 = _a574.DirEggs and rawget(_a574.DirEggs, _a744)
if _a574.Hatch and _a746 and rawget(_a574.Hatch, "SetupEgg") then
local _a747, _a748 = pcall(_a574.Hatch.SetupEgg, _a746, _a745 or 1)
if not _a747 and not _a576.egg._ahWarn then
_a576.egg._ahWarn = true
_a563("[부화] SetupEgg 실패: " .. tostring(_a748) .. "  → 클릭 대체 사용")
end
end
if _a574.R_AHTog then pcall(function() _a574.R_AHTog:FireServer(true) end) end
if _a574.R_AHOn then pcall(function() _a574.R_AHOn:FireServer(_a744, _a745 or 1) end) end
if _a574.Hatch and rawget(_a574.Hatch, "IsHatching") then
local _a749, _a750 = pcall(_a574.Hatch.IsHatching)
_a576.egg._ahLive = _a749 and _a750 and true or false
end
end
function _a576.egg.autoHatchOff()
_a576.egg._ahEgg, _a576.egg._ahAt, _a576.egg._ahLive = nil, nil, nil
if _a574.Hatch and rawget(_a574.Hatch, "StopHatching") then pcall(_a574.Hatch.StopHatching) end
if _a574.R_AHOff then pcall(function() _a574.R_AHOff:FireServer() end) end
end
function _a576.egg.clickOnce()
if _a576.ctl.moving then return false end
local _a751 = _a576.screen.signal("egg")
if not _a751 then _a751 = _a576.screen.pressInGame({ "Egg Opening" }) end
if not _a751 and not _a576.egg._eggSigWarn then
_a576.egg._eggSigWarn = true
_a563("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a751
end
function _a576.egg.watchStuck()
local _a752 = _a574.Vars
if not _a752 then return end
local _a753 = tonumber(rawget(_a752, "OpeningEgg")) or 0
if _a753 <= 0 then
_a576.egg.stuckSince, _a576.egg.stuckSaid = nil, nil
return
end
_a576.egg.stuckSince = _a576.egg.stuckSince or os.clock()
local _a754 = os.clock() - _a576.egg.stuckSince
if _a754 < 3 then return end
if not _a569.HatchClick then return end
if _a576.ctl.moving then _a576.screen.signal("egg") else _a576.egg.clickOnce() end
if _a754 > 6 and not _a576.egg.stuckSaid then
_a576.egg.stuckSaid = true
_a563("[부화] 까는 화면에서 멈춰 있어 계속 넘기는 중")
end
end
function _a576.item.applyPetSpeed()
local _a755 = _a574.PlayerPet
if not (_a755 and rawget(_a755, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a756, _a757 = pcall(_a755.GetByPlayer, _a562)
if not (_a756 and type(_a757) == "table") then return 0, "펫 목록 못 읽음" end
local _a758 = math.max(1, tonumber(_a569.PetSpeedMult) or 50)
local _a759 = math.max(0.05, tonumber(_a569.PetSpeedBase) or 4)
local _a760 = 0
for _a761, _a762 in pairs(_a757) do
if type(_a762) == "table" then
local _a763 = rawget(_a762, "cpet")
if _a763 then
_a762.speedMult = _a758
pcall(function() _a763:Broadcast("petSpeedMult", _a758) end)
pcall(function() _a763:Broadcast("petSpeed", _a759) end)
_a760 += 1
end
end
end
return _a760
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
function _a576.screen.findSignalFns(_a764)
local _a765 = _a576.screen.SIGNAL[_a764]
if not _a765 then return {} end
_a576.screen._sig = _a576.screen._sig or {}
local _a766 = _a576.screen._sig[_a764]
if _a766 and (os.clock() - _a766.at) < (#_a766.fns > 0 and 20 or 3) then return _a766.fns end
local _a767 = {}
_a576.screen._sig[_a764] = { at = os.clock(), fns = _a767 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a767
end
local _a768 = {}
for _a769, _a770 in ipairs({ true, false }) do
local _a771, _a772 = pcall(getgc, _a770)
if _a771 and type(_a772) == "table" then
for _a773, _a774 in ipairs(_a772) do _a768[#_a768 + 1] = _a774 end
end
end
if #_a768 == 0 then return _a767 end
for _a775, _a776 in ipairs(_a768) do
if type(_a776) == "function" then
local _a777, _a778 = pcall(debug.info, _a776, "s")
if _a777 and type(_a778) == "string" then
local _a779 = false
for _a780, _a781 in ipairs(_a765.pats) do
if _a778:find(_a781, 1, true) then _a779 = true break end
end
if _a779 then
local _a782, _a783 = pcall(debug.info, _a776, "a")
if _a782 then
local _a784, _a785 = {}, 0
for _a786 = 1, 16 do
local _a787, _a788 = pcall(debug.getupvalue, _a776, _a786)
if not _a787 then break end
_a785 = _a786
_a784[_a786] = type(_a788)
end
local _a789 = table.concat(_a784, ",")
local _a790 = false
for _a791, _a792 in ipairs(_a765.sigs or {}) do
if _a783 == _a792.np and _a789 == _a792.t then
_a767[#_a767 + 1] = { fn = _a776, sig = _a789, n = _a785, np = _a783,
src = _a778, set = _a792.set }
_a790 = true
break
end
end
if not _a790 and _a765.sigs then
local _a793 = {}
for _a794, _a795 in ipairs(_a784) do
if _a795 == "boolean" then _a793[#_a793 + 1] = _a794 end
end
if #_a793 > 0 then
_a767[#_a767 + 1] = { fn = _a776, idx = _a793, sig = _a789, n = _a785,
np = _a783, src = _a778, loose = true }
end
end
if not _a790 and not _a765.sigs and _a783 == 0 then
local _a796 = 0
for _a797, _a798 in ipairs(_a784) do if _a798 == "boolean" then _a796 += 1 end end
if _a796 >= (_a765.minBools or 1) then
local _a799 = {}
for _a800, _a801 in ipairs(_a784) do
if _a801 == "boolean" then _a799[#_a799 + 1] = _a800 end
end
_a767[#_a767 + 1] = { fn = _a776, idx = _a799, sig = _a789, n = _a785, src = _a778 }
end
end
end
end
end
end
end
return _a767
end
function _a576.screen.signal(_a802)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a803 = _a576.screen.findSignalFns(_a802)
local _a804 = 0
for _a805, _a806 in ipairs(_a803) do
if _a806.set then
for _a807, _a808 in ipairs(_a806.set) do
if pcall(debug.setupvalue, _a806.fn, _a808[1], _a808[2]) then _a804 += 1 end
end
elseif not _a806.loose then
for _a809, _a810 in ipairs(_a806.idx or {}) do
if pcall(debug.setupvalue, _a806.fn, _a810, true) then _a804 += 1 end
end
end
end
if _a804 == 0 then
for _a811, _a812 in ipairs(_a803) do
if _a812.loose then
for _a813, _a814 in ipairs(_a812.idx or {}) do
if pcall(debug.setupvalue, _a812.fn, _a814, true) then _a804 += 1 end
end
end
end
end
return _a804 > 0, _a804
end
function _a576.screen.pressInGame(_a815)
local _a816, _a817 = pcall(function() return game:GetService("UserInputService") end)
if not (_a816 and _a817) then return false end
local _a818 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a819 = 0
if type(getconnections) == "function" then
local _a820, _a821 = pcall(getconnections, _a817.InputBegan)
if _a820 and type(_a821) == "table" then
for _a822, _a823 in ipairs(_a821) do
local _a824 = ""
local _a825 = _a823.Function
if _a825 and type(debug) == "table" and type(debug.info) == "function" then
local _a826, _a827 = pcall(debug.info, _a825, "s")
if _a826 and _a827 then _a824 = tostring(_a827) end
end
local _a828 = false
for _a829, _a830 in ipairs(_a815) do
if _a824 ~= "" and _a824:find(_a830, 1, true) then _a828 = true break end
end
if _a828 then
if _a825 and pcall(_a825, _a818, false) then _a819 += 1
elseif _a823.Fire and pcall(function() _a823:Fire(_a818, false) end) then _a819 += 1
elseif _a823.Defer and pcall(function() _a823:Defer(_a818, false) end) then _a819 += 1 end
end
end
end
end
if _a819 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a817.InputBegan, _a818, false) then _a819 += 1 end
end
return _a819 > 0
end
function _a576.screen.realClick(_a831)
if not _a569.ScreenRealClick then return false end
local _a832 = workspace.CurrentCamera
local _a833 = (_a832 and _a832.ViewportSize) or Vector2.new(1280, 720)
local _a834, _a835 = _a833.X * 0.5, _a833.Y * 0.45
local _a836 = {}
local function _a837(_a838, _a839)
local _a840 = pcall(_a839)
_a836[#_a836 + 1] = _a838 .. (_a840 and "=OK" or "=X")
return _a840
end
local _a841 = false
if not _a841 and type(mouse1click) == "function" then
_a841 = _a837("mouse1click", function() mouse1click() end)
end
if not _a841 and type(mouse1press) == "function" then
_a841 = _a837("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a841 then
_a841 = _a837("VirtualUser", function()
local _a842 = game:GetService("VirtualUser")
_a842:Button1Down(Vector2.new(_a834, _a835), _a832 and _a832.CFrame or CFrame.new())
task.wait(0.05)
_a842:Button1Up(Vector2.new(_a834, _a835), _a832 and _a832.CFrame or CFrame.new())
end)
end
if not _a841 then
_a841 = _a837("VirtualInputManager", function()
local _a843 = game:GetService("VirtualInputManager")
_a843:SendMouseButtonEvent(_a834, _a835, 0, true, game, 1)
task.wait(0.05)
_a843:SendMouseButtonEvent(_a834, _a835, 0, false, game, 1)
end)
end
if _a831 then _a563("    " .. table.concat(_a836, " / ")) end
return _a841
end
function _a576.screen.rewardScreenUp()
if not _a562 then
if not _a576.screen.noLP then
_a576.screen.noLP = true
_a563("[화면] LocalPlayer 를 못 잡았습니다 — 화면 감시를 건너뜁니다")
end
return false
end
local _a844 = _a562:FindFirstChildOfClass("PlayerGui")
if _a844 then
for _a845, _a846 in ipairs(_a576.screen.BLOCKERS) do
local _a847 = _a844:FindFirstChild(_a846[1])
if _a847 and _a847:IsA("ScreenGui") and _a847.Enabled then return true, _a846[2], _a846[3] end
end
end
local _a848 = _a574.Vars
if _a848 then
if rawget(_a848, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a848, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a576.screen.dismissRewardScreens(_a849)
if _a576.screen.dismissBusy then return end
_a576.screen.dismissBusy = true
local _a850, _a851 = pcall(_a576.screen.dismissInner, _a849)
_a576.screen.dismissBusy = false
if not _a850 then _a563("[화면] 오류: " .. tostring(_a851)) end
end
function _a576.screen.dismissInner(_a852)
local _a853 = _a574.Vars
if not _a853 then return end
local _a854 = os.clock()
local _a855, _a856 = false, nil
local _a857 = 0
local _a858 = math.max(3, _a569.ScreenTryMax or 8)
while os.clock() - _a854 < (_a852 or 120) do
local _a859, _a860, _a861 = _a576.screen.rewardScreenUp()
if not _a859 then break end
_a855, _a856 = true, _a860
_a857 += 1
_a576.ctl.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a860), _a857,
_a857 <= 6 and " · 첫 화면 대기" or ""))
local _a862 = _a576.screen.SIGNAL[_a861 or "reward"]
local _a863 = (_a862 and _a862.pats) or { "Rebirth", "Rank Up" }
local _a864 = _a576.screen.signal(_a861 or "reward")
if not _a864 then
for _a865 in pairs(_a576.screen.SIGNAL) do
if _a576.screen.signal(_a865) then _a864 = true end
end
end
local _a866 = false
if not _a864 or _a857 >= 2 then
_a866 = _a576.screen.pressInGame(_a863)
end
if _a857 >= 3 then
if _a576.screen.realClick() then
_a866 = true
if not _a576.screen._realSaid then
_a576.screen._realSaid = true
_a563("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a864 or _a866) and not _a576.screen._sigSaid then
_a576.screen._sigSaid = true
_a563("[화면] " .. (_a864 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a857 >= _a858 and (os.clock() - _a854) >= 12 then
if _a576.screen.giveUpSaid ~= _a860 then
_a576.screen.giveUpSaid = _a860
_a563(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a860)))
_a563("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a576.screen.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a855 then
if not _a576.screen.rewardScreenUp() then
_a576.screen.lastBlocker = nil
_a576.screen.screenGaveUp = nil
_a563(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a856), _a857))
end
end
end
function _a576.egg.eggUnlocked(_a867)
_a867 = tonumber(_a867)
if not _a867 then return false end
local _a868 = _a603()
local _a869 = _a868 and rawget(_a868, "UnlockedEggs")
if type(_a869) == "table" then
for _a870, _a871 in pairs(_a869) do
if tonumber(_a871) == _a867 then return true end
end
return false
end
return _a867 <= 1
end
function _a576.egg.lockedEggs()
local _a872 = {}
if not _a574.DirEggs then return _a872, 0, 0 end
local _a873 = _a603()
local _a874 = tonumber(_a873 and rawget(_a873, "MaximumAvailableEgg")) or 1
local _a875 = 0
local _a876 = _a873 and rawget(_a873, "UnlockedEggs")
if type(_a876) == "table" then
for _a877, _a878 in pairs(_a876) do
local _a879 = tonumber(_a878)
if _a879 and _a879 > _a875 then _a875 = _a879 end
end
end
for _a880, _a881 in pairs(_a574.DirEggs) do
if type(_a881) == "table" and not rawget(_a881, "isCustomEgg") then
local _a882 = tonumber(rawget(_a881, "eggNumber"))
if _a882 and _a882 <= _a874 and not _a576.egg.eggUnlocked(_a882) then
_a872[#_a872 + 1] = { id = _a880, num = _a882 }
end
end
end
table.sort(_a872, function(_a883, _a884) return _a883.num < _a884.num end)
return _a872, _a874, _a875
end
function _a576.egg.unlockEggs(_a885)
if not _a574.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a886 = _a576.egg.lockedEggs()
if #_a886 == 0 then return 0 end
local _a887, _a888 = 0, nil
for _a889, _a890 in ipairs(_a886) do
if not _a576.egg.eggUnlocked(_a890.num) then
local _a891, _a892
pcall(function() _a891, _a892 = _a574.R_EggUn:InvokeServer(_a890.id) end)
if not _a891 and _a569.HatchAutoTp then
local _a893 = _a576.egg.tpEgg(_a890.id)
if _a893 then
task.wait(0.3)
pcall(function() _a891, _a892 = _a574.R_EggUn:InvokeServer(_a890.id) end)
end
end
if _a891 then
_a887 += 1
_a576.ctl.setAct("알 해금", ("#%d %s"):format(_a890.num, _a890.id))
_a563(("  🔓 알 해금  #%d %s"):format(_a890.num, _a890.id))
task.wait(0.15)
else
_a888 = _a892
if _a885 then
_a563(("[해금] #%d %s 실패: %s"):format(_a890.num, _a890.id, tostring(_a892)))
end
end
end
end
return _a887, _a888
end
function _a576.move.curZone()
if _a574.Map and rawget(_a574.Map, "GetCurrentZone") then
local _a894, _a895 = pcall(_a574.Map.GetCurrentZone)
if _a894 then return _a895 end
end
return nil
end
function _a576.move.zone1()
if not _a574.DirZones then return nil end
local _a896, _a897 = nil, math.huge
for _a898, _a899 in pairs(_a574.DirZones) do
if type(_a899) == "table" and _a576.move.ownsZone(_a898) then
local _a900 = tonumber(rawget(_a899, "ZoneNumber")) or math.huge
if _a900 < _a897 then _a896, _a897 = _a898, _a900 end
end
end
return _a896
end
function _a576.move.realZone(_a901) return _a901 end
function _a576.move.resolvableZone(_a902)
if _a902 then
local _a903 = _a576.move.zonePos(_a902)
if _a903 then return _a902, _a903 end
end
if not _a574.DirZones then return nil end
local _a904 = {}
for _a905, _a906 in pairs(_a574.DirZones) do
if type(_a906) == "table" and _a576.move.ownsZone(_a905) then
_a904[#_a904 + 1] = { id = _a905, n = tonumber(rawget(_a906, "ZoneNumber")) or 0 }
end
end
table.sort(_a904, function(_a907, _a908) return _a907.n > _a908.n end)
for _a909, _a910 in ipairs(_a904) do
if _a910.id ~= _a902 then
local _a911 = _a576.move.zonePos(_a910.id)
if _a911 then
if _a576.move.fallZone ~= _a910.id then
_a576.move.fallZone = _a910.id
_a563(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a902), tostring(_a910.id)))
end
return _a910.id, _a911
end
end
end
return nil
end
function _a576.move.bestZone()
if _a574.Zone and rawget(_a574.Zone, "GetMaxOwnedZone") then
local _a912, _a913, _a914 = pcall(_a574.Zone.GetMaxOwnedZone)
if _a912 and _a913 then return _a913, _a914 end
end
return _a576.move.zone1()
end
function _a576.move.ownsZone(_a915)
local _a916 = _a603()
local _a917 = _a916 and rawget(_a916, "UnlockedZones")
return (type(_a917) == "table" and _a917[_a915] ~= nil) or false
end
function _a576.move.zoneByNumber(_a918)
if not (_a574.DirZones and _a918) then return nil end
for _a919, _a920 in pairs(_a574.DirZones) do
if type(_a920) == "table" and tonumber(rawget(_a920, "ZoneNumber")) == tonumber(_a918) then
return _a919, _a920
end
end
return nil
end
local function _a921(_a922, _a923)
local _a924 = rawget(_a922, "Breakables")
local _a925 = type(_a924) == "table" and rawget(_a924, "Main") or nil
local _a926 = type(_a925) == "table" and rawget(_a925, "Data") or nil
if type(_a926) ~= "table" then return false end
for _a927, _a928 in pairs(_a926) do
local _a929 = type(_a928) == "table" and rawget(_a928, "Type") or nil
if _a929 and tostring(_a929):lower():find(_a923, 1, true) then return true end
end
return false
end
function _a576.move.zoneForBreakable(_a930)
if not (_a574.DirZones and _a930) then return nil end
local _a931 = tostring(_a930):lower()
local _a932 = _a576.move.bestZone()
if _a932 then
local _a933 = rawget(_a574.DirZones, _a932)
if type(_a933) == "table" and _a921(_a933, _a931) then return _a932 end
end
local _a934, _a935 = nil, -1
for _a936, _a937 in pairs(_a574.DirZones) do
if type(_a937) == "table" and _a936 ~= "Spawn" and _a576.move.ownsZone(_a936) then
local _a938 = rawget(_a937, "Breakables")
local _a939 = type(_a938) == "table" and rawget(_a938, "Main") or nil
local _a940 = type(_a939) == "table" and rawget(_a939, "Data") or nil
if type(_a940) == "table" then
for _a941, _a942 in pairs(_a940) do
local _a943 = type(_a942) == "table" and rawget(_a942, "Type") or nil
if _a943 and tostring(_a943):lower():find(_a931, 1, true) then
local _a944 = tonumber(rawget(_a937, "ZoneNumber")) or 0
if _a944 > _a935 then _a934, _a935 = _a936, _a944 end
break
end
end
end
end
end
return _a934
end
function _a576.move.tpZone(_a945)
if not _a945 then return false, "존 id 없음" end
if _a576.move.curZone() == _a945 then return true end
if not _a569.TpGameFallback then
_a563("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a945) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a946 = _a574.R_Tp
if _a574.Inst and rawget(_a574.Inst, "IsInInstance") then
local _a947, _a948 = pcall(_a574.Inst.IsInInstance)
if _a947 and _a948 and _a574.R_TpI then _a946 = _a574.R_TpI end
end
if not _a946 then return false, "텔레포트 리모트 없음" end
local _a949 = os.clock() - (_a576.move.lastTp or 0)
if _a949 < _a569.TpCooldown then task.wait(_a569.TpCooldown - _a949) end
_a576.move.lastTp = os.clock()
local _a950, _a951
pcall(function() _a950, _a951 = _a946:InvokeServer(_a945) end)
if not _a950 then return false, _a951 end
local _a952 = os.clock()
while os.clock() - _a952 < 5 do
if _a576.move.curZone() == _a945 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a576.move.glideTo(_a953)
if _a576.ctl.stopped() then return false, "정지됨" end
if _a576.ctl.moving and (os.clock() - _a576.ctl.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a576.ctl.moving = os.clock()
local _a954, _a955, _a956 = pcall(_a576.move.glideRaw, _a953)
_a576.ctl.moving = nil
if not _a954 then return false, tostring(_a955) end
return _a955, _a956
end
function _a576.move.glideRaw(_a957)
local _a958, _a959 = _a576.move.hrp()
if not _a958 then return false, "캐릭터 없음" end
if _a569.TpMode == "instant" then
local _a960 = _a957 + Vector3.new(0, 4, 0)
for _a961 = 1, 3 do
local _a962 = _a562.Character
local _a963, _a964 = _a576.move.hrp()
if not (_a962 and _a963) then return false, "캐릭터 없음" end
local _a965 = _a963.CFrame - _a963.CFrame.Position
pcall(function() _a962:PivotTo(CFrame.new(_a960) * _a965) end)
_a963.AssemblyLinearVelocity = Vector3.zero
for _a966 = 1, 6 do _a561.Heartbeat:Wait() end
if _a964 then
pcall(function()
_a964:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a964:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a963 = _a576.move.hrp()
if _a963 and (_a963.Position - _a960).Magnitude <= 30 then
local _a967 = os.clock()
while os.clock() - _a967 < 1.5 do
if _a576.move.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a961 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a569.TpMode == "walk" then
if not _a959 then return false, "Humanoid 없음" end
local _a968 = os.clock()
while os.clock() - _a968 < 45 do
local _a969 = _a958.Position
if (Vector3.new(_a969.X, 0, _a969.Z) - Vector3.new(_a957.X, 0, _a957.Z)).Magnitude < 8 then
return true
end
_a959:MoveTo(_a957)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a958.Position - _a957).Magnitude <= (_a569.ArriveDist or 12) then return true end
local _a970 = math.max(16, tonumber(_a569.TpSpeed) or 90)
local _a971 = math.max(0, tonumber(_a569.TpHeight) or 0)
local function _a972(_a973, _a974)
local _a975 = 0
while _a975 < 2000 do
if _a576.ctl.stopped() then return false end
_a975 += 1
local _a976 = _a576.move.hrp()
if not _a976 then return false end
local _a977 = _a976.Position
local _a978 = _a973 - _a977
local _a979 = _a978.Magnitude
if _a979 < 2.5 then return true end
local _a980 = _a561.Heartbeat:Wait()
local _a981 = math.min(_a979, _a970 * math.min(_a980, 0.1))
local _a982 = _a974 and (Vector3.new(_a973.X, _a977.Y, _a973.Z)) or nil
if _a982 and (_a982 - _a977).Magnitude > 1 then
_a976.CFrame = CFrame.lookAt(_a977 + _a978.Unit * _a981, _a982)
else
_a976.CFrame = CFrame.new(_a977 + _a978.Unit * _a981) * (_a976.CFrame - _a976.Position)
end
_a976.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a971 > 0 then
local _a983 = _a958.Position
local _a984 = math.max(_a983.Y, _a957.Y) + _a971
_a972(Vector3.new(_a983.X, _a984, _a983.Z), false)
_a972(Vector3.new(_a957.X, _a984, _a957.Z), true)
end
_a972(_a957 + Vector3.new(0, 3, 0), true)
local _a985 = _a576.move.hrp()
if _a985 then _a985.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a986(_a987)
local _a988 = #_a987
if _a988 == 0 then return nil, 0 end
local _a989, _a990 = math.huge, -math.huge
local _a991, _a992 = math.huge, -math.huge
local _a993 = 0
for _a994, _a995 in ipairs(_a987) do
if _a995.X < _a989 then _a989 = _a995.X end
if _a995.X > _a990 then _a990 = _a995.X end
if _a995.Z < _a991 then _a991 = _a995.Z end
if _a995.Z > _a992 then _a992 = _a995.Z end
_a993 += _a995.Y
end
return Vector3.new((_a989 + _a990) / 2, _a993 / _a988, (_a991 + _a992) / 2), _a988
end
function _a576.move.breakCenter(_a996)
local _a997 = _a576.move.hrp()
if not _a997 then return nil, 0 end
local _a998 = workspace:FindFirstChild("__THINGS")
if not _a998 then return nil, 0 end
local _a999 = _a997.Position
local _a1000 = {}
for _a1001, _a1002 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1003 = _a998:FindFirstChild(_a1002)
if _a1003 then
for _a1004, _a1005 in ipairs(_a1003:GetChildren()) do
local _a1006
if _a1005:IsA("BasePart") then _a1006 = _a1005.Position
elseif _a1005:IsA("Model") then
local _a1007, _a1008 = pcall(function() return _a1005:GetPivot() end)
if _a1007 and typeof(_a1008) == "CFrame" then _a1006 = _a1008.Position end
end
if _a1006 and (_a1006 - _a999).Magnitude <= (_a996 or 400) then
_a1000[#_a1000 + 1] = _a1006
end
end
end
end
return _a986(_a1000)
end
function _a576.move.groundY(_a1009, _a1010, _a1011)
_a1011 = tonumber(_a1011) or 0
local _a1012 = RaycastParams.new()
_a1012.FilterType = Enum.RaycastFilterType.Exclude
local _a1013 = {}
if _a562.Character then _a1013[#_a1013 + 1] = _a562.Character end
local _a1014 = workspace:FindFirstChild("__THINGS")
if _a1014 then _a1013[#_a1013 + 1] = _a1014 end
_a1012.FilterDescendantsInstances = _a1013
local _a1015 = Vector3.new(_a1009, _a1011 + 12, _a1010)
local _a1016, _a1017 = pcall(function()
return workspace:Raycast(_a1015, Vector3.new(0, -160, 0), _a1012)
end)
if _a1016 and _a1017 then
local _a1018 = _a1017.Position.Y
if math.abs(_a1018 - _a1011) <= 80 then return _a1018 + 4 end
end
return nil
end
function _a576.move.zonePos(_a1019, _a1020)
if not _a1019 then return nil, "존 id 없음" end
_a1019 = _a576.move.realZone(_a1019)
local _a1021 = _a574.DirZones and rawget(_a574.DirZones, _a1019)
local _a1022 = _a1021 and rawget(_a1021, "ZoneFolder")
local _a1023 = {}
do
local _a1024 = workspace:FindFirstChild("__THINGS")
for _a1025, _a1026 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1027 = _a1024 and _a1024:FindFirstChild(_a1026)
if _a1027 then
for _a1028, _a1029 in ipairs(_a1027:GetChildren()) do
local _a1030
if _a1029:IsA("BasePart") then _a1030 = _a1029.Position
elseif _a1029:IsA("Model") then
local _a1031, _a1032 = pcall(function() return _a1029:GetPivot() end)
if _a1031 and typeof(_a1032) == "CFrame" then _a1030 = _a1032.Position end
end
if _a1030 then _a1023[#_a1023 + 1] = _a1030 end
end
end
end
end
local _a1033 = {}
local function _a1034(_a1035, _a1036)
if not _a1035 then return end
local _a1037, _a1038 = pcall(function() return _a1035:GetDescendants() end)
if _a1035:IsA("BasePart") then _a1033[#_a1033 + 1] = { p = _a1035.Position, why = _a1036 } end
if _a1037 then
for _a1039, _a1040 in ipairs(_a1038) do
if _a1040:IsA("BasePart") then
_a1033[#_a1033 + 1] = { p = _a1040.Position, why = _a1036 .. "/" .. _a1040.Name }
end
end
end
end
if _a574.ZonesU then
for _a1041, _a1042 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a1043 = rawget(_a574.ZonesU, _a1042)
if type(_a1043) == "function" then
local _a1044, _a1045 = pcall(_a1043, _a1019)
if _a1044 and _a1045 then _a1034(_a1045, _a1042) end
end
end
end
if _a1022 then
for _a1046, _a1047 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a1048, _a1049 = pcall(function() return _a1022:FindFirstChild(_a1047, true) end)
if _a1048 and _a1049 then _a1034(_a1049, "ZoneFolder/" .. _a1047) end
end
end
local _a1050, _a1051, _a1052
for _a1053, _a1054 in ipairs(_a1033) do
local _a1055 = 0
for _a1056, _a1057 in ipairs(_a1023) do
if (_a1057 - _a1054.p).Magnitude <= 150 then _a1055 += 1 end
end
if not _a1051 or _a1055 > _a1051 then _a1050, _a1051, _a1052 = _a1054.p, _a1055, _a1054.why end
end
local _a1058, _a1059
if _a1050 and (_a1051 or 0) >= 1 then
_a1058, _a1059 = _a1050, ("%s (브레이커블 %d개)"):format(tostring(_a1052), _a1051)
end
if not _a1058 and _a1050 then
_a1058, _a1059 = _a1050, tostring(_a1052) .. " (브레이커블 없음)"
end
if not _a1058 and _a574.ZonesU and rawget(_a574.ZonesU, "GetTeleportPartLocation") then
local _a1060, _a1061 = pcall(_a574.ZonesU.GetTeleportPartLocation, _a1019)
if _a1060 and typeof(_a1061) == "CFrame" then
_a1058, _a1059 = _a1061.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a1058 then return nil, "브레이커블 위치를 못 찾음" end
local _a1062 = _a576.move.groundY(_a1058.X, _a1058.Z, _a1058.Y)
if _a1062 then
_a1058 = Vector3.new(_a1058.X, _a1062, _a1058.Z)
_a1059 = _a1059 .. " +지면"
else
_a1058 = Vector3.new(_a1058.X, _a1058.Y + 5, _a1058.Z)
end
return _a1058, _a1059
end
function _a576.move.goToZone(_a1063, _a1064, _a1065, _a1066)
_a1063 = _a576.move.realZone(_a1063)
if not _a1063 then return false, "존 id 없음" end
local _a1067, _a1068 = _a576.move.zonePos(_a1063)
if not _a1067 then
if _a569.TpGameFallback and _a576.move.curZone() ~= _a1063 then
local _a1069, _a1070 = _a576.move.tpZone(_a1063)
if not _a1069 then return false, _a1070 end
task.wait(0.3)
_a1067, _a1068 = _a576.move.zonePos(_a1063)
end
if not _a1067 then
local _a1071, _a1072 = _a576.move.resolvableZone(_a1063)
if _a1071 and _a1072 then
if _a1066 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a1063))
end
_a1063, _a1067, _a1068 = _a1071, _a1072, "대체 존 " .. tostring(_a1071)
else
if _a576.move.zoneFailSaid ~= _a1063 then
_a576.move.zoneFailSaid = _a1063
_a563(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a1063), tostring(_a1068)))
end
return false, _a1068
end
end
end
local _a1073 = _a576.move.hrp()
if not _a1065 and _a1073 and _a576.move.curZone() == _a1063 then
local _a1074 = _a576.move.inDottedBox()
local _a1075
if _a1074 ~= nil then
_a1075 = _a1074
else
_a1075 = (_a1073.Position - _a1067).Magnitude <= (_a569.ZoneArriveDist or 90)
end
if _a1075 then
if _a1064 then _a563("[TP] 이미 " .. _a1063 .. " 사냥터 안에 있음") end
return true
end
end
if _a1064 then
_a563(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a1063, tostring(_a1068), _a1067.X, _a1067.Y, _a1067.Z))
end
local _a1076, _a1077 = _a576.move.glideTo(_a1067)
local _a1078 = _a576.move.hrp()
if _a1078 and (_a1078.Position - _a1067).Magnitude > math.max(40, _a569.ArriveDist or 12) then
task.wait(0.2)
_a576.ctl.moving = nil
_a576.move.glideTo(_a1067)
local _a1079 = _a576.move.hrp()
local _a1080 = _a1079 and (_a1079.Position - _a1067).Magnitude or -1
if _a1080 > math.max(40, _a569.ArriveDist or 12) then
local _a1081 = _a569.TpMode
_a569.TpMode = "glide"
_a576.ctl.moving = nil
_a576.move.glideTo(_a1067)
_a569.TpMode = _a1081
local _a1082 = _a576.move.hrp()
_a1080 = _a1082 and (_a1082.Position - _a1067).Magnitude or -1
if _a1080 > math.max(40, _a569.ArriveDist or 12) then
_a563(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a1063), _a1080))
return false, "이동이 되돌려짐"
end
_a563("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a1063))
end
end
do
local _a1083 = _a576.move.hrp()
if _a1083 and (_a1083.Position.Y - _a1067.Y) > 25 then
_a563(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a1083.Position.Y - _a1067.Y))
_a576.ctl.moving = nil
_a576.move.glideTo(Vector3.new(_a1067.X, _a1067.Y, _a1067.Z))
end
end
if tostring(_a1068):find("스트리밍", 1, true) then
task.wait(1.2)
local _a1084, _a1085 = _a576.move.zonePos(_a1063)
if _a1084 and not tostring(_a1085):find("스트리밍", 1, true) then
if _a1064 then
_a563("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a1085) .. ")")
end
_a576.ctl.moving = nil
_a576.move.glideTo(_a1084)
_a1067, _a1068 = _a1084, _a1085
end
end
if _a576.move.inDottedBox() == false then
task.wait(0.2)
local _a1086, _a1087 = _a576.move.breakCenter(400)
if _a1086 and _a1087 >= 3 then
if _a1064 then
_a563(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a1087))
end
_a576.ctl.moving = nil
_a576.move.glideTo(_a1086)
_a1067 = _a1086
end
if _a576.move.inDottedBox() == false then
local _a1088 = _a576.move.zonePos(_a1063)
if _a1088 and (_a1088 - _a1067).Magnitude > 5 then
if _a1064 then _a563("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a576.ctl.moving = nil
_a576.move.glideTo(_a1088)
_a1067 = _a1088
end
end
if _a576.move.inDottedBox() == false and _a1064 then
_a563(("[TP] %s 네모 안으로 못 들어감 (좌표 %s)"):format(_a1063, tostring(_a1068)))
end
end
local function _a1089()
if _a576.move.inDottedBox() == true then return false end
local _a1090, _a1091 = _a576.move.breakCenter(400)
if (_a1091 or 0) >= 1 then return false end
task.wait(0.6)
if _a576.move.inDottedBox() == true then return false end
local _a1092, _a1093 = _a576.move.breakCenter(400)
return (_a1093 or 0) < 1
end
if _a1089() and (os.clock() - (_a576.move.lastRecover or -999)) > 30 then
_a576.move.lastRecover = os.clock()
_a563(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a1063), tostring(_a1068)))
end
_a576.move.zoneFailSaid = nil
_a576.move.arrivedZone = _a1063
do
local _a1094 = _a576.move.hrp()
local _a1095 = _a1094 and (_a1094.Position - _a1067).Magnitude or 0
if _a1095 > math.max(60, _a569.ArriveDist or 12) then
_a563(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a1063), _a1095))
return false, "이동이 되돌려짐"
end
end
local _a1096 = _a576.move.hrp()
if _a1064 and _a1096 then
_a563(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a1096.Position - _a1067).Magnitude, tostring(_a576.move.curZone()), tostring(_a576.move.inDottedBox())))
end
return true
end
function _a576.egg.tpEgg(_a1097)
if not _a1097 then return false, "알 id 없음" end
for _a1098, _a1099 in ipairs(_a576.egg.eggStands()) do
if _a1099.id == _a1097 then
if _a1099.dist <= _a569.EggRange then return true, _a1097 end
local _a1100, _a1101 = _a576.move.glideTo(_a1099.pos)
return _a1100, _a1100 and _a1097 or _a1101
end
end
if _a569.TpGameFallback then
local _a1102 = _a574.DirEggs and rawget(_a574.DirEggs, _a1097)
local _a1103 = _a1102 and select(1, _a576.move.zoneByNumber(rawget(_a1102, "zoneNumber")))
if _a1103 and _a576.move.curZone() ~= _a1103 then
local _a1104, _a1105 = _a576.move.tpZone(_a1103)
if not _a1104 then return false, _a1105 end
task.wait(0.5)
_a576.egg._standsAt = nil
for _a1106, _a1107 in ipairs(_a576.egg.eggStands()) do
if _a1107.id == _a1097 then return _a576.move.glideTo(_a1107.pos), _a1097 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a1097) .. ")"
end
function _a576.item.stacks(_a1108)
local _a1109 = _a603()
local _a1110 = _a1109 and rawget(_a1109, "Inventory")
local _a1111 = _a1110 and rawget(_a1110, _a1108)
if type(_a1111) ~= "table" then return {} end
local _a1112 = {}
for _a1113, _a1114 in pairs(_a1111) do
if type(_a1114) == "table" then
_a1112[#_a1112 + 1] = {
uid = _a1113,
id = tostring(rawget(_a1114, "id")),
tier = tonumber(rawget(_a1114, "tn")) or 1,
am = tonumber(rawget(_a1114, "_am")) or 1,
}
end
end
return _a1112
end
_a576.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a576.item.perTier(_a1115, _a1116)
_a1116 = tonumber(_a1116)
local _a1117 = _a574.Bal and rawget(_a574.Bal,
_a1115 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a1117) == "function" then
local _a1118, _a1119 = pcall(_a1117, _a1116)
_a1119 = _a1118 and tonumber(_a1119) or nil
if _a1119 and _a1119 > 0 then return _a1119 end
if not _a1118 and not _a576.item.perTierWarned then
_a576.item.perTierWarned = true
_a563("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a1119) .. ")")
end
end
local _a1120 = _a576.item.PERTIER[_a1115]
local _a1121 = _a1120 and _a1116 and _a1120[_a1116]
return (_a1121 and _a1121 > 0) and _a1121 or nil
end
function _a576.item.upgradeTo(_a1122, _a1123)
local _a1124 = (_a1122 == "Potion") and _a574.R_PotUp or _a574.R_EncUp
if not _a1124 then return 0, (_a1122 .. " 업글 리모트 없음") end
local _a1125 = math.max(1, (tonumber(_a1123) or 2) - 1)
local _a1126 = _a576.item.perTier(_a1122, _a1125)
if not _a1126 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a1125) end
local _a1127, _a1128 = {}, 0
for _a1129, _a1130 in ipairs(_a576.item.stacks(_a1122)) do
if _a1130.tier == _a1125 then
local _a1131 = math.floor(_a1130.am / _a1126)
if _a1131 > 0 then _a1127[_a1130.uid] = _a1131 _a1128 += _a1131 end
end
end
if _a1128 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a1125, _a1125, _a1126) end
local _a1132, _a1133
pcall(function() _a1132, _a1133 = _a1124:InvokeServer(_a1127) end)
if not _a1132 then return 0, tostring(_a1133) end
return _a1128
end
function _a576.item.usePotion(_a1134, _a1135)
if not _a574.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a1134 = tonumber(_a1134) or 1
local _a1136 = {}
for _a1137, _a1138 in ipairs(_a576.item.stacks("Potion")) do
if _a1138.tier >= _a1134 and _a1138.am >= 1 then _a1136[#_a1136 + 1] = _a1138 end
end
if #_a1136 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a1134) end
table.sort(_a1136, function(_a1139, _a1140) return _a1139.tier < _a1140.tier end)
local _a1141, _a1142 = _a1135, 0
for _a1143, _a1144 in ipairs(_a1136) do
for _a1145 = 1, math.min(_a1141, _a1144.am) do
if _a1141 < 1 or not _a570.quest then break end
pcall(function() _a574.R_PotUse:FireServer(_a1144.uid, 1) end)
_a1142 += 1
_a1141 -= 1
task.wait(0.12)
end
if _a1141 < 1 then break end
end
return _a1142
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
local function _a1146(_a1147)
if typeof(_a1147) == "Vector3" then return _a1147 end
if typeof(_a1147) == "CFrame" then return _a1147.Position end
if type(_a1147) == "table" then
local _a1148, _a1149, _a1150 = tonumber(_a1147.X or _a1147.x or _a1147[1]), tonumber(_a1147.Y or _a1147.y or _a1147[2]), tonumber(_a1147.Z or _a1147.z or _a1147[3])
if _a1148 and _a1149 and _a1150 then return Vector3.new(_a1148, _a1149, _a1150) end
end
return nil
end
function _a576.ev.events()
local _a1151
if _a574.Rand and rawget(_a574.Rand, "GetActive") then
local _a1152, _a1153 = pcall(_a574.Rand.GetActive)
if _a1152 and type(_a1153) == "table" and next(_a1153) then _a1151 = _a1153 end
end
if not _a1151 and _a574.R_Events then
local _a1154, _a1155 = pcall(function() return _a574.R_Events:InvokeServer() end)
if _a1154 and type(_a1155) == "table" then _a1151 = _a1155 end
end
if type(_a1151) ~= "table" then return {} end
local _a1156 = workspace:GetServerTimeNow()
local _a1157 = {}
for _a1158, _a1159 in pairs(_a1151) do
if type(_a1159) == "table" then
local _a1160 = tostring(rawget(_a1159, "id") or "")
local _a1161 = _a1160:match("|%s*(%S+)%s*$") or _a1160
local _a1162 = tonumber(rawget(_a1159, "started")) or 0
local _a1163 = tonumber(rawget(_a1159, "duration")) or 0
_a1157[#_a1157 + 1] = {
uid = rawget(_a1159, "uid"),
id = _a1160,
kind = _a1161,
name = rawget(_a1159, "name") or _a1161,
zone = rawget(_a1159, "parentID"),
pos = _a1146(rawget(_a1159, "origin")),
left = math.max(0, _a1163 - (_a1156 - _a1162)),
}
end
end
table.sort(_a1157, function(_a1164, _a1165) return _a1164.left > _a1165.left end)
return _a1157
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
local _a1166, _a1167 = pcall(_a574.Map.IsInDottedBox)
if _a1166 then return _a1167 and true or false end
end
return nil
end
function _a576.ev.spawnItems(_a1168)
local _a1169 = _a576.ev.SPAWN[_a1168]
if not _a1169 then return {} end
local _a1170 = {}
for _a1171, _a1172 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a1173, _a1174 in ipairs(_a576.item.stacks(_a1172)) do
local _a1175 = _a1174.id:lower()
if _a1175:find(_a1169.key, 1, true) then
local _a1176 = 99
if _a1169.order then
for _a1177, _a1178 in ipairs(_a1169.order) do
if _a1175:find(_a1178, 1, true) then _a1176 = _a1177 break end
end
end
_a1174.rank = _a1176
_a1170[#_a1170 + 1] = _a1174
end
end
end
table.sort(_a1170, function(_a1179, _a1180)
if _a1179.rank ~= _a1180.rank then return _a1179.rank < _a1180.rank end
return _a1179.tier < _a1180.tier
end)
return _a1170
end
function _a576.ev.spawnEvent(_a1181)
local _a1182 = _a576.ev.SPAWN[_a1181]
if not _a1182 then return 0, "소환 불가 종류" end
local _a1183 = _a567:FindFirstChild(_a1182.rem)
if not _a1183 then return 0, _a1182.rem .. " 리모트 없음" end
local _a1184 = _a576.ev.spawnItems(_a1181)
if #_a1184 == 0 then return 0, _a1181 .. " 아이템 없음" end
local _a1185 = _a576.move.inDottedBox()
if _a1185 == false then return 0, "점선 네모 안이 아님" end
local _a1186, _a1187 = 0, nil
for _a1188, _a1189 in ipairs(_a1184) do
if _a1186 >= (_a569.SpawnPerCycle or 1) or not _a570.quest then break end
local _a1190, _a1191
pcall(function() _a1190, _a1191 = _a1183:InvokeServer(_a1189.uid) end)
if _a1190 then
_a1186 += 1
_a576.ctl.setAct("소환", _a1181 .. " · " .. _a1189.id)
_a563(("  🎁 %s 소환  (%s)"):format(_a1181, _a1189.id))
task.wait(0.4)
else
_a1187 = _a1191
break
end
end
return _a1186, _a1187
end
function _a576.ev.findEvent(_a1192, _a1193)
local _a1194 = _a1193 and _a576.move.bestZone() or nil
local _a1195
for _a1196, _a1197 in ipairs(_a576.ev.events()) do
if _a1197.kind == _a1192 and _a1197.left > 15 then
if not _a1193 or _a1197.zone == _a1194 then
if not _a1195 or (_a1197.zone == _a576.move.curZone() and _a1195.zone ~= _a576.move.curZone()) then
_a1195 = _a1197
end
end
end
end
return _a1195
end
function _a576.ev.findChest(_a1198, _a1199)
local _a1200 = workspace:FindFirstChild("__THINGS")
if not _a1200 then return nil end
local _a1201 = tostring(_a1198):lower():find("superior") ~= nil
local _a1202 = _a576.move.hrp()
local _a1203 = _a1202 and _a1202.Position
local _a1204, _a1205, _a1206, _a1207
for _a1208, _a1209 in ipairs(_a1200:GetChildren()) do
if tostring(_a1209.Name):lower():find("chest", 1, true) then
for _a1210, _a1211 in ipairs(_a1209:GetChildren()) do
local _a1212
if _a1211:IsA("BasePart") then _a1212 = _a1211.Position
elseif _a1211:IsA("Model") then
local _a1213, _a1214 = pcall(function() return _a1211:GetPivot() end)
if _a1213 and typeof(_a1214) == "CFrame" then _a1212 = _a1214.Position end
end
if _a1212 then
local _a1215 = _a1203 and (_a1212 - _a1203).Magnitude or 0
local _a1216 = (tostring(_a1211.Name) .. tostring(_a1209.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a1207 or _a1215 < _a1207 then _a1206, _a1207 = _a1212, _a1215 end
if _a1216 == _a1201 and (not _a1205 or _a1215 < _a1205) then
_a1204, _a1205 = _a1212, _a1215
end
end
end
end
end
if _a1204 then return _a1204, _a1205 end
return _a1206, _a1207
end
_a576.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a576.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a576.item.petStacks()
local _a1217 = _a603()
local _a1218 = _a1217 and rawget(_a1217, "Inventory")
local _a1219 = _a1218 and rawget(_a1218, "Pet")
local _a1220 = {}
if type(_a1219) ~= "table" then return _a1220 end
for _a1221, _a1222 in pairs(_a1219) do
if type(_a1222) == "table" then
_a1220[#_a1220 + 1] = {
uid = _a1221,
id = tostring(rawget(_a1222, "id")),
pt = tonumber(rawget(_a1222, "pt")) or 0,
am = tonumber(rawget(_a1222, "_am")) or 1,
}
end
end
return _a1220
end
function _a576.item.bestEggPets()
local _a1223 = _a651()
local _a1224 = _a1223 and _a574.DirEggs and rawget(_a574.DirEggs, _a1223)
local _a1225 = _a1224 and rawget(_a1224, "pets")
local _a1226 = {}
if type(_a1225) == "table" then
for _a1227, _a1228 in pairs(_a1225) do
local _a1229 = type(_a1228) == "table" and _a1228[1] or _a1228
if _a1229 then _a1226[tostring(_a1229)] = true end
end
end
return _a1226, _a1223
end
function _a576.item.makeVariant(_a1230, _a1231)
local _a1232 = (_a1230 == "gold") and _a574.R_Gold or _a574.R_Rain
if not _a1232 then return 0, (_a1230 .. " 머신 리모트 없음") end
local _a1233 = (_a1230 == "gold") and 0 or 1
local _a1234
if _a1231 then
local _a1235, _a1236 = _a576.item.bestEggPets()
if not next(_a1235) then return 0, "최고 알(" .. tostring(_a1236) .. ") 펫 목록을 못 읽음" end
_a1234 = _a1235
end
local _a1237, _a1238 = 0, nil
for _a1239, _a1240 in ipairs(_a576.item.petStacks()) do
if not _a570.quest then break end
if _a1240.pt == _a1233 and _a1240.am >= 10 and (not _a1234 or _a1234[_a1240.id]) then
local _a1241 = math.floor(_a1240.am / 10)
if _a1241 > 0 then
local _a1242, _a1243
pcall(function() _a1242, _a1243 = _a1232:InvokeServer(_a1240.uid, _a1241) end)
if _a1242 then
_a1237 += _a1241
_a563(("  ✨ %s 제작  %s x%d"):format(
_a1230 == "gold" and "골드" or "레인보우", _a1240.id, _a1241))
task.wait(0.4)
else
_a1238 = _a1243
end
end
end
end
return _a1237, _a1238
end
function _a576.item.useFlag(_a1244)
if not _a574.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a1245, _a1246 = 0, nil
for _a1247, _a1248 in ipairs(_a576.item.stacks("Misc")) do
if _a1245 >= (_a1244 or 1) then break end
if _a1248.id:lower():find("flag", 1, true) and _a1248.am >= 1 and _a576.item.itemAllowed(_a1248.id) then
local _a1249, _a1250
pcall(function() _a1249, _a1250 = _a574.R_Flag:InvokeServer(_a1248.id, _a1248.uid, 1) end)
if _a1249 then _a1245 += 1 task.wait(0.4) else _a1246 = _a1250 end
end
end
return _a1245, _a1246
end
function _a576.item.useFruit(_a1251)
if not _a574.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a1252 = _a576.item.activeBuffs("Fruits")
local _a1253 = 0
for _a1254, _a1255 in ipairs(_a576.item.stacks("Fruit")) do
if _a1253 >= (_a1251 or 1) then break end
if _a1255.am >= 1 and _a576.item.itemAllowed(_a1255.id) and not _a1252[_a1255.id] then
pcall(function() _a574.R_Fruit:FireServer(_a1255.uid, 1) end)
_a1253 += 1
task.wait(0.4)
end
end
return _a1253
end
function _a576.quest.status()
local _a1256 = _a603()
if not _a1256 then return nil end
local _a1257 = rawget(_a1256, "Goals")
if type(_a1257) ~= "table" then return { list = {} } end
local _a1258 = {}
for _a1259, _a1260 in pairs(_a1257) do
if type(_a1260) == "table" then
local _a1261 = tonumber(rawget(_a1260, "Type")) or -1
local _a1262
if _a574.Quest and rawget(_a574.Quest, "MakeTitle") then
local _a1263, _a1264 = pcall(_a574.Quest.MakeTitle, _a1260)
if _a1263 then _a1262 = _a1264 end
end
_a1258[#_a1258 + 1] = {
slot = _a1259,
uid = tostring(rawget(_a1260, "UID")),
type = _a1261,
how = _a575[_a1261],
title = _a1262 or ("Type " .. _a1261),
amount = tonumber(rawget(_a1260, "Amount")) or 0,
progress = tonumber(rawget(_a1260, "Progress")) or 0,
stars = tonumber(rawget(_a1260, "Stars")) or 0,
potionTier = tonumber(rawget(_a1260, "PotionTier")),
enchantTier = tonumber(rawget(_a1260, "EnchantTier")),
breakable = rawget(_a1260, "BreakableType") or rawget(_a1260, "BreakableDirID"),
zoneId = rawget(_a1260, "ZoneID"),
where = _a576.quest.WHERE[_a1261] or (_a575[_a1261] == "farm" and "bestzone" or nil),
event = _a576.ev.EVENTKIND[_a1261],
chest = _a576.ev.CHESTKIND[_a1261],
bestOnly = _a576.ev.BESTONLY[_a1261] or false,
ignored = _a576.quest.IGNORE[_a1261],
}
end
end
table.sort(_a1258, function(_a1265, _a1266) return _a1265.stars > _a1266.stars end)
return { list = _a1258, rank = tonumber(rawget(_a1256, "Rank")) or 1,
rankStars = tonumber(rawget(_a1256, "RankStars")) or 0 }
end
_a576.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a576.quest.bestDepActive()
local _a1267 = _a576.ctl.lockGoal and _a576.ctl.lockGoal.q
if not _a1267 then return false end
if _a576.quest.IGNORE[_a1267.type] then return false end
if not _a576.quest.BESTDEP[_a1267.type] then return false end
local _a1268 = _a576.quest.findQuest(_a1267.uid)
if not _a1268 or _a1268.progress >= _a1268.amount then return false end
return true, _a1268
end
function _a576.quest.canDo(_a1269, _a1270)
if _a1269.how == "hatch" or _a1269.where == "bestegg" then
local _a1271 = _a676()
if not _a1271 then return false, "알 정보를 못 읽음" end
if not _a1271.price then return true end
if not _a1270 then
if _a1271.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a1271.id), _a564(_a1271.price, 0), tostring(_a1271.currency), _a564(_a1271.have, 0))
end
return true
end
local _a1272 = math.max(1, (_a1269.amount or 1) - (_a1269.progress or 0))
local _a1273 = _a1272
if _a1269.type == 2 or _a1269.type == 42 or _a1269.type == 47 then
_a1273 = math.max(_a1272, _a569.HatchMinAfford or 10)
end
if _a1271.canBuy < _a1273 then
_a576.quest.moneyUntil = os.clock() + math.max(0, _a569.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a1273, _a1271.canBuy, _a564(_a1271.price, 0), tostring(_a1271.currency))
end
if _a576.quest.moneyUntil and os.clock() < _a576.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a576.quest.moneyUntil - os.clock())
end
_a576.quest.moneyUntil = nil
end
return true
end
function _a576.quest.findQuest(_a1274)
local _a1275 = _a576.quest.status()
for _a1276, _a1277 in ipairs(_a1275 and _a1275.list or {}) do
if _a1277.uid == _a1274 then return _a1277 end
end
return nil
end
function _a576.quest.pursue(_a1278)
local _a1279, _a1280
if _a1278.how == "hatch" then _a1279, _a1280 = _a687, "mhatch"
elseif _a1278.how == "zone" then _a1279, _a1280 = _a646, "zone"
elseif _a1278.how == "gold" or _a1278.how == "rainbow" then
local _a1281 = (_a1278.type == 40 or _a1278.type == 41)
_a1280 = "quest"
_a1279 = function()
local _a1282 = _a576.item.makeVariant("gold", _a1281) or 0
if _a1278.how == "rainbow" then
_a1282 += (_a576.item.makeVariant("rainbow", _a1281) or 0)
end
if _a1282 > 0 then
_a576.ctl.setAct(_a1278.how == "gold" and "골드 합성" or "레인보우 합성", _a1282 .. "마리")
return
end
_a576.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a1283 = _a570.mhatch
_a570.mhatch = true
pcall(_a687)
_a570.mhatch = _a1283
end
end
local _a1284 = _a1278.progress
local _a1285 = os.clock()
_a576.ctl.setGoal(_a1278.title, ("%d/%d"):format(_a1278.progress, _a1278.amount))
local function _a1286()
if not _a1278.event then return end
local _a1287 = _a576.ev.findEvent(_a1278.event, _a1278.bestOnly)
if _a1287 then
_a576.ctl.setAct(_a1278.event .. " 진행 중", ("%d초 남음"):format(_a1287.left))
if _a1287.pos then
local _a1288 = _a576.move.hrp()
if _a1288 and (_a1288.Position - _a1287.pos).Magnitude > (_a569.EventStayDist or 45) then
_a576.move.glideTo(_a1287.pos)
end
end
return
end
local _a1289, _a1290 = _a576.ev.spawnEvent(_a1278.event)
if _a1289 > 0 then
_a576.ctl.setAct("소환", _a1278.event)
task.wait(0.5)
elseif _a1290 and _a576.ev.spawnErr ~= tostring(_a1290) then
_a576.ev.spawnErr = tostring(_a1290)
_a563("[퀘스트] " .. _a1278.event .. " 소환 실패: " .. tostring(_a1290))
end
end
local _a1291, _a1292 = pcall(function()
while _a570.quest and not _a576.ctl.stopped() do
local _a1293, _a1294 = _a576.quest.canDo(_a1278, false)
if not _a1293 then
_a563(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a1278.title), tostring(_a1294)))
return
end
_a1286()
if _a1279 then
local _a1295 = _a570[_a1280]
_a570[_a1280] = true
local _a1296, _a1297 = pcall(_a1279)
_a570[_a1280] = _a1295
if not _a1296 then error(_a1297, 0) end
elseif _a1278.event then
task.wait(0.4)
else
task.wait(2)
end
local _a1298 = _a576.quest.findQuest(_a1278.uid)
if not _a1298 then
_a563("[퀘스트] 완료 — " .. tostring(_a1278.title))
return
end
_a576.ctl.setGoal(_a1298.title, ("%d/%d"):format(_a1298.progress, _a1298.amount))
if _a1298.progress >= _a1298.amount then
_a563(("[퀘스트] 달성 %d/%d — %s"):format(_a1298.progress, _a1298.amount, tostring(_a1298.title)))
return
end
if _a1298.progress > _a1284 then
_a1285 = os.clock()
_a563(("[퀘스트] %d/%d  %s"):format(_a1298.progress, _a1298.amount, tostring(_a1298.title)))
end
_a1284 = _a1298.progress
local _a1299 = os.clock() - _a1285
if _a1299 >= math.max(10, _a569.PursueStallSec or 60) then
_a563(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a1299, _a1298.progress, _a1298.amount, tostring(_a1298.title)))
return
end
task.wait(0.2)
end
end)
if not _a1291 then _a563("[퀘스트] " .. tostring(_a1278.how) .. " 오류: " .. tostring(_a1292)) end
_a576.ctl.lockGoal = nil
_a576.ctl.setGoal(nil)
end
function _a576.quest.cycle()
do
local _a1300 = _a570.rank
_a570.rank = true
pcall(_a738)
_a570.rank = _a1300
end
local _a1301 = _a576.quest.status()
if not _a1301 then return end
local _a1302, _a1303, _a1304 = false, false, false
local _a1305 = {}
local _a1306 = nil
for _a1307, _a1308 in ipairs(_a1301.list) do
if not _a570.quest then break end
local _a1309, _a1310 = true, nil
if not _a1308.ignored and _a1308.progress < _a1308.amount then
_a1309, _a1310 = _a576.quest.canDo(_a1308, true)
end
if _a1308.ignored then
if _a1308.progress < _a1308.amount then
_a1305[#_a1305 + 1] = tostring(_a1308.title) .. "  — " .. _a1308.ignored
end
elseif not _a1309 then
local _a1311 = tostring(_a1308.uid) .. tostring(_a1310)
if _a576.item.skipSaid ~= _a1311 then
_a576.item.skipSaid = _a1311
_a563(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a1308.title), tostring(_a1310)))
end
elseif _a1308.progress < _a1308.amount then
local _a1312 = _a1308.where
if _a1308.event then
if not _a1306 or _a1306.rank > 0 then _a1306 = { rank = 0, kind = "event", q = _a1308 } end
elseif _a1308.chest then
if not _a1306 or _a1306.rank > 1 then _a1306 = { rank = 1, kind = "chest", q = _a1308 } end
elseif _a1312 == "bestegg" then
if not _a1306 or _a1306.rank > 1 then _a1306 = { rank = 1, kind = "egg", q = _a1308 } end
elseif _a1312 == "breakable" and _a1308.breakable then
if not _a1306 or _a1306.rank > 2 then _a1306 = { rank = 2, kind = "breakable", q = _a1308 } end
elseif _a1312 == "zoneid" and _a1308.zoneId then
if not _a1306 or _a1306.rank > 2 then _a1306 = { rank = 2, kind = "zoneid", q = _a1308 } end
elseif _a1312 == "bestzone" or _a1312 == "breakable" then
if not _a1306 then _a1306 = { rank = 3, kind = "bestzone", q = _a1308 } end
end
if _a1308.how == "farm" then
_a1302 = true
elseif _a1308.how == "hatch" then
_a1303 = true
elseif _a1308.how == "zone" then
_a1304 = true
elseif _a1308.how == "potup" and _a569.QuestUpgrade then
local _a1313, _a1314 = _a576.item.upgradeTo("Potion", _a1308.potionTier or 2)
if _a1313 > 0 then
_a571.potup += _a1313
_a571.quest += 1
_a563(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a1308.potionTier or 2, _a1313, _a1308.title))
elseif _a1314 and not tostring(_a1314):find("부족") then
if _a576.item.potUpSaid ~= tostring(_a1314) then
_a576.item.potUpSaid = tostring(_a1314)
_a563("[퀘스트] 포션 업글 실패: " .. tostring(_a1314))
end
end
elseif _a1308.how == "encup" and _a569.QuestUpgrade then
local _a1315, _a1316 = _a576.item.upgradeTo("Enchant", _a1308.enchantTier or 2)
if _a1315 > 0 then
_a571.potup += _a1315
_a571.quest += 1
_a563(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a1308.enchantTier or 2, _a1315, _a1308.title))
elseif _a1316 and not tostring(_a1316):find("부족") then
if _a576.item.encUpSaid ~= tostring(_a1316) then
_a576.item.encUpSaid = tostring(_a1316)
_a563("[퀘스트] 인챈트 업글 실패: " .. tostring(_a1316))
end
end
elseif _a1308.how == "potuse" and _a569.QuestUsePotion then
_a576.item.lastUse = _a576.item.lastUse or {}
local _a1317 = _a576.item.lastUse[_a1308.uid]
if _a1317 and _a1317.used > 0 and _a1308.progress <= _a1317.progress then
if not _a1317.gaveUp then
_a1317.gaveUp = true
_a563("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a1308.title))
end
else
local _a1318 = math.min(_a569.QuestUseMax, math.max(1, _a1308.amount - _a1308.progress))
local _a1319, _a1320 = _a576.item.usePotion(_a1308.potionTier or 1, _a1318)
_a576.item.lastUse[_a1308.uid] = { used = _a1319, progress = _a1308.progress }
if _a1319 > 0 then
_a571.potuse += _a1319
_a571.quest += 1
_a563(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a1319, _a1308.title))
elseif _a1320 and not tostring(_a1320):find("없음") then
_a563("[퀘스트] 포션 사용 실패: " .. tostring(_a1320))
end
end
elseif _a1308.how == "gold" or _a1308.how == "rainbow" then
local _a1321, _a1322 = _a576.item.makeVariant(_a1308.how, _a1308.type == 40 or _a1308.type == 41)
if _a1321 > 0 then
_a571.quest += 1
_a563(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a1308.how == "gold" and "골드" or "레인보우", _a1321, _a1308.title))
elseif _a1322 then
_a563("[퀘스트] " .. _a1308.how .. " 실패: " .. tostring(_a1322))
end
elseif _a1308.how == "fruituse" then
local _a1323 = _a576.item.useFruit(math.max(1, _a1308.amount - _a1308.progress))
if _a1323 > 0 then
_a571.quest += 1
_a563(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a1323, _a1308.title))
end
elseif _a1308.how == "flaguse" then
local _a1324, _a1325 = _a576.item.useFlag(math.max(1, _a1308.amount - _a1308.progress))
if _a1324 > 0 then
_a571.quest += 1
_a563(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a1324, _a1308.title))
elseif _a1325 then
_a563("[퀘스트] 깃발 실패: " .. tostring(_a1325))
end
elseif not _a1308.how then
_a1305[#_a1305 + 1] = _a1308.title
end
end
end
if _a569.QuestLock and _a576.ctl.lockGoal then
local _a1326
for _a1327, _a1328 in ipairs(_a1301.list) do
if _a1328.uid == _a576.ctl.lockGoal.q.uid and _a1328.progress < _a1328.amount then _a1326 = _a1328 break end
end
if _a1326 then
_a576.ctl.lockGoal.q = _a1326
_a1306 = _a576.ctl.lockGoal
else
if _a576.ctl.lockGoal.q then
_a563("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a576.ctl.lockGoal.q.title))
end
_a576.ctl.lockGoal = nil
end
end
if _a569.QuestLock and _a1306 then _a576.ctl.lockGoal = _a1306 end
if _a569.QuestTp and _a1306 and _a570.quest then
local _a1329, _a1330, _a1331
if _a1306.kind == "event" then
local _a1332 = _a576.ev.findEvent(_a1306.q.event, _a1306.q.bestOnly)
if _a1332 then
_a1331 = ("%s @%s (%d초 남음)"):format(_a1332.name, tostring(_a1332.zone), _a1332.left)
if _a1332.pos then _a1329, _a1330 = _a576.move.glideTo(_a1332.pos)
else _a1329, _a1330 = _a576.move.goToZone(_a1332.zone) end
else
local _a1333 = _a1306.q.bestOnly and _a576.move.bestZone() or (_a576.move.curZone() or _a576.move.bestZone())
_a1331 = _a1306.q.event .. " 소환용 " .. tostring(_a1333)
local _a1334 = _a576.move.inDottedBox()
_a1329, _a1330 = _a576.move.goToZone(_a1333, false, _a1334 == false, _a1306.q.bestOnly)
if _a1329 then
local _a1335, _a1336 = _a576.ev.spawnEvent(_a1306.q.event)
if _a1335 < 1 and tostring(_a1336):find("점선") then
_a576.move.goToZone(_a1333, false, true)
task.wait(0.2)
_a1335, _a1336 = _a576.ev.spawnEvent(_a1306.q.event)
end
if _a1335 > 0 then
_a1331 = ("%s %d개 소환 @%s"):format(_a1306.q.event, _a1335, tostring(_a1333))
else
_a1330 = _a1336
_a1329 = false
end
end
end
elseif _a1306.kind == "chest" then
local _a1337 = _a1306.q.bestOnly and _a576.move.bestZone() or _a576.move.curZone()
local _a1338, _a1339 = _a576.ev.findChest(_a1306.q.chest, _a1337)
_a1331 = _a1306.q.chest .. " @" .. tostring(_a1337)
if _a1338 then
if not _a1339 or _a1339 > 20 then _a576.move.glideTo(_a1338) end
_a1329 = true
else
_a1329, _a1330 = _a576.move.goToZone(_a1337)
_a1331 = _a1331 .. " (상자 없음 → 존 가운데)"
end
elseif _a1306.kind == "egg" then
local _a1340 = _a651()
_a1331 = "최고 알 " .. tostring(_a1340)
if _a1340 then _a1329, _a1330 = _a576.egg.tpEgg(_a1340) else _a1330 = "최고 알을 못 찾음" end
elseif _a1306.kind == "breakable" then
local _a1341 = _a576.move.zoneForBreakable(_a1306.q.breakable)
_a1331 = tostring(_a1306.q.breakable) .. " 나오는 존 " .. tostring(_a1341)
if _a1341 then _a1329, _a1330 = _a576.move.goToZone(_a1341, true) else _a1330 = "그 브레이커블이 나오는 존이 없음" end
elseif _a1306.kind == "zoneid" then
_a1331 = "존 " .. tostring(_a1306.q.zoneId)
_a1329, _a1330 = _a576.move.goToZone(_a1306.q.zoneId)
else
local _a1342 = _a576.move.bestZone()
local _a1343 = _a1306.q.bestOnly or _a576.quest.BESTDEP[_a1306.q.type] or false
if _a1342 then _a1329, _a1330 = _a576.move.goToZone(_a1342, true, false, _a1343)
else _a1330 = "최고 존을 못 찾음" end
_a1331 = "최고 존 " .. tostring(_a576.move.arrivedZone or _a1342)
if not _a1329 then _a1330 = _a1342 end
end
if _a1329 then
if _a576.quest.lastGoal ~= _a1331 then
_a576.quest.lastGoal = _a1331
_a563("[퀘스트] " .. _a1331 .. " 으로 이동  (" .. tostring(_a1306.q.title) .. ")")
end
_a576.quest.pursue(_a1306.q)
else
local _a1344 = _a1330 and tostring(_a1330) or "이유 불명"
if _a576.quest.lastFail ~= _a1344 then
_a576.quest.lastFail = _a1344
_a563(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a1344, tostring(_a1306.kind), tostring(_a1306.q.title)))
_a563(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a576.move.curZone()), tostring(_a576.move.bestZone()), tostring(_a576.move.inDottedBox())))
end
end
end
if _a569.QuestDrive and _a576.auto.turnOn then
if _a1302  then _a576.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a1304  then _a576.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a1303 then _a576.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a1305 > 0 and not _a576.quest.manualWarned then
_a576.quest.manualWarned = true
_a563("[퀘스트] 수동으로 해야 하는 것:")
for _a1345, _a1346 in ipairs(_a1305) do _a563("    · " .. tostring(_a1346)) end
elseif #_a1305 == 0 then
_a576.quest.manualWarned = false
end
return _a1306 ~= nil
end
local function _a1347(_a1348)
local _a1349 = {}
for _a1350 in tostring(_a1348 or ""):gmatch("[^,]+") do
_a1350 = _a1350:match("^%s*(.-)%s*$")
if _a1350 ~= "" then _a1349[#_a1349 + 1] = _a1350:lower() end
end
return _a1349
end
function _a576.item.itemAllowed(_a1351)
local _a1352 = tostring(_a1351):lower()
for _a1353, _a1354 in ipairs(_a1347(_a569.ItemBlock)) do
if _a1352:find(_a1354, 1, true) then return false end
end
local _a1355 = _a1347(_a569.ItemAllow)
if #_a1355 == 0 then return true end
for _a1356, _a1357 in ipairs(_a1355) do
if _a1352:find(_a1357, 1, true) then return true end
end
return false
end
function _a576.item.activeBuffs(_a1358)
local _a1359 = _a603()
local _a1360 = _a1359 and rawget(_a1359, _a1358)
local _a1361 = {}
if type(_a1360) == "table" then
for _a1362, _a1363 in pairs(_a1360) do
if type(_a1363) == "table" and next(_a1363) then _a1361[_a1362] = true
elseif _a1363 then _a1361[_a1362] = true end
end
end
return _a1361
end
local function _a1364(_a1365, _a1366, _a1367, _a1368)
local _a1369 = _a576.item.activeBuffs(_a1366)
local _a1370 = {}
local _a1371 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a1372, _a1373 in ipairs(_a576.item.stacks(_a1365)) do
_a1371.total += 1
if _a1369[_a1373.id] then _a1371.act += 1
elseif not _a576.item.itemAllowed(_a1373.id) then _a1371.blocked += 1
elseif _a1373.am <= _a569.ItemKeep then _a1371.few += 1
else
_a1371.ok += 1
local _a1374 = _a1370[_a1373.id]
local _a1375
if not _a1374 then _a1375 = true
elseif _a569.BuffHighTier then _a1375 = _a1373.tier > _a1374.tier
else _a1375 = _a1373.tier < _a1374.tier end
if _a1375 then _a1370[_a1373.id] = _a1373 end
end
end
if _a1371.ok == 0 and _a1371.total > 0 then
local _a1376 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a1365, _a1371.total, _a1371.act, _a1371.blocked, _a1371.few)
if _a576.item.buffSaid ~= _a1376 then
_a576.item.buffSaid = _a1376
_a563("[아이템] " .. _a1376)
end
elseif _a1371.ok > 0 then
_a576.item.buffSaid = nil
end
local _a1377 = {}
for _a1378, _a1379 in pairs(_a1370) do _a1377[#_a1377 + 1] = _a1379 end
table.sort(_a1377, function(_a1380, _a1381)
if _a1380.tier ~= _a1381.tier then return _a1380.tier > _a1381.tier end
return _a1380.am > _a1381.am
end)
local _a1382 = {}
for _a1383, _a1384 in ipairs(_a1377) do
if not _a570.items then break end
if _a1368 and _a1368.left <= 0 then break end
local _a1385 = pcall(function() _a1367(_a1384.uid, 1) end)
if _a1385 then
_a1382[#_a1382 + 1] = ("%s T%d"):format(_a1384.id, _a1384.tier)
_a571.items += 1
if _a1368 then _a1368.left -= 1 end
task.wait(0.12)
end
end
return _a1382
end
function _a576.item.cycleItems()
local function _a1386()
local _a1387 = {}
if _a569.BuffPotion then _a1387[#_a1387 + 1] = { "Potion", "Potions" } end
if _a569.BuffFruit then _a1387[#_a1387 + 1] = { "Fruit", "Fruits" } end
if _a569.BuffConsumable then _a1387[#_a1387 + 1] = { "Consumable", "Consumables" } end
for _a1388, _a1389 in ipairs(_a1387) do
local _a1390 = _a576.item.activeBuffs(_a1389[2])
for _a1391, _a1392 in ipairs(_a576.item.stacks(_a1389[1])) do
if _a1392.am > _a569.ItemKeep and _a576.item.itemAllowed(_a1392.id) and not _a1390[_a1392.id] then
return true
end
end
end
if _a569.BuffUltimate and _a574.R_Ult then
local _a1393 = _a603()
local _a1394 = _a1393 and rawget(_a1393, "Ultimates")
if type(_a1394) == "table" then
for _a1395 in pairs(_a1394) do
if _a576.item.itemAllowed(_a1395) then
if not (_a574.Ult and rawget(_a574.Ult, "IsCharged")) then return true end
local _a1396, _a1397 = pcall(_a574.Ult.IsCharged, _a1395)
if _a1396 and _a1397 then return true end
end
end
end
end
return false
end
if not _a1386() then return end
if _a569.ItemBestZone then
local _a1398 = _a576.move.bestZone()
if _a1398 and _a576.move.curZone() ~= _a1398 then
if not _a569.ItemTp then
if not _a576.item.itemZoneWarned then
_a576.item.itemZoneWarned = true
_a563(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a1398), tostring(_a576.move.curZone())))
end
return
end
local _a1399, _a1400 = _a576.move.goToZone(_a1398)
if not _a1399 then
_a563("[아이템] 최고 존 이동 실패: " .. tostring(_a1400))
return
end
_a563("[아이템] 최고 존 " .. tostring(_a1398) .. " 에서 사용")
end
_a576.item.itemZoneWarned = false
end
local _a1401 = {}
local _a1402  = { left = math.max(1, _a569.BuffMaxPotion or 5) }
local _a1403 = { left = math.max(1, _a569.BuffMaxOther or 2) }
if _a569.BuffPotion and _a574.R_PotUse then
local _a1404 = _a1364("Potion", "Potions", function(_a1405, _a1406)
_a574.R_PotUse:FireServer(_a1405, _a1406)
end, _a1402)
for _a1407, _a1408 in ipairs(_a1404) do _a1401[#_a1401 + 1] = "포션 " .. _a1408 end
end
if _a569.BuffFruit and _a574.R_Fruit then
local _a1409 = _a1364("Fruit", "Fruits", function(_a1410, _a1411)
_a574.R_Fruit:FireServer(_a1410, _a1411)
end, _a1403)
for _a1412, _a1413 in ipairs(_a1409) do _a1401[#_a1401 + 1] = "과일 " .. _a1413 end
end
if _a569.BuffConsumable and _a574.R_Cons then
local _a1414 = _a1364("Consumable", "Consumables", function(_a1415, _a1416)
_a574.R_Cons:InvokeServer(_a1415, _a1416)
end, _a1403)
for _a1417, _a1418 in ipairs(_a1414) do _a1401[#_a1401 + 1] = "소모품 " .. _a1418 end
end
if _a569.BuffUltimate and _a574.R_Ult then
local _a1419 = _a603()
local _a1420 = _a1419 and rawget(_a1419, "Ultimates")
if type(_a1420) == "table" then
for _a1421 in pairs(_a1420) do
if not _a570.items then break end
if _a576.item.itemAllowed(_a1421) then
local _a1422 = true
if _a574.Ult and rawget(_a574.Ult, "IsCharged") then
local _a1423, _a1424 = pcall(_a574.Ult.IsCharged, _a1421)
_a1422 = _a1423 and _a1424 and true or false
end
if _a1422 then
local _a1425
pcall(function() _a1425 = _a574.R_Ult:InvokeServer(_a1421) end)
if _a1425 then
_a1401[#_a1401 + 1] = "얼티밋 " .. tostring(_a1421)
_a571.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a1401 > 0 then
_a576.ctl.setAct("버프 사용", table.concat(_a1401, ", "))
_a563("[아이템] " .. table.concat(_a1401, ", ") .. " 사용")
end
end
function _a576.mach.slotStatus()
local _a1426 = _a603()
if not _a1426 then return nil end
local _a1427 = tonumber(rawget(_a1426, "PetSlotsPurchased")) or 0
local _a1428 = tonumber(rawget(_a1426, "EggSlotsPurchased")) or 0
local _a1429, _a1430 = 0, 0
if _a574.RankC then
if rawget(_a574.RankC, "GetMaxPurchasableEquipSlots") then
local _a1431, _a1432 = pcall(_a574.RankC.GetMaxPurchasableEquipSlots)
if _a1431 and tonumber(_a1432) then _a1429 = tonumber(_a1432) end
end
if rawget(_a574.RankC, "GetMaxPurchasableEggSlots") then
local _a1433, _a1434 = pcall(_a574.RankC.GetMaxPurchasableEggSlots)
if _a1433 and tonumber(_a1434) then _a1430 = tonumber(_a1434) end
end
end
local _a1435, _a1436
if _a1427 < _a1429 then
_a1435 = _a1427 + 1
if type(_a574.CalcPetS) == "function" then
local _a1437, _a1438 = pcall(_a574.CalcPetS, _a1435)
if _a1437 then _a1436 = tonumber(_a1438) end
end
end
local _a1439, _a1440, _a1441
if _a1428 < _a1430 and _a574.RankC and rawget(_a574.RankC, "GetEggBundle") then
local _a1442, _a1443, _a1444 = pcall(_a574.RankC.GetEggBundle, _a1428 + 1)
if _a1442 and tonumber(_a1443) then
_a1439, _a1440 = tonumber(_a1443), tonumber(_a1444) or 1
if type(_a574.CalcEggS) == "function" then
local _a1445, _a1446 = 0, false
for _a1447 = _a1439 - _a1440 + 1, _a1439 do
local _a1448, _a1449 = pcall(_a574.CalcEggS, _a1447)
if _a1448 and tonumber(_a1449) then _a1445 += tonumber(_a1449) else _a1446 = true end
end
if not _a1446 then _a1441 = _a1445 end
end
end
end
local _a1450
if _a574.Egg and rawget(_a574.Egg, "GetMaxHatch") then
local _a1451, _a1452 = pcall(_a574.Egg.GetMaxHatch)
if _a1451 then _a1450 = tonumber(_a1452) end
end
return {
dia = _a618("Diamonds"),
petOwned = _a1427, petMax = _a1429, petNext = _a1435, petCost = _a1436,
eggOwned = _a1428, eggMax = _a1430, eggEnd = _a1439, eggSize = _a1440, eggCost = _a1441,
maxEquip = tonumber(rawget(_a1426, "MaxPetsEquipped")), maxHatch = _a1450,
}
end
function _a576.move.machinePos(_a1453)
local _a1454
if _a574.Machine and rawget(_a574.Machine, "GetModels") then
local _a1455, _a1456 = pcall(_a574.Machine.GetModels, _a1453)
if _a1455 and type(_a1456) == "table" then
for _a1457, _a1458 in pairs(_a1456) do
if typeof(_a1458) == "Instance" then _a1454 = _a1458 break end
end
end
end
if not _a1454 then
local _a1459, _a1460 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a1459 then
for _a1461, _a1462 in ipairs(_a1460) do
if _a1462.Name == _a1453 then _a1454 = _a1462 break end
end
end
end
if not _a1454 then return nil end
if _a1454:IsA("BasePart") then return _a1454.Position end
local _a1463, _a1464 = pcall(function() return _a1454:GetPivot() end)
return (_a1463 and typeof(_a1464) == "CFrame") and _a1464.Position or nil
end
function _a576.mach.cycleSlots()
local _a1465 = 0
local _a1466 = 0
while _a570.slots and not _a576.ctl.stopped() and _a1466 < 40 do
_a1466 += 1
local _a1467 = _a576.mach.slotStatus()
if not _a1467 then return end
local _a1468 = _a569.SlotPet and _a1467.petNext and _a1467.petCost
and (_a1467.dia - _a569.SlotReserve) >= _a1467.petCost
local _a1469 = _a569.SlotEgg and _a1467.eggEnd and _a1467.eggCost
and (_a1467.dia - _a569.SlotReserve) >= _a1467.eggCost
if _a1468 and _a1469 then
if _a1467.eggCost < _a1467.petCost then _a1468 = false else _a1469 = false end
end
if not (_a1468 or _a1469) then break end
local _a1470, _a1471, _a1472, _a1473
local function _a1474()
if _a1468 then
pcall(function() _a1470, _a1471 = _a574.R_PetSlot:InvokeServer(_a1467.petNext) end)
else
pcall(function() _a1470, _a1471 = _a574.R_EggSlot:InvokeServer(_a1467.eggEnd) end)
end
end
if _a1468 then
_a1472 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a1467.petNext, _a564(_a1467.petCost, 0))
_a1473 = "EquipSlotsMachine"
else
_a1472 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a1467.eggSize, _a1467.eggEnd, _a564(_a1467.eggCost, 0))
_a1473 = "EggSlotsMachine"
end
_a1474()
if not _a1470 and tostring(_a1471):find("far away") then
local _a1475 = _a576.move.machinePos(_a1473)
if _a1475 then
_a576.ctl.setAct("슬롯 머신으로 이동", _a1473)
_a576.move.glideTo(_a1475)
task.wait(0.25)
_a1470, _a1471 = nil, nil
_a1474()
else
_a1471 = "머신 위치를 못 찾음 (" .. _a1473 .. ")"
end
end
if _a1470 then
_a1465 += 1
_a571.mslot += 1
_a576.mach.slotSaid = nil
_a576.ctl.setAct("슬롯 구매", _a1472)
_a563("  ⬆ " .. _a1472)
task.wait(0.35)
else
local _a1476 = _a1472 .. " 실패: " .. tostring(_a1471)
if _a576.mach.slotSaid ~= _a1476 then
_a576.mach.slotSaid = _a1476
_a563("[슬롯] " .. _a1476)
end
break
end
end
if _a1465 > 0 then
local _a1477 = _a576.mach.slotStatus()
_a563(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a1465, tostring(_a1477 and _a1477.maxEquip), tostring(_a1477 and _a1477.maxHatch),
_a564(_a618("Diamonds"), 0)))
end
end
function _a576.mach.upgList()
local _a1478 = {}
if not _a574.Upg then return _a1478 end
local _a1479, _a1480 = pcall(_a574.Upg.All)
if not (_a1479 and type(_a1480) == "table") then return _a1478 end
for _a1481, _a1482 in ipairs(_a1480) do
local _a1483, _a1484, _a1485 = rawget(_a1482, "UpgradeID"), rawget(_a1482, "ZoneID"), rawget(_a1482, "UpgradeTier")
if _a1483 and _a1484 and _a1485 then
local _a1486 = false
if rawget(_a574.Upg, "Owns") then
local _a1487, _a1488 = pcall(_a574.Upg.Owns, _a1483, _a1484)
_a1486 = _a1487 and _a1488 and true or false
end
local _a1489 = _a576.move.ownsZone(_a1484)
local _a1490 = _a574.DirUpg and rawget(_a574.DirUpg, _a1483)
local _a1491 = _a1490 and rawget(_a1490, "TierCosts")
local _a1492 = _a1491 and tonumber(_a1491[_a1485])
local _a1493 = "Diamonds"
local _a1494 = _a1490 and rawget(_a1490, "TierCurrencies")
local _a1495 = _a1494 and _a1494[_a1485]
if type(_a1495) == "table" and rawget(_a1495, "_id") then _a1493 = rawget(_a1495, "_id") end
local _a1496 = rawget(_a1482, "Model")
local _a1497
if typeof(_a1496) == "Instance" then
if _a1496:IsA("BasePart") then _a1497 = _a1496.Position
else
local _a1498, _a1499 = pcall(function() return _a1496:GetPivot() end)
if _a1498 and _a1499 then _a1497 = _a1499.Position end
end
end
_a1478[#_a1478 + 1] = {
id = _a1483, zone = _a1484, tier = _a1485, cost = _a1492, cur = _a1493,
bought = _a1486, zoneOwned = _a1489,
buyable = _a1489 and not _a1486,
pos = _a1497, model = _a1496,
}
end
end
table.sort(_a1478, function(_a1500, _a1501) return (_a1500.cost or math.huge) < (_a1501.cost or math.huge) end)
return _a1478
end
function _a576.mach.cycleUpg()
if not _a574.R_Upg then _a563("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a1502 = _a576.mach.upgList()
if #_a1502 == 0 then return end
local _a1503 = 0
for _a1504, _a1505 in ipairs(_a1502) do
if not _a570.mapupg then break end
if _a1505.buyable and _a1505.cost then
local _a1506 = _a618(_a1505.cur or "Diamonds")
if _a1506 - _a569.UpgReserve < _a1505.cost then break end
if _a569.UpgTp and _a1505.pos and _a1505.zone == _a576.move.curZone() then
_a576.move.glideTo(_a1505.pos)
end
local _a1507, _a1508
pcall(function() _a1507, _a1508 = _a574.R_Upg:InvokeServer(_a1505.id, _a1505.zone) end)
if _a1507 then
_a1503 += 1
_a571.mapupg += 1
_a576.ctl.setAct("맵 업글", _a1505.id .. " T" .. _a1505.tier)
_a563(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a1505.id, _a1505.tier, _a1505.zone, _a564(_a1505.cost, 0)))
elseif _a1508 then
_a563(("[맵업글] %s T%d @%s 실패: %s"):format(
_a1505.id, _a1505.tier, _a1505.zone, tostring(_a1508)))
end
task.wait(_a569.ActionGap)
end
end
if _a1503 > 0 then
_a563(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a1503, _a564(_a618("Diamonds"), 0)))
end
end
local function _a1509()
local _a1510 = _a603()
if not _a1510 then return nil end
local _a1511 = tonumber(rawget(_a1510, "Rebirths")) or 0
local _a1512 = _a1511 + 1
local _a1513
if _a574.Rebirth and rawget(_a574.Rebirth, "GetNextRebirth") then
local _a1514, _a1515 = pcall(_a574.Rebirth.GetNextRebirth, _a1510)
if _a1514 then _a1513 = _a1515 end
end
return { current = _a1511, nextN = _a1512, def = _a1513 }
end
local function _a1516()
if not _a574.R_Reb then _a563("[리버스] Rebirth_Request 리모트 없음") return end
local _a1517 = _a1509()
if not _a1517 then
_a576.auto.rebNote = "세이브를 못 읽음"
return
end
local _a1518, _a1519
pcall(function() _a1518, _a1519 = _a574.R_Reb:InvokeServer(_a1517.nextN) end)
if _a1518 then
_a571.mreb += 1
_a576.auto.rebNote, _a576.auto.rebSaid = nil, nil
_a563(("  ★ 리버스 %d → %d"):format(_a1517.current, _a1517.nextN))
task.wait(0.5)
_a576.screen.dismissRewardScreens(25)
else
_a576.auto.rebNote = ("%d → %d : %s"):format(_a1517.current, _a1517.nextN,
_a1519 and tostring(_a1519) or "조건 미달 (리버스 킬/존 요구치)")
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
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a1516() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a646() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a1520 = _a570.farm
_a570.farm = true
pcall(_a628)
_a570.farm = _a1520
local _a1521 = _a576.quest.cycle()
if not _a1521 then
local _a1522 = _a576.move.bestZone()
if _a1522 then
local _a1523, _a1524 = _a576.move.goToZone(_a1522)
if not _a1523 then
if _a1524 and _a576.auto.idleMoveSaid ~= tostring(_a1524) then
_a576.auto.idleMoveSaid = tostring(_a1524)
_a563("[자동] 최고 존 이동 실패: " .. tostring(_a1524))
end
else
_a576.auto.idleMoveSaid = nil
end
end
if not _a569.IdleHatch then
_a576.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a576.move.curZone())))
return
end
local _a1525 = _a676()
local _a1526 = math.max(1, _a569.HatchMinAfford or 10)
if _a1525 and _a1525.price and _a1525.canBuy < _a1526 then
_a576.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a576.move.curZone()), _a1525.canBuy, _a1526,
_a564(_a1525.price, 0), tostring(_a1525.currency)))
else
_a576.ctl.setAct("대기 중 부화")
local _a1527 = _a570.mhatch
_a570.mhatch = true
pcall(_a687)
_a570.mhatch = _a1527
end
end
end },
}
_a569.StepOn = {}
for _a1528, _a1529 in ipairs(_a576.auto.SIDE) do _a569.StepOn[_a1529.key] = true end
for _a1530, _a1531 in ipairs(_a576.auto.STEPS) do _a569.StepOn[_a1531.key] = true end
local function _a1532(_a1533, _a1534, _a1535, _a1536)
if not _a569.StepOn[_a1533.key] then
_a1536[#_a1536 + 1] = ("%-14s 꺼져있음"):format(_a1533.label)
return
end
if _a1533.hold and _a1534 then
_a1536[#_a1536 + 1] = ("%-14s 보류 (%s)"):format(
_a1533.label, _a1535 and tostring(_a1535.title) or "?")
if _a576.auto.heldMsg ~= _a1533.key then
_a576.auto.heldMsg = _a1533.key
_a563(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a1533.label, _a1535 and tostring(_a1535.title) or "?"))
end
return
end
if _a1533.hold then _a576.auto.heldMsg = nil end
_a576.auto.step = _a1533.label
_a576.ctl.now.step = _a1533.label
_a576.ctl.setAct("시작", _a1533.label)
local _a1537 = os.clock()
local _a1538 = _a570[_a1533.run]
_a570[_a1533.run] = true
local _a1539, _a1540 = pcall(_a1533.fn)
_a570[_a1533.run] = _a1538
local _a1541 = os.clock() - _a1537
if not _a1539 then
_a1536[#_a1536 + 1] = ("%-14s 오류: %s"):format(_a1533.label, tostring(_a1540))
_a563("[자동] " .. _a1533.label .. " 오류: " .. tostring(_a1540))
else
local _a1542 = (_a1533.key == "zone" and _a576.auto.zoneNote)
or (_a1533.key == "mreb" and _a576.auto.rebNote) or nil
_a1536[#_a1536 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a1533.label, _a1541, _a1542 and ("  → " .. _a1542) or "")
end
end
function _a576.auto.master()
local _a1543 = {}
_a576.auto.lastTrace = _a1543
_a576.auto.lastPassAt = os.clock()
if _a576.screen.rewardScreenUp() then
_a1543[#_a1543 + 1] = "보상 화면 넘기는 중"
_a576.screen.dismissRewardScreens(15)
end
for _a1544, _a1545 in ipairs(_a576.auto.SIDE) do
if not _a570.auto or _a576.ctl.stopped() then return end
_a1532(_a1545, false, nil, _a1543)
end
local _a1546, _a1547 = false, nil
if _a569.HoldZoneForQuest then _a1546, _a1547 = _a576.quest.bestDepActive() end
for _a1548, _a1549 in ipairs(_a576.auto.STEPS) do
if not _a570.auto or _a576.ctl.stopped() then break end
_a1532(_a1549, _a1546, _a1547, _a1543)
end
_a576.auto.step = nil
if not _a576.ctl.lockGoal then
_a576.ctl.now.step = "대기"
_a576.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a569.AutoInterval or 5))
end
local _a1550 = {}
for _a1551, _a1552 in ipairs(_a1543) do _a1550[#_a1550 + 1] = (_a1552:gsub("[%d%.]+초", "")) end
_a1550 = table.concat(_a1550, " | ")
if _a1550 ~= _a576.auto.lastSig then
_a576.auto.lastSig = _a1550
_a563("[자동] 바퀴 " .. (_a576.auto.passN or 0))
for _a1553, _a1554 in ipairs(_a1543) do _a563("    " .. _a1554) end
end
_a576.auto.passN = (_a576.auto.passN or 0) + 1
end
local function _a1555()
if not _a568.R_PROMO then _a563("[타워업글] 리모트 없음") return end
local _a1556 = _a572()
if not _a1556 then return end
local _a1557 = _a573(_a1556)
table.sort(_a1557, function(_a1558, _a1559) return (_a1558.dps or 0) > (_a1559.dps or 0) end)
local _a1560, _a1561 = 0, 0
for _a1562, _a1563 in ipairs(_a1557) do
if not _a570.towerup then break end
if _a1563.id then
local _a1564
pcall(function() _a1564 = _a568.R_PROMO:InvokeServer(_a1563.id) end)
if _a1564 ~= nil and _a1564 ~= false then
_a1560 += 1
_a563(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1563.kind), tostring(_a1563.up), tostring((_a1563.up or 0) + 1)))
_a1561 = 0
task.wait(_a569.ActionGap)
else
_a1561 += 1
if _a1561 >= 5 then break end
end
end
end
_a563("[타워업글] " .. _a1560 .. "건")
end
local _a1565 = {}
local _a1566 = {}
local function _a1567(_a1568, _a1569)
local _a1570 = tostring(_a1569)
local _a1571 = _a1566[_a1568]
if _a1571 and _a1571.msg == _a1570 then
_a1571.n += 1
if _a1571.n % 20 == 0 then
_a563(("[%s 오류] %s   (%d회 반복)"):format(_a1568, _a1570, _a1571.n))
end
return
end
_a1566[_a1568] = { msg = _a1570, n = 1 }
_a563("[" .. _a1568 .. " 오류] " .. _a1570)
end
local function _a1572(_a1573, _a1574, _a1575, _a1576)
_a1565[_a1573] = (_a1565[_a1573] or 0) + 1
local _a1577 = _a1565[_a1573]
task.spawn(function()
while _a570[_a1573] and _a1565[_a1573] == _a1577 do
local _a1578, _a1579 = pcall(_a1575)
if not _a1578 then _a1567(_a1576, _a1579) else _a1566[_a1576] = nil end
local _a1580, _a1581 = _a1574(), 0
while _a1581 < _a1580 and _a570[_a1573] and _a1565[_a1573] == _a1577 do task.wait(0.1) _a1581 += 0.1 end
end
if _a1565[_a1573] == _a1577 then _a563("[" .. _a1576 .. "] 중지") end
end)
end
do
local _a1582 = {
farm   = { function() return _a569.FarmInterval end,      function() _a628() end,      "파밍" },
zone   = { function() return _a569.ZoneInterval end,      function() _a646() end,      "존" },
mhatch = { function() return _a569.MainHatchInterval end, function() _a687() end, "부화" },
}
function _a576.auto.turnOn(_a1583, _a1584)
if _a570.auto then return end
if _a570[_a1583] then return end
local _a1585 = _a1582[_a1583]
if not _a1585 then return end
_a570[_a1583] = true
_a1572(_a1583, _a1585[1], _a1585[2], _a1585[3])
if _a576.auto.refresh then _a576.auto.refresh() end
_a563("[퀘스트] " .. tostring(_a1584) .. " ON")
end
end
_a559.MG, _a559.QS, _a559.saveGet, _a559.currencyAmount, _a559.cycleFarm, _a559.zoneStatus = _a574, _a576, _a603, _a618, _a628, _a642
_a559.cycleZone, _a559.bestMainEgg, _a559.mainHatchStatus, _a559.cycleMainHatch, _a559.mainRebirthStatus, _a559.cycleMainRebirth = _a646, _a651, _a676, _a687, _a1509, _a1516
_a559.cycleTowerUp, _a559.startLoop = _a1555, _a1572
end)(_a1)
;(function(_a1586)
local _a1587, _a1588, _a1589, _a1590, _a1591, _a1592, _a1593 = _a1586.UIS, _a1586.RunService, _a1586.LP, _a1586.LOG, _a1586.log, _a1586.num, _a1586.LB
local _a1594, _a1595, _a1596, _a1597, _a1598, _a1599 = _a1586.RM, _a1586.CFG, _a1586.EGG_COST_CACHE, _a1586.RUN, _a1586.STAT, _a1586.EVENT_UPGRADES
local _a1600, _a1601, _a1602, _a1603, _a1604, _a1605 = _a1586.ctx, _a1586.collectSlots, _a1586.placedTowers, _a1586.availableItems, _a1586.cyclePlace, _a1586.cycleMerchant
local _a1606, _a1607, _a1608, _a1609, _a1610, _a1611 = _a1586.sunflowers, _a1586.eventTiers, _a1586.nextCost, _a1586.cycleUpgrade, _a1586.seedInv, _a1586.bedsOf
local _a1612, _a1613, _a1614, _a1615, _a1616, _a1617 = _a1586.isUnhatched, _a1586.bedCps, _a1586.cycleCrop, _a1586.laneCosts, _a1586.lockedBeds, _a1586.cycleExpand
local _a1618, _a1619, _a1620, _a1621, _a1622 = _a1586.rebirthStatus, _a1586.cycleRebirth, _a1586.hatchStatus, _a1586.cycleHatch, _a1586.LUCK_ORDER
local _a1623, _a1624, _a1625, _a1626, _a1627, _a1628 = _a1586.luckStatus, _a1586.fmtDur, _a1586.cycleLuck, _a1586.MG, _a1586.QS, _a1586.saveGet
local _a1629, _a1630, _a1631, _a1632, _a1633, _a1634 = _a1586.currencyAmount, _a1586.cycleFarm, _a1586.zoneStatus, _a1586.cycleZone, _a1586.bestMainEgg, _a1586.mainHatchStatus
local _a1635, _a1636, _a1637, _a1638, _a1639 = _a1586.cycleMainHatch, _a1586.mainRebirthStatus, _a1586.cycleMainRebirth, _a1586.cycleTowerUp, _a1586.startLoop
local _a1640 = {
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
local function _a1641(_a1642, _a1643, _a1644)
local _a1645 = Instance.new(_a1642)
for _a1646, _a1647 in pairs(_a1643) do _a1645[_a1646] = _a1647 end
if _a1644 then _a1645.Parent = _a1644 end
return _a1645
end
local function _a1648(_a1649, _a1650) _a1641("UICorner", { CornerRadius = UDim.new(0, _a1650 or 8) }, _a1649) end
local function _a1651(_a1652, _a1653, _a1654)
_a1641("UIStroke", { Color = _a1653 or _a1640.line, Thickness = _a1654 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _a1652)
end
local function _a1655(_a1656, _a1657)
_a1641("UIPadding", {
PaddingTop = UDim.new(0, _a1657), PaddingBottom = UDim.new(0, _a1657),
PaddingLeft = UDim.new(0, _a1657), PaddingRight = UDim.new(0, _a1657),
}, _a1656)
end
local _a1658 = _a1641("ScreenGui", {
Name = "PS99GardenAuto", ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset = true, DisplayOrder = 9999,
})
local _a1659 = false
if type(gethui) == "function" then _a1659 = pcall(function() _a1658.Parent = gethui() end) end
if not _a1659 then _a1659 = pcall(function() _a1658.Parent = game:GetService("CoreGui") end) end
if not _a1659 then _a1658.Parent = _a1589:WaitForChild("PlayerGui") end
local _a1660, _a1661 = 780, 520
local _a1662 = _a1641("Frame", {
Size = UDim2.fromOffset(_a1660, _a1661), Position = UDim2.new(0.5, -_a1660 / 2, 0.5, -_a1661 / 2),
BackgroundColor3 = _a1640.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, _a1658)
_a1648(_a1662, 12)
_a1651(_a1662, Color3.fromRGB(60, 66, 82), 1)
local _a1663 = _a1641("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = _a1640.panel, BorderSizePixel = 0,
}, _a1662)
_a1648(_a1663, 12)
_a1641("Frame", {
Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
BackgroundColor3 = _a1640.panel, BorderSizePixel = 0,
}, _a1663)
_a1641("Frame", {
Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(14, 15),
BackgroundColor3 = _a1640.good, BorderSizePixel = 0,
}, _a1663).Name = "Dot"
_a1648(_a1663:FindFirstChild("Dot"), 5)
_a1641("TextLabel", {
Size = UDim2.new(0, 320, 1, 0), Position = UDim2.fromOffset(32, 0),
BackgroundTransparency = 1, Text = "Garden Defenders  AutoPlay",
TextColor3 = _a1640.text, TextSize = 14, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1663)
local function _a1664(_a1665, _a1666, _a1667, _a1668)
local _a1669 = _a1641("TextButton", {
Size = UDim2.new(0, _a1668, 0, 24), Position = UDim2.new(1, _a1667, 0, 8),
BackgroundColor3 = _a1666, BorderSizePixel = 0, Text = _a1665,
TextColor3 = _a1640.text, TextSize = 12, Font = Enum.Font.GothamMedium,
AutoButtonColor = true,
}, _a1663)
_a1648(_a1669, 6)
return _a1669
end
local _a1670 = _a1664("✕", _a1640.bad, -38, 28)
local _a1671   = _a1664("—", _a1640.card, -70, 28)
local _a1672 = _a1664("지우기", _a1640.card, -132, 58)
local _a1673  = _a1664("복사", _a1640.accent, -190, 54)
local _a1674  = _a1664("정지", _a1640.bad, -252, 58)
_a1674.MouseButton1Click:Connect(function()
_a1627.ctl.stopAll()
if _a1627.auto.refresh then pcall(_a1627.auto.refresh) end
_a1591("[정지] 모든 동작을 멈췄습니다")
end)
local _a1675 = _a1641("ScrollingFrame", {
Size = UDim2.new(0, 152, 1, -92), Position = UDim2.fromOffset(10, 48),
BackgroundColor3 = _a1640.panel, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = _a1640.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1662)
_a1648(_a1675, 8)
_a1641("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, _a1675)
_a1641("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, _a1675)
local _a1676 = _a1641("Frame", {
Size = UDim2.new(1, -182, 1, -92), Position = UDim2.fromOffset(172, 48),
BackgroundTransparency = 1,
}, _a1662)
local _a1677, _a1678 = {}, nil
local _a1679, _a1680 = {}, {}
local _a1681 = {}
local function _a1682(_a1683)
_a1678 = _a1683
for _a1684, _a1685 in pairs(_a1677) do _a1685.Visible = (_a1684 == _a1683) end
for _a1686, _a1687 in pairs(_a1679) do
local _a1688 = (_a1686 == _a1683)
_a1687.BackgroundColor3 = _a1688 and _a1640.accent or _a1640.panel
_a1687.TextColor3 = _a1688 and Color3.fromRGB(255, 255, 255) or _a1640.dim
end
local _a1689 = _a1680[_a1683]
if _a1689 and _a1681[_a1689] and not _a1681[_a1689].open then _a1681[_a1689].toggle() end
end
local function _a1690(_a1691, _a1692, _a1693)
local _a1694 = { open = true, kids = {} }
local _a1695 = _a1641("TextButton", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = _a1640.bg, BorderSizePixel = 0,
Text = "", TextColor3 = _a1640.dim, TextSize = 11,
Font = Enum.Font.GothamBold, LayoutOrder = _a1693, AutoButtonColor = false,
}, _a1675)
_a1648(_a1695, 5)
local _a1696 = _a1641("TextLabel", {
Size = UDim2.fromOffset(14, 26), Position = UDim2.fromOffset(6, 0),
BackgroundTransparency = 1, Text = "▾", TextColor3 = _a1640.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1695)
_a1641("TextLabel", {
Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(20, 0),
BackgroundTransparency = 1, Text = _a1692, TextColor3 = _a1640.dim,
TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1695)
function _a1694.toggle()
_a1694.open = not _a1694.open
_a1696.Text = _a1694.open and "▾" or "▸"
for _a1697, _a1698 in ipairs(_a1694.kids) do _a1698.Visible = _a1694.open end
end
_a1695.MouseButton1Click:Connect(_a1694.toggle)
_a1681[_a1691] = _a1694
return _a1694
end
local function _a1699(_a1700, _a1701, _a1702, _a1703)
local _a1704 = _a1703 and 14 or 6
local _a1705 = _a1641("TextButton", {
Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = _a1640.panel, BorderSizePixel = 0,
Text = "", TextColor3 = _a1640.dim, TextSize = 12,
Font = Enum.Font.GothamMedium, LayoutOrder = _a1702, AutoButtonColor = false,
}, _a1675)
_a1648(_a1705, 5)
local _a1706 = _a1641("TextLabel", {
Size = UDim2.new(1, -_a1704 - 4, 1, 0), Position = UDim2.fromOffset(_a1704, 0),
BackgroundTransparency = 1, Text = _a1701, TextColor3 = _a1640.dim,
TextSize = 12, Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1705)
_a1679[_a1700] = _a1705
if _a1703 then
_a1680[_a1700] = _a1703
local _a1707 = _a1681[_a1703]
if _a1707 then
table.insert(_a1707.kids, _a1705)
_a1705.Visible = _a1707.open
end
end
local _a1708 = _a1641("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false,
BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1640.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1676)
_a1641("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1708)
_a1641("UIPadding", { PaddingRight = UDim.new(0, 8) }, _a1708)
_a1677[_a1700] = _a1708
_a1705.MouseButton1Click:Connect(function() _a1682(_a1700) end)
_a1705.MouseEnter:Connect(function()
if _a1678 ~= _a1700 then _a1705.BackgroundColor3 = _a1640.card end
end)
_a1705.MouseLeave:Connect(function()
if _a1678 ~= _a1700 then _a1705.BackgroundColor3 = _a1640.panel end
end)
_a1705:GetPropertyChangedSignal("TextColor3"):Connect(function()
_a1706.TextColor3 = _a1705.TextColor3
end)
return _a1708
end
local _a1709 = 0
local function _a1710()
_a1709 += 1
return _a1709
end
local function _a1711(_a1712, _a1713)
local _a1714 = _a1641("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = _a1710(),
}, _a1712)
_a1641("Frame", {
Size = UDim2.fromOffset(3, 14), Position = UDim2.fromOffset(0, 7),
BackgroundColor3 = _a1640.accent, BorderSizePixel = 0,
}, _a1714)
_a1641("TextLabel", {
Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1, Text = _a1713, TextColor3 = _a1640.text,
TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1714)
return _a1714
end
local function _a1715(_a1716, _a1717, _a1718)
local _a1719 = _a1641("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = _a1640.card, BorderSizePixel = 0, LayoutOrder = _a1710(),
}, _a1716)
_a1648(_a1719, 8)
_a1651(_a1719, _a1640.line, 1)
_a1655(_a1719, 12)
_a1641("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1719)
if _a1717 then
local _a1720 = _a1641("Frame", {
Size = UDim2.new(1, 0, 0, _a1718 and 32 or 22), BackgroundTransparency = 1,
LayoutOrder = 0,
}, _a1719)
_a1641("TextLabel", {
Size = UDim2.new(1, -70, 0, 16), BackgroundTransparency = 1, Text = _a1717,
TextColor3 = _a1640.text, TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1720)
if _a1718 then
_a1641("TextLabel", {
Size = UDim2.new(1, -70, 0, 13), Position = UDim2.fromOffset(0, 17),
BackgroundTransparency = 1, Text = _a1718, TextColor3 = _a1640.dim,
TextSize = 11, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, _a1720)
end
_a1719:SetAttribute("HeadHeight", _a1718 and 32 or 18)
return _a1719, _a1720
end
return _a1719
end
local _a1721 = {}
local function _a1722()
for _a1723, _a1724 in pairs(_a1721) do pcall(_a1724) end
end
_a1627.auto.refresh = _a1722
local function _a1725(_a1726, _a1727, _a1728)
local _a1729 = _a1641("TextButton", {
Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -46, 0, 0),
BackgroundColor3 = _a1640.cardHi, BorderSizePixel = 0, Text = "",
AutoButtonColor = false,
}, _a1726)
_a1648(_a1729, 12)
local _a1730 = _a1641("Frame", {
Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
BackgroundColor3 = _a1640.dim, BorderSizePixel = 0,
}, _a1729)
_a1648(_a1730, 9)
local _a1731 = _a1641("TextLabel", {
Size = UDim2.fromOffset(46, 12), Position = UDim2.fromOffset(0, 26),
BackgroundTransparency = 1, Text = "OFF", TextColor3 = _a1640.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1729)
local function _a1732()
local _a1733 = _a1597[_a1727]
_a1729.BackgroundColor3 = _a1733 and _a1640.good or _a1640.cardHi
_a1730:TweenPosition(UDim2.fromOffset(_a1733 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a1730.BackgroundColor3 = _a1733 and Color3.fromRGB(255, 255, 255) or _a1640.dim
_a1731.Text = _a1733 and "ON" or "OFF"
_a1731.TextColor3 = _a1733 and _a1640.good or _a1640.dim
end
_a1729.MouseButton1Click:Connect(function()
_a1597[_a1727] = not _a1597[_a1727]
if _a1597[_a1727] then
if _a1727 == "auto" then _a1627.ctl.abort = false end
_a1732()
_a1591("[" .. _a1727 .. "] 시작")
local _a1734, _a1735 = pcall(_a1728)
if not _a1734 then _a1591("[에러] " .. tostring(_a1735)) end
else
if _a1727 == "auto" then
_a1627.ctl.stopAll()
_a1591("[정지] 모든 동작을 멈췄습니다")
end
_a1732()
end
end)
_a1732()
_a1721[_a1727] = _a1732
return _a1729, _a1732
end
local function _a1736(_a1737, _a1738)
local _a1739 = _a1641("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = _a1710(),
}, _a1737)
local _a1740 = #_a1738
for _a1741, _a1742 in ipairs(_a1738) do
local _a1743 = _a1641("Frame", {
Size = UDim2.new(1 / _a1740, -6, 1, 0), Position = UDim2.new((_a1741 - 1) / _a1740, 3, 0, 0),
BackgroundTransparency = 1,
}, _a1739)
_a1641("TextLabel", {
Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = _a1742.label,
TextColor3 = _a1640.dim, TextSize = 10, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1743)
local _a1744 = _a1641("TextBox", {
Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 15),
BackgroundColor3 = _a1640.bg, BorderSizePixel = 0, Text = tostring(_a1742.value),
TextColor3 = _a1640.text, TextSize = 12, Font = Enum.Font.Code,
ClearTextOnFocus = false,
}, _a1743)
_a1648(_a1744, 5)
_a1651(_a1744, _a1640.line, 1)
_a1744.FocusLost:Connect(function() _a1742.onChange(_a1744.Text, _a1744) end)
end
return _a1739
end
local function _a1745(_a1746, _a1747)
local _a1748 = _a1641("Frame", {
Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = _a1710(),
}, _a1746)
local _a1749 = #_a1747
for _a1750, _a1751 in ipairs(_a1747) do
local _a1752 = _a1641("TextButton", {
Size = UDim2.new(1 / _a1749, -5, 1, 0), Position = UDim2.new((_a1750 - 1) / _a1749, 2.5, 0, 0),
BackgroundColor3 = _a1751.col or _a1640.cardHi, BorderSizePixel = 0, Text = _a1751.label,
TextColor3 = _a1640.text, TextSize = 12, Font = Enum.Font.GothamMedium,
}, _a1748)
_a1648(_a1752, 6)
_a1752.MouseButton1Click:Connect(function()
local _a1753, _a1754 = pcall(_a1751.fn, _a1752)
if not _a1753 then _a1591("[에러] " .. tostring(_a1751.label) .. " → " .. tostring(_a1754)) end
end)
end
return _a1748
end
local function _a1755(_a1756, _a1757, _a1758, _a1759)
local _a1760 = _a1641("TextButton", {
Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = _a1640.cardHi, BorderSizePixel = 0,
Text = "", TextColor3 = _a1640.text, TextSize = 12, Font = Enum.Font.GothamMedium,
LayoutOrder = _a1710(),
}, _a1756)
_a1648(_a1760, 6)
local function _a1761()
local _a1762 = _a1758()
_a1760.Text = _a1757 .. "   " .. (_a1762 and "ON" or "OFF")
_a1760.BackgroundColor3 = _a1762 and Color3.fromRGB(40, 78, 58) or _a1640.cardHi
_a1760.TextColor3 = _a1762 and _a1640.good or _a1640.dim
end
_a1760.MouseButton1Click:Connect(function()
_a1759(not _a1758())
_a1761()
end)
_a1761()
return _a1760
end
local _a1763 = _a1699("log", "로그", 90)
local _a1764
do
local _a1765 = _a1641("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a1710(),
}, _a1763)
_a1648(_a1765, 8)
_a1651(_a1765, _a1640.line, 1)
local _a1766 = _a1641("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -10), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1640.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1765)
_a1764 = _a1641("TextLabel", {
Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(196, 208, 196),
TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
TextWrapped = true,
}, _a1766)
_a1763.AutomaticCanvasSize = Enum.AutomaticSize.None
_a1763.CanvasSize = UDim2.new()
end
do
local _a1767, _a1768, _a1769, _a1770
_a1663.InputBegan:Connect(function(_a1771)
if _a1771.UserInputType == Enum.UserInputType.MouseButton1
or _a1771.UserInputType == Enum.UserInputType.Touch then
_a1767, _a1768, _a1769 = true, _a1771.Position, _a1662.Position
_a1771.Changed:Connect(function()
if _a1771.UserInputState == Enum.UserInputState.End then _a1767 = false end
end)
end
end)
_a1663.InputChanged:Connect(function(_a1772)
if _a1772.UserInputType == Enum.UserInputType.MouseMovement
or _a1772.UserInputType == Enum.UserInputType.Touch then _a1770 = _a1772 end
end)
_a1587.InputChanged:Connect(function(_a1773)
if _a1767 and _a1773 == _a1770 then
local _a1774 = _a1773.Position - _a1768
_a1662.Position = UDim2.new(_a1769.X.Scale, _a1769.X.Offset + _a1774.X,
_a1769.Y.Scale, _a1769.Y.Offset + _a1774.Y)
end
end)
local _a1775 = false
_a1671.MouseButton1Click:Connect(function()
_a1775 = not _a1775
_a1662:TweenSize(_a1775 and UDim2.fromOffset(_a1660, 40) or UDim2.fromOffset(_a1660, _a1661),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a1671.Text = _a1775 and "▢" or "—"
end)
end
local _a1776 = _a1588.Heartbeat:Connect(function()
if not _a1586.dirty then return end
_a1586.dirty = false
local _a1777 = #_a1590
_a1764.Text = table.concat(table.move(_a1590, math.max(1, _a1777 - 300), _a1777, 1, {}), "\n")
end)
local _a1778 = _a1699("dash", "대시보드", 10)
local _a1779 = _a1699("event", "이벤트", 20)
do
local _a1780 = _a1715(_a1778, "전체 제어", nil)
_a1745(_a1780, {
{ label = "권장 전부 ON", col = _a1640.good, fn = function()
for _a1781, _a1782 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a1597[_a1782] then
_a1597[_a1782] = true
if _a1782 == "place"    then _a1639(_a1782, function() return _a1595.PlaceInterval end, _a1604, "배치") end
if _a1782 == "merchant" then _a1639(_a1782, function() return _a1595.MerchantInterval end, _a1605, "구매") end
if _a1782 == "crop"     then _a1639(_a1782, function() return _a1595.CropInterval end, _a1614, "씨앗") end
if _a1782 == "expand"   then _a1639(_a1782, function() return _a1595.ExpandInterval end, _a1617, "확장") end
if _a1782 == "hatch"    then _a1639(_a1782, function() return _a1595.HatchInterval end, _a1621, "뽑기") end
end
end
_a1722()
_a1591("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a1640.bad, fn = function()
_a1597.place, _a1597.merchant, _a1597.upgrade = false, false, false
_a1597.towerup, _a1597.crop, _a1597.expand, _a1597.rebirth, _a1597.hatch, _a1597.luck = false, false, false, false, false, false
_a1597.farm, _a1597.zone, _a1597.mhatch, _a1597.rank, _a1597.mreb = false, false, false, false, false
_a1722()
_a1591("[전체] 정지")
end },
})
local _a1783 = _a1715(_a1778, "현황", nil)
_a1745(_a1783, {
{ label = "밭 / 타워", col = _a1640.accent, fn = function()
local _a1784, _a1785, _a1786, _a1787 = _a1600()
_a1591("")
_a1591("──── 현재 상태 ────")
_a1591("레인 " .. tostring(_a1787) .. " / plot " .. (_a1786 and "O" or "X")
.. " / world " .. (_a1784 and "O" or "X"))
local _a1788 = _a1601(_a1786, _a1787)
local _a1789 = _a1602(_a1784)
_a1591("슬롯 " .. #_a1788 .. " / 배치 " .. #_a1789)
local _a1790, _a1791 = 0, {}
for _a1792, _a1793 in ipairs(_a1789) do
_a1790 += (_a1793.dps or 0)
_a1791[tostring(_a1793.kind)] = (_a1791[tostring(_a1793.kind)] or 0) + 1
end
_a1591("총 DPS " .. _a1592(_a1790))
for _a1794, _a1795 in pairs(_a1791) do _a1591("  " .. _a1794 .. " × " .. _a1795) end
local _a1796 = _a1603()
_a1591("")
_a1591("배치 가능 " .. #_a1796 .. "종")
for _a1797 = 1, math.min(10, #_a1796) do
local _a1798 = _a1796[_a1797]
_a1591(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a1798.id), tostring(_a1798.vr or "-"), tostring(_a1798.copies), _a1592(_a1798.dps)))
end
_a1682("log")
end },
{ label = "로그 보기", col = _a1640.cardHi, fn = function() _a1682("log") end },
})
end
do
local _a1799, _a1800 = _a1715(_a1779, "자동 배치 / 교체", nil)
_a1725(_a1800, "place", function()
_a1639("place", function() return _a1595.PlaceInterval end, _a1604, "배치")
end)
_a1736(_a1799, {
{ label = "주기", value = _a1595.PlaceInterval, onChange = function(_a1801)
local _a1802 = tonumber(_a1801) if _a1802 and _a1802 >= 3 then _a1595.PlaceInterval = _a1802 end
end },
{ label = "교체 배수", value = _a1595.SwapMargin, onChange = function(_a1803)
local _a1804 = tonumber(_a1803) if _a1804 and _a1804 >= 1 then _a1595.SwapMargin = _a1804 _a1591("[설정] 교체 배수 " .. _a1804) end
end },
{ label = "DoT 반영", value = _a1595.DotFactor, onChange = function(_a1805)
local _a1806 = tonumber(_a1805) if _a1806 and _a1806 >= 0 and _a1806 <= 1 then _a1595.DotFactor = _a1806 end
end },
})
_a1755(_a1799, "업글 타워 보호",
function() return _a1595.ProtectUpgraded end,
function(_a1807) _a1595.ProtectUpgraded = _a1807
_a1591("[설정] 업글 보호 " .. (_a1807 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a1745(_a1799, {
{ label = "지금 1회 실행", col = _a1640.accent, fn = function()
task.spawn(function() _a1597.place = true _a1604() _a1597.place = false _a1682("log") end)
end },
})
end
do
local _a1808, _a1809 = _a1715(_a1779, "머천트 자동 구매", nil)
_a1725(_a1809, "merchant", function()
_a1639("merchant", function() return _a1595.MerchantInterval end, _a1605, "구매")
end)
_a1736(_a1808, {
{ label = "머천트 ID", value = _a1595.MerchantId, onChange = function(_a1810)
if _a1810 ~= "" then _a1595.MerchantId = _a1810 _a1591("[설정] 머천트 " .. _a1810) end
end },
{ label = "주기", value = _a1595.MerchantInterval, onChange = function(_a1811)
local _a1812 = tonumber(_a1811) if _a1812 and _a1812 >= 5 then _a1595.MerchantInterval = _a1812 end
end },
})
_a1745(_a1808, {
{ label = "지금 1회 구매", col = _a1640.accent, fn = function()
task.spawn(function() _a1597.merchant = true _a1605() _a1597.merchant = false _a1682("log") end)
end },
})
end
do
local _a1813, _a1814 = _a1715(_a1779, "업그레이드 머신", nil)
_a1725(_a1814, "upgrade", function()
_a1639("upgrade", function() return _a1595.UpgradeInterval end, _a1609, "머신업글")
end)
_a1736(_a1813, {
{ label = "주기", value = _a1595.UpgradeInterval, onChange = function(_a1815)
local _a1816 = tonumber(_a1815) if _a1816 and _a1816 >= 5 then _a1595.UpgradeInterval = _a1816 end
end },
{ label = "최소 잔액", value = _a1595.MinSunflowers, onChange = function(_a1817)
local _a1818 = tonumber(_a1817) if _a1818 and _a1818 >= 0 then _a1595.MinSunflowers = _a1818
_a1591("[설정] 최소 잔액 " .. _a1592(_a1818, 0)) end
end },
})
_a1755(_a1813, "가격 미상 구매",
function() return _a1595.BuyUnknownCost end,
function(_a1819) _a1595.BuyUnknownCost = _a1819 end)
_a1745(_a1813, {
{ label = "업글 현황 보기", col = _a1640.accent, fn = function()
local _a1820 = _a1606()
local _a1821 = _a1607()
_a1598.sun = _a1820
_a1591("")
_a1591("──── 업그레이드 머신 ────")
_a1591("Sunflowers = " .. _a1592(_a1820, 0))
local _a1822 = {}
for _a1823, _a1824 in ipairs(_a1599) do
local _a1825 = _a1821[_a1824] or 0
_a1822[#_a1822 + 1] = { id = _a1824, tier = _a1825, cost = _a1608(_a1824, _a1825) }
end
table.sort(_a1822, function(_a1826, _a1827)
return (_a1826.cost or math.huge) < (_a1827.cost or math.huge)
end)
for _a1828, _a1829 in ipairs(_a1822) do
_a1591(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a1829.id, tostring(_a1829.tier), _a1829.cost and _a1592(_a1829.cost, 0) or "?",
(_a1829.cost and _a1829.cost <= _a1820) and "← 구매가능" or ""))
end
_a1682("log")
end },
{ label = "지금 1회 업글", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.upgrade = true _a1609() _a1597.upgrade = false _a1682("log") end)
end },
})
local _a1830, _a1831 = _a1715(_a1779, "타워 개별 업글", nil)
_a1725(_a1831, "towerup", function()
_a1639("towerup", function() return _a1595.UpgradeInterval end, _a1638, "타워업글")
end)
end
do
local _a1832, _a1833 = _a1715(_a1779, "자동 뽑기", nil)
_a1725(_a1833, "hatch", function()
_a1639("hatch", function() return _a1595.HatchInterval end, _a1621, "뽑기")
end)
_a1736(_a1832, {
{ label = "주기", value = _a1595.HatchInterval, onChange = function(_a1834)
local _a1835 = tonumber(_a1834) if _a1835 and _a1835 >= 1 then _a1595.HatchInterval = _a1835 end
end },
{ label = "한 번에 최대", value = _a1595.HatchMax, onChange = function(_a1836)
local _a1837 = tonumber(_a1836) if _a1837 and _a1837 >= 1 then _a1595.HatchMax = math.floor(_a1837) end
end },
})
_a1736(_a1832, {
{ label = "예비금", value = _a1595.HatchReserve, onChange = function(_a1838)
local _a1839 = tonumber(_a1838) if _a1839 and _a1839 >= 0 then _a1595.HatchReserve = _a1839
_a1591("[설정] 뽑기 예비금 " .. _a1592(_a1839, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a1595.HatchEggNum, onChange = function(_a1840)
local _a1841 = tonumber(_a1840) if _a1841 and _a1841 >= 0 and _a1841 <= 12 then
_a1595.HatchEggNum = math.floor(_a1841)
table.clear(_a1596)
_a1591("[설정] 알 번호 " .. (_a1841 == 0 and "자동" or _a1841)) end
end },
})
_a1745(_a1832, {
{ label = "뽑기 현황 보기", col = _a1640.accent, fn = function()
local _a1842 = _a1620()
_a1598.sun = _a1842.sun
_a1591("")
_a1591("──── 뽑기 현황 ────")
_a1591("  알 등급     " .. _a1842.id)
_a1591("  알 uid      " .. tostring(_a1842.uid))
_a1591("  개당 비용   " .. (_a1842.cost and _a1592(_a1842.cost, 0) or "?"))
_a1591("  Sunflowers  " .. _a1592(_a1842.sun, 0))
_a1591("  예비금      " .. _a1592(_a1595.HatchReserve, 0))
_a1591("  지금 가능   " .. _a1842.canBuy .. "회")
_a1591("")
_a1591("  월드의 알 " .. _a1842.eggCount .. "개")
for _a1843, _a1844 in ipairs(_a1842.eggs) do
if _a1843 > 5 then break end
_a1591(("    %s  거리 %s"):format(_a1844.uid, _a1592(_a1844.dist)))
end
_a1591("")
_a1591("  누적 뽑기   " .. _a1598.hatched .. "회")
_a1682("log")
end },
{ label = "지금 1회 실행", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.hatch = true _a1621() _a1597.hatch = false _a1682("log") end)
end },
})
end
do
local _a1845, _a1846 = _a1715(_a1779, "럭 상시 최대 유지", nil)
_a1725(_a1846, "luck", function()
_a1639("luck", function() return _a1595.LuckInterval end, _a1625, "럭")
end)
_a1736(_a1845, {
{ label = "주기", value = _a1595.LuckInterval, onChange = function(_a1847)
local _a1848 = tonumber(_a1847) if _a1848 and _a1848 >= 60 then _a1595.LuckInterval = _a1848 end
end },
{ label = "예비금", value = _a1595.LuckReserve, onChange = function(_a1849)
local _a1850 = tonumber(_a1849) if _a1850 and _a1850 >= 0 then _a1595.LuckReserve = _a1850 end
end },
})
_a1736(_a1845, {
{ label = "최소 부족분", value = _a1595.LuckMinTopUp, onChange = function(_a1851)
local _a1852 = tonumber(_a1851) if _a1852 and _a1852 >= 0 then _a1595.LuckMinTopUp = _a1852 end
end },
})
for _a1853, _a1854 in ipairs(_a1622) do
_a1755(_a1845, _a1854,
function() return _a1595.LuckBoosts[_a1854] end,
function(_a1855) _a1595.LuckBoosts[_a1854] = _a1855 end)
end
_a1745(_a1845, {
{ label = "럭 현황 보기", col = _a1640.accent, fn = function()
local _a1856 = _a1623()
_a1598.sun = _a1856.sun
_a1591("")
_a1591("──── 이벤트 럭 ────")
_a1591("  머신 활성   " .. (_a1856.enabled and "O" or "X"))
_a1591("  최대 시간   " .. _a1624(_a1856.maxSec))
_a1591("  Sunflowers  " .. _a1592(_a1856.sun, 0))
_a1591("")
for _a1857, _a1858 in ipairs(_a1856.rows) do
_a1591(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a1858.rarity, _a1624(_a1858.left), _a1624(_a1858.deficit), _a1592(_a1858.need, 0),
_a1858.on and "" or "   (꺼짐)"))
end
_a1591("")
_a1591("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a1682("log")
end },
{ label = "지금 1회 충전", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.luck = true _a1625() _a1597.luck = false _a1682("log") end)
end },
})
end
do
local _a1859, _a1860 = _a1715(_a1779, "자동 씨앗 교체", nil)
_a1725(_a1860, "crop", function()
_a1639("crop", function() return _a1595.CropInterval end, _a1614, "씨앗")
end)
_a1736(_a1859, {
{ label = "주기", value = _a1595.CropInterval, onChange = function(_a1861)
local _a1862 = tonumber(_a1861) if _a1862 and _a1862 >= 5 then _a1595.CropInterval = _a1862 end
end },
{ label = "갈아엎기 배수", value = _a1595.CropMargin, onChange = function(_a1863)
local _a1864 = tonumber(_a1863) if _a1864 and _a1864 >= 1 then _a1595.CropMargin = _a1864 _a1591("[설정] 작물 배수 " .. _a1864) end
end },
})
_a1755(_a1859, "성장중 건너뛰기",
function() return _a1595.SkipUnhatched end,
function(_a1865) _a1595.SkipUnhatched = _a1865 end)
_a1745(_a1859, {
{ label = "밭 현황 보기", col = _a1640.accent, fn = function()
local _a1866, _a1867 = _a1600()
if not _a1867 then _a1591("[씨앗] 밭 없음") _a1682("log") return end
local _a1868, _a1869 = _a1611(_a1867), _a1610()
_a1591("")
_a1591("──── 밭 현황 ────")
_a1591("보유 씨앗 (기대 초당수익 순)")
for _a1870, _a1871 in ipairs(_a1869) do
_a1591(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a1871.id), tostring(_a1871.vr or "-"), tostring(_a1871.am), _a1592(_a1871.exp)))
end
local _a1872, _a1873, _a1874, _a1875, _a1876 = 0, 0, 0, 0, 0
local _a1877 = _a1869[1]
local _a1878 = _a1877 and _a1877.exp or 0
_a1591("")
_a1591("심어진 작물")
local _a1879 = 0
for _a1880, _a1881 in pairs(_a1868) do
_a1872 += 1
local _a1882 = _a1613(_a1881) or 0
_a1873 += _a1882
if _a1612(_a1881) then _a1875 += 1
elseif _a1878 > _a1882 * _a1595.CropMargin then _a1874 += 1
else _a1876 += 1 end
_a1879 += 1
if _a1879 <= 20 then
_a1591(("  칸%-4s %-20s %s/s%s"):format(tostring(_a1880),
tostring(rawget(_a1881, "sp") or "?"), _a1592(_a1882),
_a1612(_a1881) and "  (자라는 중)" or ""))
end
end
if _a1872 > 20 then _a1591("  ... (" .. (_a1872 - 20) .. "칸 더)") end
_a1591("")
_a1591(("총 %d칸 / 합계 %s per sec"):format(_a1872, _a1592(_a1873)))
_a1591(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a1874, _a1876, _a1875))
_a1682("log")
end },
{ label = "지금 1회 실행", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.crop = true _a1614() _a1597.crop = false _a1682("log") end)
end },
})
end
do
local _a1883, _a1884 = _a1715(_a1779, "자동 확장", nil)
_a1725(_a1884, "expand", function()
_a1639("expand", function() return _a1595.ExpandInterval end, _a1617, "확장")
end)
_a1736(_a1883, {
{ label = "주기", value = _a1595.ExpandInterval, onChange = function(_a1885)
local _a1886 = tonumber(_a1885) if _a1886 and _a1886 >= 5 then _a1595.ExpandInterval = _a1886 end
end },
{ label = "밭칸 스캔", value = _a1595.MaxBedScan, onChange = function(_a1887)
local _a1888 = tonumber(_a1887) if _a1888 and _a1888 >= 1 then _a1595.MaxBedScan = math.floor(_a1888) end
end },
})
_a1745(_a1883, {
{ label = "확장 현황 보기", col = _a1640.accent, fn = function()
local _a1889, _a1890, _a1891, _a1892 = _a1600()
if not _a1890 then _a1591("[확장] 밭 없음") _a1682("log") return end
local _a1893 = _a1606()
_a1598.sun = _a1893
local _a1894 = _a1615(true)
_a1591("")
_a1591("──── 확장 현황 ────")
_a1591("Sunflowers = " .. _a1592(_a1893, 0))
_a1591("")
_a1591("레인 " .. tostring(_a1892) .. "개 열림")
local _a1895 = {}
for _a1896 in pairs(_a1894) do _a1895[#_a1895 + 1] = tonumber(_a1896) or _a1896 end
table.sort(_a1895, function(_a1897, _a1898) return tostring(_a1897) < tostring(_a1898) end)
for _a1899, _a1900 in ipairs(_a1895) do
local _a1901 = _a1894[_a1900] or _a1894[tostring(_a1900)]
local _a1902 = tonumber(_a1900) or 0
local _a1903 = (_a1902 == (tonumber(_a1892) or 0) + 1)
and ((tonumber(_a1901) or math.huge) <= _a1893 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a1902 <= (tonumber(_a1892) or 0) and "  (열림)" or "")
_a1591(("  레인 %-3s %s%s"):format(tostring(_a1900), _a1592(tonumber(_a1901) or 0, 0), _a1903))
end
local _a1904 = _a1616(_a1890)
_a1591("")
_a1591("잠긴 밭칸 " .. #_a1904 .. "개 (싼 순 8개)")
for _a1905 = 1, math.min(8, #_a1904) do
local _a1906 = _a1904[_a1905]
_a1591(("  칸 %-4s %s%s"):format(_a1906.id, _a1906.cost and _a1592(_a1906.cost, 0) or "?",
(_a1906.cost and _a1906.cost <= _a1893) and "  ← 오픈 가능" or ""))
end
if #_a1904 == 0 then _a1591("  (전부 열려 있음)") end
_a1682("log")
end },
{ label = "지금 1회 실행", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.expand = true _a1617() _a1597.expand = false _a1682("log") end)
end },
})
end
do
local _a1907, _a1908 = _a1715(_a1779, "자동 리버스", nil)
_a1725(_a1908, "rebirth", function()
_a1639("rebirth", function() return _a1595.RebirthInterval end, _a1619, "리버스")
end)
_a1736(_a1907, {
{ label = "주기", value = _a1595.RebirthInterval, onChange = function(_a1909)
local _a1910 = tonumber(_a1909) if _a1910 and _a1910 >= 10 then _a1595.RebirthInterval = _a1910 end
end },
})
_a1745(_a1907, {
{ label = "리버스 현황 보기", col = _a1640.accent, fn = function()
local _a1911 = _a1618()
_a1591("")
_a1591("──── 리버스 현황 ────")
if not _a1911 then _a1591("  밭 없음") _a1682("log") return end
_a1591(("  현재 리버스   %d회  (최대 %s)"):format(_a1911.regrows, tostring(_a1911.cap)))
_a1591(("  레인          %d / 7 %s"):format(_a1911.lanes, _a1911.lanes >= 7 and "OK" or "부족"))
_a1591(("  코인보스      %d / %d %s"):format(_a1911.kills, _a1911.need,
_a1911.kills >= _a1911.need and "OK" or "부족"))
_a1591("")
_a1591(_a1911.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a1911.reason)))
_a1682("log")
end },
{ label = "지금 1회 리버스", col = _a1640.bad, fn = function()
task.spawn(function() _a1597.rebirth = true _a1619() _a1597.rebirth = false _a1682("log") end)
end },
})
end
local _a1912 = _a1699("main", "메인 게임", 30)
do
local _a1913, _a1914 = _a1715(_a1912, "올 자동", nil)
local _a1915 = _a1641("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a1640.cardHi,
BorderSizePixel = 0, LayoutOrder = _a1710(),
}, _a1913)
_a1648(_a1915, 6)
_a1655(_a1915, 8)
local _a1916 = _a1641("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a1640.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a1915)
task.spawn(function()
while _a1658 and _a1658.Parent do
local _a1917 = _a1627.ctl.now
local _a1918 = _a1597.auto and "🟢" or "⚪"
local _a1919 = _a1917.act or "-"
if _a1917.detail and _a1917.detail ~= "" then _a1919 = _a1919 .. "  " .. _a1917.detail end
_a1916.Text = table.concat({
_a1918 .. " " .. (_a1597.auto and (_a1917.step or "-") or "정지"),
"▸ " .. _a1919,
"목표 " .. (_a1917.goal or "-") .. (_a1917.prog ~= "" and ("   " .. _a1917.prog) or ""),
"1.리버스 " .. (_a1627.auto.rebNote or "-"),
"2.존해금 " .. (_a1627.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a1627.auto.farmZone or "-") .. "   현재 " .. tostring(_a1627.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a1627.auto.start()
for _a1920, _a1921 in ipairs(_a1627.auto.STEPS) do _a1597[_a1921.run] = false end
for _a1922, _a1923 in ipairs(_a1627.auto.SIDE) do _a1597[_a1923.run] = false end
_a1597.petspd = true
_a1597.rewatch = true
_a1722()
_a1639("auto", function() return _a1595.AutoInterval end, _a1627.auto.master, "자동")
end
_a1725(_a1914, "auto", _a1627.auto.start)
_a1736(_a1913, {
{ label = "주기", value = _a1595.AutoInterval, onChange = function(_a1924)
local _a1925 = tonumber(_a1924) if _a1925 and _a1925 >= 1 then _a1595.AutoInterval = _a1925 end
end },
{ label = "정체 판정(초)", value = _a1595.PursueStallSec, onChange = function(_a1926)
local _a1927 = tonumber(_a1926) if _a1927 and _a1927 >= 10 then _a1595.PursueStallSec = _a1927 end
end },
})
_a1736(_a1913, {
{ label = "운 퀘 최소 알 개수", value = _a1595.HatchMinAfford, onChange = function(_a1928)
local _a1929 = tonumber(_a1928) if _a1929 and _a1929 >= 1 then _a1595.HatchMinAfford = math.floor(_a1929) end
end },
{ label = "더 버는 시간(초)", value = _a1595.MoneyDwell, onChange = function(_a1930)
local _a1931 = tonumber(_a1930) if _a1931 and _a1931 >= 0 then _a1595.MoneyDwell = _a1931 end
end },
})
_a1736(_a1913, {
{ label = "부화 한 번에(초)", value = _a1595.HatchBudget, onChange = function(_a1932)
local _a1933 = tonumber(_a1932) if _a1933 and _a1933 >= 3 then _a1595.HatchBudget = _a1933 end
end },
})
_a1736(_a1913, {
{ label = "이동 방식", value = _a1595.TpMode, onChange = function(_a1934)
_a1934 = tostring(_a1934 or ""):lower()
if _a1934 == "instant" or _a1934 == "glide" or _a1934 == "walk" then _a1595.TpMode = _a1934 end
end },
{ label = "glide 속도", value = _a1595.TpSpeed, onChange = function(_a1935)
local _a1936 = tonumber(_a1935) if _a1936 and _a1936 >= 16 then _a1595.TpSpeed = _a1936 end
end },
})
_a1755(_a1913, "차단 화면에 실제 클릭까지 시도",
function() return _a1595.ScreenRealClick end,
function(_a1937) _a1595.ScreenRealClick = _a1937 end)
_a1755(_a1913, "퀘스트 없을 때도 알 까기",
function() return _a1595.IdleHatch end,
function(_a1938) _a1595.IdleHatch = _a1938 end)
_a1755(_a1913, "존 해금·리버스는 퀘스트 끝나고",
function() return _a1595.HoldZoneForQuest end,
function(_a1939) _a1595.HoldZoneForQuest = _a1939 end)
for _a1940, _a1941 in ipairs(_a1627.auto.STEPS) do
local _a1942 = _a1941.key
_a1755(_a1913, "  " .. _a1940 .. ". " .. _a1941.label,
function() return _a1595.StepOn[_a1942] end,
function(_a1943) _a1595.StepOn[_a1942] = _a1943 end)
end
for _a1944, _a1945 in ipairs(_a1627.auto.SIDE) do
local _a1946 = _a1945.key
_a1755(_a1913, "  · " .. _a1945.label .. " (순위 밖)",
function() return _a1595.StepOn[_a1946] end,
function(_a1947) _a1595.StepOn[_a1946] = _a1947 end)
end
_a1745(_a1913, {
{ label = "지금 상태", col = _a1640.accent, fn = function()
_a1591("")
_a1591("──── 올 자동 ────")
_a1591("  " .. (_a1597.auto and "돌아가는 중" or "정지") ..
(_a1627.auto.step and ("   지금: " .. _a1627.auto.step) or ""))
local _a1948, _a1949 = _a1627.quest.bestDepActive()
_a1591("  현재 존 " .. tostring(_a1627.move.curZone()) .. " / 최고 존 " .. tostring(_a1627.move.bestZone()))
if _a1948 then
_a1591("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a1949 and _a1949.title))
else
_a1591("  존해금·리버스 진행 가능")
end
_a1591("")
_a1591("  먼저 (순위 밖):")
for _a1950, _a1951 in ipairs(_a1627.auto.SIDE) do
_a1591(("      %-16s %s"):format(_a1951.label, _a1595.StepOn[_a1951.key] and "ON" or "off"))
end
_a1591("  우선순위:")
for _a1952, _a1953 in ipairs(_a1627.auto.STEPS) do
_a1591(("    %d. %-16s %s%s"):format(_a1952, _a1953.label,
_a1595.StepOn[_a1953.key] and "ON" or "off",
_a1953.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a1591("")
_a1591("  세이브")
local _a1954 = _a1593.Save
_a1591("    Library.Client.Save : " .. (_a1954 and "로드됨" or "★ 없음"))
if _a1954 then
local _a1955, _a1956 = pcall(_a1954.Get)
_a1591("    Get()        : " .. (_a1955 and type(_a1956) or ("에러 " .. tostring(_a1956))))
local _a1957, _a1958 = pcall(_a1954.Get, _a1589)
_a1591("    Get(LP)      : " .. (_a1957 and type(_a1958) or ("에러 " .. tostring(_a1958))))
if rawget(_a1954, "GetSaves") then
local _a1959, _a1960 = pcall(_a1954.GetSaves)
if _a1959 and type(_a1960) == "table" then
local _a1961 = 0
for _a1962 in pairs(_a1960) do
_a1961 += 1
if _a1961 <= 3 then _a1591("      키: " .. tostring(_a1962)
.. (_a1962 == _a1589 and "   ← 내 LocalPlayer" or "")) end
end
_a1591("    GetSaves()   : " .. _a1961 .. "개")
else
_a1591("    GetSaves()   : 에러 " .. tostring(_a1960))
end
end
local _a1963 = _a1628()
if _a1963 then
local _a1964 = rawget(_a1963, "Goals")
_a1591("    → 읽기 성공. Rebirths " .. tostring(rawget(_a1963, "Rebirths"))
.. " / Goals " .. (type(_a1964) == "table" and #_a1964 or "없음"))
else
_a1591("    → ★ 어떤 방법으로도 못 읽음")
end
end
_a1591("")
_a1591("  마지막 바퀴 (" .. tostring(_a1627.auto.passN or 0) .. "번째)")
if _a1627.auto.lastPassAt then
_a1591(("    %.0f초 전"):format(os.clock() - _a1627.auto.lastPassAt))
else
_a1591("    아직 한 바퀴도 안 돎 — 루프가 안 돌고 있습니다")
end
for _a1965, _a1966 in ipairs(_a1627.auto.lastTrace or {}) do _a1591("    " .. _a1966) end
_a1682("log")
end },
{ label = "화면 넘기기 진단", col = _a1640.warn, fn = function()
task.spawn(function()
_a1591("")
_a1591("──── 보상 화면 ────")
local _a1967 = _a1626.Vars
_a1591("  Library.Variables : " .. (_a1967 and "로드됨" or "없음"))
if _a1967 then
_a1591("    IsRebirthing = " .. tostring(rawget(_a1967, "IsRebirthing")))
_a1591("    IsRankingUp  = " .. tostring(rawget(_a1967, "IsRankingUp")))
_a1591("    OpeningEgg   = " .. tostring(rawget(_a1967, "OpeningEgg")))
end
_a1591("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a1591("  getgc          : " .. tostring(type(getgc) == "function"))
_a1591("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a1968 = _a1589:FindFirstChildOfClass("PlayerGui")
if _a1968 then
_a1591("  떠 있는 차단 화면:")
local _a1969 = false
for _a1970, _a1971 in ipairs(_a1627.screen.BLOCKERS) do
local _a1972 = _a1968:FindFirstChild(_a1971[1])
_a1591(("    %-14s %s"):format(_a1971[1],
_a1972 and (_a1972.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a1972 and _a1972.Enabled then _a1969 = true end
end
if not _a1969 then _a1591("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a1591("")
_a1591("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a1973, _a1974 = {}, 0
for _a1975, _a1976 in ipairs({ true, false }) do
local _a1977, _a1978 = pcall(getgc, _a1976)
if _a1977 then
for _a1979, _a1980 in ipairs(_a1978) do
if type(_a1980) == "function" and _a1974 < 25 then
local _a1981, _a1982 = pcall(debug.info, _a1980, "s")
if _a1981 and type(_a1982) == "string"
and (_a1982:find("Rebirth", 1, true) or _a1982:find("Rank Up", 1, true)) then
local _a1983, _a1984 = pcall(debug.info, _a1980, "a")
if _a1983 then
local _a1985 = {}
for _a1986 = 1, 16 do
local _a1987, _a1988 = pcall(debug.getupvalue, _a1980, _a1986)
if not _a1987 then break end
_a1985[_a1986] = type(_a1988)
end
local _a1989 = ("인자%d | %s"):format(_a1984 or -1,
#_a1985 > 0 and table.concat(_a1985, ",") or "(없음)")
if not _a1973[_a1989] then
_a1973[_a1989] = true
_a1974 += 1
_a1591("    " .. _a1989)
end
end
end
end
end
end
end
if _a1974 == 0 then _a1591("    (하나도 못 찾음)") end
end
for _a1990, _a1991 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a1627.screen._sig = nil
local _a1992 = _a1627.screen.findSignalFns(_a1991)
_a1591("")
_a1591(("  [%s] 찾은 함수 %d개"):format(_a1991, #_a1992))
for _a1993, _a1994 in ipairs(_a1992) do
_a1591(("    %s%s"):format(_a1994.exact and "★정확일치 " or "", tostring(_a1994.src)))
_a1591(("       upvalue %d개 : %s"):format(_a1994.n or 0, tostring(_a1994.sig)))
end
if #_a1992 == 0 then
_a1591("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a1995, _a1996 = _a1627.screen.signal(_a1991)
_a1591(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a1995), tostring(_a1996)))
local _a1997 = _a1627.screen.SIGNAL[_a1991]
_a1591(("    게임내 입력발동 : %s"):format(
tostring(_a1627.screen.pressInGame(_a1997 and _a1997.pats or {}))))
end
_a1591("")
_a1591("  감시 루프 RUN.rewatch = " .. tostring(_a1597.rewatch))
_a1682("log")
end)
end },
{ label = "한 바퀴만", col = _a1640.cardHi, fn = function()
task.spawn(function()
_a1597.auto = true _a1627.auto.master() _a1597.auto = false _a1682("log")
end)
end },
{ label = "자동 점검", col = _a1640.warn, fn = function()
task.spawn(function()
_a1591("")
_a1591("════ 올 자동 점검 ════")
_a1591("  RUN.auto = " .. tostring(_a1597.auto))
local _a1998 = {}
for _a1999, _a2000 in ipairs(_a1627.auto.SIDE) do
_a1998[#_a1998 + 1] = _a2000.key .. "=" .. tostring(_a1595.StepOn[_a2000.key])
end
for _a2001, _a2002 in ipairs(_a1627.auto.STEPS) do
_a1998[#_a1998 + 1] = _a2002.key .. "=" .. tostring(_a1595.StepOn[_a2002.key])
end
_a1591("  단계 ON/OFF : " .. table.concat(_a1998, "  "))
_a1591("  lockGoal    : " .. (_a1627.ctl.lockGoal and tostring(_a1627.ctl.lockGoal.q.title) or "없음"))
local _a2003, _a2004 = _a1627.quest.bestDepActive()
_a1591("  보류중?     : " .. tostring(_a2003) .. (_a2004 and ("  ← " .. tostring(_a2004.title)) or ""))
_a1591("  리모트      : 존 " .. (_a1626.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a1626.R_Reb and "O" or "X"))
_a1591("")
_a1591("  ── 존 해금 판정 ──")
local _a2005 = _a1631()
if not _a2005 then
_a1591("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a2006 = _a1626.Zone and rawget(_a1626.Zone, "GetNextZone")
if _a2006 then
local _a2007, _a2008, _a2009 = pcall(_a1626.Zone.GetNextZone)
_a1591("    GetNextZone → ok=" .. tostring(_a2007)
.. " / " .. tostring(_a2008) .. " / " .. tostring(_a2009))
end
if _a1626.Zone and rawget(_a1626.Zone, "HasCompletedNextZoneQuests") then
local _a2010, _a2011 = pcall(_a1626.Zone.HasCompletedNextZoneQuests)
_a1591("    존 퀘스트 완료? " .. (_a2010 and tostring(_a2011) or ("에러 " .. tostring(_a2011))))
end
else
_a1591("    다음 존 : " .. tostring(_a2005.id))
_a1591(("    가격 %s %s / 보유 %s → %s"):format(
_a1592(_a2005.price or 0, 0), tostring(_a2005.currency), _a1592(_a2005.have, 0),
_a2005.ok and "지금 살 수 있음" or "부족"))
end
_a1591("")
_a1591("  ── 리버스 판정 ──")
local _a2012 = _a1636()
if not _a2012 then _a1591("    세이브 못 읽음")
else
_a1591(("    현재 %d → 다음 %d"):format(_a2012.current, _a2012.nextN))
_a1591("    최근 사유 : " .. tostring(_a1627.auto.rebNote or "-"))
end
_a1591("")
_a1591("  ── 직전 바퀴 기록 ──")
if _a1627.auto.lastTrace and #_a1627.auto.lastTrace > 0 then
for _a2013, _a2014 in ipairs(_a1627.auto.lastTrace) do _a1591("    " .. _a2014) end
_a1591(("    (%.0f초 전)"):format(os.clock() - (_a1627.auto.lastPassAt or os.clock())))
else
_a1591("    아직 한 바퀴도 안 돌았음")
end
_a1682("log")
end)
end },
})
local _a2015, _a2016 = _a1715(_a1912, "펫 이동속도", nil)
_a1725(_a2016, "petspd", function()
_a1639("petspd", function() return 0.4 end, _a1627.item.applyPetSpeed, "펫속도")
end)
_a1736(_a2015, {
{ label = "배수", value = _a1595.PetSpeedMult, onChange = function(_a2017)
local _a2018 = tonumber(_a2017) if _a2018 and _a2018 >= 1 then _a1595.PetSpeedMult = _a2018 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a1595.PetSpeedBase, onChange = function(_a2019)
local _a2020 = tonumber(_a2019) if _a2020 and _a2020 > 0 then _a1595.PetSpeedBase = _a2020 end
end },
})
_a1745(_a2015, {
{ label = "지금 적용 / 확인", col = _a1640.accent, fn = function()
local _a2021, _a2022 = _a1627.item.applyPetSpeed()
_a1591("")
_a1591("──── 펫 이동속도 ────")
_a1591("  PlayerPet 모듈 : " .. (_a1626.PlayerPet and "로드됨" or "없음"))
_a1591(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a2021, tostring(_a1595.PetSpeedMult), tostring(_a1595.PetSpeedBase)))
if _a2022 then _a1591("  " .. tostring(_a2022)) end
if _a2021 == 0 then _a1591("  펫을 장착하고 다시 눌러보세요") end
_a1682("log")
end },
})
_a1639("petspd", function() return 0.4 end, _a1627.item.applyPetSpeed, "펫속도")
_a1639("rewatch", function() return 1 end, function()
_a1627.screen.watchTick = (_a1627.screen.watchTick or 0) + 1
_a1627.egg.watchStuck()
if _a1627.screen.dismissBusy then return end
local _a2023, _a2024 = _a1627.screen.rewardScreenUp()
if _a2023 and _a1627.screen.screenGaveUp and (os.clock() - _a1627.screen.screenGaveUp) < 30 then
return
end
if _a2023 then
if _a1627.screen.lastBlocker ~= _a2024 then
_a1627.screen.lastBlocker = _a2024
_a1591("[화면] " .. tostring(_a2024) .. " 화면 감지 — 넘기는 중")
end
_a1627.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a2025, _a2026 = _a1715(_a1912, "자동 파밍 유지", nil)
_a1725(_a2026, "farm", function()
_a1639("farm", function() return _a1595.FarmInterval end, _a1630, "파밍")
end)
_a1736(_a2025, {
{ label = "주기", value = _a1595.FarmInterval, onChange = function(_a2027)
local _a2028 = tonumber(_a2027) if _a2028 and _a2028 >= 3 then _a1595.FarmInterval = _a2028 end
end },
})
local _a2029, _a2030 = _a1715(_a1912, "자동 존 해금", nil)
_a1725(_a2030, "zone", function()
_a1639("zone", function() return _a1595.ZoneInterval end, _a1632, "존")
end)
_a1736(_a2029, {
{ label = "주기", value = _a1595.ZoneInterval, onChange = function(_a2031)
local _a2032 = tonumber(_a2031) if _a2032 and _a2032 >= 3 then _a1595.ZoneInterval = _a2032 end
end },
})
_a1745(_a2029, {
{ label = "다음 존 보기", col = _a1640.accent, fn = function()
local _a2033 = _a1631()
_a1591("")
if not _a2033 then _a1591("[존] 다음 존 없음 (최대 도달?)")
else
_a1591("──── 다음 존 ────")
_a1591("  " .. tostring(_a2033.id))
_a1591("  가격 " .. _a1592(_a2033.price or 0, 0) .. " " .. tostring(_a2033.currency))
_a1591("  보유 " .. _a1592(_a2033.have, 0))
_a1591("  " .. (_a2033.ok and "지금 해금 가능" or "부족"))
end
_a1682("log")
end },
{ label = "지금 1회", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.zone = true _a1632() _a1597.zone = false _a1682("log") end)
end },
})
local _a2034, _a2035 = _a1715(_a1912, "자동 부화", nil)
_a1725(_a2035, "mhatch", function()
_a1639("mhatch", function() return _a1595.MainHatchInterval end, _a1635, "부화")
end)
_a1736(_a2034, {
{ label = "주기", value = _a1595.MainHatchInterval, onChange = function(_a2036)
local _a2037 = tonumber(_a2036) if _a2037 and _a2037 >= 1 then _a1595.MainHatchInterval = _a2037 end
end },
{ label = "한 번에 최대", value = _a1595.MainHatchMax, onChange = function(_a2038)
local _a2039 = tonumber(_a2038) if _a2039 and _a2039 >= 1 then _a1595.MainHatchMax = math.floor(_a2039) end
end },
})
_a1736(_a2034, {
{ label = "예비금", value = _a1595.MainHatchReserve, onChange = function(_a2040)
local _a2041 = tonumber(_a2040) if _a2041 and _a2041 >= 0 then _a1595.MainHatchReserve = _a2041 end
end },
{ label = "알 ID (비우면 자동)", value = _a1595.MainEggId, onChange = function(_a2042)
_a1595.MainEggId = _a2042 or ""
end },
})
_a1736(_a2034, {
{ label = "알 인식 거리", value = _a1595.EggRange, onChange = function(_a2043)
local _a2044 = tonumber(_a2043) if _a2044 and _a2044 >= 5 then _a1595.EggRange = _a2044 end
end },
})
_a1755(_a2034, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a1595.AutoUnlockEgg end,
function(_a2045) _a1595.AutoUnlockEgg = _a2045 end)
_a1755(_a2034, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a1595.UseAutoHatch end,
function(_a2046) _a1595.UseAutoHatch = _a2046 if not _a2046 then _a1627.egg.autoHatchOff() end end)
_a1755(_a2034, "까는 화면 자동으로 넘기기 (신호)",
function() return _a1595.HatchClick end,
function(_a2047) _a1595.HatchClick = _a2047 end)
_a1745(_a2034, {
{ label = "잠긴 알 보기", col = _a1640.accent, fn = function()
local _a2048, _a2049, _a2050 = _a1627.egg.lockedEggs()
_a1591("")
_a1591("──── 알 해금 현황 ────")
_a1591(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a2049, _a2050))
_a1591("  해금 리모트 : " .. (_a1626.R_EggUn and "있음" or "없음"))
if #_a2048 == 0 then
_a1591("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a1591("  아직 안 푼 알 " .. #_a2048 .. "개:")
for _a2051, _a2052 in ipairs(_a2048) do
_a1591(("    #%-3d %s"):format(_a2052.num, _a2052.id))
if _a2051 >= 20 then _a1591("    ...") break end
end
end
_a1682("log")
end },
{ label = "부화 진단", col = _a1640.warn, fn = function()
task.spawn(function()
_a1591("")
_a1591("──── 부화 진단 ────")
local _a2053, _a2054, _a2055, _a2056 = _a1633()
_a1591("  대상 알   : " .. tostring(_a2053))
if not _a2053 then _a1591("  (오픈한 알이 없음)") _a1682("log") return end
local _a2057 = _a2054 and tonumber(rawget(_a2054, "eggNumber"))
_a1591("  알 번호   : " .. tostring(_a2057) .. "   오픈함? " .. tostring(_a1627.egg.eggUnlocked(_a2057)))
_a1591("  거리      : " .. (_a2055 and ("%.0f (사거리 안)"):format(_a2055)
or ((_a2056 and ("%.0f (사거리 %d 밖)"):format(_a2056, _a1595.EggRange)) or "받침대 못 찾음")))
local _a2058 = _a2054 and rawget(_a2054, "currency") or "?"
_a1591("  통화      : " .. tostring(_a2058) .. "   보유 " .. _a1592(_a1629(_a2058), 0))
if type(_a1626.CalcEgg) == "function" then
local _a2059, _a2060 = pcall(_a1626.CalcEgg, _a2054)
_a1591("  CalcEggPricePlayer : " .. (_a2059 and tostring(_a2060) or ("에러 " .. tostring(_a2060))))
end
if type(_a1626.CalcEggB) == "function" then
local _a2061, _a2062 = pcall(_a1626.CalcEggB, _a2054)
_a1591("  CalcEggPrice       : " .. (_a2061 and tostring(_a2062) or ("에러 " .. tostring(_a2062))))
end
if _a1626.Egg then
for _a2063, _a2064 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a1626.Egg, _a2064) then
local _a2065, _a2066 = pcall(_a1626.Egg[_a2064], _a2054)
_a1591(("  %-28s : %s"):format(_a2064, _a2065 and tostring(_a2066) or ("에러 " .. tostring(_a2066))))
end
end
end
_a1591("  OpeningEgg      : " .. tostring(_a1626.Vars and rawget(_a1626.Vars, "OpeningEgg")))
if _a1626.Hatch then
for _a2067, _a2068 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a1626.Hatch, _a2068) then
local _a2069, _a2070 = pcall(_a1626.Hatch[_a2068])
_a1591(("  %-15s : %s"):format(_a2068, _a2069 and tostring(_a2070) or ("에러 " .. tostring(_a2070))))
end
end
if rawget(_a1626.Hatch, "GetEggDirectory") then
local _a2071, _a2072 = pcall(_a1626.Hatch.GetEggDirectory)
_a1591("  세팅된 알       : " .. (_a2071 and _a2072 and tostring(rawget(_a2072, "_id")) or "없음"))
end
end
_a1591("  ▶ SetupEgg 시도")
_a1627.egg._ahEgg = nil
_a1627.egg.autoHatchOn(_a2053, 1)
if _a1626.Hatch and rawget(_a1626.Hatch, "IsHatching") then
local _a2073, _a2074 = pcall(_a1626.Hatch.IsHatching)
_a1591("    IsHatching 이후 : " .. (_a2073 and tostring(_a2074) or ("에러 " .. tostring(_a2074))))
_a1591("    " .. ((_a2073 and _a2074) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a1591("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a1591("")
_a1591("  ▶ 1개로 실제 호출")
local _a2075, _a2076
local _a2077 = pcall(function() _a2075, _a2076 = _a1594.R_EGG:InvokeServer(_a2053, 1) end)
_a1591("    호출성공 : " .. tostring(_a2077))
_a1591("    반환1    : " .. tostring(_a2075))
_a1591("    반환2    : " .. tostring(_a2076))
_a1682("log")
end)
end },
{ label = "지금 전부 해금", col = _a1640.good, fn = function()
task.spawn(function()
_a1591("")
local _a2078, _a2079 = _a1627.egg.unlockEggs(true)
_a1591(_a2078 > 0 and ("[해금] %d개 완료"):format(_a2078)
or ("[해금] 0개" .. (_a2079 and (" — " .. tostring(_a2079)) or "")))
_a1682("log")
end)
end },
})
_a1745(_a2034, {
{ label = "알 현황 보기", col = _a1640.accent, fn = function()
local _a2080 = _a1634()
_a1591("")
if not _a2080 then _a1591("[부화] 알을 못 찾음")
else
_a1591("──── 메인 알 ────")
_a1591("  " .. tostring(_a2080.id))
_a1591("  가격 " .. (_a2080.price and _a1592(_a2080.price, 0) or "?") .. " " .. tostring(_a2080.currency))
_a1591("  보유 " .. _a1592(_a2080.have, 0))
_a1591("  한 번에 " .. _a2080.maxN .. "개까지")
_a1591("  지금 가능 " .. _a2080.canBuy .. "회")
if _a2080.inRange then
_a1591(("  거리 %.0f 스터드 — 부화 가능"):format(_a2080.dist))
else
_a1591(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a1595.EggRange, _a2080.nearest and ("%.0f"):format(_a2080.nearest) or "?"))
_a1591("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a1591("")
_a1591("──── 주변 알 (가까운 순 10개) ────")
local _a2081 = _a1627.egg.eggStands()
for _a2082 = 1, math.min(10, #_a2081) do
local _a2083 = _a2081[_a2082]
_a1591(("  %6.0f  #%-3d %-24s %s"):format(
_a2083.dist, _a2083.num, _a2083.id, _a1627.egg.eggUnlocked(_a2083.num) and "오픈함" or "잠김"))
end
if #_a2081 == 0 then _a1591("  (못 찾음)") end
_a1682("log")
end },
{ label = "지금 1회", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.mhatch = true _a1635() _a1597.mhatch = false _a1682("log") end)
end },
})
local _a2084, _a2085 = _a1715(_a1912, "랭크 퀘스트 자동", nil)
_a1725(_a2085, "quest", function()
_a1639("quest", function() return _a1595.QuestInterval end, _a1627.quest.cycle, "퀘스트")
end)
_a1736(_a2084, {
{ label = "주기", value = _a1595.QuestInterval, onChange = function(_a2086)
local _a2087 = tonumber(_a2086) if _a2087 and _a2087 >= 5 then _a1595.QuestInterval = _a2087 end
end },
{ label = "포션 한 번에", value = _a1595.QuestUseMax, onChange = function(_a2088)
local _a2089 = tonumber(_a2088) if _a2089 and _a2089 >= 1 then _a1595.QuestUseMax = math.floor(_a2089) end
end },
})
_a1755(_a2084, "필요한 자동화 자동 ON",
function() return _a1595.QuestDrive end,
function(_a2090) _a1595.QuestDrive = _a2090 end)
_a1755(_a2084, "포션/인챈트 업글 퀘스트",
function() return _a1595.QuestUpgrade end,
function(_a2091) _a1595.QuestUpgrade = _a2091 end)
_a1755(_a2084, "포션 사용 퀘스트",
function() return _a1595.QuestUsePotion end,
function(_a2092) _a1595.QuestUsePotion = _a2092 end)
_a1745(_a2084, {
{ label = "퀘스트 현황 보기", col = _a1640.accent, fn = function()
local _a2093 = _a1627.quest.status()
_a1591("")
if not _a2093 then _a1591("[퀘스트] 세이브 못 읽음")
else
_a1591("──── 랭크 퀘스트 ────")
_a1591(("  Rank %d   ★%d"):format(_a2093.rank, _a2093.rankStars))
if #_a2093.list == 0 then _a1591("  퀘스트 없음") end
for _a2094, _a2095 in ipairs(_a2093.list) do
local _a2096 = _a2095.how
local _a2097 =
(_a2096 == "farm" and "자동 파밍") or
(_a2096 == "hatch" and "자동 부화") or
(_a2096 == "zone" and "자동 존") or
(_a2096 == "potup" and "포션 업글") or
(_a2096 == "encup" and "인챈트 업글") or
(_a2096 == "potuse" and "포션 사용") or
(_a2096 == "fruituse" and "과일 사용") or
(_a2096 == "flaguse" and "깃발 사용") or
(_a2096 == "gold" and "골드 머신") or
(_a2096 == "rainbow" and "레인보우 머신") or
"수동"
local _a2098 = ""
if _a2095.ignored then
_a2097 = "무시"
_a2098 = "   → " .. _a2095.ignored
elseif _a2095.event then
local _a2099 = _a1627.ev.findEvent(_a2095.event, _a2095.bestOnly)
_a2098 = _a2099 and ("   → %s @%s %d초"):format(_a2099.name, tostring(_a2099.zone), _a2099.left)
or ("   → " .. _a2095.event .. " 대기중")
elseif _a2095.chest then
_a2098 = "   → " .. _a2095.chest
elseif _a2095.where then
_a2098 = "   → " .. _a2095.where
end
_a1591(("  [%d] %s"):format(_a2095.stars, tostring(_a2095.title)))
_a1591(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a2095.progress, _a2095.amount, _a2097, _a2095.type, _a2098))
end
end
_a1682("log")
end },
{ label = "활성 이벤트 보기", col = _a1640.accent, fn = function()
local _a2100 = _a1627.ev.events()
local _a2101 = _a1627.move.bestZone()
_a1591("")
_a1591("──── 지금 떠 있는 랜덤 이벤트 ────")
_a1591("  최고 존 : " .. tostring(_a2101) .. "   현재 존 : " .. tostring(_a1627.move.curZone()))
if #_a2100 == 0 then _a1591("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a2102, _a2103 in ipairs(_a2100) do
_a1591(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a2103.kind, tostring(_a2103.zone), _a2103.left,
_a2103.pos and ("(%.0f, %.0f, %.0f)"):format(_a2103.pos.X, _a2103.pos.Y, _a2103.pos.Z) or "좌표없음",
_a2103.zone == _a2101 and "  ★최고존" or ""))
end
_a1591("")
_a1591("  내 소환 아이템 :")
for _a2104 in pairs(_a1627.ev.SPAWN) do
local _a2105 = _a1627.ev.spawnItems(_a2104)
local _a2106 = 0
for _a2107, _a2108 in ipairs(_a2105) do _a2106 += _a2108.am end
_a1591(("    %-12s %d종 %d개"):format(_a2104, #_a2105, _a2106))
for _a2109, _a2110 in ipairs(_a2105) do
_a1591(("        %d. %-24s x%d%s"):format(
_a2109, _a2110.id, _a2110.am, _a2109 == 1 and "   ← 먼저 씀" or ""))
if _a2109 >= 6 then break end
end
end
_a1591("  점선 네모 안? " .. tostring(_a1627.move.inDottedBox()))
for _a2111, _a2112 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a2113, _a2114 = _a1627.ev.findChest(_a2112)
_a1591(("  %-20s %s"):format(_a2112,
_a2113 and ("가장 가까운 것 %.0f스터드"):format(_a2114 or 0) or "없음"))
end
_a1682("log")
end },
{ label = "포션 재고 보기", col = _a1640.accent, fn = function()
_a1591("")
_a1591("──── 포션 / 인챈트 재고 ────")
for _a2115, _a2116 in ipairs({ "Potion", "Enchant" }) do
local _a2117 = _a1627.item.stacks(_a2116)
table.sort(_a2117, function(_a2118, _a2119)
if _a2118.id ~= _a2119.id then return _a2118.id < _a2119.id end
return _a2118.tier < _a2119.tier
end)
_a1591("")
_a1591(_a2116 .. "  (" .. #_a2117 .. "종)")
for _a2120, _a2121 in ipairs(_a2117) do
local _a2122 = _a1627.item.perTier(_a2116, _a2121.tier)
local _a2123 = _a2122 and math.floor(_a2121.am / _a2122) or 0
_a1591(("   %-20s T%-2d x%-6d %s"):format(
_a2121.id, _a2121.tier, _a2121.am,
_a2123 > 0 and ("→ T" .. (_a2121.tier + 1) .. " " .. _a2123 .. "개 제작가능") or ""))
if _a2120 >= 40 then _a1591("   ...") break end
end
if #_a2117 == 0 then _a1591("   (없음)") end
end
_a1682("log")
end },
{ label = "지금 1회", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.quest = true _a1627.quest.cycle() _a1597.quest = false _a1682("log") end)
end },
})
local _a2124, _a2125 = _a1715(_a1912, "슬롯 머신 자동 (다이아)", nil)
_a1725(_a2125, "slots", function()
_a1639("slots", function() return _a1595.SlotInterval end, _a1627.mach.cycleSlots, "슬롯")
end)
_a1736(_a2124, {
{ label = "주기", value = _a1595.SlotInterval, onChange = function(_a2126)
local _a2127 = tonumber(_a2126) if _a2127 and _a2127 >= 5 then _a1595.SlotInterval = _a2127 end
end },
{ label = "남길 다이아", value = _a1595.SlotReserve, onChange = function(_a2128)
local _a2129 = tonumber(_a2128) if _a2129 and _a2129 >= 0 then _a1595.SlotReserve = _a2129 end
end },
})
_a1755(_a2124, "펫 장착 슬롯 (Pet Equip)",
function() return _a1595.SlotPet end, function(_a2130) _a1595.SlotPet = _a2130 end)
_a1755(_a2124, "알 부화 슬롯 (Egg Machine)",
function() return _a1595.SlotEgg end, function(_a2131) _a1595.SlotEgg = _a2131 end)
_a1745(_a2124, {
{ label = "슬롯 현황 보기", col = _a1640.accent, fn = function()
local _a2132 = _a1627.mach.slotStatus()
_a1591("")
_a1591("──── 슬롯 머신 ────")
if not _a2132 then _a1591("  세이브 못 읽음") _a1682("log") return end
_a1591("  다이아 " .. _a1592(_a2132.dia, 0))
_a1591("")
_a1591(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a2132.petOwned, _a2132.petMax, tostring(_a2132.maxEquip)))
if _a2132.petNext then
_a1591(("     다음 #%d  %s 다이아  %s"):format(
_a2132.petNext, _a2132.petCost and _a1592(_a2132.petCost, 0) or "?",
(_a2132.petCost and _a2132.petCost <= _a2132.dia - _a1595.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1591("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a1591("")
_a1591(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a2132.eggOwned, _a2132.eggMax, tostring(_a2132.maxHatch)))
if _a2132.eggEnd then
_a1591(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a2132.eggSize, _a2132.eggEnd, _a2132.eggCost and _a1592(_a2132.eggCost, 0) or "?",
(_a2132.eggCost and _a2132.eggCost <= _a2132.dia - _a1595.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1591("     랭크 상한까지 다 삼")
end
_a1591("")
_a1591("  리모트 : 펫 " .. (_a1626.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a1626.R_EggSlot and "O" or "X"))
_a1682("log")
end },
{ label = "지금 1회", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.slots = true _a1627.mach.cycleSlots() _a1597.slots = false _a1682("log") end)
end },
})
local _a2133, _a2134 = _a1715(_a1912, "아이템 자동 사용 (버프 유지)", nil)
_a1725(_a2134, "items", function()
_a1639("items", function() return _a1595.ItemInterval end, _a1627.item.cycleItems, "아이템")
end)
_a1736(_a2133, {
{ label = "주기", value = _a1595.ItemInterval, onChange = function(_a2135)
local _a2136 = tonumber(_a2135) if _a2136 and _a2136 >= 5 then _a1595.ItemInterval = _a2136 end
end },
{ label = "포션 한 바퀴 최대", value = _a1595.BuffMaxPotion, onChange = function(_a2137)
local _a2138 = tonumber(_a2137) if _a2138 and _a2138 >= 1 then _a1595.BuffMaxPotion = math.floor(_a2138) end
end },
})
_a1736(_a2133, {
{ label = "남길 개수", value = _a1595.ItemKeep, onChange = function(_a2139)
local _a2140 = tonumber(_a2139) if _a2140 and _a2140 >= 0 then _a1595.ItemKeep = math.floor(_a2140) end
end },
{ label = "과일/소모품 최대", value = _a1595.BuffMaxOther, onChange = function(_a2141)
local _a2142 = tonumber(_a2141) if _a2142 and _a2142 >= 1 then _a1595.BuffMaxOther = math.floor(_a2142) end
end },
})
_a1736(_a2133, {
{ label = "쓸 것 (비우면 전부)", value = _a1595.ItemAllow, onChange = function(_a2143)
_a1595.ItemAllow = _a2143 or ""
end },
{ label = "제외", value = _a1595.ItemBlock, onChange = function(_a2144)
_a1595.ItemBlock = _a2144 or ""
end },
})
_a1755(_a2133, "포션", function() return _a1595.BuffPotion end,
function(_a2145) _a1595.BuffPotion = _a2145 end)
_a1755(_a2133, "과일", function() return _a1595.BuffFruit end,
function(_a2146) _a1595.BuffFruit = _a2146 end)
_a1755(_a2133, "얼티밋 (충전되면 발동, 무료)", function() return _a1595.BuffUltimate end,
function(_a2147) _a1595.BuffUltimate = _a2147 end)
_a1755(_a2133, "소모품 (Rain/Sunlight 주의)", function() return _a1595.BuffConsumable end,
function(_a2148) _a1595.BuffConsumable = _a2148 end)
_a1755(_a2133, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a1595.BuffHighTier end,
function(_a2149) _a1595.BuffHighTier = _a2149 end)
_a1755(_a2133, "최고 존에서만 사용", function() return _a1595.ItemBestZone end,
function(_a2150) _a1595.ItemBestZone = _a2150 end)
_a1755(_a2133, "최고 존이 아니면 이동 후 사용", function() return _a1595.ItemTp end,
function(_a2151) _a1595.ItemTp = _a2151 end)
_a1745(_a2133, {
{ label = "버프 현황 보기", col = _a1640.accent, fn = function()
_a1591("")
_a1591("──── 버프 / 아이템 ────")
_a1591(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a1627.move.curZone()), tostring(_a1627.move.bestZone()),
_a1595.ItemBestZone and (_a1627.move.curZone() == _a1627.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a2152, _a2153 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a2154 = _a1627.item.activeBuffs(_a2152)
local _a2155 = {}
for _a2156 in pairs(_a2154) do _a2155[#_a2155 + 1] = _a2156 end
table.sort(_a2155)
_a1591(("  지금 걸린 %s : %s"):format(_a2152,
#_a2155 > 0 and table.concat(_a2155, ", ") or "없음"))
end
local _a2157 = _a1628()
local _a2158 = _a2157 and rawget(_a2157, "Ultimates")
if type(_a2158) == "table" then
local _a2159 = {}
for _a2160 in pairs(_a2158) do
local _a2161 = "?"
if _a1626.Ult and rawget(_a1626.Ult, "IsCharged") then
local _a2162, _a2163 = pcall(_a1626.Ult.IsCharged, _a2160)
_a2161 = _a2162 and (_a2163 and "충전됨" or "충전중") or "?"
end
_a2159[#_a2159 + 1] = _a2160 .. "(" .. _a2161 .. ")"
end
_a1591("  얼티밋 : " .. (#_a2159 > 0 and table.concat(_a2159, ", ") or "없음"))
end
_a1591("")
for _a2164, _a2165 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a2166 = _a1627.item.stacks(_a2165)
local _a2167, _a2168 = 0, 0
for _a2169, _a2170 in ipairs(_a2166) do
if _a1627.item.itemAllowed(_a2170.id) then _a2167 += 1 else _a2168 += 1 end
end
_a1591(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a2165, #_a2166, _a2167, _a2168))
for _a2171, _a2172 in ipairs(_a2166) do
_a1591(("      %-20s T%-2d x%-6d %s"):format(
_a2172.id, _a2172.tier, _a2172.am, _a1627.item.itemAllowed(_a2172.id) and "" or "제외됨"))
if _a2171 >= 12 then _a1591("      ...") break end
end
end
_a1591("")
_a1591("  리모트 : 포션 " .. (_a1626.R_PotUse and "O" or "X")
.. " / 과일 " .. (_a1626.R_Fruit and "O" or "X")
.. " / 소모품 " .. (_a1626.R_Cons and "O" or "X")
.. " / 얼티밋 " .. (_a1626.R_Ult and "O" or "X"))
_a1682("log")
end },
{ label = "지금 1회", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.items = true _a1627.item.cycleItems() _a1597.items = false _a1682("log") end)
end },
})
local _a2173, _a2174 = _a1715(_a1912, "맵 업그레이드 자동 (다이아)", nil)
_a1725(_a2174, "mapupg", function()
_a1639("mapupg", function() return _a1595.UpgInterval end, _a1627.mach.cycleUpg, "맵업글")
end)
_a1736(_a2173, {
{ label = "주기", value = _a1595.UpgInterval, onChange = function(_a2175)
local _a2176 = tonumber(_a2175) if _a2176 and _a2176 >= 5 then _a1595.UpgInterval = _a2176 end
end },
{ label = "남길 다이아", value = _a1595.UpgReserve, onChange = function(_a2177)
local _a2178 = tonumber(_a2177) if _a2178 and _a2178 >= 0 then _a1595.UpgReserve = _a2178 end
end },
})
_a1755(_a2173, "구매 전 그 앞으로 이동",
function() return _a1595.UpgTp end,
function(_a2179) _a1595.UpgTp = _a2179 end)
_a1745(_a2173, {
{ label = "업그레이드 목록", col = _a1640.accent, fn = function()
local _a2180 = _a1627.mach.upgList()
local _a2181 = _a1629("Diamonds")
_a1591("")
_a1591("──── 맵 업그레이드 ────")
_a1591("보유 다이아 " .. _a1592(_a2181, 0))
if #_a2180 == 0 then
_a1591("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a2182, _a2183, _a2184 = 0, 0, 0
for _a2185, _a2186 in ipairs(_a2180) do
if _a2186.bought then _a2183 += 1
elseif not _a2186.zoneOwned then _a2184 += 1
else _a2182 += 1 end
end
_a1591(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a2182, _a2183, _a2184))
_a1591("")
local _a2187 = 0
for _a2188, _a2189 in ipairs(_a2180) do
if _a2189.buyable then
_a2187 += 1
_a1591(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a2189.id, _a2189.tier, _a2189.zone, _a2189.cost and _a1592(_a2189.cost, 0) or "?",
tostring(_a2189.cur),
(_a2189.cost and _a2189.cost <= _a1629(_a2189.cur or "Diamonds") - _a1595.UpgReserve)
and "← 지금 가능" or ""))
if _a2187 >= 25 then _a1591("  ...") break end
end
end
_a1682("log")
end },
{ label = "업글 진단", col = _a1640.warn, fn = function()
task.spawn(function()
_a1591("")
_a1591("──── 맵 업그레이드 진단 ────")
_a1591("  리모트 : " .. (_a1626.R_Upg and _a1626.R_Upg:GetFullName() or "없음"))
local _a2190 = _a1627.mach.upgList()
_a1591("  로드된 기둥 " .. #_a2190 .. "개")
local _a2191
for _a2192, _a2193 in ipairs(_a2190) do
if _a2193.buyable and _a2193.cost then _a2191 = _a2193 break end
end
if not _a2191 then
_a1591("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a2194, _a2195 in ipairs(_a2190) do
_a1591(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a2195.id, _a2195.tier, tostring(_a2195.zone), tostring(_a2195.bought), tostring(_a2195.zoneOwned)))
if _a2194 >= 8 then _a1591("   ...") break end
end
_a1682("log") return
end
local _a2196 = _a1629(_a2191.cur or "Diamonds")
local _a2197 = _a1627.move.hrp()
local _a2198 = (_a2197 and _a2191.pos) and (_a2197.Position - _a2191.pos).Magnitude or nil
_a1591(("  대상 : %s T%d @%s"):format(_a2191.id, _a2191.tier, tostring(_a2191.zone)))
_a1591(("  가격 : %s %s / 보유 %s"):format(
_a1592(_a2191.cost, 0), tostring(_a2191.cur), _a1592(_a2196, 0)))
_a1591("  거리 : " .. (_a2198 and ("%.0f 스터드"):format(_a2198) or "좌표 없음"))
_a1591("")
_a1591("  ▶ 제자리에서 호출")
local _a2199, _a2200
local _a2201 = pcall(function() _a2199, _a2200 = _a1626.R_Upg:InvokeServer(_a2191.id, _a2191.zone) end)
_a1591("    호출성공 " .. tostring(_a2201) .. " / 반환1 " .. tostring(_a2199)
.. " / 반환2 " .. tostring(_a2200))
if not _a2199 and _a2191.pos then
_a1591("")
_a1591("  ▶ 기둥 앞으로 이동해서 재시도")
_a1627.move.glideTo(_a2191.pos)
task.wait(0.3)
local _a2202 = _a1627.move.hrp()
_a1591("    이동후 거리 " .. (_a2202 and ("%.0f"):format((_a2202.Position - _a2191.pos).Magnitude) or "?"))
local _a2203, _a2204
local _a2205 = pcall(function() _a2203, _a2204 = _a1626.R_Upg:InvokeServer(_a2191.id, _a2191.zone) end)
_a1591("    호출성공 " .. tostring(_a2205) .. " / 반환1 " .. tostring(_a2203)
.. " / 반환2 " .. tostring(_a2204))
_a1591("")
_a1591(_a2203 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a1591("")
_a1591(_a2199 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a1682("log")
end)
end },
{ label = "지금 1회", col = _a1640.cardHi, fn = function()
task.spawn(function() _a1597.mapupg = true _a1627.mach.cycleUpg() _a1597.mapupg = false _a1682("log") end)
end },
})
local _a2206, _a2207 = _a1715(_a1912, "자동 리버스", nil)
_a1725(_a2207, "mreb", function()
_a1639("mreb", function() return _a1595.MainRebirthInterval end, _a1637, "리버스")
end)
_a1736(_a2206, {
{ label = "주기", value = _a1595.MainRebirthInterval, onChange = function(_a2208)
local _a2209 = tonumber(_a2208) if _a2209 and _a2209 >= 10 then _a1595.MainRebirthInterval = _a2209 end
end },
})
_a1755(_a2206, "실패 이유 로그",
function() return _a1595.MainRebirthVerbose end,
function(_a2210) _a1595.MainRebirthVerbose = _a2210 end)
_a1745(_a2206, {
{ label = "리버스 현황 보기", col = _a1640.accent, fn = function()
local _a2211 = _a1636()
_a1591("")
if not _a2211 then _a1591("[리버스] 세이브 못 읽음")
else
_a1591("──── 메인 리버스 ────")
_a1591("  현재 " .. _a2211.current .. "회 → 다음 " .. _a2211.nextN)
if type(_a2211.def) == "table" then
for _a2212, _a2213 in pairs(_a2211.def) do
if type(_a2213) ~= "table" and type(_a2213) ~= "function" then
_a1591("    " .. tostring(_a2212) .. " = " .. tostring(_a2213))
end
end
end
end
_a1682("log")
end },
{ label = "지금 1회", col = _a1640.bad, fn = function()
task.spawn(function() _a1597.mreb = true _a1637() _a1597.mreb = false _a1682("log") end)
end },
})
local _a2214 = _a1715(_a1912, "전체 제어", nil)
_a1745(_a2214, {
{ label = "메인 전부 ON", col = _a1640.good, fn = function()
local _a2215 = {
{ "farm",   function() return _a1595.FarmInterval end,       _a1630,       "파밍" },
{ "zone",   function() return _a1595.ZoneInterval end,       _a1632,       "존" },
{ "mhatch", function() return _a1595.MainHatchInterval end,  _a1635,  "부화" },
{ "quest",  function() return _a1595.QuestInterval end,      _a1627.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a1595.UpgInterval end,        _a1627.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a1595.ItemInterval end,       _a1627.item.cycleItems,   "아이템" },
{ "slots",  function() return _a1595.SlotInterval end,       _a1627.mach.cycleSlots,   "슬롯" },
}
for _a2216, _a2217 in ipairs(_a2215) do
if not _a1597[_a2217[1]] then
_a1597[_a2217[1]] = true
_a1639(_a2217[1], _a2217[2], _a2217[3], _a2217[4])
end
end
_a1722()
_a1591("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a1640.bad, fn = function()
_a1627.ctl.stopAll()
_a1722()
_a1591("[메인] 정지")
end },
})
end
_a1673.MouseButton1Click:Connect(function()
local _a2218 = table.concat(_a1590, "\n")
if #_a2218 > 900000 then _a2218 = _a2218:sub(#_a2218 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a2218)
_a1673.Text = "완료"
task.delay(1.5, function() if _a1673 then _a1673.Text = "복사" end end)
end
end)
_a1672.MouseButton1Click:Connect(function()
table.clear(_a1590)
_a1586.dirty = true
end)
local function _a2219()
_a1597.place, _a1597.merchant, _a1597.upgrade = false, false, false
_a1597.towerup, _a1597.crop, _a1597.expand, _a1597.rebirth, _a1597.hatch, _a1597.luck = false, false, false, false, false, false
_a1597.farm, _a1597.zone, _a1597.mhatch, _a1597.rank, _a1597.mreb = false, false, false, false, false
if _a1776 then _a1776:Disconnect() end
if _a1658 then _a1658:Destroy() end
_G.__PS99_GARDEN = nil
end
_a1670.MouseButton1Click:Connect(_a2219)
_G.__PS99_GARDEN = _a2219
_a1682("dash")
_a1591("PS99 자동")
if _a1586.lpWait then
_a1591(("[진단] LocalPlayer 가 늦게 잡혔습니다 — %.1f초 대기, 결과 %s")
:format(_a1586.lpWait, _a1586.lpFail and "실패 (기능 대부분 못 씀)" or "성공"))
end
if _a1597.auto then
if _a1627.auto.start then
_a1591("[자동] 올 자동 켜짐 — 1초 뒤 시작합니다")
task.spawn(function()
task.wait(1)
_a1627.ctl.abort = false
local _a2220, _a2221 = pcall(_a1627.auto.start)
if _a2220 then
_a1591("[자동] 시작됨")
else
_a1597.auto = false
_a1591("[자동] 시작 실패: " .. tostring(_a2221))
if _a1627.auto.refresh then pcall(_a1627.auto.refresh) end
end
end)
else
_a1597.auto = false
_a1591("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a2222, _a2223, _a2224, _a2225 = _a1600()
if _a2222 and _a2224 then
local _a2226 = _a1601(_a2224, _a2225)
_a1598.slots = #_a2226
_a1591("레인 " .. _a2225 .. " / 슬롯 " .. #_a2226)
else
_a1591("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a1598.sun = _a1606()
_a1591("Sunflowers " .. _a1592(_a1598.sun, 0))
end)
end)(_a1)
