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
local _a1032
if _a583.ZonesU and rawget(_a583.ZonesU, "GetBreakableZones") then
local _a1033, _a1034 = pcall(_a583.ZonesU.GetBreakableZones, _a1028)
if _a1033 then _a1032 = _a1034 end
end
if not _a1032 and _a1031 then
local _a1035, _a1036 = pcall(function()
local _a1037 = _a1031:FindFirstChild("INTERACT")
return _a1037 and _a1037:FindFirstChild("BREAK_ZONES")
end)
if _a1035 then _a1032 = _a1036 end
end
local _a1038 = {}
if _a1032 then
if _a1032:IsA("BasePart") then _a1038[#_a1038 + 1] = _a1032 end
local _a1039, _a1040 = pcall(function() return _a1032:GetDescendants() end)
if _a1039 then
for _a1041, _a1042 in ipairs(_a1040) do
if _a1042:IsA("BasePart") then _a1038[#_a1038 + 1] = _a1042 end
end
end
end
local _a1043
if _a583.ZonesU and rawget(_a583.ZonesU, "GetTeleportPartLocation") then
local _a1044, _a1045 = pcall(_a583.ZonesU.GetTeleportPartLocation, _a1028)
if _a1044 and typeof(_a1045) == "CFrame" then _a1043 = _a1045.Position end
end
local _a1046 = _a585.move.badSpot and _a585.move.badSpot[_a1028]
local function _a1047(_a1048)
if not _a1046 then return false end
for _a1049, _a1050 in ipairs(_a1046) do
if (_a1050 - _a1048).Magnitude <= 60 then return true end
end
return false
end
local _a1051, _a1052, _a1053
for _a1054, _a1055 in ipairs(_a1038) do
if not _a1047(_a1055.Position) then
local _a1056 = _a1055.Size.X * _a1055.Size.Z
local _a1057 = (not _a1052) or _a1056 > _a1052 * 1.2
if not _a1057 and _a1052 and _a1056 > _a1052 * 0.8 and _a1043 and _a1051 then
_a1057 = (_a1055.Position - _a1043).Magnitude < (_a1051 - _a1043).Magnitude
end
if _a1057 then _a1051, _a1052, _a1053 = _a1055.Position, _a1056, _a1055.Name end
end
end
local _a1058, _a1059
if _a1051 then
_a1058 = _a1051
_a1059 = ("BREAK_ZONES/%s (%.0f x %.0f)"):format(
tostring(_a1053), math.sqrt(_a1052), math.sqrt(_a1052))
end
if not _a1058 and _a1043 then
_a1058, _a1059 = _a1043, "PERSISTENT/Teleport (스트리밍 대기)"
end
if not _a1058 then return nil, "BREAK_ZONES 를 못 찾음" end
local _a1060 = _a585.move.groundY(_a1058.X, _a1058.Z, _a1058.Y)
if _a1060 then
_a1058 = Vector3.new(_a1058.X, _a1060, _a1058.Z)
_a1059 = _a1059 .. " +지면"
else
_a1058 = Vector3.new(_a1058.X, _a1058.Y + 5, _a1058.Z)
end
return _a1058, _a1059
end
function _a585.move.goToZone(_a1061, _a1062, _a1063, _a1064)
_a1061 = _a585.move.realZone(_a1061)
if not _a1061 then return false, "존 id 없음" end
local _a1065, _a1066 = _a585.move.zonePos(_a1061)
if not _a1065 then
if _a578.TpGameFallback and _a585.move.curZone() ~= _a1061 then
local _a1067, _a1068 = _a585.move.tpZone(_a1061)
if not _a1067 then return false, _a1068 end
task.wait(0.3)
_a1065, _a1066 = _a585.move.zonePos(_a1061)
end
if not _a1065 then
local _a1069, _a1070 = _a585.move.resolvableZone(_a1061)
if _a1069 and _a1070 then
if _a1064 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a1061))
end
_a1061, _a1065, _a1066 = _a1069, _a1070, "대체 존 " .. tostring(_a1069)
else
if _a585.move.zoneFailSaid ~= _a1061 then
_a585.move.zoneFailSaid = _a1061
_a572(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a1061), tostring(_a1066)))
end
return false, _a1066
end
end
end
local _a1071 = _a585.move.hrp()
if not _a1063 and _a1071 and _a585.move.curZone() == _a1061 then
local _a1072 = _a585.move.inDottedBox()
local _a1073
if _a1072 ~= nil then
_a1073 = _a1072
else
_a1073 = (_a1071.Position - _a1065).Magnitude <= (_a578.ZoneArriveDist or 90)
end
if _a1073 then
if _a1062 then _a572("[TP] 이미 " .. _a1061 .. " 사냥터 안에 있음") end
return true
end
end
if _a1062 then
_a572(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a1061, tostring(_a1066), _a1065.X, _a1065.Y, _a1065.Z))
end
local _a1074, _a1075 = _a585.move.glideTo(_a1065)
local _a1076 = _a585.move.hrp()
if _a1076 and (_a1076.Position - _a1065).Magnitude > math.max(40, _a578.ArriveDist or 12) then
task.wait(0.2)
_a585.ctl.moving = nil
_a585.move.glideTo(_a1065)
local _a1077 = _a585.move.hrp()
local _a1078 = _a1077 and (_a1077.Position - _a1065).Magnitude or -1
if _a1078 > math.max(40, _a578.ArriveDist or 12) then
local _a1079 = _a578.TpMode
_a578.TpMode = "glide"
_a585.ctl.moving = nil
_a585.move.glideTo(_a1065)
_a578.TpMode = _a1079
local _a1080 = _a585.move.hrp()
_a1078 = _a1080 and (_a1080.Position - _a1065).Magnitude or -1
if _a1078 > math.max(40, _a578.ArriveDist or 12) then
_a572(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a1061), _a1078))
return false, "이동이 되돌려짐"
end
_a572("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a1061))
end
end
do
local _a1081 = _a585.move.hrp()
if _a1081 and (_a1081.Position.Y - _a1065.Y) > 25 then
_a572(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a1081.Position.Y - _a1065.Y))
_a585.ctl.moving = nil
_a585.move.glideTo(Vector3.new(_a1065.X, _a1065.Y, _a1065.Z))
end
end
if tostring(_a1066):find("스트리밍", 1, true) then
task.wait(1.2)
local _a1082, _a1083 = _a585.move.zonePos(_a1061)
if _a1082 and not tostring(_a1083):find("스트리밍", 1, true) then
if _a1062 then
_a572("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a1083) .. ")")
end
_a585.ctl.moving = nil
_a585.move.glideTo(_a1082)
_a1065, _a1066 = _a1082, _a1083
end
end
if _a585.move.inDottedBox() == false then
task.wait(0.3)
if _a585.move.inDottedBox() == false then
if _a1062 then _a572("[TP] 아직 네모 밖 → 한 번 더 이동") end
_a585.ctl.moving = nil
_a585.move.glideTo(_a1065)
task.wait(0.3)
end
if _a585.move.inDottedBox() == false and _a585.move.curZone() == _a1061 then
_a585.move.badSpot = _a585.move.badSpot or {}
local _a1084 = _a585.move.badSpot[_a1061] or {}
if #_a1084 < 3 then
_a1084[#_a1084 + 1] = _a1065
_a585.move.badSpot[_a1061] = _a1084
_a572(("[TP] %s — 갔는데 사냥터 밖입니다. 이 지점은 앞으로 안 씁니다"):format(
tostring(_a1061)))
_a572(("        %s   좌표 (%.0f, %.0f, %.0f)"):format(
tostring(_a1066), _a1065.X, _a1065.Y, _a1065.Z))
else
_a585.move.badSpot[_a1061] = nil
_a572("[TP] " .. tostring(_a1061) .. " — 쓸만한 지점을 못 찾아 기록을 지웁니다")
end
return false, "사냥터 밖"
end
end
local function _a1085()
if _a585.move.inDottedBox() == true then return false end
local _a1086, _a1087 = _a585.move.breakCenter(400)
if (_a1087 or 0) >= 1 then return false end
task.wait(0.6)
if _a585.move.inDottedBox() == true then return false end
local _a1088, _a1089 = _a585.move.breakCenter(400)
return (_a1089 or 0) < 1
end
if _a1085() and (os.clock() - (_a585.move.lastRecover or -999)) > 30 then
_a585.move.lastRecover = os.clock()
_a572(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a1061), tostring(_a1066)))
end
_a585.move.zoneFailSaid = nil
_a585.move.arrivedZone = _a1061
do
local _a1090 = _a585.move.hrp()
local _a1091 = _a1090 and (_a1090.Position - _a1065).Magnitude or 0
if _a1091 > math.max(60, _a578.ArriveDist or 12) then
_a572(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a1061), _a1091))
return false, "이동이 되돌려짐"
end
end
local _a1092 = _a585.move.hrp()
if _a1062 and _a1092 then
_a572(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a1092.Position - _a1065).Magnitude, tostring(_a585.move.curZone()), tostring(_a585.move.inDottedBox())))
end
return true
end
function _a585.egg.tpEgg(_a1093)
if not _a1093 then return false, "알 id 없음" end
for _a1094, _a1095 in ipairs(_a585.egg.eggStands()) do
if _a1095.id == _a1093 then
if _a1095.dist <= _a578.EggRange then return true, _a1093 end
local _a1096, _a1097 = _a585.move.glideTo(_a1095.pos)
return _a1096, _a1096 and _a1093 or _a1097
end
end
if _a578.TpGameFallback then
local _a1098 = _a583.DirEggs and rawget(_a583.DirEggs, _a1093)
local _a1099 = _a1098 and select(1, _a585.move.zoneByNumber(rawget(_a1098, "zoneNumber")))
if _a1099 and _a585.move.curZone() ~= _a1099 then
local _a1100, _a1101 = _a585.move.tpZone(_a1099)
if not _a1100 then return false, _a1101 end
task.wait(0.5)
_a585.egg._standsAt = nil
for _a1102, _a1103 in ipairs(_a585.egg.eggStands()) do
if _a1103.id == _a1093 then return _a585.move.glideTo(_a1103.pos), _a1093 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a1093) .. ")"
end
function _a585.item.stacks(_a1104)
local _a1105 = _a612()
local _a1106 = _a1105 and rawget(_a1105, "Inventory")
local _a1107 = _a1106 and rawget(_a1106, _a1104)
if type(_a1107) ~= "table" then return {} end
local _a1108 = {}
for _a1109, _a1110 in pairs(_a1107) do
if type(_a1110) == "table" then
_a1108[#_a1108 + 1] = {
uid = _a1109,
id = tostring(rawget(_a1110, "id")),
tier = tonumber(rawget(_a1110, "tn")) or 1,
am = tonumber(rawget(_a1110, "_am")) or 1,
}
end
end
return _a1108
end
_a585.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a585.item.perTier(_a1111, _a1112)
_a1112 = tonumber(_a1112)
local _a1113 = _a583.Bal and rawget(_a583.Bal,
_a1111 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a1113) == "function" then
local _a1114, _a1115 = pcall(_a1113, _a1112)
_a1115 = _a1114 and tonumber(_a1115) or nil
if _a1115 and _a1115 > 0 then return _a1115 end
if not _a1114 and not _a585.item.perTierWarned then
_a585.item.perTierWarned = true
_a572("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a1115) .. ")")
end
end
local _a1116 = _a585.item.PERTIER[_a1111]
local _a1117 = _a1116 and _a1112 and _a1116[_a1112]
return (_a1117 and _a1117 > 0) and _a1117 or nil
end
function _a585.item.upgradeTo(_a1118, _a1119)
local _a1120 = (_a1118 == "Potion") and _a583.R_PotUp or _a583.R_EncUp
if not _a1120 then return 0, (_a1118 .. " 업글 리모트 없음") end
local _a1121 = math.max(1, (tonumber(_a1119) or 2) - 1)
local _a1122 = _a585.item.perTier(_a1118, _a1121)
if not _a1122 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a1121) end
local _a1123, _a1124 = {}, 0
for _a1125, _a1126 in ipairs(_a585.item.stacks(_a1118)) do
if _a1126.tier == _a1121 then
local _a1127 = math.floor(_a1126.am / _a1122)
if _a1127 > 0 then _a1123[_a1126.uid] = _a1127 _a1124 += _a1127 end
end
end
if _a1124 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a1121, _a1121, _a1122) end
local _a1128, _a1129
pcall(function() _a1128, _a1129 = _a1120:InvokeServer(_a1123) end)
if not _a1128 then return 0, tostring(_a1129) end
return _a1124
end
function _a585.item.usePotion(_a1130, _a1131)
if not _a583.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a1130 = tonumber(_a1130) or 1
local _a1132 = {}
for _a1133, _a1134 in ipairs(_a585.item.stacks("Potion")) do
if _a1134.tier >= _a1130 and _a1134.am >= 1 then _a1132[#_a1132 + 1] = _a1134 end
end
if #_a1132 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a1130) end
table.sort(_a1132, function(_a1135, _a1136) return _a1135.tier < _a1136.tier end)
local _a1137, _a1138 = _a1131, 0
for _a1139, _a1140 in ipairs(_a1132) do
for _a1141 = 1, math.min(_a1137, _a1140.am) do
if _a1137 < 1 or not _a579.quest then break end
pcall(function() _a583.R_PotUse:FireServer(_a1140.uid, 1) end)
_a1138 += 1
_a1137 -= 1
task.wait(0.12)
end
if _a1137 < 1 then break end
end
return _a1138
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
local function _a1142(_a1143)
if typeof(_a1143) == "Vector3" then return _a1143 end
if typeof(_a1143) == "CFrame" then return _a1143.Position end
if type(_a1143) == "table" then
local _a1144, _a1145, _a1146 = tonumber(_a1143.X or _a1143.x or _a1143[1]), tonumber(_a1143.Y or _a1143.y or _a1143[2]), tonumber(_a1143.Z or _a1143.z or _a1143[3])
if _a1144 and _a1145 and _a1146 then return Vector3.new(_a1144, _a1145, _a1146) end
end
return nil
end
function _a585.ev.events()
local _a1147
if _a583.Rand and rawget(_a583.Rand, "GetActive") then
local _a1148, _a1149 = pcall(_a583.Rand.GetActive)
if _a1148 and type(_a1149) == "table" and next(_a1149) then _a1147 = _a1149 end
end
if not _a1147 and _a583.R_Events then
local _a1150, _a1151 = pcall(function() return _a583.R_Events:InvokeServer() end)
if _a1150 and type(_a1151) == "table" then _a1147 = _a1151 end
end
if type(_a1147) ~= "table" then return {} end
local _a1152 = workspace:GetServerTimeNow()
local _a1153 = {}
for _a1154, _a1155 in pairs(_a1147) do
if type(_a1155) == "table" then
local _a1156 = tostring(rawget(_a1155, "id") or "")
local _a1157 = _a1156:match("|%s*(%S+)%s*$") or _a1156
local _a1158 = tonumber(rawget(_a1155, "started")) or 0
local _a1159 = tonumber(rawget(_a1155, "duration")) or 0
_a1153[#_a1153 + 1] = {
uid = rawget(_a1155, "uid"),
id = _a1156,
kind = _a1157,
name = rawget(_a1155, "name") or _a1157,
zone = rawget(_a1155, "parentID"),
pos = _a1142(rawget(_a1155, "origin")),
left = math.max(0, _a1159 - (_a1152 - _a1158)),
}
end
end
table.sort(_a1153, function(_a1160, _a1161) return _a1160.left > _a1161.left end)
return _a1153
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
local _a1162, _a1163 = pcall(_a583.Map.IsInDottedBox)
if _a1162 then return _a1163 and true or false end
end
return nil
end
function _a585.ev.spawnItems(_a1164)
local _a1165 = _a585.ev.SPAWN[_a1164]
if not _a1165 then return {} end
local _a1166 = {}
for _a1167, _a1168 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a1169, _a1170 in ipairs(_a585.item.stacks(_a1168)) do
local _a1171 = _a1170.id:lower()
if _a1171:find(_a1165.key, 1, true) then
local _a1172 = 99
if _a1165.order then
for _a1173, _a1174 in ipairs(_a1165.order) do
if _a1171:find(_a1174, 1, true) then _a1172 = _a1173 break end
end
end
_a1170.rank = _a1172
_a1166[#_a1166 + 1] = _a1170
end
end
end
table.sort(_a1166, function(_a1175, _a1176)
if _a1175.rank ~= _a1176.rank then return _a1175.rank < _a1176.rank end
return _a1175.tier < _a1176.tier
end)
return _a1166
end
function _a585.ev.spawnEvent(_a1177)
local _a1178 = _a585.ev.SPAWN[_a1177]
if not _a1178 then return 0, "소환 불가 종류" end
local _a1179 = _a576:FindFirstChild(_a1178.rem)
if not _a1179 then return 0, _a1178.rem .. " 리모트 없음" end
local _a1180 = _a585.ev.spawnItems(_a1177)
if #_a1180 == 0 then return 0, _a1177 .. " 아이템 없음" end
local _a1181 = _a585.move.inDottedBox()
if _a1181 == false then return 0, "점선 네모 안이 아님" end
local _a1182, _a1183 = 0, nil
for _a1184, _a1185 in ipairs(_a1180) do
if _a1182 >= (_a578.SpawnPerCycle or 1) or not _a579.quest then break end
local _a1186, _a1187
pcall(function() _a1186, _a1187 = _a1179:InvokeServer(_a1185.uid) end)
if _a1186 then
_a1182 += 1
_a585.ctl.setAct("소환", _a1177 .. " · " .. _a1185.id)
_a572(("  🎁 %s 소환  (%s)"):format(_a1177, _a1185.id))
task.wait(0.4)
else
_a1183 = _a1187
break
end
end
return _a1182, _a1183
end
function _a585.ev.findEvent(_a1188, _a1189)
local _a1190 = _a1189 and _a585.move.bestZone() or nil
local _a1191
for _a1192, _a1193 in ipairs(_a585.ev.events()) do
if _a1193.kind == _a1188 and _a1193.left > 15 then
if not _a1189 or _a1193.zone == _a1190 then
if not _a1191 or (_a1193.zone == _a585.move.curZone() and _a1191.zone ~= _a585.move.curZone()) then
_a1191 = _a1193
end
end
end
end
return _a1191
end
function _a585.ev.findChest(_a1194, _a1195)
local _a1196 = workspace:FindFirstChild("__THINGS")
if not _a1196 then return nil end
local _a1197 = tostring(_a1194):lower():find("superior") ~= nil
local _a1198 = _a585.move.hrp()
local _a1199 = _a1198 and _a1198.Position
local _a1200, _a1201, _a1202, _a1203
for _a1204, _a1205 in ipairs(_a1196:GetChildren()) do
if tostring(_a1205.Name):lower():find("chest", 1, true) then
for _a1206, _a1207 in ipairs(_a1205:GetChildren()) do
local _a1208
if _a1207:IsA("BasePart") then _a1208 = _a1207.Position
elseif _a1207:IsA("Model") then
local _a1209, _a1210 = pcall(function() return _a1207:GetPivot() end)
if _a1209 and typeof(_a1210) == "CFrame" then _a1208 = _a1210.Position end
end
if _a1208 then
local _a1211 = _a1199 and (_a1208 - _a1199).Magnitude or 0
local _a1212 = (tostring(_a1207.Name) .. tostring(_a1205.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a1203 or _a1211 < _a1203 then _a1202, _a1203 = _a1208, _a1211 end
if _a1212 == _a1197 and (not _a1201 or _a1211 < _a1201) then
_a1200, _a1201 = _a1208, _a1211
end
end
end
end
end
if _a1200 then return _a1200, _a1201 end
return _a1202, _a1203
end
_a585.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a585.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a585.item.petStacks()
local _a1213 = _a612()
local _a1214 = _a1213 and rawget(_a1213, "Inventory")
local _a1215 = _a1214 and rawget(_a1214, "Pet")
local _a1216 = {}
if type(_a1215) ~= "table" then return _a1216 end
for _a1217, _a1218 in pairs(_a1215) do
if type(_a1218) == "table" then
_a1216[#_a1216 + 1] = {
uid = _a1217,
id = tostring(rawget(_a1218, "id")),
pt = tonumber(rawget(_a1218, "pt")) or 0,
am = tonumber(rawget(_a1218, "_am")) or 1,
}
end
end
return _a1216
end
function _a585.item.bestEggPets()
local _a1219 = _a660()
local _a1220 = _a1219 and _a583.DirEggs and rawget(_a583.DirEggs, _a1219)
local _a1221 = _a1220 and rawget(_a1220, "pets")
local _a1222 = {}
if type(_a1221) == "table" then
for _a1223, _a1224 in pairs(_a1221) do
local _a1225 = type(_a1224) == "table" and _a1224[1] or _a1224
if _a1225 then _a1222[tostring(_a1225)] = true end
end
end
return _a1222, _a1219
end
function _a585.item.makeVariant(_a1226, _a1227)
local _a1228 = (_a1226 == "gold") and _a583.R_Gold or _a583.R_Rain
if not _a1228 then return 0, (_a1226 .. " 머신 리모트 없음") end
local _a1229 = (_a1226 == "gold") and 0 or 1
local _a1230
if _a1227 then
local _a1231, _a1232 = _a585.item.bestEggPets()
if not next(_a1231) then return 0, "최고 알(" .. tostring(_a1232) .. ") 펫 목록을 못 읽음" end
_a1230 = _a1231
end
local _a1233, _a1234 = 0, nil
for _a1235, _a1236 in ipairs(_a585.item.petStacks()) do
if not _a579.quest then break end
if _a1236.pt == _a1229 and _a1236.am >= 10 and (not _a1230 or _a1230[_a1236.id]) then
local _a1237 = math.floor(_a1236.am / 10)
if _a1237 > 0 then
local _a1238, _a1239
pcall(function() _a1238, _a1239 = _a1228:InvokeServer(_a1236.uid, _a1237) end)
if _a1238 then
_a1233 += _a1237
_a572(("  ✨ %s 제작  %s x%d"):format(
_a1226 == "gold" and "골드" or "레인보우", _a1236.id, _a1237))
task.wait(0.4)
else
_a1234 = _a1239
end
end
end
end
return _a1233, _a1234
end
function _a585.item.useFlag(_a1240)
if not _a583.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a1241, _a1242 = 0, nil
for _a1243, _a1244 in ipairs(_a585.item.stacks("Misc")) do
if _a1241 >= (_a1240 or 1) then break end
if _a1244.id:lower():find("flag", 1, true) and _a1244.am >= 1 and _a585.item.itemAllowed(_a1244.id) then
local _a1245, _a1246
pcall(function() _a1245, _a1246 = _a583.R_Flag:InvokeServer(_a1244.id, _a1244.uid, 1) end)
if _a1245 then _a1241 += 1 task.wait(0.4) else _a1242 = _a1246 end
end
end
return _a1241, _a1242
end
function _a585.item.useFruit(_a1247)
if not _a583.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a1248 = _a585.item.activeBuffs("Fruits")
local _a1249 = 0
for _a1250, _a1251 in ipairs(_a585.item.stacks("Fruit")) do
if _a1249 >= (_a1247 or 1) then break end
if _a1251.am >= 1 and _a585.item.itemAllowed(_a1251.id) and not _a1248[_a1251.id] then
pcall(function() _a583.R_Fruit:FireServer(_a1251.uid, 1) end)
_a1249 += 1
task.wait(0.4)
end
end
return _a1249
end
function _a585.quest.status()
local _a1252 = _a612()
if not _a1252 then return nil end
local _a1253 = rawget(_a1252, "Goals")
if type(_a1253) ~= "table" then return { list = {} } end
local _a1254 = {}
for _a1255, _a1256 in pairs(_a1253) do
if type(_a1256) == "table" then
local _a1257 = tonumber(rawget(_a1256, "Type")) or -1
local _a1258
if _a583.Quest and rawget(_a583.Quest, "MakeTitle") then
local _a1259, _a1260 = pcall(_a583.Quest.MakeTitle, _a1256)
if _a1259 then _a1258 = _a1260 end
end
_a1254[#_a1254 + 1] = {
slot = _a1255,
uid = tostring(rawget(_a1256, "UID")),
type = _a1257,
how = _a584[_a1257],
title = _a1258 or ("Type " .. _a1257),
amount = tonumber(rawget(_a1256, "Amount")) or 0,
progress = tonumber(rawget(_a1256, "Progress")) or 0,
stars = tonumber(rawget(_a1256, "Stars")) or 0,
potionTier = tonumber(rawget(_a1256, "PotionTier")),
enchantTier = tonumber(rawget(_a1256, "EnchantTier")),
breakable = rawget(_a1256, "BreakableType") or rawget(_a1256, "BreakableDirID"),
zoneId = rawget(_a1256, "ZoneID"),
where = _a585.quest.WHERE[_a1257] or (_a584[_a1257] == "farm" and "bestzone" or nil),
event = _a585.ev.EVENTKIND[_a1257],
chest = _a585.ev.CHESTKIND[_a1257],
bestOnly = _a585.ev.BESTONLY[_a1257] or false,
ignored = _a585.quest.IGNORE[_a1257],
}
end
end
table.sort(_a1254, function(_a1261, _a1262) return _a1261.stars > _a1262.stars end)
return { list = _a1254, rank = tonumber(rawget(_a1252, "Rank")) or 1,
rankStars = tonumber(rawget(_a1252, "RankStars")) or 0 }
end
_a585.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a585.quest.bestDepActive()
local _a1263 = _a585.ctl.lockGoal and _a585.ctl.lockGoal.q
if not _a1263 then return false end
if _a585.quest.IGNORE[_a1263.type] then return false end
if not _a585.quest.BESTDEP[_a1263.type] then return false end
local _a1264 = _a585.quest.findQuest(_a1263.uid)
if not _a1264 or _a1264.progress >= _a1264.amount then return false end
return true, _a1264
end
function _a585.quest.canDo(_a1265, _a1266)
if _a1265.how == "hatch" or _a1265.where == "bestegg" then
local _a1267 = _a685()
if not _a1267 then return false, "알 정보를 못 읽음" end
if not _a1267.price then return true end
if not _a1266 then
if _a1267.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a1267.id), _a573(_a1267.price, 0), tostring(_a1267.currency), _a573(_a1267.have, 0))
end
return true
end
local _a1268 = math.max(1, (_a1265.amount or 1) - (_a1265.progress or 0))
local _a1269 = _a1268
if _a1265.type == 2 or _a1265.type == 42 or _a1265.type == 47 then
_a1269 = math.max(_a1268, _a578.HatchMinAfford or 10)
end
if _a1267.canBuy < _a1269 then
_a585.quest.moneyUntil = os.clock() + math.max(0, _a578.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a1269, _a1267.canBuy, _a573(_a1267.price, 0), tostring(_a1267.currency))
end
if _a585.quest.moneyUntil and os.clock() < _a585.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a585.quest.moneyUntil - os.clock())
end
_a585.quest.moneyUntil = nil
end
return true
end
function _a585.quest.findQuest(_a1270)
local _a1271 = _a585.quest.status()
for _a1272, _a1273 in ipairs(_a1271 and _a1271.list or {}) do
if _a1273.uid == _a1270 then return _a1273 end
end
return nil
end
function _a585.quest.pursue(_a1274)
local _a1275, _a1276
if _a1274.how == "hatch" then _a1275, _a1276 = _a696, "mhatch"
elseif _a1274.how == "zone" then _a1275, _a1276 = _a655, "zone"
elseif _a1274.how == "gold" or _a1274.how == "rainbow" then
local _a1277 = (_a1274.type == 40 or _a1274.type == 41)
_a1276 = "quest"
_a1275 = function()
local _a1278 = _a585.item.makeVariant("gold", _a1277) or 0
if _a1274.how == "rainbow" then
_a1278 += (_a585.item.makeVariant("rainbow", _a1277) or 0)
end
if _a1278 > 0 then
_a585.ctl.setAct(_a1274.how == "gold" and "골드 합성" or "레인보우 합성", _a1278 .. "마리")
return
end
_a585.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a1279 = _a579.mhatch
_a579.mhatch = true
pcall(_a696)
_a579.mhatch = _a1279
end
end
local _a1280 = _a1274.progress
local _a1281 = os.clock()
_a585.ctl.setGoal(_a1274.title, ("%d/%d"):format(_a1274.progress, _a1274.amount))
local function _a1282()
if not _a1274.event then return end
local _a1283 = _a585.ev.findEvent(_a1274.event, _a1274.bestOnly)
if _a1283 then
_a585.ctl.setAct(_a1274.event .. " 진행 중", ("%d초 남음"):format(_a1283.left))
if _a1283.pos then
local _a1284 = _a585.move.hrp()
if _a1284 and (_a1284.Position - _a1283.pos).Magnitude > (_a578.EventStayDist or 45) then
_a585.move.glideTo(_a1283.pos)
end
end
return
end
local _a1285, _a1286 = _a585.ev.spawnEvent(_a1274.event)
if _a1285 > 0 then
_a585.ctl.setAct("소환", _a1274.event)
task.wait(0.5)
elseif _a1286 and _a585.ev.spawnErr ~= tostring(_a1286) then
_a585.ev.spawnErr = tostring(_a1286)
_a572("[퀘스트] " .. _a1274.event .. " 소환 실패: " .. tostring(_a1286))
end
end
local _a1287, _a1288 = pcall(function()
while _a579.quest and not _a585.ctl.stopped() do
local _a1289, _a1290 = _a585.quest.canDo(_a1274, false)
if not _a1289 then
_a572(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a1274.title), tostring(_a1290)))
return
end
_a1282()
if _a1275 then
local _a1291 = _a579[_a1276]
_a579[_a1276] = true
local _a1292, _a1293 = pcall(_a1275)
_a579[_a1276] = _a1291
if not _a1292 then error(_a1293, 0) end
elseif _a1274.event then
task.wait(0.4)
else
task.wait(2)
end
local _a1294 = _a585.quest.findQuest(_a1274.uid)
if not _a1294 then
_a572("[퀘스트] 완료 — " .. tostring(_a1274.title))
return
end
_a585.ctl.setGoal(_a1294.title, ("%d/%d"):format(_a1294.progress, _a1294.amount))
if _a1294.progress >= _a1294.amount then
_a572(("[퀘스트] 달성 %d/%d — %s"):format(_a1294.progress, _a1294.amount, tostring(_a1294.title)))
return
end
if _a1294.progress > _a1280 then
_a1281 = os.clock()
_a572(("[퀘스트] %d/%d  %s"):format(_a1294.progress, _a1294.amount, tostring(_a1294.title)))
end
_a1280 = _a1294.progress
local _a1295 = os.clock() - _a1281
if _a1295 >= math.max(10, _a578.PursueStallSec or 60) then
_a572(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a1295, _a1294.progress, _a1294.amount, tostring(_a1294.title)))
return
end
task.wait(0.2)
end
end)
if not _a1287 then _a572("[퀘스트] " .. tostring(_a1274.how) .. " 오류: " .. tostring(_a1288)) end
_a585.ctl.lockGoal = nil
_a585.ctl.setGoal(nil)
end
function _a585.quest.cycle()
do
local _a1296 = _a579.rank
_a579.rank = true
pcall(_a747)
_a579.rank = _a1296
end
local _a1297 = _a585.quest.status()
if not _a1297 then return end
local _a1298, _a1299, _a1300 = false, false, false
local _a1301 = {}
local _a1302 = nil
for _a1303, _a1304 in ipairs(_a1297.list) do
if not _a579.quest then break end
local _a1305, _a1306 = true, nil
if not _a1304.ignored and _a1304.progress < _a1304.amount then
_a1305, _a1306 = _a585.quest.canDo(_a1304, true)
end
if _a1304.ignored then
if _a1304.progress < _a1304.amount then
_a1301[#_a1301 + 1] = tostring(_a1304.title) .. "  — " .. _a1304.ignored
end
elseif not _a1305 then
local _a1307 = tostring(_a1304.uid) .. tostring(_a1306)
if _a585.item.skipSaid ~= _a1307 then
_a585.item.skipSaid = _a1307
_a572(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a1304.title), tostring(_a1306)))
end
elseif _a1304.progress < _a1304.amount then
local _a1308 = _a1304.where
if _a1304.event then
if not _a1302 or _a1302.rank > 0 then _a1302 = { rank = 0, kind = "event", q = _a1304 } end
elseif _a1304.chest then
if not _a1302 or _a1302.rank > 1 then _a1302 = { rank = 1, kind = "chest", q = _a1304 } end
elseif _a1308 == "bestegg" then
if not _a1302 or _a1302.rank > 1 then _a1302 = { rank = 1, kind = "egg", q = _a1304 } end
elseif _a1308 == "breakable" and _a1304.breakable then
if not _a1302 or _a1302.rank > 2 then _a1302 = { rank = 2, kind = "breakable", q = _a1304 } end
elseif _a1308 == "zoneid" and _a1304.zoneId then
if not _a1302 or _a1302.rank > 2 then _a1302 = { rank = 2, kind = "zoneid", q = _a1304 } end
elseif _a1308 == "bestzone" or _a1308 == "breakable" then
if not _a1302 then _a1302 = { rank = 3, kind = "bestzone", q = _a1304 } end
end
if _a1304.how == "farm" then
_a1298 = true
elseif _a1304.how == "hatch" then
_a1299 = true
elseif _a1304.how == "zone" then
_a1300 = true
elseif _a1304.how == "potup" and _a578.QuestUpgrade then
local _a1309, _a1310 = _a585.item.upgradeTo("Potion", _a1304.potionTier or 2)
if _a1309 > 0 then
_a580.potup += _a1309
_a580.quest += 1
_a572(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a1304.potionTier or 2, _a1309, _a1304.title))
elseif _a1310 and not tostring(_a1310):find("부족") then
if _a585.item.potUpSaid ~= tostring(_a1310) then
_a585.item.potUpSaid = tostring(_a1310)
_a572("[퀘스트] 포션 업글 실패: " .. tostring(_a1310))
end
end
elseif _a1304.how == "encup" and _a578.QuestUpgrade then
local _a1311, _a1312 = _a585.item.upgradeTo("Enchant", _a1304.enchantTier or 2)
if _a1311 > 0 then
_a580.potup += _a1311
_a580.quest += 1
_a572(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a1304.enchantTier or 2, _a1311, _a1304.title))
elseif _a1312 and not tostring(_a1312):find("부족") then
if _a585.item.encUpSaid ~= tostring(_a1312) then
_a585.item.encUpSaid = tostring(_a1312)
_a572("[퀘스트] 인챈트 업글 실패: " .. tostring(_a1312))
end
end
elseif _a1304.how == "potuse" and _a578.QuestUsePotion then
_a585.item.lastUse = _a585.item.lastUse or {}
local _a1313 = _a585.item.lastUse[_a1304.uid]
if _a1313 and _a1313.used > 0 and _a1304.progress <= _a1313.progress then
if not _a1313.gaveUp then
_a1313.gaveUp = true
_a572("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a1304.title))
end
else
local _a1314 = math.min(_a578.QuestUseMax, math.max(1, _a1304.amount - _a1304.progress))
local _a1315, _a1316 = _a585.item.usePotion(_a1304.potionTier or 1, _a1314)
_a585.item.lastUse[_a1304.uid] = { used = _a1315, progress = _a1304.progress }
if _a1315 > 0 then
_a580.potuse += _a1315
_a580.quest += 1
_a572(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a1315, _a1304.title))
elseif _a1316 and not tostring(_a1316):find("없음") then
_a572("[퀘스트] 포션 사용 실패: " .. tostring(_a1316))
end
end
elseif _a1304.how == "gold" or _a1304.how == "rainbow" then
local _a1317, _a1318 = _a585.item.makeVariant(_a1304.how, _a1304.type == 40 or _a1304.type == 41)
if _a1317 > 0 then
_a580.quest += 1
_a572(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a1304.how == "gold" and "골드" or "레인보우", _a1317, _a1304.title))
elseif _a1318 then
_a572("[퀘스트] " .. _a1304.how .. " 실패: " .. tostring(_a1318))
end
elseif _a1304.how == "fruituse" then
local _a1319 = _a585.item.useFruit(math.max(1, _a1304.amount - _a1304.progress))
if _a1319 > 0 then
_a580.quest += 1
_a572(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a1319, _a1304.title))
end
elseif _a1304.how == "flaguse" then
local _a1320, _a1321 = _a585.item.useFlag(math.max(1, _a1304.amount - _a1304.progress))
if _a1320 > 0 then
_a580.quest += 1
_a572(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a1320, _a1304.title))
elseif _a1321 then
_a572("[퀘스트] 깃발 실패: " .. tostring(_a1321))
end
elseif not _a1304.how then
_a1301[#_a1301 + 1] = _a1304.title
end
end
end
if _a578.QuestLock and _a585.ctl.lockGoal then
local _a1322
for _a1323, _a1324 in ipairs(_a1297.list) do
if _a1324.uid == _a585.ctl.lockGoal.q.uid and _a1324.progress < _a1324.amount then _a1322 = _a1324 break end
end
if _a1322 then
_a585.ctl.lockGoal.q = _a1322
_a1302 = _a585.ctl.lockGoal
else
if _a585.ctl.lockGoal.q then
_a572("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a585.ctl.lockGoal.q.title))
end
_a585.ctl.lockGoal = nil
end
end
if _a578.QuestLock and _a1302 then _a585.ctl.lockGoal = _a1302 end
if _a578.QuestTp and _a1302 and _a579.quest then
local _a1325, _a1326, _a1327
if _a1302.kind == "event" then
local _a1328 = _a585.ev.findEvent(_a1302.q.event, _a1302.q.bestOnly)
if _a1328 then
_a1327 = ("%s @%s (%d초 남음)"):format(_a1328.name, tostring(_a1328.zone), _a1328.left)
if _a1328.pos then _a1325, _a1326 = _a585.move.glideTo(_a1328.pos)
else _a1325, _a1326 = _a585.move.goToZone(_a1328.zone) end
else
local _a1329 = _a1302.q.bestOnly and _a585.move.bestZone() or (_a585.move.curZone() or _a585.move.bestZone())
_a1327 = _a1302.q.event .. " 소환용 " .. tostring(_a1329)
local _a1330 = _a585.move.inDottedBox()
_a1325, _a1326 = _a585.move.goToZone(_a1329, false, _a1330 == false, _a1302.q.bestOnly)
if _a1325 then
local _a1331, _a1332 = _a585.ev.spawnEvent(_a1302.q.event)
if _a1331 < 1 and tostring(_a1332):find("점선") then
_a585.move.goToZone(_a1329, false, true)
task.wait(0.2)
_a1331, _a1332 = _a585.ev.spawnEvent(_a1302.q.event)
end
if _a1331 > 0 then
_a1327 = ("%s %d개 소환 @%s"):format(_a1302.q.event, _a1331, tostring(_a1329))
else
_a1326 = _a1332
_a1325 = false
end
end
end
elseif _a1302.kind == "chest" then
local _a1333 = _a1302.q.bestOnly and _a585.move.bestZone() or _a585.move.curZone()
local _a1334, _a1335 = _a585.ev.findChest(_a1302.q.chest, _a1333)
_a1327 = _a1302.q.chest .. " @" .. tostring(_a1333)
if _a1334 then
if not _a1335 or _a1335 > 20 then _a585.move.glideTo(_a1334) end
_a1325 = true
else
_a1325, _a1326 = _a585.move.goToZone(_a1333)
_a1327 = _a1327 .. " (상자 없음 → 존 가운데)"
end
elseif _a1302.kind == "egg" then
local _a1336 = _a660()
_a1327 = "최고 알 " .. tostring(_a1336)
if _a1336 then _a1325, _a1326 = _a585.egg.tpEgg(_a1336) else _a1326 = "최고 알을 못 찾음" end
elseif _a1302.kind == "breakable" then
local _a1337 = _a585.move.zoneForBreakable(_a1302.q.breakable)
_a1327 = tostring(_a1302.q.breakable) .. " 나오는 존 " .. tostring(_a1337)
if _a1337 then _a1325, _a1326 = _a585.move.goToZone(_a1337, true) else _a1326 = "그 브레이커블이 나오는 존이 없음" end
elseif _a1302.kind == "zoneid" then
_a1327 = "존 " .. tostring(_a1302.q.zoneId)
_a1325, _a1326 = _a585.move.goToZone(_a1302.q.zoneId)
else
local _a1338 = _a585.move.bestZone()
local _a1339 = _a1302.q.bestOnly or _a585.quest.BESTDEP[_a1302.q.type] or false
if _a1338 then _a1325, _a1326 = _a585.move.goToZone(_a1338, true, false, _a1339)
else _a1326 = "최고 존을 못 찾음" end
_a1327 = "최고 존 " .. tostring(_a585.move.arrivedZone or _a1338)
if not _a1325 then _a1326 = _a1338 end
end
if _a1325 then
if _a585.quest.lastGoal ~= _a1327 then
_a585.quest.lastGoal = _a1327
_a572("[퀘스트] " .. _a1327 .. " 으로 이동  (" .. tostring(_a1302.q.title) .. ")")
end
_a585.quest.pursue(_a1302.q)
else
local _a1340 = _a1326 and tostring(_a1326) or "이유 불명"
if _a585.quest.lastFail ~= _a1340 then
_a585.quest.lastFail = _a1340
_a572(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a1340, tostring(_a1302.kind), tostring(_a1302.q.title)))
_a572(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a585.move.curZone()), tostring(_a585.move.bestZone()), tostring(_a585.move.inDottedBox())))
end
end
end
if _a578.QuestDrive and _a585.auto.turnOn then
if _a1298  then _a585.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a1300  then _a585.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a1299 then _a585.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a1301 > 0 and not _a585.quest.manualWarned then
_a585.quest.manualWarned = true
_a572("[퀘스트] 수동으로 해야 하는 것:")
for _a1341, _a1342 in ipairs(_a1301) do _a572("    · " .. tostring(_a1342)) end
elseif #_a1301 == 0 then
_a585.quest.manualWarned = false
end
return _a1302 ~= nil
end
local function _a1343(_a1344)
local _a1345 = {}
for _a1346 in tostring(_a1344 or ""):gmatch("[^,]+") do
_a1346 = _a1346:match("^%s*(.-)%s*$")
if _a1346 ~= "" then _a1345[#_a1345 + 1] = _a1346:lower() end
end
return _a1345
end
function _a585.item.itemAllowed(_a1347)
local _a1348 = tostring(_a1347):lower()
for _a1349, _a1350 in ipairs(_a1343(_a578.ItemBlock)) do
if _a1348:find(_a1350, 1, true) then return false end
end
local _a1351 = _a1343(_a578.ItemAllow)
if #_a1351 == 0 then return true end
for _a1352, _a1353 in ipairs(_a1351) do
if _a1348:find(_a1353, 1, true) then return true end
end
return false
end
function _a585.item.activeBuffs(_a1354)
local _a1355 = _a612()
local _a1356 = _a1355 and rawget(_a1355, _a1354)
local _a1357 = {}
if type(_a1356) == "table" then
for _a1358, _a1359 in pairs(_a1356) do
if type(_a1359) == "table" and next(_a1359) then _a1357[_a1358] = true
elseif _a1359 then _a1357[_a1358] = true end
end
end
return _a1357
end
local function _a1360(_a1361, _a1362, _a1363, _a1364)
local _a1365 = _a585.item.activeBuffs(_a1362)
local _a1366 = {}
local _a1367 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a1368, _a1369 in ipairs(_a585.item.stacks(_a1361)) do
_a1367.total += 1
if _a1365[_a1369.id] then _a1367.act += 1
elseif not _a585.item.itemAllowed(_a1369.id) then _a1367.blocked += 1
elseif _a1369.am <= _a578.ItemKeep then _a1367.few += 1
else
_a1367.ok += 1
local _a1370 = _a1366[_a1369.id]
local _a1371
if not _a1370 then _a1371 = true
elseif _a578.BuffHighTier then _a1371 = _a1369.tier > _a1370.tier
else _a1371 = _a1369.tier < _a1370.tier end
if _a1371 then _a1366[_a1369.id] = _a1369 end
end
end
if _a1367.ok == 0 and _a1367.total > 0 then
local _a1372 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a1361, _a1367.total, _a1367.act, _a1367.blocked, _a1367.few)
if _a585.item.buffSaid ~= _a1372 then
_a585.item.buffSaid = _a1372
_a572("[아이템] " .. _a1372)
end
elseif _a1367.ok > 0 then
_a585.item.buffSaid = nil
end
local _a1373 = {}
for _a1374, _a1375 in pairs(_a1366) do _a1373[#_a1373 + 1] = _a1375 end
table.sort(_a1373, function(_a1376, _a1377)
if _a1376.tier ~= _a1377.tier then return _a1376.tier > _a1377.tier end
return _a1376.am > _a1377.am
end)
local _a1378 = {}
for _a1379, _a1380 in ipairs(_a1373) do
if not _a579.items then break end
if _a1364 and _a1364.left <= 0 then break end
local _a1381 = pcall(function() _a1363(_a1380.uid, 1) end)
if _a1381 then
_a1378[#_a1378 + 1] = ("%s T%d"):format(_a1380.id, _a1380.tier)
_a580.items += 1
if _a1364 then _a1364.left -= 1 end
task.wait(0.12)
end
end
return _a1378
end
function _a585.item.cycleItems()
local function _a1382()
local _a1383 = {}
if _a578.BuffPotion then _a1383[#_a1383 + 1] = { "Potion", "Potions" } end
if _a578.BuffFruit then _a1383[#_a1383 + 1] = { "Fruit", "Fruits" } end
if _a578.BuffConsumable then _a1383[#_a1383 + 1] = { "Consumable", "Consumables" } end
for _a1384, _a1385 in ipairs(_a1383) do
local _a1386 = _a585.item.activeBuffs(_a1385[2])
for _a1387, _a1388 in ipairs(_a585.item.stacks(_a1385[1])) do
if _a1388.am > _a578.ItemKeep and _a585.item.itemAllowed(_a1388.id) and not _a1386[_a1388.id] then
return true
end
end
end
if _a578.BuffUltimate and _a583.R_Ult then
local _a1389 = _a612()
local _a1390 = _a1389 and rawget(_a1389, "Ultimates")
if type(_a1390) == "table" then
for _a1391 in pairs(_a1390) do
if _a585.item.itemAllowed(_a1391) then
if not (_a583.Ult and rawget(_a583.Ult, "IsCharged")) then return true end
local _a1392, _a1393 = pcall(_a583.Ult.IsCharged, _a1391)
if _a1392 and _a1393 then return true end
end
end
end
end
return false
end
if not _a1382() then return end
if _a578.ItemBestZone then
local _a1394 = _a585.move.bestZone()
if _a1394 and _a585.move.curZone() ~= _a1394 then
if not _a578.ItemTp then
if not _a585.item.itemZoneWarned then
_a585.item.itemZoneWarned = true
_a572(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a1394), tostring(_a585.move.curZone())))
end
return
end
local _a1395, _a1396 = _a585.move.goToZone(_a1394)
if not _a1395 then
_a572("[아이템] 최고 존 이동 실패: " .. tostring(_a1396))
return
end
_a572("[아이템] 최고 존 " .. tostring(_a1394) .. " 에서 사용")
end
_a585.item.itemZoneWarned = false
end
local _a1397 = {}
local _a1398  = { left = math.max(1, _a578.BuffMaxPotion or 5) }
local _a1399 = { left = math.max(1, _a578.BuffMaxOther or 2) }
if _a578.BuffPotion and _a583.R_PotUse then
local _a1400 = _a1360("Potion", "Potions", function(_a1401, _a1402)
_a583.R_PotUse:FireServer(_a1401, _a1402)
end, _a1398)
for _a1403, _a1404 in ipairs(_a1400) do _a1397[#_a1397 + 1] = "포션 " .. _a1404 end
end
if _a578.BuffFruit and _a583.R_Fruit then
local _a1405 = _a1360("Fruit", "Fruits", function(_a1406, _a1407)
_a583.R_Fruit:FireServer(_a1406, _a1407)
end, _a1399)
for _a1408, _a1409 in ipairs(_a1405) do _a1397[#_a1397 + 1] = "과일 " .. _a1409 end
end
if _a578.BuffConsumable and _a583.R_Cons then
local _a1410 = _a1360("Consumable", "Consumables", function(_a1411, _a1412)
_a583.R_Cons:InvokeServer(_a1411, _a1412)
end, _a1399)
for _a1413, _a1414 in ipairs(_a1410) do _a1397[#_a1397 + 1] = "소모품 " .. _a1414 end
end
if _a578.BuffUltimate and _a583.R_Ult then
local _a1415 = _a612()
local _a1416 = _a1415 and rawget(_a1415, "Ultimates")
if type(_a1416) == "table" then
for _a1417 in pairs(_a1416) do
if not _a579.items then break end
if _a585.item.itemAllowed(_a1417) then
local _a1418 = true
if _a583.Ult and rawget(_a583.Ult, "IsCharged") then
local _a1419, _a1420 = pcall(_a583.Ult.IsCharged, _a1417)
_a1418 = _a1419 and _a1420 and true or false
end
if _a1418 then
local _a1421
pcall(function() _a1421 = _a583.R_Ult:InvokeServer(_a1417) end)
if _a1421 then
_a1397[#_a1397 + 1] = "얼티밋 " .. tostring(_a1417)
_a580.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a1397 > 0 then
_a585.ctl.setAct("버프 사용", table.concat(_a1397, ", "))
_a572("[아이템] " .. table.concat(_a1397, ", ") .. " 사용")
end
end
function _a585.mach.slotStatus()
local _a1422 = _a612()
if not _a1422 then return nil end
local _a1423 = tonumber(rawget(_a1422, "PetSlotsPurchased")) or 0
local _a1424 = tonumber(rawget(_a1422, "EggSlotsPurchased")) or 0
local _a1425, _a1426 = 0, 0
if _a583.RankC then
if rawget(_a583.RankC, "GetMaxPurchasableEquipSlots") then
local _a1427, _a1428 = pcall(_a583.RankC.GetMaxPurchasableEquipSlots)
if _a1427 and tonumber(_a1428) then _a1425 = tonumber(_a1428) end
end
if rawget(_a583.RankC, "GetMaxPurchasableEggSlots") then
local _a1429, _a1430 = pcall(_a583.RankC.GetMaxPurchasableEggSlots)
if _a1429 and tonumber(_a1430) then _a1426 = tonumber(_a1430) end
end
end
local _a1431, _a1432
if _a1423 < _a1425 then
_a1431 = _a1423 + 1
if type(_a583.CalcPetS) == "function" then
local _a1433, _a1434 = pcall(_a583.CalcPetS, _a1431)
if _a1433 then _a1432 = tonumber(_a1434) end
end
end
local _a1435, _a1436, _a1437
if _a1424 < _a1426 and _a583.RankC and rawget(_a583.RankC, "GetEggBundle") then
local _a1438, _a1439, _a1440 = pcall(_a583.RankC.GetEggBundle, _a1424 + 1)
if _a1438 and tonumber(_a1439) then
_a1435, _a1436 = tonumber(_a1439), tonumber(_a1440) or 1
if type(_a583.CalcEggS) == "function" then
local _a1441, _a1442 = 0, false
for _a1443 = _a1435 - _a1436 + 1, _a1435 do
local _a1444, _a1445 = pcall(_a583.CalcEggS, _a1443)
if _a1444 and tonumber(_a1445) then _a1441 += tonumber(_a1445) else _a1442 = true end
end
if not _a1442 then _a1437 = _a1441 end
end
end
end
local _a1446
if _a583.Egg and rawget(_a583.Egg, "GetMaxHatch") then
local _a1447, _a1448 = pcall(_a583.Egg.GetMaxHatch)
if _a1447 then _a1446 = tonumber(_a1448) end
end
return {
dia = _a627("Diamonds"),
petOwned = _a1423, petMax = _a1425, petNext = _a1431, petCost = _a1432,
eggOwned = _a1424, eggMax = _a1426, eggEnd = _a1435, eggSize = _a1436, eggCost = _a1437,
maxEquip = tonumber(rawget(_a1422, "MaxPetsEquipped")), maxHatch = _a1446,
}
end
function _a585.move.machinePos(_a1449)
local _a1450
if _a583.Machine and rawget(_a583.Machine, "GetModels") then
local _a1451, _a1452 = pcall(_a583.Machine.GetModels, _a1449)
if _a1451 and type(_a1452) == "table" then
for _a1453, _a1454 in pairs(_a1452) do
if typeof(_a1454) == "Instance" then _a1450 = _a1454 break end
end
end
end
if not _a1450 then
local _a1455, _a1456 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a1455 then
for _a1457, _a1458 in ipairs(_a1456) do
if _a1458.Name == _a1449 then _a1450 = _a1458 break end
end
end
end
if not _a1450 then return nil end
if _a1450:IsA("BasePart") then return _a1450.Position end
local _a1459, _a1460 = pcall(function() return _a1450:GetPivot() end)
return (_a1459 and typeof(_a1460) == "CFrame") and _a1460.Position or nil
end
function _a585.mach.cycleSlots()
local _a1461 = 0
local _a1462 = 0
while _a579.slots and not _a585.ctl.stopped() and _a1462 < 40 do
_a1462 += 1
local _a1463 = _a585.mach.slotStatus()
if not _a1463 then return end
local _a1464 = _a578.SlotPet and _a1463.petNext and _a1463.petCost
and (_a1463.dia - _a578.SlotReserve) >= _a1463.petCost
local _a1465 = _a578.SlotEgg and _a1463.eggEnd and _a1463.eggCost
and (_a1463.dia - _a578.SlotReserve) >= _a1463.eggCost
if _a1464 and _a1465 then
if _a1463.eggCost < _a1463.petCost then _a1464 = false else _a1465 = false end
end
if not (_a1464 or _a1465) then break end
local _a1466, _a1467, _a1468, _a1469
local function _a1470()
if _a1464 then
pcall(function() _a1466, _a1467 = _a583.R_PetSlot:InvokeServer(_a1463.petNext) end)
else
pcall(function() _a1466, _a1467 = _a583.R_EggSlot:InvokeServer(_a1463.eggEnd) end)
end
end
if _a1464 then
_a1468 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a1463.petNext, _a573(_a1463.petCost, 0))
_a1469 = "EquipSlotsMachine"
else
_a1468 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a1463.eggSize, _a1463.eggEnd, _a573(_a1463.eggCost, 0))
_a1469 = "EggSlotsMachine"
end
_a1470()
if not _a1466 and tostring(_a1467):find("far away") then
local _a1471 = _a585.move.machinePos(_a1469)
if _a1471 then
_a585.ctl.setAct("슬롯 머신으로 이동", _a1469)
_a585.move.glideTo(_a1471)
task.wait(0.25)
_a1466, _a1467 = nil, nil
_a1470()
else
_a1467 = "머신 위치를 못 찾음 (" .. _a1469 .. ")"
end
end
if _a1466 then
_a1461 += 1
_a580.mslot += 1
_a585.mach.slotSaid = nil
_a585.ctl.setAct("슬롯 구매", _a1468)
_a572("  ⬆ " .. _a1468)
task.wait(0.35)
else
local _a1472 = _a1468 .. " 실패: " .. tostring(_a1467)
if _a585.mach.slotSaid ~= _a1472 then
_a585.mach.slotSaid = _a1472
_a572("[슬롯] " .. _a1472)
end
break
end
end
if _a1461 > 0 then
local _a1473 = _a585.mach.slotStatus()
_a572(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a1461, tostring(_a1473 and _a1473.maxEquip), tostring(_a1473 and _a1473.maxHatch),
_a573(_a627("Diamonds"), 0)))
end
end
function _a585.mach.upgList()
local _a1474 = {}
if not _a583.Upg then return _a1474 end
local _a1475, _a1476 = pcall(_a583.Upg.All)
if not (_a1475 and type(_a1476) == "table") then return _a1474 end
for _a1477, _a1478 in ipairs(_a1476) do
local _a1479, _a1480, _a1481 = rawget(_a1478, "UpgradeID"), rawget(_a1478, "ZoneID"), rawget(_a1478, "UpgradeTier")
if _a1479 and _a1480 and _a1481 then
local _a1482 = false
if rawget(_a583.Upg, "Owns") then
local _a1483, _a1484 = pcall(_a583.Upg.Owns, _a1479, _a1480)
_a1482 = _a1483 and _a1484 and true or false
end
local _a1485 = _a585.move.ownsZone(_a1480)
local _a1486 = _a583.DirUpg and rawget(_a583.DirUpg, _a1479)
local _a1487 = _a1486 and rawget(_a1486, "TierCosts")
local _a1488 = _a1487 and tonumber(_a1487[_a1481])
local _a1489 = "Diamonds"
local _a1490 = _a1486 and rawget(_a1486, "TierCurrencies")
local _a1491 = _a1490 and _a1490[_a1481]
if type(_a1491) == "table" and rawget(_a1491, "_id") then _a1489 = rawget(_a1491, "_id") end
local _a1492 = rawget(_a1478, "Model")
local _a1493
if typeof(_a1492) == "Instance" then
if _a1492:IsA("BasePart") then _a1493 = _a1492.Position
else
local _a1494, _a1495 = pcall(function() return _a1492:GetPivot() end)
if _a1494 and _a1495 then _a1493 = _a1495.Position end
end
end
_a1474[#_a1474 + 1] = {
id = _a1479, zone = _a1480, tier = _a1481, cost = _a1488, cur = _a1489,
bought = _a1482, zoneOwned = _a1485,
buyable = _a1485 and not _a1482,
pos = _a1493, model = _a1492,
}
end
end
table.sort(_a1474, function(_a1496, _a1497) return (_a1496.cost or math.huge) < (_a1497.cost or math.huge) end)
return _a1474
end
function _a585.mach.cycleUpg()
if not _a583.R_Upg then _a572("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a1498 = _a585.mach.upgList()
if #_a1498 == 0 then return end
local _a1499 = 0
for _a1500, _a1501 in ipairs(_a1498) do
if not _a579.mapupg then break end
if _a1501.buyable and _a1501.cost then
local _a1502 = _a627(_a1501.cur or "Diamonds")
if _a1502 - _a578.UpgReserve < _a1501.cost then break end
if _a578.UpgTp and _a1501.pos and _a1501.zone == _a585.move.curZone() then
_a585.move.glideTo(_a1501.pos)
end
local _a1503, _a1504
pcall(function() _a1503, _a1504 = _a583.R_Upg:InvokeServer(_a1501.id, _a1501.zone) end)
if _a1503 then
_a1499 += 1
_a580.mapupg += 1
_a585.ctl.setAct("맵 업글", _a1501.id .. " T" .. _a1501.tier)
_a572(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a1501.id, _a1501.tier, _a1501.zone, _a573(_a1501.cost, 0)))
elseif _a1504 then
_a572(("[맵업글] %s T%d @%s 실패: %s"):format(
_a1501.id, _a1501.tier, _a1501.zone, tostring(_a1504)))
end
task.wait(_a578.ActionGap)
end
end
if _a1499 > 0 then
_a572(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a1499, _a573(_a627("Diamonds"), 0)))
end
end
local function _a1505()
local _a1506 = _a612()
if not _a1506 then return nil end
local _a1507 = tonumber(rawget(_a1506, "Rebirths")) or 0
local _a1508 = _a1507 + 1
local _a1509
if _a583.Rebirth and rawget(_a583.Rebirth, "GetNextRebirth") then
local _a1510, _a1511 = pcall(_a583.Rebirth.GetNextRebirth, _a1506)
if _a1510 then _a1509 = _a1511 end
end
return { current = _a1507, nextN = _a1508, def = _a1509 }
end
local function _a1512()
if not _a583.R_Reb then _a572("[리버스] Rebirth_Request 리모트 없음") return end
local _a1513 = _a1505()
if not _a1513 then
_a585.auto.rebNote = "세이브를 못 읽음"
return
end
local _a1514, _a1515
pcall(function() _a1514, _a1515 = _a583.R_Reb:InvokeServer(_a1513.nextN) end)
if _a1514 then
_a580.mreb += 1
_a585.auto.rebNote, _a585.auto.rebSaid = nil, nil
_a572(("  ★ 리버스 %d → %d"):format(_a1513.current, _a1513.nextN))
task.wait(0.5)
_a585.screen.dismissRewardScreens(25)
else
_a585.auto.rebNote = ("%d → %d : %s"):format(_a1513.current, _a1513.nextN,
_a1515 and tostring(_a1515) or "조건 미달 (리버스 킬/존 요구치)")
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
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a1512() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a655() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a1516 = _a579.farm
_a579.farm = true
pcall(_a637)
_a579.farm = _a1516
local _a1517 = _a585.quest.cycle()
if not _a1517 then
local _a1518 = _a585.move.bestZone()
if _a1518 then
local _a1519, _a1520 = _a585.move.goToZone(_a1518)
if not _a1519 then
if _a1520 and _a585.auto.idleMoveSaid ~= tostring(_a1520) then
_a585.auto.idleMoveSaid = tostring(_a1520)
_a572("[자동] 최고 존 이동 실패: " .. tostring(_a1520))
end
else
_a585.auto.idleMoveSaid = nil
end
end
if not _a578.IdleHatch then
_a585.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a585.move.curZone())))
return
end
local _a1521 = _a685()
local _a1522 = math.max(1, _a578.HatchMinAfford or 10)
if _a1521 and _a1521.price and _a1521.canBuy < _a1522 then
_a585.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a585.move.curZone()), _a1521.canBuy, _a1522,
_a573(_a1521.price, 0), tostring(_a1521.currency)))
else
_a585.ctl.setAct("대기 중 부화")
local _a1523 = _a579.mhatch
_a579.mhatch = true
pcall(_a696)
_a579.mhatch = _a1523
end
end
end },
}
_a578.StepOn = {}
for _a1524, _a1525 in ipairs(_a585.auto.SIDE) do _a578.StepOn[_a1525.key] = true end
for _a1526, _a1527 in ipairs(_a585.auto.STEPS) do _a578.StepOn[_a1527.key] = true end
local function _a1528(_a1529, _a1530, _a1531, _a1532)
if not _a578.StepOn[_a1529.key] then
_a1532[#_a1532 + 1] = ("%-14s 꺼져있음"):format(_a1529.label)
return
end
if _a1529.hold and _a1530 then
_a1532[#_a1532 + 1] = ("%-14s 보류 (%s)"):format(
_a1529.label, _a1531 and tostring(_a1531.title) or "?")
if _a585.auto.heldMsg ~= _a1529.key then
_a585.auto.heldMsg = _a1529.key
_a572(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a1529.label, _a1531 and tostring(_a1531.title) or "?"))
end
return
end
if _a1529.hold then _a585.auto.heldMsg = nil end
_a585.auto.step = _a1529.label
_a585.ctl.now.step = _a1529.label
_a585.ctl.setAct("시작", _a1529.label)
local _a1533 = os.clock()
local _a1534 = _a579[_a1529.run]
_a579[_a1529.run] = true
local _a1535, _a1536 = pcall(_a1529.fn)
_a579[_a1529.run] = _a1534
local _a1537 = os.clock() - _a1533
if not _a1535 then
_a1532[#_a1532 + 1] = ("%-14s 오류: %s"):format(_a1529.label, tostring(_a1536))
_a572("[자동] " .. _a1529.label .. " 오류: " .. tostring(_a1536))
else
local _a1538 = (_a1529.key == "zone" and _a585.auto.zoneNote)
or (_a1529.key == "mreb" and _a585.auto.rebNote) or nil
_a1532[#_a1532 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a1529.label, _a1537, _a1538 and ("  → " .. _a1538) or "")
end
end
function _a585.auto.master()
local _a1539 = {}
_a585.auto.lastTrace = _a1539
_a585.auto.lastPassAt = os.clock()
if _a585.screen.rewardScreenUp() then
_a1539[#_a1539 + 1] = "보상 화면 넘기는 중"
_a585.screen.dismissRewardScreens(15)
end
for _a1540, _a1541 in ipairs(_a585.auto.SIDE) do
if not _a579.auto or _a585.ctl.stopped() then return end
_a1528(_a1541, false, nil, _a1539)
end
local _a1542, _a1543 = false, nil
if _a578.HoldZoneForQuest then _a1542, _a1543 = _a585.quest.bestDepActive() end
for _a1544, _a1545 in ipairs(_a585.auto.STEPS) do
if not _a579.auto or _a585.ctl.stopped() then break end
_a1528(_a1545, _a1542, _a1543, _a1539)
end
_a585.auto.step = nil
if not _a585.ctl.lockGoal then
_a585.ctl.now.step = "대기"
_a585.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a578.AutoInterval or 5))
end
local _a1546 = {}
for _a1547, _a1548 in ipairs(_a1539) do _a1546[#_a1546 + 1] = (_a1548:gsub("[%d%.]+초", "")) end
_a1546 = table.concat(_a1546, " | ")
if _a1546 ~= _a585.auto.lastSig then
_a585.auto.lastSig = _a1546
_a572("[자동] 바퀴 " .. (_a585.auto.passN or 0))
for _a1549, _a1550 in ipairs(_a1539) do _a572("    " .. _a1550) end
end
_a585.auto.passN = (_a585.auto.passN or 0) + 1
end
local function _a1551()
if not _a577.R_PROMO then _a572("[타워업글] 리모트 없음") return end
local _a1552 = _a581()
if not _a1552 then return end
local _a1553 = _a582(_a1552)
table.sort(_a1553, function(_a1554, _a1555) return (_a1554.dps or 0) > (_a1555.dps or 0) end)
local _a1556, _a1557 = 0, 0
for _a1558, _a1559 in ipairs(_a1553) do
if not _a579.towerup then break end
if _a1559.id then
local _a1560
pcall(function() _a1560 = _a577.R_PROMO:InvokeServer(_a1559.id) end)
if _a1560 ~= nil and _a1560 ~= false then
_a1556 += 1
_a572(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1559.kind), tostring(_a1559.up), tostring((_a1559.up or 0) + 1)))
_a1557 = 0
task.wait(_a578.ActionGap)
else
_a1557 += 1
if _a1557 >= 5 then break end
end
end
end
_a572("[타워업글] " .. _a1556 .. "건")
end
local _a1561 = {}
local _a1562 = {}
local function _a1563(_a1564, _a1565)
local _a1566 = tostring(_a1565)
local _a1567 = _a1562[_a1564]
if _a1567 and _a1567.msg == _a1566 then
_a1567.n += 1
if _a1567.n % 20 == 0 then
_a572(("[%s 오류] %s   (%d회 반복)"):format(_a1564, _a1566, _a1567.n))
end
return
end
_a1562[_a1564] = { msg = _a1566, n = 1 }
_a572("[" .. _a1564 .. " 오류] " .. _a1566)
end
local function _a1568(_a1569, _a1570, _a1571, _a1572)
_a1561[_a1569] = (_a1561[_a1569] or 0) + 1
local _a1573 = _a1561[_a1569]
task.spawn(function()
while _a579[_a1569] and _a1561[_a1569] == _a1573 do
local _a1574, _a1575 = pcall(_a1571)
if not _a1574 then _a1563(_a1572, _a1575) else _a1562[_a1572] = nil end
local _a1576, _a1577 = _a1570(), 0
while _a1577 < _a1576 and _a579[_a1569] and _a1561[_a1569] == _a1573 do task.wait(0.1) _a1577 += 0.1 end
end
if _a1561[_a1569] == _a1573 then _a572("[" .. _a1572 .. "] 중지") end
end)
end
do
local _a1578 = {
farm   = { function() return _a578.FarmInterval end,      function() _a637() end,      "파밍" },
zone   = { function() return _a578.ZoneInterval end,      function() _a655() end,      "존" },
mhatch = { function() return _a578.MainHatchInterval end, function() _a696() end, "부화" },
}
function _a585.auto.turnOn(_a1579, _a1580)
if _a579.auto then return end
if _a579[_a1579] then return end
local _a1581 = _a1578[_a1579]
if not _a1581 then return end
_a579[_a1579] = true
_a1568(_a1579, _a1581[1], _a1581[2], _a1581[3])
if _a585.auto.refresh then _a585.auto.refresh() end
_a572("[퀘스트] " .. tostring(_a1580) .. " ON")
end
end
_a568.MG, _a568.QS, _a568.saveGet, _a568.currencyAmount, _a568.cycleFarm, _a568.zoneStatus = _a583, _a585, _a612, _a627, _a637, _a651
_a568.cycleZone, _a568.bestMainEgg, _a568.mainHatchStatus, _a568.cycleMainHatch, _a568.mainRebirthStatus, _a568.cycleMainRebirth = _a655, _a660, _a685, _a696, _a1505, _a1512
_a568.cycleTowerUp, _a568.startLoop = _a1551, _a1568
end)(_a1)
;(function(_a1582)
local _a1583, _a1584, _a1585, _a1586, _a1587, _a1588, _a1589 = _a1582.UIS, _a1582.RunService, _a1582.LP, _a1582.LOG, _a1582.log, _a1582.num, _a1582.LB
local _a1590, _a1591, _a1592, _a1593, _a1594, _a1595 = _a1582.RM, _a1582.CFG, _a1582.EGG_COST_CACHE, _a1582.RUN, _a1582.STAT, _a1582.EVENT_UPGRADES
local _a1596, _a1597, _a1598, _a1599, _a1600, _a1601 = _a1582.ctx, _a1582.collectSlots, _a1582.placedTowers, _a1582.availableItems, _a1582.cyclePlace, _a1582.cycleMerchant
local _a1602, _a1603, _a1604, _a1605, _a1606, _a1607 = _a1582.sunflowers, _a1582.eventTiers, _a1582.nextCost, _a1582.cycleUpgrade, _a1582.seedInv, _a1582.bedsOf
local _a1608, _a1609, _a1610, _a1611, _a1612, _a1613 = _a1582.isUnhatched, _a1582.bedCps, _a1582.cycleCrop, _a1582.laneCosts, _a1582.lockedBeds, _a1582.cycleExpand
local _a1614, _a1615, _a1616, _a1617, _a1618 = _a1582.rebirthStatus, _a1582.cycleRebirth, _a1582.hatchStatus, _a1582.cycleHatch, _a1582.LUCK_ORDER
local _a1619, _a1620, _a1621, _a1622, _a1623, _a1624 = _a1582.luckStatus, _a1582.fmtDur, _a1582.cycleLuck, _a1582.MG, _a1582.QS, _a1582.saveGet
local _a1625, _a1626, _a1627, _a1628, _a1629, _a1630 = _a1582.currencyAmount, _a1582.cycleFarm, _a1582.zoneStatus, _a1582.cycleZone, _a1582.bestMainEgg, _a1582.mainHatchStatus
local _a1631, _a1632, _a1633, _a1634, _a1635 = _a1582.cycleMainHatch, _a1582.mainRebirthStatus, _a1582.cycleMainRebirth, _a1582.cycleTowerUp, _a1582.startLoop
local _a1636 = {
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
local function _a1637(_a1638, _a1639, _a1640)
local _a1641 = Instance.new(_a1638)
for _a1642, _a1643 in pairs(_a1639) do _a1641[_a1642] = _a1643 end
if _a1640 then _a1641.Parent = _a1640 end
return _a1641
end
local function _a1644(_a1645, _a1646) _a1637("UICorner", { CornerRadius = UDim.new(0, _a1646 or 8) }, _a1645) end
local function _a1647(_a1648, _a1649, _a1650)
_a1637("UIStroke", { Color = _a1649 or _a1636.line, Thickness = _a1650 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _a1648)
end
local function _a1651(_a1652, _a1653)
_a1637("UIPadding", {
PaddingTop = UDim.new(0, _a1653), PaddingBottom = UDim.new(0, _a1653),
PaddingLeft = UDim.new(0, _a1653), PaddingRight = UDim.new(0, _a1653),
}, _a1652)
end
local _a1654 = _a1637("ScreenGui", {
Name = "PS99GardenAuto", ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset = true, DisplayOrder = 9999,
})
local _a1655 = false
if type(gethui) == "function" then _a1655 = pcall(function() _a1654.Parent = gethui() end) end
if not _a1655 then _a1655 = pcall(function() _a1654.Parent = game:GetService("CoreGui") end) end
if not _a1655 then _a1654.Parent = _a1585:WaitForChild("PlayerGui") end
local _a1656, _a1657 = 780, 520
local _a1658 = _a1637("Frame", {
Size = UDim2.fromOffset(_a1656, _a1657), Position = UDim2.new(0.5, -_a1656 / 2, 0.5, -_a1657 / 2),
BackgroundColor3 = _a1636.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, _a1654)
_a1644(_a1658, 12)
_a1647(_a1658, Color3.fromRGB(60, 66, 82), 1)
local _a1659 = _a1637("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = _a1636.panel, BorderSizePixel = 0,
}, _a1658)
_a1644(_a1659, 12)
_a1637("Frame", {
Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
BackgroundColor3 = _a1636.panel, BorderSizePixel = 0,
}, _a1659)
_a1637("Frame", {
Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(14, 15),
BackgroundColor3 = _a1636.good, BorderSizePixel = 0,
}, _a1659).Name = "Dot"
_a1644(_a1659:FindFirstChild("Dot"), 5)
_a1637("TextLabel", {
Size = UDim2.new(0, 320, 1, 0), Position = UDim2.fromOffset(32, 0),
BackgroundTransparency = 1, Text = "Garden Defenders  AutoPlay",
TextColor3 = _a1636.text, TextSize = 14, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1659)
local function _a1660(_a1661, _a1662, _a1663, _a1664)
local _a1665 = _a1637("TextButton", {
Size = UDim2.new(0, _a1664, 0, 24), Position = UDim2.new(1, _a1663, 0, 8),
BackgroundColor3 = _a1662, BorderSizePixel = 0, Text = _a1661,
TextColor3 = _a1636.text, TextSize = 12, Font = Enum.Font.GothamMedium,
AutoButtonColor = true,
}, _a1659)
_a1644(_a1665, 6)
return _a1665
end
local _a1666 = _a1660("✕", _a1636.bad, -38, 28)
local _a1667   = _a1660("—", _a1636.card, -70, 28)
local _a1668 = _a1660("지우기", _a1636.card, -132, 58)
local _a1669  = _a1660("복사", _a1636.accent, -190, 54)
local _a1670  = _a1660("정지", _a1636.bad, -252, 58)
_a1670.MouseButton1Click:Connect(function()
task.spawn(function()
_a1623.ctl.stopAll()
if _a1623.auto.refresh then pcall(_a1623.auto.refresh) end
_a1587("[정지] 모든 동작을 멈췄습니다")
end)
end)
local _a1671 = _a1637("ScrollingFrame", {
Size = UDim2.new(0, 152, 1, -92), Position = UDim2.fromOffset(10, 48),
BackgroundColor3 = _a1636.panel, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = _a1636.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1658)
_a1644(_a1671, 8)
_a1637("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, _a1671)
_a1637("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, _a1671)
local _a1672 = _a1637("Frame", {
Size = UDim2.new(1, -182, 1, -92), Position = UDim2.fromOffset(172, 48),
BackgroundTransparency = 1,
}, _a1658)
local _a1673, _a1674 = {}, nil
local _a1675, _a1676 = {}, {}
local _a1677 = {}
local function _a1678(_a1679)
_a1674 = _a1679
for _a1680, _a1681 in pairs(_a1673) do _a1681.Visible = (_a1680 == _a1679) end
for _a1682, _a1683 in pairs(_a1675) do
local _a1684 = (_a1682 == _a1679)
_a1683.BackgroundColor3 = _a1684 and _a1636.accent or _a1636.panel
_a1683.TextColor3 = _a1684 and Color3.fromRGB(255, 255, 255) or _a1636.dim
end
local _a1685 = _a1676[_a1679]
if _a1685 and _a1677[_a1685] and not _a1677[_a1685].open then _a1677[_a1685].toggle() end
end
local function _a1686(_a1687, _a1688, _a1689)
local _a1690 = { open = true, kids = {} }
local _a1691 = _a1637("TextButton", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = _a1636.bg, BorderSizePixel = 0,
Text = "", TextColor3 = _a1636.dim, TextSize = 11,
Font = Enum.Font.GothamBold, LayoutOrder = _a1689, AutoButtonColor = false,
}, _a1671)
_a1644(_a1691, 5)
local _a1692 = _a1637("TextLabel", {
Size = UDim2.fromOffset(14, 26), Position = UDim2.fromOffset(6, 0),
BackgroundTransparency = 1, Text = "▾", TextColor3 = _a1636.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1691)
_a1637("TextLabel", {
Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(20, 0),
BackgroundTransparency = 1, Text = _a1688, TextColor3 = _a1636.dim,
TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1691)
function _a1690.toggle()
_a1690.open = not _a1690.open
_a1692.Text = _a1690.open and "▾" or "▸"
for _a1693, _a1694 in ipairs(_a1690.kids) do _a1694.Visible = _a1690.open end
end
_a1691.MouseButton1Click:Connect(_a1690.toggle)
_a1677[_a1687] = _a1690
return _a1690
end
local function _a1695(_a1696, _a1697, _a1698, _a1699)
local _a1700 = _a1699 and 14 or 6
local _a1701 = _a1637("TextButton", {
Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = _a1636.panel, BorderSizePixel = 0,
Text = "", TextColor3 = _a1636.dim, TextSize = 12,
Font = Enum.Font.GothamMedium, LayoutOrder = _a1698, AutoButtonColor = false,
}, _a1671)
_a1644(_a1701, 5)
local _a1702 = _a1637("TextLabel", {
Size = UDim2.new(1, -_a1700 - 4, 1, 0), Position = UDim2.fromOffset(_a1700, 0),
BackgroundTransparency = 1, Text = _a1697, TextColor3 = _a1636.dim,
TextSize = 12, Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1701)
_a1675[_a1696] = _a1701
if _a1699 then
_a1676[_a1696] = _a1699
local _a1703 = _a1677[_a1699]
if _a1703 then
table.insert(_a1703.kids, _a1701)
_a1701.Visible = _a1703.open
end
end
local _a1704 = _a1637("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false,
BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1636.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1672)
_a1637("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1704)
_a1637("UIPadding", { PaddingRight = UDim.new(0, 8) }, _a1704)
_a1673[_a1696] = _a1704
_a1701.MouseButton1Click:Connect(function() _a1678(_a1696) end)
_a1701.MouseEnter:Connect(function()
if _a1674 ~= _a1696 then _a1701.BackgroundColor3 = _a1636.card end
end)
_a1701.MouseLeave:Connect(function()
if _a1674 ~= _a1696 then _a1701.BackgroundColor3 = _a1636.panel end
end)
_a1701:GetPropertyChangedSignal("TextColor3"):Connect(function()
_a1702.TextColor3 = _a1701.TextColor3
end)
return _a1704
end
local _a1705 = 0
local function _a1706()
_a1705 += 1
return _a1705
end
local function _a1707(_a1708, _a1709)
local _a1710 = _a1637("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = _a1706(),
}, _a1708)
_a1637("Frame", {
Size = UDim2.fromOffset(3, 14), Position = UDim2.fromOffset(0, 7),
BackgroundColor3 = _a1636.accent, BorderSizePixel = 0,
}, _a1710)
_a1637("TextLabel", {
Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1, Text = _a1709, TextColor3 = _a1636.text,
TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1710)
return _a1710
end
local function _a1711(_a1712, _a1713, _a1714)
local _a1715 = _a1637("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = _a1636.card, BorderSizePixel = 0, LayoutOrder = _a1706(),
}, _a1712)
_a1644(_a1715, 8)
_a1647(_a1715, _a1636.line, 1)
_a1651(_a1715, 12)
_a1637("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1715)
if _a1713 then
local _a1716 = _a1637("Frame", {
Size = UDim2.new(1, 0, 0, _a1714 and 32 or 22), BackgroundTransparency = 1,
LayoutOrder = 0,
}, _a1715)
_a1637("TextLabel", {
Size = UDim2.new(1, -70, 0, 16), BackgroundTransparency = 1, Text = _a1713,
TextColor3 = _a1636.text, TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1716)
if _a1714 then
_a1637("TextLabel", {
Size = UDim2.new(1, -70, 0, 13), Position = UDim2.fromOffset(0, 17),
BackgroundTransparency = 1, Text = _a1714, TextColor3 = _a1636.dim,
TextSize = 11, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, _a1716)
end
_a1715:SetAttribute("HeadHeight", _a1714 and 32 or 18)
return _a1715, _a1716
end
return _a1715
end
local _a1717 = {}
local function _a1718()
for _a1719, _a1720 in pairs(_a1717) do pcall(_a1720) end
end
_a1623.auto.refresh = _a1718
local function _a1721(_a1722, _a1723, _a1724)
local _a1725 = _a1637("TextButton", {
Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -46, 0, 0),
BackgroundColor3 = _a1636.cardHi, BorderSizePixel = 0, Text = "",
AutoButtonColor = false,
}, _a1722)
_a1644(_a1725, 12)
local _a1726 = _a1637("Frame", {
Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
BackgroundColor3 = _a1636.dim, BorderSizePixel = 0,
}, _a1725)
_a1644(_a1726, 9)
local _a1727 = _a1637("TextLabel", {
Size = UDim2.fromOffset(46, 12), Position = UDim2.fromOffset(0, 26),
BackgroundTransparency = 1, Text = "OFF", TextColor3 = _a1636.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1725)
local function _a1728()
local _a1729 = _a1593[_a1723]
_a1725.BackgroundColor3 = _a1729 and _a1636.good or _a1636.cardHi
_a1726:TweenPosition(UDim2.fromOffset(_a1729 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a1726.BackgroundColor3 = _a1729 and Color3.fromRGB(255, 255, 255) or _a1636.dim
_a1727.Text = _a1729 and "ON" or "OFF"
_a1727.TextColor3 = _a1729 and _a1636.good or _a1636.dim
end
_a1725.MouseButton1Click:Connect(function()
_a1593[_a1723] = not _a1593[_a1723]
if _a1593[_a1723] then
if _a1723 == "auto" then _a1623.ctl.abort = false end
_a1728()
_a1587("[" .. _a1723 .. "] 시작")
task.spawn(function()
local _a1730, _a1731 = pcall(_a1724)
if not _a1730 then _a1587("[에러] " .. tostring(_a1731)) end
end)
else
if _a1723 == "auto" then
_a1623.ctl.stopAll()
_a1587("[정지] 모든 동작을 멈췄습니다")
end
_a1728()
end
end)
_a1728()
_a1717[_a1723] = _a1728
return _a1725, _a1728
end
local function _a1732(_a1733, _a1734)
local _a1735 = _a1637("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = _a1706(),
}, _a1733)
local _a1736 = #_a1734
for _a1737, _a1738 in ipairs(_a1734) do
local _a1739 = _a1637("Frame", {
Size = UDim2.new(1 / _a1736, -6, 1, 0), Position = UDim2.new((_a1737 - 1) / _a1736, 3, 0, 0),
BackgroundTransparency = 1,
}, _a1735)
_a1637("TextLabel", {
Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = _a1738.label,
TextColor3 = _a1636.dim, TextSize = 10, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1739)
local _a1740 = _a1637("TextBox", {
Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 15),
BackgroundColor3 = _a1636.bg, BorderSizePixel = 0, Text = tostring(_a1738.value),
TextColor3 = _a1636.text, TextSize = 12, Font = Enum.Font.Code,
ClearTextOnFocus = false,
}, _a1739)
_a1644(_a1740, 5)
_a1647(_a1740, _a1636.line, 1)
_a1740.FocusLost:Connect(function() _a1738.onChange(_a1740.Text, _a1740) end)
end
return _a1735
end
local function _a1741(_a1742, _a1743)
local _a1744 = _a1637("Frame", {
Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = _a1706(),
}, _a1742)
local _a1745 = #_a1743
for _a1746, _a1747 in ipairs(_a1743) do
local _a1748 = _a1637("TextButton", {
Size = UDim2.new(1 / _a1745, -5, 1, 0), Position = UDim2.new((_a1746 - 1) / _a1745, 2.5, 0, 0),
BackgroundColor3 = _a1747.col or _a1636.cardHi, BorderSizePixel = 0, Text = _a1747.label,
TextColor3 = _a1636.text, TextSize = 12, Font = Enum.Font.GothamMedium,
}, _a1744)
_a1644(_a1748, 6)
_a1748.MouseButton1Click:Connect(function()
task.spawn(function()
local _a1749, _a1750 = pcall(_a1747.fn, _a1748)
if not _a1749 then _a1587("[에러] " .. tostring(_a1747.label) .. " → " .. tostring(_a1750)) end
end)
end)
end
return _a1744
end
local function _a1751(_a1752, _a1753, _a1754, _a1755)
local _a1756 = _a1637("TextButton", {
Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = _a1636.cardHi, BorderSizePixel = 0,
Text = "", TextColor3 = _a1636.text, TextSize = 12, Font = Enum.Font.GothamMedium,
LayoutOrder = _a1706(),
}, _a1752)
_a1644(_a1756, 6)
local function _a1757()
local _a1758 = _a1754()
_a1756.Text = _a1753 .. "   " .. (_a1758 and "ON" or "OFF")
_a1756.BackgroundColor3 = _a1758 and Color3.fromRGB(40, 78, 58) or _a1636.cardHi
_a1756.TextColor3 = _a1758 and _a1636.good or _a1636.dim
end
_a1756.MouseButton1Click:Connect(function()
_a1755(not _a1754())
_a1757()
end)
_a1757()
return _a1756
end
local _a1759 = _a1695("log", "로그", 90)
local _a1760, _a1761, _a1762
local _a1763 = { size = 140, top = nil }
do
local _a1764 = _a1637("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a1706(),
}, _a1759)
_a1644(_a1764, 8)
_a1647(_a1764, _a1636.line, 1)
local _a1765 = _a1637("Frame", {
Size = UDim2.new(1, -10, 0, 24), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1,
}, _a1764)
_a1761 = _a1637("TextLabel", {
Size = UDim2.new(1, -250, 1, 0), BackgroundTransparency = 1,
Text = "", TextColor3 = _a1636.dim, TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1765)
local function _a1766(_a1767, _a1768, _a1769, _a1770)
local _a1771 = _a1637("TextButton", {
Size = UDim2.new(0, _a1768, 0, 22), Position = UDim2.new(1, _a1767, 0, 1),
BackgroundColor3 = _a1636.cardHi, BorderSizePixel = 0, AutoButtonColor = true,
Text = _a1769, TextColor3 = _a1636.text, TextSize = 11, Font = Enum.Font.GothamBold,
}, _a1765)
_a1644(_a1771, 5)
_a1771.MouseButton1Click:Connect(function()
task.spawn(function() pcall(_a1770) _a1582.dirty = true end)
end)
return _a1771
end
local function _a1772()
return _a1763.top or math.max(1, #_a1586 - _a1763.size + 1)
end
_a1766(-244, 56, "맨 위",  function() _a1763.top = 1 end)
_a1766(-186, 40, "▲",     function() _a1763.top = math.max(1, _a1772() - _a1763.size) end)
_a1766(-144, 40, "▼",     function()
local _a1773 = _a1772() + _a1763.size
if _a1773 >= math.max(1, #_a1586 - _a1763.size + 1) then _a1763.top = nil else _a1763.top = _a1773 end
end)
_a1766(-102, 100, "최신 따라가기", function() _a1763.top = nil end)
_a1762 = _a1637("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -36), Position = UDim2.fromOffset(5, 31),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 6,
ScrollBarImageColor3 = _a1636.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1764)
_a1760 = _a1637("TextLabel", {
Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(196, 208, 196),
TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
TextWrapped = true,
}, _a1762)
_a1759.AutomaticCanvasSize = Enum.AutomaticSize.None
_a1759.CanvasSize = UDim2.new()
end
do
local _a1774, _a1775, _a1776, _a1777
_a1659.InputBegan:Connect(function(_a1778)
if _a1778.UserInputType == Enum.UserInputType.MouseButton1
or _a1778.UserInputType == Enum.UserInputType.Touch then
_a1774, _a1775, _a1776 = true, _a1778.Position, _a1658.Position
_a1778.Changed:Connect(function()
if _a1778.UserInputState == Enum.UserInputState.End then _a1774 = false end
end)
end
end)
_a1659.InputChanged:Connect(function(_a1779)
if _a1779.UserInputType == Enum.UserInputType.MouseMovement
or _a1779.UserInputType == Enum.UserInputType.Touch then _a1777 = _a1779 end
end)
_a1583.InputChanged:Connect(function(_a1780)
if _a1774 and _a1780 == _a1777 then
local _a1781 = _a1780.Position - _a1775
_a1658.Position = UDim2.new(_a1776.X.Scale, _a1776.X.Offset + _a1781.X,
_a1776.Y.Scale, _a1776.Y.Offset + _a1781.Y)
end
end)
local _a1782 = false
_a1667.MouseButton1Click:Connect(function()
_a1782 = not _a1782
_a1658:TweenSize(_a1782 and UDim2.fromOffset(_a1656, 40) or UDim2.fromOffset(_a1656, _a1657),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a1667.Text = _a1782 and "▢" or "—"
end)
end
local _a1783 = _a1584.Heartbeat:Connect(function()
if not _a1582.dirty then return end
_a1582.dirty = false
local _a1784 = #_a1586
local _a1785 = math.max(1, _a1784 - _a1763.size + 1)
local _a1786 = (_a1763.top == nil)
local _a1787 = math.max(1, math.min(_a1763.top or _a1785, _a1785))
local _a1788 = math.min(_a1784, _a1787 + _a1763.size - 1)
local _a1789, _a1790 = {}, 0
for _a1791 = _a1787, _a1788 do
local _a1792 = _a1586[_a1791] or ""
if #_a1792 > 400 then _a1792 = _a1792:sub(1, 400) .. " …" end
_a1790 += #_a1792 + 1
if _a1790 > 12000 then
_a1789[#_a1789 + 1] = "…  (이 창에 다 못 담아 잘랐습니다. ▲ 로 나눠서 보세요)"
_a1788 = _a1791 - 1
break
end
_a1789[#_a1789 + 1] = _a1792
end
_a1760.Text = table.concat(_a1789, "\n")
_a1761.Text = ("%d-%d / %d 줄    %s")
:format(_a1787, _a1788, _a1784, _a1786 and "최신 따라가는 중" or "▲▼ 로 이동  ·  멈춤")
if _a1786 then
task.defer(function()
if _a1762 and _a1762.Parent then
_a1762.CanvasPosition = Vector2.new(0, _a1762.AbsoluteCanvasSize.Y)
end
end)
end
end)
local _a1793 = _a1695("dash", "대시보드", 10)
local _a1794 = _a1695("event", "이벤트", 20)
do
local _a1795 = _a1711(_a1793, "전체 제어", nil)
_a1741(_a1795, {
{ label = "권장 전부 ON", col = _a1636.good, fn = function()
for _a1796, _a1797 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a1593[_a1797] then
_a1593[_a1797] = true
if _a1797 == "place"    then _a1635(_a1797, function() return _a1591.PlaceInterval end, _a1600, "배치") end
if _a1797 == "merchant" then _a1635(_a1797, function() return _a1591.MerchantInterval end, _a1601, "구매") end
if _a1797 == "crop"     then _a1635(_a1797, function() return _a1591.CropInterval end, _a1610, "씨앗") end
if _a1797 == "expand"   then _a1635(_a1797, function() return _a1591.ExpandInterval end, _a1613, "확장") end
if _a1797 == "hatch"    then _a1635(_a1797, function() return _a1591.HatchInterval end, _a1617, "뽑기") end
end
end
_a1718()
_a1587("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a1636.bad, fn = function()
_a1593.place, _a1593.merchant, _a1593.upgrade = false, false, false
_a1593.towerup, _a1593.crop, _a1593.expand, _a1593.rebirth, _a1593.hatch, _a1593.luck = false, false, false, false, false, false
_a1593.farm, _a1593.zone, _a1593.mhatch, _a1593.rank, _a1593.mreb = false, false, false, false, false
_a1718()
_a1587("[전체] 정지")
end },
})
local _a1798 = _a1711(_a1793, "현황", nil)
_a1741(_a1798, {
{ label = "밭 / 타워", col = _a1636.accent, fn = function()
local _a1799, _a1800, _a1801, _a1802 = _a1596()
_a1587("")
_a1587("──── 현재 상태 ────")
_a1587("레인 " .. tostring(_a1802) .. " / plot " .. (_a1801 and "O" or "X")
.. " / world " .. (_a1799 and "O" or "X"))
local _a1803 = _a1597(_a1801, _a1802)
local _a1804 = _a1598(_a1799)
_a1587("슬롯 " .. #_a1803 .. " / 배치 " .. #_a1804)
local _a1805, _a1806 = 0, {}
for _a1807, _a1808 in ipairs(_a1804) do
_a1805 += (_a1808.dps or 0)
_a1806[tostring(_a1808.kind)] = (_a1806[tostring(_a1808.kind)] or 0) + 1
end
_a1587("총 DPS " .. _a1588(_a1805))
for _a1809, _a1810 in pairs(_a1806) do _a1587("  " .. _a1809 .. " × " .. _a1810) end
local _a1811 = _a1599()
_a1587("")
_a1587("배치 가능 " .. #_a1811 .. "종")
for _a1812 = 1, math.min(10, #_a1811) do
local _a1813 = _a1811[_a1812]
_a1587(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a1813.id), tostring(_a1813.vr or "-"), tostring(_a1813.copies), _a1588(_a1813.dps)))
end
_a1678("log")
end },
{ label = "로그 보기", col = _a1636.cardHi, fn = function() _a1678("log") end },
})
end
do
local _a1814, _a1815 = _a1711(_a1794, "자동 배치 / 교체", nil)
_a1721(_a1815, "place", function()
_a1635("place", function() return _a1591.PlaceInterval end, _a1600, "배치")
end)
_a1732(_a1814, {
{ label = "주기", value = _a1591.PlaceInterval, onChange = function(_a1816)
local _a1817 = tonumber(_a1816) if _a1817 and _a1817 >= 3 then _a1591.PlaceInterval = _a1817 end
end },
{ label = "교체 배수", value = _a1591.SwapMargin, onChange = function(_a1818)
local _a1819 = tonumber(_a1818) if _a1819 and _a1819 >= 1 then _a1591.SwapMargin = _a1819 _a1587("[설정] 교체 배수 " .. _a1819) end
end },
{ label = "DoT 반영", value = _a1591.DotFactor, onChange = function(_a1820)
local _a1821 = tonumber(_a1820) if _a1821 and _a1821 >= 0 and _a1821 <= 1 then _a1591.DotFactor = _a1821 end
end },
})
_a1751(_a1814, "업글 타워 보호",
function() return _a1591.ProtectUpgraded end,
function(_a1822) _a1591.ProtectUpgraded = _a1822
_a1587("[설정] 업글 보호 " .. (_a1822 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a1741(_a1814, {
{ label = "지금 1회 실행", col = _a1636.accent, fn = function()
task.spawn(function() _a1593.place = true _a1600() _a1593.place = false _a1678("log") end)
end },
})
end
do
local _a1823, _a1824 = _a1711(_a1794, "머천트 자동 구매", nil)
_a1721(_a1824, "merchant", function()
_a1635("merchant", function() return _a1591.MerchantInterval end, _a1601, "구매")
end)
_a1732(_a1823, {
{ label = "머천트 ID", value = _a1591.MerchantId, onChange = function(_a1825)
if _a1825 ~= "" then _a1591.MerchantId = _a1825 _a1587("[설정] 머천트 " .. _a1825) end
end },
{ label = "주기", value = _a1591.MerchantInterval, onChange = function(_a1826)
local _a1827 = tonumber(_a1826) if _a1827 and _a1827 >= 5 then _a1591.MerchantInterval = _a1827 end
end },
})
_a1741(_a1823, {
{ label = "지금 1회 구매", col = _a1636.accent, fn = function()
task.spawn(function() _a1593.merchant = true _a1601() _a1593.merchant = false _a1678("log") end)
end },
})
end
do
local _a1828, _a1829 = _a1711(_a1794, "업그레이드 머신", nil)
_a1721(_a1829, "upgrade", function()
_a1635("upgrade", function() return _a1591.UpgradeInterval end, _a1605, "머신업글")
end)
_a1732(_a1828, {
{ label = "주기", value = _a1591.UpgradeInterval, onChange = function(_a1830)
local _a1831 = tonumber(_a1830) if _a1831 and _a1831 >= 5 then _a1591.UpgradeInterval = _a1831 end
end },
{ label = "최소 잔액", value = _a1591.MinSunflowers, onChange = function(_a1832)
local _a1833 = tonumber(_a1832) if _a1833 and _a1833 >= 0 then _a1591.MinSunflowers = _a1833
_a1587("[설정] 최소 잔액 " .. _a1588(_a1833, 0)) end
end },
})
_a1751(_a1828, "가격 미상 구매",
function() return _a1591.BuyUnknownCost end,
function(_a1834) _a1591.BuyUnknownCost = _a1834 end)
_a1741(_a1828, {
{ label = "업글 현황 보기", col = _a1636.accent, fn = function()
local _a1835 = _a1602()
local _a1836 = _a1603()
_a1594.sun = _a1835
_a1587("")
_a1587("──── 업그레이드 머신 ────")
_a1587("Sunflowers = " .. _a1588(_a1835, 0))
local _a1837 = {}
for _a1838, _a1839 in ipairs(_a1595) do
local _a1840 = _a1836[_a1839] or 0
_a1837[#_a1837 + 1] = { id = _a1839, tier = _a1840, cost = _a1604(_a1839, _a1840) }
end
table.sort(_a1837, function(_a1841, _a1842)
return (_a1841.cost or math.huge) < (_a1842.cost or math.huge)
end)
for _a1843, _a1844 in ipairs(_a1837) do
_a1587(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a1844.id, tostring(_a1844.tier), _a1844.cost and _a1588(_a1844.cost, 0) or "?",
(_a1844.cost and _a1844.cost <= _a1835) and "← 구매가능" or ""))
end
_a1678("log")
end },
{ label = "지금 1회 업글", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.upgrade = true _a1605() _a1593.upgrade = false _a1678("log") end)
end },
})
local _a1845, _a1846 = _a1711(_a1794, "타워 개별 업글", nil)
_a1721(_a1846, "towerup", function()
_a1635("towerup", function() return _a1591.UpgradeInterval end, _a1634, "타워업글")
end)
end
do
local _a1847, _a1848 = _a1711(_a1794, "자동 뽑기", nil)
_a1721(_a1848, "hatch", function()
_a1635("hatch", function() return _a1591.HatchInterval end, _a1617, "뽑기")
end)
_a1732(_a1847, {
{ label = "주기", value = _a1591.HatchInterval, onChange = function(_a1849)
local _a1850 = tonumber(_a1849) if _a1850 and _a1850 >= 1 then _a1591.HatchInterval = _a1850 end
end },
{ label = "한 번에 최대", value = _a1591.HatchMax, onChange = function(_a1851)
local _a1852 = tonumber(_a1851) if _a1852 and _a1852 >= 1 then _a1591.HatchMax = math.floor(_a1852) end
end },
})
_a1732(_a1847, {
{ label = "예비금", value = _a1591.HatchReserve, onChange = function(_a1853)
local _a1854 = tonumber(_a1853) if _a1854 and _a1854 >= 0 then _a1591.HatchReserve = _a1854
_a1587("[설정] 뽑기 예비금 " .. _a1588(_a1854, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a1591.HatchEggNum, onChange = function(_a1855)
local _a1856 = tonumber(_a1855) if _a1856 and _a1856 >= 0 and _a1856 <= 12 then
_a1591.HatchEggNum = math.floor(_a1856)
table.clear(_a1592)
_a1587("[설정] 알 번호 " .. (_a1856 == 0 and "자동" or _a1856)) end
end },
})
_a1741(_a1847, {
{ label = "뽑기 현황 보기", col = _a1636.accent, fn = function()
local _a1857 = _a1616()
_a1594.sun = _a1857.sun
_a1587("")
_a1587("──── 뽑기 현황 ────")
_a1587("  알 등급     " .. _a1857.id)
_a1587("  알 uid      " .. tostring(_a1857.uid))
_a1587("  개당 비용   " .. (_a1857.cost and _a1588(_a1857.cost, 0) or "?"))
_a1587("  Sunflowers  " .. _a1588(_a1857.sun, 0))
_a1587("  예비금      " .. _a1588(_a1591.HatchReserve, 0))
_a1587("  지금 가능   " .. _a1857.canBuy .. "회")
_a1587("")
_a1587("  월드의 알 " .. _a1857.eggCount .. "개")
for _a1858, _a1859 in ipairs(_a1857.eggs) do
if _a1858 > 5 then break end
_a1587(("    %s  거리 %s"):format(_a1859.uid, _a1588(_a1859.dist)))
end
_a1587("")
_a1587("  누적 뽑기   " .. _a1594.hatched .. "회")
_a1678("log")
end },
{ label = "지금 1회 실행", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.hatch = true _a1617() _a1593.hatch = false _a1678("log") end)
end },
})
end
do
local _a1860, _a1861 = _a1711(_a1794, "럭 상시 최대 유지", nil)
_a1721(_a1861, "luck", function()
_a1635("luck", function() return _a1591.LuckInterval end, _a1621, "럭")
end)
_a1732(_a1860, {
{ label = "주기", value = _a1591.LuckInterval, onChange = function(_a1862)
local _a1863 = tonumber(_a1862) if _a1863 and _a1863 >= 60 then _a1591.LuckInterval = _a1863 end
end },
{ label = "예비금", value = _a1591.LuckReserve, onChange = function(_a1864)
local _a1865 = tonumber(_a1864) if _a1865 and _a1865 >= 0 then _a1591.LuckReserve = _a1865 end
end },
})
_a1732(_a1860, {
{ label = "최소 부족분", value = _a1591.LuckMinTopUp, onChange = function(_a1866)
local _a1867 = tonumber(_a1866) if _a1867 and _a1867 >= 0 then _a1591.LuckMinTopUp = _a1867 end
end },
})
for _a1868, _a1869 in ipairs(_a1618) do
_a1751(_a1860, _a1869,
function() return _a1591.LuckBoosts[_a1869] end,
function(_a1870) _a1591.LuckBoosts[_a1869] = _a1870 end)
end
_a1741(_a1860, {
{ label = "럭 현황 보기", col = _a1636.accent, fn = function()
local _a1871 = _a1619()
_a1594.sun = _a1871.sun
_a1587("")
_a1587("──── 이벤트 럭 ────")
_a1587("  머신 활성   " .. (_a1871.enabled and "O" or "X"))
_a1587("  최대 시간   " .. _a1620(_a1871.maxSec))
_a1587("  Sunflowers  " .. _a1588(_a1871.sun, 0))
_a1587("")
for _a1872, _a1873 in ipairs(_a1871.rows) do
_a1587(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a1873.rarity, _a1620(_a1873.left), _a1620(_a1873.deficit), _a1588(_a1873.need, 0),
_a1873.on and "" or "   (꺼짐)"))
end
_a1587("")
_a1587("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a1678("log")
end },
{ label = "지금 1회 충전", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.luck = true _a1621() _a1593.luck = false _a1678("log") end)
end },
})
end
do
local _a1874, _a1875 = _a1711(_a1794, "자동 씨앗 교체", nil)
_a1721(_a1875, "crop", function()
_a1635("crop", function() return _a1591.CropInterval end, _a1610, "씨앗")
end)
_a1732(_a1874, {
{ label = "주기", value = _a1591.CropInterval, onChange = function(_a1876)
local _a1877 = tonumber(_a1876) if _a1877 and _a1877 >= 5 then _a1591.CropInterval = _a1877 end
end },
{ label = "갈아엎기 배수", value = _a1591.CropMargin, onChange = function(_a1878)
local _a1879 = tonumber(_a1878) if _a1879 and _a1879 >= 1 then _a1591.CropMargin = _a1879 _a1587("[설정] 작물 배수 " .. _a1879) end
end },
})
_a1751(_a1874, "성장중 건너뛰기",
function() return _a1591.SkipUnhatched end,
function(_a1880) _a1591.SkipUnhatched = _a1880 end)
_a1741(_a1874, {
{ label = "밭 현황 보기", col = _a1636.accent, fn = function()
local _a1881, _a1882 = _a1596()
if not _a1882 then _a1587("[씨앗] 밭 없음") _a1678("log") return end
local _a1883, _a1884 = _a1607(_a1882), _a1606()
_a1587("")
_a1587("──── 밭 현황 ────")
_a1587("보유 씨앗 (기대 초당수익 순)")
for _a1885, _a1886 in ipairs(_a1884) do
_a1587(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a1886.id), tostring(_a1886.vr or "-"), tostring(_a1886.am), _a1588(_a1886.exp)))
end
local _a1887, _a1888, _a1889, _a1890, _a1891 = 0, 0, 0, 0, 0
local _a1892 = _a1884[1]
local _a1893 = _a1892 and _a1892.exp or 0
_a1587("")
_a1587("심어진 작물")
local _a1894 = 0
for _a1895, _a1896 in pairs(_a1883) do
_a1887 += 1
local _a1897 = _a1609(_a1896) or 0
_a1888 += _a1897
if _a1608(_a1896) then _a1890 += 1
elseif _a1893 > _a1897 * _a1591.CropMargin then _a1889 += 1
else _a1891 += 1 end
_a1894 += 1
if _a1894 <= 20 then
_a1587(("  칸%-4s %-20s %s/s%s"):format(tostring(_a1895),
tostring(rawget(_a1896, "sp") or "?"), _a1588(_a1897),
_a1608(_a1896) and "  (자라는 중)" or ""))
end
end
if _a1887 > 20 then _a1587("  ... (" .. (_a1887 - 20) .. "칸 더)") end
_a1587("")
_a1587(("총 %d칸 / 합계 %s per sec"):format(_a1887, _a1588(_a1888)))
_a1587(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a1889, _a1891, _a1890))
_a1678("log")
end },
{ label = "지금 1회 실행", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.crop = true _a1610() _a1593.crop = false _a1678("log") end)
end },
})
end
do
local _a1898, _a1899 = _a1711(_a1794, "자동 확장", nil)
_a1721(_a1899, "expand", function()
_a1635("expand", function() return _a1591.ExpandInterval end, _a1613, "확장")
end)
_a1732(_a1898, {
{ label = "주기", value = _a1591.ExpandInterval, onChange = function(_a1900)
local _a1901 = tonumber(_a1900) if _a1901 and _a1901 >= 5 then _a1591.ExpandInterval = _a1901 end
end },
{ label = "밭칸 스캔", value = _a1591.MaxBedScan, onChange = function(_a1902)
local _a1903 = tonumber(_a1902) if _a1903 and _a1903 >= 1 then _a1591.MaxBedScan = math.floor(_a1903) end
end },
})
_a1741(_a1898, {
{ label = "확장 현황 보기", col = _a1636.accent, fn = function()
local _a1904, _a1905, _a1906, _a1907 = _a1596()
if not _a1905 then _a1587("[확장] 밭 없음") _a1678("log") return end
local _a1908 = _a1602()
_a1594.sun = _a1908
local _a1909 = _a1611(true)
_a1587("")
_a1587("──── 확장 현황 ────")
_a1587("Sunflowers = " .. _a1588(_a1908, 0))
_a1587("")
_a1587("레인 " .. tostring(_a1907) .. "개 열림")
local _a1910 = {}
for _a1911 in pairs(_a1909) do _a1910[#_a1910 + 1] = tonumber(_a1911) or _a1911 end
table.sort(_a1910, function(_a1912, _a1913) return tostring(_a1912) < tostring(_a1913) end)
for _a1914, _a1915 in ipairs(_a1910) do
local _a1916 = _a1909[_a1915] or _a1909[tostring(_a1915)]
local _a1917 = tonumber(_a1915) or 0
local _a1918 = (_a1917 == (tonumber(_a1907) or 0) + 1)
and ((tonumber(_a1916) or math.huge) <= _a1908 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a1917 <= (tonumber(_a1907) or 0) and "  (열림)" or "")
_a1587(("  레인 %-3s %s%s"):format(tostring(_a1915), _a1588(tonumber(_a1916) or 0, 0), _a1918))
end
local _a1919 = _a1612(_a1905)
_a1587("")
_a1587("잠긴 밭칸 " .. #_a1919 .. "개 (싼 순 8개)")
for _a1920 = 1, math.min(8, #_a1919) do
local _a1921 = _a1919[_a1920]
_a1587(("  칸 %-4s %s%s"):format(_a1921.id, _a1921.cost and _a1588(_a1921.cost, 0) or "?",
(_a1921.cost and _a1921.cost <= _a1908) and "  ← 오픈 가능" or ""))
end
if #_a1919 == 0 then _a1587("  (전부 열려 있음)") end
_a1678("log")
end },
{ label = "지금 1회 실행", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.expand = true _a1613() _a1593.expand = false _a1678("log") end)
end },
})
end
do
local _a1922, _a1923 = _a1711(_a1794, "자동 리버스", nil)
_a1721(_a1923, "rebirth", function()
_a1635("rebirth", function() return _a1591.RebirthInterval end, _a1615, "리버스")
end)
_a1732(_a1922, {
{ label = "주기", value = _a1591.RebirthInterval, onChange = function(_a1924)
local _a1925 = tonumber(_a1924) if _a1925 and _a1925 >= 10 then _a1591.RebirthInterval = _a1925 end
end },
})
_a1741(_a1922, {
{ label = "리버스 현황 보기", col = _a1636.accent, fn = function()
local _a1926 = _a1614()
_a1587("")
_a1587("──── 리버스 현황 ────")
if not _a1926 then _a1587("  밭 없음") _a1678("log") return end
_a1587(("  현재 리버스   %d회  (최대 %s)"):format(_a1926.regrows, tostring(_a1926.cap)))
_a1587(("  레인          %d / 7 %s"):format(_a1926.lanes, _a1926.lanes >= 7 and "OK" or "부족"))
_a1587(("  코인보스      %d / %d %s"):format(_a1926.kills, _a1926.need,
_a1926.kills >= _a1926.need and "OK" or "부족"))
_a1587("")
_a1587(_a1926.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a1926.reason)))
_a1678("log")
end },
{ label = "지금 1회 리버스", col = _a1636.bad, fn = function()
task.spawn(function() _a1593.rebirth = true _a1615() _a1593.rebirth = false _a1678("log") end)
end },
})
end
local _a1927 = _a1695("main", "메인 게임", 30)
do
local _a1928, _a1929 = _a1711(_a1927, "올 자동", nil)
local _a1930 = _a1637("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a1636.cardHi,
BorderSizePixel = 0, LayoutOrder = _a1706(),
}, _a1928)
_a1644(_a1930, 6)
_a1651(_a1930, 8)
local _a1931 = _a1637("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a1636.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a1930)
task.spawn(function()
while _a1654 and _a1654.Parent do
local _a1932 = _a1623.ctl.now
local _a1933 = _a1593.auto and "🟢" or "⚪"
local _a1934 = _a1932.act or "-"
if _a1932.detail and _a1932.detail ~= "" then _a1934 = _a1934 .. "  " .. _a1932.detail end
_a1931.Text = table.concat({
_a1933 .. " " .. (_a1593.auto and (_a1932.step or "-") or "정지"),
"▸ " .. _a1934,
"목표 " .. (_a1932.goal or "-") .. (_a1932.prog ~= "" and ("   " .. _a1932.prog) or ""),
"1.리버스 " .. (_a1623.auto.rebNote or "-"),
"2.존해금 " .. (_a1623.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a1623.auto.farmZone or "-") .. "   현재 " .. tostring(_a1623.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a1623.auto.start()
for _a1935, _a1936 in ipairs(_a1623.auto.STEPS) do _a1593[_a1936.run] = false end
for _a1937, _a1938 in ipairs(_a1623.auto.SIDE) do _a1593[_a1938.run] = false end
_a1593.petspd = true
_a1593.rewatch = true
_a1718()
_a1635("auto", function() return _a1591.AutoInterval end, _a1623.auto.master, "자동")
end
_a1721(_a1929, "auto", _a1623.auto.start)
_a1732(_a1928, {
{ label = "주기", value = _a1591.AutoInterval, onChange = function(_a1939)
local _a1940 = tonumber(_a1939) if _a1940 and _a1940 >= 1 then _a1591.AutoInterval = _a1940 end
end },
{ label = "정체 판정(초)", value = _a1591.PursueStallSec, onChange = function(_a1941)
local _a1942 = tonumber(_a1941) if _a1942 and _a1942 >= 10 then _a1591.PursueStallSec = _a1942 end
end },
})
_a1732(_a1928, {
{ label = "운 퀘 최소 알 개수", value = _a1591.HatchMinAfford, onChange = function(_a1943)
local _a1944 = tonumber(_a1943) if _a1944 and _a1944 >= 1 then _a1591.HatchMinAfford = math.floor(_a1944) end
end },
{ label = "더 버는 시간(초)", value = _a1591.MoneyDwell, onChange = function(_a1945)
local _a1946 = tonumber(_a1945) if _a1946 and _a1946 >= 0 then _a1591.MoneyDwell = _a1946 end
end },
})
_a1732(_a1928, {
{ label = "부화 한 번에(초)", value = _a1591.HatchBudget, onChange = function(_a1947)
local _a1948 = tonumber(_a1947) if _a1948 and _a1948 >= 3 then _a1591.HatchBudget = _a1948 end
end },
})
_a1732(_a1928, {
{ label = "이동 방식", value = _a1591.TpMode, onChange = function(_a1949)
_a1949 = tostring(_a1949 or ""):lower()
if _a1949 == "instant" or _a1949 == "glide" or _a1949 == "walk" then _a1591.TpMode = _a1949 end
end },
{ label = "glide 속도", value = _a1591.TpSpeed, onChange = function(_a1950)
local _a1951 = tonumber(_a1950) if _a1951 and _a1951 >= 16 then _a1591.TpSpeed = _a1951 end
end },
})
_a1751(_a1928, "차단 화면에 실제 클릭까지 시도",
function() return _a1591.ScreenRealClick end,
function(_a1952) _a1591.ScreenRealClick = _a1952 end)
_a1751(_a1928, "퀘스트 없을 때도 알 까기",
function() return _a1591.IdleHatch end,
function(_a1953) _a1591.IdleHatch = _a1953 end)
_a1751(_a1928, "존 해금·리버스는 퀘스트 끝나고",
function() return _a1591.HoldZoneForQuest end,
function(_a1954) _a1591.HoldZoneForQuest = _a1954 end)
for _a1955, _a1956 in ipairs(_a1623.auto.STEPS) do
local _a1957 = _a1956.key
_a1751(_a1928, "  " .. _a1955 .. ". " .. _a1956.label,
function() return _a1591.StepOn[_a1957] end,
function(_a1958) _a1591.StepOn[_a1957] = _a1958 end)
end
for _a1959, _a1960 in ipairs(_a1623.auto.SIDE) do
local _a1961 = _a1960.key
_a1751(_a1928, "  · " .. _a1960.label .. " (순위 밖)",
function() return _a1591.StepOn[_a1961] end,
function(_a1962) _a1591.StepOn[_a1961] = _a1962 end)
end
_a1741(_a1928, {
{ label = "지금 상태", col = _a1636.accent, fn = function()
_a1587("")
_a1587("──── 올 자동 ────")
_a1587("  " .. (_a1593.auto and "돌아가는 중" or "정지") ..
(_a1623.auto.step and ("   지금: " .. _a1623.auto.step) or ""))
local _a1963, _a1964 = _a1623.quest.bestDepActive()
_a1587("  현재 존 " .. tostring(_a1623.move.curZone()) .. " / 최고 존 " .. tostring(_a1623.move.bestZone()))
if _a1963 then
_a1587("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a1964 and _a1964.title))
else
_a1587("  존해금·리버스 진행 가능")
end
_a1587("")
_a1587("  먼저 (순위 밖):")
for _a1965, _a1966 in ipairs(_a1623.auto.SIDE) do
_a1587(("      %-16s %s"):format(_a1966.label, _a1591.StepOn[_a1966.key] and "ON" or "off"))
end
_a1587("  우선순위:")
for _a1967, _a1968 in ipairs(_a1623.auto.STEPS) do
_a1587(("    %d. %-16s %s%s"):format(_a1967, _a1968.label,
_a1591.StepOn[_a1968.key] and "ON" or "off",
_a1968.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a1587("")
_a1587("  세이브")
local _a1969 = _a1589.Save
_a1587("    Library.Client.Save : " .. (_a1969 and "로드됨" or "★ 없음"))
if _a1969 then
local _a1970, _a1971 = pcall(_a1969.Get)
_a1587("    Get()        : " .. (_a1970 and type(_a1971) or ("에러 " .. tostring(_a1971))))
local _a1972, _a1973 = pcall(_a1969.Get, _a1585)
_a1587("    Get(LP)      : " .. (_a1972 and type(_a1973) or ("에러 " .. tostring(_a1973))))
if rawget(_a1969, "GetSaves") then
local _a1974, _a1975 = pcall(_a1969.GetSaves)
if _a1974 and type(_a1975) == "table" then
local _a1976 = 0
for _a1977 in pairs(_a1975) do
_a1976 += 1
if _a1976 <= 3 then _a1587("      키: " .. tostring(_a1977)
.. (_a1977 == _a1585 and "   ← 내 LocalPlayer" or "")) end
end
_a1587("    GetSaves()   : " .. _a1976 .. "개")
else
_a1587("    GetSaves()   : 에러 " .. tostring(_a1975))
end
end
local _a1978 = _a1624()
if _a1978 then
local _a1979 = rawget(_a1978, "Goals")
_a1587("    → 읽기 성공. Rebirths " .. tostring(rawget(_a1978, "Rebirths"))
.. " / Goals " .. (type(_a1979) == "table" and #_a1979 or "없음"))
else
_a1587("    → ★ 어떤 방법으로도 못 읽음")
end
end
_a1587("")
_a1587("  마지막 바퀴 (" .. tostring(_a1623.auto.passN or 0) .. "번째)")
if _a1623.auto.lastPassAt then
_a1587(("    %.0f초 전"):format(os.clock() - _a1623.auto.lastPassAt))
else
_a1587("    아직 한 바퀴도 안 돎 — 루프가 안 돌고 있습니다")
end
for _a1980, _a1981 in ipairs(_a1623.auto.lastTrace or {}) do _a1587("    " .. _a1981) end
_a1678("log")
end },
{ label = "화면 넘기기 진단", col = _a1636.warn, fn = function()
task.spawn(function()
_a1587("")
_a1587("──── 보상 화면 ────")
local _a1982 = _a1622.Vars
_a1587("  Library.Variables : " .. (_a1982 and "로드됨" or "없음"))
if _a1982 then
_a1587("    IsRebirthing = " .. tostring(rawget(_a1982, "IsRebirthing")))
_a1587("    IsRankingUp  = " .. tostring(rawget(_a1982, "IsRankingUp")))
_a1587("    OpeningEgg   = " .. tostring(rawget(_a1982, "OpeningEgg")))
end
_a1587("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a1587("  getgc          : " .. tostring(type(getgc) == "function"))
_a1587("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a1983 = _a1585:FindFirstChildOfClass("PlayerGui")
if _a1983 then
_a1587("  떠 있는 차단 화면:")
local _a1984 = false
for _a1985, _a1986 in ipairs(_a1623.screen.BLOCKERS) do
local _a1987 = _a1983:FindFirstChild(_a1986[1])
_a1587(("    %-14s %s"):format(_a1986[1],
_a1987 and (_a1987.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a1987 and _a1987.Enabled then _a1984 = true end
end
if not _a1984 then _a1587("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a1587("")
_a1587("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a1988, _a1989 = {}, 0
for _a1990, _a1991 in ipairs({ true, false }) do
local _a1992, _a1993 = pcall(getgc, _a1991)
if _a1992 then
for _a1994, _a1995 in ipairs(_a1993) do
if type(_a1995) == "function" and _a1989 < 25 then
local _a1996, _a1997 = pcall(debug.info, _a1995, "s")
if _a1996 and type(_a1997) == "string"
and (_a1997:find("Rebirth", 1, true) or _a1997:find("Rank Up", 1, true)) then
local _a1998, _a1999 = pcall(debug.info, _a1995, "a")
if _a1998 then
local _a2000 = {}
for _a2001 = 1, 16 do
local _a2002, _a2003 = pcall(debug.getupvalue, _a1995, _a2001)
if not _a2002 then break end
_a2000[_a2001] = type(_a2003)
end
local _a2004 = ("인자%d | %s"):format(_a1999 or -1,
#_a2000 > 0 and table.concat(_a2000, ",") or "(없음)")
if not _a1988[_a2004] then
_a1988[_a2004] = true
_a1989 += 1
_a1587("    " .. _a2004)
end
end
end
end
end
end
end
if _a1989 == 0 then _a1587("    (하나도 못 찾음)") end
end
for _a2005, _a2006 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a1623.screen._sig = nil
local _a2007 = _a1623.screen.findSignalFns(_a2006)
_a1587("")
_a1587(("  [%s] 찾은 함수 %d개"):format(_a2006, #_a2007))
for _a2008, _a2009 in ipairs(_a2007) do
_a1587(("    %s%s"):format(_a2009.exact and "★정확일치 " or "", tostring(_a2009.src)))
_a1587(("       upvalue %d개 : %s"):format(_a2009.n or 0, tostring(_a2009.sig)))
end
if #_a2007 == 0 then
_a1587("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a2010, _a2011 = _a1623.screen.signal(_a2006)
_a1587(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a2010), tostring(_a2011)))
local _a2012 = _a1623.screen.SIGNAL[_a2006]
_a1587(("    게임내 입력발동 : %s"):format(
tostring(_a1623.screen.pressInGame(_a2012 and _a2012.pats or {}))))
end
_a1587("")
_a1587("  감시 루프 RUN.rewatch = " .. tostring(_a1593.rewatch))
_a1678("log")
end)
end },
{ label = "한 바퀴만", col = _a1636.cardHi, fn = function()
task.spawn(function()
_a1593.auto = true _a1623.auto.master() _a1593.auto = false _a1678("log")
end)
end },
{ label = "자동 점검", col = _a1636.warn, fn = function()
task.spawn(function()
_a1587("")
_a1587("════ 올 자동 점검 ════")
_a1587("  RUN.auto = " .. tostring(_a1593.auto))
local _a2013 = {}
for _a2014, _a2015 in ipairs(_a1623.auto.SIDE) do
_a2013[#_a2013 + 1] = _a2015.key .. "=" .. tostring(_a1591.StepOn[_a2015.key])
end
for _a2016, _a2017 in ipairs(_a1623.auto.STEPS) do
_a2013[#_a2013 + 1] = _a2017.key .. "=" .. tostring(_a1591.StepOn[_a2017.key])
end
_a1587("  단계 ON/OFF : " .. table.concat(_a2013, "  "))
_a1587("  lockGoal    : " .. (_a1623.ctl.lockGoal and tostring(_a1623.ctl.lockGoal.q.title) or "없음"))
local _a2018, _a2019 = _a1623.quest.bestDepActive()
_a1587("  보류중?     : " .. tostring(_a2018) .. (_a2019 and ("  ← " .. tostring(_a2019.title)) or ""))
_a1587("  리모트      : 존 " .. (_a1622.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a1622.R_Reb and "O" or "X"))
_a1587("")
_a1587("  ── 존 해금 판정 ──")
local _a2020 = _a1627()
if not _a2020 then
_a1587("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a2021 = _a1622.Zone and rawget(_a1622.Zone, "GetNextZone")
if _a2021 then
local _a2022, _a2023, _a2024 = pcall(_a1622.Zone.GetNextZone)
_a1587("    GetNextZone → ok=" .. tostring(_a2022)
.. " / " .. tostring(_a2023) .. " / " .. tostring(_a2024))
end
if _a1622.Zone and rawget(_a1622.Zone, "HasCompletedNextZoneQuests") then
local _a2025, _a2026 = pcall(_a1622.Zone.HasCompletedNextZoneQuests)
_a1587("    존 퀘스트 완료? " .. (_a2025 and tostring(_a2026) or ("에러 " .. tostring(_a2026))))
end
else
_a1587("    다음 존 : " .. tostring(_a2020.id))
_a1587(("    가격 %s %s / 보유 %s → %s"):format(
_a1588(_a2020.price or 0, 0), tostring(_a2020.currency), _a1588(_a2020.have, 0),
_a2020.ok and "지금 살 수 있음" or "부족"))
end
_a1587("")
_a1587("  ── 리버스 판정 ──")
local _a2027 = _a1632()
if not _a2027 then _a1587("    세이브 못 읽음")
else
_a1587(("    현재 %d → 다음 %d"):format(_a2027.current, _a2027.nextN))
_a1587("    최근 사유 : " .. tostring(_a1623.auto.rebNote or "-"))
end
_a1587("")
_a1587("  ── 직전 바퀴 기록 ──")
if _a1623.auto.lastTrace and #_a1623.auto.lastTrace > 0 then
for _a2028, _a2029 in ipairs(_a1623.auto.lastTrace) do _a1587("    " .. _a2029) end
_a1587(("    (%.0f초 전)"):format(os.clock() - (_a1623.auto.lastPassAt or os.clock())))
else
_a1587("    아직 한 바퀴도 안 돌았음")
end
_a1678("log")
end)
end },
})
local _a2030, _a2031 = _a1711(_a1927, "펫 이동속도", nil)
_a1721(_a2031, "petspd", function()
_a1635("petspd", function() return 0.4 end, _a1623.item.applyPetSpeed, "펫속도")
end)
_a1732(_a2030, {
{ label = "배수", value = _a1591.PetSpeedMult, onChange = function(_a2032)
local _a2033 = tonumber(_a2032) if _a2033 and _a2033 >= 1 then _a1591.PetSpeedMult = _a2033 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a1591.PetSpeedBase, onChange = function(_a2034)
local _a2035 = tonumber(_a2034) if _a2035 and _a2035 > 0 then _a1591.PetSpeedBase = _a2035 end
end },
})
_a1741(_a2030, {
{ label = "지금 적용 / 확인", col = _a1636.accent, fn = function()
local _a2036, _a2037 = _a1623.item.applyPetSpeed()
_a1587("")
_a1587("──── 펫 이동속도 ────")
_a1587("  PlayerPet 모듈 : " .. (_a1622.PlayerPet and "로드됨" or "없음"))
_a1587(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a2036, tostring(_a1591.PetSpeedMult), tostring(_a1591.PetSpeedBase)))
if _a2037 then _a1587("  " .. tostring(_a2037)) end
if _a2036 == 0 then _a1587("  펫을 장착하고 다시 눌러보세요") end
_a1678("log")
end },
})
_a1635("petspd", function() return 0.4 end, _a1623.item.applyPetSpeed, "펫속도")
_a1635("rewatch", function() return 1 end, function()
_a1623.screen.watchTick = (_a1623.screen.watchTick or 0) + 1
_a1623.egg.watchStuck()
if _a1623.screen.dismissBusy then return end
local _a2038, _a2039 = _a1623.screen.rewardScreenUp()
if _a2038 and _a1623.screen.screenGaveUp and (os.clock() - _a1623.screen.screenGaveUp) < 30 then
return
end
if _a2038 then
if _a1623.screen.lastBlocker ~= _a2039 then
_a1623.screen.lastBlocker = _a2039
_a1587("[화면] " .. tostring(_a2039) .. " 화면 감지 — 넘기는 중")
end
_a1623.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a2040, _a2041 = _a1711(_a1927, "자동 파밍 유지", nil)
_a1721(_a2041, "farm", function()
_a1635("farm", function() return _a1591.FarmInterval end, _a1626, "파밍")
end)
_a1732(_a2040, {
{ label = "주기", value = _a1591.FarmInterval, onChange = function(_a2042)
local _a2043 = tonumber(_a2042) if _a2043 and _a2043 >= 3 then _a1591.FarmInterval = _a2043 end
end },
})
local _a2044, _a2045 = _a1711(_a1927, "자동 존 해금", nil)
_a1721(_a2045, "zone", function()
_a1635("zone", function() return _a1591.ZoneInterval end, _a1628, "존")
end)
_a1732(_a2044, {
{ label = "주기", value = _a1591.ZoneInterval, onChange = function(_a2046)
local _a2047 = tonumber(_a2046) if _a2047 and _a2047 >= 3 then _a1591.ZoneInterval = _a2047 end
end },
})
_a1741(_a2044, {
{ label = "다음 존 보기", col = _a1636.accent, fn = function()
local _a2048 = _a1627()
_a1587("")
if not _a2048 then _a1587("[존] 다음 존 없음 (최대 도달?)")
else
_a1587("──── 다음 존 ────")
_a1587("  " .. tostring(_a2048.id))
_a1587("  가격 " .. _a1588(_a2048.price or 0, 0) .. " " .. tostring(_a2048.currency))
_a1587("  보유 " .. _a1588(_a2048.have, 0))
_a1587("  " .. (_a2048.ok and "지금 해금 가능" or "부족"))
end
_a1678("log")
end },
{ label = "지금 1회", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.zone = true _a1628() _a1593.zone = false _a1678("log") end)
end },
})
local _a2049, _a2050 = _a1711(_a1927, "자동 부화", nil)
_a1721(_a2050, "mhatch", function()
_a1635("mhatch", function() return _a1591.MainHatchInterval end, _a1631, "부화")
end)
_a1732(_a2049, {
{ label = "주기", value = _a1591.MainHatchInterval, onChange = function(_a2051)
local _a2052 = tonumber(_a2051) if _a2052 and _a2052 >= 1 then _a1591.MainHatchInterval = _a2052 end
end },
{ label = "한 번에 최대", value = _a1591.MainHatchMax, onChange = function(_a2053)
local _a2054 = tonumber(_a2053) if _a2054 and _a2054 >= 1 then _a1591.MainHatchMax = math.floor(_a2054) end
end },
})
_a1732(_a2049, {
{ label = "예비금", value = _a1591.MainHatchReserve, onChange = function(_a2055)
local _a2056 = tonumber(_a2055) if _a2056 and _a2056 >= 0 then _a1591.MainHatchReserve = _a2056 end
end },
{ label = "알 ID (비우면 자동)", value = _a1591.MainEggId, onChange = function(_a2057)
_a1591.MainEggId = _a2057 or ""
end },
})
_a1732(_a2049, {
{ label = "알 인식 거리", value = _a1591.EggRange, onChange = function(_a2058)
local _a2059 = tonumber(_a2058) if _a2059 and _a2059 >= 5 then _a1591.EggRange = _a2059 end
end },
})
_a1751(_a2049, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a1591.AutoUnlockEgg end,
function(_a2060) _a1591.AutoUnlockEgg = _a2060 end)
_a1751(_a2049, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a1591.UseAutoHatch end,
function(_a2061) _a1591.UseAutoHatch = _a2061 if not _a2061 then _a1623.egg.autoHatchOff() end end)
_a1751(_a2049, "까는 화면 자동으로 넘기기 (신호)",
function() return _a1591.HatchClick end,
function(_a2062) _a1591.HatchClick = _a2062 end)
_a1741(_a2049, {
{ label = "잠긴 알 보기", col = _a1636.accent, fn = function()
local _a2063, _a2064, _a2065 = _a1623.egg.lockedEggs()
_a1587("")
_a1587("──── 알 해금 현황 ────")
_a1587(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a2064, _a2065))
_a1587("  해금 리모트 : " .. (_a1622.R_EggUn and "있음" or "없음"))
if #_a2063 == 0 then
_a1587("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a1587("  아직 안 푼 알 " .. #_a2063 .. "개:")
for _a2066, _a2067 in ipairs(_a2063) do
_a1587(("    #%-3d %s"):format(_a2067.num, _a2067.id))
if _a2066 >= 20 then _a1587("    ...") break end
end
end
_a1678("log")
end },
{ label = "부화 진단", col = _a1636.warn, fn = function()
task.spawn(function()
_a1587("")
_a1587("──── 부화 진단 ────")
local _a2068, _a2069, _a2070, _a2071 = _a1629()
_a1587("  대상 알   : " .. tostring(_a2068))
if not _a2068 then _a1587("  (오픈한 알이 없음)") _a1678("log") return end
local _a2072 = _a2069 and tonumber(rawget(_a2069, "eggNumber"))
_a1587("  알 번호   : " .. tostring(_a2072) .. "   오픈함? " .. tostring(_a1623.egg.eggUnlocked(_a2072)))
_a1587("  거리      : " .. (_a2070 and ("%.0f (사거리 안)"):format(_a2070)
or ((_a2071 and ("%.0f (사거리 %d 밖)"):format(_a2071, _a1591.EggRange)) or "받침대 못 찾음")))
local _a2073 = _a2069 and rawget(_a2069, "currency") or "?"
_a1587("  통화      : " .. tostring(_a2073) .. "   보유 " .. _a1588(_a1625(_a2073), 0))
if type(_a1622.CalcEgg) == "function" then
local _a2074, _a2075 = pcall(_a1622.CalcEgg, _a2069)
_a1587("  CalcEggPricePlayer : " .. (_a2074 and tostring(_a2075) or ("에러 " .. tostring(_a2075))))
end
if type(_a1622.CalcEggB) == "function" then
local _a2076, _a2077 = pcall(_a1622.CalcEggB, _a2069)
_a1587("  CalcEggPrice       : " .. (_a2076 and tostring(_a2077) or ("에러 " .. tostring(_a2077))))
end
if _a1622.Egg then
for _a2078, _a2079 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a1622.Egg, _a2079) then
local _a2080, _a2081 = pcall(_a1622.Egg[_a2079], _a2069)
_a1587(("  %-28s : %s"):format(_a2079, _a2080 and tostring(_a2081) or ("에러 " .. tostring(_a2081))))
end
end
end
_a1587("  OpeningEgg      : " .. tostring(_a1622.Vars and rawget(_a1622.Vars, "OpeningEgg")))
if _a1622.Hatch then
for _a2082, _a2083 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a1622.Hatch, _a2083) then
local _a2084, _a2085 = pcall(_a1622.Hatch[_a2083])
_a1587(("  %-15s : %s"):format(_a2083, _a2084 and tostring(_a2085) or ("에러 " .. tostring(_a2085))))
end
end
if rawget(_a1622.Hatch, "GetEggDirectory") then
local _a2086, _a2087 = pcall(_a1622.Hatch.GetEggDirectory)
_a1587("  세팅된 알       : " .. (_a2086 and _a2087 and tostring(rawget(_a2087, "_id")) or "없음"))
end
end
_a1587("  ▶ SetupEgg 시도")
_a1623.egg._ahEgg = nil
_a1623.egg.autoHatchOn(_a2068, 1)
if _a1622.Hatch and rawget(_a1622.Hatch, "IsHatching") then
local _a2088, _a2089 = pcall(_a1622.Hatch.IsHatching)
_a1587("    IsHatching 이후 : " .. (_a2088 and tostring(_a2089) or ("에러 " .. tostring(_a2089))))
_a1587("    " .. ((_a2088 and _a2089) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a1587("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a1587("")
_a1587("  ▶ 1개로 실제 호출")
local _a2090, _a2091
local _a2092 = pcall(function() _a2090, _a2091 = _a1590.R_EGG:InvokeServer(_a2068, 1) end)
_a1587("    호출성공 : " .. tostring(_a2092))
_a1587("    반환1    : " .. tostring(_a2090))
_a1587("    반환2    : " .. tostring(_a2091))
_a1678("log")
end)
end },
{ label = "지금 전부 해금", col = _a1636.good, fn = function()
task.spawn(function()
_a1587("")
local _a2093, _a2094 = _a1623.egg.unlockEggs(true)
_a1587(_a2093 > 0 and ("[해금] %d개 완료"):format(_a2093)
or ("[해금] 0개" .. (_a2094 and (" — " .. tostring(_a2094)) or "")))
_a1678("log")
end)
end },
})
_a1741(_a2049, {
{ label = "알 현황 보기", col = _a1636.accent, fn = function()
local _a2095 = _a1630()
_a1587("")
if not _a2095 then _a1587("[부화] 알을 못 찾음")
else
_a1587("──── 메인 알 ────")
_a1587("  " .. tostring(_a2095.id))
_a1587("  가격 " .. (_a2095.price and _a1588(_a2095.price, 0) or "?") .. " " .. tostring(_a2095.currency))
_a1587("  보유 " .. _a1588(_a2095.have, 0))
_a1587("  한 번에 " .. _a2095.maxN .. "개까지")
_a1587("  지금 가능 " .. _a2095.canBuy .. "회")
if _a2095.inRange then
_a1587(("  거리 %.0f 스터드 — 부화 가능"):format(_a2095.dist))
else
_a1587(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a1591.EggRange, _a2095.nearest and ("%.0f"):format(_a2095.nearest) or "?"))
_a1587("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a1587("")
_a1587("──── 주변 알 (가까운 순 10개) ────")
local _a2096 = _a1623.egg.eggStands()
for _a2097 = 1, math.min(10, #_a2096) do
local _a2098 = _a2096[_a2097]
_a1587(("  %6.0f  #%-3d %-24s %s"):format(
_a2098.dist, _a2098.num, _a2098.id, _a1623.egg.eggUnlocked(_a2098.num) and "오픈함" or "잠김"))
end
if #_a2096 == 0 then _a1587("  (못 찾음)") end
_a1678("log")
end },
{ label = "지금 1회", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.mhatch = true _a1631() _a1593.mhatch = false _a1678("log") end)
end },
})
local _a2099, _a2100 = _a1711(_a1927, "랭크 퀘스트 자동", nil)
_a1721(_a2100, "quest", function()
_a1635("quest", function() return _a1591.QuestInterval end, _a1623.quest.cycle, "퀘스트")
end)
_a1732(_a2099, {
{ label = "주기", value = _a1591.QuestInterval, onChange = function(_a2101)
local _a2102 = tonumber(_a2101) if _a2102 and _a2102 >= 5 then _a1591.QuestInterval = _a2102 end
end },
{ label = "포션 한 번에", value = _a1591.QuestUseMax, onChange = function(_a2103)
local _a2104 = tonumber(_a2103) if _a2104 and _a2104 >= 1 then _a1591.QuestUseMax = math.floor(_a2104) end
end },
})
_a1751(_a2099, "필요한 자동화 자동 ON",
function() return _a1591.QuestDrive end,
function(_a2105) _a1591.QuestDrive = _a2105 end)
_a1751(_a2099, "포션/인챈트 업글 퀘스트",
function() return _a1591.QuestUpgrade end,
function(_a2106) _a1591.QuestUpgrade = _a2106 end)
_a1751(_a2099, "포션 사용 퀘스트",
function() return _a1591.QuestUsePotion end,
function(_a2107) _a1591.QuestUsePotion = _a2107 end)
_a1741(_a2099, {
{ label = "퀘스트 현황 보기", col = _a1636.accent, fn = function()
local _a2108 = _a1623.quest.status()
_a1587("")
if not _a2108 then _a1587("[퀘스트] 세이브 못 읽음")
else
_a1587("──── 랭크 퀘스트 ────")
_a1587(("  Rank %d   ★%d"):format(_a2108.rank, _a2108.rankStars))
if #_a2108.list == 0 then _a1587("  퀘스트 없음") end
for _a2109, _a2110 in ipairs(_a2108.list) do
local _a2111 = _a2110.how
local _a2112 =
(_a2111 == "farm" and "자동 파밍") or
(_a2111 == "hatch" and "자동 부화") or
(_a2111 == "zone" and "자동 존") or
(_a2111 == "potup" and "포션 업글") or
(_a2111 == "encup" and "인챈트 업글") or
(_a2111 == "potuse" and "포션 사용") or
(_a2111 == "fruituse" and "과일 사용") or
(_a2111 == "flaguse" and "깃발 사용") or
(_a2111 == "gold" and "골드 머신") or
(_a2111 == "rainbow" and "레인보우 머신") or
"수동"
local _a2113 = ""
if _a2110.ignored then
_a2112 = "무시"
_a2113 = "   → " .. _a2110.ignored
elseif _a2110.event then
local _a2114 = _a1623.ev.findEvent(_a2110.event, _a2110.bestOnly)
_a2113 = _a2114 and ("   → %s @%s %d초"):format(_a2114.name, tostring(_a2114.zone), _a2114.left)
or ("   → " .. _a2110.event .. " 대기중")
elseif _a2110.chest then
_a2113 = "   → " .. _a2110.chest
elseif _a2110.where then
_a2113 = "   → " .. _a2110.where
end
_a1587(("  [%d] %s"):format(_a2110.stars, tostring(_a2110.title)))
_a1587(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a2110.progress, _a2110.amount, _a2112, _a2110.type, _a2113))
end
end
_a1678("log")
end },
{ label = "활성 이벤트 보기", col = _a1636.accent, fn = function()
local _a2115 = _a1623.ev.events()
local _a2116 = _a1623.move.bestZone()
_a1587("")
_a1587("──── 지금 떠 있는 랜덤 이벤트 ────")
_a1587("  최고 존 : " .. tostring(_a2116) .. "   현재 존 : " .. tostring(_a1623.move.curZone()))
if #_a2115 == 0 then _a1587("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a2117, _a2118 in ipairs(_a2115) do
_a1587(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a2118.kind, tostring(_a2118.zone), _a2118.left,
_a2118.pos and ("(%.0f, %.0f, %.0f)"):format(_a2118.pos.X, _a2118.pos.Y, _a2118.pos.Z) or "좌표없음",
_a2118.zone == _a2116 and "  ★최고존" or ""))
end
_a1587("")
_a1587("  내 소환 아이템 :")
for _a2119 in pairs(_a1623.ev.SPAWN) do
local _a2120 = _a1623.ev.spawnItems(_a2119)
local _a2121 = 0
for _a2122, _a2123 in ipairs(_a2120) do _a2121 += _a2123.am end
_a1587(("    %-12s %d종 %d개"):format(_a2119, #_a2120, _a2121))
for _a2124, _a2125 in ipairs(_a2120) do
_a1587(("        %d. %-24s x%d%s"):format(
_a2124, _a2125.id, _a2125.am, _a2124 == 1 and "   ← 먼저 씀" or ""))
if _a2124 >= 6 then break end
end
end
_a1587("  점선 네모 안? " .. tostring(_a1623.move.inDottedBox()))
for _a2126, _a2127 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a2128, _a2129 = _a1623.ev.findChest(_a2127)
_a1587(("  %-20s %s"):format(_a2127,
_a2128 and ("가장 가까운 것 %.0f스터드"):format(_a2129 or 0) or "없음"))
end
_a1678("log")
end },
{ label = "포션 재고 보기", col = _a1636.accent, fn = function()
_a1587("")
_a1587("──── 포션 / 인챈트 재고 ────")
for _a2130, _a2131 in ipairs({ "Potion", "Enchant" }) do
local _a2132 = _a1623.item.stacks(_a2131)
table.sort(_a2132, function(_a2133, _a2134)
if _a2133.id ~= _a2134.id then return _a2133.id < _a2134.id end
return _a2133.tier < _a2134.tier
end)
_a1587("")
_a1587(_a2131 .. "  (" .. #_a2132 .. "종)")
for _a2135, _a2136 in ipairs(_a2132) do
local _a2137 = _a1623.item.perTier(_a2131, _a2136.tier)
local _a2138 = _a2137 and math.floor(_a2136.am / _a2137) or 0
_a1587(("   %-20s T%-2d x%-6d %s"):format(
_a2136.id, _a2136.tier, _a2136.am,
_a2138 > 0 and ("→ T" .. (_a2136.tier + 1) .. " " .. _a2138 .. "개 제작가능") or ""))
if _a2135 >= 40 then _a1587("   ...") break end
end
if #_a2132 == 0 then _a1587("   (없음)") end
end
_a1678("log")
end },
{ label = "지금 1회", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.quest = true _a1623.quest.cycle() _a1593.quest = false _a1678("log") end)
end },
})
local _a2139, _a2140 = _a1711(_a1927, "슬롯 머신 자동 (다이아)", nil)
_a1721(_a2140, "slots", function()
_a1635("slots", function() return _a1591.SlotInterval end, _a1623.mach.cycleSlots, "슬롯")
end)
_a1732(_a2139, {
{ label = "주기", value = _a1591.SlotInterval, onChange = function(_a2141)
local _a2142 = tonumber(_a2141) if _a2142 and _a2142 >= 5 then _a1591.SlotInterval = _a2142 end
end },
{ label = "남길 다이아", value = _a1591.SlotReserve, onChange = function(_a2143)
local _a2144 = tonumber(_a2143) if _a2144 and _a2144 >= 0 then _a1591.SlotReserve = _a2144 end
end },
})
_a1751(_a2139, "펫 장착 슬롯 (Pet Equip)",
function() return _a1591.SlotPet end, function(_a2145) _a1591.SlotPet = _a2145 end)
_a1751(_a2139, "알 부화 슬롯 (Egg Machine)",
function() return _a1591.SlotEgg end, function(_a2146) _a1591.SlotEgg = _a2146 end)
_a1741(_a2139, {
{ label = "슬롯 현황 보기", col = _a1636.accent, fn = function()
local _a2147 = _a1623.mach.slotStatus()
_a1587("")
_a1587("──── 슬롯 머신 ────")
if not _a2147 then _a1587("  세이브 못 읽음") _a1678("log") return end
_a1587("  다이아 " .. _a1588(_a2147.dia, 0))
_a1587("")
_a1587(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a2147.petOwned, _a2147.petMax, tostring(_a2147.maxEquip)))
if _a2147.petNext then
_a1587(("     다음 #%d  %s 다이아  %s"):format(
_a2147.petNext, _a2147.petCost and _a1588(_a2147.petCost, 0) or "?",
(_a2147.petCost and _a2147.petCost <= _a2147.dia - _a1591.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1587("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a1587("")
_a1587(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a2147.eggOwned, _a2147.eggMax, tostring(_a2147.maxHatch)))
if _a2147.eggEnd then
_a1587(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a2147.eggSize, _a2147.eggEnd, _a2147.eggCost and _a1588(_a2147.eggCost, 0) or "?",
(_a2147.eggCost and _a2147.eggCost <= _a2147.dia - _a1591.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1587("     랭크 상한까지 다 삼")
end
_a1587("")
_a1587("  리모트 : 펫 " .. (_a1622.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a1622.R_EggSlot and "O" or "X"))
_a1678("log")
end },
{ label = "지금 1회", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.slots = true _a1623.mach.cycleSlots() _a1593.slots = false _a1678("log") end)
end },
})
local _a2148, _a2149 = _a1711(_a1927, "아이템 자동 사용 (버프 유지)", nil)
_a1721(_a2149, "items", function()
_a1635("items", function() return _a1591.ItemInterval end, _a1623.item.cycleItems, "아이템")
end)
_a1732(_a2148, {
{ label = "주기", value = _a1591.ItemInterval, onChange = function(_a2150)
local _a2151 = tonumber(_a2150) if _a2151 and _a2151 >= 5 then _a1591.ItemInterval = _a2151 end
end },
{ label = "포션 한 바퀴 최대", value = _a1591.BuffMaxPotion, onChange = function(_a2152)
local _a2153 = tonumber(_a2152) if _a2153 and _a2153 >= 1 then _a1591.BuffMaxPotion = math.floor(_a2153) end
end },
})
_a1732(_a2148, {
{ label = "남길 개수", value = _a1591.ItemKeep, onChange = function(_a2154)
local _a2155 = tonumber(_a2154) if _a2155 and _a2155 >= 0 then _a1591.ItemKeep = math.floor(_a2155) end
end },
{ label = "과일/소모품 최대", value = _a1591.BuffMaxOther, onChange = function(_a2156)
local _a2157 = tonumber(_a2156) if _a2157 and _a2157 >= 1 then _a1591.BuffMaxOther = math.floor(_a2157) end
end },
})
_a1732(_a2148, {
{ label = "쓸 것 (비우면 전부)", value = _a1591.ItemAllow, onChange = function(_a2158)
_a1591.ItemAllow = _a2158 or ""
end },
{ label = "제외", value = _a1591.ItemBlock, onChange = function(_a2159)
_a1591.ItemBlock = _a2159 or ""
end },
})
_a1751(_a2148, "포션", function() return _a1591.BuffPotion end,
function(_a2160) _a1591.BuffPotion = _a2160 end)
_a1751(_a2148, "과일", function() return _a1591.BuffFruit end,
function(_a2161) _a1591.BuffFruit = _a2161 end)
_a1751(_a2148, "얼티밋 (충전되면 발동, 무료)", function() return _a1591.BuffUltimate end,
function(_a2162) _a1591.BuffUltimate = _a2162 end)
_a1751(_a2148, "소모품 (Rain/Sunlight 주의)", function() return _a1591.BuffConsumable end,
function(_a2163) _a1591.BuffConsumable = _a2163 end)
_a1751(_a2148, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a1591.BuffHighTier end,
function(_a2164) _a1591.BuffHighTier = _a2164 end)
_a1751(_a2148, "최고 존에서만 사용", function() return _a1591.ItemBestZone end,
function(_a2165) _a1591.ItemBestZone = _a2165 end)
_a1751(_a2148, "최고 존이 아니면 이동 후 사용", function() return _a1591.ItemTp end,
function(_a2166) _a1591.ItemTp = _a2166 end)
_a1741(_a2148, {
{ label = "버프 현황 보기", col = _a1636.accent, fn = function()
_a1587("")
_a1587("──── 버프 / 아이템 ────")
_a1587(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a1623.move.curZone()), tostring(_a1623.move.bestZone()),
_a1591.ItemBestZone and (_a1623.move.curZone() == _a1623.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a2167, _a2168 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a2169 = _a1623.item.activeBuffs(_a2167)
local _a2170 = {}
for _a2171 in pairs(_a2169) do _a2170[#_a2170 + 1] = _a2171 end
table.sort(_a2170)
_a1587(("  지금 걸린 %s : %s"):format(_a2167,
#_a2170 > 0 and table.concat(_a2170, ", ") or "없음"))
end
local _a2172 = _a1624()
local _a2173 = _a2172 and rawget(_a2172, "Ultimates")
if type(_a2173) == "table" then
local _a2174 = {}
for _a2175 in pairs(_a2173) do
local _a2176 = "?"
if _a1622.Ult and rawget(_a1622.Ult, "IsCharged") then
local _a2177, _a2178 = pcall(_a1622.Ult.IsCharged, _a2175)
_a2176 = _a2177 and (_a2178 and "충전됨" or "충전중") or "?"
end
_a2174[#_a2174 + 1] = _a2175 .. "(" .. _a2176 .. ")"
end
_a1587("  얼티밋 : " .. (#_a2174 > 0 and table.concat(_a2174, ", ") or "없음"))
end
_a1587("")
for _a2179, _a2180 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a2181 = _a1623.item.stacks(_a2180)
local _a2182, _a2183 = 0, 0
for _a2184, _a2185 in ipairs(_a2181) do
if _a1623.item.itemAllowed(_a2185.id) then _a2182 += 1 else _a2183 += 1 end
end
_a1587(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a2180, #_a2181, _a2182, _a2183))
for _a2186, _a2187 in ipairs(_a2181) do
_a1587(("      %-20s T%-2d x%-6d %s"):format(
_a2187.id, _a2187.tier, _a2187.am, _a1623.item.itemAllowed(_a2187.id) and "" or "제외됨"))
if _a2186 >= 12 then _a1587("      ...") break end
end
end
_a1587("")
_a1587("  리모트 : 포션 " .. (_a1622.R_PotUse and "O" or "X")
.. " / 과일 " .. (_a1622.R_Fruit and "O" or "X")
.. " / 소모품 " .. (_a1622.R_Cons and "O" or "X")
.. " / 얼티밋 " .. (_a1622.R_Ult and "O" or "X"))
_a1678("log")
end },
{ label = "지금 1회", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.items = true _a1623.item.cycleItems() _a1593.items = false _a1678("log") end)
end },
})
local _a2188, _a2189 = _a1711(_a1927, "맵 업그레이드 자동 (다이아)", nil)
_a1721(_a2189, "mapupg", function()
_a1635("mapupg", function() return _a1591.UpgInterval end, _a1623.mach.cycleUpg, "맵업글")
end)
_a1732(_a2188, {
{ label = "주기", value = _a1591.UpgInterval, onChange = function(_a2190)
local _a2191 = tonumber(_a2190) if _a2191 and _a2191 >= 5 then _a1591.UpgInterval = _a2191 end
end },
{ label = "남길 다이아", value = _a1591.UpgReserve, onChange = function(_a2192)
local _a2193 = tonumber(_a2192) if _a2193 and _a2193 >= 0 then _a1591.UpgReserve = _a2193 end
end },
})
_a1751(_a2188, "구매 전 그 앞으로 이동",
function() return _a1591.UpgTp end,
function(_a2194) _a1591.UpgTp = _a2194 end)
_a1741(_a2188, {
{ label = "업그레이드 목록", col = _a1636.accent, fn = function()
local _a2195 = _a1623.mach.upgList()
local _a2196 = _a1625("Diamonds")
_a1587("")
_a1587("──── 맵 업그레이드 ────")
_a1587("보유 다이아 " .. _a1588(_a2196, 0))
if #_a2195 == 0 then
_a1587("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a2197, _a2198, _a2199 = 0, 0, 0
for _a2200, _a2201 in ipairs(_a2195) do
if _a2201.bought then _a2198 += 1
elseif not _a2201.zoneOwned then _a2199 += 1
else _a2197 += 1 end
end
_a1587(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a2197, _a2198, _a2199))
_a1587("")
local _a2202 = 0
for _a2203, _a2204 in ipairs(_a2195) do
if _a2204.buyable then
_a2202 += 1
_a1587(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a2204.id, _a2204.tier, _a2204.zone, _a2204.cost and _a1588(_a2204.cost, 0) or "?",
tostring(_a2204.cur),
(_a2204.cost and _a2204.cost <= _a1625(_a2204.cur or "Diamonds") - _a1591.UpgReserve)
and "← 지금 가능" or ""))
if _a2202 >= 25 then _a1587("  ...") break end
end
end
_a1678("log")
end },
{ label = "업글 진단", col = _a1636.warn, fn = function()
task.spawn(function()
_a1587("")
_a1587("──── 맵 업그레이드 진단 ────")
_a1587("  리모트 : " .. (_a1622.R_Upg and _a1622.R_Upg:GetFullName() or "없음"))
local _a2205 = _a1623.mach.upgList()
_a1587("  로드된 기둥 " .. #_a2205 .. "개")
local _a2206
for _a2207, _a2208 in ipairs(_a2205) do
if _a2208.buyable and _a2208.cost then _a2206 = _a2208 break end
end
if not _a2206 then
_a1587("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a2209, _a2210 in ipairs(_a2205) do
_a1587(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a2210.id, _a2210.tier, tostring(_a2210.zone), tostring(_a2210.bought), tostring(_a2210.zoneOwned)))
if _a2209 >= 8 then _a1587("   ...") break end
end
_a1678("log") return
end
local _a2211 = _a1625(_a2206.cur or "Diamonds")
local _a2212 = _a1623.move.hrp()
local _a2213 = (_a2212 and _a2206.pos) and (_a2212.Position - _a2206.pos).Magnitude or nil
_a1587(("  대상 : %s T%d @%s"):format(_a2206.id, _a2206.tier, tostring(_a2206.zone)))
_a1587(("  가격 : %s %s / 보유 %s"):format(
_a1588(_a2206.cost, 0), tostring(_a2206.cur), _a1588(_a2211, 0)))
_a1587("  거리 : " .. (_a2213 and ("%.0f 스터드"):format(_a2213) or "좌표 없음"))
_a1587("")
_a1587("  ▶ 제자리에서 호출")
local _a2214, _a2215
local _a2216 = pcall(function() _a2214, _a2215 = _a1622.R_Upg:InvokeServer(_a2206.id, _a2206.zone) end)
_a1587("    호출성공 " .. tostring(_a2216) .. " / 반환1 " .. tostring(_a2214)
.. " / 반환2 " .. tostring(_a2215))
if not _a2214 and _a2206.pos then
_a1587("")
_a1587("  ▶ 기둥 앞으로 이동해서 재시도")
_a1623.move.glideTo(_a2206.pos)
task.wait(0.3)
local _a2217 = _a1623.move.hrp()
_a1587("    이동후 거리 " .. (_a2217 and ("%.0f"):format((_a2217.Position - _a2206.pos).Magnitude) or "?"))
local _a2218, _a2219
local _a2220 = pcall(function() _a2218, _a2219 = _a1622.R_Upg:InvokeServer(_a2206.id, _a2206.zone) end)
_a1587("    호출성공 " .. tostring(_a2220) .. " / 반환1 " .. tostring(_a2218)
.. " / 반환2 " .. tostring(_a2219))
_a1587("")
_a1587(_a2218 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a1587("")
_a1587(_a2214 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a1678("log")
end)
end },
{ label = "지금 1회", col = _a1636.cardHi, fn = function()
task.spawn(function() _a1593.mapupg = true _a1623.mach.cycleUpg() _a1593.mapupg = false _a1678("log") end)
end },
})
local _a2221, _a2222 = _a1711(_a1927, "자동 리버스", nil)
_a1721(_a2222, "mreb", function()
_a1635("mreb", function() return _a1591.MainRebirthInterval end, _a1633, "리버스")
end)
_a1732(_a2221, {
{ label = "주기", value = _a1591.MainRebirthInterval, onChange = function(_a2223)
local _a2224 = tonumber(_a2223) if _a2224 and _a2224 >= 10 then _a1591.MainRebirthInterval = _a2224 end
end },
})
_a1751(_a2221, "실패 이유 로그",
function() return _a1591.MainRebirthVerbose end,
function(_a2225) _a1591.MainRebirthVerbose = _a2225 end)
_a1741(_a2221, {
{ label = "리버스 현황 보기", col = _a1636.accent, fn = function()
local _a2226 = _a1632()
_a1587("")
if not _a2226 then _a1587("[리버스] 세이브 못 읽음")
else
_a1587("──── 메인 리버스 ────")
_a1587("  현재 " .. _a2226.current .. "회 → 다음 " .. _a2226.nextN)
if type(_a2226.def) == "table" then
for _a2227, _a2228 in pairs(_a2226.def) do
if type(_a2228) ~= "table" and type(_a2228) ~= "function" then
_a1587("    " .. tostring(_a2227) .. " = " .. tostring(_a2228))
end
end
end
end
_a1678("log")
end },
{ label = "지금 1회", col = _a1636.bad, fn = function()
task.spawn(function() _a1593.mreb = true _a1633() _a1593.mreb = false _a1678("log") end)
end },
})
local _a2229 = _a1711(_a1927, "전체 제어", nil)
_a1741(_a2229, {
{ label = "메인 전부 ON", col = _a1636.good, fn = function()
local _a2230 = {
{ "farm",   function() return _a1591.FarmInterval end,       _a1626,       "파밍" },
{ "zone",   function() return _a1591.ZoneInterval end,       _a1628,       "존" },
{ "mhatch", function() return _a1591.MainHatchInterval end,  _a1631,  "부화" },
{ "quest",  function() return _a1591.QuestInterval end,      _a1623.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a1591.UpgInterval end,        _a1623.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a1591.ItemInterval end,       _a1623.item.cycleItems,   "아이템" },
{ "slots",  function() return _a1591.SlotInterval end,       _a1623.mach.cycleSlots,   "슬롯" },
}
for _a2231, _a2232 in ipairs(_a2230) do
if not _a1593[_a2232[1]] then
_a1593[_a2232[1]] = true
_a1635(_a2232[1], _a2232[2], _a2232[3], _a2232[4])
end
end
_a1718()
_a1587("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a1636.bad, fn = function()
_a1623.ctl.stopAll()
_a1718()
_a1587("[메인] 정지")
end },
})
end
_a1669.MouseButton1Click:Connect(function()
local _a2233 = table.concat(_a1586, "\n")
if #_a2233 > 900000 then _a2233 = _a2233:sub(#_a2233 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a2233)
_a1669.Text = "완료"
task.delay(1.5, function() if _a1669 then _a1669.Text = "복사" end end)
end
end)
_a1668.MouseButton1Click:Connect(function()
table.clear(_a1586)
_a1763.top = nil
_a1582.dirty = true
end)
local function _a2234()
_a1593.place, _a1593.merchant, _a1593.upgrade = false, false, false
_a1593.towerup, _a1593.crop, _a1593.expand, _a1593.rebirth, _a1593.hatch, _a1593.luck = false, false, false, false, false, false
_a1593.farm, _a1593.zone, _a1593.mhatch, _a1593.rank, _a1593.mreb = false, false, false, false, false
if _a1783 then _a1783:Disconnect() end
if _a1654 then _a1654:Destroy() end
_G.__PS99_GARDEN = nil
end
_a1666.MouseButton1Click:Connect(_a2234)
_G.__PS99_GARDEN = _a2234
_a1678("dash")
_a1587("PS99 자동")
if _a1582.lpWait then
_a1587(("[진단] LocalPlayer 가 늦게 잡혔습니다 — %.1f초 대기, 결과 %s")
:format(_a1582.lpWait, _a1582.lpFail and "★ 실패" or "성공"))
end
if _a1582.lpFail then
_a1587("[진단] ★ LocalPlayer 를 못 잡아 이동·부화가 전부 안 됩니다.")
_a1587("        게임이 완전히 로드된 뒤에 다시 실행해 주세요.")
end
if _a1582.libWait then
_a1587(("[진단] 게임 모듈(Library/Network)도 늦게 잡혔습니다 — %.1f초 대기")
:format(_a1582.libWait))
end
if _a1582.libFail then
_a1587("[진단] ★ " .. _a1582.libFail .. " 를 못 찾았습니다 — 게임 로드 후 다시 실행하세요")
end
if _a1593.auto then
if _a1623.auto.start then
_a1587("[자동] 올 자동 켜짐 — 1초 뒤 시작합니다")
task.spawn(function()
task.wait(1)
_a1623.ctl.abort = false
local _a2235, _a2236 = pcall(_a1623.auto.start)
if _a2235 then
_a1587("[자동] 시작됨")
else
_a1593.auto = false
_a1587("[자동] 시작 실패: " .. tostring(_a2236))
if _a1623.auto.refresh then pcall(_a1623.auto.refresh) end
end
end)
else
_a1593.auto = false
_a1587("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a2237, _a2238, _a2239, _a2240 = _a1596()
if _a2237 and _a2239 then
local _a2241 = _a1597(_a2239, _a2240)
_a1594.slots = #_a2241
_a1587("레인 " .. _a2240 .. " / 슬롯 " .. #_a2241)
else
_a1587("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a1594.sun = _a1602()
_a1587("Sunflowers " .. _a1588(_a1594.sun, 0))
end)
end)(_a1)
