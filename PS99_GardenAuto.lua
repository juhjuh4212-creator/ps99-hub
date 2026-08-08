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
_a38.BuffMaxPotion = 5
_a38.BuffMaxOther  = 2
_a1.RS, _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log = _a2, _a3, _a4, _a11, _a13, _a15
_a1.num, _a1.req, _a1.LB, _a1.ff, _a1.NET, _a1.RM = _a17, _a20, _a29, _a30, _a36, _a37
_a1.CFG, _a1.VARIANT, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT = _a38, _a39, _a40, _a41, _a42
;(function(_a43)
local _a44, _a45, _a46, _a47, _a48, _a49 = _a43.RS, _a43.LP, _a43.log, _a43.num, _a43.req, _a43.LB
local _a50, _a51, _a52, _a53, _a54, _a55 = _a43.ff, _a43.RM, _a43.CFG, _a43.VARIANT, _a43.EGG_COST_CACHE, _a43.RUN
local _a56 = _a43.STAT
local _a57
local _a58 = {
"GardenMoreDamage", "GardenFasterAttacks", "GardenMoreCoins",
"GardenBetterEggs", "GardenBetterLuck", "GardenBiggerHarvest",
"GardenFasterCrops", "GardenMoreSeeds",
}
local _a59
local function _a60()
if _a59 then return _a59 end
_a59 = {}
local _a61 = _a44:FindFirstChild("__DIRECTORY")
_a61 = _a61 and _a61:FindFirstChild("TowerDefenseTowers")
if _a61 then
for _a62, _a63 in ipairs(_a61:GetDescendants()) do
if _a63:IsA("ModuleScript") then
local _a64, _a65 = pcall(require, _a63)
if _a64 and type(_a65) == "table" then _a59[rawget(_a65, "_id") or _a63.Name] = _a65 end
end
end
end
return _a59
end
local function _a66(_a67, _a68, _a69)
local _a70 = _a60()[_a67]
if type(_a70) ~= "table" then return 0 end
local _a71 = tonumber(rawget(_a70, "AttackDamage")) or 0
local _a72 = tonumber(rawget(_a70, "AttackSpeed")) or 0
local _a73, _a74 = _a71 * _a72, 0
local _a75 = rawget(_a70, "Projectile")
if type(_a75) == "table" then
local _a76 = rawget(_a75, "ApplyDots")
if type(_a76) == "table" then
for _a77, _a78 in pairs(_a76) do
if type(_a78) == "table" then
local _a79  = tonumber(rawget(_a78, "Duration")) or 0
local _a80 = tonumber(rawget(_a78, "TickDelta")) or 0
local _a81  = tonumber(rawget(_a78, "DamageMult")) or 1
local _a82   = tonumber(rawget(_a78, "Probability")) or 1
if _a80 > 0 and _a79 > 0 and _a72 > 0 then
_a74 += (_a71 * _a81 * _a82 / _a80) * math.min(1, _a79 * _a72) * _a52.DotFactor
end
end
end
end
local _a83 = tonumber(rawget(_a75, "LingerDuration")) or 0
if _a83 > 0 and _a72 > 0 then _a74 += _a73 * math.min(1, _a83 * _a72) * 0.5 * _a52.DotFactor end
end
local _a84 = (_a73 + _a74) * (_a53[_a68 or ""] or 1)
return (_a84 ~= _a84) and 0 or _a84
end
local function _a85(_a86, _a87)
if type(_a86) ~= "string" then return nil end
return string.match(_a86, '"' .. _a87 .. '"%s*:%s*"([^"]*)"')
end
local function _a88(_a89)
if type(_a89) ~= "table" and typeof(_a89) ~= "userdata" then return nil, nil end
local _a90, _a91
pcall(function() _a90 = rawget(_a89, "_stackKey") end)
pcall(function() _a91 = rawget(_a89, "_exactStackKey") end)
if not _a90 then pcall(function() _a90 = _a89._stackKey end) end
if not _a91 then pcall(function() _a91 = _a89._exactStackKey end) end
local _a92 = _a85(_a90, "id") or _a85(_a91, "id")
local _a93 = _a85(_a90, "vr") or _a85(_a91, "vr")
return _a92, _a93
end
local function _a94(_a95)
local _a96
if _a49.GardenDefenders and _a49.GardenDefenders.UnitKey then
pcall(function() _a96 = _a49.GardenDefenders.UnitKey(_a95) end)
end
if _a96 ~= nil then return tostring(_a96) end
local _a97, _a98 = _a88(_a95)
return tostring(_a97) .. "|" .. tostring(_a98 or "")
end
local function _a99()
local _a100 = {}
if not _a49.Save then return _a100 end
local _a101, _a102 = pcall(_a49.Save.Get)
if not _a101 or type(_a102) ~= "table" then return _a100 end
local _a103 = _a102.Inventory and _a102.Inventory.Tower
if type(_a103) ~= "table" then return _a100 end
for _a104, _a105 in pairs(_a103) do
if type(_a105) == "table" then _a100[_a104] = { id = _a105.id, vr = _a105.vr } end
end
return _a100
end
local function _a106()
local _a107, _a108
pcall(function()
_a107 = _a49.ClientTowerDefense and _a49.ClientTowerDefense.GetLocal and _a49.ClientTowerDefense.GetLocal()
end)
pcall(function()
_a108 = _a49.ClientPlot and _a49.ClientPlot.GetLocal and _a49.ClientPlot.GetLocal()
end)
local _a109
if _a108 then pcall(function() _a109 = _a108:GetModel() end) end
local _a110 = 0
if _a49.LaneUnlock and _a108 then
local _a111, _a112 = pcall(_a49.LaneUnlock.UnlockedFor, _a108)
if _a111 then _a110 = tonumber(_a112) or 0 end
end
return _a107, _a108, _a109, _a110
end
local function _a113(_a114, _a115)
local _a116 = {}
local _a117 = _a114 and _a114:FindFirstChild("Lanes")
if not _a117 then return _a116 end
for _a118, _a119 in ipairs(_a117:GetChildren()) do
local _a120 = tonumber(_a119.Name)
if _a120 and _a120 <= _a115 then
local _a121 = _a119:FindFirstChild("Slots")
if _a121 then
for _a122, _a123 in ipairs(_a121:GetChildren()) do
if _a123:IsA("BasePart") then
_a116[#_a116 + 1] = {
part = _a123, lane = _a120,
pos = _a123.Position + Vector3.new(0, _a123.Size.Y / 2, 0),
}
end
end
end
end
end
return _a116
end
local function _a124(_a125)
local _a126
pcall(function() _a126 = _a125:GetUpgrade() end)
if type(_a126) == "number" then return _a126 end
pcall(function()
local _a127 = rawget(_a125, "State")
local _a128 = _a127 and rawget(_a127, "Upgrade")
_a126 = _a128 and rawget(_a128, "Value")
end)
return tonumber(_a126) or 0
end
local function _a129(_a130)
local _a131
pcall(function() _a131 = _a130:GetId() end)
if type(_a131) == "number" then return _a131 end
pcall(function() _a131 = rawget(_a130, "Id") end)
return tonumber(_a131)
end
local function _a132(_a133)
local _a134 = {}
if not (_a133 and _a49.ClientTower) then return _a134 end
local _a135
pcall(function() _a135 = _a49.ClientTower.All(_a133) end)
if type(_a135) ~= "table" then return _a134 end
local _a136 = _a99()
for _a137, _a138 in ipairs(_a135) do
local _a139, _a140, _a141
pcall(function() _a139 = _a138:GetItem() end)
pcall(function() _a140 = _a138:GetCFrame() end)
if _a139 then pcall(function() _a141 = _a139:GetOptionalUID() end) end
local _a142, _a143 = _a88(_a139)
if not _a142 then
local _a144 = _a136[_a141 or ""] or {}
_a142, _a143 = _a144.id, _a144.vr
end
local _a145 = _a124(_a138)
_a134[#_a134 + 1] = {
tower = _a138, item = _a139, uid = _a141, cf = _a140,
id = _a129(_a138), kind = _a142, vr = _a143, up = _a145,
dps = _a66(_a142, _a143, _a145),
}
end
return _a134
end
local function _a146()
local _a147 = {}
if not (_a49.TowerItem and _a49.EntityPlacement) then return _a147 end
local _a148
if not pcall(function() _a148 = _a49.TowerItem:All() end) or type(_a148) ~= "table" then return _a147 end
local _a149 = _a99()
local _a150 = {}
for _a151, _a152 in pairs(_a148) do
local _a153
pcall(function() _a153 = _a152:GetOptionalUID() end)
if _a153 then
local _a154 = _a94(_a152)
if not _a150[_a154] then
local _a155 = 0
pcall(function() _a155 = _a49.EntityPlacement.AvailableCopies(_a152) or 0 end)
if _a155 > 0 then
local _a156, _a157 = _a88(_a152)
if not _a156 then
local _a158 = _a149[_a153] or {}
_a156, _a157 = _a158.id, _a158.vr
end
_a150[_a154] = {
item = _a152, uid = _a153, key = _a154, id = _a156, vr = _a157,
copies = _a155, dps = _a66(_a156, _a157, 0),
}
else
_a150[_a154] = false
end
end
end
end
for _a159, _a160 in pairs(_a150) do
if _a160 then _a147[#_a147 + 1] = _a160 end
end
table.sort(_a147, function(_a161, _a162)
if (_a161.dps or 0) == (_a162.dps or 0) then return tostring(_a161.key) < tostring(_a162.key) end
return (_a161.dps or 0) > (_a162.dps or 0)
end)
return _a147
end
local function _a163(_a164)
local _a165
pcall(function() _a165 = _a49.GardenLaneFacing.ForSlot(_a164.pos, _a164.part) end)
return _a165
end
local function _a166(_a167, _a168)
local _a169 = _a163(_a167)
if not _a169 then return false end
local _a170 = false
pcall(function() _a170 = _a49.EntityPlacement.Validate(_a168, _a169) end)
return _a170 and true or false, _a169
end
local function _a171(_a172, _a173, _a174)
local _a175 = _a163(_a173)
if not _a175 then return false, "facing 실패" end
local _a176, _a177 = _a172.item, _a172.uid
if _a49.EntityPlacement and type(rawget(_a49.EntityPlacement, "FirstFreeCopy")) == "function" then
local _a178, _a179 = pcall(_a49.EntityPlacement.FirstFreeCopy, _a172.item)
if _a178 and _a179 then
_a176 = _a179
pcall(function() _a177 = _a179:GetUID() end)
end
end
if not _a177 then return false, "쓸 수 있는 스택 없음" end
local _a180 = _a174.CFrame:ToObjectSpace(_a175)
local _a181, _a182, _a183
if not pcall(function() _a181, _a182, _a183 = _a51.R_ATTACH:InvokeServer(_a177, _a180) end) then
return false, "호출 실패"
end
return _a181 and true or false, _a182, _a183
end
local function _a184(_a185)
if not (_a51.R_DETACH and _a185) then return false end
local _a186
pcall(function() _a186 = _a51.R_DETACH:InvokeServer(_a185) end)
return _a186 and true or false
end
local function _a187()
local _a188, _a189, _a190, _a191 = _a106()
if not (_a188 and _a190) then
_a46("[배치] 밭/월드 준비 안 됨 — Garden 안에 있는지 확인")
return
end
local _a192 = _a113(_a190, _a191)
_a56.slots = #_a192
if #_a192 == 0 then _a46("[배치] 슬롯 없음 (잠금해제 레인 " .. _a191 .. ")") return end
local _a193 = _a132(_a188)
local _a194 = _a146()
if #_a194 == 0 then
_a46("[배치] 배치 가능한 타워 없음 (종류별 최대치 도달)")
end
local _a195 = _a193
local _a196, _a197, _a198, _a199 = 0, 0, 0, 0
local _a200 = {}
local _a201 = {}
local function _a202(_a203)
return tostring(_a203 and _a203.key or (tostring(_a203 and _a203.id) .. "|" .. tostring(_a203 and _a203.vr or "")))
end
for _a204 = #_a194, 1, -1 do
if _a201[_a202(_a194[_a204])] then table.remove(_a194, _a204) end
end
local function _a205(_a206)
for _a207, _a208 in ipairs(_a195) do
if _a208.cf then
local _a209 = Vector2.new(_a208.cf.X - _a206.pos.X, _a208.cf.Z - _a206.pos.Z).Magnitude
if _a209 < 2 then return _a208 end
end
end
return nil
end
for _a210, _a211 in ipairs(_a192) do
if not _a55.place then break end
local _a212 = _a205(_a211)
if _a212 then _a196 += 1 else _a197 += 1 end
local _a213 = _a194[1]
if not _a213 then break end
if not _a212 then
local _a214, _a215, _a216 = _a171(_a213, _a211, _a188)
if _a214 then
_a198 += 1
_a56.placed += 1
_a46(("  ▸ 배치  레인%s  %s %s  DPS %s"):format(
_a211.lane, tostring(_a213.id), tostring(_a213.vr or "-"), _a47(_a213.dps)))
_a195 = _a132(_a188)
_a194 = _a146()
for _a217 = #_a194, 1, -1 do
if _a201[_a202(_a194[_a217])] then table.remove(_a194, _a217) end
end
else
_a200[tostring(_a215)] = (_a200[tostring(_a215)] or 0) + 1
if tostring(_a215):find("copies") then _a201[_a202(_a213)] = true end
table.remove(_a194, 1)
end
task.wait(_a52.ActionGap)
elseif (_a213.dps or 0) > (_a212.dps or 0) * _a52.SwapMargin then
if _a52.ProtectUpgraded and (_a212.up or 0) > 0 then
else
if _a184(_a212.id) then
task.wait(0.5)
local _a218 = _a146()
local _a219, _a220 = false, nil
for _a221 = 1, math.min(10, #_a218) do
local _a222 = _a218[_a221]
if not _a201[_a202(_a222)] then
local _a223, _a224 = _a171(_a222, _a211, _a188)
if _a223 then
_a219, _a220 = true, _a222
break
end
_a200[tostring(_a224)] = (_a200[tostring(_a224)] or 0) + 1
if tostring(_a224):find("copies") then _a201[_a202(_a222)] = true end
task.wait(0.15)
end
end
if _a219 and _a220 then
if _a220.id == _a212.kind and (_a220.vr or "") == (_a212.vr or "") then
_a46("  · 레인" .. _a211.lane .. " 같은 종류로 되돌림 (더 나은 게 없음)")
else
_a199 += 1
_a56.swapped += 1
_a46(("  ⇄ 교체  레인%s   %s%s(Lv%s) DPS %s  →  %s %s DPS %s"):format(
_a211.lane,
tostring(_a212.kind), _a212.vr and (" " .. _a212.vr) or "",
tostring(_a212.up), _a47(_a212.dps),
tostring(_a220.id), tostring(_a220.vr or "-"), _a47(_a220.dps)))
end
else
_a46("  ! 레인" .. _a211.lane .. " 아무것도 못 놓음 — 칸이 비었습니다")
end
_a195 = _a132(_a188)
_a194 = _a146()
for _a225 = #_a194, 1, -1 do
if _a201[_a202(_a194[_a225])] then table.remove(_a194, _a225) end
end
task.wait(_a52.ActionGap)
end
end
end
end
_a56.filled, _a56.empty = _a196, _a197
local _a226 = ("[배치] 슬롯 %d (찬칸 %d / 빈칸 %d)  이번에 배치 %d, 교체 %d")
:format(#_a192, _a196, _a197, _a198, _a199)
_a46(_a226)
if next(_a200) then
for _a227, _a228 in pairs(_a200) do _a46("    실패 " .. _a228 .. "회: " .. _a227) end
end
end
local function _a229()
if not _a51.R_BUY then _a46("[구매] 리모트 없음") return end
local _a230, _a231 = 0, 0
for _a232 = 1, _a52.MerchantSlots do
if not _a55.merchant then break end
local _a233
pcall(function() _a233 = _a51.R_BUY:InvokeServer(_a52.MerchantId, _a232) end)
if _a233 ~= nil and _a233 ~= false then _a230 += 1 else _a231 += 1 end
task.wait(0.3)
end
_a56.bought += _a230
_a46(("[구매] %s  성공 %d / 실패 %d"):format(_a52.MerchantId, _a230, _a231))
end
local function _a234()
if not _a49.Save then return 0 end
local _a235, _a236 = pcall(_a49.Save.Get)
if not _a235 or type(_a236) ~= "table" then return 0 end
local _a237 = _a236.Inventory and _a236.Inventory.Currency
if type(_a237) ~= "table" then return 0 end
for _a238, _a239 in pairs(_a237) do
if type(_a239) == "table" and rawget(_a239, "id") == "Sunflowers" then
return tonumber(rawget(_a239, "_am")) or 0
end
end
return 0
end
local function _a240()
local _a241 = {}
if not _a49.Save then return _a241 end
local _a242, _a243 = pcall(_a49.Save.Get)
if not _a242 or type(_a243) ~= "table" then return _a241 end
local _a244 = rawget(_a243, "EventUpgrades")
if type(_a244) == "table" then
for _a245, _a246 in pairs(_a244) do _a241[_a245] = tonumber(_a246) or 0 end
end
return _a241
end
local _a247
local function _a248()
if _a247 then return _a247 end
_a247 = {}
local _a249 = _a44:FindFirstChild("__DIRECTORY")
_a249 = _a249 and _a249:FindFirstChild("EventUpgrades")
if _a249 then
for _a250, _a251 in ipairs(_a249:GetDescendants()) do
if _a251:IsA("ModuleScript") then
local _a252, _a253 = pcall(require, _a251)
if _a252 and type(_a253) == "table" then
_a247[rawget(_a253, "_id") or _a251.Name] = _a253
end
end
end
end
return _a247
end
local _a254, _a255
local function _a256()
if _a254 ~= nil then return _a254 end
_a254 = false
local _a257 = {
_a48("Library", "Util", "GardenUpgradeCurve"),
_a48("Library", "Util", "GardenUpgradeBoosts"),
_a49.EventUpgradeCmds,
}
for _a258, _a259 in ipairs(_a257) do
if type(_a259) == "table" then
for _a260, _a261 in pairs(_a259) do
local _a262 = tostring(_a260):lower()
if type(_a261) == "function" and (_a262:find("cost") or _a262:find("price")) then
for _a263, _a264 in ipairs({
{ "GardenMoreDamage", 1 }, { "GardenMoreDamage", 2 },
{ 1 }, { 2 }, { "GardenMoreDamage" },
}) do
local _a265, _a266 = pcall(_a261, table.unpack(_a264))
if _a265 and type(_a266) == "number" and _a266 > 0 then
_a254 = _a261
_a255 = (#_a264 == 2) and "id_tier" or
(type(_a264[1]) == "number" and "tier" or "id")
return _a254
end
end
end
end
end
end
return _a254
end
local function _a267(_a268)
if _a268 == nil then return nil end
if type(_a268) == "number" then return _a268 end
if type(_a268) == "table" then
local _a269 = rawget(_a268, "_data")
if type(_a269) == "table" then
return tonumber(rawget(_a269, "_am")) or 1
end
end
local _a270, _a271 = pcall(function() return _a268:GetAmount() end)
if _a270 and type(_a271) == "number" then return _a271 end
return nil
end
local function _a272(_a273, _a274)
local _a275 = _a248()[_a273]
if type(_a275) == "table" then
for _a276, _a277 in ipairs({ "TierCosts", "Costs", "Prices", "TierPrices" }) do
local _a278 = rawget(_a275, _a277)
if type(_a278) == "table" then
local _a279 = _a267(_a278[(tonumber(_a274) or 0) + 1])
if _a279 then return _a279 end
end
end
end
local _a280 = _a256()
if _a280 then
local _a281 = (tonumber(_a274) or 0) + 1
local _a282
if _a255 == "id_tier" then _a282 = { { _a273, _a281 }, { _a273, _a274 } }
elseif _a255 == "tier" then _a282 = { { _a281 }, { _a274 } }
else _a282 = { { _a273 } } end
for _a283, _a284 in ipairs(_a282) do
local _a285, _a286 = pcall(_a280, table.unpack(_a284))
if _a285 and type(_a286) == "number" and _a286 > 0 then return _a286 end
end
end
return nil
end
local function _a287(_a288)
if _a49.EventUpgradeCmds and type(rawget(_a49.EventUpgradeCmds, "Purchase")) == "function" then
local _a289, _a290 = pcall(_a49.EventUpgradeCmds.Purchase, _a288)
if _a289 and _a290 ~= nil and _a290 ~= false then return true, _a290 end
if _a289 then return false, _a290 end
end
if _a51.R_EVUP then
local _a291
local _a292 = pcall(function() _a291 = _a51.R_EVUP:InvokeServer(_a288) end)
if _a292 then return (_a291 ~= nil and _a291 ~= false), _a291 end
end
return false, "호출 실패"
end
local function _a293()
if not (_a51.R_EVUP or _a49.EventUpgradeCmds) then _a46("[머신업글] API 없음") return end
local _a294, _a295 = 0, 0
while _a55.upgrade and _a294 < 40 do
_a294 += 1
local _a296 = _a234()
_a56.sun = _a296
local _a297 = _a240()
local _a298 = {}
for _a299, _a300 in ipairs(_a58) do
local _a301 = _a297[_a300] or 0
local _a302 = _a272(_a300, _a301)
_a298[#_a298 + 1] = { id = _a300, tier = _a301, cost = _a302 }
end
table.sort(_a298, function(_a303, _a304)
local _a305 = _a303.cost or math.huge
local _a306 = _a304.cost or math.huge
if _a305 == _a306 then return _a303.id < _a304.id end
return _a305 < _a306
end)
local _a307 = false
for _a308, _a309 in ipairs(_a298) do
if not _a55.upgrade then break end
local _a310 = _a309.cost and (_a296 - _a309.cost >= _a52.MinSunflowers)
if _a309.cost == nil then _a310 = _a52.BuyUnknownCost end
if _a310 then
local _a311 = _a296
local _a312, _a313 = _a287(_a309.id)
if _a312 then
_a295 += 1
_a56.upgraded += 1
_a307 = true
task.wait(0.4)
local _a314 = _a234()
_a46(("  ▲ %s  Lv%s → Lv%s   비용 %s   잔액 %s"):format(
_a309.id, tostring(_a309.tier), tostring(_a309.tier + 1),
_a47(_a311 - _a314, 0), _a47(_a314, 0)))
break
end
end
end
if not _a307 then break end
end
local _a315 = _a234()
_a56.sun = _a315
local _a316 = _a240()
if _a295 > 0 then
_a46(("[머신업글] %d건 구매 / 잔액 %s"):format(_a295, _a47(_a315, 0)))
else
local _a317, _a318 = math.huge, nil
for _a319, _a320 in ipairs(_a58) do
local _a321 = _a272(_a320, _a316[_a320] or 0)
if _a321 and _a321 < _a317 then _a317, _a318 = _a321, _a320 end
end
if _a318 then
_a46(("[머신업글] 살 수 있는 게 없음 — 잔액 %s / 최저 %s (%s)")
:format(_a47(_a315, 0), _a47(_a317, 0), _a318))
else
_a46("[머신업글] 구매 실패 (비용표를 못 읽음)")
end
end
end
local _a322, _a323
local function _a324()
if _a322 then return _a322 end
_a322 = {}
local _a325 = _a44:FindFirstChild("__DIRECTORY")
_a325 = _a325 and _a325:FindFirstChild("CropSeeds")
if _a325 then
for _a326, _a327 in ipairs(_a325:GetDescendants()) do
if _a327:IsA("ModuleScript") then
local _a328, _a329 = pcall(require, _a327)
if _a328 and type(_a329) == "table" then _a322[rawget(_a329, "_id") or _a327.Name] = _a329 end
end
end
end
return _a322
end
local function _a330()
if _a323 then return _a323 end
_a323 = {}
local _a331 = _a44:FindFirstChild("__DIRECTORY")
_a331 = _a331 and _a331:FindFirstChild("GardenCrops")
if _a331 then
for _a332, _a333 in ipairs(_a331:GetDescendants()) do
if _a333:IsA("ModuleScript") then
local _a334, _a335 = pcall(require, _a333)
if _a334 and type(_a335) == "table" then _a323[rawget(_a335, "_id") or _a333.Name] = _a335 end
end
end
end
return _a323
end
local function _a336(_a337)
local _a338 = _a330()[_a337]
return _a338 and tonumber(rawget(_a338, "CoinsPerSec")) or 0
end
local _a339 = {}
local function _a340(_a341)
if _a339[_a341] then return _a339[_a341] end
local _a342 = _a324()[_a341]
local _a343 = _a342 and rawget(_a342, "SpeciesWeights")
local _a344, _a345 = 0, 0
if type(_a343) == "table" then
for _a346, _a347 in pairs(_a343) do
local _a348 = tonumber(_a347) or 0
_a344 += _a348
_a345 += _a348 * _a336(_a346)
end
end
local _a349 = (_a344 > 0) and (_a345 / _a344) or 0
_a339[_a341] = _a349
return _a349
end
local function _a350()
local _a351 = {}
if not _a49.Save then return _a351 end
local _a352, _a353 = pcall(_a49.Save.Get)
if not _a352 or type(_a353) ~= "table" then return _a351 end
local _a354 = _a353.Inventory and _a353.Inventory.CropSeed
if type(_a354) ~= "table" then return _a351 end
for _a355, _a356 in pairs(_a354) do
if type(_a356) == "table" then
local _a357 = tonumber(rawget(_a356, "_am")) or 1
if _a357 > 0 then
_a351[#_a351 + 1] = {
uid = _a355, id = rawget(_a356, "id"), vr = rawget(_a356, "vr"),
am = _a357, exp = _a340(rawget(_a356, "id")),
}
end
end
end
table.sort(_a351, function(_a358, _a359)
if (_a358.exp or 0) == (_a359.exp or 0) then return (_a358.am or 0) > (_a359.am or 0) end
return (_a358.exp or 0) > (_a359.exp or 0)
end)
return _a351
end
local function _a360(_a361)
if not _a361 then return {} end
local _a362
pcall(function() _a362 = _a361:Save("PvC_Beds") end)
return type(_a362) == "table" and _a362 or {}
end
local function _a363(_a364, _a365)
if not (_a49.GardenPlots and _a364) then return true end
local _a366, _a367 = pcall(_a49.GardenPlots.IsBedUnlocked, _a364, _a365)
if _a366 then return _a367 and true or false end
return true
end
local function _a368(_a369)
if not (_a49.PvCropGrowth and type(_a369) == "table") then return false end
local _a370, _a371 = pcall(_a49.PvCropGrowth.IsUnhatched, _a369)
return _a370 and _a371 and true or false
end
local function _a372(_a373)
if type(_a373) ~= "table" then return nil end
local _a374 = tonumber(rawget(_a373, "cps"))
if _a374 then return _a374 end
local _a375 = rawget(_a373, "sp")
if _a375 then return _a336(_a375) end
return nil
end
local function _a376()
local _a377, _a378 = _a106()
if not _a378 then _a46("[씨앗] 밭 없음") return end
local _a379 = _a360(_a378)
local _a380 = _a350()
if #_a380 == 0 then _a46("[씨앗] 인벤에 씨앗 없음") return end
local _a381, _a382 = {}, {}
for _a383 in pairs(_a379) do
if not _a382[tostring(_a383)] then _a382[tostring(_a383)] = true _a381[#_a381 + 1] = _a383 end
end
for _a384 = 1, 80 do
local _a385 = tostring(_a384)
if not _a382[_a385] and _a363(_a378, _a385) then _a382[_a385] = true _a381[#_a381 + 1] = _a385 end
end
local _a386, _a387, _a388, _a389 = 0, 0, 0, 0
local _a390 = 1
for _a391, _a392 in ipairs(_a381) do
if not _a55.crop then break end
local _a393 = _a380[_a390]
while _a393 and _a393.am <= 0 do
_a390 += 1
_a393 = _a380[_a390]
end
if not _a393 then break end
local _a394 = _a379[_a392]
local _a395 = _a372(_a394)
if _a394 == nil then
local _a396
pcall(function() _a396 = _a378:Invoke("SD_Insert", _a392, _a393.uid) end)
if _a396 ~= false then
_a387 += 1
_a56.replant += 1
_a393.am -= 1
_a46(("  ▸ 심기  칸%s  %s 씨앗 (기대 %s/s)"):format(tostring(_a392), tostring(_a393.id), _a47(_a393.exp)))
task.wait(_a52.ActionGap)
end
elseif _a52.SkipUnhatched and _a368(_a394) then
_a389 += 1
elseif _a395 and (_a393.exp or 0) > _a395 * _a52.CropMargin then
local _a397
pcall(function() _a397 = _a378:Invoke("SD_Purge", _a392) end)
if _a397 ~= false then
task.wait(0.4)
local _a398
pcall(function() _a398 = _a378:Invoke("SD_Insert", _a392, _a393.uid) end)
if _a398 ~= false then
_a386 += 1
_a56.replant += 1
_a393.am -= 1
_a46(("  ⇄ 갈아엎기  칸%s  %s(%s/s) → %s 씨앗(기대 %s/s)"):format(
tostring(_a392), tostring(rawget(_a394, "sp") or "?"), _a47(_a395),
tostring(_a393.id), _a47(_a393.exp)))
else
_a46("  ! 칸" .. tostring(_a392) .. " 파냈는데 심기 실패")
end
task.wait(_a52.ActionGap)
end
else
_a388 += 1
end
end
_a46(("[씨앗] 심기 %d / 갈아엎기 %d / 유지 %d / 성장중 %d")
:format(_a387, _a386, _a388, _a389))
end
local function _a399(_a400)
if _a57 and not _a400 then return _a57 end
if _a51.R_JC then
local _a401, _a402 = pcall(function() return _a51.R_JC:InvokeServer() end)
if _a401 and type(_a402) == "table" then _a57 = _a402 end
end
return _a57 or {}
end
local function _a403(_a404)
if not (_a49.GardenPlots and rawget(_a49.GardenPlots, "PlotCost")) then return nil end
local _a405, _a406 = pcall(_a49.GardenPlots.PlotCost, tonumber(_a404))
return (_a405 and type(_a406) == "number") and _a406 or nil
end
local function _a407(_a408)
local _a409 = {}
if not _a408 then return _a409 end
for _a410 = 1, _a52.MaxBedScan do
local _a411 = tostring(_a410)
if not _a363(_a408, _a411) then
_a409[#_a409 + 1] = { id = _a411, n = _a410, cost = _a403(_a410) }
end
end
table.sort(_a409, function(_a412, _a413)
return (_a412.cost or math.huge) < (_a413.cost or math.huge)
end)
return _a409
end
local function _a414()
local _a415, _a416, _a417, _a418 = _a106()
if not _a416 then _a46("[확장] 밭 없음") return end
local _a419, _a420 = 0, 0
local _a421 = _a234()
local _a422 = _a399(true)
local _a423 = 0
while _a55.expand and _a423 < 12 do
_a423 += 1
local _a424 = (tonumber(_a418) or 0) + 1
local _a425 = tonumber(_a422[_a424]) or tonumber(_a422[tostring(_a424)])
if _a425 and (_a421 - _a425) < _a52.MinSunflowers then
_a46(("[확장] 레인%d 비용 %s / 잔액 %s — 부족"):format(_a424, _a47(_a425, 0), _a47(_a421, 0)))
break
end
if not _a425 and not _a52.BuyUnknownCost then
_a46("[확장] 레인" .. _a424 .. " 비용을 못 읽음 — 건너뜀")
break
end
if not _a51.R_WIDEN then break end
local _a426 = _a421
local _a427, _a428, _a429
pcall(function() _a427, _a428, _a429 = _a51.R_WIDEN:InvokeServer() end)
task.wait(0.5)
_a421 = _a234()
if _a427 then
_a419 += 1
_a420 += (_a426 - _a421)
_a418 = tonumber(_a429) or (_a418 + 1)
_a46(("  ▣ 레인 오픈 → %s개   비용 %s   잔액 %s"):format(
tostring(_a418), _a47(_a426 - _a421, 0), _a47(_a421, 0)))
task.wait(_a52.ActionGap)
else
if _a428 then _a46("[확장] 레인 실패: " .. tostring(_a428)) end
break
end
end
local _a430 = _a407(_a416)
for _a431, _a432 in ipairs(_a430) do
if not _a55.expand then break end
if _a432.cost and (_a421 - _a432.cost) < _a52.MinSunflowers then break end
if not _a432.cost and not _a52.BuyUnknownCost then break end
local _a433 = _a421
local _a434
pcall(function() _a434 = _a416:Invoke("BD_Acquire", _a432.id) end)
task.wait(0.4)
_a421 = _a234()
if _a434 ~= false and _a421 < _a433 then
_a419 += 1
_a420 += (_a433 - _a421)
_a46(("  ▣ 밭칸 %s 오픈   비용 %s   잔액 %s"):format(
_a432.id, _a47(_a433 - _a421, 0), _a47(_a421, 0)))
task.wait(_a52.ActionGap)
else
break
end
end
_a56.sun = _a421
if _a419 > 0 then
_a46(("[확장] %d개 오픈 / 총 %s 소비"):format(_a419, _a47(_a420, 0)))
else
local _a435 = (tonumber(_a418) or 0) + 1
local _a436 = _a422[_a435] or _a422[tostring(_a435)]
local _a437 = _a430[1]
_a46(("[확장] 오픈할 것 없음 — 잔액 %s / 다음 레인%d %s / 다음 밭칸 %s"):format(
_a47(_a421, 0), _a435, _a436 and _a47(_a436, 0) or "?",
_a437 and (_a437.id .. " " .. (_a437.cost and _a47(_a437.cost, 0) or "?")) or "없음"))
end
end
local function _a438()
local _a439, _a440 = _a106()
if not _a440 then return nil end
local function _a441(_a442)
local _a443
pcall(function() _a443 = _a440:Save(_a442) end)
return _a443
end
local _a444 = tonumber(_a441("PvC_Regrows")) or 0
local _a445   = tonumber(_a441("PvC_UnlockedLanes")) or 1
local _a446   = tonumber(_a441("PvC_RunBossKills")) or 0
local _a447     = _a50("PvC_RegrowCap") or math.huge
local _a448    = _a50("PvC_RegrowBossBase") or 1
local _a449    = _a50("PvC_RegrowBossStep") or 1
local _a450  = math.min(_a444, _a447)
local _a451    = math.ceil(_a448 * (_a449 ^ _a450))
local _a452   = (_a447 <= _a450)
return {
regrows = _a444, lanes = _a445, kills = _a446, need = _a451,
cap = _a447, maxed = _a452,
ready = (not _a452) and _a445 >= 7 and _a446 >= _a451,
reason = _a452 and "최대 리버스 도달"
or (_a445 < 7 and ("레인 %d/7"):format(_a445))
or (_a446 < _a451 and ("코인보스 %d/%d"):format(_a446, _a451))
or nil,
}
end
local function _a453()
if not _a51.R_WK then _a46("[리버스] WK_Reclaim 리모트 없음") return end
local _a454 = _a438()
if not _a454 then _a46("[리버스] 밭 없음") return end
if not _a454.ready then
_a46(("[리버스] 대기 — %s   (리버스 %d회)"):format(tostring(_a454.reason), _a454.regrows))
return
end
_a46(("[리버스] 조건 충족 (레인 %d, 보스 %d/%d) — 실행"):format(_a454.lanes, _a454.kills, _a454.need))
local _a455, _a456, _a457
pcall(function() _a455, _a456, _a457 = _a51.R_WK:InvokeServer() end)
task.wait(1.5)
if _a455 then
_a56.sun = _a234()
_a57 = nil
_a46(("  ★ 리버스 성공 → %s회   (레인/밭칸/작물 초기화됨)"):format(tostring(_a457 or (_a454.regrows + 1))))
_a46("  자동 확장이 켜져 있으면 레인/밭칸을 다시 엽니다")
else
_a46("  ✗ 리버스 실패: " .. tostring(_a456))
end
end
local _a458 = _a48("Library", "Util", "GardenEggs")
local _a459    = _a48("Library", "Directory", "Eggs")
local _a460= _a48("Library", "Balancing", "CalcEggPricePlayer")
local _a461  = _a48("Library", "Balancing", "CalcEggPrice")
local function _a462()
if _a52.HatchEggNum and _a52.HatchEggNum >= 1 then
return math.floor(_a52.HatchEggNum)
end
local _a463, _a464 = _a106()
if _a458 and rawget(_a458, "CurrentEggNum") then
local _a465, _a466 = pcall(_a458.CurrentEggNum, _a464)
if _a465 and tonumber(_a466) then return math.floor(tonumber(_a466)) end
end
if _a49.EventUpgradeCmds and rawget(_a49.EventUpgradeCmds, "GetPower") then
local _a467, _a468 = pcall(_a49.EventUpgradeCmds.GetPower, "GardenBetterEggs")
if _a467 and tonumber(_a468) then return math.clamp(1 + math.floor(tonumber(_a468)), 1, 12) end
end
return 1
end
local function _a469(_a470)
return ("Garden Egg %d"):format(_a470 or _a462())
end
local function _a471(_a472)
if type(_a459) == "table" then
local _a473 = rawget(_a459, _a472)
if _a473 then return _a473 end
end
local _a474 = _a44:FindFirstChild("__DIRECTORY")
_a474 = _a474 and _a474:FindFirstChild("Eggs")
if _a474 then
for _a475, _a476 in ipairs(_a474:GetDescendants()) do
if _a476:IsA("ModuleScript") then
local _a477, _a478 = pcall(require, _a476)
if _a477 and type(_a478) == "table" and rawget(_a478, "_id") == _a472 then return _a478 end
end
end
end
return nil
end
table.clear(_a54)
local function _a479(_a480)
if _a54[_a480] then return _a54[_a480] end
local _a481 = _a471(_a480)
if not _a481 then return nil end
for _a482, _a483 in ipairs({ _a460, _a461 }) do
if type(_a483) == "function" then
local _a484, _a485 = pcall(_a483, _a481)
if _a484 and tonumber(_a485) and tonumber(_a485) > 0 then
_a54[_a480] = tonumber(_a485)
return _a54[_a480]
end
end
end
local _a486 = tonumber(rawget(_a481, "overrideCost"))
if _a486 then
local _a487 = _a50("PvC_EggCostMult")
if not _a487 or _a487 <= 0 then _a487 = 1 end
local _a488 = math.max(1, math.round(_a486 * _a487))
_a54[_a480] = _a488
return _a488
end
return nil
end
local _a489 = _a48("Library", "Client", "CustomEggsCmds")
local function _a490()
local _a491 = {}
local _a492 = workspace:FindFirstChild("__THINGS")
_a492 = _a492 and _a492:FindFirstChild("CustomEggs")
if not _a492 then return _a491 end
local _a493 = _a45.Character and _a45.Character:FindFirstChild("HumanoidRootPart")
for _a494, _a495 in ipairs(_a492:GetChildren()) do
local _a496
pcall(function()
if _a495:IsA("Model") then _a496 = _a495:GetPivot().Position
elseif _a495:IsA("BasePart") then _a496 = _a495.Position end
end)
_a491[#_a491 + 1] = {
uid = _a495.Name, inst = _a495,
dist = (_a496 and _a493) and (_a496 - _a493.Position).Magnitude or math.huge,
}
end
table.sort(_a491, function(_a497, _a498) return _a497.dist < _a498.dist end)
return _a491
end
local function _a499()
if _a52.HatchUid and _a52.HatchUid ~= "" then return _a52.HatchUid end
local _a500 = _a490()
return _a500[1] and _a500[1].uid or nil
end
local function _a501()
if type(_a489) == "table" then
local _a502 = rawget(_a489, "GetMaxEggCount")
if type(_a502) == "function" then
local _a503, _a504 = pcall(_a502)
if _a503 and tonumber(_a504) and tonumber(_a504) >= 1 then return math.floor(tonumber(_a504)) end
end
end
return _a52.HatchMax
end
local function _a505()
local _a506 = _a462()
local _a507 = _a469(_a506)
local _a508 = _a479(_a507)
local _a509 = _a234()
local _a510 = math.max(0, _a509 - (_a52.HatchReserve or 0))
local _a511 = _a490()
return {
num = _a506, id = _a507, cost = _a508, sun = _a509,
uid = _a499(), eggCount = #_a511, eggs = _a511,
canBuy = (_a508 and _a508 > 0) and math.floor(_a510 / _a508) or 0,
}
end
local function _a512()
if not _a51.R_CEGG then _a46("[뽑기] CustomEggs_Hatch 리모트 없음") return end
local _a513 = _a505()
_a56.sun = _a513.sun
if not _a513.uid then
_a46("[뽑기] 알을 못 찾음 — 알 근처로 가주세요 (workspace.__THINGS.CustomEggs 비어있음)")
return
end
if not _a513.cost then
_a46("[뽑기] " .. _a513.id .. " 비용을 못 읽음")
return
end
if _a513.canBuy < 1 then
return
end
local _a514 = math.min(_a52.HatchMax, _a501())
local _a515, _a516 = 0, 0
local _a517 = math.min(_a513.canBuy, _a514)
while _a55.hatch and _a517 >= 1 and _a516 < 20 do
_a516 += 1
local _a518, _a519
pcall(function() _a518, _a519 = _a51.R_CEGG:InvokeServer(_a513.uid, _a517) end)
if _a518 then
_a515 += _a517
_a56.hatched += _a517
task.wait(0.4)
local _a520 = _a234()
_a56.sun = _a520
local _a521 = math.max(0, _a520 - (_a52.HatchReserve or 0))
local _a522 = math.floor(_a521 / _a513.cost)
if _a522 < 1 then break end
_a517 = math.min(_a522, _a514)
else
local _a523 = tostring(_a519)
if _a523:find("quickly") then
task.wait(2.5)
elseif _a517 > 1 then
_a517 = math.floor(_a517 / 2)
else
if _a519 then _a46("[뽑기] 실패: " .. _a523) end
break
end
end
end
if _a515 > 0 then
_a46(("[뽑기] %s × %d   (개당 %s)   잔액 %s"):format(
_a513.id, _a515, _a47(_a513.cost, 0), _a47(_a234(), 0)))
end
end
local _a524 = _a48("Library", "Client", "GardenChanceMachineCmds")
local _a525 = _a48("Library", "Types", "GardenChanceMachine")
local _a526 = { "Huge", "Titanic", "Gargantuan" }
local function _a527()
if _a524 and rawget(_a524, "GetMaxBoostSeconds") then
local _a528, _a529 = pcall(_a524.GetMaxBoostSeconds)
if _a528 and tonumber(_a529) then return tonumber(_a529) end
end
return (_a525 and tonumber(rawget(_a525, "MaxSecondsDefault"))) or 21600
end
local function _a530(_a531)
if _a524 and rawget(_a524, "GetPerTokenSecondsForBoost") then
local _a532, _a533 = pcall(_a524.GetPerTokenSecondsForBoost, _a531)
if _a532 and tonumber(_a533) and tonumber(_a533) > 0 then return tonumber(_a533) end
end
local _a534 = (_a525 and _a525.TokensToMaxDefault
and tonumber(_a525.TokensToMaxDefault[_a531])) or 5000
return _a527() / _a534
end
local function _a535(_a536)
if _a524 and rawget(_a524, "GetBoostTime") then
local _a537, _a538 = pcall(_a524.GetBoostTime, _a536)
if _a537 and tonumber(_a538) then return tonumber(_a538) end
end
return 0
end
local function _a539()
if _a524 and rawget(_a524, "IsEnabled") then
local _a540, _a541 = pcall(_a524.IsEnabled)
if _a540 then return _a541 and true or false end
end
return true
end
local function _a542()
local _a543 = _a527()
local _a544 = {}
for _a545, _a546 in ipairs(_a526) do
local _a547 = _a535(_a546)
local _a548 = _a530(_a546)
local _a549 = math.max(0, _a543 - _a547)
_a544[#_a544 + 1] = {
rarity = _a546, left = _a547, per = _a548, deficit = _a549,
need = (_a548 > 0) and math.ceil(_a549 / _a548) or 0,
on = _a52.LuckBoosts[_a546] and true or false,
}
end
return { maxSec = _a543, rows = _a544, enabled = _a539(), sun = _a234() }
end
local function _a550(_a551)
_a551 = math.max(0, math.floor(tonumber(_a551) or 0))
local _a552 = math.floor(_a551 / 3600)
local _a553 = math.floor((_a551 % 3600) / 60)
return ("%d시간 %d분"):format(_a552, _a553)
end
local function _a554()
if not _a51.R_LUCK then _a46("[럭] GardenChanceMachine_AddTime 리모트 없음") return end
if not _a539() then _a46("[럭] 이 서버에서 비활성") return end
local _a555 = _a542()
_a56.sun = _a555.sun
local _a556 = _a555.sun
local _a557 = 0
for _a558, _a559 in ipairs(_a555.rows) do
if not _a55.luck then break end
if _a559.on and _a559.deficit >= _a52.LuckMinTopUp and _a559.need >= 1 then
local _a560 = math.max(0, _a556 - _a52.LuckReserve)
local _a561 = math.min(_a559.need, math.floor(_a560))
if _a561 >= 1 then
local _a562 = _a556
local _a563, _a564
pcall(function()
_a563, _a564 = _a51.R_LUCK:InvokeServer(_a559.rarity, "Slot1", _a561)
end)
task.wait(0.4)
_a556 = _a234()
_a56.sun = _a556
if _a563 then
_a557 += 1
_a56.luck += 1
_a46(("  ✦ 럭 %s  +%s  (%s → %s)  비용 %s"):format(
_a559.rarity, _a550(_a561 * _a559.per),
_a550(_a559.left), _a550(math.min(_a555.maxSec, _a559.left + _a561 * _a559.per)),
_a47(_a562 - _a556, 0)))
else
_a46(("  ✗ 럭 %s 실패: %s"):format(_a559.rarity, tostring(_a564)))
end
task.wait(_a52.ActionGap)
end
end
end
if _a557 == 0 then
local _a565 = {}
for _a566, _a567 in ipairs(_a555.rows) do
if _a567.on then
_a565[#_a565 + 1] = ("%s %s"):format(_a567.rarity, _a550(_a567.left))
end
end
if #_a565 > 0 then
_a46("[럭] 유지 중 — " .. table.concat(_a565, " / "))
end
end
end
_a43.EVENT_UPGRADES, _a43.ctx, _a43.collectSlots, _a43.placedTowers, _a43.availableItems, _a43.cyclePlace = _a58, _a106, _a113, _a132, _a146, _a187
_a43.cycleMerchant, _a43.sunflowers, _a43.eventTiers, _a43.nextCost, _a43.cycleUpgrade, _a43.seedInv = _a229, _a234, _a240, _a272, _a293, _a350
_a43.bedsOf, _a43.isUnhatched, _a43.bedCps, _a43.cycleCrop, _a43.laneCosts, _a43.lockedBeds = _a360, _a368, _a372, _a376, _a399, _a407
_a43.cycleExpand, _a43.rebirthStatus, _a43.cycleRebirth, _a43.hatchStatus, _a43.cycleHatch = _a414, _a438, _a453, _a505, _a512
_a43.LUCK_ORDER, _a43.luckStatus, _a43.fmtDur, _a43.cycleLuck = _a526, _a542, _a550, _a554
end)(_a1)
;(function(_a568)
local _a569, _a570, _a571, _a572, _a573, _a574 = _a568.UIS, _a568.RunService, _a568.LP, _a568.log, _a568.num, _a568.req
local _a575, _a576, _a577, _a578, _a579, _a580 = _a568.LB, _a568.NET, _a568.RM, _a568.CFG, _a568.RUN, _a568.STAT
local _a581, _a582 = _a568.ctx, _a568.placedTowers
local _a583 = {
AutoFarm = _a574("Library", "Client", "AutoFarmCmds"),
Zone     = _a574("Library", "Client", "ZoneCmds"),
Currency = _a574("Library", "Client", "CurrencyCmds"),
Bal      = _a574("Library", "Balancing"),
Egg      = _a574("Library", "Client", "EggCmds"),
Rebirth  = _a574("Library", "Client", "RebirthCmds"),
RanksU   = _a574("Library", "Util", "RanksUtil"),
DirRanks = _a574("Library", "Directory", "Ranks"),
DirEggs  = _a574("Library", "Directory", "Eggs"),
CalcEgg  = _a574("Library", "Balancing", "CalcEggPricePlayer"),
R_Farm   = _a576:FindFirstChild("AutoFarm_Enable"),
R_FarmOff = _a576:FindFirstChild("AutoFarm_Disable"),
R_Zone   = _a576:FindFirstChild("Zones_RequestPurchase"),
R_Reb    = _a576:FindFirstChild("Rebirth_Request"),
R_Rank   = _a576:FindFirstChild("Ranks_ClaimReward"),
Quest    = _a574("Library", "Client", "QuestCmds"),
EggsU    = _a574("Library", "Util", "EggsUtil"),
Map      = _a574("Library", "Client", "MapCmds"),
Inst     = _a574("Library", "Client", "InstancingCmds"),
DirZones = _a574("Library", "Directory", "Zones"),
ZonesU   = _a574("Library", "Util", "ZonesUtil"),
Upg      = _a574("Library", "Client", "UpgradeCmds"),
DirUpg   = _a574("Library", "Directory", "Upgrades"),
R_Upg    = _a576:FindFirstChild("Upgrades_Purchase"),
R_EggUn  = _a576:FindFirstChild("Eggs_RequestUnlock"),
Rand     = _a574("Library", "Client", "RandomEventCmds"),
R_Events = _a576:FindFirstChild("RandomEvents_Get"),
Ult      = _a574("Library", "Client", "UltimateCmds"),
R_Fruit  = _a576:FindFirstChild("Fruits: Consume"),
R_Cons   = _a576:FindFirstChild("Consumables_Consume"),
R_Ult    = _a576:FindFirstChild("Ultimates: Activate"),
R_Gold   = _a576:FindFirstChild("GoldMachine_Activate"),
R_Rain   = _a576:FindFirstChild("RainbowMachine_Activate"),
R_Flag   = _a576:FindFirstChild("FlexibleFlags_Consume"),
DirPets  = _a574("Library", "Directory", "Pets"),
CalcEggB = _a574("Library", "Balancing", "CalcEggPrice"),
PlayerPet = _a574("Library", "Client", "PlayerPet"),
Machine  = _a574("Library", "Client", "MachineCmds"),
Vars     = _a574("Library", "Variables"),
Hatch    = _a574("Library", "Client", "HatchingCmds"),
R_AHTog  = _a576:FindFirstChild("AutoHatch_Toggle"),
R_AHOn   = _a576:FindFirstChild("AutoHatch_Enable"),
R_AHOff  = _a576:FindFirstChild("AutoHatch_Disable"),
RankC    = _a574("Library", "Client", "RankCmds"),
CalcPetS = _a574("Library", "Balancing", "CalcPetSlotPrice"),
CalcEggS = _a574("Library", "Balancing", "CalcEggSlotPrice"),
R_PetSlot = _a576:FindFirstChild("EquipSlotsMachine_RequestPurchase"),
R_EggSlot = _a576:FindFirstChild("EggHatchSlotsMachine_RequestPurchase"),
R_Tp     = _a576:FindFirstChild("Teleports_RequestTeleport"),
R_TpI    = _a576:FindFirstChild("Teleports_RequestInstanceTeleport"),
R_PotUp  = _a576:FindFirstChild("UpgradePotionsMachine_ActivateBulk"),
R_EncUp  = _a576:FindFirstChild("UpgradeEnchantsMachine_ActivateBulk"),
R_PotUse = _a576:FindFirstChild("Potions: Consume"),
}
local _a584 = {
[1]="farm", [9]="farm", [21]="farm", [7]="farm", [99]="farm", [8]="farm",
[30]="farm", [31]="farm", [32]="farm", [37]="farm", [38]="farm", [39]="farm",
[43]="farm", [44]="farm", [66]="farm", [67]="farm", [75]="farm", [76]="farm",
[14]="farm", [15]="farm", [64]="farm", [65]="farm", [63]="farm",
[2]="hatch", [3]="hatch", [20]="hatch", [42]="hatch", [47]="hatch",
[6]="zone", [81]="zone",
[34]="potuse",
[35]="fruituse", [33]="flaguse",
}
local _a585 = {}
_a585.ctl, _a585.move, _a585.egg = {}, {}, {}
_a585.screen, _a585.quest, _a585.ev = {}, {}, {}
_a585.item, _a585.mach, _a585.auto = {}, {}, {}
_a585.quest.IGNORE = {
[4]  = "골드 펫 만들기 (합성 필요)",
[5]  = "레인보우 펫 만들기 (합성 필요)",
[40] = "best egg 골드 펫 (뽑기+합성 필요)",
[41] = "best egg 레인보우 펫 (뽑기+2단 합성 필요)",
[12] = "포션 업글 (업글 머신으로 이동 필요)",
[13] = "인챈트 업글 (업글 머신으로 이동 필요)",
}
_a585.ctl.abort = false
function _a585.ctl.stopped() return _a585.ctl.abort == true end
function _a585.ctl.stopAll()
_a585.ctl.abort = true
for _a586 in pairs(_a579) do
if _a586 ~= "petspd" and _a586 ~= "rewatch" then _a579[_a586] = false end
end
_a585.ctl.lockGoal = nil
_a585.ctl.moving = nil
_a585.ctl.now.step = "정지"
_a585.ctl.setAct("정지됨")
end
_a585.ctl.now = { step = "-", act = "-", detail = "", goal = "-", prog = "" }
function _a585.ctl.setAct(_a587, _a588)
_a585.ctl.now.act = _a587 or "-"
_a585.ctl.now.detail = _a588 and tostring(_a588) or ""
_a585.ctl.now.at = os.clock()
end
function _a585.ctl.setGoal(_a589, _a590)
_a585.ctl.now.goal = _a589 and tostring(_a589) or "-"
_a585.ctl.now.prog = _a590 and tostring(_a590) or ""
end
function _a585.egg.eggStands()
local _a591 = os.clock()
if _a585.egg._standsAt and (_a591 - _a585.egg._standsAt) < 2 and _a585.egg._stands then
local _a592 = _a571 and _a571.Character
local _a593 = _a592 and _a592:FindFirstChild("HumanoidRootPart")
if _a593 then
for _a594, _a595 in ipairs(_a585.egg._stands) do
_a595.dist = (_a595.pos - _a593.Position).Magnitude
end
table.sort(_a585.egg._stands, function(_a596, _a597) return _a596.dist < _a597.dist end)
end
return _a585.egg._stands
end
local _a598 = {}
local _a599 = workspace:FindFirstChild("__THINGS")
local _a600 = _a599 and _a599:FindFirstChild("Eggs")
if not _a600 then return _a598 end
local _a601 = _a571 and _a571.Character
local _a602 = _a601 and _a601:FindFirstChild("HumanoidRootPart")
for _a603, _a604 in ipairs(_a600:GetDescendants()) do
if _a604:IsA("Model") and _a604.PrimaryPart then
local _a605 = tonumber(tostring(_a604.Name):match("%d+"))
if _a605 then
local _a606
if _a583.EggsU and rawget(_a583.EggsU, "GetByNumber") then
local _a607, _a608 = pcall(_a583.EggsU.GetByNumber, _a605)
if _a607 then _a606 = _a608 end
end
local _a609 = _a606 and (rawget(_a606, "_id") or rawget(_a606, "name"))
if _a609 then
_a598[#_a598 + 1] = {
id = _a609, def = _a606, num = _a605,
pos = _a604.PrimaryPart.Position,
dist = _a602 and (_a604.PrimaryPart.Position - _a602.Position).Magnitude or 9e9,
unlocked = _a604:GetAttribute("Unlocked") and true or false,
}
end
end
end
end
table.sort(_a598, function(_a610, _a611) return _a610.dist < _a611.dist end)
_a585.egg._stands, _a585.egg._standsAt = _a598, os.clock()
return _a598
end
local function _a612()
local _a613 = _a575.Save
if not _a613 then return nil end
local _a614, _a615 = pcall(_a613.Get)
if _a614 and type(_a615) == "table" then return _a615 end
if _a571 then
_a614, _a615 = pcall(_a613.Get, _a571)
if _a614 and type(_a615) == "table" then return _a615 end
end
if rawget(_a613, "GetSaves") then
local _a616, _a617 = pcall(_a613.GetSaves)
if _a616 and type(_a617) == "table" then
local _a618, _a619 = nil, 0
for _a620, _a621 in pairs(_a617) do _a619 += 1 _a618 = _a621 end
if _a619 == 1 and type(_a618) == "table" then
if not _a585.ctl.saveAlt then
_a585.ctl.saveAlt = true
_a572("[세이브] LocalPlayer 키가 안 맞아 유일한 항목으로 대체했습니다")
end
return _a618
end
end
end
return nil
end
local function _a622(_a623, _a624)
if _a583.Currency and rawget(_a583.Currency, "CanAfford") then
local _a625, _a626 = pcall(_a583.Currency.CanAfford, _a623, _a624)
if _a625 then return _a626 and true or false end
end
return false
end
local function _a627(_a628)
if _a583.Currency and rawget(_a583.Currency, "Get") then
local _a629, _a630 = pcall(_a583.Currency.Get, _a628)
if _a629 and tonumber(_a630) then return tonumber(_a630) end
end
return 0
end
local function _a631()
if _a583.AutoFarm and rawget(_a583.AutoFarm, "IsEnabled") then
local _a632, _a633 = pcall(_a583.AutoFarm.IsEnabled)
if _a632 then return _a633 and true or false end
end
return false
end
local function _a634()
if _a583.AutoFarm and rawget(_a583.AutoFarm, "GetTargetParentId") then
local _a635, _a636 = pcall(_a583.AutoFarm.GetTargetParentId)
if _a635 then return _a636 end
end
return nil
end
local function _a637()
if not _a583.R_Farm then _a572("[파밍] AutoFarm_Enable 리모트 없음") return end
local _a638 = _a631()
_a585.auto.farmZone, _a585.auto.hereZone = _a634(), _a585.move.curZone()
if _a638 then
local _a639, _a640 = _a634(), _a585.move.curZone()
if _a639 and _a640 and _a639 ~= _a640 then
_a572(("[파밍] 대상이 %s 인데 지금은 %s — 다시 켬"):format(
tostring(_a639), tostring(_a640)))
if _a583.R_FarmOff then pcall(function() _a583.R_FarmOff:InvokeServer() end) end
if _a583.AutoFarm and rawget(_a583.AutoFarm, "ForceDisable") then
pcall(_a583.AutoFarm.ForceDisable)
end
task.wait(0.3)
_a638 = false
end
end
if _a638 then return end
local _a641, _a642
pcall(function() _a641, _a642 = _a583.R_Farm:InvokeServer() end)
if _a641 then
_a580.farm += 1
_a585.auto.farmSaid = nil
_a572("[파밍] 자동 파밍 ON  (대상 " .. tostring(_a634() or _a585.move.curZone()) .. ")")
elseif _a642 and _a585.auto.farmSaid ~= tostring(_a642) then
_a585.auto.farmSaid = tostring(_a642)
_a572("[파밍] 실패: " .. tostring(_a642))
end
end
local function _a643()
if not (_a583.Zone and rawget(_a583.Zone, "GetNextZone")) then return nil end
local _a644, _a645, _a646 = pcall(_a583.Zone.GetNextZone)
if not _a644 then return nil end
return _a646 or _a645
end
local function _a647(_a648)
if not (_a583.Bal and rawget(_a583.Bal, "CalcGatePrice")) then return nil end
local _a649, _a650 = pcall(_a583.Bal.CalcGatePrice, _a648)
return (_a649 and tonumber(_a650)) or nil
end
local function _a651()
local _a652 = _a643()
if not _a652 then return nil end
local _a653 = _a647(_a652)
local _a654 = rawget(_a652, "Currency")
return {
zone = _a652, id = rawget(_a652, "_id"), price = _a653, currency = _a654,
have = _a654 and _a627(_a654) or 0,
ok = (_a653 and _a654) and _a622(_a654, _a653) or false,
}
end
local function _a655()
if not _a583.R_Zone then _a572("[존] Zones_RequestPurchase 리모트 없음") return end
local _a656 = 0
while _a579.zone and not _a585.ctl.stopped() and _a656 < 20 do
_a656 += 1
local _a657 = _a651()
if not _a657 then
_a585.auto.zoneNote = "다음 존을 못 구함 (GetNextZone 실패 / 존 퀘스트 미완료?)"
if _a585.auto.zoneSaid ~= _a585.auto.zoneNote then
_a585.auto.zoneSaid = _a585.auto.zoneNote
_a572("[존] " .. _a585.auto.zoneNote)
end
return
end
if not _a657.ok then
_a585.auto.zoneNote = ("%s  %s %s / 보유 %s — 부족"):format(
tostring(_a657.id), _a573(_a657.price or 0, 0), tostring(_a657.currency), _a573(_a657.have, 0))
if _a585.auto.zoneSaid ~= _a585.auto.zoneNote then
_a585.auto.zoneSaid = _a585.auto.zoneNote
_a572("[존] " .. _a585.auto.zoneNote)
end
return
end
_a585.auto.zoneSaid = nil
local _a658, _a659
pcall(function() _a658, _a659 = _a583.R_Zone:InvokeServer(_a657.id) end)
task.wait(0.5)
if _a658 then
_a580.zone += 1
_a572(("  ▶ 존 해금  %s   (%s %s)"):format(
tostring(_a657.id), _a573(_a657.price or 0, 0), tostring(_a657.currency)))
else
if _a659 then _a572("[존] 실패: " .. tostring(_a659)) end
return
end
task.wait(_a578.ActionGap)
end
end
local function _a660()
local _a661 = _a585.egg.eggStands()
local _a662 = (_a578.MainEggId and _a578.MainEggId ~= "") and _a578.MainEggId or nil
if _a662 then
for _a663, _a664 in ipairs(_a661) do
if _a664.id == _a662 then return _a664.id, _a664.def, _a664.dist end
end
local _a665 = _a583.DirEggs and rawget(_a583.DirEggs, _a662)
if _a665 then return _a662, _a665, nil, (_a661[1] and _a661[1].dist) end
return nil
end
if not _a583.DirEggs then return nil end
local _a666, _a667, _a668 = nil, nil, -1
for _a669, _a670 in pairs(_a583.DirEggs) do
if type(_a670) == "table" and not rawget(_a670, "isCustomEgg") then
local _a671 = tonumber(rawget(_a670, "eggNumber"))
if _a671 and _a671 > _a668 and _a585.egg.eggUnlocked(_a671) then
_a666, _a667, _a668 = _a669, _a670, _a671
end
end
end
if not _a666 then return nil end
local _a672, _a673
for _a674, _a675 in ipairs(_a661) do
if not _a673 then _a673 = _a675.dist end
if _a675.id == _a666 then _a672 = _a675.dist break end
end
if _a672 and _a672 <= _a578.EggRange then
return _a666, _a667, _a672
end
return _a666, _a667, nil, _a672 or _a673
end
local function _a676(_a677)
if type(_a583.CalcEgg) == "function" then
local _a678, _a679 = pcall(_a583.CalcEgg, _a677)
if _a678 and tonumber(_a679) then return tonumber(_a679) end
if not _a678 and not _a585.egg.priceWarned then
_a585.egg.priceWarned = true
_a572("[부화] CalcEggPricePlayer 막힘 → 기본가로 계산: " .. tostring(_a679))
end
end
if type(_a583.CalcEggB) == "function" then
local _a680, _a681 = pcall(_a583.CalcEggB, _a677)
if _a680 and tonumber(_a681) then return tonumber(_a681) end
end
for _a682, _a683 in ipairs({ "price", "Price", "cost", "Cost" }) do
local _a684 = tonumber(rawget(_a677, _a683))
if _a684 then return _a684 end
end
return nil
end
local function _a685()
local _a686, _a687, _a688, _a689 = _a660()
if not _a686 then return nil end
local _a690 = _a676(_a687)
local _a691 = rawget(_a687, "currency") or "Coins"
local _a692 = 1
if _a583.Egg and rawget(_a583.Egg, "GetMaxHatch") then
local _a693, _a694 = pcall(_a583.Egg.GetMaxHatch, _a687)
if _a693 and tonumber(_a694) then _a692 = math.max(1, math.floor(tonumber(_a694))) end
end
local _a695 = _a627(_a691)
return {
id = _a686, def = _a687, price = _a690, currency = _a691, maxN = _a692, have = _a695,
dist = _a688, nearest = _a689, inRange = _a688 ~= nil,
canBuy = (_a690 and _a690 > 0) and math.floor(math.max(0, _a695 - _a578.MainHatchReserve) / _a690) or 0,
}
end
local function _a696()
if not _a577.R_EGG then _a572("[부화] Eggs_RequestPurchase 리모트 없음") return end
if _a578.AutoUnlockEgg then
local _a697, _a698, _a699 = _a585.egg.lockedEggs()
if _a698 > _a699 then
local _a700 = _a585.egg.unlockEggs()
if _a700 > 0 then _a572(("[부화] 알 %d개 해금 (해금가능 #%d)"):format(_a700, _a698)) end
end
end
local _a701 = _a685()
if not _a701 then _a572("[부화] 알을 못 찾음") return end
if not _a701.inRange then
if _a578.HatchAutoTp then
local _a702, _a703 = _a585.egg.tpEgg(_a701.id)
if not _a702 then
if not _a585.egg.hatchWarned then
_a585.egg.hatchWarned = true
_a572("[부화] 알로 이동 실패: " .. tostring(_a703))
end
return
end
_a572("[부화] " .. _a701.id .. " 로 이동")
_a701 = _a685()
if not (_a701 and _a701.inRange) then return end
else
if not _a585.egg.hatchWarned then
_a585.egg.hatchWarned = true
_a572(("[부화] 알 근처로 가주세요 (가장 가까운 알까지 %s스터드, 인식 %d)"):format(
_a701.nearest and ("%.0f"):format(_a701.nearest) or "?", _a578.EggRange))
end
return
end
end
_a585.egg.hatchWarned = false
local _a704 = math.min(_a701.maxN, _a578.MainHatchMax)
local _a705 = _a701.price and math.min(_a701.canBuy, _a704) or _a704
if _a705 < 1 then return end
local _a706, _a707 = 0, 0
local function _a708()
return tonumber(_a583.Vars and rawget(_a583.Vars, "OpeningEgg")) or 0
end
local _a709 = _a583.Vars and rawget(_a583.Vars, "OpeningEgg") ~= nil
local _a710 = 2.5
if _a583.Egg and rawget(_a583.Egg, "ComputeDebounce") then
local _a711, _a712 = pcall(_a583.Egg.ComputeDebounce)
if _a711 and tonumber(_a712) then _a710 = tonumber(_a712) end
end
_a585.egg.autoHatchOn(_a701.id, _a705)
local _a713 = false
local _a714 = _a585.ctl.lockGoal and _a585.ctl.lockGoal.q
local _a715 = _a714 and (_a714.how == "hatch" or _a714.where == "bestegg") or false
local _a716 = _a715 and math.huge
or (os.clock() + math.max(3, _a578.HatchBudget or 25))
local _a717 = _a715 and 100000 or 400
while _a579.mhatch and not _a585.ctl.stopped() and _a705 >= 1 and _a707 < _a717 and os.clock() < _a716 do
if _a715 and (_a707 % 5 == 0) then
local _a718 = _a585.quest.findQuest(_a714.uid)
if not _a718 or _a718.progress >= _a718.amount then break end
end
_a707 += 1
if _a709 then
local _a719 = os.clock()
local _a720 = _a578.HatchClickAfter
local _a721 = false
while _a708() > 0 and _a579.mhatch and not _a585.ctl.stopped()
and (os.clock() - _a719) < 20 do
if _a578.HatchClick and (os.clock() - _a719) > _a720 then
_a585.egg.clickOnce()
_a720 += 0.3
if (os.clock() - _a719) > 3 and not _a721 then
_a721 = true
_a585.egg._ahEgg = nil
_a585.egg.autoHatchOn(_a701.id, _a705)
_a572("[부화] 화면이 안 넘어가서 오토해치 재설정")
end
end
task.wait(0.03)
end
if _a708() > 0 then
if _a585.egg.hatchStuck ~= _a701.id then
_a585.egg.hatchStuck = _a701.id
_a572("[부화] " .. tostring(_a701.id) .. " 까는 화면에서 멈춤 — 이번 회차 중단")
end
_a713 = true
break
end
_a585.egg.hatchStuck = nil
else
local _a722 = os.clock() - (_a585.egg.lastHatch or 0)
if _a722 < _a710 then task.wait(_a710 - _a722) end
end
_a585.egg.lastHatch = os.clock()
_a585.ctl.setAct("알 까는 중", ("%s x%d  (총 %d)"):format(_a701.id, _a705, _a706))
local _a723, _a724
local _a725 = pcall(function() _a723, _a724 = _a577.R_EGG:InvokeServer(_a701.id, _a705) end)
if _a723 then
_a706 += _a705
_a580.mhatch += _a705
_a585.egg.hatchErr = nil
if _a701.price then
local _a726 = _a627(_a701.currency)
local _a727 = math.floor(math.max(0, _a726 - _a578.MainHatchReserve) / _a701.price)
if _a727 < 1 then break end
_a705 = math.min(_a727, _a704)
end
else
local _a728 = _a725 and tostring(_a724) or "호출 자체 실패"
if _a728:find("quickly") or _a728:find("fast") then
task.wait(0.25)
elseif _a728:find("far away") then
if _a578.HatchAutoTp then _a585.egg.tpEgg(_a701.id) task.wait(0.2)
else _a572("[부화] 알에서 너무 멈") break end
elseif _a705 > 1 then
_a705 = math.floor(_a705 / 2)
else
if _a585.egg.hatchErr ~= _a728 then
_a585.egg.hatchErr = _a728
_a572("[부화] 실패: " .. _a728 .. "   (알 " .. tostring(_a701.id)
.. " / 개수 " .. _a705 .. " / 거리 "
.. (_a701.dist and ("%.0f"):format(_a701.dist) or "?") .. ")")
end
break
end
end
end
if _a709 and _a706 > 0 and not _a713 then
local _a729 = os.clock()
while _a708() == 0 and not _a585.ctl.stopped() and (os.clock() - _a729) < 2.5 do
task.wait(0.05)
end
local _a730 = os.clock()
local _a731 = _a578.HatchClickAfter
while _a708() > 0 and not _a585.ctl.stopped() and (os.clock() - _a730) < 20 do
_a585.ctl.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a701.id, _a705))
if _a578.HatchClick and (os.clock() - _a730) > _a731 then
_a585.egg.clickOnce()
_a731 += 0.3
if (os.clock() - _a730) > 3 and not _a585.egg._finRe then
_a585.egg._finRe = true
_a585.egg._ahEgg = nil
_a585.egg.autoHatchOn(_a701.id, _a705)
end
end
task.wait(0.03)
end
_a585.egg._finRe = nil
if _a708() > 0 then
_a572("[부화] 마지막 알이 20초 넘게 안 끝남 — 그대로 두고 진행합니다")
end
end
_a585.egg.autoHatchOff()
if _a706 > 0 then
_a585.egg.hatchErr = nil
_a572(("[부화] %s × %d%s  (개당 %s %s)"):format(
_a701.id, _a706, _a715 and " (목표까지)" or "",
_a701.price and _a573(_a701.price, 0) or "?", tostring(_a701.currency)))
end
end
local function _a732()
local _a733 = _a612()
if not _a733 then return nil end
local _a734 = tonumber(rawget(_a733, "Rank")) or 1
local _a735 = tonumber(rawget(_a733, "RankStars")) or 0
local _a736 = rawget(_a733, "RedeemedRankRewards") or {}
local _a737
if _a583.RanksU and rawget(_a583.RanksU, "RankIDFromNumber") then
local _a738, _a739 = pcall(_a583.RanksU.RankIDFromNumber, _a734)
if _a738 then _a737 = _a739 end
end
local _a740 = _a737 and _a583.DirRanks and rawget(_a583.DirRanks, _a737)
if type(_a740) ~= "table" then
return { rankNum = _a734, stars = _a735, rankId = _a737, rewards = {} }
end
local _a741, _a742 = {}, 0
for _a743, _a744 in ipairs(rawget(_a740, "Rewards") or {}) do
_a742 += (tonumber(rawget(_a744, "StarsRequired")) or 0)
local _a745 = _a742 <= _a735
local _a746 = _a736[tostring(_a743)] ~= nil
_a741[#_a741 + 1] = {
index = _a743, need = _a742, earned = _a745, redeemed = _a746,
claimable = _a745 and not _a746,
}
end
return { rankNum = _a734, stars = _a735, rankId = _a737, rewards = _a741 }
end
local function _a747()
if not _a583.R_Rank then _a572("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a748 = _a732()
if not _a748 then return end
local _a749 = 0
for _a750, _a751 in ipairs(_a748.rewards) do
if not _a579.rank then break end
if _a751.claimable then
pcall(function() _a583.R_Rank:FireServer(_a751.index) end)
_a749 += 1
_a580.rank += 1
task.wait(0.1)
end
end
if _a749 > 0 then
_a572(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a749, _a748.rankNum, _a748.stars))
end
end
function _a585.move.hrp()
local _a752 = _a571 and _a571.Character
return _a752 and _a752:FindFirstChild("HumanoidRootPart"),
_a752 and _a752:FindFirstChildOfClass("Humanoid")
end
function _a585.egg.autoHatchOn(_a753, _a754)
if not _a578.UseAutoHatch then return end
if _a585.egg._ahEgg == _a753 and _a585.egg._ahAt and (os.clock() - _a585.egg._ahAt) < 15 then return end
_a585.egg._ahEgg, _a585.egg._ahAt = _a753, os.clock()
local _a755 = _a583.DirEggs and rawget(_a583.DirEggs, _a753)
if _a583.Hatch and _a755 and rawget(_a583.Hatch, "SetupEgg") then
local _a756, _a757 = pcall(_a583.Hatch.SetupEgg, _a755, _a754 or 1)
if not _a756 and not _a585.egg._ahWarn then
_a585.egg._ahWarn = true
_a572("[부화] SetupEgg 실패: " .. tostring(_a757) .. "  → 클릭 대체 사용")
end
end
if _a583.R_AHTog then pcall(function() _a583.R_AHTog:FireServer(true) end) end
if _a583.R_AHOn then pcall(function() _a583.R_AHOn:FireServer(_a753, _a754 or 1) end) end
if _a583.Hatch and rawget(_a583.Hatch, "IsHatching") then
local _a758, _a759 = pcall(_a583.Hatch.IsHatching)
_a585.egg._ahLive = _a758 and _a759 and true or false
end
end
function _a585.egg.autoHatchOff()
_a585.egg._ahEgg, _a585.egg._ahAt, _a585.egg._ahLive = nil, nil, nil
if _a583.Hatch and rawget(_a583.Hatch, "StopHatching") then pcall(_a583.Hatch.StopHatching) end
if _a583.R_AHOff then pcall(function() _a583.R_AHOff:FireServer() end) end
end
function _a585.egg.clickOnce()
if _a585.ctl.moving then return false end
local _a760 = _a585.screen.signal("egg")
if not _a760 then _a760 = _a585.screen.pressInGame({ "Egg Opening" }) end
if not _a760 and not _a585.egg._eggSigWarn then
_a585.egg._eggSigWarn = true
_a572("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a760
end
function _a585.egg.watchStuck()
local _a761 = _a583.Vars
if not _a761 then return end
local _a762 = tonumber(rawget(_a761, "OpeningEgg")) or 0
if _a762 <= 0 then
_a585.egg.stuckSince, _a585.egg.stuckSaid = nil, nil
return
end
_a585.egg.stuckSince = _a585.egg.stuckSince or os.clock()
local _a763 = os.clock() - _a585.egg.stuckSince
if _a763 < 3 then return end
if not _a578.HatchClick then return end
if _a585.ctl.moving then _a585.screen.signal("egg") else _a585.egg.clickOnce() end
if _a763 > 6 and not _a585.egg.stuckSaid then
_a585.egg.stuckSaid = true
_a572("[부화] 까는 화면에서 멈춰 있어 계속 넘기는 중")
end
end
function _a585.item.applyPetSpeed()
local _a764 = _a583.PlayerPet
if not (_a764 and rawget(_a764, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a765, _a766 = pcall(_a764.GetByPlayer, _a571)
if not (_a765 and type(_a766) == "table") then return 0, "펫 목록 못 읽음" end
local _a767 = math.max(1, tonumber(_a578.PetSpeedMult) or 50)
local _a768 = math.max(0.05, tonumber(_a578.PetSpeedBase) or 4)
local _a769 = 0
for _a770, _a771 in pairs(_a766) do
if type(_a771) == "table" then
local _a772 = rawget(_a771, "cpet")
if _a772 then
_a771.speedMult = _a767
pcall(function() _a772:Broadcast("petSpeedMult", _a767) end)
pcall(function() _a772:Broadcast("petSpeed", _a768) end)
_a769 += 1
end
end
end
return _a769
end
_a585.screen.SIGNAL = {
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
_a585.screen.BLOCKERS = {
{ "Rebirth",     "리버스",   "reward" },
{ "RankUp",      "랭크업",   "reward" },
{ "MasteryPerk", "마스터리", "mastery" },
{ "Card",        "카드",     "card" },
}
function _a585.screen.findSignalFns(_a773)
local _a774 = _a585.screen.SIGNAL[_a773]
if not _a774 then return {} end
_a585.screen._sig = _a585.screen._sig or {}
local _a775 = _a585.screen._sig[_a773]
if _a775 and (os.clock() - _a775.at) < (#_a775.fns > 0 and 20 or 3) then return _a775.fns end
local _a776 = {}
_a585.screen._sig[_a773] = { at = os.clock(), fns = _a776 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a776
end
local _a777 = {}
for _a778, _a779 in ipairs({ true, false }) do
local _a780, _a781 = pcall(getgc, _a779)
if _a780 and type(_a781) == "table" then
for _a782, _a783 in ipairs(_a781) do _a777[#_a777 + 1] = _a783 end
end
end
if #_a777 == 0 then return _a776 end
for _a784, _a785 in ipairs(_a777) do
if type(_a785) == "function" then
local _a786, _a787 = pcall(debug.info, _a785, "s")
if _a786 and type(_a787) == "string" then
local _a788 = false
for _a789, _a790 in ipairs(_a774.pats) do
if _a787:find(_a790, 1, true) then _a788 = true break end
end
if _a788 then
local _a791, _a792 = pcall(debug.info, _a785, "a")
if _a791 then
local _a793, _a794 = {}, 0
for _a795 = 1, 16 do
local _a796, _a797 = pcall(debug.getupvalue, _a785, _a795)
if not _a796 then break end
_a794 = _a795
_a793[_a795] = type(_a797)
end
local _a798 = table.concat(_a793, ",")
local _a799 = false
for _a800, _a801 in ipairs(_a774.sigs or {}) do
if _a792 == _a801.np and _a798 == _a801.t then
_a776[#_a776 + 1] = { fn = _a785, sig = _a798, n = _a794, np = _a792,
src = _a787, set = _a801.set }
_a799 = true
break
end
end
if not _a799 and _a774.sigs then
local _a802 = {}
for _a803, _a804 in ipairs(_a793) do
if _a804 == "boolean" then _a802[#_a802 + 1] = _a803 end
end
if #_a802 > 0 then
_a776[#_a776 + 1] = { fn = _a785, idx = _a802, sig = _a798, n = _a794,
np = _a792, src = _a787, loose = true }
end
end
if not _a799 and not _a774.sigs and _a792 == 0 then
local _a805 = 0
for _a806, _a807 in ipairs(_a793) do if _a807 == "boolean" then _a805 += 1 end end
if _a805 >= (_a774.minBools or 1) then
local _a808 = {}
for _a809, _a810 in ipairs(_a793) do
if _a810 == "boolean" then _a808[#_a808 + 1] = _a809 end
end
_a776[#_a776 + 1] = { fn = _a785, idx = _a808, sig = _a798, n = _a794, src = _a787 }
end
end
end
end
end
end
end
return _a776
end
function _a585.screen.signal(_a811)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a812 = _a585.screen.findSignalFns(_a811)
local _a813 = 0
for _a814, _a815 in ipairs(_a812) do
if _a815.set then
for _a816, _a817 in ipairs(_a815.set) do
if pcall(debug.setupvalue, _a815.fn, _a817[1], _a817[2]) then _a813 += 1 end
end
elseif not _a815.loose then
for _a818, _a819 in ipairs(_a815.idx or {}) do
if pcall(debug.setupvalue, _a815.fn, _a819, true) then _a813 += 1 end
end
end
end
if _a813 == 0 then
for _a820, _a821 in ipairs(_a812) do
if _a821.loose then
for _a822, _a823 in ipairs(_a821.idx or {}) do
if pcall(debug.setupvalue, _a821.fn, _a823, true) then _a813 += 1 end
end
end
end
end
return _a813 > 0, _a813
end
function _a585.screen.pressInGame(_a824)
local _a825, _a826 = pcall(function() return game:GetService("UserInputService") end)
if not (_a825 and _a826) then return false end
local _a827 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a828 = 0
if type(getconnections) == "function" then
local _a829, _a830 = pcall(getconnections, _a826.InputBegan)
if _a829 and type(_a830) == "table" then
for _a831, _a832 in ipairs(_a830) do
local _a833 = ""
local _a834 = _a832.Function
if _a834 and type(debug) == "table" and type(debug.info) == "function" then
local _a835, _a836 = pcall(debug.info, _a834, "s")
if _a835 and _a836 then _a833 = tostring(_a836) end
end
local _a837 = false
for _a838, _a839 in ipairs(_a824) do
if _a833 ~= "" and _a833:find(_a839, 1, true) then _a837 = true break end
end
if _a837 then
if _a834 and pcall(_a834, _a827, false) then _a828 += 1
elseif _a832.Fire and pcall(function() _a832:Fire(_a827, false) end) then _a828 += 1
elseif _a832.Defer and pcall(function() _a832:Defer(_a827, false) end) then _a828 += 1 end
end
end
end
end
if _a828 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a826.InputBegan, _a827, false) then _a828 += 1 end
end
return _a828 > 0
end
function _a585.screen.realClick(_a840)
if not _a578.ScreenRealClick then return false end
local _a841 = workspace.CurrentCamera
local _a842 = (_a841 and _a841.ViewportSize) or Vector2.new(1280, 720)
local _a843, _a844 = _a842.X * 0.5, _a842.Y * 0.45
local _a845 = {}
local function _a846(_a847, _a848)
local _a849 = pcall(_a848)
_a845[#_a845 + 1] = _a847 .. (_a849 and "=OK" or "=X")
return _a849
end
local _a850 = false
if not _a850 and type(mouse1click) == "function" then
_a850 = _a846("mouse1click", function() mouse1click() end)
end
if not _a850 and type(mouse1press) == "function" then
_a850 = _a846("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a850 then
_a850 = _a846("VirtualUser", function()
local _a851 = game:GetService("VirtualUser")
_a851:Button1Down(Vector2.new(_a843, _a844), _a841 and _a841.CFrame or CFrame.new())
task.wait(0.05)
_a851:Button1Up(Vector2.new(_a843, _a844), _a841 and _a841.CFrame or CFrame.new())
end)
end
if not _a850 then
_a850 = _a846("VirtualInputManager", function()
local _a852 = game:GetService("VirtualInputManager")
_a852:SendMouseButtonEvent(_a843, _a844, 0, true, game, 1)
task.wait(0.05)
_a852:SendMouseButtonEvent(_a843, _a844, 0, false, game, 1)
end)
end
if _a840 then _a572("    " .. table.concat(_a845, " / ")) end
return _a850
end
function _a585.screen.rewardScreenUp()
if not _a571 then
if not _a585.screen.noLP then
_a585.screen.noLP = true
_a572("[화면] LocalPlayer 를 못 잡았습니다 — 화면 감시를 건너뜁니다")
end
return false
end
local _a853 = _a571:FindFirstChildOfClass("PlayerGui")
if _a853 then
for _a854, _a855 in ipairs(_a585.screen.BLOCKERS) do
local _a856 = _a853:FindFirstChild(_a855[1])
if _a856 and _a856:IsA("ScreenGui") and _a856.Enabled then return true, _a855[2], _a855[3] end
end
end
local _a857 = _a583.Vars
if _a857 then
if rawget(_a857, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a857, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a585.screen.dismissRewardScreens(_a858)
if _a585.screen.dismissBusy then return end
_a585.screen.dismissBusy = true
local _a859, _a860 = pcall(_a585.screen.dismissInner, _a858)
_a585.screen.dismissBusy = false
if not _a859 then _a572("[화면] 오류: " .. tostring(_a860)) end
end
function _a585.screen.dismissInner(_a861)
local _a862 = _a583.Vars
if not _a862 then return end
local _a863 = os.clock()
local _a864, _a865 = false, nil
local _a866 = 0
local _a867 = math.max(3, _a578.ScreenTryMax or 8)
while os.clock() - _a863 < (_a861 or 120) do
local _a868, _a869, _a870 = _a585.screen.rewardScreenUp()
if not _a868 then break end
_a864, _a865 = true, _a869
_a866 += 1
_a585.ctl.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a869), _a866,
_a866 <= 6 and " · 첫 화면 대기" or ""))
local _a871 = _a585.screen.SIGNAL[_a870 or "reward"]
local _a872 = (_a871 and _a871.pats) or { "Rebirth", "Rank Up" }
local _a873 = _a585.screen.signal(_a870 or "reward")
if not _a873 then
for _a874 in pairs(_a585.screen.SIGNAL) do
if _a585.screen.signal(_a874) then _a873 = true end
end
end
local _a875 = false
if not _a873 or _a866 >= 2 then
_a875 = _a585.screen.pressInGame(_a872)
end
if _a866 >= 3 then
if _a585.screen.realClick() then
_a875 = true
if not _a585.screen._realSaid then
_a585.screen._realSaid = true
_a572("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a873 or _a875) and not _a585.screen._sigSaid then
_a585.screen._sigSaid = true
_a572("[화면] " .. (_a873 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a866 >= _a867 and (os.clock() - _a863) >= 12 then
if _a585.screen.giveUpSaid ~= _a869 then
_a585.screen.giveUpSaid = _a869
_a572(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a869)))
_a572("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a585.screen.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a864 then
if not _a585.screen.rewardScreenUp() then
_a585.screen.lastBlocker = nil
_a585.screen.screenGaveUp = nil
_a572(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a865), _a866))
end
end
end
function _a585.egg.eggUnlocked(_a876)
_a876 = tonumber(_a876)
if not _a876 then return false end
local _a877 = _a612()
local _a878 = _a877 and rawget(_a877, "UnlockedEggs")
if type(_a878) == "table" then
for _a879, _a880 in pairs(_a878) do
if tonumber(_a880) == _a876 then return true end
end
return false
end
return _a876 <= 1
end
function _a585.egg.lockedEggs()
local _a881 = {}
if not _a583.DirEggs then return _a881, 0, 0 end
local _a882 = _a612()
local _a883 = tonumber(_a882 and rawget(_a882, "MaximumAvailableEgg")) or 1
local _a884 = 0
local _a885 = _a882 and rawget(_a882, "UnlockedEggs")
if type(_a885) == "table" then
for _a886, _a887 in pairs(_a885) do
local _a888 = tonumber(_a887)
if _a888 and _a888 > _a884 then _a884 = _a888 end
end
end
for _a889, _a890 in pairs(_a583.DirEggs) do
if type(_a890) == "table" and not rawget(_a890, "isCustomEgg") then
local _a891 = tonumber(rawget(_a890, "eggNumber"))
if _a891 and _a891 <= _a883 and not _a585.egg.eggUnlocked(_a891) then
_a881[#_a881 + 1] = { id = _a889, num = _a891 }
end
end
end
table.sort(_a881, function(_a892, _a893) return _a892.num < _a893.num end)
return _a881, _a883, _a884
end
function _a585.egg.unlockEggs(_a894)
if not _a583.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a895 = _a585.egg.lockedEggs()
if #_a895 == 0 then return 0 end
local _a896, _a897 = 0, nil
for _a898, _a899 in ipairs(_a895) do
if not _a585.egg.eggUnlocked(_a899.num) then
local _a900, _a901
pcall(function() _a900, _a901 = _a583.R_EggUn:InvokeServer(_a899.id) end)
if not _a900 and _a578.HatchAutoTp then
local _a902 = _a585.egg.tpEgg(_a899.id)
if _a902 then
task.wait(0.3)
pcall(function() _a900, _a901 = _a583.R_EggUn:InvokeServer(_a899.id) end)
end
end
if _a900 then
_a896 += 1
_a585.ctl.setAct("알 해금", ("#%d %s"):format(_a899.num, _a899.id))
_a572(("  🔓 알 해금  #%d %s"):format(_a899.num, _a899.id))
task.wait(0.15)
else
_a897 = _a901
if _a894 then
_a572(("[해금] #%d %s 실패: %s"):format(_a899.num, _a899.id, tostring(_a901)))
end
end
end
end
return _a896, _a897
end
function _a585.move.curZone()
if _a583.Map and rawget(_a583.Map, "GetCurrentZone") then
local _a903, _a904 = pcall(_a583.Map.GetCurrentZone)
if _a903 then return _a904 end
end
return nil
end
function _a585.move.zone1()
if not _a583.DirZones then return nil end
local _a905, _a906 = nil, math.huge
for _a907, _a908 in pairs(_a583.DirZones) do
if type(_a908) == "table" and _a585.move.ownsZone(_a907) then
local _a909 = tonumber(rawget(_a908, "ZoneNumber")) or math.huge
if _a909 < _a906 then _a905, _a906 = _a907, _a909 end
end
end
return _a905
end
function _a585.move.realZone(_a910) return _a910 end
function _a585.move.resolvableZone(_a911)
if _a911 then
local _a912 = _a585.move.zonePos(_a911)
if _a912 then return _a911, _a912 end
end
if not _a583.DirZones then return nil end
local _a913 = {}
for _a914, _a915 in pairs(_a583.DirZones) do
if type(_a915) == "table" and _a585.move.ownsZone(_a914) then
_a913[#_a913 + 1] = { id = _a914, n = tonumber(rawget(_a915, "ZoneNumber")) or 0 }
end
end
table.sort(_a913, function(_a916, _a917) return _a916.n > _a917.n end)
for _a918, _a919 in ipairs(_a913) do
if _a919.id ~= _a911 then
local _a920 = _a585.move.zonePos(_a919.id)
if _a920 then
if _a585.move.fallZone ~= _a919.id then
_a585.move.fallZone = _a919.id
_a572(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a911), tostring(_a919.id)))
end
return _a919.id, _a920
end
end
end
return nil
end
function _a585.move.bestZone()
if _a583.Zone and rawget(_a583.Zone, "GetMaxOwnedZone") then
local _a921, _a922, _a923 = pcall(_a583.Zone.GetMaxOwnedZone)
if _a921 and _a922 then return _a922, _a923 end
end
return _a585.move.zone1()
end
function _a585.move.ownsZone(_a924)
local _a925 = _a612()
local _a926 = _a925 and rawget(_a925, "UnlockedZones")
return (type(_a926) == "table" and _a926[_a924] ~= nil) or false
end
function _a585.move.zoneByNumber(_a927)
if not (_a583.DirZones and _a927) then return nil end
for _a928, _a929 in pairs(_a583.DirZones) do
if type(_a929) == "table" and tonumber(rawget(_a929, "ZoneNumber")) == tonumber(_a927) then
return _a928, _a929
end
end
return nil
end
local function _a930(_a931, _a932)
local _a933 = rawget(_a931, "Breakables")
local _a934 = type(_a933) == "table" and rawget(_a933, "Main") or nil
local _a935 = type(_a934) == "table" and rawget(_a934, "Data") or nil
if type(_a935) ~= "table" then return false end
for _a936, _a937 in pairs(_a935) do
local _a938 = type(_a937) == "table" and rawget(_a937, "Type") or nil
if _a938 and tostring(_a938):lower():find(_a932, 1, true) then return true end
end
return false
end
function _a585.move.zoneForBreakable(_a939)
if not (_a583.DirZones and _a939) then return nil end
local _a940 = tostring(_a939):lower()
local _a941 = _a585.move.bestZone()
if _a941 then
local _a942 = rawget(_a583.DirZones, _a941)
if type(_a942) == "table" and _a930(_a942, _a940) then return _a941 end
end
local _a943, _a944 = nil, -1
for _a945, _a946 in pairs(_a583.DirZones) do
if type(_a946) == "table" and _a945 ~= "Spawn" and _a585.move.ownsZone(_a945) then
local _a947 = rawget(_a946, "Breakables")
local _a948 = type(_a947) == "table" and rawget(_a947, "Main") or nil
local _a949 = type(_a948) == "table" and rawget(_a948, "Data") or nil
if type(_a949) == "table" then
for _a950, _a951 in pairs(_a949) do
local _a952 = type(_a951) == "table" and rawget(_a951, "Type") or nil
if _a952 and tostring(_a952):lower():find(_a940, 1, true) then
local _a953 = tonumber(rawget(_a946, "ZoneNumber")) or 0
if _a953 > _a944 then _a943, _a944 = _a945, _a953 end
break
end
end
end
end
end
return _a943
end
function _a585.move.tpZone(_a954)
if not _a954 then return false, "존 id 없음" end
if _a585.move.curZone() == _a954 then return true end
if not _a578.TpGameFallback then
_a572("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a954) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a955 = _a583.R_Tp
if _a583.Inst and rawget(_a583.Inst, "IsInInstance") then
local _a956, _a957 = pcall(_a583.Inst.IsInInstance)
if _a956 and _a957 and _a583.R_TpI then _a955 = _a583.R_TpI end
end
if not _a955 then return false, "텔레포트 리모트 없음" end
local _a958 = os.clock() - (_a585.move.lastTp or 0)
if _a958 < _a578.TpCooldown then task.wait(_a578.TpCooldown - _a958) end
_a585.move.lastTp = os.clock()
local _a959, _a960
pcall(function() _a959, _a960 = _a955:InvokeServer(_a954) end)
if not _a959 then return false, _a960 end
local _a961 = os.clock()
while os.clock() - _a961 < 5 do
if _a585.move.curZone() == _a954 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a585.move.glideTo(_a962)
if _a585.ctl.stopped() then return false, "정지됨" end
if _a585.ctl.moving and (os.clock() - _a585.ctl.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a585.ctl.moving = os.clock()
local _a963, _a964, _a965 = pcall(_a585.move.glideRaw, _a962)
_a585.ctl.moving = nil
if not _a963 then return false, tostring(_a964) end
return _a964, _a965
end
function _a585.move.glideRaw(_a966)
local _a967, _a968 = _a585.move.hrp()
if not _a967 then return false, "캐릭터 없음" end
if _a578.TpMode == "instant" then
local _a969 = _a966 + Vector3.new(0, 4, 0)
for _a970 = 1, 3 do
local _a971 = _a571 and _a571.Character
local _a972, _a973 = _a585.move.hrp()
if not (_a971 and _a972) then return false, "캐릭터 없음" end
local _a974 = _a972.CFrame - _a972.CFrame.Position
pcall(function() _a971:PivotTo(CFrame.new(_a969) * _a974) end)
_a972.AssemblyLinearVelocity = Vector3.zero
for _a975 = 1, 6 do _a570.Heartbeat:Wait() end
if _a973 then
pcall(function()
_a973:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a973:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a972 = _a585.move.hrp()
if _a972 and (_a972.Position - _a969).Magnitude <= 30 then
local _a976 = os.clock()
while os.clock() - _a976 < 1.5 do
if _a585.move.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a970 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a578.TpMode == "walk" then
if not _a968 then return false, "Humanoid 없음" end
local _a977 = os.clock()
while os.clock() - _a977 < 45 do
local _a978 = _a967.Position
if (Vector3.new(_a978.X, 0, _a978.Z) - Vector3.new(_a966.X, 0, _a966.Z)).Magnitude < 8 then
return true
end
_a968:MoveTo(_a966)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a967.Position - _a966).Magnitude <= (_a578.ArriveDist or 12) then return true end
local _a979 = math.max(16, tonumber(_a578.TpSpeed) or 90)
local _a980 = math.max(0, tonumber(_a578.TpHeight) or 0)
local function _a981(_a982, _a983)
local _a984 = 0
while _a984 < 2000 do
if _a585.ctl.stopped() then return false end
_a984 += 1
local _a985 = _a585.move.hrp()
if not _a985 then return false end
local _a986 = _a985.Position
local _a987 = _a982 - _a986
local _a988 = _a987.Magnitude
if _a988 < 2.5 then return true end
local _a989 = _a570.Heartbeat:Wait()
local _a990 = math.min(_a988, _a979 * math.min(_a989, 0.1))
local _a991 = _a983 and (Vector3.new(_a982.X, _a986.Y, _a982.Z)) or nil
if _a991 and (_a991 - _a986).Magnitude > 1 then
_a985.CFrame = CFrame.lookAt(_a986 + _a987.Unit * _a990, _a991)
else
_a985.CFrame = CFrame.new(_a986 + _a987.Unit * _a990) * (_a985.CFrame - _a985.Position)
end
_a985.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a980 > 0 then
local _a992 = _a967.Position
local _a993 = math.max(_a992.Y, _a966.Y) + _a980
_a981(Vector3.new(_a992.X, _a993, _a992.Z), false)
_a981(Vector3.new(_a966.X, _a993, _a966.Z), true)
end
_a981(_a966 + Vector3.new(0, 3, 0), true)
local _a994 = _a585.move.hrp()
if _a994 then _a994.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a995(_a996)
local _a997 = #_a996
if _a997 == 0 then return nil, 0 end
local _a998, _a999 = math.huge, -math.huge
local _a1000, _a1001 = math.huge, -math.huge
local _a1002 = 0
for _a1003, _a1004 in ipairs(_a996) do
if _a1004.X < _a998 then _a998 = _a1004.X end
if _a1004.X > _a999 then _a999 = _a1004.X end
if _a1004.Z < _a1000 then _a1000 = _a1004.Z end
if _a1004.Z > _a1001 then _a1001 = _a1004.Z end
_a1002 += _a1004.Y
end
return Vector3.new((_a998 + _a999) / 2, _a1002 / _a997, (_a1000 + _a1001) / 2), _a997
end
function _a585.move.breakCenter(_a1005)
local _a1006 = _a585.move.hrp()
if not _a1006 then return nil, 0 end
local _a1007 = workspace:FindFirstChild("__THINGS")
if not _a1007 then return nil, 0 end
local _a1008 = _a1006.Position
local _a1009 = {}
for _a1010, _a1011 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1012 = _a1007:FindFirstChild(_a1011)
if _a1012 then
for _a1013, _a1014 in ipairs(_a1012:GetChildren()) do
local _a1015
if _a1014:IsA("BasePart") then _a1015 = _a1014.Position
elseif _a1014:IsA("Model") then
local _a1016, _a1017 = pcall(function() return _a1014:GetPivot() end)
if _a1016 and typeof(_a1017) == "CFrame" then _a1015 = _a1017.Position end
end
if _a1015 and (_a1015 - _a1008).Magnitude <= (_a1005 or 400) then
_a1009[#_a1009 + 1] = _a1015
end
end
end
end
return _a995(_a1009)
end
function _a585.move.groundY(_a1018, _a1019, _a1020)
_a1020 = tonumber(_a1020) or 0
local _a1021 = RaycastParams.new()
_a1021.FilterType = Enum.RaycastFilterType.Exclude
local _a1022 = {}
if _a571 and _a571.Character then _a1022[#_a1022 + 1] = _a571.Character end
local _a1023 = workspace:FindFirstChild("__THINGS")
if _a1023 then _a1022[#_a1022 + 1] = _a1023 end
_a1021.FilterDescendantsInstances = _a1022
local _a1024 = Vector3.new(_a1018, _a1020 + 12, _a1019)
local _a1025, _a1026 = pcall(function()
return workspace:Raycast(_a1024, Vector3.new(0, -160, 0), _a1021)
end)
if _a1025 and _a1026 then
local _a1027 = _a1026.Position.Y
if math.abs(_a1027 - _a1020) <= 80 then return _a1027 + 4 end
end
return nil
end
function _a585.move.zonePos(_a1028, _a1029)
if not _a1028 then return nil, "존 id 없음" end
_a1028 = _a585.move.realZone(_a1028)
local _a1030 = _a583.DirZones and rawget(_a583.DirZones, _a1028)
local _a1031 = _a1030 and rawget(_a1030, "ZoneFolder")
local _a1032 = {}
do
local _a1033 = workspace:FindFirstChild("__THINGS")
for _a1034, _a1035 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1036 = _a1033 and _a1033:FindFirstChild(_a1035)
if _a1036 then
for _a1037, _a1038 in ipairs(_a1036:GetChildren()) do
local _a1039
if _a1038:IsA("BasePart") then _a1039 = _a1038.Position
elseif _a1038:IsA("Model") then
local _a1040, _a1041 = pcall(function() return _a1038:GetPivot() end)
if _a1040 and typeof(_a1041) == "CFrame" then _a1039 = _a1041.Position end
end
if _a1039 then _a1032[#_a1032 + 1] = _a1039 end
end
end
end
end
local _a1042 = {}
local function _a1043(_a1044, _a1045)
if not _a1044 then return end
local _a1046, _a1047 = pcall(function() return _a1044:GetDescendants() end)
if _a1044:IsA("BasePart") then _a1042[#_a1042 + 1] = { p = _a1044.Position, why = _a1045 } end
if _a1046 then
for _a1048, _a1049 in ipairs(_a1047) do
if _a1049:IsA("BasePart") then
_a1042[#_a1042 + 1] = { p = _a1049.Position, why = _a1045 .. "/" .. _a1049.Name }
end
end
end
end
if _a583.ZonesU then
for _a1050, _a1051 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a1052 = rawget(_a583.ZonesU, _a1051)
if type(_a1052) == "function" then
local _a1053, _a1054 = pcall(_a1052, _a1028)
if _a1053 and _a1054 then _a1043(_a1054, _a1051) end
end
end
end
if _a1031 then
for _a1055, _a1056 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a1057, _a1058 = pcall(function() return _a1031:FindFirstChild(_a1056, true) end)
if _a1057 and _a1058 then _a1043(_a1058, "ZoneFolder/" .. _a1056) end
end
end
local _a1059, _a1060
if _a583.ZonesU and rawget(_a583.ZonesU, "GetTeleportPartLocation") then
local _a1061, _a1062 = pcall(_a583.ZonesU.GetTeleportPartLocation, _a1028)
if _a1061 and typeof(_a1062) == "CFrame" then _a1059, _a1060 = _a1062.Position, _a1062.LookVector end
end
local _a1063 = _a585.move.badSpot and _a585.move.badSpot[_a1028]
local function _a1064(_a1065)
if not _a1063 then return false end
for _a1066, _a1067 in ipairs(_a1063) do
if (_a1067 - _a1065).Magnitude <= 60 then return true end
end
return false
end
local _a1068, _a1069, _a1070, _a1071
for _a1072, _a1073 in ipairs(_a1042) do
if not _a1064(_a1073.p) then
local _a1074 = 0
for _a1075, _a1076 in ipairs(_a1032) do
if (_a1076 - _a1073.p).Magnitude <= 150 then _a1074 += 1 end
end
local _a1077
if _a1059 then
local _a1078 = _a1073.p - _a1059
local _a1079 = _a1078.Magnitude
local _a1080 = 0
if _a1060 and _a1079 > 1 then
local _a1081 = (_a1078 / _a1079):Dot(_a1060)
if _a1081 > 0.25 then _a1080 = 200 end
end
_a1077 = _a1079 - _a1080 - math.min(_a1074, 20) * 5
else
_a1077 = -_a1074
end
if _a1074 >= 1 and (not _a1071 or _a1077 < _a1071) then
_a1068, _a1069, _a1070, _a1071 = _a1073.p, _a1074, _a1073.why, _a1077
end
end
end
local _a1082, _a1083
if _a1068 then
_a1082, _a1083 = _a1068, ("%s (브레이커블 %d개%s)"):format(
tostring(_a1070), _a1069, _a1059 and ", 도착지점 앞" or "")
end
if not _a1082 and _a1059 then
_a1082 = _a1060 and (_a1059 + _a1060 * 40) or _a1059
_a1083 = "PERSISTENT/Teleport 앞 (스트리밍 대기)"
end
if not _a1082 then return nil, "브레이커블 위치를 못 찾음" end
local _a1084 = _a585.move.groundY(_a1082.X, _a1082.Z, _a1082.Y)
if _a1084 then
_a1082 = Vector3.new(_a1082.X, _a1084, _a1082.Z)
_a1083 = _a1083 .. " +지면"
else
_a1082 = Vector3.new(_a1082.X, _a1082.Y + 5, _a1082.Z)
end
return _a1082, _a1083
end
function _a585.move.goToZone(_a1085, _a1086, _a1087, _a1088)
_a1085 = _a585.move.realZone(_a1085)
if not _a1085 then return false, "존 id 없음" end
local _a1089, _a1090 = _a585.move.zonePos(_a1085)
if not _a1089 then
if _a578.TpGameFallback and _a585.move.curZone() ~= _a1085 then
local _a1091, _a1092 = _a585.move.tpZone(_a1085)
if not _a1091 then return false, _a1092 end
task.wait(0.3)
_a1089, _a1090 = _a585.move.zonePos(_a1085)
end
if not _a1089 then
local _a1093, _a1094 = _a585.move.resolvableZone(_a1085)
if _a1093 and _a1094 then
if _a1088 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a1085))
end
_a1085, _a1089, _a1090 = _a1093, _a1094, "대체 존 " .. tostring(_a1093)
else
if _a585.move.zoneFailSaid ~= _a1085 then
_a585.move.zoneFailSaid = _a1085
_a572(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a1085), tostring(_a1090)))
end
return false, _a1090
end
end
end
local _a1095 = _a585.move.hrp()
if not _a1087 and _a1095 and _a585.move.curZone() == _a1085 then
local _a1096 = _a585.move.inDottedBox()
local _a1097
if _a1096 ~= nil then
_a1097 = _a1096
else
_a1097 = (_a1095.Position - _a1089).Magnitude <= (_a578.ZoneArriveDist or 90)
end
if _a1097 then
if _a1086 then _a572("[TP] 이미 " .. _a1085 .. " 사냥터 안에 있음") end
return true
end
end
if _a1086 then
_a572(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a1085, tostring(_a1090), _a1089.X, _a1089.Y, _a1089.Z))
end
local _a1098, _a1099 = _a585.move.glideTo(_a1089)
local _a1100 = _a585.move.hrp()
if _a1100 and (_a1100.Position - _a1089).Magnitude > math.max(40, _a578.ArriveDist or 12) then
task.wait(0.2)
_a585.ctl.moving = nil
_a585.move.glideTo(_a1089)
local _a1101 = _a585.move.hrp()
local _a1102 = _a1101 and (_a1101.Position - _a1089).Magnitude or -1
if _a1102 > math.max(40, _a578.ArriveDist or 12) then
local _a1103 = _a578.TpMode
_a578.TpMode = "glide"
_a585.ctl.moving = nil
_a585.move.glideTo(_a1089)
_a578.TpMode = _a1103
local _a1104 = _a585.move.hrp()
_a1102 = _a1104 and (_a1104.Position - _a1089).Magnitude or -1
if _a1102 > math.max(40, _a578.ArriveDist or 12) then
_a572(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a1085), _a1102))
return false, "이동이 되돌려짐"
end
_a572("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a1085))
end
end
do
local _a1105 = _a585.move.hrp()
if _a1105 and (_a1105.Position.Y - _a1089.Y) > 25 then
_a572(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a1105.Position.Y - _a1089.Y))
_a585.ctl.moving = nil
_a585.move.glideTo(Vector3.new(_a1089.X, _a1089.Y, _a1089.Z))
end
end
if tostring(_a1090):find("스트리밍", 1, true) then
task.wait(1.2)
local _a1106, _a1107 = _a585.move.zonePos(_a1085)
if _a1106 and not tostring(_a1107):find("스트리밍", 1, true) then
if _a1086 then
_a572("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a1107) .. ")")
end
_a585.ctl.moving = nil
_a585.move.glideTo(_a1106)
_a1089, _a1090 = _a1106, _a1107
end
end
if _a585.move.inDottedBox() == false then
task.wait(0.2)
local _a1108, _a1109 = _a585.move.breakCenter(400)
if _a1108 and _a585.move.badSpot and _a585.move.badSpot[_a1085] then
for _a1110, _a1111 in ipairs(_a585.move.badSpot[_a1085]) do
if (_a1111 - _a1108).Magnitude <= 60 then _a1108 = nil break end
end
end
if _a1108 and _a1109 >= 3 then
if _a1086 then
_a572(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a1109))
end
_a585.ctl.moving = nil
_a585.move.glideTo(_a1108)
_a1089 = _a1108
end
if _a585.move.inDottedBox() == false then
local _a1112 = _a585.move.zonePos(_a1085)
if _a1112 and (_a1112 - _a1089).Magnitude > 5 then
if _a1086 then _a572("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a585.ctl.moving = nil
_a585.move.glideTo(_a1112)
_a1089 = _a1112
end
end
if _a585.move.inDottedBox() == false and _a585.move.curZone() == _a1085 then
_a585.move.badSpot = _a585.move.badSpot or {}
local _a1113 = _a585.move.badSpot[_a1085] or {}
if #_a1113 < 5 then
_a1113[#_a1113 + 1] = _a1089
_a585.move.badSpot[_a1085] = _a1113
_a572(("[TP] %s — 사냥터(점선 네모) 밖입니다. 이 지점은 앞으로 안 씁니다"):format(
tostring(_a1085)))
_a572(("        후보: %s   좌표 (%.0f, %.0f, %.0f)"):format(
tostring(_a1090), _a1089.X, _a1089.Y, _a1089.Z))
else
_a585.move.badSpot[_a1085] = nil
_a572("[TP] " .. tostring(_a1085) .. " — 쓸만한 지점을 못 찾아 기록을 지웁니다")
end
return false, "사냥터 밖"
end
end
local function _a1114()
if _a585.move.inDottedBox() == true then return false end
local _a1115, _a1116 = _a585.move.breakCenter(400)
if (_a1116 or 0) >= 1 then return false end
task.wait(0.6)
if _a585.move.inDottedBox() == true then return false end
local _a1117, _a1118 = _a585.move.breakCenter(400)
return (_a1118 or 0) < 1
end
if _a1114() and (os.clock() - (_a585.move.lastRecover or -999)) > 30 then
_a585.move.lastRecover = os.clock()
_a572(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a1085), tostring(_a1090)))
end
_a585.move.zoneFailSaid = nil
_a585.move.arrivedZone = _a1085
do
local _a1119 = _a585.move.hrp()
local _a1120 = _a1119 and (_a1119.Position - _a1089).Magnitude or 0
if _a1120 > math.max(60, _a578.ArriveDist or 12) then
_a572(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a1085), _a1120))
return false, "이동이 되돌려짐"
end
end
local _a1121 = _a585.move.hrp()
if _a1086 and _a1121 then
_a572(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a1121.Position - _a1089).Magnitude, tostring(_a585.move.curZone()), tostring(_a585.move.inDottedBox())))
end
return true
end
function _a585.egg.tpEgg(_a1122)
if not _a1122 then return false, "알 id 없음" end
for _a1123, _a1124 in ipairs(_a585.egg.eggStands()) do
if _a1124.id == _a1122 then
if _a1124.dist <= _a578.EggRange then return true, _a1122 end
local _a1125, _a1126 = _a585.move.glideTo(_a1124.pos)
return _a1125, _a1125 and _a1122 or _a1126
end
end
if _a578.TpGameFallback then
local _a1127 = _a583.DirEggs and rawget(_a583.DirEggs, _a1122)
local _a1128 = _a1127 and select(1, _a585.move.zoneByNumber(rawget(_a1127, "zoneNumber")))
if _a1128 and _a585.move.curZone() ~= _a1128 then
local _a1129, _a1130 = _a585.move.tpZone(_a1128)
if not _a1129 then return false, _a1130 end
task.wait(0.5)
_a585.egg._standsAt = nil
for _a1131, _a1132 in ipairs(_a585.egg.eggStands()) do
if _a1132.id == _a1122 then return _a585.move.glideTo(_a1132.pos), _a1122 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a1122) .. ")"
end
function _a585.item.stacks(_a1133)
local _a1134 = _a612()
local _a1135 = _a1134 and rawget(_a1134, "Inventory")
local _a1136 = _a1135 and rawget(_a1135, _a1133)
if type(_a1136) ~= "table" then return {} end
local _a1137 = {}
for _a1138, _a1139 in pairs(_a1136) do
if type(_a1139) == "table" then
_a1137[#_a1137 + 1] = {
uid = _a1138,
id = tostring(rawget(_a1139, "id")),
tier = tonumber(rawget(_a1139, "tn")) or 1,
am = tonumber(rawget(_a1139, "_am")) or 1,
}
end
end
return _a1137
end
_a585.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a585.item.perTier(_a1140, _a1141)
_a1141 = tonumber(_a1141)
local _a1142 = _a583.Bal and rawget(_a583.Bal,
_a1140 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a1142) == "function" then
local _a1143, _a1144 = pcall(_a1142, _a1141)
_a1144 = _a1143 and tonumber(_a1144) or nil
if _a1144 and _a1144 > 0 then return _a1144 end
if not _a1143 and not _a585.item.perTierWarned then
_a585.item.perTierWarned = true
_a572("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a1144) .. ")")
end
end
local _a1145 = _a585.item.PERTIER[_a1140]
local _a1146 = _a1145 and _a1141 and _a1145[_a1141]
return (_a1146 and _a1146 > 0) and _a1146 or nil
end
function _a585.item.upgradeTo(_a1147, _a1148)
local _a1149 = (_a1147 == "Potion") and _a583.R_PotUp or _a583.R_EncUp
if not _a1149 then return 0, (_a1147 .. " 업글 리모트 없음") end
local _a1150 = math.max(1, (tonumber(_a1148) or 2) - 1)
local _a1151 = _a585.item.perTier(_a1147, _a1150)
if not _a1151 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a1150) end
local _a1152, _a1153 = {}, 0
for _a1154, _a1155 in ipairs(_a585.item.stacks(_a1147)) do
if _a1155.tier == _a1150 then
local _a1156 = math.floor(_a1155.am / _a1151)
if _a1156 > 0 then _a1152[_a1155.uid] = _a1156 _a1153 += _a1156 end
end
end
if _a1153 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a1150, _a1150, _a1151) end
local _a1157, _a1158
pcall(function() _a1157, _a1158 = _a1149:InvokeServer(_a1152) end)
if not _a1157 then return 0, tostring(_a1158) end
return _a1153
end
function _a585.item.usePotion(_a1159, _a1160)
if not _a583.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a1159 = tonumber(_a1159) or 1
local _a1161 = {}
for _a1162, _a1163 in ipairs(_a585.item.stacks("Potion")) do
if _a1163.tier >= _a1159 and _a1163.am >= 1 then _a1161[#_a1161 + 1] = _a1163 end
end
if #_a1161 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a1159) end
table.sort(_a1161, function(_a1164, _a1165) return _a1164.tier < _a1165.tier end)
local _a1166, _a1167 = _a1160, 0
for _a1168, _a1169 in ipairs(_a1161) do
for _a1170 = 1, math.min(_a1166, _a1169.am) do
if _a1166 < 1 or not _a579.quest then break end
pcall(function() _a583.R_PotUse:FireServer(_a1169.uid, 1) end)
_a1167 += 1
_a1166 -= 1
task.wait(0.12)
end
if _a1166 < 1 then break end
end
return _a1167
end
_a585.ev.EVENTKIND = {
[31]="CoinJar",    [37]="CoinJar",    [68]="CoinJar",
[32]="Comet",      [38]="Comet",      [69]="Comet",
[66]="Pinata",     [43]="Pinata",     [70]="Pinata",
[67]="LuckyBlock", [44]="LuckyBlock", [71]="LuckyBlock",
}
_a585.ev.BESTONLY = { [37]=true, [38]=true, [43]=true, [44]=true, [39]=true, [76]=true }
_a585.ev.CHESTKIND = { [8]="MiniChests", [39]="MiniChests", [72]="MiniChests",
[75]="SuperiorMiniChests", [76]="SuperiorMiniChests", [77]="SuperiorMiniChests" }
local function _a1171(_a1172)
if typeof(_a1172) == "Vector3" then return _a1172 end
if typeof(_a1172) == "CFrame" then return _a1172.Position end
if type(_a1172) == "table" then
local _a1173, _a1174, _a1175 = tonumber(_a1172.X or _a1172.x or _a1172[1]), tonumber(_a1172.Y or _a1172.y or _a1172[2]), tonumber(_a1172.Z or _a1172.z or _a1172[3])
if _a1173 and _a1174 and _a1175 then return Vector3.new(_a1173, _a1174, _a1175) end
end
return nil
end
function _a585.ev.events()
local _a1176
if _a583.Rand and rawget(_a583.Rand, "GetActive") then
local _a1177, _a1178 = pcall(_a583.Rand.GetActive)
if _a1177 and type(_a1178) == "table" and next(_a1178) then _a1176 = _a1178 end
end
if not _a1176 and _a583.R_Events then
local _a1179, _a1180 = pcall(function() return _a583.R_Events:InvokeServer() end)
if _a1179 and type(_a1180) == "table" then _a1176 = _a1180 end
end
if type(_a1176) ~= "table" then return {} end
local _a1181 = workspace:GetServerTimeNow()
local _a1182 = {}
for _a1183, _a1184 in pairs(_a1176) do
if type(_a1184) == "table" then
local _a1185 = tostring(rawget(_a1184, "id") or "")
local _a1186 = _a1185:match("|%s*(%S+)%s*$") or _a1185
local _a1187 = tonumber(rawget(_a1184, "started")) or 0
local _a1188 = tonumber(rawget(_a1184, "duration")) or 0
_a1182[#_a1182 + 1] = {
uid = rawget(_a1184, "uid"),
id = _a1185,
kind = _a1186,
name = rawget(_a1184, "name") or _a1186,
zone = rawget(_a1184, "parentID"),
pos = _a1171(rawget(_a1184, "origin")),
left = math.max(0, _a1188 - (_a1181 - _a1187)),
}
end
end
table.sort(_a1182, function(_a1189, _a1190) return _a1189.left > _a1190.left end)
return _a1182
end
_a585.ev.SPAWN = {
CoinJar    = { rem = "CoinJar_Spawn",           key = "coin jar",
order = { "basic", "giant", "magic" } },
Comet      = { rem = "Comet_Spawn",             key = "comet" },
Pinata     = { rem = "MiniPinata_Consume",      key = "pinata" },
LuckyBlock = { rem = "MiniLuckyBlock_Consume",  key = "lucky block" },
}
function _a585.move.inDottedBox()
if _a583.Map and rawget(_a583.Map, "IsInDottedBox") then
local _a1191, _a1192 = pcall(_a583.Map.IsInDottedBox)
if _a1191 then return _a1192 and true or false end
end
return nil
end
function _a585.ev.spawnItems(_a1193)
local _a1194 = _a585.ev.SPAWN[_a1193]
if not _a1194 then return {} end
local _a1195 = {}
for _a1196, _a1197 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a1198, _a1199 in ipairs(_a585.item.stacks(_a1197)) do
local _a1200 = _a1199.id:lower()
if _a1200:find(_a1194.key, 1, true) then
local _a1201 = 99
if _a1194.order then
for _a1202, _a1203 in ipairs(_a1194.order) do
if _a1200:find(_a1203, 1, true) then _a1201 = _a1202 break end
end
end
_a1199.rank = _a1201
_a1195[#_a1195 + 1] = _a1199
end
end
end
table.sort(_a1195, function(_a1204, _a1205)
if _a1204.rank ~= _a1205.rank then return _a1204.rank < _a1205.rank end
return _a1204.tier < _a1205.tier
end)
return _a1195
end
function _a585.ev.spawnEvent(_a1206)
local _a1207 = _a585.ev.SPAWN[_a1206]
if not _a1207 then return 0, "소환 불가 종류" end
local _a1208 = _a576:FindFirstChild(_a1207.rem)
if not _a1208 then return 0, _a1207.rem .. " 리모트 없음" end
local _a1209 = _a585.ev.spawnItems(_a1206)
if #_a1209 == 0 then return 0, _a1206 .. " 아이템 없음" end
local _a1210 = _a585.move.inDottedBox()
if _a1210 == false then return 0, "점선 네모 안이 아님" end
local _a1211, _a1212 = 0, nil
for _a1213, _a1214 in ipairs(_a1209) do
if _a1211 >= (_a578.SpawnPerCycle or 1) or not _a579.quest then break end
local _a1215, _a1216
pcall(function() _a1215, _a1216 = _a1208:InvokeServer(_a1214.uid) end)
if _a1215 then
_a1211 += 1
_a585.ctl.setAct("소환", _a1206 .. " · " .. _a1214.id)
_a572(("  🎁 %s 소환  (%s)"):format(_a1206, _a1214.id))
task.wait(0.4)
else
_a1212 = _a1216
break
end
end
return _a1211, _a1212
end
function _a585.ev.findEvent(_a1217, _a1218)
local _a1219 = _a1218 and _a585.move.bestZone() or nil
local _a1220
for _a1221, _a1222 in ipairs(_a585.ev.events()) do
if _a1222.kind == _a1217 and _a1222.left > 15 then
if not _a1218 or _a1222.zone == _a1219 then
if not _a1220 or (_a1222.zone == _a585.move.curZone() and _a1220.zone ~= _a585.move.curZone()) then
_a1220 = _a1222
end
end
end
end
return _a1220
end
function _a585.ev.findChest(_a1223, _a1224)
local _a1225 = workspace:FindFirstChild("__THINGS")
if not _a1225 then return nil end
local _a1226 = tostring(_a1223):lower():find("superior") ~= nil
local _a1227 = _a585.move.hrp()
local _a1228 = _a1227 and _a1227.Position
local _a1229, _a1230, _a1231, _a1232
for _a1233, _a1234 in ipairs(_a1225:GetChildren()) do
if tostring(_a1234.Name):lower():find("chest", 1, true) then
for _a1235, _a1236 in ipairs(_a1234:GetChildren()) do
local _a1237
if _a1236:IsA("BasePart") then _a1237 = _a1236.Position
elseif _a1236:IsA("Model") then
local _a1238, _a1239 = pcall(function() return _a1236:GetPivot() end)
if _a1238 and typeof(_a1239) == "CFrame" then _a1237 = _a1239.Position end
end
if _a1237 then
local _a1240 = _a1228 and (_a1237 - _a1228).Magnitude or 0
local _a1241 = (tostring(_a1236.Name) .. tostring(_a1234.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a1232 or _a1240 < _a1232 then _a1231, _a1232 = _a1237, _a1240 end
if _a1241 == _a1226 and (not _a1230 or _a1240 < _a1230) then
_a1229, _a1230 = _a1237, _a1240
end
end
end
end
end
if _a1229 then return _a1229, _a1230 end
return _a1231, _a1232
end
_a585.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a585.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a585.item.petStacks()
local _a1242 = _a612()
local _a1243 = _a1242 and rawget(_a1242, "Inventory")
local _a1244 = _a1243 and rawget(_a1243, "Pet")
local _a1245 = {}
if type(_a1244) ~= "table" then return _a1245 end
for _a1246, _a1247 in pairs(_a1244) do
if type(_a1247) == "table" then
_a1245[#_a1245 + 1] = {
uid = _a1246,
id = tostring(rawget(_a1247, "id")),
pt = tonumber(rawget(_a1247, "pt")) or 0,
am = tonumber(rawget(_a1247, "_am")) or 1,
}
end
end
return _a1245
end
function _a585.item.bestEggPets()
local _a1248 = _a660()
local _a1249 = _a1248 and _a583.DirEggs and rawget(_a583.DirEggs, _a1248)
local _a1250 = _a1249 and rawget(_a1249, "pets")
local _a1251 = {}
if type(_a1250) == "table" then
for _a1252, _a1253 in pairs(_a1250) do
local _a1254 = type(_a1253) == "table" and _a1253[1] or _a1253
if _a1254 then _a1251[tostring(_a1254)] = true end
end
end
return _a1251, _a1248
end
function _a585.item.makeVariant(_a1255, _a1256)
local _a1257 = (_a1255 == "gold") and _a583.R_Gold or _a583.R_Rain
if not _a1257 then return 0, (_a1255 .. " 머신 리모트 없음") end
local _a1258 = (_a1255 == "gold") and 0 or 1
local _a1259
if _a1256 then
local _a1260, _a1261 = _a585.item.bestEggPets()
if not next(_a1260) then return 0, "최고 알(" .. tostring(_a1261) .. ") 펫 목록을 못 읽음" end
_a1259 = _a1260
end
local _a1262, _a1263 = 0, nil
for _a1264, _a1265 in ipairs(_a585.item.petStacks()) do
if not _a579.quest then break end
if _a1265.pt == _a1258 and _a1265.am >= 10 and (not _a1259 or _a1259[_a1265.id]) then
local _a1266 = math.floor(_a1265.am / 10)
if _a1266 > 0 then
local _a1267, _a1268
pcall(function() _a1267, _a1268 = _a1257:InvokeServer(_a1265.uid, _a1266) end)
if _a1267 then
_a1262 += _a1266
_a572(("  ✨ %s 제작  %s x%d"):format(
_a1255 == "gold" and "골드" or "레인보우", _a1265.id, _a1266))
task.wait(0.4)
else
_a1263 = _a1268
end
end
end
end
return _a1262, _a1263
end
function _a585.item.useFlag(_a1269)
if not _a583.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a1270, _a1271 = 0, nil
for _a1272, _a1273 in ipairs(_a585.item.stacks("Misc")) do
if _a1270 >= (_a1269 or 1) then break end
if _a1273.id:lower():find("flag", 1, true) and _a1273.am >= 1 and _a585.item.itemAllowed(_a1273.id) then
local _a1274, _a1275
pcall(function() _a1274, _a1275 = _a583.R_Flag:InvokeServer(_a1273.id, _a1273.uid, 1) end)
if _a1274 then _a1270 += 1 task.wait(0.4) else _a1271 = _a1275 end
end
end
return _a1270, _a1271
end
function _a585.item.useFruit(_a1276)
if not _a583.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a1277 = _a585.item.activeBuffs("Fruits")
local _a1278 = 0
for _a1279, _a1280 in ipairs(_a585.item.stacks("Fruit")) do
if _a1278 >= (_a1276 or 1) then break end
if _a1280.am >= 1 and _a585.item.itemAllowed(_a1280.id) and not _a1277[_a1280.id] then
pcall(function() _a583.R_Fruit:FireServer(_a1280.uid, 1) end)
_a1278 += 1
task.wait(0.4)
end
end
return _a1278
end
function _a585.quest.status()
local _a1281 = _a612()
if not _a1281 then return nil end
local _a1282 = rawget(_a1281, "Goals")
if type(_a1282) ~= "table" then return { list = {} } end
local _a1283 = {}
for _a1284, _a1285 in pairs(_a1282) do
if type(_a1285) == "table" then
local _a1286 = tonumber(rawget(_a1285, "Type")) or -1
local _a1287
if _a583.Quest and rawget(_a583.Quest, "MakeTitle") then
local _a1288, _a1289 = pcall(_a583.Quest.MakeTitle, _a1285)
if _a1288 then _a1287 = _a1289 end
end
_a1283[#_a1283 + 1] = {
slot = _a1284,
uid = tostring(rawget(_a1285, "UID")),
type = _a1286,
how = _a584[_a1286],
title = _a1287 or ("Type " .. _a1286),
amount = tonumber(rawget(_a1285, "Amount")) or 0,
progress = tonumber(rawget(_a1285, "Progress")) or 0,
stars = tonumber(rawget(_a1285, "Stars")) or 0,
potionTier = tonumber(rawget(_a1285, "PotionTier")),
enchantTier = tonumber(rawget(_a1285, "EnchantTier")),
breakable = rawget(_a1285, "BreakableType") or rawget(_a1285, "BreakableDirID"),
zoneId = rawget(_a1285, "ZoneID"),
where = _a585.quest.WHERE[_a1286] or (_a584[_a1286] == "farm" and "bestzone" or nil),
event = _a585.ev.EVENTKIND[_a1286],
chest = _a585.ev.CHESTKIND[_a1286],
bestOnly = _a585.ev.BESTONLY[_a1286] or false,
ignored = _a585.quest.IGNORE[_a1286],
}
end
end
table.sort(_a1283, function(_a1290, _a1291) return _a1290.stars > _a1291.stars end)
return { list = _a1283, rank = tonumber(rawget(_a1281, "Rank")) or 1,
rankStars = tonumber(rawget(_a1281, "RankStars")) or 0 }
end
_a585.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a585.quest.bestDepActive()
local _a1292 = _a585.ctl.lockGoal and _a585.ctl.lockGoal.q
if not _a1292 then return false end
if _a585.quest.IGNORE[_a1292.type] then return false end
if not _a585.quest.BESTDEP[_a1292.type] then return false end
local _a1293 = _a585.quest.findQuest(_a1292.uid)
if not _a1293 or _a1293.progress >= _a1293.amount then return false end
return true, _a1293
end
function _a585.quest.canDo(_a1294, _a1295)
if _a1294.how == "hatch" or _a1294.where == "bestegg" then
local _a1296 = _a685()
if not _a1296 then return false, "알 정보를 못 읽음" end
if not _a1296.price then return true end
if not _a1295 then
if _a1296.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a1296.id), _a573(_a1296.price, 0), tostring(_a1296.currency), _a573(_a1296.have, 0))
end
return true
end
local _a1297 = math.max(1, (_a1294.amount or 1) - (_a1294.progress or 0))
local _a1298 = _a1297
if _a1294.type == 2 or _a1294.type == 42 or _a1294.type == 47 then
_a1298 = math.max(_a1297, _a578.HatchMinAfford or 10)
end
if _a1296.canBuy < _a1298 then
_a585.quest.moneyUntil = os.clock() + math.max(0, _a578.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a1298, _a1296.canBuy, _a573(_a1296.price, 0), tostring(_a1296.currency))
end
if _a585.quest.moneyUntil and os.clock() < _a585.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a585.quest.moneyUntil - os.clock())
end
_a585.quest.moneyUntil = nil
end
return true
end
function _a585.quest.findQuest(_a1299)
local _a1300 = _a585.quest.status()
for _a1301, _a1302 in ipairs(_a1300 and _a1300.list or {}) do
if _a1302.uid == _a1299 then return _a1302 end
end
return nil
end
function _a585.quest.pursue(_a1303)
local _a1304, _a1305
if _a1303.how == "hatch" then _a1304, _a1305 = _a696, "mhatch"
elseif _a1303.how == "zone" then _a1304, _a1305 = _a655, "zone"
elseif _a1303.how == "gold" or _a1303.how == "rainbow" then
local _a1306 = (_a1303.type == 40 or _a1303.type == 41)
_a1305 = "quest"
_a1304 = function()
local _a1307 = _a585.item.makeVariant("gold", _a1306) or 0
if _a1303.how == "rainbow" then
_a1307 += (_a585.item.makeVariant("rainbow", _a1306) or 0)
end
if _a1307 > 0 then
_a585.ctl.setAct(_a1303.how == "gold" and "골드 합성" or "레인보우 합성", _a1307 .. "마리")
return
end
_a585.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a1308 = _a579.mhatch
_a579.mhatch = true
pcall(_a696)
_a579.mhatch = _a1308
end
end
local _a1309 = _a1303.progress
local _a1310 = os.clock()
_a585.ctl.setGoal(_a1303.title, ("%d/%d"):format(_a1303.progress, _a1303.amount))
local function _a1311()
if not _a1303.event then return end
local _a1312 = _a585.ev.findEvent(_a1303.event, _a1303.bestOnly)
if _a1312 then
_a585.ctl.setAct(_a1303.event .. " 진행 중", ("%d초 남음"):format(_a1312.left))
if _a1312.pos then
local _a1313 = _a585.move.hrp()
if _a1313 and (_a1313.Position - _a1312.pos).Magnitude > (_a578.EventStayDist or 45) then
_a585.move.glideTo(_a1312.pos)
end
end
return
end
local _a1314, _a1315 = _a585.ev.spawnEvent(_a1303.event)
if _a1314 > 0 then
_a585.ctl.setAct("소환", _a1303.event)
task.wait(0.5)
elseif _a1315 and _a585.ev.spawnErr ~= tostring(_a1315) then
_a585.ev.spawnErr = tostring(_a1315)
_a572("[퀘스트] " .. _a1303.event .. " 소환 실패: " .. tostring(_a1315))
end
end
local _a1316, _a1317 = pcall(function()
while _a579.quest and not _a585.ctl.stopped() do
local _a1318, _a1319 = _a585.quest.canDo(_a1303, false)
if not _a1318 then
_a572(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a1303.title), tostring(_a1319)))
return
end
_a1311()
if _a1304 then
local _a1320 = _a579[_a1305]
_a579[_a1305] = true
local _a1321, _a1322 = pcall(_a1304)
_a579[_a1305] = _a1320
if not _a1321 then error(_a1322, 0) end
elseif _a1303.event then
task.wait(0.4)
else
task.wait(2)
end
local _a1323 = _a585.quest.findQuest(_a1303.uid)
if not _a1323 then
_a572("[퀘스트] 완료 — " .. tostring(_a1303.title))
return
end
_a585.ctl.setGoal(_a1323.title, ("%d/%d"):format(_a1323.progress, _a1323.amount))
if _a1323.progress >= _a1323.amount then
_a572(("[퀘스트] 달성 %d/%d — %s"):format(_a1323.progress, _a1323.amount, tostring(_a1323.title)))
return
end
if _a1323.progress > _a1309 then
_a1310 = os.clock()
_a572(("[퀘스트] %d/%d  %s"):format(_a1323.progress, _a1323.amount, tostring(_a1323.title)))
end
_a1309 = _a1323.progress
local _a1324 = os.clock() - _a1310
if _a1324 >= math.max(10, _a578.PursueStallSec or 60) then
_a572(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a1324, _a1323.progress, _a1323.amount, tostring(_a1323.title)))
return
end
task.wait(0.2)
end
end)
if not _a1316 then _a572("[퀘스트] " .. tostring(_a1303.how) .. " 오류: " .. tostring(_a1317)) end
_a585.ctl.lockGoal = nil
_a585.ctl.setGoal(nil)
end
function _a585.quest.cycle()
do
local _a1325 = _a579.rank
_a579.rank = true
pcall(_a747)
_a579.rank = _a1325
end
local _a1326 = _a585.quest.status()
if not _a1326 then return end
local _a1327, _a1328, _a1329 = false, false, false
local _a1330 = {}
local _a1331 = nil
for _a1332, _a1333 in ipairs(_a1326.list) do
if not _a579.quest then break end
local _a1334, _a1335 = true, nil
if not _a1333.ignored and _a1333.progress < _a1333.amount then
_a1334, _a1335 = _a585.quest.canDo(_a1333, true)
end
if _a1333.ignored then
if _a1333.progress < _a1333.amount then
_a1330[#_a1330 + 1] = tostring(_a1333.title) .. "  — " .. _a1333.ignored
end
elseif not _a1334 then
local _a1336 = tostring(_a1333.uid) .. tostring(_a1335)
if _a585.item.skipSaid ~= _a1336 then
_a585.item.skipSaid = _a1336
_a572(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a1333.title), tostring(_a1335)))
end
elseif _a1333.progress < _a1333.amount then
local _a1337 = _a1333.where
if _a1333.event then
if not _a1331 or _a1331.rank > 0 then _a1331 = { rank = 0, kind = "event", q = _a1333 } end
elseif _a1333.chest then
if not _a1331 or _a1331.rank > 1 then _a1331 = { rank = 1, kind = "chest", q = _a1333 } end
elseif _a1337 == "bestegg" then
if not _a1331 or _a1331.rank > 1 then _a1331 = { rank = 1, kind = "egg", q = _a1333 } end
elseif _a1337 == "breakable" and _a1333.breakable then
if not _a1331 or _a1331.rank > 2 then _a1331 = { rank = 2, kind = "breakable", q = _a1333 } end
elseif _a1337 == "zoneid" and _a1333.zoneId then
if not _a1331 or _a1331.rank > 2 then _a1331 = { rank = 2, kind = "zoneid", q = _a1333 } end
elseif _a1337 == "bestzone" or _a1337 == "breakable" then
if not _a1331 then _a1331 = { rank = 3, kind = "bestzone", q = _a1333 } end
end
if _a1333.how == "farm" then
_a1327 = true
elseif _a1333.how == "hatch" then
_a1328 = true
elseif _a1333.how == "zone" then
_a1329 = true
elseif _a1333.how == "potup" and _a578.QuestUpgrade then
local _a1338, _a1339 = _a585.item.upgradeTo("Potion", _a1333.potionTier or 2)
if _a1338 > 0 then
_a580.potup += _a1338
_a580.quest += 1
_a572(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a1333.potionTier or 2, _a1338, _a1333.title))
elseif _a1339 and not tostring(_a1339):find("부족") then
if _a585.item.potUpSaid ~= tostring(_a1339) then
_a585.item.potUpSaid = tostring(_a1339)
_a572("[퀘스트] 포션 업글 실패: " .. tostring(_a1339))
end
end
elseif _a1333.how == "encup" and _a578.QuestUpgrade then
local _a1340, _a1341 = _a585.item.upgradeTo("Enchant", _a1333.enchantTier or 2)
if _a1340 > 0 then
_a580.potup += _a1340
_a580.quest += 1
_a572(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a1333.enchantTier or 2, _a1340, _a1333.title))
elseif _a1341 and not tostring(_a1341):find("부족") then
if _a585.item.encUpSaid ~= tostring(_a1341) then
_a585.item.encUpSaid = tostring(_a1341)
_a572("[퀘스트] 인챈트 업글 실패: " .. tostring(_a1341))
end
end
elseif _a1333.how == "potuse" and _a578.QuestUsePotion then
_a585.item.lastUse = _a585.item.lastUse or {}
local _a1342 = _a585.item.lastUse[_a1333.uid]
if _a1342 and _a1342.used > 0 and _a1333.progress <= _a1342.progress then
if not _a1342.gaveUp then
_a1342.gaveUp = true
_a572("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a1333.title))
end
else
local _a1343 = math.min(_a578.QuestUseMax, math.max(1, _a1333.amount - _a1333.progress))
local _a1344, _a1345 = _a585.item.usePotion(_a1333.potionTier or 1, _a1343)
_a585.item.lastUse[_a1333.uid] = { used = _a1344, progress = _a1333.progress }
if _a1344 > 0 then
_a580.potuse += _a1344
_a580.quest += 1
_a572(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a1344, _a1333.title))
elseif _a1345 and not tostring(_a1345):find("없음") then
_a572("[퀘스트] 포션 사용 실패: " .. tostring(_a1345))
end
end
elseif _a1333.how == "gold" or _a1333.how == "rainbow" then
local _a1346, _a1347 = _a585.item.makeVariant(_a1333.how, _a1333.type == 40 or _a1333.type == 41)
if _a1346 > 0 then
_a580.quest += 1
_a572(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a1333.how == "gold" and "골드" or "레인보우", _a1346, _a1333.title))
elseif _a1347 then
_a572("[퀘스트] " .. _a1333.how .. " 실패: " .. tostring(_a1347))
end
elseif _a1333.how == "fruituse" then
local _a1348 = _a585.item.useFruit(math.max(1, _a1333.amount - _a1333.progress))
if _a1348 > 0 then
_a580.quest += 1
_a572(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a1348, _a1333.title))
end
elseif _a1333.how == "flaguse" then
local _a1349, _a1350 = _a585.item.useFlag(math.max(1, _a1333.amount - _a1333.progress))
if _a1349 > 0 then
_a580.quest += 1
_a572(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a1349, _a1333.title))
elseif _a1350 then
_a572("[퀘스트] 깃발 실패: " .. tostring(_a1350))
end
elseif not _a1333.how then
_a1330[#_a1330 + 1] = _a1333.title
end
end
end
if _a578.QuestLock and _a585.ctl.lockGoal then
local _a1351
for _a1352, _a1353 in ipairs(_a1326.list) do
if _a1353.uid == _a585.ctl.lockGoal.q.uid and _a1353.progress < _a1353.amount then _a1351 = _a1353 break end
end
if _a1351 then
_a585.ctl.lockGoal.q = _a1351
_a1331 = _a585.ctl.lockGoal
else
if _a585.ctl.lockGoal.q then
_a572("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a585.ctl.lockGoal.q.title))
end
_a585.ctl.lockGoal = nil
end
end
if _a578.QuestLock and _a1331 then _a585.ctl.lockGoal = _a1331 end
if _a578.QuestTp and _a1331 and _a579.quest then
local _a1354, _a1355, _a1356
if _a1331.kind == "event" then
local _a1357 = _a585.ev.findEvent(_a1331.q.event, _a1331.q.bestOnly)
if _a1357 then
_a1356 = ("%s @%s (%d초 남음)"):format(_a1357.name, tostring(_a1357.zone), _a1357.left)
if _a1357.pos then _a1354, _a1355 = _a585.move.glideTo(_a1357.pos)
else _a1354, _a1355 = _a585.move.goToZone(_a1357.zone) end
else
local _a1358 = _a1331.q.bestOnly and _a585.move.bestZone() or (_a585.move.curZone() or _a585.move.bestZone())
_a1356 = _a1331.q.event .. " 소환용 " .. tostring(_a1358)
local _a1359 = _a585.move.inDottedBox()
_a1354, _a1355 = _a585.move.goToZone(_a1358, false, _a1359 == false, _a1331.q.bestOnly)
if _a1354 then
local _a1360, _a1361 = _a585.ev.spawnEvent(_a1331.q.event)
if _a1360 < 1 and tostring(_a1361):find("점선") then
_a585.move.goToZone(_a1358, false, true)
task.wait(0.2)
_a1360, _a1361 = _a585.ev.spawnEvent(_a1331.q.event)
end
if _a1360 > 0 then
_a1356 = ("%s %d개 소환 @%s"):format(_a1331.q.event, _a1360, tostring(_a1358))
else
_a1355 = _a1361
_a1354 = false
end
end
end
elseif _a1331.kind == "chest" then
local _a1362 = _a1331.q.bestOnly and _a585.move.bestZone() or _a585.move.curZone()
local _a1363, _a1364 = _a585.ev.findChest(_a1331.q.chest, _a1362)
_a1356 = _a1331.q.chest .. " @" .. tostring(_a1362)
if _a1363 then
if not _a1364 or _a1364 > 20 then _a585.move.glideTo(_a1363) end
_a1354 = true
else
_a1354, _a1355 = _a585.move.goToZone(_a1362)
_a1356 = _a1356 .. " (상자 없음 → 존 가운데)"
end
elseif _a1331.kind == "egg" then
local _a1365 = _a660()
_a1356 = "최고 알 " .. tostring(_a1365)
if _a1365 then _a1354, _a1355 = _a585.egg.tpEgg(_a1365) else _a1355 = "최고 알을 못 찾음" end
elseif _a1331.kind == "breakable" then
local _a1366 = _a585.move.zoneForBreakable(_a1331.q.breakable)
_a1356 = tostring(_a1331.q.breakable) .. " 나오는 존 " .. tostring(_a1366)
if _a1366 then _a1354, _a1355 = _a585.move.goToZone(_a1366, true) else _a1355 = "그 브레이커블이 나오는 존이 없음" end
elseif _a1331.kind == "zoneid" then
_a1356 = "존 " .. tostring(_a1331.q.zoneId)
_a1354, _a1355 = _a585.move.goToZone(_a1331.q.zoneId)
else
local _a1367 = _a585.move.bestZone()
local _a1368 = _a1331.q.bestOnly or _a585.quest.BESTDEP[_a1331.q.type] or false
if _a1367 then _a1354, _a1355 = _a585.move.goToZone(_a1367, true, false, _a1368)
else _a1355 = "최고 존을 못 찾음" end
_a1356 = "최고 존 " .. tostring(_a585.move.arrivedZone or _a1367)
if not _a1354 then _a1355 = _a1367 end
end
if _a1354 then
if _a585.quest.lastGoal ~= _a1356 then
_a585.quest.lastGoal = _a1356
_a572("[퀘스트] " .. _a1356 .. " 으로 이동  (" .. tostring(_a1331.q.title) .. ")")
end
_a585.quest.pursue(_a1331.q)
else
local _a1369 = _a1355 and tostring(_a1355) or "이유 불명"
if _a585.quest.lastFail ~= _a1369 then
_a585.quest.lastFail = _a1369
_a572(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a1369, tostring(_a1331.kind), tostring(_a1331.q.title)))
_a572(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a585.move.curZone()), tostring(_a585.move.bestZone()), tostring(_a585.move.inDottedBox())))
end
end
end
if _a578.QuestDrive and _a585.auto.turnOn then
if _a1327  then _a585.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a1329  then _a585.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a1328 then _a585.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a1330 > 0 and not _a585.quest.manualWarned then
_a585.quest.manualWarned = true
_a572("[퀘스트] 수동으로 해야 하는 것:")
for _a1370, _a1371 in ipairs(_a1330) do _a572("    · " .. tostring(_a1371)) end
elseif #_a1330 == 0 then
_a585.quest.manualWarned = false
end
return _a1331 ~= nil
end
local function _a1372(_a1373)
local _a1374 = {}
for _a1375 in tostring(_a1373 or ""):gmatch("[^,]+") do
_a1375 = _a1375:match("^%s*(.-)%s*$")
if _a1375 ~= "" then _a1374[#_a1374 + 1] = _a1375:lower() end
end
return _a1374
end
function _a585.item.itemAllowed(_a1376)
local _a1377 = tostring(_a1376):lower()
for _a1378, _a1379 in ipairs(_a1372(_a578.ItemBlock)) do
if _a1377:find(_a1379, 1, true) then return false end
end
local _a1380 = _a1372(_a578.ItemAllow)
if #_a1380 == 0 then return true end
for _a1381, _a1382 in ipairs(_a1380) do
if _a1377:find(_a1382, 1, true) then return true end
end
return false
end
function _a585.item.activeBuffs(_a1383)
local _a1384 = _a612()
local _a1385 = _a1384 and rawget(_a1384, _a1383)
local _a1386 = {}
if type(_a1385) == "table" then
for _a1387, _a1388 in pairs(_a1385) do
if type(_a1388) == "table" and next(_a1388) then _a1386[_a1387] = true
elseif _a1388 then _a1386[_a1387] = true end
end
end
return _a1386
end
local function _a1389(_a1390, _a1391, _a1392, _a1393)
local _a1394 = _a585.item.activeBuffs(_a1391)
local _a1395 = {}
local _a1396 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a1397, _a1398 in ipairs(_a585.item.stacks(_a1390)) do
_a1396.total += 1
if _a1394[_a1398.id] then _a1396.act += 1
elseif not _a585.item.itemAllowed(_a1398.id) then _a1396.blocked += 1
elseif _a1398.am <= _a578.ItemKeep then _a1396.few += 1
else
_a1396.ok += 1
local _a1399 = _a1395[_a1398.id]
local _a1400
if not _a1399 then _a1400 = true
elseif _a578.BuffHighTier then _a1400 = _a1398.tier > _a1399.tier
else _a1400 = _a1398.tier < _a1399.tier end
if _a1400 then _a1395[_a1398.id] = _a1398 end
end
end
if _a1396.ok == 0 and _a1396.total > 0 then
local _a1401 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a1390, _a1396.total, _a1396.act, _a1396.blocked, _a1396.few)
if _a585.item.buffSaid ~= _a1401 then
_a585.item.buffSaid = _a1401
_a572("[아이템] " .. _a1401)
end
elseif _a1396.ok > 0 then
_a585.item.buffSaid = nil
end
local _a1402 = {}
for _a1403, _a1404 in pairs(_a1395) do _a1402[#_a1402 + 1] = _a1404 end
table.sort(_a1402, function(_a1405, _a1406)
if _a1405.tier ~= _a1406.tier then return _a1405.tier > _a1406.tier end
return _a1405.am > _a1406.am
end)
local _a1407 = {}
for _a1408, _a1409 in ipairs(_a1402) do
if not _a579.items then break end
if _a1393 and _a1393.left <= 0 then break end
local _a1410 = pcall(function() _a1392(_a1409.uid, 1) end)
if _a1410 then
_a1407[#_a1407 + 1] = ("%s T%d"):format(_a1409.id, _a1409.tier)
_a580.items += 1
if _a1393 then _a1393.left -= 1 end
task.wait(0.12)
end
end
return _a1407
end
function _a585.item.cycleItems()
local function _a1411()
local _a1412 = {}
if _a578.BuffPotion then _a1412[#_a1412 + 1] = { "Potion", "Potions" } end
if _a578.BuffFruit then _a1412[#_a1412 + 1] = { "Fruit", "Fruits" } end
if _a578.BuffConsumable then _a1412[#_a1412 + 1] = { "Consumable", "Consumables" } end
for _a1413, _a1414 in ipairs(_a1412) do
local _a1415 = _a585.item.activeBuffs(_a1414[2])
for _a1416, _a1417 in ipairs(_a585.item.stacks(_a1414[1])) do
if _a1417.am > _a578.ItemKeep and _a585.item.itemAllowed(_a1417.id) and not _a1415[_a1417.id] then
return true
end
end
end
if _a578.BuffUltimate and _a583.R_Ult then
local _a1418 = _a612()
local _a1419 = _a1418 and rawget(_a1418, "Ultimates")
if type(_a1419) == "table" then
for _a1420 in pairs(_a1419) do
if _a585.item.itemAllowed(_a1420) then
if not (_a583.Ult and rawget(_a583.Ult, "IsCharged")) then return true end
local _a1421, _a1422 = pcall(_a583.Ult.IsCharged, _a1420)
if _a1421 and _a1422 then return true end
end
end
end
end
return false
end
if not _a1411() then return end
if _a578.ItemBestZone then
local _a1423 = _a585.move.bestZone()
if _a1423 and _a585.move.curZone() ~= _a1423 then
if not _a578.ItemTp then
if not _a585.item.itemZoneWarned then
_a585.item.itemZoneWarned = true
_a572(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a1423), tostring(_a585.move.curZone())))
end
return
end
local _a1424, _a1425 = _a585.move.goToZone(_a1423)
if not _a1424 then
_a572("[아이템] 최고 존 이동 실패: " .. tostring(_a1425))
return
end
_a572("[아이템] 최고 존 " .. tostring(_a1423) .. " 에서 사용")
end
_a585.item.itemZoneWarned = false
end
local _a1426 = {}
local _a1427  = { left = math.max(1, _a578.BuffMaxPotion or 5) }
local _a1428 = { left = math.max(1, _a578.BuffMaxOther or 2) }
if _a578.BuffPotion and _a583.R_PotUse then
local _a1429 = _a1389("Potion", "Potions", function(_a1430, _a1431)
_a583.R_PotUse:FireServer(_a1430, _a1431)
end, _a1427)
for _a1432, _a1433 in ipairs(_a1429) do _a1426[#_a1426 + 1] = "포션 " .. _a1433 end
end
if _a578.BuffFruit and _a583.R_Fruit then
local _a1434 = _a1389("Fruit", "Fruits", function(_a1435, _a1436)
_a583.R_Fruit:FireServer(_a1435, _a1436)
end, _a1428)
for _a1437, _a1438 in ipairs(_a1434) do _a1426[#_a1426 + 1] = "과일 " .. _a1438 end
end
if _a578.BuffConsumable and _a583.R_Cons then
local _a1439 = _a1389("Consumable", "Consumables", function(_a1440, _a1441)
_a583.R_Cons:InvokeServer(_a1440, _a1441)
end, _a1428)
for _a1442, _a1443 in ipairs(_a1439) do _a1426[#_a1426 + 1] = "소모품 " .. _a1443 end
end
if _a578.BuffUltimate and _a583.R_Ult then
local _a1444 = _a612()
local _a1445 = _a1444 and rawget(_a1444, "Ultimates")
if type(_a1445) == "table" then
for _a1446 in pairs(_a1445) do
if not _a579.items then break end
if _a585.item.itemAllowed(_a1446) then
local _a1447 = true
if _a583.Ult and rawget(_a583.Ult, "IsCharged") then
local _a1448, _a1449 = pcall(_a583.Ult.IsCharged, _a1446)
_a1447 = _a1448 and _a1449 and true or false
end
if _a1447 then
local _a1450
pcall(function() _a1450 = _a583.R_Ult:InvokeServer(_a1446) end)
if _a1450 then
_a1426[#_a1426 + 1] = "얼티밋 " .. tostring(_a1446)
_a580.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a1426 > 0 then
_a585.ctl.setAct("버프 사용", table.concat(_a1426, ", "))
_a572("[아이템] " .. table.concat(_a1426, ", ") .. " 사용")
end
end
function _a585.mach.slotStatus()
local _a1451 = _a612()
if not _a1451 then return nil end
local _a1452 = tonumber(rawget(_a1451, "PetSlotsPurchased")) or 0
local _a1453 = tonumber(rawget(_a1451, "EggSlotsPurchased")) or 0
local _a1454, _a1455 = 0, 0
if _a583.RankC then
if rawget(_a583.RankC, "GetMaxPurchasableEquipSlots") then
local _a1456, _a1457 = pcall(_a583.RankC.GetMaxPurchasableEquipSlots)
if _a1456 and tonumber(_a1457) then _a1454 = tonumber(_a1457) end
end
if rawget(_a583.RankC, "GetMaxPurchasableEggSlots") then
local _a1458, _a1459 = pcall(_a583.RankC.GetMaxPurchasableEggSlots)
if _a1458 and tonumber(_a1459) then _a1455 = tonumber(_a1459) end
end
end
local _a1460, _a1461
if _a1452 < _a1454 then
_a1460 = _a1452 + 1
if type(_a583.CalcPetS) == "function" then
local _a1462, _a1463 = pcall(_a583.CalcPetS, _a1460)
if _a1462 then _a1461 = tonumber(_a1463) end
end
end
local _a1464, _a1465, _a1466
if _a1453 < _a1455 and _a583.RankC and rawget(_a583.RankC, "GetEggBundle") then
local _a1467, _a1468, _a1469 = pcall(_a583.RankC.GetEggBundle, _a1453 + 1)
if _a1467 and tonumber(_a1468) then
_a1464, _a1465 = tonumber(_a1468), tonumber(_a1469) or 1
if type(_a583.CalcEggS) == "function" then
local _a1470, _a1471 = 0, false
for _a1472 = _a1464 - _a1465 + 1, _a1464 do
local _a1473, _a1474 = pcall(_a583.CalcEggS, _a1472)
if _a1473 and tonumber(_a1474) then _a1470 += tonumber(_a1474) else _a1471 = true end
end
if not _a1471 then _a1466 = _a1470 end
end
end
end
local _a1475
if _a583.Egg and rawget(_a583.Egg, "GetMaxHatch") then
local _a1476, _a1477 = pcall(_a583.Egg.GetMaxHatch)
if _a1476 then _a1475 = tonumber(_a1477) end
end
return {
dia = _a627("Diamonds"),
petOwned = _a1452, petMax = _a1454, petNext = _a1460, petCost = _a1461,
eggOwned = _a1453, eggMax = _a1455, eggEnd = _a1464, eggSize = _a1465, eggCost = _a1466,
maxEquip = tonumber(rawget(_a1451, "MaxPetsEquipped")), maxHatch = _a1475,
}
end
function _a585.move.machinePos(_a1478)
local _a1479
if _a583.Machine and rawget(_a583.Machine, "GetModels") then
local _a1480, _a1481 = pcall(_a583.Machine.GetModels, _a1478)
if _a1480 and type(_a1481) == "table" then
for _a1482, _a1483 in pairs(_a1481) do
if typeof(_a1483) == "Instance" then _a1479 = _a1483 break end
end
end
end
if not _a1479 then
local _a1484, _a1485 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a1484 then
for _a1486, _a1487 in ipairs(_a1485) do
if _a1487.Name == _a1478 then _a1479 = _a1487 break end
end
end
end
if not _a1479 then return nil end
if _a1479:IsA("BasePart") then return _a1479.Position end
local _a1488, _a1489 = pcall(function() return _a1479:GetPivot() end)
return (_a1488 and typeof(_a1489) == "CFrame") and _a1489.Position or nil
end
function _a585.mach.cycleSlots()
local _a1490 = 0
local _a1491 = 0
while _a579.slots and not _a585.ctl.stopped() and _a1491 < 40 do
_a1491 += 1
local _a1492 = _a585.mach.slotStatus()
if not _a1492 then return end
local _a1493 = _a578.SlotPet and _a1492.petNext and _a1492.petCost
and (_a1492.dia - _a578.SlotReserve) >= _a1492.petCost
local _a1494 = _a578.SlotEgg and _a1492.eggEnd and _a1492.eggCost
and (_a1492.dia - _a578.SlotReserve) >= _a1492.eggCost
if _a1493 and _a1494 then
if _a1492.eggCost < _a1492.petCost then _a1493 = false else _a1494 = false end
end
if not (_a1493 or _a1494) then break end
local _a1495, _a1496, _a1497, _a1498
local function _a1499()
if _a1493 then
pcall(function() _a1495, _a1496 = _a583.R_PetSlot:InvokeServer(_a1492.petNext) end)
else
pcall(function() _a1495, _a1496 = _a583.R_EggSlot:InvokeServer(_a1492.eggEnd) end)
end
end
if _a1493 then
_a1497 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a1492.petNext, _a573(_a1492.petCost, 0))
_a1498 = "EquipSlotsMachine"
else
_a1497 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a1492.eggSize, _a1492.eggEnd, _a573(_a1492.eggCost, 0))
_a1498 = "EggSlotsMachine"
end
_a1499()
if not _a1495 and tostring(_a1496):find("far away") then
local _a1500 = _a585.move.machinePos(_a1498)
if _a1500 then
_a585.ctl.setAct("슬롯 머신으로 이동", _a1498)
_a585.move.glideTo(_a1500)
task.wait(0.25)
_a1495, _a1496 = nil, nil
_a1499()
else
_a1496 = "머신 위치를 못 찾음 (" .. _a1498 .. ")"
end
end
if _a1495 then
_a1490 += 1
_a580.mslot += 1
_a585.mach.slotSaid = nil
_a585.ctl.setAct("슬롯 구매", _a1497)
_a572("  ⬆ " .. _a1497)
task.wait(0.35)
else
local _a1501 = _a1497 .. " 실패: " .. tostring(_a1496)
if _a585.mach.slotSaid ~= _a1501 then
_a585.mach.slotSaid = _a1501
_a572("[슬롯] " .. _a1501)
end
break
end
end
if _a1490 > 0 then
local _a1502 = _a585.mach.slotStatus()
_a572(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a1490, tostring(_a1502 and _a1502.maxEquip), tostring(_a1502 and _a1502.maxHatch),
_a573(_a627("Diamonds"), 0)))
end
end
function _a585.mach.upgList()
local _a1503 = {}
if not _a583.Upg then return _a1503 end
local _a1504, _a1505 = pcall(_a583.Upg.All)
if not (_a1504 and type(_a1505) == "table") then return _a1503 end
for _a1506, _a1507 in ipairs(_a1505) do
local _a1508, _a1509, _a1510 = rawget(_a1507, "UpgradeID"), rawget(_a1507, "ZoneID"), rawget(_a1507, "UpgradeTier")
if _a1508 and _a1509 and _a1510 then
local _a1511 = false
if rawget(_a583.Upg, "Owns") then
local _a1512, _a1513 = pcall(_a583.Upg.Owns, _a1508, _a1509)
_a1511 = _a1512 and _a1513 and true or false
end
local _a1514 = _a585.move.ownsZone(_a1509)
local _a1515 = _a583.DirUpg and rawget(_a583.DirUpg, _a1508)
local _a1516 = _a1515 and rawget(_a1515, "TierCosts")
local _a1517 = _a1516 and tonumber(_a1516[_a1510])
local _a1518 = "Diamonds"
local _a1519 = _a1515 and rawget(_a1515, "TierCurrencies")
local _a1520 = _a1519 and _a1519[_a1510]
if type(_a1520) == "table" and rawget(_a1520, "_id") then _a1518 = rawget(_a1520, "_id") end
local _a1521 = rawget(_a1507, "Model")
local _a1522
if typeof(_a1521) == "Instance" then
if _a1521:IsA("BasePart") then _a1522 = _a1521.Position
else
local _a1523, _a1524 = pcall(function() return _a1521:GetPivot() end)
if _a1523 and _a1524 then _a1522 = _a1524.Position end
end
end
_a1503[#_a1503 + 1] = {
id = _a1508, zone = _a1509, tier = _a1510, cost = _a1517, cur = _a1518,
bought = _a1511, zoneOwned = _a1514,
buyable = _a1514 and not _a1511,
pos = _a1522, model = _a1521,
}
end
end
table.sort(_a1503, function(_a1525, _a1526) return (_a1525.cost or math.huge) < (_a1526.cost or math.huge) end)
return _a1503
end
function _a585.mach.cycleUpg()
if not _a583.R_Upg then _a572("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a1527 = _a585.mach.upgList()
if #_a1527 == 0 then return end
local _a1528 = 0
for _a1529, _a1530 in ipairs(_a1527) do
if not _a579.mapupg then break end
if _a1530.buyable and _a1530.cost then
local _a1531 = _a627(_a1530.cur or "Diamonds")
if _a1531 - _a578.UpgReserve < _a1530.cost then break end
if _a578.UpgTp and _a1530.pos and _a1530.zone == _a585.move.curZone() then
_a585.move.glideTo(_a1530.pos)
end
local _a1532, _a1533
pcall(function() _a1532, _a1533 = _a583.R_Upg:InvokeServer(_a1530.id, _a1530.zone) end)
if _a1532 then
_a1528 += 1
_a580.mapupg += 1
_a585.ctl.setAct("맵 업글", _a1530.id .. " T" .. _a1530.tier)
_a572(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a1530.id, _a1530.tier, _a1530.zone, _a573(_a1530.cost, 0)))
elseif _a1533 then
_a572(("[맵업글] %s T%d @%s 실패: %s"):format(
_a1530.id, _a1530.tier, _a1530.zone, tostring(_a1533)))
end
task.wait(_a578.ActionGap)
end
end
if _a1528 > 0 then
_a572(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a1528, _a573(_a627("Diamonds"), 0)))
end
end
local function _a1534()
local _a1535 = _a612()
if not _a1535 then return nil end
local _a1536 = tonumber(rawget(_a1535, "Rebirths")) or 0
local _a1537 = _a1536 + 1
local _a1538
if _a583.Rebirth and rawget(_a583.Rebirth, "GetNextRebirth") then
local _a1539, _a1540 = pcall(_a583.Rebirth.GetNextRebirth, _a1535)
if _a1539 then _a1538 = _a1540 end
end
return { current = _a1536, nextN = _a1537, def = _a1538 }
end
local function _a1541()
if not _a583.R_Reb then _a572("[리버스] Rebirth_Request 리모트 없음") return end
local _a1542 = _a1534()
if not _a1542 then
_a585.auto.rebNote = "세이브를 못 읽음"
return
end
local _a1543, _a1544
pcall(function() _a1543, _a1544 = _a583.R_Reb:InvokeServer(_a1542.nextN) end)
if _a1543 then
_a580.mreb += 1
_a585.auto.rebNote, _a585.auto.rebSaid = nil, nil
_a572(("  ★ 리버스 %d → %d"):format(_a1542.current, _a1542.nextN))
task.wait(0.5)
_a585.screen.dismissRewardScreens(25)
else
_a585.auto.rebNote = ("%d → %d : %s"):format(_a1542.current, _a1542.nextN,
_a1544 and tostring(_a1544) or "조건 미달 (리버스 킬/존 요구치)")
if _a585.auto.rebSaid ~= _a585.auto.rebNote then
_a585.auto.rebSaid = _a585.auto.rebNote
_a572("[리버스] " .. _a585.auto.rebNote)
end
end
end
_a585.auto.SIDE = {
{ key = "unlock", label = "알 해금",   run = "mhatch", fn = function() _a585.egg.unlockEggs() end },
{ key = "slots",  label = "슬롯 머신", run = "slots",  fn = function() _a585.mach.cycleSlots() end },
{ key = "mapupg", label = "맵 업그레이드", run = "mapupg", fn = function() _a585.mach.cycleUpg() end },
{ key = "items",  label = "버프 유지",     run = "items",  fn = function() _a585.item.cycleItems() end },
}
_a585.auto.STEPS = {
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a1541() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a655() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a1545 = _a579.farm
_a579.farm = true
pcall(_a637)
_a579.farm = _a1545
local _a1546 = _a585.quest.cycle()
if not _a1546 then
local _a1547 = _a585.move.bestZone()
if _a1547 then
local _a1548, _a1549 = _a585.move.goToZone(_a1547)
if not _a1548 then
if _a1549 and _a585.auto.idleMoveSaid ~= tostring(_a1549) then
_a585.auto.idleMoveSaid = tostring(_a1549)
_a572("[자동] 최고 존 이동 실패: " .. tostring(_a1549))
end
else
_a585.auto.idleMoveSaid = nil
end
end
if not _a578.IdleHatch then
_a585.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a585.move.curZone())))
return
end
local _a1550 = _a685()
local _a1551 = math.max(1, _a578.HatchMinAfford or 10)
if _a1550 and _a1550.price and _a1550.canBuy < _a1551 then
_a585.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a585.move.curZone()), _a1550.canBuy, _a1551,
_a573(_a1550.price, 0), tostring(_a1550.currency)))
else
_a585.ctl.setAct("대기 중 부화")
local _a1552 = _a579.mhatch
_a579.mhatch = true
pcall(_a696)
_a579.mhatch = _a1552
end
end
end },
}
_a578.StepOn = {}
for _a1553, _a1554 in ipairs(_a585.auto.SIDE) do _a578.StepOn[_a1554.key] = true end
for _a1555, _a1556 in ipairs(_a585.auto.STEPS) do _a578.StepOn[_a1556.key] = true end
local function _a1557(_a1558, _a1559, _a1560, _a1561)
if not _a578.StepOn[_a1558.key] then
_a1561[#_a1561 + 1] = ("%-14s 꺼져있음"):format(_a1558.label)
return
end
if _a1558.hold and _a1559 then
_a1561[#_a1561 + 1] = ("%-14s 보류 (%s)"):format(
_a1558.label, _a1560 and tostring(_a1560.title) or "?")
if _a585.auto.heldMsg ~= _a1558.key then
_a585.auto.heldMsg = _a1558.key
_a572(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a1558.label, _a1560 and tostring(_a1560.title) or "?"))
end
return
end
if _a1558.hold then _a585.auto.heldMsg = nil end
_a585.auto.step = _a1558.label
_a585.ctl.now.step = _a1558.label
_a585.ctl.setAct("시작", _a1558.label)
local _a1562 = os.clock()
local _a1563 = _a579[_a1558.run]
_a579[_a1558.run] = true
local _a1564, _a1565 = pcall(_a1558.fn)
_a579[_a1558.run] = _a1563
local _a1566 = os.clock() - _a1562
if not _a1564 then
_a1561[#_a1561 + 1] = ("%-14s 오류: %s"):format(_a1558.label, tostring(_a1565))
_a572("[자동] " .. _a1558.label .. " 오류: " .. tostring(_a1565))
else
local _a1567 = (_a1558.key == "zone" and _a585.auto.zoneNote)
or (_a1558.key == "mreb" and _a585.auto.rebNote) or nil
_a1561[#_a1561 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a1558.label, _a1566, _a1567 and ("  → " .. _a1567) or "")
end
end
function _a585.auto.master()
local _a1568 = {}
_a585.auto.lastTrace = _a1568
_a585.auto.lastPassAt = os.clock()
if _a585.screen.rewardScreenUp() then
_a1568[#_a1568 + 1] = "보상 화면 넘기는 중"
_a585.screen.dismissRewardScreens(15)
end
for _a1569, _a1570 in ipairs(_a585.auto.SIDE) do
if not _a579.auto or _a585.ctl.stopped() then return end
_a1557(_a1570, false, nil, _a1568)
end
local _a1571, _a1572 = false, nil
if _a578.HoldZoneForQuest then _a1571, _a1572 = _a585.quest.bestDepActive() end
for _a1573, _a1574 in ipairs(_a585.auto.STEPS) do
if not _a579.auto or _a585.ctl.stopped() then break end
_a1557(_a1574, _a1571, _a1572, _a1568)
end
_a585.auto.step = nil
if not _a585.ctl.lockGoal then
_a585.ctl.now.step = "대기"
_a585.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a578.AutoInterval or 5))
end
local _a1575 = {}
for _a1576, _a1577 in ipairs(_a1568) do _a1575[#_a1575 + 1] = (_a1577:gsub("[%d%.]+초", "")) end
_a1575 = table.concat(_a1575, " | ")
if _a1575 ~= _a585.auto.lastSig then
_a585.auto.lastSig = _a1575
_a572("[자동] 바퀴 " .. (_a585.auto.passN or 0))
for _a1578, _a1579 in ipairs(_a1568) do _a572("    " .. _a1579) end
end
_a585.auto.passN = (_a585.auto.passN or 0) + 1
end
local function _a1580()
if not _a577.R_PROMO then _a572("[타워업글] 리모트 없음") return end
local _a1581 = _a581()
if not _a1581 then return end
local _a1582 = _a582(_a1581)
table.sort(_a1582, function(_a1583, _a1584) return (_a1583.dps or 0) > (_a1584.dps or 0) end)
local _a1585, _a1586 = 0, 0
for _a1587, _a1588 in ipairs(_a1582) do
if not _a579.towerup then break end
if _a1588.id then
local _a1589
pcall(function() _a1589 = _a577.R_PROMO:InvokeServer(_a1588.id) end)
if _a1589 ~= nil and _a1589 ~= false then
_a1585 += 1
_a572(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1588.kind), tostring(_a1588.up), tostring((_a1588.up or 0) + 1)))
_a1586 = 0
task.wait(_a578.ActionGap)
else
_a1586 += 1
if _a1586 >= 5 then break end
end
end
end
_a572("[타워업글] " .. _a1585 .. "건")
end
local _a1590 = {}
local _a1591 = {}
local function _a1592(_a1593, _a1594)
local _a1595 = tostring(_a1594)
local _a1596 = _a1591[_a1593]
if _a1596 and _a1596.msg == _a1595 then
_a1596.n += 1
if _a1596.n % 20 == 0 then
_a572(("[%s 오류] %s   (%d회 반복)"):format(_a1593, _a1595, _a1596.n))
end
return
end
_a1591[_a1593] = { msg = _a1595, n = 1 }
_a572("[" .. _a1593 .. " 오류] " .. _a1595)
end
local function _a1597(_a1598, _a1599, _a1600, _a1601)
_a1590[_a1598] = (_a1590[_a1598] or 0) + 1
local _a1602 = _a1590[_a1598]
task.spawn(function()
while _a579[_a1598] and _a1590[_a1598] == _a1602 do
local _a1603, _a1604 = pcall(_a1600)
if not _a1603 then _a1592(_a1601, _a1604) else _a1591[_a1601] = nil end
local _a1605, _a1606 = _a1599(), 0
while _a1606 < _a1605 and _a579[_a1598] and _a1590[_a1598] == _a1602 do task.wait(0.1) _a1606 += 0.1 end
end
if _a1590[_a1598] == _a1602 then _a572("[" .. _a1601 .. "] 중지") end
end)
end
do
local _a1607 = {
farm   = { function() return _a578.FarmInterval end,      function() _a637() end,      "파밍" },
zone   = { function() return _a578.ZoneInterval end,      function() _a655() end,      "존" },
mhatch = { function() return _a578.MainHatchInterval end, function() _a696() end, "부화" },
}
function _a585.auto.turnOn(_a1608, _a1609)
if _a579.auto then return end
if _a579[_a1608] then return end
local _a1610 = _a1607[_a1608]
if not _a1610 then return end
_a579[_a1608] = true
_a1597(_a1608, _a1610[1], _a1610[2], _a1610[3])
if _a585.auto.refresh then _a585.auto.refresh() end
_a572("[퀘스트] " .. tostring(_a1609) .. " ON")
end
end
_a568.MG, _a568.QS, _a568.saveGet, _a568.currencyAmount, _a568.cycleFarm, _a568.zoneStatus = _a583, _a585, _a612, _a627, _a637, _a651
_a568.cycleZone, _a568.bestMainEgg, _a568.mainHatchStatus, _a568.cycleMainHatch, _a568.mainRebirthStatus, _a568.cycleMainRebirth = _a655, _a660, _a685, _a696, _a1534, _a1541
_a568.cycleTowerUp, _a568.startLoop = _a1580, _a1597
end)(_a1)
;(function(_a1611)
local _a1612, _a1613, _a1614, _a1615, _a1616, _a1617, _a1618 = _a1611.UIS, _a1611.RunService, _a1611.LP, _a1611.LOG, _a1611.log, _a1611.num, _a1611.LB
local _a1619, _a1620, _a1621, _a1622, _a1623, _a1624 = _a1611.RM, _a1611.CFG, _a1611.EGG_COST_CACHE, _a1611.RUN, _a1611.STAT, _a1611.EVENT_UPGRADES
local _a1625, _a1626, _a1627, _a1628, _a1629, _a1630 = _a1611.ctx, _a1611.collectSlots, _a1611.placedTowers, _a1611.availableItems, _a1611.cyclePlace, _a1611.cycleMerchant
local _a1631, _a1632, _a1633, _a1634, _a1635, _a1636 = _a1611.sunflowers, _a1611.eventTiers, _a1611.nextCost, _a1611.cycleUpgrade, _a1611.seedInv, _a1611.bedsOf
local _a1637, _a1638, _a1639, _a1640, _a1641, _a1642 = _a1611.isUnhatched, _a1611.bedCps, _a1611.cycleCrop, _a1611.laneCosts, _a1611.lockedBeds, _a1611.cycleExpand
local _a1643, _a1644, _a1645, _a1646, _a1647 = _a1611.rebirthStatus, _a1611.cycleRebirth, _a1611.hatchStatus, _a1611.cycleHatch, _a1611.LUCK_ORDER
local _a1648, _a1649, _a1650, _a1651, _a1652, _a1653 = _a1611.luckStatus, _a1611.fmtDur, _a1611.cycleLuck, _a1611.MG, _a1611.QS, _a1611.saveGet
local _a1654, _a1655, _a1656, _a1657, _a1658, _a1659 = _a1611.currencyAmount, _a1611.cycleFarm, _a1611.zoneStatus, _a1611.cycleZone, _a1611.bestMainEgg, _a1611.mainHatchStatus
local _a1660, _a1661, _a1662, _a1663, _a1664 = _a1611.cycleMainHatch, _a1611.mainRebirthStatus, _a1611.cycleMainRebirth, _a1611.cycleTowerUp, _a1611.startLoop
local _a1665 = {
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
local function _a1666(_a1667, _a1668, _a1669)
local _a1670 = Instance.new(_a1667)
for _a1671, _a1672 in pairs(_a1668) do _a1670[_a1671] = _a1672 end
if _a1669 then _a1670.Parent = _a1669 end
return _a1670
end
local function _a1673(_a1674, _a1675) _a1666("UICorner", { CornerRadius = UDim.new(0, _a1675 or 8) }, _a1674) end
local function _a1676(_a1677, _a1678, _a1679)
_a1666("UIStroke", { Color = _a1678 or _a1665.line, Thickness = _a1679 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _a1677)
end
local function _a1680(_a1681, _a1682)
_a1666("UIPadding", {
PaddingTop = UDim.new(0, _a1682), PaddingBottom = UDim.new(0, _a1682),
PaddingLeft = UDim.new(0, _a1682), PaddingRight = UDim.new(0, _a1682),
}, _a1681)
end
local _a1683 = _a1666("ScreenGui", {
Name = "PS99GardenAuto", ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset = true, DisplayOrder = 9999,
})
local _a1684 = false
if type(gethui) == "function" then _a1684 = pcall(function() _a1683.Parent = gethui() end) end
if not _a1684 then _a1684 = pcall(function() _a1683.Parent = game:GetService("CoreGui") end) end
if not _a1684 then _a1683.Parent = _a1614:WaitForChild("PlayerGui") end
local _a1685, _a1686 = 780, 520
local _a1687 = _a1666("Frame", {
Size = UDim2.fromOffset(_a1685, _a1686), Position = UDim2.new(0.5, -_a1685 / 2, 0.5, -_a1686 / 2),
BackgroundColor3 = _a1665.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, _a1683)
_a1673(_a1687, 12)
_a1676(_a1687, Color3.fromRGB(60, 66, 82), 1)
local _a1688 = _a1666("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = _a1665.panel, BorderSizePixel = 0,
}, _a1687)
_a1673(_a1688, 12)
_a1666("Frame", {
Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
BackgroundColor3 = _a1665.panel, BorderSizePixel = 0,
}, _a1688)
_a1666("Frame", {
Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(14, 15),
BackgroundColor3 = _a1665.good, BorderSizePixel = 0,
}, _a1688).Name = "Dot"
_a1673(_a1688:FindFirstChild("Dot"), 5)
_a1666("TextLabel", {
Size = UDim2.new(0, 320, 1, 0), Position = UDim2.fromOffset(32, 0),
BackgroundTransparency = 1, Text = "Garden Defenders  AutoPlay",
TextColor3 = _a1665.text, TextSize = 14, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1688)
local function _a1689(_a1690, _a1691, _a1692, _a1693)
local _a1694 = _a1666("TextButton", {
Size = UDim2.new(0, _a1693, 0, 24), Position = UDim2.new(1, _a1692, 0, 8),
BackgroundColor3 = _a1691, BorderSizePixel = 0, Text = _a1690,
TextColor3 = _a1665.text, TextSize = 12, Font = Enum.Font.GothamMedium,
AutoButtonColor = true,
}, _a1688)
_a1673(_a1694, 6)
return _a1694
end
local _a1695 = _a1689("✕", _a1665.bad, -38, 28)
local _a1696   = _a1689("—", _a1665.card, -70, 28)
local _a1697 = _a1689("지우기", _a1665.card, -132, 58)
local _a1698  = _a1689("복사", _a1665.accent, -190, 54)
local _a1699  = _a1689("정지", _a1665.bad, -252, 58)
_a1699.MouseButton1Click:Connect(function()
task.spawn(function()
_a1652.ctl.stopAll()
if _a1652.auto.refresh then pcall(_a1652.auto.refresh) end
_a1616("[정지] 모든 동작을 멈췄습니다")
end)
end)
local _a1700 = _a1666("ScrollingFrame", {
Size = UDim2.new(0, 152, 1, -92), Position = UDim2.fromOffset(10, 48),
BackgroundColor3 = _a1665.panel, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = _a1665.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1687)
_a1673(_a1700, 8)
_a1666("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, _a1700)
_a1666("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, _a1700)
local _a1701 = _a1666("Frame", {
Size = UDim2.new(1, -182, 1, -92), Position = UDim2.fromOffset(172, 48),
BackgroundTransparency = 1,
}, _a1687)
local _a1702, _a1703 = {}, nil
local _a1704, _a1705 = {}, {}
local _a1706 = {}
local function _a1707(_a1708)
_a1703 = _a1708
for _a1709, _a1710 in pairs(_a1702) do _a1710.Visible = (_a1709 == _a1708) end
for _a1711, _a1712 in pairs(_a1704) do
local _a1713 = (_a1711 == _a1708)
_a1712.BackgroundColor3 = _a1713 and _a1665.accent or _a1665.panel
_a1712.TextColor3 = _a1713 and Color3.fromRGB(255, 255, 255) or _a1665.dim
end
local _a1714 = _a1705[_a1708]
if _a1714 and _a1706[_a1714] and not _a1706[_a1714].open then _a1706[_a1714].toggle() end
end
local function _a1715(_a1716, _a1717, _a1718)
local _a1719 = { open = true, kids = {} }
local _a1720 = _a1666("TextButton", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = _a1665.bg, BorderSizePixel = 0,
Text = "", TextColor3 = _a1665.dim, TextSize = 11,
Font = Enum.Font.GothamBold, LayoutOrder = _a1718, AutoButtonColor = false,
}, _a1700)
_a1673(_a1720, 5)
local _a1721 = _a1666("TextLabel", {
Size = UDim2.fromOffset(14, 26), Position = UDim2.fromOffset(6, 0),
BackgroundTransparency = 1, Text = "▾", TextColor3 = _a1665.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1720)
_a1666("TextLabel", {
Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(20, 0),
BackgroundTransparency = 1, Text = _a1717, TextColor3 = _a1665.dim,
TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1720)
function _a1719.toggle()
_a1719.open = not _a1719.open
_a1721.Text = _a1719.open and "▾" or "▸"
for _a1722, _a1723 in ipairs(_a1719.kids) do _a1723.Visible = _a1719.open end
end
_a1720.MouseButton1Click:Connect(_a1719.toggle)
_a1706[_a1716] = _a1719
return _a1719
end
local function _a1724(_a1725, _a1726, _a1727, _a1728)
local _a1729 = _a1728 and 14 or 6
local _a1730 = _a1666("TextButton", {
Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = _a1665.panel, BorderSizePixel = 0,
Text = "", TextColor3 = _a1665.dim, TextSize = 12,
Font = Enum.Font.GothamMedium, LayoutOrder = _a1727, AutoButtonColor = false,
}, _a1700)
_a1673(_a1730, 5)
local _a1731 = _a1666("TextLabel", {
Size = UDim2.new(1, -_a1729 - 4, 1, 0), Position = UDim2.fromOffset(_a1729, 0),
BackgroundTransparency = 1, Text = _a1726, TextColor3 = _a1665.dim,
TextSize = 12, Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1730)
_a1704[_a1725] = _a1730
if _a1728 then
_a1705[_a1725] = _a1728
local _a1732 = _a1706[_a1728]
if _a1732 then
table.insert(_a1732.kids, _a1730)
_a1730.Visible = _a1732.open
end
end
local _a1733 = _a1666("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false,
BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1665.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1701)
_a1666("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1733)
_a1666("UIPadding", { PaddingRight = UDim.new(0, 8) }, _a1733)
_a1702[_a1725] = _a1733
_a1730.MouseButton1Click:Connect(function() _a1707(_a1725) end)
_a1730.MouseEnter:Connect(function()
if _a1703 ~= _a1725 then _a1730.BackgroundColor3 = _a1665.card end
end)
_a1730.MouseLeave:Connect(function()
if _a1703 ~= _a1725 then _a1730.BackgroundColor3 = _a1665.panel end
end)
_a1730:GetPropertyChangedSignal("TextColor3"):Connect(function()
_a1731.TextColor3 = _a1730.TextColor3
end)
return _a1733
end
local _a1734 = 0
local function _a1735()
_a1734 += 1
return _a1734
end
local function _a1736(_a1737, _a1738)
local _a1739 = _a1666("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = _a1735(),
}, _a1737)
_a1666("Frame", {
Size = UDim2.fromOffset(3, 14), Position = UDim2.fromOffset(0, 7),
BackgroundColor3 = _a1665.accent, BorderSizePixel = 0,
}, _a1739)
_a1666("TextLabel", {
Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1, Text = _a1738, TextColor3 = _a1665.text,
TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1739)
return _a1739
end
local function _a1740(_a1741, _a1742, _a1743)
local _a1744 = _a1666("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = _a1665.card, BorderSizePixel = 0, LayoutOrder = _a1735(),
}, _a1741)
_a1673(_a1744, 8)
_a1676(_a1744, _a1665.line, 1)
_a1680(_a1744, 12)
_a1666("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1744)
if _a1742 then
local _a1745 = _a1666("Frame", {
Size = UDim2.new(1, 0, 0, _a1743 and 32 or 22), BackgroundTransparency = 1,
LayoutOrder = 0,
}, _a1744)
_a1666("TextLabel", {
Size = UDim2.new(1, -70, 0, 16), BackgroundTransparency = 1, Text = _a1742,
TextColor3 = _a1665.text, TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1745)
if _a1743 then
_a1666("TextLabel", {
Size = UDim2.new(1, -70, 0, 13), Position = UDim2.fromOffset(0, 17),
BackgroundTransparency = 1, Text = _a1743, TextColor3 = _a1665.dim,
TextSize = 11, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, _a1745)
end
_a1744:SetAttribute("HeadHeight", _a1743 and 32 or 18)
return _a1744, _a1745
end
return _a1744
end
local _a1746 = {}
local function _a1747()
for _a1748, _a1749 in pairs(_a1746) do pcall(_a1749) end
end
_a1652.auto.refresh = _a1747
local function _a1750(_a1751, _a1752, _a1753)
local _a1754 = _a1666("TextButton", {
Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -46, 0, 0),
BackgroundColor3 = _a1665.cardHi, BorderSizePixel = 0, Text = "",
AutoButtonColor = false,
}, _a1751)
_a1673(_a1754, 12)
local _a1755 = _a1666("Frame", {
Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
BackgroundColor3 = _a1665.dim, BorderSizePixel = 0,
}, _a1754)
_a1673(_a1755, 9)
local _a1756 = _a1666("TextLabel", {
Size = UDim2.fromOffset(46, 12), Position = UDim2.fromOffset(0, 26),
BackgroundTransparency = 1, Text = "OFF", TextColor3 = _a1665.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1754)
local function _a1757()
local _a1758 = _a1622[_a1752]
_a1754.BackgroundColor3 = _a1758 and _a1665.good or _a1665.cardHi
_a1755:TweenPosition(UDim2.fromOffset(_a1758 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a1755.BackgroundColor3 = _a1758 and Color3.fromRGB(255, 255, 255) or _a1665.dim
_a1756.Text = _a1758 and "ON" or "OFF"
_a1756.TextColor3 = _a1758 and _a1665.good or _a1665.dim
end
_a1754.MouseButton1Click:Connect(function()
_a1622[_a1752] = not _a1622[_a1752]
if _a1622[_a1752] then
if _a1752 == "auto" then _a1652.ctl.abort = false end
_a1757()
_a1616("[" .. _a1752 .. "] 시작")
task.spawn(function()
local _a1759, _a1760 = pcall(_a1753)
if not _a1759 then _a1616("[에러] " .. tostring(_a1760)) end
end)
else
if _a1752 == "auto" then
_a1652.ctl.stopAll()
_a1616("[정지] 모든 동작을 멈췄습니다")
end
_a1757()
end
end)
_a1757()
_a1746[_a1752] = _a1757
return _a1754, _a1757
end
local function _a1761(_a1762, _a1763)
local _a1764 = _a1666("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = _a1735(),
}, _a1762)
local _a1765 = #_a1763
for _a1766, _a1767 in ipairs(_a1763) do
local _a1768 = _a1666("Frame", {
Size = UDim2.new(1 / _a1765, -6, 1, 0), Position = UDim2.new((_a1766 - 1) / _a1765, 3, 0, 0),
BackgroundTransparency = 1,
}, _a1764)
_a1666("TextLabel", {
Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = _a1767.label,
TextColor3 = _a1665.dim, TextSize = 10, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1768)
local _a1769 = _a1666("TextBox", {
Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 15),
BackgroundColor3 = _a1665.bg, BorderSizePixel = 0, Text = tostring(_a1767.value),
TextColor3 = _a1665.text, TextSize = 12, Font = Enum.Font.Code,
ClearTextOnFocus = false,
}, _a1768)
_a1673(_a1769, 5)
_a1676(_a1769, _a1665.line, 1)
_a1769.FocusLost:Connect(function() _a1767.onChange(_a1769.Text, _a1769) end)
end
return _a1764
end
local function _a1770(_a1771, _a1772)
local _a1773 = _a1666("Frame", {
Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = _a1735(),
}, _a1771)
local _a1774 = #_a1772
for _a1775, _a1776 in ipairs(_a1772) do
local _a1777 = _a1666("TextButton", {
Size = UDim2.new(1 / _a1774, -5, 1, 0), Position = UDim2.new((_a1775 - 1) / _a1774, 2.5, 0, 0),
BackgroundColor3 = _a1776.col or _a1665.cardHi, BorderSizePixel = 0, Text = _a1776.label,
TextColor3 = _a1665.text, TextSize = 12, Font = Enum.Font.GothamMedium,
}, _a1773)
_a1673(_a1777, 6)
_a1777.MouseButton1Click:Connect(function()
task.spawn(function()
local _a1778, _a1779 = pcall(_a1776.fn, _a1777)
if not _a1778 then _a1616("[에러] " .. tostring(_a1776.label) .. " → " .. tostring(_a1779)) end
end)
end)
end
return _a1773
end
local function _a1780(_a1781, _a1782, _a1783, _a1784)
local _a1785 = _a1666("TextButton", {
Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = _a1665.cardHi, BorderSizePixel = 0,
Text = "", TextColor3 = _a1665.text, TextSize = 12, Font = Enum.Font.GothamMedium,
LayoutOrder = _a1735(),
}, _a1781)
_a1673(_a1785, 6)
local function _a1786()
local _a1787 = _a1783()
_a1785.Text = _a1782 .. "   " .. (_a1787 and "ON" or "OFF")
_a1785.BackgroundColor3 = _a1787 and Color3.fromRGB(40, 78, 58) or _a1665.cardHi
_a1785.TextColor3 = _a1787 and _a1665.good or _a1665.dim
end
_a1785.MouseButton1Click:Connect(function()
_a1784(not _a1783())
_a1786()
end)
_a1786()
return _a1785
end
local _a1788 = _a1724("log", "로그", 90)
local _a1789, _a1790, _a1791
local _a1792 = { size = 140, top = nil }
do
local _a1793 = _a1666("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a1735(),
}, _a1788)
_a1673(_a1793, 8)
_a1676(_a1793, _a1665.line, 1)
local _a1794 = _a1666("Frame", {
Size = UDim2.new(1, -10, 0, 24), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1,
}, _a1793)
_a1790 = _a1666("TextLabel", {
Size = UDim2.new(1, -250, 1, 0), BackgroundTransparency = 1,
Text = "", TextColor3 = _a1665.dim, TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1794)
local function _a1795(_a1796, _a1797, _a1798, _a1799)
local _a1800 = _a1666("TextButton", {
Size = UDim2.new(0, _a1797, 0, 22), Position = UDim2.new(1, _a1796, 0, 1),
BackgroundColor3 = _a1665.cardHi, BorderSizePixel = 0, AutoButtonColor = true,
Text = _a1798, TextColor3 = _a1665.text, TextSize = 11, Font = Enum.Font.GothamBold,
}, _a1794)
_a1673(_a1800, 5)
_a1800.MouseButton1Click:Connect(function()
task.spawn(function() pcall(_a1799) _a1611.dirty = true end)
end)
return _a1800
end
local function _a1801()
return _a1792.top or math.max(1, #_a1615 - _a1792.size + 1)
end
_a1795(-244, 56, "맨 위",  function() _a1792.top = 1 end)
_a1795(-186, 40, "▲",     function() _a1792.top = math.max(1, _a1801() - _a1792.size) end)
_a1795(-144, 40, "▼",     function()
local _a1802 = _a1801() + _a1792.size
if _a1802 >= math.max(1, #_a1615 - _a1792.size + 1) then _a1792.top = nil else _a1792.top = _a1802 end
end)
_a1795(-102, 100, "최신 따라가기", function() _a1792.top = nil end)
_a1791 = _a1666("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -36), Position = UDim2.fromOffset(5, 31),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 6,
ScrollBarImageColor3 = _a1665.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1793)
_a1789 = _a1666("TextLabel", {
Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(196, 208, 196),
TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
TextWrapped = true,
}, _a1791)
_a1788.AutomaticCanvasSize = Enum.AutomaticSize.None
_a1788.CanvasSize = UDim2.new()
end
do
local _a1803, _a1804, _a1805, _a1806
_a1688.InputBegan:Connect(function(_a1807)
if _a1807.UserInputType == Enum.UserInputType.MouseButton1
or _a1807.UserInputType == Enum.UserInputType.Touch then
_a1803, _a1804, _a1805 = true, _a1807.Position, _a1687.Position
_a1807.Changed:Connect(function()
if _a1807.UserInputState == Enum.UserInputState.End then _a1803 = false end
end)
end
end)
_a1688.InputChanged:Connect(function(_a1808)
if _a1808.UserInputType == Enum.UserInputType.MouseMovement
or _a1808.UserInputType == Enum.UserInputType.Touch then _a1806 = _a1808 end
end)
_a1612.InputChanged:Connect(function(_a1809)
if _a1803 and _a1809 == _a1806 then
local _a1810 = _a1809.Position - _a1804
_a1687.Position = UDim2.new(_a1805.X.Scale, _a1805.X.Offset + _a1810.X,
_a1805.Y.Scale, _a1805.Y.Offset + _a1810.Y)
end
end)
local _a1811 = false
_a1696.MouseButton1Click:Connect(function()
_a1811 = not _a1811
_a1687:TweenSize(_a1811 and UDim2.fromOffset(_a1685, 40) or UDim2.fromOffset(_a1685, _a1686),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a1696.Text = _a1811 and "▢" or "—"
end)
end
local _a1812 = _a1613.Heartbeat:Connect(function()
if not _a1611.dirty then return end
_a1611.dirty = false
local _a1813 = #_a1615
local _a1814 = math.max(1, _a1813 - _a1792.size + 1)
local _a1815 = (_a1792.top == nil)
local _a1816 = math.max(1, math.min(_a1792.top or _a1814, _a1814))
local _a1817 = math.min(_a1813, _a1816 + _a1792.size - 1)
local _a1818, _a1819 = {}, 0
for _a1820 = _a1816, _a1817 do
local _a1821 = _a1615[_a1820] or ""
if #_a1821 > 400 then _a1821 = _a1821:sub(1, 400) .. " …" end
_a1819 += #_a1821 + 1
if _a1819 > 12000 then
_a1818[#_a1818 + 1] = "…  (이 창에 다 못 담아 잘랐습니다. ▲ 로 나눠서 보세요)"
_a1817 = _a1820 - 1
break
end
_a1818[#_a1818 + 1] = _a1821
end
_a1789.Text = table.concat(_a1818, "\n")
_a1790.Text = ("%d-%d / %d 줄    %s")
:format(_a1816, _a1817, _a1813, _a1815 and "최신 따라가는 중" or "▲▼ 로 이동  ·  멈춤")
if _a1815 then
task.defer(function()
if _a1791 and _a1791.Parent then
_a1791.CanvasPosition = Vector2.new(0, _a1791.AbsoluteCanvasSize.Y)
end
end)
end
end)
local _a1822 = _a1724("dash", "대시보드", 10)
local _a1823 = _a1724("event", "이벤트", 20)
do
local _a1824 = _a1740(_a1822, "전체 제어", nil)
_a1770(_a1824, {
{ label = "권장 전부 ON", col = _a1665.good, fn = function()
for _a1825, _a1826 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a1622[_a1826] then
_a1622[_a1826] = true
if _a1826 == "place"    then _a1664(_a1826, function() return _a1620.PlaceInterval end, _a1629, "배치") end
if _a1826 == "merchant" then _a1664(_a1826, function() return _a1620.MerchantInterval end, _a1630, "구매") end
if _a1826 == "crop"     then _a1664(_a1826, function() return _a1620.CropInterval end, _a1639, "씨앗") end
if _a1826 == "expand"   then _a1664(_a1826, function() return _a1620.ExpandInterval end, _a1642, "확장") end
if _a1826 == "hatch"    then _a1664(_a1826, function() return _a1620.HatchInterval end, _a1646, "뽑기") end
end
end
_a1747()
_a1616("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a1665.bad, fn = function()
_a1622.place, _a1622.merchant, _a1622.upgrade = false, false, false
_a1622.towerup, _a1622.crop, _a1622.expand, _a1622.rebirth, _a1622.hatch, _a1622.luck = false, false, false, false, false, false
_a1622.farm, _a1622.zone, _a1622.mhatch, _a1622.rank, _a1622.mreb = false, false, false, false, false
_a1747()
_a1616("[전체] 정지")
end },
})
local _a1827 = _a1740(_a1822, "현황", nil)
_a1770(_a1827, {
{ label = "밭 / 타워", col = _a1665.accent, fn = function()
local _a1828, _a1829, _a1830, _a1831 = _a1625()
_a1616("")
_a1616("──── 현재 상태 ────")
_a1616("레인 " .. tostring(_a1831) .. " / plot " .. (_a1830 and "O" or "X")
.. " / world " .. (_a1828 and "O" or "X"))
local _a1832 = _a1626(_a1830, _a1831)
local _a1833 = _a1627(_a1828)
_a1616("슬롯 " .. #_a1832 .. " / 배치 " .. #_a1833)
local _a1834, _a1835 = 0, {}
for _a1836, _a1837 in ipairs(_a1833) do
_a1834 += (_a1837.dps or 0)
_a1835[tostring(_a1837.kind)] = (_a1835[tostring(_a1837.kind)] or 0) + 1
end
_a1616("총 DPS " .. _a1617(_a1834))
for _a1838, _a1839 in pairs(_a1835) do _a1616("  " .. _a1838 .. " × " .. _a1839) end
local _a1840 = _a1628()
_a1616("")
_a1616("배치 가능 " .. #_a1840 .. "종")
for _a1841 = 1, math.min(10, #_a1840) do
local _a1842 = _a1840[_a1841]
_a1616(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a1842.id), tostring(_a1842.vr or "-"), tostring(_a1842.copies), _a1617(_a1842.dps)))
end
_a1707("log")
end },
{ label = "로그 보기", col = _a1665.cardHi, fn = function() _a1707("log") end },
})
end
do
local _a1843, _a1844 = _a1740(_a1823, "자동 배치 / 교체", nil)
_a1750(_a1844, "place", function()
_a1664("place", function() return _a1620.PlaceInterval end, _a1629, "배치")
end)
_a1761(_a1843, {
{ label = "주기", value = _a1620.PlaceInterval, onChange = function(_a1845)
local _a1846 = tonumber(_a1845) if _a1846 and _a1846 >= 3 then _a1620.PlaceInterval = _a1846 end
end },
{ label = "교체 배수", value = _a1620.SwapMargin, onChange = function(_a1847)
local _a1848 = tonumber(_a1847) if _a1848 and _a1848 >= 1 then _a1620.SwapMargin = _a1848 _a1616("[설정] 교체 배수 " .. _a1848) end
end },
{ label = "DoT 반영", value = _a1620.DotFactor, onChange = function(_a1849)
local _a1850 = tonumber(_a1849) if _a1850 and _a1850 >= 0 and _a1850 <= 1 then _a1620.DotFactor = _a1850 end
end },
})
_a1780(_a1843, "업글 타워 보호",
function() return _a1620.ProtectUpgraded end,
function(_a1851) _a1620.ProtectUpgraded = _a1851
_a1616("[설정] 업글 보호 " .. (_a1851 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a1770(_a1843, {
{ label = "지금 1회 실행", col = _a1665.accent, fn = function()
task.spawn(function() _a1622.place = true _a1629() _a1622.place = false _a1707("log") end)
end },
})
end
do
local _a1852, _a1853 = _a1740(_a1823, "머천트 자동 구매", nil)
_a1750(_a1853, "merchant", function()
_a1664("merchant", function() return _a1620.MerchantInterval end, _a1630, "구매")
end)
_a1761(_a1852, {
{ label = "머천트 ID", value = _a1620.MerchantId, onChange = function(_a1854)
if _a1854 ~= "" then _a1620.MerchantId = _a1854 _a1616("[설정] 머천트 " .. _a1854) end
end },
{ label = "주기", value = _a1620.MerchantInterval, onChange = function(_a1855)
local _a1856 = tonumber(_a1855) if _a1856 and _a1856 >= 5 then _a1620.MerchantInterval = _a1856 end
end },
})
_a1770(_a1852, {
{ label = "지금 1회 구매", col = _a1665.accent, fn = function()
task.spawn(function() _a1622.merchant = true _a1630() _a1622.merchant = false _a1707("log") end)
end },
})
end
do
local _a1857, _a1858 = _a1740(_a1823, "업그레이드 머신", nil)
_a1750(_a1858, "upgrade", function()
_a1664("upgrade", function() return _a1620.UpgradeInterval end, _a1634, "머신업글")
end)
_a1761(_a1857, {
{ label = "주기", value = _a1620.UpgradeInterval, onChange = function(_a1859)
local _a1860 = tonumber(_a1859) if _a1860 and _a1860 >= 5 then _a1620.UpgradeInterval = _a1860 end
end },
{ label = "최소 잔액", value = _a1620.MinSunflowers, onChange = function(_a1861)
local _a1862 = tonumber(_a1861) if _a1862 and _a1862 >= 0 then _a1620.MinSunflowers = _a1862
_a1616("[설정] 최소 잔액 " .. _a1617(_a1862, 0)) end
end },
})
_a1780(_a1857, "가격 미상 구매",
function() return _a1620.BuyUnknownCost end,
function(_a1863) _a1620.BuyUnknownCost = _a1863 end)
_a1770(_a1857, {
{ label = "업글 현황 보기", col = _a1665.accent, fn = function()
local _a1864 = _a1631()
local _a1865 = _a1632()
_a1623.sun = _a1864
_a1616("")
_a1616("──── 업그레이드 머신 ────")
_a1616("Sunflowers = " .. _a1617(_a1864, 0))
local _a1866 = {}
for _a1867, _a1868 in ipairs(_a1624) do
local _a1869 = _a1865[_a1868] or 0
_a1866[#_a1866 + 1] = { id = _a1868, tier = _a1869, cost = _a1633(_a1868, _a1869) }
end
table.sort(_a1866, function(_a1870, _a1871)
return (_a1870.cost or math.huge) < (_a1871.cost or math.huge)
end)
for _a1872, _a1873 in ipairs(_a1866) do
_a1616(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a1873.id, tostring(_a1873.tier), _a1873.cost and _a1617(_a1873.cost, 0) or "?",
(_a1873.cost and _a1873.cost <= _a1864) and "← 구매가능" or ""))
end
_a1707("log")
end },
{ label = "지금 1회 업글", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.upgrade = true _a1634() _a1622.upgrade = false _a1707("log") end)
end },
})
local _a1874, _a1875 = _a1740(_a1823, "타워 개별 업글", nil)
_a1750(_a1875, "towerup", function()
_a1664("towerup", function() return _a1620.UpgradeInterval end, _a1663, "타워업글")
end)
end
do
local _a1876, _a1877 = _a1740(_a1823, "자동 뽑기", nil)
_a1750(_a1877, "hatch", function()
_a1664("hatch", function() return _a1620.HatchInterval end, _a1646, "뽑기")
end)
_a1761(_a1876, {
{ label = "주기", value = _a1620.HatchInterval, onChange = function(_a1878)
local _a1879 = tonumber(_a1878) if _a1879 and _a1879 >= 1 then _a1620.HatchInterval = _a1879 end
end },
{ label = "한 번에 최대", value = _a1620.HatchMax, onChange = function(_a1880)
local _a1881 = tonumber(_a1880) if _a1881 and _a1881 >= 1 then _a1620.HatchMax = math.floor(_a1881) end
end },
})
_a1761(_a1876, {
{ label = "예비금", value = _a1620.HatchReserve, onChange = function(_a1882)
local _a1883 = tonumber(_a1882) if _a1883 and _a1883 >= 0 then _a1620.HatchReserve = _a1883
_a1616("[설정] 뽑기 예비금 " .. _a1617(_a1883, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a1620.HatchEggNum, onChange = function(_a1884)
local _a1885 = tonumber(_a1884) if _a1885 and _a1885 >= 0 and _a1885 <= 12 then
_a1620.HatchEggNum = math.floor(_a1885)
table.clear(_a1621)
_a1616("[설정] 알 번호 " .. (_a1885 == 0 and "자동" or _a1885)) end
end },
})
_a1770(_a1876, {
{ label = "뽑기 현황 보기", col = _a1665.accent, fn = function()
local _a1886 = _a1645()
_a1623.sun = _a1886.sun
_a1616("")
_a1616("──── 뽑기 현황 ────")
_a1616("  알 등급     " .. _a1886.id)
_a1616("  알 uid      " .. tostring(_a1886.uid))
_a1616("  개당 비용   " .. (_a1886.cost and _a1617(_a1886.cost, 0) or "?"))
_a1616("  Sunflowers  " .. _a1617(_a1886.sun, 0))
_a1616("  예비금      " .. _a1617(_a1620.HatchReserve, 0))
_a1616("  지금 가능   " .. _a1886.canBuy .. "회")
_a1616("")
_a1616("  월드의 알 " .. _a1886.eggCount .. "개")
for _a1887, _a1888 in ipairs(_a1886.eggs) do
if _a1887 > 5 then break end
_a1616(("    %s  거리 %s"):format(_a1888.uid, _a1617(_a1888.dist)))
end
_a1616("")
_a1616("  누적 뽑기   " .. _a1623.hatched .. "회")
_a1707("log")
end },
{ label = "지금 1회 실행", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.hatch = true _a1646() _a1622.hatch = false _a1707("log") end)
end },
})
end
do
local _a1889, _a1890 = _a1740(_a1823, "럭 상시 최대 유지", nil)
_a1750(_a1890, "luck", function()
_a1664("luck", function() return _a1620.LuckInterval end, _a1650, "럭")
end)
_a1761(_a1889, {
{ label = "주기", value = _a1620.LuckInterval, onChange = function(_a1891)
local _a1892 = tonumber(_a1891) if _a1892 and _a1892 >= 60 then _a1620.LuckInterval = _a1892 end
end },
{ label = "예비금", value = _a1620.LuckReserve, onChange = function(_a1893)
local _a1894 = tonumber(_a1893) if _a1894 and _a1894 >= 0 then _a1620.LuckReserve = _a1894 end
end },
})
_a1761(_a1889, {
{ label = "최소 부족분", value = _a1620.LuckMinTopUp, onChange = function(_a1895)
local _a1896 = tonumber(_a1895) if _a1896 and _a1896 >= 0 then _a1620.LuckMinTopUp = _a1896 end
end },
})
for _a1897, _a1898 in ipairs(_a1647) do
_a1780(_a1889, _a1898,
function() return _a1620.LuckBoosts[_a1898] end,
function(_a1899) _a1620.LuckBoosts[_a1898] = _a1899 end)
end
_a1770(_a1889, {
{ label = "럭 현황 보기", col = _a1665.accent, fn = function()
local _a1900 = _a1648()
_a1623.sun = _a1900.sun
_a1616("")
_a1616("──── 이벤트 럭 ────")
_a1616("  머신 활성   " .. (_a1900.enabled and "O" or "X"))
_a1616("  최대 시간   " .. _a1649(_a1900.maxSec))
_a1616("  Sunflowers  " .. _a1617(_a1900.sun, 0))
_a1616("")
for _a1901, _a1902 in ipairs(_a1900.rows) do
_a1616(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a1902.rarity, _a1649(_a1902.left), _a1649(_a1902.deficit), _a1617(_a1902.need, 0),
_a1902.on and "" or "   (꺼짐)"))
end
_a1616("")
_a1616("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a1707("log")
end },
{ label = "지금 1회 충전", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.luck = true _a1650() _a1622.luck = false _a1707("log") end)
end },
})
end
do
local _a1903, _a1904 = _a1740(_a1823, "자동 씨앗 교체", nil)
_a1750(_a1904, "crop", function()
_a1664("crop", function() return _a1620.CropInterval end, _a1639, "씨앗")
end)
_a1761(_a1903, {
{ label = "주기", value = _a1620.CropInterval, onChange = function(_a1905)
local _a1906 = tonumber(_a1905) if _a1906 and _a1906 >= 5 then _a1620.CropInterval = _a1906 end
end },
{ label = "갈아엎기 배수", value = _a1620.CropMargin, onChange = function(_a1907)
local _a1908 = tonumber(_a1907) if _a1908 and _a1908 >= 1 then _a1620.CropMargin = _a1908 _a1616("[설정] 작물 배수 " .. _a1908) end
end },
})
_a1780(_a1903, "성장중 건너뛰기",
function() return _a1620.SkipUnhatched end,
function(_a1909) _a1620.SkipUnhatched = _a1909 end)
_a1770(_a1903, {
{ label = "밭 현황 보기", col = _a1665.accent, fn = function()
local _a1910, _a1911 = _a1625()
if not _a1911 then _a1616("[씨앗] 밭 없음") _a1707("log") return end
local _a1912, _a1913 = _a1636(_a1911), _a1635()
_a1616("")
_a1616("──── 밭 현황 ────")
_a1616("보유 씨앗 (기대 초당수익 순)")
for _a1914, _a1915 in ipairs(_a1913) do
_a1616(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a1915.id), tostring(_a1915.vr or "-"), tostring(_a1915.am), _a1617(_a1915.exp)))
end
local _a1916, _a1917, _a1918, _a1919, _a1920 = 0, 0, 0, 0, 0
local _a1921 = _a1913[1]
local _a1922 = _a1921 and _a1921.exp or 0
_a1616("")
_a1616("심어진 작물")
local _a1923 = 0
for _a1924, _a1925 in pairs(_a1912) do
_a1916 += 1
local _a1926 = _a1638(_a1925) or 0
_a1917 += _a1926
if _a1637(_a1925) then _a1919 += 1
elseif _a1922 > _a1926 * _a1620.CropMargin then _a1918 += 1
else _a1920 += 1 end
_a1923 += 1
if _a1923 <= 20 then
_a1616(("  칸%-4s %-20s %s/s%s"):format(tostring(_a1924),
tostring(rawget(_a1925, "sp") or "?"), _a1617(_a1926),
_a1637(_a1925) and "  (자라는 중)" or ""))
end
end
if _a1916 > 20 then _a1616("  ... (" .. (_a1916 - 20) .. "칸 더)") end
_a1616("")
_a1616(("총 %d칸 / 합계 %s per sec"):format(_a1916, _a1617(_a1917)))
_a1616(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a1918, _a1920, _a1919))
_a1707("log")
end },
{ label = "지금 1회 실행", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.crop = true _a1639() _a1622.crop = false _a1707("log") end)
end },
})
end
do
local _a1927, _a1928 = _a1740(_a1823, "자동 확장", nil)
_a1750(_a1928, "expand", function()
_a1664("expand", function() return _a1620.ExpandInterval end, _a1642, "확장")
end)
_a1761(_a1927, {
{ label = "주기", value = _a1620.ExpandInterval, onChange = function(_a1929)
local _a1930 = tonumber(_a1929) if _a1930 and _a1930 >= 5 then _a1620.ExpandInterval = _a1930 end
end },
{ label = "밭칸 스캔", value = _a1620.MaxBedScan, onChange = function(_a1931)
local _a1932 = tonumber(_a1931) if _a1932 and _a1932 >= 1 then _a1620.MaxBedScan = math.floor(_a1932) end
end },
})
_a1770(_a1927, {
{ label = "확장 현황 보기", col = _a1665.accent, fn = function()
local _a1933, _a1934, _a1935, _a1936 = _a1625()
if not _a1934 then _a1616("[확장] 밭 없음") _a1707("log") return end
local _a1937 = _a1631()
_a1623.sun = _a1937
local _a1938 = _a1640(true)
_a1616("")
_a1616("──── 확장 현황 ────")
_a1616("Sunflowers = " .. _a1617(_a1937, 0))
_a1616("")
_a1616("레인 " .. tostring(_a1936) .. "개 열림")
local _a1939 = {}
for _a1940 in pairs(_a1938) do _a1939[#_a1939 + 1] = tonumber(_a1940) or _a1940 end
table.sort(_a1939, function(_a1941, _a1942) return tostring(_a1941) < tostring(_a1942) end)
for _a1943, _a1944 in ipairs(_a1939) do
local _a1945 = _a1938[_a1944] or _a1938[tostring(_a1944)]
local _a1946 = tonumber(_a1944) or 0
local _a1947 = (_a1946 == (tonumber(_a1936) or 0) + 1)
and ((tonumber(_a1945) or math.huge) <= _a1937 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a1946 <= (tonumber(_a1936) or 0) and "  (열림)" or "")
_a1616(("  레인 %-3s %s%s"):format(tostring(_a1944), _a1617(tonumber(_a1945) or 0, 0), _a1947))
end
local _a1948 = _a1641(_a1934)
_a1616("")
_a1616("잠긴 밭칸 " .. #_a1948 .. "개 (싼 순 8개)")
for _a1949 = 1, math.min(8, #_a1948) do
local _a1950 = _a1948[_a1949]
_a1616(("  칸 %-4s %s%s"):format(_a1950.id, _a1950.cost and _a1617(_a1950.cost, 0) or "?",
(_a1950.cost and _a1950.cost <= _a1937) and "  ← 오픈 가능" or ""))
end
if #_a1948 == 0 then _a1616("  (전부 열려 있음)") end
_a1707("log")
end },
{ label = "지금 1회 실행", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.expand = true _a1642() _a1622.expand = false _a1707("log") end)
end },
})
end
do
local _a1951, _a1952 = _a1740(_a1823, "자동 리버스", nil)
_a1750(_a1952, "rebirth", function()
_a1664("rebirth", function() return _a1620.RebirthInterval end, _a1644, "리버스")
end)
_a1761(_a1951, {
{ label = "주기", value = _a1620.RebirthInterval, onChange = function(_a1953)
local _a1954 = tonumber(_a1953) if _a1954 and _a1954 >= 10 then _a1620.RebirthInterval = _a1954 end
end },
})
_a1770(_a1951, {
{ label = "리버스 현황 보기", col = _a1665.accent, fn = function()
local _a1955 = _a1643()
_a1616("")
_a1616("──── 리버스 현황 ────")
if not _a1955 then _a1616("  밭 없음") _a1707("log") return end
_a1616(("  현재 리버스   %d회  (최대 %s)"):format(_a1955.regrows, tostring(_a1955.cap)))
_a1616(("  레인          %d / 7 %s"):format(_a1955.lanes, _a1955.lanes >= 7 and "OK" or "부족"))
_a1616(("  코인보스      %d / %d %s"):format(_a1955.kills, _a1955.need,
_a1955.kills >= _a1955.need and "OK" or "부족"))
_a1616("")
_a1616(_a1955.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a1955.reason)))
_a1707("log")
end },
{ label = "지금 1회 리버스", col = _a1665.bad, fn = function()
task.spawn(function() _a1622.rebirth = true _a1644() _a1622.rebirth = false _a1707("log") end)
end },
})
end
local _a1956 = _a1724("main", "메인 게임", 30)
do
local _a1957, _a1958 = _a1740(_a1956, "올 자동", nil)
local _a1959 = _a1666("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a1665.cardHi,
BorderSizePixel = 0, LayoutOrder = _a1735(),
}, _a1957)
_a1673(_a1959, 6)
_a1680(_a1959, 8)
local _a1960 = _a1666("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a1665.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a1959)
task.spawn(function()
while _a1683 and _a1683.Parent do
local _a1961 = _a1652.ctl.now
local _a1962 = _a1622.auto and "🟢" or "⚪"
local _a1963 = _a1961.act or "-"
if _a1961.detail and _a1961.detail ~= "" then _a1963 = _a1963 .. "  " .. _a1961.detail end
_a1960.Text = table.concat({
_a1962 .. " " .. (_a1622.auto and (_a1961.step or "-") or "정지"),
"▸ " .. _a1963,
"목표 " .. (_a1961.goal or "-") .. (_a1961.prog ~= "" and ("   " .. _a1961.prog) or ""),
"1.리버스 " .. (_a1652.auto.rebNote or "-"),
"2.존해금 " .. (_a1652.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a1652.auto.farmZone or "-") .. "   현재 " .. tostring(_a1652.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a1652.auto.start()
for _a1964, _a1965 in ipairs(_a1652.auto.STEPS) do _a1622[_a1965.run] = false end
for _a1966, _a1967 in ipairs(_a1652.auto.SIDE) do _a1622[_a1967.run] = false end
_a1622.petspd = true
_a1622.rewatch = true
_a1747()
_a1664("auto", function() return _a1620.AutoInterval end, _a1652.auto.master, "자동")
end
_a1750(_a1958, "auto", _a1652.auto.start)
_a1761(_a1957, {
{ label = "주기", value = _a1620.AutoInterval, onChange = function(_a1968)
local _a1969 = tonumber(_a1968) if _a1969 and _a1969 >= 1 then _a1620.AutoInterval = _a1969 end
end },
{ label = "정체 판정(초)", value = _a1620.PursueStallSec, onChange = function(_a1970)
local _a1971 = tonumber(_a1970) if _a1971 and _a1971 >= 10 then _a1620.PursueStallSec = _a1971 end
end },
})
_a1761(_a1957, {
{ label = "운 퀘 최소 알 개수", value = _a1620.HatchMinAfford, onChange = function(_a1972)
local _a1973 = tonumber(_a1972) if _a1973 and _a1973 >= 1 then _a1620.HatchMinAfford = math.floor(_a1973) end
end },
{ label = "더 버는 시간(초)", value = _a1620.MoneyDwell, onChange = function(_a1974)
local _a1975 = tonumber(_a1974) if _a1975 and _a1975 >= 0 then _a1620.MoneyDwell = _a1975 end
end },
})
_a1761(_a1957, {
{ label = "부화 한 번에(초)", value = _a1620.HatchBudget, onChange = function(_a1976)
local _a1977 = tonumber(_a1976) if _a1977 and _a1977 >= 3 then _a1620.HatchBudget = _a1977 end
end },
})
_a1761(_a1957, {
{ label = "이동 방식", value = _a1620.TpMode, onChange = function(_a1978)
_a1978 = tostring(_a1978 or ""):lower()
if _a1978 == "instant" or _a1978 == "glide" or _a1978 == "walk" then _a1620.TpMode = _a1978 end
end },
{ label = "glide 속도", value = _a1620.TpSpeed, onChange = function(_a1979)
local _a1980 = tonumber(_a1979) if _a1980 and _a1980 >= 16 then _a1620.TpSpeed = _a1980 end
end },
})
_a1780(_a1957, "차단 화면에 실제 클릭까지 시도",
function() return _a1620.ScreenRealClick end,
function(_a1981) _a1620.ScreenRealClick = _a1981 end)
_a1780(_a1957, "퀘스트 없을 때도 알 까기",
function() return _a1620.IdleHatch end,
function(_a1982) _a1620.IdleHatch = _a1982 end)
_a1780(_a1957, "존 해금·리버스는 퀘스트 끝나고",
function() return _a1620.HoldZoneForQuest end,
function(_a1983) _a1620.HoldZoneForQuest = _a1983 end)
for _a1984, _a1985 in ipairs(_a1652.auto.STEPS) do
local _a1986 = _a1985.key
_a1780(_a1957, "  " .. _a1984 .. ". " .. _a1985.label,
function() return _a1620.StepOn[_a1986] end,
function(_a1987) _a1620.StepOn[_a1986] = _a1987 end)
end
for _a1988, _a1989 in ipairs(_a1652.auto.SIDE) do
local _a1990 = _a1989.key
_a1780(_a1957, "  · " .. _a1989.label .. " (순위 밖)",
function() return _a1620.StepOn[_a1990] end,
function(_a1991) _a1620.StepOn[_a1990] = _a1991 end)
end
_a1770(_a1957, {
{ label = "지금 상태", col = _a1665.accent, fn = function()
_a1616("")
_a1616("──── 올 자동 ────")
_a1616("  " .. (_a1622.auto and "돌아가는 중" or "정지") ..
(_a1652.auto.step and ("   지금: " .. _a1652.auto.step) or ""))
local _a1992, _a1993 = _a1652.quest.bestDepActive()
_a1616("  현재 존 " .. tostring(_a1652.move.curZone()) .. " / 최고 존 " .. tostring(_a1652.move.bestZone()))
if _a1992 then
_a1616("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a1993 and _a1993.title))
else
_a1616("  존해금·리버스 진행 가능")
end
_a1616("")
_a1616("  먼저 (순위 밖):")
for _a1994, _a1995 in ipairs(_a1652.auto.SIDE) do
_a1616(("      %-16s %s"):format(_a1995.label, _a1620.StepOn[_a1995.key] and "ON" or "off"))
end
_a1616("  우선순위:")
for _a1996, _a1997 in ipairs(_a1652.auto.STEPS) do
_a1616(("    %d. %-16s %s%s"):format(_a1996, _a1997.label,
_a1620.StepOn[_a1997.key] and "ON" or "off",
_a1997.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a1616("")
_a1616("  세이브")
local _a1998 = _a1618.Save
_a1616("    Library.Client.Save : " .. (_a1998 and "로드됨" or "★ 없음"))
if _a1998 then
local _a1999, _a2000 = pcall(_a1998.Get)
_a1616("    Get()        : " .. (_a1999 and type(_a2000) or ("에러 " .. tostring(_a2000))))
local _a2001, _a2002 = pcall(_a1998.Get, _a1614)
_a1616("    Get(LP)      : " .. (_a2001 and type(_a2002) or ("에러 " .. tostring(_a2002))))
if rawget(_a1998, "GetSaves") then
local _a2003, _a2004 = pcall(_a1998.GetSaves)
if _a2003 and type(_a2004) == "table" then
local _a2005 = 0
for _a2006 in pairs(_a2004) do
_a2005 += 1
if _a2005 <= 3 then _a1616("      키: " .. tostring(_a2006)
.. (_a2006 == _a1614 and "   ← 내 LocalPlayer" or "")) end
end
_a1616("    GetSaves()   : " .. _a2005 .. "개")
else
_a1616("    GetSaves()   : 에러 " .. tostring(_a2004))
end
end
local _a2007 = _a1653()
if _a2007 then
local _a2008 = rawget(_a2007, "Goals")
_a1616("    → 읽기 성공. Rebirths " .. tostring(rawget(_a2007, "Rebirths"))
.. " / Goals " .. (type(_a2008) == "table" and #_a2008 or "없음"))
else
_a1616("    → ★ 어떤 방법으로도 못 읽음")
end
end
_a1616("")
_a1616("  마지막 바퀴 (" .. tostring(_a1652.auto.passN or 0) .. "번째)")
if _a1652.auto.lastPassAt then
_a1616(("    %.0f초 전"):format(os.clock() - _a1652.auto.lastPassAt))
else
_a1616("    아직 한 바퀴도 안 돎 — 루프가 안 돌고 있습니다")
end
for _a2009, _a2010 in ipairs(_a1652.auto.lastTrace or {}) do _a1616("    " .. _a2010) end
_a1707("log")
end },
{ label = "화면 넘기기 진단", col = _a1665.warn, fn = function()
task.spawn(function()
_a1616("")
_a1616("──── 보상 화면 ────")
local _a2011 = _a1651.Vars
_a1616("  Library.Variables : " .. (_a2011 and "로드됨" or "없음"))
if _a2011 then
_a1616("    IsRebirthing = " .. tostring(rawget(_a2011, "IsRebirthing")))
_a1616("    IsRankingUp  = " .. tostring(rawget(_a2011, "IsRankingUp")))
_a1616("    OpeningEgg   = " .. tostring(rawget(_a2011, "OpeningEgg")))
end
_a1616("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a1616("  getgc          : " .. tostring(type(getgc) == "function"))
_a1616("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a2012 = _a1614:FindFirstChildOfClass("PlayerGui")
if _a2012 then
_a1616("  떠 있는 차단 화면:")
local _a2013 = false
for _a2014, _a2015 in ipairs(_a1652.screen.BLOCKERS) do
local _a2016 = _a2012:FindFirstChild(_a2015[1])
_a1616(("    %-14s %s"):format(_a2015[1],
_a2016 and (_a2016.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a2016 and _a2016.Enabled then _a2013 = true end
end
if not _a2013 then _a1616("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a1616("")
_a1616("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a2017, _a2018 = {}, 0
for _a2019, _a2020 in ipairs({ true, false }) do
local _a2021, _a2022 = pcall(getgc, _a2020)
if _a2021 then
for _a2023, _a2024 in ipairs(_a2022) do
if type(_a2024) == "function" and _a2018 < 25 then
local _a2025, _a2026 = pcall(debug.info, _a2024, "s")
if _a2025 and type(_a2026) == "string"
and (_a2026:find("Rebirth", 1, true) or _a2026:find("Rank Up", 1, true)) then
local _a2027, _a2028 = pcall(debug.info, _a2024, "a")
if _a2027 then
local _a2029 = {}
for _a2030 = 1, 16 do
local _a2031, _a2032 = pcall(debug.getupvalue, _a2024, _a2030)
if not _a2031 then break end
_a2029[_a2030] = type(_a2032)
end
local _a2033 = ("인자%d | %s"):format(_a2028 or -1,
#_a2029 > 0 and table.concat(_a2029, ",") or "(없음)")
if not _a2017[_a2033] then
_a2017[_a2033] = true
_a2018 += 1
_a1616("    " .. _a2033)
end
end
end
end
end
end
end
if _a2018 == 0 then _a1616("    (하나도 못 찾음)") end
end
for _a2034, _a2035 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a1652.screen._sig = nil
local _a2036 = _a1652.screen.findSignalFns(_a2035)
_a1616("")
_a1616(("  [%s] 찾은 함수 %d개"):format(_a2035, #_a2036))
for _a2037, _a2038 in ipairs(_a2036) do
_a1616(("    %s%s"):format(_a2038.exact and "★정확일치 " or "", tostring(_a2038.src)))
_a1616(("       upvalue %d개 : %s"):format(_a2038.n or 0, tostring(_a2038.sig)))
end
if #_a2036 == 0 then
_a1616("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a2039, _a2040 = _a1652.screen.signal(_a2035)
_a1616(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a2039), tostring(_a2040)))
local _a2041 = _a1652.screen.SIGNAL[_a2035]
_a1616(("    게임내 입력발동 : %s"):format(
tostring(_a1652.screen.pressInGame(_a2041 and _a2041.pats or {}))))
end
_a1616("")
_a1616("  감시 루프 RUN.rewatch = " .. tostring(_a1622.rewatch))
_a1707("log")
end)
end },
{ label = "한 바퀴만", col = _a1665.cardHi, fn = function()
task.spawn(function()
_a1622.auto = true _a1652.auto.master() _a1622.auto = false _a1707("log")
end)
end },
{ label = "자동 점검", col = _a1665.warn, fn = function()
task.spawn(function()
_a1616("")
_a1616("════ 올 자동 점검 ════")
_a1616("  RUN.auto = " .. tostring(_a1622.auto))
local _a2042 = {}
for _a2043, _a2044 in ipairs(_a1652.auto.SIDE) do
_a2042[#_a2042 + 1] = _a2044.key .. "=" .. tostring(_a1620.StepOn[_a2044.key])
end
for _a2045, _a2046 in ipairs(_a1652.auto.STEPS) do
_a2042[#_a2042 + 1] = _a2046.key .. "=" .. tostring(_a1620.StepOn[_a2046.key])
end
_a1616("  단계 ON/OFF : " .. table.concat(_a2042, "  "))
_a1616("  lockGoal    : " .. (_a1652.ctl.lockGoal and tostring(_a1652.ctl.lockGoal.q.title) or "없음"))
local _a2047, _a2048 = _a1652.quest.bestDepActive()
_a1616("  보류중?     : " .. tostring(_a2047) .. (_a2048 and ("  ← " .. tostring(_a2048.title)) or ""))
_a1616("  리모트      : 존 " .. (_a1651.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a1651.R_Reb and "O" or "X"))
_a1616("")
_a1616("  ── 존 해금 판정 ──")
local _a2049 = _a1656()
if not _a2049 then
_a1616("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a2050 = _a1651.Zone and rawget(_a1651.Zone, "GetNextZone")
if _a2050 then
local _a2051, _a2052, _a2053 = pcall(_a1651.Zone.GetNextZone)
_a1616("    GetNextZone → ok=" .. tostring(_a2051)
.. " / " .. tostring(_a2052) .. " / " .. tostring(_a2053))
end
if _a1651.Zone and rawget(_a1651.Zone, "HasCompletedNextZoneQuests") then
local _a2054, _a2055 = pcall(_a1651.Zone.HasCompletedNextZoneQuests)
_a1616("    존 퀘스트 완료? " .. (_a2054 and tostring(_a2055) or ("에러 " .. tostring(_a2055))))
end
else
_a1616("    다음 존 : " .. tostring(_a2049.id))
_a1616(("    가격 %s %s / 보유 %s → %s"):format(
_a1617(_a2049.price or 0, 0), tostring(_a2049.currency), _a1617(_a2049.have, 0),
_a2049.ok and "지금 살 수 있음" or "부족"))
end
_a1616("")
_a1616("  ── 리버스 판정 ──")
local _a2056 = _a1661()
if not _a2056 then _a1616("    세이브 못 읽음")
else
_a1616(("    현재 %d → 다음 %d"):format(_a2056.current, _a2056.nextN))
_a1616("    최근 사유 : " .. tostring(_a1652.auto.rebNote or "-"))
end
_a1616("")
_a1616("  ── 직전 바퀴 기록 ──")
if _a1652.auto.lastTrace and #_a1652.auto.lastTrace > 0 then
for _a2057, _a2058 in ipairs(_a1652.auto.lastTrace) do _a1616("    " .. _a2058) end
_a1616(("    (%.0f초 전)"):format(os.clock() - (_a1652.auto.lastPassAt or os.clock())))
else
_a1616("    아직 한 바퀴도 안 돌았음")
end
_a1707("log")
end)
end },
})
local _a2059, _a2060 = _a1740(_a1956, "펫 이동속도", nil)
_a1750(_a2060, "petspd", function()
_a1664("petspd", function() return 0.4 end, _a1652.item.applyPetSpeed, "펫속도")
end)
_a1761(_a2059, {
{ label = "배수", value = _a1620.PetSpeedMult, onChange = function(_a2061)
local _a2062 = tonumber(_a2061) if _a2062 and _a2062 >= 1 then _a1620.PetSpeedMult = _a2062 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a1620.PetSpeedBase, onChange = function(_a2063)
local _a2064 = tonumber(_a2063) if _a2064 and _a2064 > 0 then _a1620.PetSpeedBase = _a2064 end
end },
})
_a1770(_a2059, {
{ label = "지금 적용 / 확인", col = _a1665.accent, fn = function()
local _a2065, _a2066 = _a1652.item.applyPetSpeed()
_a1616("")
_a1616("──── 펫 이동속도 ────")
_a1616("  PlayerPet 모듈 : " .. (_a1651.PlayerPet and "로드됨" or "없음"))
_a1616(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a2065, tostring(_a1620.PetSpeedMult), tostring(_a1620.PetSpeedBase)))
if _a2066 then _a1616("  " .. tostring(_a2066)) end
if _a2065 == 0 then _a1616("  펫을 장착하고 다시 눌러보세요") end
_a1707("log")
end },
})
_a1664("petspd", function() return 0.4 end, _a1652.item.applyPetSpeed, "펫속도")
_a1664("rewatch", function() return 1 end, function()
_a1652.screen.watchTick = (_a1652.screen.watchTick or 0) + 1
_a1652.egg.watchStuck()
if _a1652.screen.dismissBusy then return end
local _a2067, _a2068 = _a1652.screen.rewardScreenUp()
if _a2067 and _a1652.screen.screenGaveUp and (os.clock() - _a1652.screen.screenGaveUp) < 30 then
return
end
if _a2067 then
if _a1652.screen.lastBlocker ~= _a2068 then
_a1652.screen.lastBlocker = _a2068
_a1616("[화면] " .. tostring(_a2068) .. " 화면 감지 — 넘기는 중")
end
_a1652.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a2069, _a2070 = _a1740(_a1956, "자동 파밍 유지", nil)
_a1750(_a2070, "farm", function()
_a1664("farm", function() return _a1620.FarmInterval end, _a1655, "파밍")
end)
_a1761(_a2069, {
{ label = "주기", value = _a1620.FarmInterval, onChange = function(_a2071)
local _a2072 = tonumber(_a2071) if _a2072 and _a2072 >= 3 then _a1620.FarmInterval = _a2072 end
end },
})
local _a2073, _a2074 = _a1740(_a1956, "자동 존 해금", nil)
_a1750(_a2074, "zone", function()
_a1664("zone", function() return _a1620.ZoneInterval end, _a1657, "존")
end)
_a1761(_a2073, {
{ label = "주기", value = _a1620.ZoneInterval, onChange = function(_a2075)
local _a2076 = tonumber(_a2075) if _a2076 and _a2076 >= 3 then _a1620.ZoneInterval = _a2076 end
end },
})
_a1770(_a2073, {
{ label = "다음 존 보기", col = _a1665.accent, fn = function()
local _a2077 = _a1656()
_a1616("")
if not _a2077 then _a1616("[존] 다음 존 없음 (최대 도달?)")
else
_a1616("──── 다음 존 ────")
_a1616("  " .. tostring(_a2077.id))
_a1616("  가격 " .. _a1617(_a2077.price or 0, 0) .. " " .. tostring(_a2077.currency))
_a1616("  보유 " .. _a1617(_a2077.have, 0))
_a1616("  " .. (_a2077.ok and "지금 해금 가능" or "부족"))
end
_a1707("log")
end },
{ label = "지금 1회", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.zone = true _a1657() _a1622.zone = false _a1707("log") end)
end },
})
local _a2078, _a2079 = _a1740(_a1956, "자동 부화", nil)
_a1750(_a2079, "mhatch", function()
_a1664("mhatch", function() return _a1620.MainHatchInterval end, _a1660, "부화")
end)
_a1761(_a2078, {
{ label = "주기", value = _a1620.MainHatchInterval, onChange = function(_a2080)
local _a2081 = tonumber(_a2080) if _a2081 and _a2081 >= 1 then _a1620.MainHatchInterval = _a2081 end
end },
{ label = "한 번에 최대", value = _a1620.MainHatchMax, onChange = function(_a2082)
local _a2083 = tonumber(_a2082) if _a2083 and _a2083 >= 1 then _a1620.MainHatchMax = math.floor(_a2083) end
end },
})
_a1761(_a2078, {
{ label = "예비금", value = _a1620.MainHatchReserve, onChange = function(_a2084)
local _a2085 = tonumber(_a2084) if _a2085 and _a2085 >= 0 then _a1620.MainHatchReserve = _a2085 end
end },
{ label = "알 ID (비우면 자동)", value = _a1620.MainEggId, onChange = function(_a2086)
_a1620.MainEggId = _a2086 or ""
end },
})
_a1761(_a2078, {
{ label = "알 인식 거리", value = _a1620.EggRange, onChange = function(_a2087)
local _a2088 = tonumber(_a2087) if _a2088 and _a2088 >= 5 then _a1620.EggRange = _a2088 end
end },
})
_a1780(_a2078, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a1620.AutoUnlockEgg end,
function(_a2089) _a1620.AutoUnlockEgg = _a2089 end)
_a1780(_a2078, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a1620.UseAutoHatch end,
function(_a2090) _a1620.UseAutoHatch = _a2090 if not _a2090 then _a1652.egg.autoHatchOff() end end)
_a1780(_a2078, "까는 화면 자동으로 넘기기 (신호)",
function() return _a1620.HatchClick end,
function(_a2091) _a1620.HatchClick = _a2091 end)
_a1770(_a2078, {
{ label = "잠긴 알 보기", col = _a1665.accent, fn = function()
local _a2092, _a2093, _a2094 = _a1652.egg.lockedEggs()
_a1616("")
_a1616("──── 알 해금 현황 ────")
_a1616(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a2093, _a2094))
_a1616("  해금 리모트 : " .. (_a1651.R_EggUn and "있음" or "없음"))
if #_a2092 == 0 then
_a1616("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a1616("  아직 안 푼 알 " .. #_a2092 .. "개:")
for _a2095, _a2096 in ipairs(_a2092) do
_a1616(("    #%-3d %s"):format(_a2096.num, _a2096.id))
if _a2095 >= 20 then _a1616("    ...") break end
end
end
_a1707("log")
end },
{ label = "부화 진단", col = _a1665.warn, fn = function()
task.spawn(function()
_a1616("")
_a1616("──── 부화 진단 ────")
local _a2097, _a2098, _a2099, _a2100 = _a1658()
_a1616("  대상 알   : " .. tostring(_a2097))
if not _a2097 then _a1616("  (오픈한 알이 없음)") _a1707("log") return end
local _a2101 = _a2098 and tonumber(rawget(_a2098, "eggNumber"))
_a1616("  알 번호   : " .. tostring(_a2101) .. "   오픈함? " .. tostring(_a1652.egg.eggUnlocked(_a2101)))
_a1616("  거리      : " .. (_a2099 and ("%.0f (사거리 안)"):format(_a2099)
or ((_a2100 and ("%.0f (사거리 %d 밖)"):format(_a2100, _a1620.EggRange)) or "받침대 못 찾음")))
local _a2102 = _a2098 and rawget(_a2098, "currency") or "?"
_a1616("  통화      : " .. tostring(_a2102) .. "   보유 " .. _a1617(_a1654(_a2102), 0))
if type(_a1651.CalcEgg) == "function" then
local _a2103, _a2104 = pcall(_a1651.CalcEgg, _a2098)
_a1616("  CalcEggPricePlayer : " .. (_a2103 and tostring(_a2104) or ("에러 " .. tostring(_a2104))))
end
if type(_a1651.CalcEggB) == "function" then
local _a2105, _a2106 = pcall(_a1651.CalcEggB, _a2098)
_a1616("  CalcEggPrice       : " .. (_a2105 and tostring(_a2106) or ("에러 " .. tostring(_a2106))))
end
if _a1651.Egg then
for _a2107, _a2108 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a1651.Egg, _a2108) then
local _a2109, _a2110 = pcall(_a1651.Egg[_a2108], _a2098)
_a1616(("  %-28s : %s"):format(_a2108, _a2109 and tostring(_a2110) or ("에러 " .. tostring(_a2110))))
end
end
end
_a1616("  OpeningEgg      : " .. tostring(_a1651.Vars and rawget(_a1651.Vars, "OpeningEgg")))
if _a1651.Hatch then
for _a2111, _a2112 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a1651.Hatch, _a2112) then
local _a2113, _a2114 = pcall(_a1651.Hatch[_a2112])
_a1616(("  %-15s : %s"):format(_a2112, _a2113 and tostring(_a2114) or ("에러 " .. tostring(_a2114))))
end
end
if rawget(_a1651.Hatch, "GetEggDirectory") then
local _a2115, _a2116 = pcall(_a1651.Hatch.GetEggDirectory)
_a1616("  세팅된 알       : " .. (_a2115 and _a2116 and tostring(rawget(_a2116, "_id")) or "없음"))
end
end
_a1616("  ▶ SetupEgg 시도")
_a1652.egg._ahEgg = nil
_a1652.egg.autoHatchOn(_a2097, 1)
if _a1651.Hatch and rawget(_a1651.Hatch, "IsHatching") then
local _a2117, _a2118 = pcall(_a1651.Hatch.IsHatching)
_a1616("    IsHatching 이후 : " .. (_a2117 and tostring(_a2118) or ("에러 " .. tostring(_a2118))))
_a1616("    " .. ((_a2117 and _a2118) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a1616("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a1616("")
_a1616("  ▶ 1개로 실제 호출")
local _a2119, _a2120
local _a2121 = pcall(function() _a2119, _a2120 = _a1619.R_EGG:InvokeServer(_a2097, 1) end)
_a1616("    호출성공 : " .. tostring(_a2121))
_a1616("    반환1    : " .. tostring(_a2119))
_a1616("    반환2    : " .. tostring(_a2120))
_a1707("log")
end)
end },
{ label = "지금 전부 해금", col = _a1665.good, fn = function()
task.spawn(function()
_a1616("")
local _a2122, _a2123 = _a1652.egg.unlockEggs(true)
_a1616(_a2122 > 0 and ("[해금] %d개 완료"):format(_a2122)
or ("[해금] 0개" .. (_a2123 and (" — " .. tostring(_a2123)) or "")))
_a1707("log")
end)
end },
})
_a1770(_a2078, {
{ label = "알 현황 보기", col = _a1665.accent, fn = function()
local _a2124 = _a1659()
_a1616("")
if not _a2124 then _a1616("[부화] 알을 못 찾음")
else
_a1616("──── 메인 알 ────")
_a1616("  " .. tostring(_a2124.id))
_a1616("  가격 " .. (_a2124.price and _a1617(_a2124.price, 0) or "?") .. " " .. tostring(_a2124.currency))
_a1616("  보유 " .. _a1617(_a2124.have, 0))
_a1616("  한 번에 " .. _a2124.maxN .. "개까지")
_a1616("  지금 가능 " .. _a2124.canBuy .. "회")
if _a2124.inRange then
_a1616(("  거리 %.0f 스터드 — 부화 가능"):format(_a2124.dist))
else
_a1616(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a1620.EggRange, _a2124.nearest and ("%.0f"):format(_a2124.nearest) or "?"))
_a1616("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a1616("")
_a1616("──── 주변 알 (가까운 순 10개) ────")
local _a2125 = _a1652.egg.eggStands()
for _a2126 = 1, math.min(10, #_a2125) do
local _a2127 = _a2125[_a2126]
_a1616(("  %6.0f  #%-3d %-24s %s"):format(
_a2127.dist, _a2127.num, _a2127.id, _a1652.egg.eggUnlocked(_a2127.num) and "오픈함" or "잠김"))
end
if #_a2125 == 0 then _a1616("  (못 찾음)") end
_a1707("log")
end },
{ label = "지금 1회", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.mhatch = true _a1660() _a1622.mhatch = false _a1707("log") end)
end },
})
local _a2128, _a2129 = _a1740(_a1956, "랭크 퀘스트 자동", nil)
_a1750(_a2129, "quest", function()
_a1664("quest", function() return _a1620.QuestInterval end, _a1652.quest.cycle, "퀘스트")
end)
_a1761(_a2128, {
{ label = "주기", value = _a1620.QuestInterval, onChange = function(_a2130)
local _a2131 = tonumber(_a2130) if _a2131 and _a2131 >= 5 then _a1620.QuestInterval = _a2131 end
end },
{ label = "포션 한 번에", value = _a1620.QuestUseMax, onChange = function(_a2132)
local _a2133 = tonumber(_a2132) if _a2133 and _a2133 >= 1 then _a1620.QuestUseMax = math.floor(_a2133) end
end },
})
_a1780(_a2128, "필요한 자동화 자동 ON",
function() return _a1620.QuestDrive end,
function(_a2134) _a1620.QuestDrive = _a2134 end)
_a1780(_a2128, "포션/인챈트 업글 퀘스트",
function() return _a1620.QuestUpgrade end,
function(_a2135) _a1620.QuestUpgrade = _a2135 end)
_a1780(_a2128, "포션 사용 퀘스트",
function() return _a1620.QuestUsePotion end,
function(_a2136) _a1620.QuestUsePotion = _a2136 end)
_a1770(_a2128, {
{ label = "퀘스트 현황 보기", col = _a1665.accent, fn = function()
local _a2137 = _a1652.quest.status()
_a1616("")
if not _a2137 then _a1616("[퀘스트] 세이브 못 읽음")
else
_a1616("──── 랭크 퀘스트 ────")
_a1616(("  Rank %d   ★%d"):format(_a2137.rank, _a2137.rankStars))
if #_a2137.list == 0 then _a1616("  퀘스트 없음") end
for _a2138, _a2139 in ipairs(_a2137.list) do
local _a2140 = _a2139.how
local _a2141 =
(_a2140 == "farm" and "자동 파밍") or
(_a2140 == "hatch" and "자동 부화") or
(_a2140 == "zone" and "자동 존") or
(_a2140 == "potup" and "포션 업글") or
(_a2140 == "encup" and "인챈트 업글") or
(_a2140 == "potuse" and "포션 사용") or
(_a2140 == "fruituse" and "과일 사용") or
(_a2140 == "flaguse" and "깃발 사용") or
(_a2140 == "gold" and "골드 머신") or
(_a2140 == "rainbow" and "레인보우 머신") or
"수동"
local _a2142 = ""
if _a2139.ignored then
_a2141 = "무시"
_a2142 = "   → " .. _a2139.ignored
elseif _a2139.event then
local _a2143 = _a1652.ev.findEvent(_a2139.event, _a2139.bestOnly)
_a2142 = _a2143 and ("   → %s @%s %d초"):format(_a2143.name, tostring(_a2143.zone), _a2143.left)
or ("   → " .. _a2139.event .. " 대기중")
elseif _a2139.chest then
_a2142 = "   → " .. _a2139.chest
elseif _a2139.where then
_a2142 = "   → " .. _a2139.where
end
_a1616(("  [%d] %s"):format(_a2139.stars, tostring(_a2139.title)))
_a1616(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a2139.progress, _a2139.amount, _a2141, _a2139.type, _a2142))
end
end
_a1707("log")
end },
{ label = "활성 이벤트 보기", col = _a1665.accent, fn = function()
local _a2144 = _a1652.ev.events()
local _a2145 = _a1652.move.bestZone()
_a1616("")
_a1616("──── 지금 떠 있는 랜덤 이벤트 ────")
_a1616("  최고 존 : " .. tostring(_a2145) .. "   현재 존 : " .. tostring(_a1652.move.curZone()))
if #_a2144 == 0 then _a1616("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a2146, _a2147 in ipairs(_a2144) do
_a1616(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a2147.kind, tostring(_a2147.zone), _a2147.left,
_a2147.pos and ("(%.0f, %.0f, %.0f)"):format(_a2147.pos.X, _a2147.pos.Y, _a2147.pos.Z) or "좌표없음",
_a2147.zone == _a2145 and "  ★최고존" or ""))
end
_a1616("")
_a1616("  내 소환 아이템 :")
for _a2148 in pairs(_a1652.ev.SPAWN) do
local _a2149 = _a1652.ev.spawnItems(_a2148)
local _a2150 = 0
for _a2151, _a2152 in ipairs(_a2149) do _a2150 += _a2152.am end
_a1616(("    %-12s %d종 %d개"):format(_a2148, #_a2149, _a2150))
for _a2153, _a2154 in ipairs(_a2149) do
_a1616(("        %d. %-24s x%d%s"):format(
_a2153, _a2154.id, _a2154.am, _a2153 == 1 and "   ← 먼저 씀" or ""))
if _a2153 >= 6 then break end
end
end
_a1616("  점선 네모 안? " .. tostring(_a1652.move.inDottedBox()))
for _a2155, _a2156 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a2157, _a2158 = _a1652.ev.findChest(_a2156)
_a1616(("  %-20s %s"):format(_a2156,
_a2157 and ("가장 가까운 것 %.0f스터드"):format(_a2158 or 0) or "없음"))
end
_a1707("log")
end },
{ label = "포션 재고 보기", col = _a1665.accent, fn = function()
_a1616("")
_a1616("──── 포션 / 인챈트 재고 ────")
for _a2159, _a2160 in ipairs({ "Potion", "Enchant" }) do
local _a2161 = _a1652.item.stacks(_a2160)
table.sort(_a2161, function(_a2162, _a2163)
if _a2162.id ~= _a2163.id then return _a2162.id < _a2163.id end
return _a2162.tier < _a2163.tier
end)
_a1616("")
_a1616(_a2160 .. "  (" .. #_a2161 .. "종)")
for _a2164, _a2165 in ipairs(_a2161) do
local _a2166 = _a1652.item.perTier(_a2160, _a2165.tier)
local _a2167 = _a2166 and math.floor(_a2165.am / _a2166) or 0
_a1616(("   %-20s T%-2d x%-6d %s"):format(
_a2165.id, _a2165.tier, _a2165.am,
_a2167 > 0 and ("→ T" .. (_a2165.tier + 1) .. " " .. _a2167 .. "개 제작가능") or ""))
if _a2164 >= 40 then _a1616("   ...") break end
end
if #_a2161 == 0 then _a1616("   (없음)") end
end
_a1707("log")
end },
{ label = "지금 1회", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.quest = true _a1652.quest.cycle() _a1622.quest = false _a1707("log") end)
end },
})
local _a2168, _a2169 = _a1740(_a1956, "슬롯 머신 자동 (다이아)", nil)
_a1750(_a2169, "slots", function()
_a1664("slots", function() return _a1620.SlotInterval end, _a1652.mach.cycleSlots, "슬롯")
end)
_a1761(_a2168, {
{ label = "주기", value = _a1620.SlotInterval, onChange = function(_a2170)
local _a2171 = tonumber(_a2170) if _a2171 and _a2171 >= 5 then _a1620.SlotInterval = _a2171 end
end },
{ label = "남길 다이아", value = _a1620.SlotReserve, onChange = function(_a2172)
local _a2173 = tonumber(_a2172) if _a2173 and _a2173 >= 0 then _a1620.SlotReserve = _a2173 end
end },
})
_a1780(_a2168, "펫 장착 슬롯 (Pet Equip)",
function() return _a1620.SlotPet end, function(_a2174) _a1620.SlotPet = _a2174 end)
_a1780(_a2168, "알 부화 슬롯 (Egg Machine)",
function() return _a1620.SlotEgg end, function(_a2175) _a1620.SlotEgg = _a2175 end)
_a1770(_a2168, {
{ label = "슬롯 현황 보기", col = _a1665.accent, fn = function()
local _a2176 = _a1652.mach.slotStatus()
_a1616("")
_a1616("──── 슬롯 머신 ────")
if not _a2176 then _a1616("  세이브 못 읽음") _a1707("log") return end
_a1616("  다이아 " .. _a1617(_a2176.dia, 0))
_a1616("")
_a1616(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a2176.petOwned, _a2176.petMax, tostring(_a2176.maxEquip)))
if _a2176.petNext then
_a1616(("     다음 #%d  %s 다이아  %s"):format(
_a2176.petNext, _a2176.petCost and _a1617(_a2176.petCost, 0) or "?",
(_a2176.petCost and _a2176.petCost <= _a2176.dia - _a1620.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1616("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a1616("")
_a1616(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a2176.eggOwned, _a2176.eggMax, tostring(_a2176.maxHatch)))
if _a2176.eggEnd then
_a1616(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a2176.eggSize, _a2176.eggEnd, _a2176.eggCost and _a1617(_a2176.eggCost, 0) or "?",
(_a2176.eggCost and _a2176.eggCost <= _a2176.dia - _a1620.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1616("     랭크 상한까지 다 삼")
end
_a1616("")
_a1616("  리모트 : 펫 " .. (_a1651.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a1651.R_EggSlot and "O" or "X"))
_a1707("log")
end },
{ label = "지금 1회", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.slots = true _a1652.mach.cycleSlots() _a1622.slots = false _a1707("log") end)
end },
})
local _a2177, _a2178 = _a1740(_a1956, "아이템 자동 사용 (버프 유지)", nil)
_a1750(_a2178, "items", function()
_a1664("items", function() return _a1620.ItemInterval end, _a1652.item.cycleItems, "아이템")
end)
_a1761(_a2177, {
{ label = "주기", value = _a1620.ItemInterval, onChange = function(_a2179)
local _a2180 = tonumber(_a2179) if _a2180 and _a2180 >= 5 then _a1620.ItemInterval = _a2180 end
end },
{ label = "포션 한 바퀴 최대", value = _a1620.BuffMaxPotion, onChange = function(_a2181)
local _a2182 = tonumber(_a2181) if _a2182 and _a2182 >= 1 then _a1620.BuffMaxPotion = math.floor(_a2182) end
end },
})
_a1761(_a2177, {
{ label = "남길 개수", value = _a1620.ItemKeep, onChange = function(_a2183)
local _a2184 = tonumber(_a2183) if _a2184 and _a2184 >= 0 then _a1620.ItemKeep = math.floor(_a2184) end
end },
{ label = "과일/소모품 최대", value = _a1620.BuffMaxOther, onChange = function(_a2185)
local _a2186 = tonumber(_a2185) if _a2186 and _a2186 >= 1 then _a1620.BuffMaxOther = math.floor(_a2186) end
end },
})
_a1761(_a2177, {
{ label = "쓸 것 (비우면 전부)", value = _a1620.ItemAllow, onChange = function(_a2187)
_a1620.ItemAllow = _a2187 or ""
end },
{ label = "제외", value = _a1620.ItemBlock, onChange = function(_a2188)
_a1620.ItemBlock = _a2188 or ""
end },
})
_a1780(_a2177, "포션", function() return _a1620.BuffPotion end,
function(_a2189) _a1620.BuffPotion = _a2189 end)
_a1780(_a2177, "과일", function() return _a1620.BuffFruit end,
function(_a2190) _a1620.BuffFruit = _a2190 end)
_a1780(_a2177, "얼티밋 (충전되면 발동, 무료)", function() return _a1620.BuffUltimate end,
function(_a2191) _a1620.BuffUltimate = _a2191 end)
_a1780(_a2177, "소모품 (Rain/Sunlight 주의)", function() return _a1620.BuffConsumable end,
function(_a2192) _a1620.BuffConsumable = _a2192 end)
_a1780(_a2177, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a1620.BuffHighTier end,
function(_a2193) _a1620.BuffHighTier = _a2193 end)
_a1780(_a2177, "최고 존에서만 사용", function() return _a1620.ItemBestZone end,
function(_a2194) _a1620.ItemBestZone = _a2194 end)
_a1780(_a2177, "최고 존이 아니면 이동 후 사용", function() return _a1620.ItemTp end,
function(_a2195) _a1620.ItemTp = _a2195 end)
_a1770(_a2177, {
{ label = "버프 현황 보기", col = _a1665.accent, fn = function()
_a1616("")
_a1616("──── 버프 / 아이템 ────")
_a1616(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a1652.move.curZone()), tostring(_a1652.move.bestZone()),
_a1620.ItemBestZone and (_a1652.move.curZone() == _a1652.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a2196, _a2197 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a2198 = _a1652.item.activeBuffs(_a2196)
local _a2199 = {}
for _a2200 in pairs(_a2198) do _a2199[#_a2199 + 1] = _a2200 end
table.sort(_a2199)
_a1616(("  지금 걸린 %s : %s"):format(_a2196,
#_a2199 > 0 and table.concat(_a2199, ", ") or "없음"))
end
local _a2201 = _a1653()
local _a2202 = _a2201 and rawget(_a2201, "Ultimates")
if type(_a2202) == "table" then
local _a2203 = {}
for _a2204 in pairs(_a2202) do
local _a2205 = "?"
if _a1651.Ult and rawget(_a1651.Ult, "IsCharged") then
local _a2206, _a2207 = pcall(_a1651.Ult.IsCharged, _a2204)
_a2205 = _a2206 and (_a2207 and "충전됨" or "충전중") or "?"
end
_a2203[#_a2203 + 1] = _a2204 .. "(" .. _a2205 .. ")"
end
_a1616("  얼티밋 : " .. (#_a2203 > 0 and table.concat(_a2203, ", ") or "없음"))
end
_a1616("")
for _a2208, _a2209 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a2210 = _a1652.item.stacks(_a2209)
local _a2211, _a2212 = 0, 0
for _a2213, _a2214 in ipairs(_a2210) do
if _a1652.item.itemAllowed(_a2214.id) then _a2211 += 1 else _a2212 += 1 end
end
_a1616(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a2209, #_a2210, _a2211, _a2212))
for _a2215, _a2216 in ipairs(_a2210) do
_a1616(("      %-20s T%-2d x%-6d %s"):format(
_a2216.id, _a2216.tier, _a2216.am, _a1652.item.itemAllowed(_a2216.id) and "" or "제외됨"))
if _a2215 >= 12 then _a1616("      ...") break end
end
end
_a1616("")
_a1616("  리모트 : 포션 " .. (_a1651.R_PotUse and "O" or "X")
.. " / 과일 " .. (_a1651.R_Fruit and "O" or "X")
.. " / 소모품 " .. (_a1651.R_Cons and "O" or "X")
.. " / 얼티밋 " .. (_a1651.R_Ult and "O" or "X"))
_a1707("log")
end },
{ label = "지금 1회", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.items = true _a1652.item.cycleItems() _a1622.items = false _a1707("log") end)
end },
})
local _a2217, _a2218 = _a1740(_a1956, "맵 업그레이드 자동 (다이아)", nil)
_a1750(_a2218, "mapupg", function()
_a1664("mapupg", function() return _a1620.UpgInterval end, _a1652.mach.cycleUpg, "맵업글")
end)
_a1761(_a2217, {
{ label = "주기", value = _a1620.UpgInterval, onChange = function(_a2219)
local _a2220 = tonumber(_a2219) if _a2220 and _a2220 >= 5 then _a1620.UpgInterval = _a2220 end
end },
{ label = "남길 다이아", value = _a1620.UpgReserve, onChange = function(_a2221)
local _a2222 = tonumber(_a2221) if _a2222 and _a2222 >= 0 then _a1620.UpgReserve = _a2222 end
end },
})
_a1780(_a2217, "구매 전 그 앞으로 이동",
function() return _a1620.UpgTp end,
function(_a2223) _a1620.UpgTp = _a2223 end)
_a1770(_a2217, {
{ label = "업그레이드 목록", col = _a1665.accent, fn = function()
local _a2224 = _a1652.mach.upgList()
local _a2225 = _a1654("Diamonds")
_a1616("")
_a1616("──── 맵 업그레이드 ────")
_a1616("보유 다이아 " .. _a1617(_a2225, 0))
if #_a2224 == 0 then
_a1616("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a2226, _a2227, _a2228 = 0, 0, 0
for _a2229, _a2230 in ipairs(_a2224) do
if _a2230.bought then _a2227 += 1
elseif not _a2230.zoneOwned then _a2228 += 1
else _a2226 += 1 end
end
_a1616(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a2226, _a2227, _a2228))
_a1616("")
local _a2231 = 0
for _a2232, _a2233 in ipairs(_a2224) do
if _a2233.buyable then
_a2231 += 1
_a1616(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a2233.id, _a2233.tier, _a2233.zone, _a2233.cost and _a1617(_a2233.cost, 0) or "?",
tostring(_a2233.cur),
(_a2233.cost and _a2233.cost <= _a1654(_a2233.cur or "Diamonds") - _a1620.UpgReserve)
and "← 지금 가능" or ""))
if _a2231 >= 25 then _a1616("  ...") break end
end
end
_a1707("log")
end },
{ label = "업글 진단", col = _a1665.warn, fn = function()
task.spawn(function()
_a1616("")
_a1616("──── 맵 업그레이드 진단 ────")
_a1616("  리모트 : " .. (_a1651.R_Upg and _a1651.R_Upg:GetFullName() or "없음"))
local _a2234 = _a1652.mach.upgList()
_a1616("  로드된 기둥 " .. #_a2234 .. "개")
local _a2235
for _a2236, _a2237 in ipairs(_a2234) do
if _a2237.buyable and _a2237.cost then _a2235 = _a2237 break end
end
if not _a2235 then
_a1616("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a2238, _a2239 in ipairs(_a2234) do
_a1616(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a2239.id, _a2239.tier, tostring(_a2239.zone), tostring(_a2239.bought), tostring(_a2239.zoneOwned)))
if _a2238 >= 8 then _a1616("   ...") break end
end
_a1707("log") return
end
local _a2240 = _a1654(_a2235.cur or "Diamonds")
local _a2241 = _a1652.move.hrp()
local _a2242 = (_a2241 and _a2235.pos) and (_a2241.Position - _a2235.pos).Magnitude or nil
_a1616(("  대상 : %s T%d @%s"):format(_a2235.id, _a2235.tier, tostring(_a2235.zone)))
_a1616(("  가격 : %s %s / 보유 %s"):format(
_a1617(_a2235.cost, 0), tostring(_a2235.cur), _a1617(_a2240, 0)))
_a1616("  거리 : " .. (_a2242 and ("%.0f 스터드"):format(_a2242) or "좌표 없음"))
_a1616("")
_a1616("  ▶ 제자리에서 호출")
local _a2243, _a2244
local _a2245 = pcall(function() _a2243, _a2244 = _a1651.R_Upg:InvokeServer(_a2235.id, _a2235.zone) end)
_a1616("    호출성공 " .. tostring(_a2245) .. " / 반환1 " .. tostring(_a2243)
.. " / 반환2 " .. tostring(_a2244))
if not _a2243 and _a2235.pos then
_a1616("")
_a1616("  ▶ 기둥 앞으로 이동해서 재시도")
_a1652.move.glideTo(_a2235.pos)
task.wait(0.3)
local _a2246 = _a1652.move.hrp()
_a1616("    이동후 거리 " .. (_a2246 and ("%.0f"):format((_a2246.Position - _a2235.pos).Magnitude) or "?"))
local _a2247, _a2248
local _a2249 = pcall(function() _a2247, _a2248 = _a1651.R_Upg:InvokeServer(_a2235.id, _a2235.zone) end)
_a1616("    호출성공 " .. tostring(_a2249) .. " / 반환1 " .. tostring(_a2247)
.. " / 반환2 " .. tostring(_a2248))
_a1616("")
_a1616(_a2247 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a1616("")
_a1616(_a2243 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a1707("log")
end)
end },
{ label = "지금 1회", col = _a1665.cardHi, fn = function()
task.spawn(function() _a1622.mapupg = true _a1652.mach.cycleUpg() _a1622.mapupg = false _a1707("log") end)
end },
})
local _a2250, _a2251 = _a1740(_a1956, "자동 리버스", nil)
_a1750(_a2251, "mreb", function()
_a1664("mreb", function() return _a1620.MainRebirthInterval end, _a1662, "리버스")
end)
_a1761(_a2250, {
{ label = "주기", value = _a1620.MainRebirthInterval, onChange = function(_a2252)
local _a2253 = tonumber(_a2252) if _a2253 and _a2253 >= 10 then _a1620.MainRebirthInterval = _a2253 end
end },
})
_a1780(_a2250, "실패 이유 로그",
function() return _a1620.MainRebirthVerbose end,
function(_a2254) _a1620.MainRebirthVerbose = _a2254 end)
_a1770(_a2250, {
{ label = "리버스 현황 보기", col = _a1665.accent, fn = function()
local _a2255 = _a1661()
_a1616("")
if not _a2255 then _a1616("[리버스] 세이브 못 읽음")
else
_a1616("──── 메인 리버스 ────")
_a1616("  현재 " .. _a2255.current .. "회 → 다음 " .. _a2255.nextN)
if type(_a2255.def) == "table" then
for _a2256, _a2257 in pairs(_a2255.def) do
if type(_a2257) ~= "table" and type(_a2257) ~= "function" then
_a1616("    " .. tostring(_a2256) .. " = " .. tostring(_a2257))
end
end
end
end
_a1707("log")
end },
{ label = "지금 1회", col = _a1665.bad, fn = function()
task.spawn(function() _a1622.mreb = true _a1662() _a1622.mreb = false _a1707("log") end)
end },
})
local _a2258 = _a1740(_a1956, "전체 제어", nil)
_a1770(_a2258, {
{ label = "메인 전부 ON", col = _a1665.good, fn = function()
local _a2259 = {
{ "farm",   function() return _a1620.FarmInterval end,       _a1655,       "파밍" },
{ "zone",   function() return _a1620.ZoneInterval end,       _a1657,       "존" },
{ "mhatch", function() return _a1620.MainHatchInterval end,  _a1660,  "부화" },
{ "quest",  function() return _a1620.QuestInterval end,      _a1652.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a1620.UpgInterval end,        _a1652.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a1620.ItemInterval end,       _a1652.item.cycleItems,   "아이템" },
{ "slots",  function() return _a1620.SlotInterval end,       _a1652.mach.cycleSlots,   "슬롯" },
}
for _a2260, _a2261 in ipairs(_a2259) do
if not _a1622[_a2261[1]] then
_a1622[_a2261[1]] = true
_a1664(_a2261[1], _a2261[2], _a2261[3], _a2261[4])
end
end
_a1747()
_a1616("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a1665.bad, fn = function()
_a1652.ctl.stopAll()
_a1747()
_a1616("[메인] 정지")
end },
})
end
_a1698.MouseButton1Click:Connect(function()
local _a2262 = table.concat(_a1615, "\n")
if #_a2262 > 900000 then _a2262 = _a2262:sub(#_a2262 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a2262)
_a1698.Text = "완료"
task.delay(1.5, function() if _a1698 then _a1698.Text = "복사" end end)
end
end)
_a1697.MouseButton1Click:Connect(function()
table.clear(_a1615)
_a1792.top = nil
_a1611.dirty = true
end)
local function _a2263()
_a1622.place, _a1622.merchant, _a1622.upgrade = false, false, false
_a1622.towerup, _a1622.crop, _a1622.expand, _a1622.rebirth, _a1622.hatch, _a1622.luck = false, false, false, false, false, false
_a1622.farm, _a1622.zone, _a1622.mhatch, _a1622.rank, _a1622.mreb = false, false, false, false, false
if _a1812 then _a1812:Disconnect() end
if _a1683 then _a1683:Destroy() end
_G.__PS99_GARDEN = nil
end
_a1695.MouseButton1Click:Connect(_a2263)
_G.__PS99_GARDEN = _a2263
_a1707("dash")
_a1616("PS99 자동")
if _a1611.lpWait then
_a1616(("[진단] LocalPlayer 가 늦게 잡혔습니다 — %.1f초 대기, 결과 %s")
:format(_a1611.lpWait, _a1611.lpFail and "★ 실패" or "성공"))
end
if _a1611.lpFail then
_a1616("[진단] ★ LocalPlayer 를 못 잡아 이동·부화가 전부 안 됩니다.")
_a1616("        게임이 완전히 로드된 뒤에 다시 실행해 주세요.")
end
if _a1611.libWait then
_a1616(("[진단] 게임 모듈(Library/Network)도 늦게 잡혔습니다 — %.1f초 대기")
:format(_a1611.libWait))
end
if _a1611.libFail then
_a1616("[진단] ★ " .. _a1611.libFail .. " 를 못 찾았습니다 — 게임 로드 후 다시 실행하세요")
end
if _a1622.auto then
if _a1652.auto.start then
_a1616("[자동] 올 자동 켜짐 — 1초 뒤 시작합니다")
task.spawn(function()
task.wait(1)
_a1652.ctl.abort = false
local _a2264, _a2265 = pcall(_a1652.auto.start)
if _a2264 then
_a1616("[자동] 시작됨")
else
_a1622.auto = false
_a1616("[자동] 시작 실패: " .. tostring(_a2265))
if _a1652.auto.refresh then pcall(_a1652.auto.refresh) end
end
end)
else
_a1622.auto = false
_a1616("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a2266, _a2267, _a2268, _a2269 = _a1625()
if _a2266 and _a2268 then
local _a2270 = _a1626(_a2268, _a2269)
_a1623.slots = #_a2270
_a1616("레인 " .. _a2269 .. " / 슬롯 " .. #_a2270)
else
_a1616("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a1623.sun = _a1631()
_a1616("Sunflowers " .. _a1617(_a1623.sun, 0))
end)
end)(_a1)
